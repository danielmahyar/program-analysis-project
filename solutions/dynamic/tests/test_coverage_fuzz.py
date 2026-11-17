"""Controlled executions test exploration without pretending to implement a JVM."""

import random
from dataclasses import replace

import pytest
from coverage_fuzz import FuzzConfig, fuzz
from fuzz_contract import RunResult, Violation
from fuzz_inputs import INT_MAX, INT_MIN, InputSpace, interesting_integers
from hypothesis import given
from hypothesis import strategies as st

import jvm
from jpamb.case import Boolean, Input, Int
from jvm.state import PC


def method(signature="(I)V"):
    return jvm.AbsMethodID.decode(f"example.Test.check:{signature}")


def integers(*values):
    return Input(tuple(Int(v) for v in values))


def result(mid, offsets=(0,), *, outcome="ok", violation=None, steps=None):
    return RunResult(
        "completed",
        frozenset(PC(mid, offset) for offset in offsets),
        len(offsets) if steps is None else steps,
        outcome,
        (violation,) if violation else (),
    )


def leak(mid, offset=2, **kwargs):
    return Violation(
        PC(mid, offset), "publish argument 0", "High", "Low", "High", **kwargs
    )


def test_retained_intermediate_input_enables_later_discovery():
    mid = method()
    space = InputSpace((jvm.Int(),))
    tried = []

    def runner(method_id, inputs, **kwargs):
        value = inputs.values[0].value
        tried.append(value)
        if value >= 2:
            return result(
                mid, (0, 1, 2), outcome="assertion error", violation=leak(mid)
            )
        return result(mid, (0, 1) if value == 1 else (0,))

    campaign = fuzz(
        mid,
        space,
        runner,
        config=FuzzConfig(max_executions=10, seed_limit=1, seed=0),
        mutator=lambda inputs, rand: integers(inputs.values[0].value + 1),
    )
    assert 1 in tried and 2 in tried
    assert integers(1) in campaign.corpus
    assert campaign.findings[0].inputs == integers(2)
    assert campaign.outcomes == {"ok", "assertion error"}
    assert campaign.executions == 10  # A discovery does not stop the campaign.


def test_findings_are_saved_without_new_coverage_and_deduplicated():
    mid = method()

    def runner(method_id, inputs, **kwargs):
        if inputs.values[0].value:
            return result(
                mid, (0, 1, 2), outcome="assertion error", violation=leak(mid)
            )
        return result(mid, (0, 1, 2))

    campaign = fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        runner,
        seeds=[integers(0), integers(1), integers(2)],
        config=FuzzConfig(max_executions=3),
    )
    assert campaign.corpus == (integers(0),)
    assert len(campaign.findings) == 1
    assert campaign.findings[0].inputs == integers(1)
    assert campaign.findings[0].execution == 2


def test_distinct_sites_and_methods_are_not_collapsed():
    mid = method()
    other = jvm.AbsMethodID.decode("example.Other.check:(I)V")
    diagnostics = [leak(mid, 0), leak(mid, 1), leak(other, 0)]

    def runner(method_id, inputs, **kwargs):
        violation = diagnostics[inputs.values[0].value]
        return RunResult(
            "completed",
            frozenset({violation.pc}),
            1,
            "assertion error",
            (violation,),
        )

    campaign = fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        runner,
        seeds=[integers(0), integers(1), integers(2)],
        config=FuzzConfig(max_executions=3),
    )
    assert len(campaign.findings) == len(campaign.coverage) == 3


def test_ordinary_assertion_is_an_outcome_without_a_confidentiality_finding():
    mid = method()
    campaign = fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        lambda *args, **kwargs: result(mid, outcome="assertion error"),
        config=FuzzConfig(max_executions=1),
    )
    assert campaign.outcomes == {"assertion error"}
    assert not campaign.findings


def test_partial_coverage_and_statuses_do_not_claim_termination():
    mid = method()

    def runner(method_id, inputs, **kwargs):
        offset = inputs.values[0].value
        status = "unsupported" if offset == 0 else "step-limit"
        return RunResult(status, frozenset({PC(mid, offset)}), 1, detail=status)

    campaign = fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        runner,
        seeds=[integers(0), integers(1)],
        config=FuzzConfig(max_executions=2),
    )
    assert len(campaign.coverage) == len(campaign.corpus) == 2
    assert campaign.unsupported_runs == campaign.limited_runs == 1
    assert campaign.completed_runs == 0
    assert not campaign.outcomes and not campaign.findings


def test_seed_and_repeat_execution_costs_and_final_step_allowance():
    mid = method()
    supplied_limits = []

    def runner(method_id, inputs, *, step_limit, **kwargs):
        supplied_limits.append(step_limit)
        return RunResult("step-limit", frozenset({PC(mid, 0)}), step_limit)

    campaign = fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        runner,
        seeds=[integers(0)],
        mutator=lambda inputs, rand: inputs,
        config=FuzzConfig(max_executions=20, step_limit=3, max_steps=8),
    )
    assert supplied_limits == [3, 3, 2]
    assert campaign.executions == 3 and campaign.steps == 8
    assert campaign.stop_reason == "steps"
    assert campaign.corpus == (integers(0),)


@pytest.mark.parametrize(
    "config",
    [
        FuzzConfig(max_executions=0),
        FuzzConfig(max_steps=0),
    ],
)
def test_zero_budget_does_not_consume_seeds_or_invoke_runner(config):
    def forbidden(*args, **kwargs):
        raise AssertionError("a zero-budget campaign must not execute")

    def seeds():
        forbidden()
        yield integers(0)

    campaign = fuzz(
        method(), InputSpace((jvm.Int(),)), forbidden, config=config, seeds=seeds()
    )
    assert campaign.executions == campaign.steps == 0
    assert not campaign.corpus


def test_cooperative_deadline_uses_injected_clock():
    mid = method()
    now = [0.0]

    def runner(*args, **kwargs):
        now[0] += 2
        return result(mid)

    campaign = fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        runner,
        config=FuzzConfig(timeout_seconds=1),
        clock=lambda: now[0],
    )
    assert campaign.executions == 1
    assert campaign.stop_reason == "deadline" and campaign.elapsed_seconds == 2


def test_nullary_method_is_executed_once_and_empty_seeds_have_a_fallback():
    mid = method("()V")
    campaign = fuzz(mid, InputSpace(()), lambda *a, **kw: result(mid), seeds=[])
    assert campaign.executions == 1
    assert campaign.corpus == (Input(()),)
    assert campaign.stop_reason == "input-exhausted"


def test_seed_limit_bounds_lazy_generators_and_none_is_not_a_seed():
    mid = method()
    consumed = []

    def seeds():
        for value in range(100):
            consumed.append(value)
            yield integers(value)

    fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        lambda *args, **kwargs: result(mid),
        seeds=seeds(),
        config=FuzzConfig(max_executions=5, seed_limit=2),
    )
    assert consumed == [0, 1]
    with pytest.raises(TypeError, match="immutable"):
        fuzz(mid, InputSpace((jvm.Int(),)), None, seeds=[None])


def test_campaigns_reset_search_state_and_use_reproducible_local_randomness():
    mid = method("(IZ)V")
    space = InputSpace((jvm.Int(), jvm.Boolean()))
    traces = []
    security_settings = object()

    def run_campaign():
        seen = []

        def runner(method_id, inputs, *, security_config, **kwargs):
            assert security_config is security_settings
            seen.append(inputs)
            return result(mid)

        campaign = fuzz(
            mid,
            space,
            runner,
            config=FuzzConfig(max_executions=50, seed=42),
            security_config=security_settings,
        )
        traces.append(seen)
        return campaign

    original_random_state = random.getstate()
    first = run_campaign()
    second = run_campaign()
    assert traces[0] == traces[1]
    assert first.corpus == second.corpus
    assert first.security_config is security_settings
    assert random.getstate() == original_random_state


def test_runner_bugs_propagate_and_step_limit_breaches_are_rejected():
    mid = method()

    def broken(*args, **kwargs):
        raise RuntimeError("interpreter bug")

    with pytest.raises(RuntimeError, match="interpreter bug"):
        fuzz(mid, InputSpace((jvm.Int(),)), broken)
    with pytest.raises(ValueError, match="exceeded"):
        fuzz(
            mid,
            InputSpace((jvm.Int(),)),
            lambda *a, **kw: result(mid, steps=3),
            config=FuzzConfig(step_limit=2),
        )


def test_signature_and_custom_mutation_inputs_are_validated():
    with pytest.raises(ValueError, match="signature"):
        fuzz(method(), InputSpace((jvm.Boolean(),)), None)
    mid = method()
    with pytest.raises(ValueError, match="arity"):
        fuzz(mid, InputSpace((jvm.Int(),)), None, seeds=[integers()])
    with pytest.raises(ValueError, match="invalid value"):
        fuzz(
            mid,
            InputSpace((jvm.Int(),)),
            lambda *a, **kw: result(mid),
            seeds=[integers(0)],
            mutator=lambda *args: integers(INT_MAX + 1),
            config=FuzzConfig(max_executions=2),
        )


def test_dictionary_uses_executable_constants_and_signed_neighbours():
    mid = method()
    executable = jvm.Method(
        mid,
        [
            jvm.Push(offset=0, type=jvm.Int(), value=30),
            jvm.Push(
                offset=1,
                type=jvm.Object(jvm.ClassName("java.lang.String")),
                value="5000",
            ),
            jvm.Incr(offset=2, index=0, amount=7),
        ],
        1,
    )
    dictionary = InputSpace.from_method(executable).dictionary
    assert {29, 30, 31, 6, 7, 8} <= set(dictionary)
    assert 5000 not in dictionary
    assert len(dictionary) == len(set(dictionary))
    assert all(
        INT_MIN <= value <= INT_MAX
        for value in interesting_integers([INT_MIN, INT_MAX])
    )


def test_seed_generation_is_bounded_typed_and_immutable():
    space = InputSpace((jvm.Int(), jvm.Boolean(), jvm.Int()))
    assert space.seeds(1) == (Input((Int(0), Boolean(False), Int(0))),)
    assert len(space.seeds(4)) == 4
    for inputs in space.seeds():
        space.validate(inputs)
        hash(inputs)
    with pytest.raises(ValueError, match="supports only"):
        InputSpace((jvm.Array(jvm.Int()),))
    with pytest.raises(TypeError, match="immutable"):
        space.validate(Input([Int(0), Boolean(False), Int(0)]))
    with pytest.raises(ValueError, match="invalid value"):
        InputSpace((jvm.Boolean(),)).validate(Input((Boolean(1),)))


@given(st.integers(INT_MIN, INT_MAX), st.booleans(), st.integers(0, 2**32))
def test_mutations_preserve_types_bounds_and_original_inputs(value, flag, seed):
    space = InputSpace((jvm.Int(), jvm.Boolean()))
    original = Input((Int(value), Boolean(flag)))
    mutated = space.mutate(original, random.Random(seed))
    space.validate(mutated)
    assert mutated != original
    assert original == Input((Int(value), Boolean(flag)))
    assert mutated == space.mutate(original, random.Random(seed))


@pytest.mark.parametrize(
    "kwargs",
    [
        {"max_executions": -1},
        {"max_executions": True},
        {"step_limit": 0},
        {"max_steps": -1},
        {"seed_limit": 0},
        {"seed": 0.5},
        {"timeout_seconds": 0},
        {"timeout_seconds": float("inf")},
    ],
)
def test_invalid_campaign_budgets_are_rejected(kwargs):
    with pytest.raises(ValueError):
        FuzzConfig(**kwargs)


def test_runner_result_rejects_misleading_claims():
    mid = method()
    valid = result(mid)
    for change in (
        {"outcome": "*"},
        {"status": "unsupported"},
        {"steps": -1},
        {"steps": 0},
        {"status": "mystery"},
        {"violations": (leak(mid),)},
    ):
        with pytest.raises(ValueError):
            replace(valid, **change)
    with pytest.raises(ValueError, match="included in coverage"):
        replace(valid, outcome="assertion error", violations=(leak(mid),))


def test_finding_can_be_replayed_through_the_same_runner_contract():
    mid = method()

    def runner(method_id, inputs, **kwargs):
        return result(mid, (0, 1, 2), outcome="assertion error", violation=leak(mid))

    campaign = fuzz(
        mid, InputSpace((jvm.Int(),)), runner, config=FuzzConfig(max_executions=1)
    )
    finding = campaign.findings[0]
    # Input encoding is JPAMB's existing representation; replay needs no new codec.
    observed = runner(
        campaign.method_id,
        Input.decode(finding.inputs.encode()),
        step_limit=finding.step_limit,
        security_config=campaign.security_config,
    )
    assert observed.violations[0].fingerprint == finding.violation.fingerprint

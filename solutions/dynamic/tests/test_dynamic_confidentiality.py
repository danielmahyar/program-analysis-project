"""Real concrete-runner regressions; no generated Java classes are needed."""

from dataclasses import replace
from types import SimpleNamespace

import dynamic
import pytest
import security_monitor
from coverage_fuzz import FuzzConfig, fuzz
from fuzz_inputs import InputSpace

from jpamb.case import Input, Int
from jpamb.confidentiality import Config, analyze
from jpamb.security import ProductLattice, SecurityLattice
from jvm.state import PC
from tests.test_confidentiality import (
    RETURN,
    VOID,
    branch,
    goto,
    invoke,
    load,
    program,
    push,
    sink,
    store,
)


def execute(ops, values=(1,), *, config=None, step_limit=200, **kwargs):
    bc, mid, policy = program(ops, **kwargs)
    result = dynamic.make_runner(bc, policy)(
        mid,
        Input(tuple(Int(v) for v in values)),
        step_limit=step_limit,
        security_config=config,
    )
    return result, mid


@pytest.mark.parametrize("kind", ["parameter", "configured-local", "increment"])
def test_fixed_writes_are_certified_at_the_failing_instruction(kind):
    if kind == "parameter":
        ops = [load(1), store(0), VOID]
        result, mid = execute(ops, (0, 7), labels=(None, "Oncology"), returns=False)
        offset = 1
    elif kind == "configured-local":
        result, mid = execute(
            [load(0), store(1), VOID],
            returns=False,
            config=Config(local_clearances={1: "Public"}),
        )
        offset = 1
    else:
        result, mid = execute(
            [
                push(),
                store(1),
                load(0),
                branch(5),
                {"opr": "incr", "index": 1, "amount": 1},
                VOID,
            ],
            returns=False,
            config=Config(local_clearances={1: "Public"}),
        )
        offset = 4
    assert result.outcome == "assertion error"
    assert result.violations[0].pc == PC(mid, offset)
    assert result.violations[0].allowed == "Public"
    assert result.violations[0].pc in result.coverage
    assert PC(mid, offset + 1) not in result.coverage


def test_safe_parameter_overwrite_preserves_its_fixed_label():
    result, _ = execute([push(), store(0), load(0), RETURN], clearance="Public")
    assert result.outcome == "assertion error"
    assert result.violations[0].effective == "Oncology"
    assert result.violations[0].pc.offset == 3


@pytest.mark.parametrize(
    "clearance,default,expected",
    [
        (None, None, "assertion error"),
        (None, "Oncology", "ok"),
        ("Public", "HospitalAdmin", "assertion error"),
        ("Oncology", "Public", "ok"),
    ],
)
def test_return_defaults_and_explicit_annotation_precedence(
    clearance, default, expected
):
    result, _ = execute(
        [load(0), RETURN],
        clearance=clearance,
        config=Config(return_clearance=default),
    )
    assert result.outcome == expected


def test_integrity_only_policy_difference_does_not_create_a_confidentiality_finding():
    bc, mid, policy = program([load(0), RETURN], labels=("Public",))
    integrity = SecurityLattice(
        "integ", ("Trusted", "Untrusted"), (("Trusted", "Untrusted"),), "Untrusted"
    )
    product = ProductLattice({**policy.product_lattice.lattices, "integ": integrity})
    declared = replace(
        policy.method(mid),
        param_labels=(product.make_label(conf="Public", integ="Untrusted"),),
        param_constraints=(product.make_label(conf="Public", integ="Untrusted"),),
        return_clearance=product.make_label(conf="Public", integ="Trusted"),
    )
    policy = replace(policy, product_lattice=product, methods={declared.id: declared})
    observed = dynamic.make_runner(bc, policy)(mid, Input((Int(5),)), step_limit=20)
    assert analyze(bc, mid, policy).safe
    assert observed.outcome == "ok" and not observed.violations


@pytest.mark.parametrize("value", [0, 1])
def test_stack_selection_retains_the_leaving_context(value):
    result, _ = execute(
        [
            push(),
            push(1),
            load(0),
            branch(5),
            {"opr": "swap"},
            {"opr": "pop", "words": 1},
            RETURN,
        ],
        (value,),
        clearance="Public",
    )
    assert result.outcome == "assertion error"
    assert result.violations[0].kind == "implicit"


@pytest.mark.parametrize("value", [-1, 1])
def test_early_returns_both_retain_the_secret_context(value):
    result, _ = execute(
        [load(0), branch(4, "le"), push(1), RETURN, push(), RETURN],
        (value,),
        clearance="Public",
    )
    assert result.outcome == "assertion error"
    assert result.violations[0].kind == "implicit"


@pytest.mark.parametrize("value", [0, 1])
def test_public_value_created_after_merge_is_safe(value):
    result, _ = execute(
        [load(0), branch(5), push(1), store(1), goto(5), push(5), invoke(), VOID],
        (value,),
        returns=False,
        extra_methods=[sink()],
    )
    assert result.outcome == "ok" and not result.violations


def test_inferred_local_overwrite_can_clear_its_label():
    result, _ = execute(
        [load(0), store(1), push(), store(1), load(1), invoke(), VOID],
        returns=False,
        extra_methods=[sink()],
    )
    assert result.outcome == "ok" and not result.violations


@pytest.mark.parametrize(
    "destination,expected",
    [
        ("Psych", "assertion error"),
        ("HospitalAdmin", "ok"),
    ],
)
def test_incomparable_compartments_and_join_clearances(destination, expected):
    result, _ = execute(
        [
            load(0),
            load(1),
            {"opr": "binary", "type": "int", "operant": "add"},
            invoke(),
            VOID,
        ],
        (1, 2),
        labels=("Oncology", "Psych"),
        returns=False,
        extra_methods=[sink(label=destination)],
    )
    assert result.outcome == expected


def threshold_program():
    return program(
        [
            push(),
            store(1),
            load(0),
            push(30),
            branch(8, "le", "if"),
            push(1),
            store(1),
            goto(8),
            load(1),
            invoke(),
            VOID,
        ],
        labels=("Psych",),
        returns=False,
        extra_methods=[sink(label="Oncology")],
    )


def test_real_runner_resets_concrete_and_shadow_state_between_inputs():
    bc, mid, policy = threshold_program()
    runner = dynamic.make_runner(bc, policy)
    results = [runner(mid, Input((Int(v),)), step_limit=100) for v in (10, 40, 10)]
    assert [r.outcome for r in results] == ["ok", "assertion error", "ok"]
    assert results[1].violations[0].kind == "implicit"
    assert not results[0].violations and not results[2].violations


def test_real_runner_campaign_finds_and_replays_a_compartment_violation():
    bc, mid, policy = threshold_program()
    runner = dynamic.make_runner(bc, policy)
    campaign = fuzz(
        mid,
        InputSpace.from_method(bc.getmethod(mid)),
        runner,
        config=FuzzConfig(max_executions=100, step_limit=100),
        security_config=Config(),
    )
    assert campaign.outcomes == {"ok", "assertion error"}
    assert len(campaign.findings) == 1
    finding = campaign.findings[0]
    replay = runner(
        mid,
        Input.decode(finding.inputs.encode()),
        step_limit=finding.step_limit,
        security_config=campaign.security_config,
    )
    assert replay.violations[0].fingerprint == finding.violation.fingerprint


def test_same_runner_honours_configuration_changes_and_other_programs_share_no_cache():
    bc, mid, policy = program([load(0), store(1), VOID], returns=False)
    runner = dynamic.make_runner(bc, policy)
    inputs = Input((Int(1),))
    assert runner(mid, inputs, step_limit=10).outcome == "ok"
    assert (
        runner(
            mid,
            inputs,
            step_limit=10,
            security_config=Config(local_clearances={1: "Public"}),
        ).outcome
        == "assertion error"
    )
    assert runner(mid, inputs, step_limit=10).outcome == "ok"
    other, same_id, other_policy = program([load(0), RETURN], clearance="Public")
    assert same_id.extension.name == mid.extension.name
    assert (
        dynamic.make_runner(other, other_policy)(same_id, inputs, step_limit=10).outcome
        == "assertion error"
    )


def test_prepared_control_flow_is_not_reused_after_replacing_a_method_body():
    bc, mid, policy = program(
        [push(), {"opr": "pop", "words": 1}, VOID],
        returns=False,
        extra_methods=[sink()],
    )
    runner = dynamic.make_runner(bc, policy)
    inputs = Input((Int(1),))
    assert runner(mid, inputs, step_limit=30).outcome == "ok"
    replacement, same_id, _ = program(
        [
            push(),
            store(1),
            load(0),
            branch(7),
            push(1),
            store(1),
            goto(7),
            load(1),
            invoke(),
            VOID,
        ],
        returns=False,
        extra_methods=[sink()],
    )
    assert same_id == mid
    bc.methods[mid] = replacement.getmethod(mid)
    assert runner(mid, inputs, step_limit=30).outcome == "assertion error"


def loop_program():
    return program(
        [
            push(3),
            store(0),
            load(0),
            branch(6),
            {"opr": "incr", "index": 0, "amount": -1},
            goto(2),
            VOID,
        ],
        labels=(),
        returns=False,
        max_locals=1,
    )


def test_finite_loop_budget_preserves_partial_coverage_without_inventing_an_outcome():
    bc, mid, policy = loop_program()
    runner = dynamic.make_runner(bc, policy)
    limited = runner(mid, Input(()), step_limit=5)
    assert limited.status == "step-limit" and limited.outcome is None
    assert limited.steps == 5 and limited.coverage
    assert not limited.violations
    assert runner(mid, Input(()), step_limit=100).outcome == "ok"


def test_loop_context_is_retained_and_restored_for_a_later_public_value():
    for tail, expected in (
        ([load(1), invoke(), VOID], "assertion error"),
        ([push(5), invoke(), VOID], "ok"),
    ):
        result, _ = execute(
            [
                push(),
                store(1),
                load(0),
                branch(7),
                {"opr": "incr", "index": 1, "amount": 1},
                {"opr": "incr", "index": 0, "amount": -1},
                goto(2),
                *tail,
            ],
            (3,),
            returns=False,
            extra_methods=[sink()],
        )
        assert result.outcome == expected


@pytest.mark.parametrize(
    "inputs,expected",
    [
        ((0, 1), "ok"),
        ((1, 0), "assertion error"),
        ((1, 1), "assertion error"),
    ],
)
def test_nested_branch_join_depends_on_the_executed_path(inputs, expected):
    result, _ = execute(
        [
            push(),
            store(2),
            load(0),
            branch(10),
            load(1),
            branch(8),
            push(1),
            goto(9),
            push(2),
            store(2),
            load(2),
            invoke(),
            VOID,
        ],
        inputs,
        labels=("Oncology", "Psych"),
        returns=False,
        extra_methods=[sink(label="Oncology")],
    )
    assert result.outcome == expected


@pytest.mark.parametrize("value", [-1, 1])
def test_identical_branch_values_still_obey_the_conservative_label_policy(value):
    result, _ = execute(
        [
            load(0),
            branch(5, "le"),
            push(1),
            store(1),
            goto(7),
            push(1),
            store(1),
            load(1),
            invoke(),
            VOID,
        ],
        (value,),
        returns=False,
        extra_methods=[sink()],
    )
    assert result.outcome == "assertion error"
    assert result.violations[0].kind == "implicit"


def test_dead_branch_is_not_executed_by_the_concrete_runner():
    result, mid = execute(
        [
            push(),
            store(1),
            load(1),
            push(1),
            branch(7, "ne", "if"),
            load(0),
            invoke(),
            VOID,
        ],
        returns=False,
        extra_methods=[sink()],
    )
    assert result.outcome == "ok"
    assert PC(mid, 6) not in result.coverage


def test_dup2_has_consistent_concrete_and_shadow_stack_order():
    result, _ = execute(
        [
            load(0),
            load(1),
            {"opr": "dup", "words": 2},
            {"opr": "pop", "words": 2},
            {"opr": "swap"},
            {"opr": "pop", "words": 1},
            RETURN,
        ],
        (1, 2),
        labels=("Oncology", "Psych"),
        clearance="Psych",
    )
    assert result.outcome == "ok"


def test_ordinary_assertion_is_not_a_confidentiality_finding():
    result, _ = execute(
        [{"opr": "new", "class": "java/lang/AssertionError"}, VOID],
        returns=False,
    )
    assert result.outcome == "assertion error" and not result.violations


@pytest.mark.parametrize(
    "ops",
    [
        [
            push(1),
            {"opr": "newarray", "type": "int", "dim": 1},
            {"opr": "pop", "words": 1},
            VOID,
        ],
        [load(1), {"opr": "pop", "words": 1}, VOID],
    ],
)
def test_unmodelled_heap_and_uninitialized_locals_are_unsupported(ops):
    result, _ = execute(ops, returns=False)
    assert result.status == "unsupported" and result.outcome is None
    assert not result.violations and result.detail


def test_arbitrary_annotated_callee_is_not_assumed_to_be_an_empty_sink():
    result, _ = execute(
        [push(), invoke(), VOID],
        returns=False,
        extra_methods=[sink(body=[push(), store(0), VOID])],
    )
    assert result.status == "unsupported" and "unsummarized" in result.detail


def test_shadow_stack_bug_propagates_instead_of_becoming_public():
    with pytest.raises(security_monitor.ShadowStateError, match="underflow"):
        execute([{"opr": "pop", "words": 1}, VOID], returns=False)


def test_ordinary_methods_keep_numeric_execution_without_a_security_policy():
    bc, mid, _ = program(
        [push(1), load(0), {"opr": "binary", "type": "int", "operant": "div"}, RETURN]
    )
    runner = dynamic.make_runner(bc, None)
    assert runner(mid, Input((Int(1),)), step_limit=10).outcome == "ok"
    zero = runner(mid, Input((Int(0),)), step_limit=10)
    assert zero.outcome == "divide by zero" and not zero.violations


def test_unsupported_method_metadata_and_invalid_returns_never_report_ok():
    bc, mid, policy = program([push(), RETURN])
    declared = replace(policy.method(mid), unsupported_features=("exception handlers",))
    policy = replace(policy, methods={declared.id: declared})
    result = dynamic.make_runner(bc, policy)(mid, Input((Int(1),)), step_limit=10)
    assert result.status == "unsupported" and result.steps == 0
    result, _ = execute([push(), VOID], returns=False)
    assert result.status == "unsupported" and result.outcome is None


def test_fixed_local_override_cannot_relax_parameter_clearance():
    result, _ = execute(
        [load(1), store(0), VOID],
        (0, 1),
        labels=(None, "Oncology"),
        returns=False,
        config=Config(local_clearances={0: "HospitalAdmin"}),
    )
    assert result.outcome == "assertion error"


def test_analysis_summary_keeps_step_limits_out_of_program_outcomes(
    monkeypatch, capsys
):
    bc, mid, policy = loop_program()
    monkeypatch.setattr(dynamic.jpamb, "getmethodid", lambda *a, **kw: mid)
    monkeypatch.setattr(
        dynamic.jpamb,
        "setup",
        lambda: (SimpleNamespace(security_policy=lambda *a, **kw: policy), None),
    )
    monkeypatch.setattr(dynamic.jpamb, "Bytecode", lambda *a, **kw: bc)
    monkeypatch.setenv("JPAMB_DYNAMIC_STEPS", "5")
    dynamic.analyse()
    out, err = capsys.readouterr()
    assert "outcomes {}" in err and "'step-limit': 1" in err
    assert "'*'" not in err
    assert "*;timeout" in out  # A heuristic category, not an observed infinite run.


@pytest.mark.parametrize(
    "clearance,outcome",
    [
        ("Public", "assertion error"),
        ("Oncology", "ok"),
    ],
)
def test_analysis_entrypoint_passes_return_settings_to_the_real_runner(
    monkeypatch, capsys, clearance, outcome
):
    bc, mid, policy = program([load(0), RETURN])
    monkeypatch.setattr(dynamic.jpamb, "getmethodid", lambda *a, **kw: mid)
    monkeypatch.setattr(
        dynamic.jpamb,
        "setup",
        lambda: (SimpleNamespace(security_policy=lambda *a, **kw: policy), None),
    )
    monkeypatch.setattr(dynamic.jpamb, "Bytecode", lambda *a, **kw: bc)
    monkeypatch.setenv("JPAMB_CONF_RETURN_CLEARANCE", clearance)
    monkeypatch.setenv("JPAMB_DYNAMIC_RUNS", "1")
    dynamic.analyse()
    out, err = capsys.readouterr()
    assert f"{outcome};found" in out
    assert f"'{outcome}': 1" in err

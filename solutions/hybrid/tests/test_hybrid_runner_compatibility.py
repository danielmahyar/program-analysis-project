"""Hybrid/shared-monitor integration without compiled JPAMB artifacts."""

from types import SimpleNamespace

import hybrid
import pytest
from coverage_fuzz import FuzzConfig, fuzz
from fuzz_inputs import InputSpace

from jpamb.case import Input, Int
from jpamb.confidentiality import Config
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


def threshold():
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


@pytest.mark.parametrize(
    "body,leaks,early",
    [
        ("return secret;", 1, False),
        ("if (secret > 0) return 1; return 0;", 2, True),
        ("int mode = 0; if (mode == 1) return secret; return 0;", 0, False),
    ],
)
def test_pulled_syntactic_pass_parses_confidentiality_fixtures(body, leaks, early):
    _, mid, policy = program([load(0), RETURN], clearance="Public")
    source = f"class Fake {{ static int main(int secret) {{ {body} }} }}".encode()
    suite = SimpleNamespace(
        sourcefile=lambda *a: SimpleNamespace(read_bytes=lambda: source)
    )
    summary = hybrid.run_syntactic_analysis(suite, policy, mid)
    assert len(summary.leaks) == leaks
    assert summary.has_secret_early_return == early


def test_actual_syntactic_and_concrete_passes_work_together_without_generated_files():
    bc, mid, policy = threshold()
    source = b"""class Fake {
        static void main(int score) {
            int flag = 0;
            if (score > 30) { flag = 1; }
            publish(flag);
        }
        static void publish(int value) {}
    }"""
    suite = SimpleNamespace(
        sourcefile=lambda *a: SimpleNamespace(read_bytes=lambda: source)
    )
    report = hybrid.analyze_hybrid(suite, bc, policy, mid, max_runs=30, max_steps=100)
    assert report.syntactic.leaks and 30 in report.syntactic.constants
    assert report.dynamic_findings
    assert report.predictions["assertion error"] == "confirmed-leak"


@pytest.mark.parametrize("pretaint", [False, True])
def test_hybrid_runner_inherits_fixed_parameter_certification(pretaint):
    bc, mid, policy = program(
        [load(1), store(0), VOID],
        labels=(None, "Oncology"),
        returns=False,
    )
    result = hybrid.make_hybrid_runner(bc, policy, hybrid_branch_taint=pretaint)(
        mid,
        Input((Int(0), Int(1))),
        step_limit=10,
    )
    assert result.outcome == "assertion error"
    assert result.violations[0].target == "local 0"


@pytest.mark.parametrize("pretaint", [False, True])
def test_hybrid_runner_honours_shared_return_and_local_settings(pretaint):
    bc, mid, policy = program([load(0), store(1), load(1), RETURN])
    runner = hybrid.make_hybrid_runner(bc, policy, hybrid_branch_taint=pretaint)
    inputs = Input((Int(2),))
    assert runner(mid, inputs, step_limit=20).outcome == "assertion error"
    assert (
        runner(
            mid,
            inputs,
            step_limit=20,
            security_config=Config(return_clearance="Oncology"),
        ).outcome
        == "ok"
    )
    constrained = runner(
        mid,
        inputs,
        step_limit=20,
        security_config=Config(
            return_clearance="Oncology",
            local_clearances={1: "Public"},
        ),
    )
    assert constrained.outcome == "assertion error"
    assert constrained.violations[0].target == "local 1"


def test_observed_and_hypothetical_branch_results_remain_distinct():
    bc, mid, policy = threshold()
    concrete = hybrid.make_hybrid_runner(bc, policy)
    hypothetical = hybrid.make_hybrid_runner(bc, policy, hybrid_branch_taint=True)
    low = Input((Int(10),))
    assert concrete(mid, low, step_limit=100).outcome == "ok"
    probe = hypothetical(mid, low, step_limit=100)
    assert probe.outcome == "assertion error"
    assert probe.violations[0].kind == "implicit"
    assert concrete(mid, Input((Int(40),)), step_limit=100).outcome == "assertion error"
    assert concrete(mid, low, step_limit=100).outcome == "ok"


def test_hybrid_campaign_uses_the_real_shared_runner():
    bc, mid, policy = threshold()
    campaign = fuzz(
        mid,
        InputSpace.from_method(bc.getmethod(mid)),
        hybrid.make_hybrid_runner(bc, policy),
        config=FuzzConfig(max_executions=100, step_limit=100),
    )
    assert campaign.outcomes == {"ok", "assertion error"}
    assert campaign.findings[0].violation.kind == "implicit"


def test_hybrid_orchestration_separates_hypothetical_from_observed_findings(
    monkeypatch,
):
    bc, mid, policy = threshold()
    monkeypatch.setattr(
        hybrid,
        "run_syntactic_analysis",
        lambda *a: hybrid.SyntacticSummary(
            leaks=["candidate implicit flow"],
            constants=[30],
        ),
    )
    report = hybrid.analyze_hybrid(None, bc, policy, mid, max_runs=1, max_steps=100)
    assert not report.dynamic_findings
    assert report.dynamic_outcomes == {"ok": 1}
    assert report.hybrid_pre_taint_findings
    assert report.execution_statuses == {"completed": 1}


def test_hybrid_budget_exhaustion_does_not_become_an_observed_outcome(monkeypatch):
    bc, mid, policy = program(
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
    monkeypatch.setattr(
        hybrid, "run_syntactic_analysis", lambda *a: hybrid.SyntacticSummary()
    )
    report = hybrid.analyze_hybrid(None, bc, policy, mid, max_runs=1, max_steps=5)
    assert not report.dynamic_outcomes
    assert report.execution_statuses == {"step-limit": 1}
    assert report.predictions["*"] == "timeout"


def test_general_calls_remain_explicitly_outside_the_shared_confidentiality_subset():
    bc, mid, policy = program([push(), invoke("helper"), VOID], returns=False)
    result = hybrid.make_hybrid_runner(bc, policy)(
        mid,
        Input((Int(0),)),
        step_limit=20,
    )
    assert result.status == "unsupported" and not result.violations
    assert "supported sink" in result.detail

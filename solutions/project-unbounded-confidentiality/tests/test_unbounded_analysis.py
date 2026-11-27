"""Exercise the project command on the cases compiled by `uv run jpamb build`."""

import subprocess
import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[3]
ANALYSIS = Path(__file__).resolve().parents[1] / "src" / "unbounded_analysis.py"


def run(*args: str) -> str:
    return subprocess.run(
        [sys.executable, str(ANALYSIS), *args],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
        timeout=30,
    ).stdout


def test_info():
    assert run("info").splitlines()[0] == "project-unbounded-confidentiality"


def test_project_runs_independently_of_static_interpreter(monkeypatch, capsys):
    from jpamb import confidentiality

    monkeypatch.syspath_prepend(str(ANALYSIS.parent))
    import unbounded_analysis

    def fail_if_called(self):
        pytest.fail("The project command used the shared static interpreter")

    monkeypatch.setattr(confidentiality.AbstractInterpreter, "run", fail_if_called)
    monkeypatch.chdir(ROOT)
    monkeypatch.setattr(
        sys, "argv", [str(ANALYSIS), "jpamb.cases.BasicLeaks.explicitDirect:(I)V"]
    )
    unbounded_analysis.analyse()
    assert "assertion error;maybe" in capsys.readouterr().out.splitlines()


@pytest.mark.parametrize(
    ("method", "expected"),
    [
        ("BasicLeaks.explicitDirect:(I)V", "maybe"),
        ("BasicLeaks.implicitIf:(I)V", "maybe"),
        ("BasicLeaks.implicitIfSafe:(I)V", "no"),
        ("BasicLeaks.implicitWhile:(I)V", "maybe"),
        ("BasicLeaks.skippedLoop:(I)V", "no"),
        ("BasicLeaks.leakAfterBackEdge:(II)V", "maybe"),
        ("AdvancedLeaks.computedDeadBranchSafe:(I)V", "no"),
        ("AdvancedLeaks.ternaryDeadBranchSafe:(I)V", "no"),
        ("AdvancedLeaks.doWhileLeak:(I)V", "maybe"),
        ("FuzzingChallenges.stagedMask3:(IIII)V", "maybe"),
        ("FuzzingChallenges.stagedMask4:(IIII)V", "maybe"),
        ("FuzzingChallenges.stagedMask5:(IIII)V", "maybe"),
        ("FuzzingChallenges.stagedMaskSafe:(IIII)V", "no"),
        ("FuzzingChallenges.opaquePair17:(III)V", "maybe"),
        ("FuzzingChallenges.opaquePair29:(III)V", "maybe"),
        ("FuzzingChallenges.opaquePair53:(III)V", "maybe"),
        ("FuzzingChallenges.opaquePairSafe:(III)V", "no"),
        ("InfoFlow.launderedThroughArithmetic:(I)V", "maybe"),
        ("Simple.justReturn:()I", "unknown"),
    ],
)
def test_confidentiality_prediction(method, expected):
    output = run(f"jpamb.cases.{method}")
    predictions = dict(line.split(";") for line in output.splitlines())
    assert predictions["assertion error"] == expected


@pytest.mark.parametrize(
    ("method", "expected_ae", "expected_ok"),
    [
        # Unconditional leaks: every feasible path definitely leaks -> ok cannot happen.
        ("BasicLeaks.explicitDirect:(I)V", "maybe", "no"),
        ("BasicLeaks.explicitReturn:(I)I", "maybe", "no"),
        ("BasicLeaks.implicitIfElse:(I)V", "maybe", "no"),
        ("BasicLeaks.implicitReturn:(I)I", "maybe", "no"),
        ("AdvancedLeaks.ternaryImplicitLeak:(I)V", "maybe", "no"),
        ("Hospital.process:(II)V", "maybe", "no"),
        ("Hospital.publicRiskScore:(I)I", "maybe", "no"),
        ("Hospital.sameValueBothBranches:(I)V", "maybe", "no"),
        # Conditional leaks: a leak-free path to return exists -> ok-maybe.
        ("BasicLeaks.implicitIf:(I)V", "maybe", "ok-maybe"),
        ("BasicLeaks.implicitWhile:(I)V", "maybe", "ok-maybe"),
        ("BasicLeaks.leakAfterBackEdge:(II)V", "maybe", "ok-maybe"),
        ("AdvancedLeaks.doWhileLeak:(I)V", "maybe", "ok-maybe"),
        ("AdvancedLeaks.earlyReturnBeforeSink:(I)V", "maybe", "ok-maybe"),
        ("AdvancedLeaks.continueSkipsSink:(I)V", "maybe", "ok-maybe"),
        ("FuzzingChallenges.stagedMask3:(IIII)V", "maybe", "ok-maybe"),
        ("FuzzingChallenges.opaquePair17:(III)V", "maybe", "ok-maybe"),
        ("Hospital.implicitCompartmentLeak:(I)V", "maybe", "ok-maybe"),
        # Safe methods: no leaks and reachable return -> ok-safe.
        ("BasicLeaks.explicitDirectSafe:(I)V", "no", "ok-safe"),
        ("BasicLeaks.skippedLoop:(I)V", "no", "ok-safe"),
        ("AdvancedLeaks.computedDeadBranchSafe:(I)V", "no", "ok-safe"),
        ("FuzzingChallenges.stagedMaskSafe:(IIII)V", "no", "ok-safe"),
        ("Hospital.deadBranchLeak:(I)V", "no", "ok-safe"),
        # Unsupported class without lattice -> unknown on both.
        ("Simple.justReturn:()I", "unknown", "unknown"),
    ],
)
def test_ok_and_runtime_predictions(method, expected_ae, expected_ok):
    output = run(f"jpamb.cases.{method}")
    predictions = dict(line.split(";") for line in output.splitlines())
    assert predictions["assertion error"] == expected_ae
    assert predictions["ok"] == expected_ok
    if expected_ae != "unknown":
        assert predictions["divide by zero"] == "no"
        assert predictions["null pointer"] == "no"
        assert predictions["out of bounds"] == "no"

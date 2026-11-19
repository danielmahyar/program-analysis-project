"""Tests for the Hybrid Confidentiality Analyzer (Syntactic AST + Dynamic Coverage-Guided Fuzzing).

Run from the repository root:

    uv run --project solutions/hybrid pytest solutions/hybrid/tests
"""

from pathlib import Path
import subprocess
import sys

import pytest

ROOT = Path(__file__).resolve().parents[3]
HYBRID_SCRIPT = ROOT / "solutions" / "hybrid" / "src" / "hybrid.py"

sys.path.insert(0, str(HYBRID_SCRIPT.parent))
import hybrid  # noqa: E402
import jpamb  # noqa: E402
import jvm  # noqa: E402
import tree_sitter  # noqa: E402

if not (ROOT / "target/decompiled").exists():
    pytest.skip("run `uv run jpamb build` first", allow_module_level=True)


def run_cli(methodid: str) -> dict[str, str]:
    out = subprocess.run(
        [sys.executable, str(HYBRID_SCRIPT), methodid],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    return dict(line.split(";") for line in out.splitlines())


def test_info():
    out = subprocess.run(
        [sys.executable, str(HYBRID_SCRIPT), "info"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    lines = out.splitlines()
    assert lines[0] == "hybrid-confidentiality"
    assert "hybrid" in lines[3]


def test_confirmed_direct_leak():
    # Both syntactic and dynamic confirm the confidentiality violation
    preds = run_cli("jpamb.cases.Clearance.flowDownOneLevel:(I)V")
    assert preds["assertion error"] == "confirmed-leak"


def test_confirmed_safe_flow():
    # Both syntactic and 100%-coverage dynamic confirm no leak
    preds = run_cli("jpamb.cases.Clearance.flowUpTwoLevels:(I)V")
    assert preds["assertion error"] == "confirmed-safe"
    assert preds["ok"] == "confirmed-ok"


def test_dead_branch_leak_eliminated_by_hybrid():
    # Both syntactic constant folding and dynamic runtime agree deadBranchLeak has no leak!
    preds_hospital = run_cli("jpamb.cases.Hospital.deadBranchLeak:(I)V")
    assert preds_hospital["assertion error"] == "not-found"
    assert preds_hospital["ok"] == "confirmed-ok"

    preds_infoflow = run_cli("jpamb.cases.InfoFlow.deadBranchLeak:(I)V")
    assert preds_infoflow["assertion error"] == "not-found"
    assert preds_infoflow["ok"] == "confirmed-ok"


def test_ast_constants_seed_dynamic_fuzzer():
    # `Hospital.implicitCompartmentLeak` requires `score > 30`;
    # syntactic extracts `30` from the AST, dynamic fuzzer tests `31` and witnesses the leak!
    preds = run_cli("jpamb.cases.Hospital.implicitCompartmentLeak:(I)V")
    assert preds["assertion error"] == "confirmed-leak"
    assert preds["ok"] == "partial-ok"


def test_postdominator_early_return_in_syntactic_and_dynamic():
    # `InfoFlow.implicitReturn` has `if (secret > 0) return 1; return 0;`
    # Both syntactic (with early-return pc propagation) and dynamic catch it!
    suite, eff = jpamb.setup()
    mid = jpamb.parse_methodid("jpamb.cases.InfoFlow.implicitReturn:(I)I")
    policy = suite.security_policy(mid.classname, eff=eff)
    syn = hybrid.run_syntactic_analysis(suite, policy, mid)
    assert syn.has_secret_early_return
    assert len(syn.leaks) == 2  # Both `return 1` and `return 0` are flagged!


def test_untaken_secret_branch_caught_by_hybrid_pretaint():
    # Even if the fuzzer is given only 1 run with input (10) where `score > 30` is false,
    # the hybrid untaken-branch pre-tainting still catches the implicit flow on `flag`!
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})
    mid = jpamb.parse_methodid("jpamb.cases.Hospital.implicitCompartmentLeak:(I)V")
    policy = suite.security_policy(mid.classname, eff=eff)
    runner = hybrid.make_hybrid_runner(bc, policy, hybrid_branch_taint=True)
    res = runner(mid, jpamb.case.Input((jpamb.case.Int(10),)), step_limit=100)
    assert res.outcome == "assertion error"
    assert len(res.violations) == 1
    assert res.violations[0].kind == "implicit"


def test_advanced_leaks_nested_while_corner_cases():
    # Deeply nested while loops with narrow corner conditions: syntactic catches the leak
    # even when the fuzzer's bounded campaign only partially covers the loop body.
    preds_weird = run_cli("jpamb.cases.AdvancedLeaks.nestedWhileWeirdCaseLeak:(III)V")
    assert preds_weird["assertion error"] in ("confirmed-leak", "syntactic-deep-leak")

    preds_triple = run_cli("jpamb.cases.AdvancedLeaks.tripleNestedWhileCornerLeak:(IIII)V")
    assert preds_triple["assertion error"] in ("confirmed-leak", "syntactic-deep-leak")

    preds_safe = run_cli("jpamb.cases.AdvancedLeaks.nestedWhileSafe:(III)V")
    assert preds_safe["assertion error"] in ("confirmed-safe", "not-found")
    assert preds_safe["ok"] == "confirmed-ok"


def test_advanced_leaks_recursion_cases():
    preds_countdown = run_cli("jpamb.cases.AdvancedLeaks.recursiveCountdownLeak:(I)V")
    assert preds_countdown["assertion error"] == "confirmed-leak"

    preds_explicit = run_cli("jpamb.cases.AdvancedLeaks.recursiveExplicitLeak:(II)V")
    assert preds_explicit["assertion error"] == "confirmed-leak"

    preds_safe = run_cli("jpamb.cases.AdvancedLeaks.recursiveSafe:(II)V")
    assert preds_safe["assertion error"] in ("confirmed-safe", "not-found")
    assert preds_safe["ok"] == "confirmed-ok"


def test_advanced_leaks_early_return_and_dead_branches():
    preds_early_leak = run_cli("jpamb.cases.AdvancedLeaks.earlyReturnBeforeSink:(I)V")
    assert preds_early_leak["assertion error"] == "confirmed-leak"

    preds_early_safe = run_cli("jpamb.cases.AdvancedLeaks.earlyReturnSafe:(I)V")
    assert preds_early_safe["assertion error"] == "confirmed-safe"

    preds_ternary_dead = run_cli("jpamb.cases.AdvancedLeaks.ternaryDeadBranchSafe:(I)V")
    assert preds_ternary_dead["assertion error"] == "not-found"
    assert preds_ternary_dead["ok"] == "confirmed-ok"

    preds_comp_dead = run_cli("jpamb.cases.AdvancedLeaks.computedDeadBranchSafe:(I)V")
    assert preds_comp_dead["assertion error"] == "not-found"
    assert preds_comp_dead["ok"] == "confirmed-ok"

"""Run the analysis on a few security cases, as `jpamb analyse` would.

Run from the repository root (needs `uv run jpamb build` first):

    uv run --project solutions/project-syntactic-confidentiality pytest solutions/project-syntactic-confidentiality/tests
"""

from pathlib import Path
import subprocess
import sys

import pytest

ROOT = Path(__file__).resolve().parents[3]
ANALYSIS = ROOT / "solutions/project-syntactic-confidentiality/src/syntactic_confidentiality.py"

if not (ROOT / "target/decompiled").exists():
    pytest.skip("run `uv run jpamb build` first", allow_module_level=True)


def run(methodid: str) -> dict[str, str]:
    out = subprocess.run(
        [sys.executable, str(ANALYSIS), methodid],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    return dict(line.split(";") for line in out.splitlines())


def test_info():
    out = subprocess.run(
        [sys.executable, str(ANALYSIS), "info"],
        cwd=ROOT, capture_output=True, text=True, check=True,
    ).stdout
    assert out.splitlines()[0] == "project-syntactic-confidentiality"


def test_direct_leak_is_found():
    # Secret parameter passed to a Confidential sink.
    preds = run("jpamb.cases.Clearance.flowDownOneLevel:(I)V")
    assert preds["assertion error"] == "90%"
    assert preds["ok"] == "10%"


def test_flow_up_is_not_a_leak():
    # Restricted parameter passed to a Secret sink.
    preds = run("jpamb.cases.Clearance.flowUpTwoLevels:(I)V")
    assert preds["assertion error"] == "10%"
    assert preds["ok"] == "95%"


def test_dead_branch_leak_pruned_statically():
    # Constant propagation folds `int mode = 0; if (mode == 1)` to False and prunes the dead branch!
    preds_hospital = run("jpamb.cases.Hospital.deadBranchLeak:(I)V")
    assert preds_hospital["assertion error"] == "10%"
    assert preds_hospital["ok"] == "95%"

    preds_infoflow = run("jpamb.cases.InfoFlow.deadBranchLeak:(I)V")
    assert preds_infoflow["assertion error"] == "10%"
    assert preds_infoflow["ok"] == "95%"


# --- the rules on small snippets, with the Hospital policy ---------------------

sys.path.insert(0, str(ANALYSIS.parent))
import jpamb  # noqa: E402
import jvm  # noqa: E402
import syntactic_confidentiality as sc  # noqa: E402
import tree_sitter  # noqa: E402

ONCO, PSYCH = frozenset({"Oncology"}), frozenset({"Psych"})


def analyse(body: str, params: dict[str, frozenset[str]], extra_methods: str = ""):
    suite, eff = jpamb.setup()
    policy = suite.security_policy(jvm.ClassName("jpamb.cases.Hospital"), eff=eff)
    method = next(m for m in policy.case_methods.values() if m.name == "compartmentLeak")
    code = f"class C {{ void m() {{ {body} }} {extra_methods} }}".encode()
    tree = tree_sitter.Parser(sc.JAVA).parse(code)
    analysis = sc.Analysis(policy, method, tree_root=tree.root_node)
    analysis.fixed = dict(params)
    block = tree.root_node.named_children[0].child_by_field_name("body")
    block = block.named_children[0].child_by_field_name("body")
    env = analysis.stmt(block, dict(params), frozenset())
    return env, list(analysis.leaks)


def test_parameter_reassignment_is_certified():
    # Parameters are fixed: `onco = psych` is checked, and onco stays {Oncology}.
    env, leaks = analyse("onco = psych;", {"onco": ONCO, "psych": PSYCH})
    assert env["onco"] == ONCO
    assert len(leaks) == 1
    env, leaks = analyse("onco = 0;", {"onco": ONCO})
    assert env["onco"] == ONCO and leaks == []


def test_unannotated_parameter_is_fixed_public():
    _, leaks = analyse("open = onco;", {"open": frozenset(), "onco": ONCO})
    assert len(leaks) == 1


def test_locals_are_inferred_including_increment():
    env, leaks = analyse(
        "int x = 0; if (onco > 0) { x++; } int y = x + psych;",
        {"onco": ONCO, "psych": PSYCH},
    )
    assert env["x"] == ONCO  # x = x + 1 under pc {Oncology}
    assert env["y"] == ONCO | PSYCH
    assert leaks == []


def test_improvement_1_early_return_propagates_pc():
    # Reaching `publicDashboard(0)` after `if (onco > 0) { return; }` leaks `onco > 0`!
    env, leaks = analyse(
        "if (onco > 0) { return; } publicDashboard(0);",
        {"onco": ONCO},
    )
    assert len(leaks) == 1
    assert "publicDashboard(0)" in leaks[0]


def test_improvement_2_for_do_ternary_switch():
    # 1. for loop
    env, leaks = analyse(
        "int acc = 0; for (int i = 0; i < onco; i++) { acc += 1; } publicDashboard(acc);",
        {"onco": ONCO},
    )
    assert env["acc"] == ONCO
    assert len(leaks) == 1

    # 2. do-while loop
    env, leaks = analyse(
        "int x = 0; do { x += 1; } while (psych > 0); oncologyRecords(x);",
        {"psych": PSYCH},
    )
    assert len(leaks) == 1

    # 3. ternary expression with sink in branch
    env, leaks = analyse(
        "int y = (onco > 0) ? 1 : 0; publicDashboard(y);",
        {"onco": ONCO},
    )
    assert env["y"] == ONCO
    assert len(leaks) == 1

    # 4. switch statement
    env, leaks = analyse(
        "int z = 0; switch (onco) { case 1: z = 10; break; default: z = 20; } publicDashboard(z);",
        {"onco": ONCO},
    )
    assert env["z"] == ONCO
    assert len(leaks) == 1


def test_improvement_3_interprocedural_helper_calls():
    # Calling a non-sink helper method that internally calls a sink
    _, leaks = analyse(
        "helperPublish(onco);",
        {"onco": ONCO},
        extra_methods="static void helperPublish(int v) { publicDashboard(v); }",
    )
    assert len(leaks) == 1
    assert "publicDashboard(v)" in leaks[0]


def test_improvement_4_constant_propagation_prunes_dead_branches():
    _, leaks = analyse(
        "int mode = 0; if (mode == 1) { publicDashboard(onco); }",
        {"onco": ONCO},
    )
    assert leaks == []

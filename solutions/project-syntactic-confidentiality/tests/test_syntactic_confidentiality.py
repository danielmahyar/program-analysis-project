"""Run the analysis on a few security cases, as `jpamb analyse` would.

Run from the repository root (needs `uv run jpamb build` first):

    uv run --project solutions/project-syntactic-confidentiality pytest solutions/project-syntactic-confidentiality/tests
"""

import subprocess
import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[3]
ANALYSIS = (
    ROOT
    / "solutions/project-syntactic-confidentiality/src/syntactic_confidentiality.py"
)

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
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
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
import syntactic_confidentiality as sc
import tree_sitter

import jpamb
import jvm

ONCO, PSYCH = frozenset({"Oncology"}), frozenset({"Psych"})


def analyse(body: str, params: dict[str, frozenset[str]], extra_methods: str = ""):
    suite, eff = jpamb.setup()
    policy = suite.security_policy(jvm.ClassName("jpamb.cases.Hospital"), eff=eff)
    method = next(
        m for m in policy.case_methods.values() if m.name == "compartmentLeak"
    )
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
    _env, leaks = analyse(
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


def test_novel_datatype_strings():
    # 1. String literal has label ∅; concatenation s1 + s2 propagates L(s1) ∪ L(s2) ∪ pc
    env, leaks = analyse(
        'String rev = "Reviewed"; String msg = patientDept + ": " + rev; int n = msg.length(); publicDashboard(n);',
        {"patientDept": ONCO},
    )
    assert env["rev"] == frozenset()
    assert env["msg"] == ONCO
    assert env["n"] == ONCO
    assert len(leaks) == 1
    assert "publicDashboard(n)" in leaks[0]

    # 2. Branching on `if (patientDept.equals("Oncology"))` raises pc to L(patientDept)
    env, leaks = analyse(
        'int out = 0; if (patientDept.equals("Oncology")) { out = 1; } publicDashboard(out);',
        {"patientDept": ONCO},
    )
    assert env["out"] == ONCO
    assert len(leaks) == 1


def test_novel_datatype_arrays_monolithic_and_index_tainting():
    # 1. Report motivating example: `notes[psych] = "Reviewed"` where `notes` is a fixed Public parameter (∅)
    #    and `psych` is {Psych}: L(notes) ∪ L("Reviewed") ∪ L(psych) ∪ pc = {Psych} ⊈ ∅ -> immediate violation!
    env, leaks = analyse(
        'notes[psych] = "Reviewed";',
        {"notes": frozenset(), "psych": PSYCH},
    )
    assert env["notes"] == frozenset()  # fixed parameter keeps its fixed label
    assert len(leaks) == 1
    assert 'notes[psych] = "Reviewed"' in leaks[0]

    # 2. Local array write `arr[i] = x` updates monolithic label L(arr') = L(arr) ∪ L(x) ∪ L(i) ∪ pc
    env, leaks = analyse(
        "int[] arr = new int[4]; arr[psych] = 0; int v = arr[0]; oncologyRecords(v);",
        {"psych": PSYCH},
    )
    assert env["arr"] == PSYCH
    assert env["v"] == PSYCH
    assert len(leaks) == 1  # Psych cannot flow to Oncology sink

    # 3. Array read `x = arr[i]` folds L(arr) ∪ L(i) ∪ pc
    env, leaks = analyse(
        "int[] pubArr = new int[4]; int x = pubArr[onco]; publicDashboard(x);",
        {"onco": ONCO},
    )
    assert env["x"] == ONCO
    assert len(leaks) == 1


def test_basic_and_advanced_leaks_strings_and_arrays():
    # BasicLeaks: Strings
    assert run("jpamb.cases.BasicLeaks.stringEqualsImplicitLeak:(Ljava/lang/String;)V")["assertion error"] == "90%"
    assert run("jpamb.cases.BasicLeaks.stringEqualsSafe:(Ljava/lang/String;)V")["assertion error"] == "10%"

    # BasicLeaks: Arrays (monolithic index tainting)
    assert run("jpamb.cases.BasicLeaks.arrayIndexWriteLeak:(I)V")["assertion error"] == "90%"
    assert run("jpamb.cases.BasicLeaks.arrayIndexWriteSafe:(I)V")["assertion error"] == "10%"

    # AdvancedLeaks: Strings (concatenation + .length() + .equals())
    assert run("jpamb.cases.AdvancedLeaks.stringConcatLengthLeak:(Ljava/lang/String;Ljava/lang/String;)V")["assertion error"] == "90%"
    assert run("jpamb.cases.AdvancedLeaks.stringBranchAndConcatSafe:(Ljava/lang/String;Ljava/lang/String;)V")["assertion error"] == "10%"

    # AdvancedLeaks: Arrays (parameter index tainting & monolithic read/write)
    assert run("jpamb.cases.AdvancedLeaks.arraySecretIndexParameterLeak:([Ljava/lang/String;I)V")["assertion error"] == "90%"
    assert run("jpamb.cases.AdvancedLeaks.arrayMonolithicReadLeak:(II)V")["assertion error"] == "90%"
    assert run("jpamb.cases.AdvancedLeaks.arrayMonolithicSafe:(II)V")["assertion error"] == "10%"



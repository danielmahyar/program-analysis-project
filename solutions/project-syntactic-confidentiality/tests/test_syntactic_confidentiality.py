"""Run the analysis on a few security cases, as `jpamb analyse` would.

Run from the repository root (needs `uv run jpamb build` first):

    uv run --project solutions/project-syntactic-confidentiality pytest solutions/project-syntactic-confidentiality/tests
"""

import subprocess
import sys
from pathlib import Path

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
    assert run("jpamb.cases.Clearance.flowDownOneLevel:(I)V")["assertion error"] == "90%"


def test_flow_up_is_not_a_leak():
    # Restricted parameter passed to a Secret sink.
    assert run("jpamb.cases.Clearance.flowUpTwoLevels:(I)V")["assertion error"] == "50%"


# --- the rules on small snippets, with the Hospital policy ---------------------

sys.path.insert(0, str(ANALYSIS.parent))
import jpamb  # noqa: E402
import jvm  # noqa: E402
import syntactic_confidentiality as sc  # noqa: E402
import tree_sitter  # noqa: E402

ONCO, PSYCH = frozenset({"Oncology"}), frozenset({"Psych"})


def analyse(body: str, params: dict[str, frozenset[str]]):
    suite, eff = jpamb.setup()
    policy = suite.security_policy(jvm.ClassName("jpamb.cases.Hospital"), eff=eff)
    method = next(m for m in policy.case_methods.values() if m.name == "compartmentLeak")
    analysis = sc.Analysis(policy, method)
    analysis.fixed = dict(params)
    tree = tree_sitter.Parser(sc.JAVA).parse(f"class C {{ void m() {{ {body} }} }}".encode())
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

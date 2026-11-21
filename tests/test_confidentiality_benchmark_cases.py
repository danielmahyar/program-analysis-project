"""Keep JVM-verified successful loop outcomes in the benchmark ground truth."""

from pathlib import Path

import dynamic
import pytest

import jpamb


@pytest.mark.parametrize(
    "identifier",
    [
        "jpamb.cases.BasicLeaks.implicitWhile:(I)V",
        "jpamb.cases.AdvancedLeaks.doWhileLeak:(I)V",
    ],
)
def test_successful_loop_boundary_is_declared_and_matches_concrete_execution(
    identifier,
):
    suite, eff = jpamb.setup()
    method = jpamb.parse_methodid(identifier)
    inputs = jpamb.case.Input((jpamb.case.Int(0),))
    cases = [case for case in suite.cases(eff=eff) if case.methodid == method]
    assert any(case.input == inputs and case.result == "ok" for case in cases)
    assert any(case.result == "assertion error" for case in cases)
    if not Path(suite.decompiledfile(method.classname)).exists():
        pytest.skip("run the JPAMB compile/decompile build first")
    policy = suite.security_policy(method.classname, eff=eff)
    runner = dynamic.make_runner(jpamb.Bytecode(suite, eff, {}), policy)
    observed = runner(method, inputs, step_limit=100)
    assert observed.status == "completed" and observed.outcome == "ok"
    assert not observed.violations

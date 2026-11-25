from dataclasses import replace
from pathlib import Path

import pytest
from unbounded_confidentiality.interpreter import Config, analyze

import jpamb


@pytest.mark.parametrize(
    ("annotated", "fallback", "expected"),
    [(False, None, "safe"), (False, "Low", "violation"), (True, "High", "violation")],
)
def test_secret_return_uses_declared_or_configured_clearance(
    annotated, fallback, expected
):
    suite = jpamb.Suite.from_workdir(Path(__file__).resolve().parents[3])
    eff = jpamb.Effect(None)
    method = jpamb.parse_methodid("jpamb.cases.BasicLeaks.explicitReturn:(I)I")
    policy = suite.security_policy(method.classname, eff=eff)
    if not annotated:
        # Keep the same `return secret` bytecode and remove its @Sec("Low") policy.
        declared = policy.method(method)
        policy = replace(
            policy,
            methods=policy.methods
            | {declared.id: replace(declared, return_clearance=None)},
        )

    result = analyze(
        jpamb.Bytecode(suite, eff), method, policy, Config(return_clearance=fallback)
    )
    assert result.status == expected
    assert result.return_label == "High"

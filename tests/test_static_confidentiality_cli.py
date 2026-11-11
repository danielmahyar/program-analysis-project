import importlib.util
import sys
from pathlib import Path
from types import SimpleNamespace

import pytest

import jpamb.interpret
import sexpr
from jpamb.confidentiality import analyze

from .test_confidentiality import RETURN, VOID, branch, goto, load, program, push


@pytest.fixture
def static(monkeypatch):
    folder = Path(__file__).resolve().parents[1] / "solutions/static/src"
    monkeypatch.syspath_prepend(str(folder))
    spec = importlib.util.spec_from_file_location(
        "static_confidentiality_test", folder / "static.py"
    )
    module = importlib.util.module_from_spec(spec)
    monkeypatch.setitem(sys.modules, spec.name, module)
    spec.loader.exec_module(module)
    monkeypatch.delenv("JPAMB_CONF_MAX_STEPS", raising=False)
    monkeypatch.delenv("JPAMB_CONF_RETURN_CLEARANCE", raising=False)
    return module


def entrypoint(static, monkeypatch, ops, *, security=True, **kwargs):
    bc, mid, policy = program(ops, **kwargs)
    suite = SimpleNamespace(
        security_policy=lambda *args, **kwargs: policy if security else None
    )
    monkeypatch.setattr(static.jpamb, "setup", lambda: (suite, None))
    monkeypatch.setattr(static.jpamb, "Bytecode", lambda *args: bc)
    monkeypatch.setattr(static.jpamb, "getmethodid", lambda *args, **kwargs: mid)
    return bc, mid, policy


@pytest.mark.parametrize(
    ("label", "prediction", "status"),
    [
        ("Public", "no", "safe"),
        ("Oncology", "maybe", "violation"),
    ],
)
def test_analysis_entrypoint_routes_security_policy(
    static, monkeypatch, capsys, label, prediction, status
):
    entrypoint(static, monkeypatch, [load(0), RETURN], labels=(label,))
    static.analyse()
    out, err = capsys.readouterr()
    assert f"assertion error;{prediction}" in out
    assert f"confidentiality: {status}" in err
    assert "ok;unknown" in out  # This is not a numeric execution analysis.


def test_configured_limits_and_returns(static, monkeypatch, capsys):
    entrypoint(static, monkeypatch, [load(0), RETURN])
    monkeypatch.setenv("JPAMB_CONF_MAX_STEPS", "1")
    static.analyse()
    out, err = capsys.readouterr()
    assert "assertion error;unknown" in out and "incomplete" in err
    monkeypatch.delenv("JPAMB_CONF_MAX_STEPS")
    monkeypatch.setenv("JPAMB_CONF_RETURN_CLEARANCE", "Oncology")
    static.analyse()
    out, err = capsys.readouterr()
    assert "assertion error;no" in out and "confidentiality: safe" in err


def test_unsupported_instruction_reports_unknown(static, monkeypatch, capsys):
    entrypoint(
        static,
        monkeypatch,
        [push(), {"opr": "newarray", "type": "int", "dim": 1}, VOID],
        returns=False,
    )
    static.analyse()
    out, err = capsys.readouterr()
    assert "assertion error;unknown" in out
    assert "confidentiality: unsupported" in err


def test_bad_configuration_is_unknown(static, monkeypatch, capsys):
    entrypoint(static, monkeypatch, [push(), RETURN])
    monkeypatch.setenv("JPAMB_CONF_MAX_STEPS", "-1")
    static.analyse()
    out, err = capsys.readouterr()
    assert all(line.endswith(";unknown") for line in out.splitlines())
    assert "non-negative" in err


def test_ordinary_method_keeps_numeric_entrypoint(static, monkeypatch, capsys):
    entrypoint(static, monkeypatch, [VOID], security=False, returns=False)
    static.analyse()
    out, err = capsys.readouterr()
    assert "ok;maybe" in out
    assert "confidentiality:" not in err


def test_ordinary_unsupported_and_budget_are_unknown(static, monkeypatch, capsys):
    entrypoint(static, monkeypatch, [push(), RETURN], security=False)
    static.analyse()
    out, _ = capsys.readouterr()
    assert all(line.endswith(";unknown") for line in out.splitlines())
    entrypoint(static, monkeypatch, [goto(0)], security=False, returns=False)
    monkeypatch.setenv("JPAMB_CONF_MAX_STEPS", "0")
    static.analyse()
    out, _ = capsys.readouterr()
    assert all(line.endswith(";unknown") for line in out.splitlines())


def test_trace_edits_remain_valid_after_terminal_events(static, capsys):
    bc, mid, policy = program([load(0), branch(4), push(1), RETURN, push(), RETURN])
    static.interpret_security(bc, mid, policy, 100)
    out, err = capsys.readouterr()
    response, warnings = jpamb.interpret.Response.parse(out)
    assert response is not None and not warnings
    cursor = sexpr.cursor(response.init.state)
    for step in response.steps:
        previous = cursor.value
        sexpr.iapply(cursor, step.edits)
        if isinstance(cursor.value, str):
            cursor.value = previous
    assert "confidentiality: violation" in err


def test_decode_failure_is_explicitly_unsupported(static, monkeypatch, capsys):
    bc, mid, policy = entrypoint(static, monkeypatch, [push(), RETURN])

    def unsupported(methodid):
        raise NotImplementedError("unrecognized tableswitch")

    monkeypatch.setattr(bc, "getmethod", unsupported)
    result = analyze(bc, mid, policy)
    assert result.status == "unsupported"
    static.analyse()
    out, err = capsys.readouterr()
    assert "assertion error;unknown" in out and "tableswitch" in err

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
        ("BasicLeaks.skippedLoop:(I)V", "maybe"),
        ("BasicLeaks.leakAfterBackEdge:(II)V", "maybe"),
        ("Simple.justReturn:()I", "unknown"),
    ],
)
def test_confidentiality_prediction(method, expected):
    output = run(f"jpamb.cases.{method}")
    predictions = dict(line.split(";") for line in output.splitlines())
    assert predictions["assertion error"] == expected

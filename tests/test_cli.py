"""
These test, check that the output of the tests remain the same.
"""

import shutil

import pytest
from click.testing import CliRunner

import cli
import jpamb

analyses = [
    "jpamb-analysis-dummy",
    "basic",
    "syntactic-regex",
    "solution-dynamic-analysis",
]


@pytest.mark.slow
@pytest.mark.parametrize("solution", analyses)
def test_analyse(solution):
    exe = shutil.which(solution)
    if exe is None:
        pytest.skip(f"Could not find {solution} on path")

    runner = CliRunner()
    result = runner.invoke(
        cli.cli,
        [
            "analyse",
            "-f",
            "Simple",
            solution,
        ],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output


@pytest.mark.slow
def test_analyse_report(tmp_path):
    runner = CliRunner()

    solution = "jpamb-analysis-dummy"
    exe = shutil.which(solution)
    if exe is None:
        pytest.skip(f"Could not find {solution} on path")

    result = runner.invoke(
        cli.cli,
        [
            "-vv",
            "analyse",
            "--report",
            (tmp_path / "report.sexp"),
            exe,
        ],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output


@pytest.mark.slow
def test_checkhealth(tmp_path):
    runner = CliRunner()
    result = runner.invoke(
        cli.cli,
        [
            "checkhealth",
        ],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output


interpreters = [
    "solution-dynamic-interpreter",
]


@pytest.mark.slow
@pytest.mark.parametrize("solution", interpreters)
def test_interpret(tmp_path, solution):
    exe = shutil.which(solution)
    if exe is None:
        pytest.skip(f"Could not find {solution} on path")

    runner = CliRunner()
    result = runner.invoke(
        cli.cli,
        [
            "interpret",
            "--report",
            (tmp_path / "report.sexp"),
            solution,
        ],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output


methods = [
    "jpamb.cases.Simple.assertBoolean:(Z)V",
]

formats = ["pretty", "real", "repr", "json"]


@pytest.mark.slow
@pytest.mark.parametrize("method", methods)
@pytest.mark.parametrize("format", formats)
def test_inspect(method, format):
    runner = CliRunner()
    result = runner.invoke(
        cli.cli,
        ["-v", "inspect", "--format", format, method],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output


# The reports in tests/data were made for the cases of JPAMB 0.7.0, so they are
# validated against its benchmark, not against the current (growing) one.
REPORTS_WORKDIR = "tests/data/jpamb-0.7.0"


@pytest.mark.slow
@pytest.mark.parametrize("format", ["autolab", "user"])
def test_validate_analysis(format):
    runner = CliRunner()
    result = runner.invoke(
        cli.cli,
        [
            "--workdir",
            REPORTS_WORKDIR,
            "-v",
            "validate",
            "analyse",
            "--format",
            format,
            "tests/data/analysis-report.sexp",
        ],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output


@pytest.mark.slow
@pytest.mark.parametrize("format", ["autolab", "user"])
def test_validate_interpret(format):
    runner = CliRunner()
    result = runner.invoke(
        cli.cli,
        [
            "--workdir",
            REPORTS_WORKDIR,
            "-v",
            "validate",
            "interpret",
            "--format",
            format,
            "tests/data/interpret-report.sexp",
        ],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output


@pytest.fixture
def build_steps(monkeypatch):
    """Replace the slow steps of `jpamb build` with stubs that record what ran."""
    ran = []
    monkeypatch.setattr(cli.DockerRunner, "create", lambda *args, **kwargs: None)
    monkeypatch.setattr(jpamb.Suite, "build", lambda self, **kw: ran.append("compile"))
    monkeypatch.setattr(
        jpamb.Suite, "document", lambda self, **kw: ran.append("document")
    )
    monkeypatch.setattr(jpamb.Suite, "test", lambda self, **kw: ran.append("test"))
    monkeypatch.setattr(
        jpamb.Suite,
        "run_benchmark",
        lambda self, dynamic=None, **kw: ran.append(("benchmark", dynamic)),
    )
    return ran


@pytest.mark.parametrize(
    ("args", "expected"),
    [
        ([], ["compile", ("benchmark", None), "document", "test"]),
        (["--benchmark"], [("benchmark", None)]),
        (["--benchmark", "jvm"], [("benchmark", None)]),
        (["--compile", "--benchmark"], ["compile", ("benchmark", None)]),
        (["--benchmark", "--compile"], ["compile", ("benchmark", None)]),
        (["--no-benchmark"], ["compile", "document", "test"]),
    ],
)
def test_build_benchmark_on_jvm(build_steps, args, expected):
    result = CliRunner().invoke(cli.cli, ["build", *args], catch_exceptions=False)

    assert result.exit_code == 0, result.output
    assert build_steps == expected


@pytest.mark.slow
def test_build_benchmark_with_interpreter(build_steps):
    exe = shutil.which("jpamb-interpreter-dummy")
    if exe is None:
        pytest.skip("Could not find jpamb-interpreter-dummy on path")

    result = CliRunner().invoke(
        cli.cli,
        ["build", "--benchmark", "jpamb-interpreter-dummy"],
        catch_exceptions=False,
    )

    assert result.exit_code == 0, result.output
    [(step, interpreter)] = build_steps
    assert step == "benchmark"
    assert interpreter.cmd == (exe,)


def test_build_benchmark_with_missing_interpreter(build_steps):
    result = CliRunner().invoke(
        cli.cli,
        ["build", "--benchmark", "jpamb-no-such-interpreter"],
        catch_exceptions=False,
    )

    assert result.exit_code == 1
    assert "did not have jpamb-no-such-interpreter installed" in result.output
    assert build_steps == []


def test_build_benchmark_and_no_benchmark(build_steps):
    result = CliRunner().invoke(cli.cli, ["build", "--benchmark", "--no-benchmark"])

    assert result.exit_code == 2
    assert build_steps == []

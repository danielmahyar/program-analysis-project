"""Persistence, provenance, CLI integration, and finding replay regressions."""

import copy
import json
import subprocess
import sys
from dataclasses import replace
from pathlib import Path
from types import SimpleNamespace

import dynamic
import fuzz_cli
import fuzz_reports as reports
import pytest
from coverage_fuzz import FuzzConfig, fuzz
from fuzz_contract import RunResult
from fuzz_inputs import InputSpace

import jpamb
from jpamb.confidentiality import Config
from jpamb.utils import Effect
from tests.test_confidentiality import (
    RETURN,
    VOID,
    branch,
    goto,
    invoke,
    load,
    program,
    push,
    sink,
    store,
)


@pytest.fixture
def saved(tmp_path, monkeypatch):
    monkeypatch.delenv("JPAMB_FUZZ_REPORT_DIR", raising=False)
    bc, mid, policy = program([load(0), store(1), load(1), RETURN])
    suite = jpamb.Suite.from_workdir(tmp_path.resolve())
    artifact = suite.decompiledfile(mid.classname)
    artifact.parent.mkdir(parents=True)
    artifact.write_text('{"fixture": 1, "note": "fixture"}', encoding="utf-8")
    space = InputSpace.from_method(bc.getmethod(mid))
    settings = Config(
        return_clearance="Oncology", max_steps=99, local_clearances={1: "Public"}
    )
    runner = dynamic.make_runner(bc, policy)
    campaign = fuzz(
        mid,
        space,
        runner,
        config=FuzzConfig(max_executions=3),
        security_config=settings,
    )
    report = reports.create_report(
        campaign,
        suite=suite,
        bytecode=bc,
        input_space=space,
        seed_inputs=space.seeds(),
        generator="typed-mutation-v1",
    )
    path = reports.write_report(report, tmp_path / "campaign.json")
    return SimpleNamespace(
        bc=bc,
        mid=mid,
        policy=policy,
        suite=suite,
        artifact=artifact,
        space=space,
        runner=runner,
        campaign=campaign,
        report=report,
        path=path,
    )


def test_roundtrip_preserves_settings_inputs_locations_and_campaign_evidence(saved):
    loaded = reports.read_report(saved.path)
    assert loaded.method_id == saved.mid
    assert loaded.config == saved.campaign.config
    assert loaded.security_config == saved.campaign.security_config
    assert loaded.findings == saved.campaign.findings
    assert loaded.document["summary"]["statuses"] == {
        "completed": 3,
        "step-limit": 0,
        "unsupported": 0,
    }
    assert loaded.document["generator"]["dictionary"] == list(saved.space.dictionary)
    assert loaded.document["generator"]["seed_inputs"] == [
        v.encode() for v in saved.space.seeds()
    ]
    assert loaded.document["corpus"] == [v.encode() for v in saved.campaign.corpus]
    assert loaded.document["configuration"]["confidentiality"]["local_clearances"] == {
        "1": "Public"
    }
    assert loaded.document["evidence_kind"] == "concrete"
    reports.verify_program(loaded, saved.suite)
    replay = reports.replay_finding(loaded, 1, saved.runner)
    assert replay.matched and replay.observed.violations == (
        loaded.findings[0].violation,
    )


def test_label_changes_are_mismatches_even_when_the_fingerprint_is_unchanged(saved):
    expected = saved.report.findings[0].violation
    changed = replace(expected, effective="Psych")
    assert changed.fingerprint == expected.fingerprint
    runner = lambda *args, **kwargs: RunResult(
        "completed",
        frozenset({changed.pc}),
        1,
        "assertion error",
        (changed,),
    )
    assert not reports.replay_finding(saved.report, 1, runner).matched


@pytest.mark.parametrize("status", ["step-limit", "unsupported"])
def test_incomplete_replay_is_not_a_reproduced_violation(saved, status):
    runner = lambda *args, **kwargs: RunResult(status, frozenset(), 0, detail=status)
    replay = reports.replay_finding(saved.report, 1, runner)
    assert not replay.matched and replay.observed.outcome is None


@pytest.mark.parametrize(
    "mutate",
    [
        lambda d: d.update(schema_version=2),
        lambda d: d.update(schema_version=True),
        lambda d: d.update(format="unrelated-validation-report"),
        lambda d: d.update(evidence_kind="hypothetical"),
        lambda d: d["configuration"]["confidentiality"].update(
            ignored_setting="Public"
        ),
        lambda d: d["configuration"]["confidentiality"].update(
            local_clearances={"-1": "Public"}
        ),
        lambda d: d["findings"][0].update(id=2),
        lambda d: d["findings"][0].update(input="(true)"),
        lambda d: d["findings"][0].update(input="(2147483648)"),
        lambda d: d["findings"][0].update(step_limit=100000),
        lambda d: d["findings"][0]["violation"].update(pc="../../outside.main:(I)V:0"),
        lambda d: d["program"]["artifacts"][0].update(sha256="bad-digest"),
        lambda d: d["program"].update(artifacts=[]),
        lambda d: d["summary"].update(executions=10000),
        lambda d: d["summary"].update(outcomes=["*"]),
        lambda d: d["summary"].update(stop_reason="safe"),
        lambda d: d["summary"].update(elapsed_seconds=-1),
        lambda d: d["configuration"]["fuzz"].pop("step_limit"),
    ],
)
def test_malformed_or_misleading_reports_are_rejected(saved, mutate):
    document = copy.deepcopy(saved.report.document)
    mutate(document)
    with pytest.raises(reports.ReportError):
        reports.parse_report(document)


def test_nonfinite_json_and_invalid_finding_ids_are_rejected(saved):
    saved.path.write_text('{"value": NaN}', encoding="utf-8")
    with pytest.raises(reports.ReportError, match="non-finite"):
        reports.read_report(saved.path)
    for number in (0, 2, True):
        with pytest.raises(reports.ReportError):
            reports.replay_finding(saved.report, number, saved.runner)


def test_failed_atomic_write_does_not_destroy_an_existing_report(saved):
    before = saved.path.read_bytes()
    document = copy.deepcopy(saved.report.document)
    document["summary"]["elapsed_seconds"] = float("nan")
    with pytest.raises(ValueError):
        reports.write_report(replace(saved.report, document=document), saved.path)
    assert saved.path.read_bytes() == before
    assert not list(saved.path.parent.glob(".fuzz-report-*"))


def test_program_drift_is_detected_before_a_replay_runner_is_created(
    saved, monkeypatch, capsys
):
    saved.artifact.write_text('{"fixture": 2}', encoding="utf-8")
    monkeypatch.setattr(
        fuzz_cli, "_runner", lambda *args: pytest.fail("runner must not be constructed")
    )
    assert fuzz_cli.main(["replay", str(saved.path)]) == 2
    assert "program changed" in capsys.readouterr().err


def test_program_snapshots_ignore_formatting_and_line_ending_changes(saved):
    saved.artifact.write_bytes(b'{\r\n "note": "fixture",\r\n "fixture": 1\r\n}\r\n')
    reports.verify_program(saved.report, saved.suite)


def test_replay_does_not_accept_a_runner_exceeding_the_saved_budget(saved):
    finding = saved.report.findings[0]
    runner = lambda *args, **kwargs: RunResult(
        "completed",
        frozenset({finding.violation.pc}),
        finding.step_limit + 1,
        "assertion error",
        (finding.violation,),
    )
    with pytest.raises(reports.ReportError, match="exceeded"):
        reports.replay_finding(saved.report, 1, runner)


def test_checkout_relocation_and_ambient_settings_do_not_change_recorded_policy(
    saved, tmp_path, monkeypatch, capsys
):
    relocated = jpamb.Suite.from_workdir((tmp_path / "relocated").resolve())
    artifact = relocated.decompiledfile(saved.mid.classname)
    artifact.parent.mkdir(parents=True)
    artifact.write_bytes(saved.artifact.read_bytes())
    reports.verify_program(saved.report, relocated)
    roots = []

    def context(root, method):
        roots.append(Path(root))
        return relocated, saved.bc, saved.policy

    monkeypatch.setattr(fuzz_cli, "_context", context)
    monkeypatch.setenv("JPAMB_CONF_RETURN_CLEARANCE", "HospitalAdmin")
    assert (
        fuzz_cli.main(["replay", str(saved.path), "--suite", str(relocated.workdir)])
        == 0
    )
    output = json.loads(capsys.readouterr().out)
    assert output["all_matched"] and roots == [relocated.workdir]


def test_cli_run_saves_a_report_and_replay_has_meaningful_exit_codes(
    saved, tmp_path, monkeypatch, capsys
):
    monkeypatch.setattr(
        fuzz_cli, "_context", lambda *a: (saved.suite, saved.bc, saved.policy)
    )
    output = tmp_path / "cli.json"
    assert (
        fuzz_cli.main(
            [
                "run",
                saved.mid.encode(),
                "--output",
                str(output),
                "--executions",
                "3",
                "--local-clearance",
                "1=Public",
                "--return-clearance",
                "Oncology",
            ]
        )
        == 0
    )
    assert json.loads(capsys.readouterr().out)["findings"] == 1
    assert fuzz_cli.main(["replay", str(output), "--finding", "1"]) == 0
    assert json.loads(capsys.readouterr().out)["all_matched"]
    monkeypatch.setattr(
        fuzz_cli,
        "_runner",
        lambda *args: (
            lambda *a, **kw: RunResult(
                "completed",
                frozenset(),
                0,
                "ok",
            )
        ),
    )
    assert fuzz_cli.main(["replay", str(output)]) == 1
    assert not json.loads(capsys.readouterr().out)["all_matched"]


def test_empty_and_incomplete_campaign_reports_are_valid_but_not_safe_proofs(
    saved, tmp_path, monkeypatch, capsys
):
    campaign = fuzz(
        saved.mid, saved.space, saved.runner, config=FuzzConfig(max_executions=0)
    )
    empty = reports.create_report(
        campaign, suite=saved.suite, bytecode=saved.bc, input_space=saved.space
    )
    path = reports.write_report(empty, tmp_path / "empty.json")
    assert reports.read_report(path).document["summary"]["outcomes"] == []
    assert fuzz_cli.main(["replay", str(path)]) == 2
    assert "no findings" in capsys.readouterr().err
    incomplete = fuzz(
        saved.mid,
        saved.space,
        lambda *a, **kw: RunResult(
            "unsupported",
            frozenset(),
            0,
            detail="outside model",
        ),
        config=FuzzConfig(max_executions=1),
    )
    report = reports.create_report(
        incomplete, suite=saved.suite, bytecode=saved.bc, input_space=saved.space
    )
    assert report.document["summary"]["statuses"]["unsupported"] == 1
    assert not report.document["summary"]["outcomes"]


def test_jpamb_export_is_opt_in_and_keeps_prediction_stdout_clean(
    saved, tmp_path, monkeypatch, capsys
):
    suite = SimpleNamespace(
        workdir=saved.suite.workdir,
        decompiled_folder=saved.suite.decompiled_folder,
        decompiledfile=saved.suite.decompiledfile,
        security_policy=lambda *args, **kwargs: saved.policy,
    )
    monkeypatch.setattr(dynamic.jpamb, "setup", lambda: (suite, Effect(None)))
    monkeypatch.setattr(dynamic.jpamb, "getmethodid", lambda *args, **kwargs: saved.mid)
    monkeypatch.setattr(dynamic.jpamb, "Bytecode", lambda *args, **kwargs: saved.bc)
    monkeypatch.setenv("JPAMB_DYNAMIC_RUNS", "3")
    monkeypatch.delenv("JPAMB_FUZZ_REPORT_DIR", raising=False)
    dynamic.analyse()
    capsys.readouterr()
    directory = tmp_path / "reports"
    assert not directory.exists()
    monkeypatch.setenv("JPAMB_FUZZ_REPORT_DIR", str(directory))
    dynamic.analyse()
    out, err = capsys.readouterr()
    assert all(len(line.split(";")) == 2 for line in out.splitlines())
    assert "saved fuzz report:" in err
    (path,) = directory.glob("*.json")
    assert reports.read_report(path).findings


def test_hybrid_reports_and_replays_preserve_hypothetical_provenance(
    saved, tmp_path, monkeypatch, capsys
):
    hybrid = pytest.importorskip("hybrid", exc_type=ImportError)
    bc, mid, policy = program(
        [
            push(),
            store(1),
            load(0),
            push(30),
            branch(8, "le", "if"),
            push(1),
            store(1),
            goto(8),
            load(1),
            invoke(),
            VOID,
        ],
        labels=("Psych",),
        returns=False,
        extra_methods=[sink(label="Oncology")],
    )
    monkeypatch.setattr(
        hybrid,
        "run_syntactic_analysis",
        lambda *args: hybrid.SyntacticSummary(leaks=["candidate"], constants=[30]),
    )
    directory = tmp_path / "hybrid-reports"
    monkeypatch.setenv("JPAMB_FUZZ_REPORT_DIR", str(directory))
    hybrid.analyze_hybrid(saved.suite, bc, policy, mid, max_runs=1, max_steps=100)
    capsys.readouterr()
    loaded = [reports.read_report(path) for path in directory.glob("*.json")]
    assert len(loaded) == 2
    concrete = next(report for report in loaded if report.mode == "concrete")
    hypothetical = next(report for report in loaded if report.mode == "hybrid-pretaint")
    assert not concrete.findings and hypothetical.findings
    assert hypothetical.document["evidence_kind"] == "hypothetical"
    assert not reports.replay_finding(
        hypothetical, 1, dynamic.make_runner(bc, policy)
    ).matched
    assert reports.replay_finding(
        hypothetical,
        1,
        hybrid.make_hybrid_runner(
            bc,
            policy,
            hybrid_branch_taint=True,
        ),
    ).matched
    monkeypatch.setattr(fuzz_cli, "_context", lambda *args: (saved.suite, bc, policy))
    path = next(
        path
        for path in directory.glob("*.json")
        if reports.read_report(path).mode == "hybrid-pretaint"
    )
    assert fuzz_cli.main(["replay", str(path)]) == 0
    assert json.loads(capsys.readouterr().out)["evidence_kind"] == "hypothetical"


def test_real_cli_subprocess_saves_and_replays_a_compiled_java_finding(tmp_path):
    root = Path(__file__).resolve().parents[3]
    if not (root / "target/decompiled/jpamb/cases/Hospital.json").exists():
        pytest.skip("run the JPAMB compile/decompile build first")
    cli = root / "solutions/dynamic/src/fuzz_cli.py"
    output = tmp_path / "hospital.json"
    run = subprocess.run(
        [
            sys.executable,
            str(cli),
            "run",
            "jpamb.cases.Hospital.implicitCompartmentLeak:(I)V",
            "--suite",
            str(root),
            "--executions",
            "30",
            "--output",
            str(output),
        ],
        cwd=root,
        capture_output=True,
        text=True,
        check=True,
        timeout=20,
    )
    assert json.loads(run.stdout)["findings"] == 1
    replay = subprocess.run(
        [
            sys.executable,
            str(cli),
            "replay",
            str(output),
            "--finding",
            "1",
        ],
        cwd=root,
        capture_output=True,
        text=True,
        check=True,
        timeout=20,
    )
    assert json.loads(replay.stdout)["all_matched"]

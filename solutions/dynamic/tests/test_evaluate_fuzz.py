"""Fair search comparisons, censored metrics, and replayable trial evidence."""

import csv
import json
import random
import subprocess
import sys
from dataclasses import replace
from pathlib import Path

import dynamic
import evaluate_fuzz as evaluation
import fuzz_reports
import pytest
from coverage_fuzz import STRATEGIES, FuzzConfig, fuzz
from fuzz_contract import RunResult, Violation
from fuzz_inputs import InputSpace

import jpamb
import jvm
from jpamb.case import Input, Int
from jpamb.confidentiality import Config
from jvm.state import PC
from tests.test_confidentiality import RETURN, load, program

MID = jvm.AbsMethodID.decode("example.Test.check:(I)V")


def inputs(value):
    return Input((Int(value),))


def completed(mid=MID, *, leak=False):
    return RunResult(
        "completed",
        frozenset({PC(mid, 0)}),
        1,
        "assertion error" if leak else "ok",
        (Violation(PC(mid, 0), "return", "High", "Low", "High"),) if leak else (),
    )


@pytest.mark.parametrize("strategy", STRATEGIES)
def test_all_strategies_charge_seeds_and_enforce_exact_remaining_instruction_budget(
    strategy,
):
    limits = []
    recorder = evaluation.ProgressRecorder()

    def runner(mid, candidate, *, step_limit, **kwargs):
        limits.append(step_limit)
        return RunResult("step-limit", frozenset({PC(mid, 0)}), step_limit)

    campaign = fuzz(
        MID,
        InputSpace((jvm.Int(),)),
        runner,
        config=FuzzConfig(max_executions=20, step_limit=3, max_steps=8, seed_limit=1),
        seeds=[inputs(0)],
        strategy=strategy,
        observer=recorder,
    )
    row = evaluation.trial_metrics(campaign, recorder)
    assert limits == [3, 3, 2]
    assert campaign.steps == 8 and campaign.stop_reason == "steps"
    assert row["seed_executions"] == 1 and row["seed_steps"] == 3
    assert row["search_executions"] == 2 and row["search_steps"] == 5
    assert row["limited_runs"] == 3 and row["censored"]
    assert row["first_finding_steps"] is None
    assert recorder.finish()[-1]["steps"] == 8


def test_strategy_comparison_shares_initial_inputs_and_local_reproducible_randomness():
    space = InputSpace((jvm.Int(), jvm.Boolean()), (0, 1, 10))
    mid = jvm.AbsMethodID.decode("example.Test.check:(IZ)V")
    seeds = space.seeds(3)
    original_rng = random.getstate()

    def run(strategy):
        tried = []

        def runner(method, candidate, **kwargs):
            space.validate(candidate)
            tried.append(candidate)
            return completed(method)

        fuzz(
            mid,
            space,
            runner,
            strategy=strategy,
            seeds=seeds,
            config=FuzzConfig(max_executions=40, seed=19, seed_limit=3),
        )
        return tried

    for strategy in STRATEGIES:
        tried = run(strategy)
        assert tried == run(strategy)
        assert tried[:3] == list(seeds)
        if strategy == "dictionary-random":
            assert all(item.values[0].value in space.dictionary for item in tried[3:])
            assert len(set(tried[3:])) > 1
    assert random.getstate() == original_rng


def test_unguided_retention_does_not_depend_on_coverage():
    def runner(mid, candidate, **kwargs):
        return completed(mid, leak=candidate.values[0].value >= 2)

    def run(strategy):
        return fuzz(
            MID,
            InputSpace((jvm.Int(),)),
            runner,
            config=FuzzConfig(max_executions=20, seed_limit=1),
            strategy=strategy,
            seeds=[inputs(0)],
            mutator=lambda candidate, rand: inputs(candidate.values[0].value + 1),
        )

    guided = run("coverage-guided")
    unguided = run("unguided-mutation")
    assert not guided.findings and guided.corpus == (inputs(0),)
    assert unguided.findings and inputs(1) in unguided.corpus
    assert guided.coverage == unguided.coverage


def test_seed_discoveries_and_new_search_discoveries_are_separate():
    recorder = evaluation.ProgressRecorder()
    now = [0.0]

    def runner(mid, candidate, **kwargs):
        now[0] += 0.5
        offset = 0 if candidate.values[0].value == 0 else 1
        violation = Violation(PC(mid, offset), "return", "High", "Low", "High")
        return RunResult(
            "completed", frozenset({violation.pc}), 1, "assertion error", (violation,)
        )

    campaign = fuzz(
        MID,
        InputSpace((jvm.Int(),)),
        runner,
        config=FuzzConfig(max_executions=4, seed_limit=1),
        seeds=[inputs(0)],
        mutator=lambda *_: inputs(1),
        observer=recorder,
        clock=lambda: now[0],
    )
    row = evaluation.trial_metrics(campaign, recorder)
    assert row["first_finding_phase"] == "seed"
    assert row["first_finding_execution"] == 1
    assert row["first_finding_seconds"] == 0.5
    assert row["seed_findings"] == row["search_new_findings"] == 1
    assert row["search_executions_to_new_finding"] == 1
    assert row["search_steps_to_new_finding"] == 1
    assert [event["execution"] for event in recorder.finish()] == [1, 2, 4]


def test_zero_budget_is_censored_and_seed_only_trials_have_no_search_estimate():
    for config in (FuzzConfig(max_executions=0), FuzzConfig(max_executions=1)):
        recorder = evaluation.ProgressRecorder()
        campaign = fuzz(
            MID,
            InputSpace((jvm.Int(),)),
            lambda *a, **kw: completed(),
            config=config,
            observer=recorder,
        )
        row = evaluation.trial_metrics(campaign, recorder)
        assert row["censored"] and row["first_finding_execution"] is None
        assert row["search_executions"] == 0
        summary = evaluation.aggregate([row])[0]
        assert summary["found_fraction"] == 0
        assert summary["search_new_finding_fraction"] is None
        assert summary["median_first_finding_executions_on_success"] is None


def test_aggregation_keeps_unsuccessful_and_unsupported_trials_in_denominator():
    rows = []
    for seed in range(3):
        recorder = evaluation.ProgressRecorder()

        def runner(*args, trial_seed=seed, **kwargs):
            return (
                completed(leak=True)
                if trial_seed == 0
                else RunResult("unsupported", frozenset(), 0)
            )

        campaign = fuzz(
            MID,
            InputSpace((jvm.Int(),)),
            runner,
            config=FuzzConfig(max_executions=4, seed=seed, seed_limit=1),
            observer=recorder,
        )
        rows.append(evaluation.trial_metrics(campaign, recorder))
    group = evaluation.aggregate(rows)[0]
    assert group["trials"] == 3 and group["found_trials"] == 1
    assert group["not_found_trials"] == 2
    assert group["found_fraction"] == pytest.approx(1 / 3)
    assert group["mean_unsupported_runs"] == pytest.approx(8 / 3)
    assert group["median_first_finding_executions_on_success"] == 1
    baseline = [
        {**row, "strategy": "dictionary-random", "found": False} for row in rows
    ]
    assert evaluation.paired_comparisons(rows + baseline) == [
        {
            "method": MID.encode(),
            "baseline": "dictionary-random",
            "both_found": 0,
            "guided_only_found": 1,
            "baseline_only_found": 0,
            "neither_found": 2,
        }
    ]


@pytest.fixture
def context(tmp_path, monkeypatch):
    bc, mid, policy = program([load(0), RETURN])
    suite = jpamb.Suite.from_workdir(tmp_path.resolve())
    artifact = suite.decompiledfile(mid.classname)
    artifact.parent.mkdir(parents=True)
    artifact.write_text('{"fixture": "evaluation"}', encoding="utf-8")
    monkeypatch.setattr(
        evaluation.fuzz_cli, "_context", lambda *args: (suite, bc, policy)
    )
    return suite, bc, mid, policy


def test_evaluation_outputs_match_campaigns_and_replay_with_recorded_settings(
    context, tmp_path
):
    suite, bc, mid, policy = context
    output = tmp_path / "evaluation"
    settings = Config(return_clearance="Public")
    config = FuzzConfig(max_executions=6, step_limit=20, max_steps=100, seed_limit=2)
    rows = evaluation.evaluate(
        [mid],
        suite_root=suite.workdir,
        output=output,
        config=config,
        random_seeds=[3, 7],
        security_config=settings,
    )
    summary = json.loads((output / "summary.json").read_text())
    assert (
        summary["complete"]
        and summary["completed_trials"] == summary["expected_trials"] == 6
    )
    assert len(summary["groups"]) == 3 and len(summary["paired_comparisons"]) == 2
    assert json.loads((output / "trials.json").read_text()) == rows
    with (output / "trials.csv").open(newline="", encoding="utf-8") as stream:
        csv_rows = list(csv.DictReader(stream))
    assert len(csv_rows) == len(rows)
    for row in rows:
        report = fuzz_reports.read_report(output / row["report"])
        assert report.document["generator"]["strategy"] == row["strategy"]
        assert report.document["evaluation"]["metrics"] == row
        assert report.document["evaluation"]["progress"][-1]["execution"] == 6
        assert report.document["summary"]["executions"] == row["executions"]
        assert report.config == replace(config, seed=row["random_seed"])
        assert report.security_config == settings
        assert row["first_finding_phase"] == "seed" and row["search_new_findings"] == 0
        assert fuzz_reports.replay_finding(
            report, 1, dynamic.make_runner(bc, policy)
        ).matched
    # Additive strategy metadata preserves reports written before the harness existed.
    del report.document["generator"]["strategy"]
    assert fuzz_reports.parse_report(report.document).findings
    report.document["generator"]["strategy"] = "imaginary"
    with pytest.raises(fuzz_reports.ReportError, match="strategy"):
        fuzz_reports.parse_report(report.document)


def test_interrupted_evaluation_preserves_finished_trials_without_claiming_completion(
    context, tmp_path, monkeypatch
):
    suite, _bc, mid, _policy = context
    actual = evaluation.fuzz
    count = 0

    def fail_second(*args, **kwargs):
        nonlocal count
        count += 1
        if count == 2:
            raise RuntimeError("runner bug")
        return actual(*args, **kwargs)

    monkeypatch.setattr(evaluation, "fuzz", fail_second)
    output = tmp_path / "partial"
    with pytest.raises(RuntimeError, match="runner bug"):
        evaluation.evaluate(
            [mid],
            suite_root=suite.workdir,
            output=output,
            config=FuzzConfig(max_executions=1),
            random_seeds=[0],
        )
    summary = json.loads((output / "summary.json").read_text())
    assert not summary["complete"] and summary["completed_trials"] == 1
    assert len(list((output / "campaigns").glob("*.json"))) == 1


@pytest.mark.parametrize(
    "change",
    [
        {"random_seeds": [1, 1]},
        {"random_seeds": []},
        {"strategies": ["unknown"]},
        {"strategies": ["coverage-guided"] * 2},
        {"strategies": []},
    ],
)
def test_invalid_comparisons_are_rejected_before_output_is_created(
    context, tmp_path, change
):
    suite, _, mid, _ = context
    output = tmp_path / "invalid"
    kwargs = {"random_seeds": [0], **change}
    with pytest.raises(ValueError):
        evaluation.evaluate(
            [mid],
            suite_root=suite.workdir,
            output=output,
            config=FuzzConfig(),
            **kwargs,
        )
    assert not output.exists()


def test_existing_output_is_protected_and_target_manifest_rejects_duplicates(
    context, tmp_path
):
    suite, _, mid, _ = context
    output = tmp_path / "existing"
    output.mkdir()
    (output / "keep.txt").write_text("keep")
    with pytest.raises(ValueError, match="new or empty"):
        evaluation.evaluate(
            [mid],
            suite_root=suite.workdir,
            output=output,
            config=FuzzConfig(),
            random_seeds=[0],
        )
    assert (output / "keep.txt").read_text() == "keep"
    manifest = tmp_path / "targets.json"
    manifest.write_text(
        json.dumps(
            {
                "format": "jpamb-fuzz-targets",
                "schema_version": 1,
                "methods": [mid.encode(), mid.encode()],
            }
        )
    )
    with pytest.raises(ValueError, match="duplicate"):
        evaluation.load_targets(manifest)


def test_compiled_java_evaluation_cli_produces_comparable_replayable_trials(tmp_path):
    root = Path(__file__).resolve().parents[3]
    if not (root / "target/decompiled/jpamb/cases/Hospital.json").exists():
        pytest.skip("run the JPAMB compile/decompile build first")
    output = tmp_path / "compiled"
    completed_cli = subprocess.run(
        [
            sys.executable,
            str(root / "solutions/dynamic/src/evaluate_fuzz.py"),
            "--method",
            "jpamb.cases.Hospital.implicitCompartmentLeak:(I)V",
            "--suite",
            str(root),
            "--output",
            str(output),
            "--seeds",
            "0",
            "1",
            "--executions",
            "30",
        ],
        capture_output=True,
        text=True,
        check=True,
        timeout=30,
        cwd=tmp_path,
    )
    assert json.loads(completed_cli.stdout)["completed_trials"] == 6
    rows = json.loads((output / "trials.json").read_text())
    assert all(row["found"] and row["first_finding_phase"] == "seed" for row in rows)
    assert len({row["seed_steps"] for row in rows}) == 1
    report = fuzz_reports.read_report(output / rows[0]["report"])
    from fuzz_cli import _context

    suite, bc, policy = _context(root, report.method_id)
    fuzz_reports.verify_program(report, suite)
    assert fuzz_reports.replay_finding(
        report, 1, dynamic.make_runner(bc, policy)
    ).matched


def test_checked_in_target_manifests_have_expected_scope():
    directory = Path(__file__).resolve().parents[1] / "evaluation"
    pilot = evaluation.load_targets(directory / "pilot.json")
    full = evaluation.load_targets(directory / "benchmarks.json")
    assert len(pilot) == 8 and len(full) == 68
    assert set(pilot) <= set(full)
    assert all(not method.extension.name.startswith("recursive") for method in full)

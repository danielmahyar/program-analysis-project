"""Study integrity and compiled challenge mechanisms, independent of expected rankings."""

import json
from itertools import pairwise
from pathlib import Path

import dynamic
import evaluate_fuzz
import fuzz_cli
import fuzz_study
import pytest
from coverage_fuzz import STRATEGIES, FuzzConfig, fuzz
from fuzz_inputs import InputSpace, interesting_integers

import jpamb
import jvm
from jpamb.case import Input, Int
from jpamb.confidentiality import Config
from jpamb.utils import Effect
from tests.test_confidentiality import RETURN, load, program, push

ROOT = Path(__file__).resolve().parents[3]
PROTOCOL = ROOT / "solutions/dynamic/evaluation/challenges-protocol.json"


def test_protocol_rejects_changed_source_and_normalizes_line_endings(tmp_path):
    source = tmp_path / "Challenge.java"
    source.write_bytes(b"class Challenge {}\n")
    names = ["example.Challenge.leak:(I)V", "example.Challenge.control:(I)V"]
    (tmp_path / "methods.json").write_text(
        json.dumps(
            {
                "format": "jpamb-fuzz-targets",
                "schema_version": 1,
                "methods": names,
            }
        )
    )
    protocol = {
        "format": "jpamb-fuzz-study",
        "schema_version": 1,
        "source": "Challenge.java",
        "source_sha256": fuzz_study.source_digest(source),
        "manifest": "methods.json",
        "configuration": {},
        "strategies": list(STRATEGIES),
        "families": [{"methods": names[:1], "control": names[1]}],
    }
    path = tmp_path / "protocol.json"
    path.write_text(json.dumps(protocol))
    source.write_bytes(b"class Challenge {}\r\n")
    assert len(fuzz_study.load_protocol(path, tmp_path)[1]) == 2
    source.write_text("class Different {}")
    with pytest.raises(ValueError, match="source differs"):
        fuzz_study.load_protocol(path, tmp_path)


@pytest.mark.parametrize(
    "ops, fails", [([load(0), RETURN], True), ([push(0), RETURN], False)]
)
def test_seed_check_rejects_seed_solved_methods_without_running_search(
    monkeypatch, ops, fails
):
    bc, mid, policy = program(ops)
    monkeypatch.setattr(
        fuzz_study.fuzz_cli, "_context", lambda *args: (None, bc, policy)
    )
    if fails:
        with pytest.raises(ValueError, match="initial seeds solve"):
            fuzz_study.check_initial_seeds([mid], ROOT, FuzzConfig())
    else:
        (result,) = fuzz_study.check_initial_seeds([mid], ROOT, FuzzConfig())
        assert result["seed_findings"] == 0
        assert result["seed_executions"] > 0


def synthetic_rows():
    mid = jvm.AbsMethodID.decode("example.Challenge.leak:(I)V")
    recorder = evaluate_fuzz.ProgressRecorder()
    empty = fuzz(
        mid,
        InputSpace((jvm.Int(),)),
        None,
        config=FuzzConfig(max_executions=0),
        observer=recorder,
    )
    template = evaluate_fuzz.trial_metrics(empty, recorder)
    methods = [mid.encode(), "example.Challenge.control:(I)V"]
    protocol = {
        "id": "fixture",
        "strategies": list(STRATEGIES),
        "random_seeds": [0, 1],
        "families": [
            {
                "id": "fixture-family",
                "methods": methods[:1],
                "control": methods[1],
                "expected_best": "coverage-guided",
                "hypothesis": "guided wins",
            }
        ],
    }
    rows = [
        {**template, "method": method, "strategy": strategy, "random_seed": seed}
        for method in methods
        for strategy in STRATEGIES
        for seed in (0, 1)
    ]
    return protocol, rows


def test_comparison_reports_ties_as_unsupported_expectation_and_preserves_misses():
    protocol, rows = synthetic_rows()
    comparison = fuzz_study.compare(protocol, rows)
    (family,) = comparison["families"]
    assert not family["expectation_met_descriptively"]
    assert set(family["actual_best"]) == set(STRATEGIES)
    assert family["control_trials"] == 6 and family["control_found_trials"] == 0
    assert all(
        result["detection_fraction"] == 0 for result in family["results"].values()
    )
    protocol["families"][0]["expected_best"] = None
    assert fuzz_study.compare(protocol, rows)["families"][0][
        "expectation_met_descriptively"
    ]


@pytest.mark.parametrize("change", ["missing", "duplicate", "seed-discovery"])
def test_comparison_rejects_incomplete_or_seed_solved_data(change):
    protocol, rows = synthetic_rows()
    if change == "missing":
        rows.pop()
    elif change == "duplicate":
        rows.append(rows[0])
    else:
        rows[0]["seed_findings"] = 1
    with pytest.raises(ValueError):
        fuzz_study.compare(protocol, rows)


@pytest.fixture
def compiled():
    if not (ROOT / "target/decompiled/jpamb/cases/FuzzingChallenges.json").exists():
        pytest.skip("run the JPAMB compile/decompile build first")
    # Test the landscapes against the current runner. Historical study digests
    # are enforced by the study CLI, not as a freeze on future interpreter fixes.
    protocol = json.loads(PROTOCOL.read_text(encoding="utf-8"))
    methods = evaluate_fuzz.load_targets(PROTOCOL.parent / protocol["manifest"])
    config = FuzzConfig(**protocol["configuration"])
    return protocol, methods, config


def test_all_declared_challenge_inputs_match_the_concrete_oracle_and_controls(compiled):
    protocol, methods, _ = compiled
    assert len(methods) == 16 and len(protocol["families"]) == 4
    suite = jpamb.Suite.from_workdir(ROOT)
    cases = [
        case
        for case in suite.cases(eff=Effect(None))
        if str(case.experiment.entry.classname) == "jpamb.cases.FuzzingChallenges"
    ]
    assert len(cases) == 32
    for case in cases:
        mid = case.experiment.entry
        _, bytecode, policy = fuzz_cli._context(ROOT, mid)
        observed = dynamic.make_runner(bytecode, policy)(
            mid,
            case.experiment.input,
            step_limit=2500,
            security_config=Config(),
        )
        assert observed.status == "completed" and observed.outcome == case.result
        assert bool(observed.violations) == (case.result == "assertion error")


def test_challenges_leave_the_whole_shared_seed_phase_unresolved(compiled):
    _, methods, config = compiled
    observations = fuzz_study.check_initial_seeds(methods, ROOT, config)
    assert len(observations) == 16
    assert all(
        row["seed_executions"] > 0 and row["seed_findings"] == 0 for row in observations
    )


def challenge(name):
    method = jpamb.parse_methodid("jpamb.cases.FuzzingChallenges." + name)
    _, bytecode, policy = fuzz_cli._context(ROOT, method)
    constants, _ = dynamic.collect_constants(bytecode, method)
    space = InputSpace(tuple(method.extension.params), interesting_integers(constants))
    runner = dynamic.make_runner(bytecode, policy)

    def run(*values):
        return runner(
            method,
            Input(tuple(Int(value) for value in values)),
            step_limit=2500,
            security_config=Config(),
        )

    return space, run


@pytest.mark.parametrize("target", [19, 23, 31])
def test_neutral_targets_are_absent_from_dictionary_and_partial_values_add_no_coverage(
    compiled, target
):
    space, run = challenge(f"neutralTarget{target}:(II)V")
    assert target not in space.dictionary
    zero = run(0, 99)
    bridge = run(target - 8, 99)
    assert not zero.violations and not bridge.violations
    assert zero.coverage == bridge.coverage
    assert run(target, 99).violations


def test_staged_guards_supply_progress_while_opaque_pair_hides_partial_matches(
    compiled,
):
    _, staged = challenge("stagedMask3:(IIII)V")
    observations = [
        staged(*values, 99) for values in ((0, 0, 0), (3, 0, 0), (3, 5, 0), (3, 5, 6))
    ]
    assert all(not observed.violations for observed in observations[:3])
    assert observations[-1].violations
    assert all(len(b.coverage) > len(a.coverage) for a, b in pairwise(observations))
    space, opaque = challenge("opaquePair17:(III)V")
    assert {17, 43} <= set(space.dictionary)
    assert opaque(0, 0, 99).coverage == opaque(17, 0, 99).coverage
    assert opaque(17, 43, 99).violations


@pytest.mark.parametrize("first, second", [(257, 263), (509, 521), (1031, 1033)])
def test_product_targets_are_not_exposed_as_executable_constants(
    compiled, first, second
):
    space, run = challenge(f"productTarget{first}:(II)V")
    assert first * second not in space.dictionary
    assert not run(first, 99).violations
    assert run(first * second, 99).violations

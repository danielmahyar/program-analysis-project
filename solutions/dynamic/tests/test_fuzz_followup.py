"""Expectations informed by old seeds must be checked on the extension partition."""

from copy import deepcopy

import evaluate_fuzz
import fuzz_followup
import pytest
from coverage_fuzz import STRATEGIES, FuzzConfig, fuzz
from fuzz_inputs import InputSpace

import jvm


def fixture_data():
    method = jvm.AbsMethodID.decode("example.Test.check:(I)V")
    recorder = evaluate_fuzz.ProgressRecorder()
    empty = fuzz(
        method,
        InputSpace((jvm.Int(),)),
        None,
        config=FuzzConfig(max_executions=0),
        observer=recorder,
    )
    template = evaluate_fuzz.trial_metrics(empty, recorder)
    protocol = {
        "format": "jpamb-fuzz-followup",
        "schema_version": 1,
        "id": "fixture",
        "configuration": {},
        "exploratory_seeds": [0],
        "extension_seeds": [1],
        "random_seeds": [0, 1],
        "strategies": list(STRATEGIES),
        "primary_hypotheses": [
            {
                "method": method.encode(),
                "expected_best": "dictionary-random",
            }
        ],
        "interpretation": [],
    }
    rows = []
    for strategy in STRATEGIES:
        for seed in (0, 1):
            # Dictionary wins on the old seed, unguided wins on the unseen seed.
            found = (strategy, seed) in {
                ("dictionary-random", 0),
                ("unguided-mutation", 1),
            }
            rows.append(
                {
                    **template,
                    "strategy": strategy,
                    "random_seed": seed,
                    "found": found,
                    "censored": not found,
                    "first_finding_execution": 1 if found else None,
                    "first_finding_steps": 1 if found else None,
                }
            )
    original = {
        "groups": [
            {
                "method": method.encode(),
                "strategy": strategy,
                "trials": 1,
                "found_trials": int(strategy == "dictionary-random"),
            }
            for strategy in STRATEGIES
        ]
    }
    return protocol, rows, original


def test_expectation_uses_unseen_seeds_and_keeps_replication_separate():
    protocol, rows, original = fixture_data()
    result = fuzz_followup.summarize(protocol, rows, original)
    assert result["partitions"]["combined"]["trials"] == 6
    assert result["partitions"]["extension"]["trials"] == 3
    assert result["partitions"]["exploratory_replication"]["trials"] == 3
    (check,) = result["primary_checks"]
    assert check["evaluated_partition"] == "extension"
    assert not check["expectation_met_descriptively"]
    assert check["fractions"]["dictionary-random"] == 0
    assert check["fractions"]["unguided-mutation"] == 1


@pytest.mark.parametrize("change", ["missing", "duplicate", "overlap"])
def test_bad_trial_matrices_or_overlapping_seed_partitions_are_rejected(change):
    protocol, rows, original = fixture_data()
    if change == "missing":
        rows.pop()
    elif change == "duplicate":
        rows.append(rows[0])
    else:
        protocol["extension_seeds"] = [0, 1]
    with pytest.raises(ValueError):
        fuzz_followup.summarize(protocol, rows, original)


def test_changed_original_detection_counts_are_not_silently_accepted():
    protocol, rows, original = fixture_data()
    original = deepcopy(original)
    original["groups"][0]["found_trials"] = 0
    with pytest.raises(ValueError, match="did not reproduce"):
        fuzz_followup.summarize(protocol, rows, original)


def test_initial_input_discovery_is_not_credited_to_a_search_strategy():
    protocol, rows, original = fixture_data()
    rows[0]["seed_findings"] = 1
    with pytest.raises(ValueError, match="unresolved by initial"):
        fuzz_followup.summarize(protocol, rows, original)

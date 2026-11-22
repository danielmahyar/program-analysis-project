"""Summarize a follow-up, keeping exploratory and previously unseen RNG seeds separate."""

import argparse
import csv
import hashlib
import json
import sys
from pathlib import Path

_ROOT = Path(__file__).resolve().parents[3]
if (_ROOT / "src").is_dir() and str(_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(_ROOT / "src"))

import evaluate_fuzz


def summarize(protocol, rows, original):
    if (
        protocol.get("format") != "jpamb-fuzz-followup"
        or type(protocol.get("schema_version")) is not int
        or protocol["schema_version"] != 1
    ):
        raise ValueError("expected a jpamb-fuzz-followup version 1 protocol")
    exploratory = set(protocol["exploratory_seeds"])
    extension = set(protocol["extension_seeds"])
    all_seeds = set(protocol["random_seeds"])
    if (
        not exploratory
        or not extension
        or exploratory & extension
        or exploratory | extension != all_seeds
        or len(all_seeds) != len(protocol["random_seeds"])
    ):
        raise ValueError("exploratory and extension seeds must partition the RNG seeds")
    methods = [hypothesis["method"] for hypothesis in protocol["primary_hypotheses"]]
    expected = {
        (method, strategy, seed)
        for method in methods
        for strategy in protocol["strategies"]
        for seed in all_seeds
    }
    actual = [(row["method"], row["strategy"], row["random_seed"]) for row in rows]
    if len(set(actual)) != len(actual) or set(actual) != expected:
        raise ValueError("trial results do not match the follow-up matrix")
    if any(row["seed_findings"] for row in rows):
        raise ValueError("follow-up methods must remain unresolved by initial inputs")
    partitions = {}
    for name, seeds in (
        ("exploratory_replication", exploratory),
        ("extension", extension),
        ("combined", all_seeds),
    ):
        selected = [row for row in rows if row["random_seed"] in seeds]
        partitions[name] = {
            "random_seeds": sorted(seeds),
            "trials": len(selected),
            "groups": evaluate_fuzz.aggregate(selected),
            "paired_comparisons": evaluate_fuzz.paired_comparisons(selected),
        }
    original_counts = {
        (group["method"], group["strategy"]): (group["found_trials"], group["trials"])
        for group in original["groups"]
    }
    for group in partitions["exploratory_replication"]["groups"]:
        if original_counts[(group["method"], group["strategy"])] != (
            group["found_trials"],
            group["trials"],
        ):
            raise ValueError("original seed detection counts did not reproduce")
    fractions = {
        (group["method"], group["strategy"]): group["found_fraction"]
        for group in partitions["extension"]["groups"]
    }
    checks = []
    for hypothesis in protocol["primary_hypotheses"]:
        method = hypothesis["method"]
        predicted = hypothesis["expected_best"]
        observed = {
            strategy: fractions[(method, strategy)]
            for strategy in protocol["strategies"]
        }
        checks.append(
            {
                **hypothesis,
                "evaluated_partition": "extension",
                "fractions": observed,
                "expectation_met_descriptively": all(
                    observed[predicted] > fraction
                    for strategy, fraction in observed.items()
                    if strategy != predicted
                ),
            }
        )
    # This secondary comparison is specific to the two named nested-loop methods.
    double = next(
        (method for method in methods if ".nestedWhileWeirdCaseLeak:" in method), None
    )
    triple = next(
        (method for method in methods if ".tripleNestedWhileCornerLeak:" in method),
        None,
    )
    secondary = None
    if double and triple and "secondary_hypothesis" in protocol:
        secondary = {
            **protocol["secondary_hypothesis"],
            "evaluated_partition": "extension",
            "double_loop_fraction": fractions[(double, "dictionary-random")],
            "triple_loop_fraction": fractions[(triple, "dictionary-random")],
            "expectation_met_descriptively": (
                fractions[(triple, "dictionary-random")]
                < fractions[(double, "dictionary-random")]
            ),
        }
    return {
        "format": "jpamb-fuzz-followup-results",
        "schema_version": 1,
        "study": protocol["id"],
        "configuration": protocol["configuration"],
        "partitions": partitions,
        "primary_checks": checks,
        "secondary_check": secondary,
        "notes": protocol["interpretation"],
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--protocol", type=Path, required=True)
    parser.add_argument("--run", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)
    try:
        protocol = json.loads(args.protocol.read_text(encoding="utf-8"))
        saved = json.loads(
            (args.run / "study-protocol.json").read_text(encoding="utf-8")
        )
        run = json.loads((args.run / "summary.json").read_text(encoding="utf-8"))
        if (
            saved != protocol
            or not run["complete"]
            or run["configuration"] != protocol["configuration"]
        ):
            raise ValueError("completed campaign settings/protocol do not match")
        original = json.loads(
            (args.protocol.parent / protocol["original_result"]).read_text(
                encoding="utf-8"
            )
        )
        rows = json.loads((args.run / "trials.json").read_text(encoding="utf-8"))
        result = summarize(protocol, rows, original)
        result["protocol_sha256"] = hashlib.sha256(
            args.protocol.read_text(encoding="utf-8").encode("utf-8")
        ).hexdigest()
        result["program_artifacts"] = protocol.get("program_artifacts", {})
        validation = args.run / "validation-summary.json"
        if validation.exists():
            result["validation"] = json.loads(validation.read_text(encoding="utf-8"))
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(
            json.dumps(result, indent=2, sort_keys=True, allow_nan=False) + "\n",
            encoding="utf-8",
        )
        table = [
            {
                "partition": name,
                **{
                    field: group[field]
                    for field in (
                        "method",
                        "strategy",
                        "trials",
                        "found_trials",
                        "found_fraction",
                        "seed_found_trials",
                        "mean_coverage_locations",
                        "mean_steps",
                        "mean_limited_runs",
                        "mean_unsupported_runs",
                    )
                },
            }
            for name, partition in result["partitions"].items()
            for group in partition["groups"]
        ]
        with args.output.with_suffix(".csv").open(
            "w", encoding="utf-8", newline=""
        ) as stream:
            writer = csv.DictWriter(stream, fieldnames=list(table[0]))
            writer.writeheader()
            writer.writerows(table)
    except (OSError, ValueError, TypeError, KeyError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
    print(
        json.dumps(
            {"output": str(args.output), "completed_trials": len(rows)}, indent=2
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

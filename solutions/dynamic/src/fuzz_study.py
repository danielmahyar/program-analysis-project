"""Run a predeclared synthetic search study without changing the input strategies."""

import argparse
import csv
import hashlib
import json
import sys
from dataclasses import replace
from pathlib import Path

_ROOT = Path(__file__).resolve().parents[3]
if (_ROOT / "src").is_dir() and str(_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(_ROOT / "src"))

import dynamic
import evaluate_fuzz
import fuzz_cli
import fuzz_reports
from coverage_fuzz import STRATEGIES, FuzzConfig, fuzz
from fuzz_inputs import InputSpace, interesting_integers

from jpamb.confidentiality import Config


def source_digest(path):
    # Stable across Windows/Linux checkouts with different line endings.
    source = Path(path).read_text(encoding="utf-8").replace("\r\n", "\n")
    return hashlib.sha256(source.encode("utf-8")).hexdigest()


def load_protocol(path, suite_root):
    path = Path(path).resolve()
    document = json.loads(path.read_text(encoding="utf-8"))
    if (
        document.get("format") != "jpamb-fuzz-study"
        or type(document.get("schema_version")) is not int
        or document["schema_version"] != 1
    ):
        raise ValueError("expected a jpamb-fuzz-study version 1 protocol")
    source = Path(suite_root).resolve() / document["source"]
    if source_digest(source) != document["source_sha256"]:
        raise ValueError("challenge source differs from the predeclared protocol")
    for relative, expected in document.get("implementation_sha256", {}).items():
        if source_digest(Path(suite_root) / relative) != expected:
            raise ValueError(f"search implementation differs from protocol: {relative}")
    for relative, expected in document.get("program_artifacts", {}).items():
        if fuzz_reports._artifact_digest(Path(suite_root) / relative) != expected:
            raise ValueError(f"compiled program differs from protocol: {relative}")
    methods = evaluate_fuzz.load_targets(path.parent / document["manifest"])
    declared = [
        method
        for family in document["families"]
        for method in [*family["methods"], family["control"]]
    ]
    if (
        not declared
        or len(set(declared)) != len(declared)
        or set(declared) != {method.encode() for method in methods}
    ):
        raise ValueError("protocol families must partition the target manifest")
    if set(document["strategies"]) != set(STRATEGIES):
        raise ValueError("this comparison requires all three input strategies")
    config = FuzzConfig(**document["configuration"])
    return document, methods, config


def check_initial_seeds(methods, suite_root, config):
    """Check challenge eligibility without running any post-seed input selection."""
    observations = []
    for method in methods:
        _suite, bytecode, policy = fuzz_cli._context(suite_root, method)
        constants, _ = dynamic.collect_constants(bytecode, method)
        space = InputSpace(
            tuple(method.extension.params), interesting_integers(constants)
        )
        seeds = dynamic.build_seeds(space, constants)[: config.seed_limit]
        result = fuzz(
            method,
            space,
            dynamic.make_runner(bytecode, policy),
            config=replace(config, max_executions=len(seeds)),
            seeds=seeds,
            security_config=Config(),
        )
        if (
            result.findings
            or result.completed_runs != len(seeds)
            or result.executions != len(seeds)
        ):
            raise ValueError(
                f"initial seeds solve or cannot fully execute challenge: {method}"
            )
        observations.append(
            {
                "method": method.encode(),
                "seed_executions": result.executions,
                "seed_steps": result.steps,
                "seed_findings": len(result.findings),
                "dictionary": list(space.dictionary),
            }
        )
    return observations


def compare(protocol, rows):
    expected = {
        (method, strategy, seed)
        for family in protocol["families"]
        for method in [*family["methods"], family["control"]]
        for strategy in protocol["strategies"]
        for seed in protocol["random_seeds"]
    }
    actual = [(row["method"], row["strategy"], row["random_seed"]) for row in rows]
    if len(set(actual)) != len(actual) or set(actual) != expected:
        raise ValueError("trial results do not match the predeclared study matrix")
    if any(row["seed_findings"] for row in rows):
        raise ValueError("a comparison trial found a violation during initial seeding")
    families = []
    for family in protocol["families"]:
        selected = [row for row in rows if row["method"] in family["methods"]]
        groups = evaluate_fuzz.aggregate(selected)
        results = {}
        for strategy in protocol["strategies"]:
            trials = [row for row in selected if row["strategy"] == strategy]
            results[strategy] = {
                "found_trials": sum(row["found"] for row in trials),
                "trials": len(trials),
                # Same repetition count per method; this equals the method macro-average.
                "detection_fraction": sum(row["found"] for row in trials) / len(trials),
                "methods_found": len({row["method"] for row in trials if row["found"]}),
                "mean_coverage_locations": sum(
                    row["coverage_locations"] for row in trials
                )
                / len(trials),
            }
        predicted = family["expected_best"]
        fractions = {
            name: result["detection_fraction"] for name, result in results.items()
        }
        if predicted is None:
            supported = all(fraction <= 0.1 for fraction in fractions.values())
        else:
            supported = all(
                fractions[predicted] > value
                for name, value in fractions.items()
                if name != predicted
            )
        best = max(fractions.values())
        controls = [row for row in rows if row["method"] == family["control"]]
        families.append(
            {
                "family": family["id"],
                "hypothesis": family["hypothesis"],
                "predicted_reason": family.get("reason", ""),
                "expected_best": predicted,
                "expectation_met_descriptively": supported,
                "actual_best": [
                    name for name, value in fractions.items() if value == best
                ],
                "results": results,
                "per_method": groups,
                "control_trials": len(controls),
                "control_found_trials": sum(row["found"] for row in controls),
            }
        )
    return {
        "format": "jpamb-fuzz-study-comparison",
        "schema_version": 1,
        "study": protocol["id"],
        "completed_trials": len(rows),
        "families": families,
        "interpretation": "Descriptive hypothesis checks, not statistical significance tests or a general strategy ranking.",
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--protocol", type=Path, required=True)
    parser.add_argument("--suite", type=Path, default=Path.cwd())
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--summarize-only",
        action="store_true",
        help="summarize existing completed trial data without rerunning",
    )
    args = parser.parse_args(argv)
    try:
        protocol, methods, config = load_protocol(args.protocol, args.suite)
        if args.summarize_only:
            rows = json.loads((args.output / "trials.json").read_text(encoding="utf-8"))
            saved = json.loads(
                (args.output / "study-protocol.json").read_text(encoding="utf-8")
            )
            if saved != protocol:
                raise ValueError(
                    "saved study protocol differs from the supplied protocol"
                )
        else:
            initial = check_initial_seeds(methods, args.suite, config)
            print(
                f"All {len(initial)} targets pass the initial-seed check.",
                file=sys.stderr,
            )
            rows = evaluate_fuzz.evaluate(
                methods,
                suite_root=args.suite,
                output=args.output,
                config=config,
                random_seeds=protocol["random_seeds"],
                strategies=protocol["strategies"],
            )
            for name, document in (
                ("study-protocol.json", protocol),
                ("initial-seed-check.json", initial),
            ):
                (args.output / name).write_text(
                    json.dumps(document, indent=2) + "\n", encoding="utf-8"
                )
        result = compare(protocol, rows)
        (args.output / "study-comparison.json").write_text(
            json.dumps(result, indent=2, sort_keys=True, allow_nan=False) + "\n",
            encoding="utf-8",
        )
        table = [
            {
                "family": family["family"],
                "strategy": strategy,
                "hypothesis": family["hypothesis"],
                "expected_best": family["expected_best"],
                "found_trials": observed["found_trials"],
                "trials": observed["trials"],
                "detection_fraction": observed["detection_fraction"],
                "actual_best": ", ".join(family["actual_best"]),
                "expectation_met_descriptively": family[
                    "expectation_met_descriptively"
                ],
                "predicted_reason": family["predicted_reason"],
            }
            for family in result["families"]
            for strategy, observed in family["results"].items()
        ]
        with (args.output / "study-comparison.csv").open(
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

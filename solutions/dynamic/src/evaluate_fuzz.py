"""Compare input strategies with shared concrete confidentiality semantics."""

import argparse
import csv
import json
import statistics
import sys
import time
from collections import defaultdict
from dataclasses import asdict, replace
from pathlib import Path

_ROOT = Path(__file__).resolve().parents[3]
if (_ROOT / "src").is_dir() and str(_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(_ROOT / "src"))

import dynamic
import fuzz_cli
import fuzz_reports
from coverage_fuzz import STRATEGIES, FuzzConfig, Progress, fuzz
from fuzz_inputs import InputSpace, interesting_integers

import jpamb
from jpamb.confidentiality import Config

FORMAT = "jpamb-fuzz-evaluation"
VERSION = 1


class ProgressRecorder:
    """Keep discovery/coverage changes, phase boundaries, and final observation."""

    def __init__(self):
        self.checkpoints: list[Progress] = []
        self.last: Progress | None = None
        self.seed_last: Progress | None = None
        self.first_finding: Progress | None = None
        self.first_search_finding: Progress | None = None

    def __call__(self, event: Progress):
        previous = self.last
        if event.phase == "seed":
            self.seed_last = event
        if event.findings and self.first_finding is None:
            self.first_finding = event
        if (
            event.phase == "search"
            and event.findings > (previous.findings if previous else 0)
            and self.first_search_finding is None
        ):
            self.first_search_finding = event
        if previous and event.phase != previous.phase:
            self._append(previous)
        if (
            previous is None
            or event.phase != previous.phase
            or event.findings != previous.findings
            or event.coverage_locations != previous.coverage_locations
        ):
            self._append(event)
        self.last = event

    def _append(self, event):
        if not self.checkpoints or self.checkpoints[-1].execution != event.execution:
            self.checkpoints.append(event)

    def finish(self):
        if self.last:
            self._append(self.last)
        return [asdict(event) for event in self.checkpoints]


def trial_metrics(campaign, progress: ProgressRecorder):
    """Null discovery costs mean censored observations, never a zero-cost success."""
    seed = progress.seed_last
    first = progress.first_finding
    later = progress.first_search_finding
    seed_executions = seed.execution if seed else 0
    seed_steps = seed.steps if seed else 0
    seed_findings = seed.findings if seed else 0
    return {
        "method": campaign.method_id.encode(),
        "strategy": campaign.strategy,
        "random_seed": campaign.config.seed,
        "found": bool(campaign.findings),
        "first_finding_phase": first.phase if first else None,
        "first_finding_execution": first.execution if first else None,
        "first_finding_steps": first.steps if first else None,
        "first_finding_seconds": first.elapsed_seconds if first else None,
        "censored": not campaign.findings,
        "executions": campaign.executions,
        "steps": campaign.steps,
        "elapsed_seconds": campaign.elapsed_seconds,
        "seed_executions": seed_executions,
        "seed_steps": seed_steps,
        "seed_findings": seed_findings,
        "seed_coverage_locations": seed.coverage_locations if seed else 0,
        "search_executions": campaign.executions - seed_executions,
        "search_steps": campaign.steps - seed_steps,
        "search_new_findings": len(campaign.findings) - seed_findings,
        "search_executions_to_new_finding": (
            later.execution - seed_executions if later else None
        ),
        "search_steps_to_new_finding": later.steps - seed_steps if later else None,
        "distinct_findings": len(campaign.findings),
        "violation_locations": len({item.violation.pc for item in campaign.findings}),
        "coverage_locations": len(campaign.coverage),
        "completed_runs": campaign.completed_runs,
        "limited_runs": campaign.limited_runs,
        "unsupported_runs": campaign.unsupported_runs,
        "stop_reason": campaign.stop_reason,
    }


def aggregate(rows):
    """Summarize per method/strategy; preserve failures in detection denominators."""
    grouped = defaultdict(list)
    for row in rows:
        grouped[(row["method"], row["strategy"])].append(row)
    summaries = []
    for (method, strategy), trials in sorted(grouped.items()):
        successes = [row for row in trials if row["found"]]
        searching = [row for row in trials if row["search_executions"] > 0]
        summaries.append(
            {
                "method": method,
                "strategy": strategy,
                "trials": len(trials),
                "found_trials": len(successes),
                "not_found_trials": len(trials) - len(successes),
                "found_fraction": len(successes) / len(trials),
                "seed_found_trials": sum(row["seed_findings"] > 0 for row in trials),
                "trials_reaching_search": len(searching),
                "search_new_finding_trials": sum(
                    row["search_new_findings"] > 0 for row in trials
                ),
                "search_new_finding_fraction": (
                    sum(row["search_new_findings"] > 0 for row in searching)
                    / len(searching)
                    if searching
                    else None
                ),
                "median_first_finding_executions_on_success": (
                    statistics.median(
                        row["first_finding_execution"] for row in successes
                    )
                    if successes
                    else None
                ),
                "median_first_finding_steps_on_success": (
                    statistics.median(row["first_finding_steps"] for row in successes)
                    if successes
                    else None
                ),
                **{
                    f"mean_{field}": statistics.mean(row[field] for row in trials)
                    for field in (
                        "coverage_locations",
                        "distinct_findings",
                        "violation_locations",
                        "executions",
                        "steps",
                        "elapsed_seconds",
                        "completed_runs",
                        "limited_runs",
                        "unsupported_runs",
                    )
                },
            }
        )
    return summaries


def paired_comparisons(rows):
    """Pair strategies by method and RNG seed rather than pooling unlike targets."""
    grouped = defaultdict(dict)
    for row in rows:
        grouped[(row["method"], row["random_seed"])][row["strategy"]] = row
    pairs = defaultdict(
        lambda: {
            "both_found": 0,
            "guided_only_found": 0,
            "baseline_only_found": 0,
            "neither_found": 0,
        }
    )
    for (method, _), strategies in sorted(grouped.items()):
        guided = strategies.get("coverage-guided")
        if guided is None:
            continue
        for name in STRATEGIES:
            if name == "coverage-guided" or name not in strategies:
                continue
            baseline = strategies[name]
            key = (
                "both_found"
                if guided["found"] and baseline["found"]
                else "guided_only_found"
                if guided["found"]
                else "baseline_only_found"
                if baseline["found"]
                else "neither_found"
            )
            pairs[(method, name)][key] += 1
    return [
        {"method": method, "baseline": name, **counts}
        for (method, name), counts in sorted(pairs.items())
    ]


def load_targets(path):
    document = json.loads(Path(path).read_text(encoding="utf-8"))
    if (
        not isinstance(document, dict)
        or document.get("format") != "jpamb-fuzz-targets"
        or type(document.get("schema_version")) is not int
        or document["schema_version"] != 1
        or not isinstance(document.get("methods"), list)
    ):
        raise ValueError("expected a jpamb-fuzz-targets version 1 manifest")
    return validate_targets(document["methods"])


def validate_targets(names):
    if not names or any(not isinstance(name, str) for name in names):
        raise ValueError("supply at least one method identifier")
    methods = [jpamb.parse_methodid(name) for name in names]
    if len(set(methods)) != len(methods):
        raise ValueError("duplicate target methods")
    return methods


def _replace_table(temporary, destination):
    # Windows readers/virus scanners can briefly deny replacement of an open file.
    for attempt in range(10):
        try:
            temporary.replace(destination)
            return
        except PermissionError:
            if attempt == 9:
                raise
            time.sleep(0.05)


def _write_tables(output, rows, metadata):
    # Called after each complete trial: interrupted runs retain completed evidence.
    summary = {
        "format": FORMAT,
        "schema_version": VERSION,
        **metadata,
        "completed_trials": len(rows),
        "groups": aggregate(rows),
        "paired_comparisons": paired_comparisons(rows),
    }
    for name, document in (("summary.json", summary), ("trials.json", rows)):
        path = output / name
        temporary = path.with_suffix(".tmp")
        temporary.write_text(
            json.dumps(document, indent=2, sort_keys=True, allow_nan=False) + "\n",
            encoding="utf-8",
        )
        _replace_table(temporary, path)
    if rows:
        temporary = output / "trials.csv.tmp"
        with temporary.open("w", encoding="utf-8", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)
        _replace_table(temporary, output / "trials.csv")


def evaluate(
    methods,
    *,
    suite_root,
    output,
    config,
    random_seeds,
    strategies=STRATEGIES,
    security_config=None,
):
    """Run a predeclared target set; exceptions propagate instead of becoming misses."""
    methods = validate_targets([method.encode() for method in methods])
    random_seeds = tuple(random_seeds)
    strategies = tuple(strategies)
    if (
        not random_seeds
        or any(type(seed) is not int for seed in random_seeds)
        or len(set(random_seeds)) != len(random_seeds)
    ):
        raise ValueError("random seeds must be distinct integers")
    if (
        not strategies
        or any(name not in STRATEGIES for name in strategies)
        or len(set(strategies)) != len(strategies)
    ):
        raise ValueError("strategies must be distinct known strategy names")
    output = Path(output)
    if output.exists() and (not output.is_dir() or any(output.iterdir())):
        raise ValueError("evaluation output must be a new or empty directory")
    settings = security_config if security_config is not None else Config()
    if not isinstance(settings, Config):
        raise TypeError("evaluation requires jpamb.confidentiality.Config settings")
    contexts = []
    # Validate all targets before starting; neither @Case values nor outcomes are read.
    for method in methods:
        suite, bytecode, policy = fuzz_cli._context(suite_root, method)
        if policy is None or "conf" not in policy.product_lattice.lattices:
            raise ValueError(f"target has no confidentiality policy: {method}")
        constants, _ = dynamic.collect_constants(bytecode, method)
        space = InputSpace(
            tuple(method.extension.params), interesting_integers(constants)
        )
        seeds = dynamic.build_seeds(space, constants)
        contexts.append((method, suite, bytecode, policy, space, seeds))
    output.mkdir(parents=True, exist_ok=True)
    metadata = {
        "methods": [method.encode() for method in methods],
        "random_seeds": list(random_seeds),
        "strategies": list(strategies),
        "configuration": asdict(config),
        "confidentiality": asdict(settings),
        "expected_trials": len(methods) * len(random_seeds) * len(strategies),
        "complete": False,
        "notes": [
            "Concrete policy violations; no hypothetical hybrid pre-taint.",
            "Initial seeds are shared and charged to all budgets.",
            "Null discovery costs are censored; not-found is not proof of safety.",
            "Timing includes search/observation and lazy runner setup, excludes report I/O.",
            "Instruction coverage counts visited locations, not paths or a proof of completeness.",
            "Success-only discovery medians exclude misses; read alongside detection fractions.",
        ],
    }
    rows = []
    _write_tables(output, rows, metadata)
    for method_index, (method, suite, bytecode, policy, space, seeds) in enumerate(
        contexts
    ):
        for trial_index, seed in enumerate(random_seeds):
            # Rotate which strategy runs first; instruction/execution caps remain primary.
            offset = (method_index + trial_index) % len(strategies)
            order = strategies[offset:] + strategies[:offset]
            for strategy in order:
                trial_config = replace(config, seed=seed)
                recorder = ProgressRecorder()
                campaign = fuzz(
                    method,
                    space,
                    dynamic.make_runner(bytecode, policy),
                    config=trial_config,
                    security_config=settings,
                    seeds=seeds,
                    strategy=strategy,
                    observer=recorder,
                )
                row = trial_metrics(campaign, recorder)
                relative = f"campaigns/{len(rows) + 1:05d}.json"
                row["report"] = relative
                report = fuzz_reports.create_report(
                    campaign,
                    suite=suite,
                    bytecode=bytecode,
                    input_space=space,
                    seed_inputs=seeds,
                    producer="coverage-fuzz-evaluate",
                    producer_version=str(VERSION),
                    generator="typed-search-v1/boundary-seeds",
                )
                report.document["evaluation"] = {
                    "schema_version": VERSION,
                    "metrics": row,
                    "progress": recorder.finish(),
                }
                fuzz_reports.write_report(report, output / relative)
                rows.append(row)
                _write_tables(output, rows, metadata)
                print(
                    f"[{len(rows)}/{metadata['expected_trials']}] {method} "
                    f"seed={seed} {strategy}: {len(campaign.findings)} findings, "
                    f"{campaign.executions} inputs, {campaign.steps} steps",
                    file=sys.stderr,
                )
    metadata["complete"] = True
    _write_tables(output, rows, metadata)
    return rows


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    targets = parser.add_mutually_exclusive_group(required=True)
    targets.add_argument(
        "--manifest", type=Path, help="JSON file listing target methods"
    )
    targets.add_argument(
        "--method", action="append", help="repeat for multiple methods"
    )
    parser.add_argument("--suite", type=Path, default=Path.cwd())
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seeds", type=int, nargs="+", default=[0, 1, 2, 3, 4])
    parser.add_argument(
        "--strategies", choices=STRATEGIES, nargs="+", default=STRATEGIES
    )
    parser.add_argument("--executions", type=int, default=300)
    parser.add_argument("--step-limit", type=int, default=2500)
    parser.add_argument("--max-steps", type=int, default=100_000)
    parser.add_argument(
        "--seed-limit",
        type=int,
        default=80,
        help="shared initial input cap, charged to budgets (default: 80)",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        help="optional cooperative deadline per trial; default: none",
    )
    parser.add_argument("--return-clearance")
    parser.add_argument(
        "--local-clearance", action="append", default=[], metavar="SLOT=LEVEL"
    )
    args = parser.parse_args(argv)
    try:
        methods = (
            load_targets(args.manifest)
            if args.manifest
            else validate_targets(args.method)
        )
        rows = evaluate(
            methods,
            suite_root=args.suite,
            output=args.output,
            config=FuzzConfig(
                max_executions=args.executions,
                step_limit=args.step_limit,
                max_steps=args.max_steps,
                seed_limit=args.seed_limit,
                timeout_seconds=args.timeout,
            ),
            random_seeds=args.seeds,
            strategies=args.strategies,
            security_config=Config(
                return_clearance=args.return_clearance,
                local_clearances=fuzz_cli._local_settings(args.local_clearance),
            ),
        )
    except (OSError, ValueError, TypeError, IndexError) as exc:
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

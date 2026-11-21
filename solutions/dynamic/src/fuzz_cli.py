"""Run/save a confidentiality campaign or replay findings from a saved report."""

import argparse
import json
import sys
from pathlib import Path

# Direct source-checkout use does not require an editable package installation.
_ROOT_SRC = Path(__file__).resolve().parents[3] / "src"
if _ROOT_SRC.is_dir() and str(_ROOT_SRC) not in sys.path:
    sys.path.insert(0, str(_ROOT_SRC))

import dynamic
import fuzz_reports
from coverage_fuzz import FuzzConfig, fuzz
from fuzz_inputs import InputSpace, interesting_integers

import jpamb
from jpamb.confidentiality import Config
from jpamb.utils import Effect


def _context(root, method):
    suite = jpamb.Suite.from_workdir(Path(root).resolve())
    effect = Effect(None)
    bytecode = jpamb.Bytecode(suite, effect, {})
    try:
        policy = suite.security_policy(method.classname, eff=effect)
        bytecode.getmethod(method)
    except FileNotFoundError as exc:
        raise fuzz_reports.ReportError(
            "compiled/decompiled program is missing; run the JPAMB build first"
        ) from exc
    return suite, bytecode, policy


def _runner(mode, bytecode, policy):
    if mode == "concrete":
        return dynamic.make_runner(bytecode, policy)
    hybrid_src = Path(__file__).resolve().parents[2] / "hybrid" / "src"
    if hybrid_src.is_dir() and str(hybrid_src) not in sys.path:
        sys.path.insert(0, str(hybrid_src))
    try:
        import hybrid
    except ModuleNotFoundError as exc:
        raise fuzz_reports.ReportError(
            "hypothetical replay requires the hybrid analyzer and its parser dependencies"
        ) from exc
    return hybrid.make_hybrid_runner(bytecode, policy, hybrid_branch_taint=True)


def _local_settings(entries):
    result = {}
    for entry in entries:
        slot, separator, clearance = entry.partition("=")
        if not separator or not slot.isdecimal() or not clearance:
            raise fuzz_reports.ReportError("use --local-clearance SLOT=LEVEL")
        slot = int(slot)
        if slot in result:
            raise fuzz_reports.ReportError(f"duplicate clearance for local slot {slot}")
        result[slot] = clearance
    return result


def _run(args):
    method = jpamb.parse_methodid(args.method)
    suite, bytecode, policy = _context(args.suite, method)
    if policy is None or "conf" not in policy.product_lattice.lattices:
        raise fuzz_reports.ReportError(
            "campaigns require a declared confidentiality lattice"
        )
    constants, _ = dynamic.collect_constants(bytecode, method)
    space = InputSpace(tuple(method.extension.params), interesting_integers(constants))
    seeds = dynamic.build_seeds(space, constants)
    config = FuzzConfig(
        max_executions=args.executions,
        step_limit=args.step_limit,
        max_steps=args.max_steps,
        timeout_seconds=args.timeout,
        seed=args.seed,
        seed_limit=args.seed_limit
        if args.seed_limit is not None
        else max(1, len(seeds)),
    )
    security = Config(
        return_clearance=args.return_clearance,
        local_clearances=_local_settings(args.local_clearance),
    )
    campaign = fuzz(
        method,
        space,
        _runner(args.mode, bytecode, policy),
        config=config,
        security_config=security,
        seeds=seeds,
    )
    report = fuzz_reports.create_report(
        campaign,
        suite=suite,
        bytecode=bytecode,
        input_space=space,
        seed_inputs=seeds,
        mode=args.mode,
        producer="coverage-fuzz",
        producer_version=dynamic.VERSION,
        generator="typed-mutation-v1/boundary-seeds",
    )
    path = fuzz_reports.write_report(report, args.output)
    print(
        json.dumps(
            {
                "report": str(path),
                "evidence_kind": report.document["evidence_kind"],
                "findings": len(report.findings),
                "summary": {
                    **{
                        key: value
                        for key, value in report.document["summary"].items()
                        if key != "coverage"
                    },
                    "coverage_locations": len(campaign.coverage),
                },
            },
            indent=2,
        )
    )
    return 0


def _replay(args):
    report = fuzz_reports.read_report(args.report)
    if not report.findings:
        raise fuzz_reports.ReportError("report contains no findings to replay")
    root = (
        args.suite
        if args.suite is not None
        else report.document["program"]["suite_root"]
    )
    suite = jpamb.Suite.from_workdir(Path(root).resolve())
    fuzz_reports.verify_program(report, suite)
    suite, bytecode, policy = _context(suite.workdir, report.method_id)
    runner = _runner(report.mode, bytecode, policy)
    numbers = (
        [args.finding]
        if args.finding is not None
        else range(1, len(report.findings) + 1)
    )
    results = [
        fuzz_reports.replay_finding(report, number, runner) for number in numbers
    ]
    print(
        json.dumps(
            {
                "report": str(args.report),
                "evidence_kind": report.document["evidence_kind"],
                "all_matched": all(item.matched for item in results),
                "results": [
                    {
                        "finding": item.finding,
                        "matched": item.matched,
                        "input": report.findings[item.finding - 1].inputs.encode(),
                        "status": item.observed.status,
                        "outcome": item.observed.outcome,
                        "steps": item.observed.steps,
                        "reason": item.reason,
                    }
                    for item in results
                ],
            },
            indent=2,
        )
    )
    return 0 if all(item.matched for item in results) else 1


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    run = commands.add_parser("run", help="run a campaign and save its JSON report")
    run.add_argument("method", help="JPAMB method identifier")
    run.add_argument("--output", type=Path, required=True)
    run.add_argument("--suite", type=Path, default=Path.cwd())
    run.add_argument("--mode", choices=tuple(fuzz_reports.MODES), default="concrete")
    run.add_argument("--executions", type=int, default=100)
    run.add_argument("--step-limit", type=int, default=2500)
    run.add_argument("--max-steps", type=int, help="total instruction budget")
    run.add_argument("--timeout", type=float, default=2.0)
    run.add_argument("--seed", type=int, default=0)
    run.add_argument("--seed-limit", type=int)
    run.add_argument("--return-clearance")
    run.add_argument(
        "--local-clearance", action="append", default=[], metavar="SLOT=LEVEL"
    )
    replay = commands.add_parser(
        "replay", help="re-execute saved findings with recorded settings"
    )
    replay.add_argument("report", type=Path)
    replay.add_argument(
        "--finding", type=int, help="one-based finding ID; default: all"
    )
    replay.add_argument(
        "--suite", type=Path, help="override the saved checkout location"
    )
    args = parser.parse_args(argv)
    try:
        return _run(args) if args.command == "run" else _replay(args)
    except (OSError, ValueError, TypeError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""
Reproducible End-to-End Empirical & Statistical Evaluation for the JPAMB Confidentiality Suite.

Runs and validates:
1. Domain & benchmark selection audit across all JPAMB case classes (@Lattice/@Sec vs. standard).
2. Official `jpamb analyse -N 3` CLI runs for all 4 Python analyzers:
   - Syntactic (`project-syntactic-confidentiality`)
   - Unbounded Static (`project-unbounded-confidentiality`: Interval x SignSet x SecurityLabel)
   - Dynamic (`dynamic`: 32-bit concrete bytecode + shadow monitor + coverage-guided fuzzing)
   - Hybrid (`hybrid`: Syntactic AST triage + Dynamic fuzzing + separate counterfactual pre-taint)
3. In-process verdict, transfer/execution cost, ablation (label-only, interval-only, no-widening),
   and repeated warm runtime measurements across all @Lattice benchmark methods.
4. Paired multi-seed fuzzing campaigns (seeds 0..19, 300 executions, 100k total steps, 2.5k/run)
   comparing Dictionary (D), Unguided (U), Coverage-Guided (G), and Hybrid (H) on the 18
   challenge/control/nested-loop methods, plus budget-triage evaluation across all safe methods.
5. Independent ground-truth verification of EVERY discovered concrete leak witness on the real
   ASM-instrumented JVM (`jpamb.Runtime` + `BytecodeInstrumenter` + `SecurityMonitor`).
6. Formal statistical analysis:
   - Confusion matrices (TP, FP, FN, TN, Unknown), Precision, Recall, FPR, FNR, F1, Wilson 95% CIs
   - Exact two-sided McNemar tests (per method over 20 paired seeds)
   - Exact paired Wilcoxon signed-rank tests (collapsing 3-variant families per seed to avoid
     pseudo-replication, with mid-rank tie handling and exact DP p-values)
   - Effect sizes (risk difference, Cohen's h, rank-biserial correlation r_rb), 10,000-resample
     paired bootstrap 95% CIs, and Holm-Bonferroni multiple-testing correction
   - Coverage vs. discovery correlation and mechanism breakdown.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
import os
import random
import statistics
import subprocess
import sys
import time
from collections import Counter, defaultdict
from dataclasses import asdict, replace
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
_EXTRA_PATHS = [
    str(ROOT / rel)
    for rel in (
        "src",
        "solutions/dynamic/src",
        "solutions/project-syntactic-confidentiality/src",
        "solutions/project-unbounded-confidentiality/src",
        "solutions/hybrid/src",
    )
]
for p in _EXTRA_PATHS:
    if p not in sys.path:
        sys.path.insert(0, p)
os.environ["PYTHONPATH"] = os.pathsep.join(
    _EXTRA_PATHS + ([os.environ["PYTHONPATH"]] if os.environ.get("PYTHONPATH") else [])
)

import coverage_fuzz  # noqa: E402
import dynamic as dyn_mod  # noqa: E402
import fuzz_inputs  # noqa: E402
import hybrid as hyb_mod  # noqa: E402
import jpamb  # noqa: E402
import jpamb.analyse  # noqa: E402
import jpamb.confidentiality as pure_conf  # noqa: E402
import jvm  # noqa: E402
import sexpr  # noqa: E402
import syntactic_confidentiality as syn_mod  # noqa: E402
import tree_sitter  # noqa: E402
from jpamb.case import Experiment  # noqa: E402
from unbounded_confidentiality import interpreter as unb_interp  # noqa: E402


# =============================================================================
# 1. Exact Statistical Primitives (Zero-approximation where tractable)
# =============================================================================


def wilson_ci(k: int, n: int, z: float = 1.959963984540054) -> tuple[float, float]:
    """95% Wilson score confidence interval for a binomial proportion k/n."""
    if n <= 0:
        return (0.0, 0.0)
    p = k / n
    denom = 1.0 + (z * z) / n
    center = (p + (z * z) / (2.0 * n)) / denom
    half = (z / denom) * math.sqrt((p * (1.0 - p)) / n + (z * z) / (4.0 * n * n))
    return (max(0.0, center - half), min(1.0, center + half))


def cohens_h(p1: float, p2: float) -> float:
    """Cohen's h effect size for difference between two proportions."""
    p1 = min(1.0, max(0.0, p1))
    p2 = min(1.0, max(0.0, p2))
    return 2.0 * math.asin(math.sqrt(p1)) - 2.0 * math.asin(math.sqrt(p2))


def exact_mcnemar_test(n10: int, n01: int) -> float:
    """Exact two-sided binomial McNemar p-value for discordant counts (n10, n01)."""
    b = n10 + n01
    if b == 0:
        return 1.0
    k = min(n10, n01)
    # Sum exact binomial probabilities <= k using log-space or math.comb
    total = sum(math.comb(b, i) for i in range(k + 1))
    p_two = 2.0 * (total / (2**b))
    return min(1.0, p_two)


def exact_wilcoxon_signed_rank(diffs: list[float]) -> dict[str, float]:
    """Paired Wilcoxon signed-rank test with mid-ranks for ties and exact sign-flip p-value
    for len(non_zero) <= 25 (normal approximation with tie correction above 25).
    Also returns rank-biserial correlation r_rb in [-1, 1].
    """
    nz = [float(d) for d in diffs if abs(d) > 1e-12]
    m = len(nz)
    if m == 0:
        return {
            "n_pairs": len(diffs),
            "n_nonzero": 0,
            "w_plus": 0.0,
            "w_minus": 0.0,
            "statistic": 0.0,
            "p_value": 1.0,
            "rank_biserial": 0.0,
        }

    # Sort by absolute magnitude and assign average mid-ranks (1-indexed)
    indexed = sorted(enumerate(nz), key=lambda kv: abs(kv[1]))
    ranks = [0.0] * m
    tie_groups: list[int] = []
    i = 0
    while i < m:
        j = i + 1
        while j < m and math.isclose(abs(indexed[j][1]), abs(indexed[i][1]), rel_tol=1e-12, abs_tol=1e-12):
            j += 1
        avg_rank = 0.5 * ((i + 1) + j)
        for k in range(i, j):
            ranks[indexed[k][0]] = avg_rank
        tie_groups.append(j - i)
        i = j

    w_plus = sum(r for r, d in zip(ranks, nz) if d > 0)
    w_minus = sum(r for r, d in zip(ranks, nz) if d < 0)
    total_rank = 0.5 * m * (m + 1)
    r_rb = (w_plus - w_minus) / total_rank if total_rank > 0 else 0.0
    w_min = min(w_plus, w_minus)

    if m <= 25:
        # Exact sign-flip distribution over 2^m configurations using integer doubled ranks
        # (since mid-ranks are always multiples of 0.5, 2 * rank is an exact integer!)
        int_ranks = [int(round(2.0 * r)) for r in ranks]
        target_plus = int(round(2.0 * w_plus))
        target_total = sum(int_ranks)
        # DP over possible sums of positive ranks
        dp: dict[int, int] = {0: 1}
        for ir in int_ranks:
            nxt: dict[int, int] = dict(dp)
            for s, cnt in dp.items():
                nxt[s + ir] = nxt.get(s + ir, 0) + cnt
            dp = nxt
        obs_dev = abs(2 * target_plus - target_total)
        extreme = sum(cnt for s, cnt in dp.items() if abs(2 * s - target_total) >= obs_dev)
        p_val = min(1.0, extreme / (2**m))
    else:
        mean_w = m * (m + 1) / 4.0
        tie_corr = sum(t * (t * t - 1) for t in tie_groups) / 48.0
        var_w = m * (m + 1) * (2 * m + 1) / 24.0 - tie_corr
        if var_w <= 0:
            p_val = 1.0
        else:
            # Continuity correction
            z = (abs(w_plus - mean_w) - 0.5) / math.sqrt(var_w)
            p_val = min(1.0, math.erfc(max(0.0, z) / math.sqrt(2.0)))

    return {
        "n_pairs": len(diffs),
        "n_nonzero": m,
        "w_plus": w_plus,
        "w_minus": w_minus,
        "statistic": w_min,
        "p_value": p_val,
        "rank_biserial": r_rb,
    }


def paired_bootstrap_ci(
    diffs: list[float], n_boot: int = 10_000, seed: int = 42, stat: str = "mean"
) -> tuple[float, float]:
    """Percentile paired bootstrap 95% CI for mean or median difference."""
    if not diffs:
        return (0.0, 0.0)
    n = len(diffs)
    if all(abs(d - diffs[0]) < 1e-15 for d in diffs):
        return (float(diffs[0]), float(diffs[0]))
    rng = random.Random(seed)
    samples: list[float] = []
    for _ in range(n_boot):
        draw = [diffs[rng.randrange(n)] for _ in range(n)]
        samples.append(statistics.mean(draw) if stat == "mean" else statistics.median(draw))
    samples.sort()
    lo_idx = int(0.025 * n_boot)
    hi_idx = min(n_boot - 1, int(0.975 * n_boot))
    return (samples[lo_idx], samples[hi_idx])


def holm_bonferroni(p_values: list[float]) -> list[float]:
    """Holm-Bonferroni step-down adjusted p-values preserving original order."""
    m = len(p_values)
    if m == 0:
        return []
    order = sorted(range(m), key=lambda i: p_values[i])
    adjusted = [0.0] * m
    running_max = 0.0
    for rank, idx in enumerate(order):
        adj = (m - rank) * p_values[idx]
        running_max = max(running_max, adj)
        adjusted[idx] = min(1.0, running_max)
    return adjusted


def spearman_rho(xs: list[float], ys: list[float]) -> float:
    """Spearman rank correlation with average mid-ranks for ties."""
    assert len(xs) == len(ys)
    n = len(xs)
    if n < 2:
        return 0.0

    def rank_vec(vals: list[float]) -> list[float]:
        idx = sorted(range(n), key=lambda i: vals[i])
        out = [0.0] * n
        i = 0
        while i < n:
            j = i + 1
            while j < n and math.isclose(vals[idx[j]], vals[idx[i]], rel_tol=1e-12, abs_tol=1e-12):
                j += 1
            avg = 0.5 * ((i + 1) + j)
            for k in range(i, j):
                out[idx[k]] = avg
            i = j
        return out

    rx = rank_vec(xs)
    ry = rank_vec(ys)
    mx = statistics.mean(rx)
    my = statistics.mean(ry)
    num = sum((a - mx) * (b - my) for a, b in zip(rx, ry))
    den_x = math.sqrt(sum((a - mx) ** 2 for a in rx))
    den_y = math.sqrt(sum((b - my) ** 2 for b in ry))
    if den_x == 0 or den_y == 0:
        return 0.0
    return num / (den_x * den_y)


def summary_stats(values: list[float]) -> dict[str, float]:
    """Median, Q1, Q3, IQR, Mean, SD, Min, Max."""
    if not values:
        return {k: 0.0 for k in ("n", "median", "q1", "q3", "iqr", "mean", "sd", "min", "max")}
    sv = sorted(values)
    n = len(sv)
    med = statistics.median(sv)
    if n >= 4:
        qs = statistics.quantiles(sv, n=4, method="inclusive")
        q1, q3 = qs[0], qs[2]
    else:
        q1, q3 = sv[0], sv[-1]
    sd = statistics.stdev(sv) if n >= 2 else 0.0
    return {
        "n": n,
        "median": med,
        "q1": q1,
        "q3": q3,
        "iqr": q3 - q1,
        "mean": statistics.mean(sv),
        "sd": sd,
        "min": sv[0],
        "max": sv[-1],
    }


# =============================================================================
# 2. Domain Audit & Ground Truth Loader
# =============================================================================


def audit_suite(suite: jpamb.Suite, eff: jpamb.Effect) -> dict[str, Any]:
    benchmark = suite.benchmark(eff=eff)
    cases_by_method: dict[jvm.AbsMethodID, list[jpamb.case.Case]] = defaultdict(list)
    for c in suite.cases(eff=eff):
        cases_by_method[c.methodid].append(c)

    included_classes = []
    excluded_classes = []
    security_methods: list[jvm.AbsMethodID] = []

    all_classes = sorted(
        {m.classname for m in benchmark.entries()}, key=lambda cn: str(cn)
    )
    for cn in all_classes:
        mids = sorted(
            [m for m in benchmark.entries() if m.classname == cn],
            key=lambda m: m.encode(),
        )
        policy = suite.security_policy(cn, eff=eff)
        case_count = sum(len(cases_by_method[m]) for m in mids)
        param_types = sorted(
            {t.encode() for m in mids for t in m.extension.params}
        )
        if policy is not None:
            lat = policy.product_lattice.lattices["conf"]
            included_classes.append(
                {
                    "class": str(cn),
                    "methods": len(mids),
                    "cases": case_count,
                    "levels": list(lat.levels),
                    "bot": lat.bot,
                    "top": lat.top,
                    "param_types": param_types,
                }
            )
            security_methods.extend(mids)
        else:
            reason = (
                "Two-run self-composition via manual Java assert; no @Lattice/@Sec annotations"
                if str(cn).endswith("InformationFlow")
                else "Standard JPAMB runtime-error/termination benchmark without @Lattice/@Sec policy"
            )
            excluded_classes.append(
                {
                    "class": str(cn),
                    "methods": len(mids),
                    "cases": case_count,
                    "param_types": param_types,
                    "reason": reason,
                }
            )

    ground_truth: dict[str, dict[str, Any]] = {}
    for mid in security_methods:
        exp = benchmark.experiments[Experiment(mid, None)]
        expected = sorted(exp.results)
        ground_truth[mid.encode()] = {
            "method": mid.encode(),
            "class": str(mid.classname),
            "short_name": f"{str(mid.classname).split('.')[-1]}.{mid.extension.name}",
            "expected_outcomes": expected,
            "has_leak": "assertion error" in exp.results,
            "can_ok": "ok" in exp.results,
            "cases": [
                {"input": c.input.encode(), "result": c.result}
                for c in cases_by_method[mid]
            ],
        }

    return {
        "included_classes": included_classes,
        "excluded_classes": excluded_classes,
        "total_included_methods": len(security_methods),
        "total_excluded_methods": sum(c["methods"] for c in excluded_classes),
        "total_leaking_methods": sum(1 for g in ground_truth.values() if g["has_leak"]),
        "total_safe_methods": sum(1 for g in ground_truth.values() if not g["has_leak"]),
        "ground_truth": ground_truth,
    }


# =============================================================================
# 3. Official JPAMB CLI Evaluation (-N 3)
# =============================================================================


ANALYZER_COMMANDS = {
    "syntactic": (
        str(ROOT / "solutions/project-syntactic-confidentiality/.venv/bin/python"),
        str(ROOT / "solutions/project-syntactic-confidentiality/src/syntactic_confidentiality.py"),
    ),
    "unbounded": (
        str(ROOT / "solutions/project-unbounded-confidentiality/.venv/bin/python"),
        str(ROOT / "solutions/project-unbounded-confidentiality/src/unbounded_analysis.py"),
    ),
    "dynamic": (
        str(ROOT / "solutions/dynamic/.venv/bin/python"),
        str(ROOT / "solutions/dynamic/src/dynamic.py"),
    ),
    "hybrid": (
        str(ROOT / "solutions/hybrid/.venv/bin/python"),
        str(ROOT / "solutions/hybrid/src/hybrid.py"),
    ),
}


def run_official_jpamb_cli(
    suite: jpamb.Suite,
    eff: jpamb.Effect,
    security_methods: list[jvm.AbsMethodID],
    output_dir: Path,
    iterations: int = 3,
    only_analyzers: set[str] | None = None,
) -> dict[str, Any]:
    """Run JPAMB's exact `analyse` scoring loop (`iterations=3`) over the security benchmark set."""
    benchmark = suite.benchmark(eff=eff)
    cli_results: dict[str, Any] = {}
    silent_eff = jpamb.Effect(None)

    for name, cmd in ANALYZER_COMMANDS.items():
        if only_analyzers is not None and name not in only_analyzers:
            continue
        print(f"[CLI] Running official JPAMB analyse (N={iterations}) for {name}...", file=sys.stderr, flush=True)
        cfg = jpamb.analyse.Config.from_cmd(
            cmd,
            security_methods,
            timeout=30.0,
            iterations=iterations,
            eff=silent_eff,
        )
        state = jpamb.analyse.State(cfg)
        step_idx = 0
        total_cli_steps = len(security_methods) * iterations
        while state.run_next(benchmark=benchmark, workdir=ROOT, eff=silent_eff) is not None:
            step_idx += 1
            if step_idx % 100 == 0 or step_idx == total_cli_steps:
                print(f"  [{name}] {step_idx}/{total_cli_steps} CLI runs completed", file=sys.stderr, flush=True)
        summary = state.summary()
        scored = summary.score_results(benchmark=benchmark, eff=silent_eff)

        report_path = output_dir / f"jpamb-cli-{name}.sexp"
        report_path.write_text(sexpr.pretty(summary.__sexpr__(), indent=2), encoding="utf-8")

        per_method_abs_ms: list[float] = []
        per_method_rel_db: list[float] = []
        per_method_scores: dict[str, float] = {}
        per_method_times_ms: dict[str, float] = {}

        categories_wager = {
            k: v.wager() for k, v in summary.calculate_categories(benchmark=benchmark).items()
        }
        for mid, res_list in summary.results.items():
            expected = benchmark.experiments[Experiment(mid, None)].results
            m_score = statistics.mean(
                r.response.score(expected, categories_wager) for r in res_list
            )
            m_ms = statistics.mean(r.duration.absolute / 1e6 for r in res_list)
            m_db = statistics.mean(r.duration.relative for r in res_list)
            per_method_scores[mid.encode()] = m_score
            per_method_times_ms[mid.encode()] = m_ms
            per_method_abs_ms.append(m_ms)
            per_method_rel_db.append(m_db)

        cats_info = {}
        for cat, tracker in scored.categories.items():
            w = tracker.wager()
            false_contrib = w.score(False) * tracker.misses if tracker.misses else 0.0
            true_contrib = w.score(True) * tracker.hits if tracker.hits else 0.0
            cats_info[cat.name] = {
                "hits": tracker.hits / iterations,
                "misses": tracker.misses / iterations,
                "probability": w.to_probability(),
                "wager": w.wager if math.isfinite(w.wager) else str(w.wager),
                "score_contribution": (false_contrib + true_contrib) / iterations,
            }

        cli_results[name] = {
            "total_score": scored.total_score,
            "mean_rel_time_db": scored.mean_rel_time,
            "total_abs_time_s": scored.total_abs_time / 1e9,
            "invalid": scored.invalid,
            "time_ms_stats": summary_stats(per_method_abs_ms),
            "rel_db_stats": summary_stats(per_method_rel_db),
            "categories": cats_info,
            "per_method_score": per_method_scores,
            "per_method_time_ms": per_method_times_ms,
        }
    return cli_results


# =============================================================================
# 4. In-Process Detailed Method-Level Evaluation & Ablations
# =============================================================================


def evaluate_in_process_all_methods(
    suite: jpamb.Suite,
    eff: jpamb.Effect,
    security_methods: list[jvm.AbsMethodID],
    ground_truth: dict[str, dict[str, Any]],
    warm_repeats: int = 5,
) -> tuple[dict[str, dict[str, Any]], set[tuple[str, str]]]:
    """Run all 4 analyzers + static ablations in-process on every security method.
    Collects exact verdicts, diagnostics, transfers/executions, coverage, warm runtimes,
    and concrete witness pairs for JVM oracle verification.
    """
    bc = jpamb.Bytecode(suite, eff, {})
    policies = {
        cn: suite.security_policy(cn, eff=eff)
        for cn in {m.classname for m in security_methods}
    }
    parsed_trees: dict[jvm.ClassName, tree_sitter.Tree] = {}
    for cn in policies:
        src = suite.sourcefile(cn).read_bytes()
        parsed_trees[cn] = tree_sitter.Parser(syn_mod.JAVA).parse(src)

    records: dict[str, dict[str, Any]] = {}
    witness_pairs: set[tuple[str, str]] = set()

    for mid in security_methods:
        mid_str = mid.encode()
        gt = ground_truth[mid_str]
        policy = policies[mid.classname]
        assert policy is not None
        method_bc = bc.getmethod(mid)
        total_insns = len(method_bc.opcodes)

        # --- 1. Syntactic ---
        syn_times = []
        syn_summary = None
        for _ in range(warm_repeats):
            t0 = time.perf_counter()
            syn_summary = hyb_mod.run_syntactic_analysis(suite, policy, mid)
            syn_times.append((time.perf_counter() - t0) * 1000.0)
        assert syn_summary is not None
        syn_verdict = "violation" if syn_summary.leaks else "safe"

        # --- 2. Unbounded Static (Full Interval x SignSet x SecurityLabel + Widening) ---
        unb_times = []
        unb_res = None
        for _ in range(warm_repeats):
            t0 = time.perf_counter()
            unb_res = unb_interp.analyze(bc, mid, policy)
            unb_times.append((time.perf_counter() - t0) * 1000.0)
        assert unb_res is not None

        # Ablation A: Pure-label static analysis (no numeric pruning)
        pure_res = pure_conf.analyze(bc, mid, policy)

        # Ablation B: No threshold widening (ordinary joins on back edges, capped at 100 steps)
        no_widen_steps = None
        no_widen_status = None
        try:
            nw_interp = unb_interp.AbstractInterpreter.initial(
                bc, mid, policy, unb_interp.Config(max_steps=100)
            )
            nw_interp.back_edges = set()  # disable widening on back edges
            nw_out = nw_interp.run()
            no_widen_steps = nw_out.steps
            no_widen_status = nw_out.status
        except Exception:
            no_widen_status = "unsupported"

        # --- 3. Dynamic (seed=0, 100 runs default JPAMB CLI setting + 300-run evaluation setting) ---
        dyn_times = []
        dyn_campaign = None
        raw_ints, _ = dyn_mod.collect_constants(bc, mid)
        space = fuzz_inputs.InputSpace(
            tuple(mid.extension.params),
            fuzz_inputs.interesting_integers(raw_ints),
        )
        seeds = dyn_mod.build_seeds(space, raw_ints)
        for rep in range(warm_repeats):
            t0 = time.perf_counter()
            runner = dyn_mod.make_runner(bc, policy)
            dyn_campaign = coverage_fuzz.fuzz(
                mid,
                space,
                runner,
                config=coverage_fuzz.FuzzConfig(
                    max_executions=100,
                    step_limit=2500,
                    timeout_seconds=2.0,
                    seed=0,
                    seed_limit=max(1, len(seeds)),
                ),
                seeds=seeds,
            )
            dyn_times.append((time.perf_counter() - t0) * 1000.0)
        assert dyn_campaign is not None
        for f in dyn_campaign.findings:
            witness_pairs.add((mid_str, f.inputs.encode()))
        dyn_cov = len({pc.offset for pc in dyn_campaign.coverage if pc.method == mid})
        if dyn_campaign.findings or "assertion error" in dyn_campaign.outcomes:
            dyn_verdict = "witness"
        elif dyn_campaign.unsupported_runs == dyn_campaign.executions and dyn_campaign.executions > 0:
            dyn_verdict = "unknown"
        else:
            dyn_verdict = "unresolved"

        # --- 4. Hybrid (default 80 primary runs, 12 triage runs when syntactic clean) ---
        hyb_times = []
        hyb_rep = None
        for _ in range(warm_repeats):
            t0 = time.perf_counter()
            hyb_rep = hyb_mod.analyze_hybrid(
                suite, bc, policy, mid, max_runs=80, max_steps=2500, timeout_sec=2.0
            )
            hyb_times.append((time.perf_counter() - t0) * 1000.0)
        assert hyb_rep is not None
        for f in hyb_rep.dynamic_findings:
            witness_pairs.add((mid_str, f.inputs.encode()))

        hyb_ae_cat = hyb_rep.predictions["assertion error"]
        hyb_has_witness = bool(hyb_rep.dynamic_findings) or (
            "assertion error" in hyb_rep.dynamic_outcomes
        )
        hyb_has_warning = bool(hyb_rep.syntactic.leaks) or hyb_has_witness
        hyb_has_pretaint = bool(hyb_rep.hybrid_pre_taint_findings)

        records[mid_str] = {
            **gt,
            "total_opcodes": total_insns,
            "syntactic": {
                "verdict": syn_verdict,
                "leaks": syn_summary.leaks,
                "has_unconditional_leak": syn_summary.has_unconditional_leak,
                "warm_median_ms": statistics.median(syn_times),
            },
            "unbounded": {
                "status": unb_res.status,
                "steps": unb_res.steps,
                "diagnostics": [asdict(d) for d in unb_res.diagnostics],
                "can_return_ok": unb_res.can_return_ok,
                "has_reachable_cycle": unb_res.has_reachable_cycle,
                "warm_median_ms": statistics.median(unb_times),
                "pure_label_status": pure_res.status,
                "pure_label_steps": pure_res.steps,
                "no_widening_status_cap100": no_widen_status,
                "no_widening_steps_cap100": no_widen_steps,
            },
            "dynamic": {
                "verdict": dyn_verdict,
                "executions": dyn_campaign.executions,
                "steps": dyn_campaign.steps,
                "completed_runs": dyn_campaign.completed_runs,
                "limited_runs": dyn_campaign.limited_runs,
                "unsupported_runs": dyn_campaign.unsupported_runs,
                "covered_offsets": dyn_cov,
                "coverage_fraction": dyn_cov / total_insns if total_insns else 1.0,
                "findings_count": len(dyn_campaign.findings),
                "witnesses": [f.inputs.encode() for f in dyn_campaign.findings],
                "warm_median_ms": statistics.median(dyn_times),
            },
            "hybrid": {
                "category": hyb_ae_cat,
                "has_witness": hyb_has_witness,
                "has_warning": hyb_has_warning,
                "has_pretaint_only": hyb_has_pretaint and not hyb_has_witness,
                "pretaint_count": len(hyb_rep.hybrid_pre_taint_findings),
                "executions": hyb_rep.runs,
                "covered_offsets": hyb_rep.covered_instructions,
                "coverage_fraction": (
                    hyb_rep.covered_instructions / total_insns if total_insns else 1.0
                ),
                "witnesses": [f.inputs.encode() for f in hyb_rep.dynamic_findings],
                "pretaint_inputs": [
                    f.inputs.encode() for f in hyb_rep.hybrid_pre_taint_findings
                ],
                "warm_median_ms": statistics.median(hyb_times),
            },
        }

    return records, witness_pairs


# =============================================================================
# 5. Confusion Matrix & Accuracy Computation
# =============================================================================


def compute_classification_metrics(
    records: dict[str, dict[str, Any]],
    cli_results: dict[str, Any],
) -> dict[str, Any]:
    """Compute TP, FP, FN, TN, Unknown, Precision, Recall, FPR, FNR, F1, Wilson CIs."""
    modes = (
        "syntactic",
        "unbounded",
        "dynamic",
        "hybrid_warning",
        "hybrid_witness",
    )
    out: dict[str, Any] = {}
    total_methods = len(records)
    total_leaking = sum(1 for r in records.values() if r["has_leak"])
    total_safe = total_methods - total_leaking

    for mode in modes:
        tp = fp = fn = tn = unk = unk_leaking = unk_safe = 0
        fp_methods: list[str] = []
        fn_methods: list[str] = []
        unk_methods: list[str] = []

        for mid_str, r in sorted(records.items()):
            actual_leak = r["has_leak"]
            short = r["short_name"]

            if mode == "syntactic":
                state = "pos" if r["syntactic"]["verdict"] == "violation" else "neg"
            elif mode == "unbounded":
                st = r["unbounded"]["status"]
                if st == "violation":
                    state = "pos"
                elif st == "safe":
                    state = "neg"
                else:
                    state = "unk"
            elif mode == "dynamic":
                vd = r["dynamic"]["verdict"]
                if vd == "witness":
                    state = "pos"
                elif vd == "unknown":
                    state = "unk"
                else:
                    state = "neg"
            elif mode == "hybrid_warning":
                if r["hybrid"]["has_warning"]:
                    state = "pos"
                elif (
                    r["dynamic"]["verdict"] == "unknown"
                    and not r["hybrid"]["has_warning"]
                ):
                    # Syntactic still classified it (e.g. helperPassthroughSafe)
                    state = "neg"
                else:
                    state = "neg"
            elif mode == "hybrid_witness":
                if r["hybrid"]["has_witness"]:
                    state = "pos"
                elif r["dynamic"]["verdict"] == "unknown":
                    state = "unk"
                else:
                    state = "neg"
            else:
                raise ValueError(mode)

            if state == "unk":
                unk += 1
                unk_methods.append(short)
                if actual_leak:
                    unk_leaking += 1
                else:
                    unk_safe += 1
            elif state == "pos":
                if actual_leak:
                    tp += 1
                else:
                    fp += 1
                    fp_methods.append(short)
            else:
                if actual_leak:
                    fn += 1
                    fn_methods.append(short)
                else:
                    tn += 1

        prec = tp / (tp + fp) if (tp + fp) > 0 else 1.0
        rec_classified = tp / (tp + fn) if (tp + fn) > 0 else 0.0
        rec_end_to_end = tp / total_leaking if total_leaking > 0 else 0.0
        fpr_classified = fp / (fp + tn) if (fp + tn) > 0 else 0.0
        fnr_classified = fn / (tp + fn) if (tp + fn) > 0 else 0.0
        f1 = (2 * tp) / (2 * tp + fp + fn) if (2 * tp + fp + fn) > 0 else 0.0

        cli_key = "hybrid" if mode.startswith("hybrid") else mode
        warm_times = [
            r["hybrid" if mode.startswith("hybrid") else mode]["warm_median_ms"]
            for r in records.values()
        ]

        out[mode] = {
            "TP": tp,
            "FP": fp,
            "FN": fn,
            "TN": tn,
            "Unknown": unk,
            "Unknown_leaking": unk_leaking,
            "Unknown_safe": unk_safe,
            "precision": prec,
            "precision_ci95": wilson_ci(tp, tp + fp),
            "recall_classified": rec_classified,
            "recall_classified_ci95": wilson_ci(tp, tp + fn),
            "recall_total": rec_end_to_end,
            "recall_total_ci95": wilson_ci(tp, total_leaking),
            "fpr": fpr_classified,
            "fpr_ci95": wilson_ci(fp, fp + tn),
            "fnr": fnr_classified,
            "fnr_ci95": wilson_ci(fn, tp + fn),
            "f1": f1,
            "jpamb_score": cli_results[cli_key]["total_score"],
            "cli_time_ms_stats": cli_results[cli_key]["time_ms_stats"],
            "cli_rel_db_stats": cli_results[cli_key]["rel_db_stats"],
            "inproc_time_ms_stats": summary_stats(warm_times),
            "fp_methods": fp_methods,
            "fn_methods": fn_methods,
            "unknown_methods": unk_methods,
        }
    return out


# =============================================================================
# 6. Paired 20-Seed Fuzzing & Hybrid Triage Study
# =============================================================================


CHALLENGE_FAMILIES = [
    (
        "staged",
        "Staged guards",
        [
            "jpamb.cases.FuzzingChallenges.stagedMask3:(IIII)V",
            "jpamb.cases.FuzzingChallenges.stagedMask4:(IIII)V",
            "jpamb.cases.FuzzingChallenges.stagedMask5:(IIII)V",
        ],
        "jpamb.cases.FuzzingChallenges.stagedMaskSafe:(IIII)V",
        "coverage-guided",
    ),
    (
        "opaque",
        "Opaque pairs",
        [
            "jpamb.cases.FuzzingChallenges.opaquePair17:(III)V",
            "jpamb.cases.FuzzingChallenges.opaquePair29:(III)V",
            "jpamb.cases.FuzzingChallenges.opaquePair53:(III)V",
        ],
        "jpamb.cases.FuzzingChallenges.opaquePairSafe:(III)V",
        "dictionary-random",
    ),
    (
        "neutral",
        "Neutral targets",
        [
            "jpamb.cases.FuzzingChallenges.neutralTarget19:(II)V",
            "jpamb.cases.FuzzingChallenges.neutralTarget23:(II)V",
            "jpamb.cases.FuzzingChallenges.neutralTarget31:(II)V",
        ],
        "jpamb.cases.FuzzingChallenges.neutralTargetSafe:(II)V",
        "unguided-mutation",
    ),
    (
        "product",
        "Product targets",
        [
            "jpamb.cases.FuzzingChallenges.productTarget257:(II)V",
            "jpamb.cases.FuzzingChallenges.productTarget509:(II)V",
            "jpamb.cases.FuzzingChallenges.productTarget1031:(II)V",
        ],
        "jpamb.cases.FuzzingChallenges.productTargetSafe:(II)V",
        None,
    ),
]

NESTED_LOOP_METHODS = [
    ("double_loop", "Double loop", "jpamb.cases.AdvancedLeaks.nestedWhileWeirdCaseLeak:(III)V"),
    ("triple_loop", "Triple loop", "jpamb.cases.AdvancedLeaks.tripleNestedWhileCornerLeak:(IIII)V"),
]


def run_paired_fuzzing_study(
    suite: jpamb.Suite,
    eff: jpamb.Effect,
    security_methods: list[jvm.AbsMethodID],
    ground_truth: dict[str, dict[str, Any]],
    seeds: list[int],
) -> tuple[dict[str, Any], set[tuple[str, str]]]:
    """Run paired 20-seed campaigns (300 executions, 100k max_steps, 2500 step_limit, seed_limit 80)
    across Dictionary (D), Unguided (U), Coverage-Guided (G), and Hybrid (H) on the 18 challenge,
    control, and nested-loop methods, plus triage comparison across ALL safe methods in the suite.
    """
    bc = jpamb.Bytecode(suite, eff, {})
    target_strs: list[str] = []
    for _, _, mlist, ctrl, _ in CHALLENGE_FAMILIES:
        target_strs.extend(mlist)
        target_strs.append(ctrl)
    for _, _, m in NESTED_LOOP_METHODS:
        target_strs.append(m)

    witness_pairs: set[tuple[str, str]] = set()
    trial_rows: list[dict[str, Any]] = []

    print(
        f"[FUZZ] Running paired {len(seeds)}-seed x 4-strategy campaigns on {len(target_strs)} methods...",
        file=sys.stderr,
    )

    for m_str in target_strs:
        mid = jpamb.parse_methodid(m_str)
        policy = suite.security_policy(mid.classname, eff=eff)
        assert policy is not None
        total_insns = len(bc.getmethod(mid).opcodes)

        # Standalone constants & seeds
        bc_ints, _ = dyn_mod.collect_constants(bc, mid)
        space = fuzz_inputs.InputSpace(
            tuple(mid.extension.params),
            fuzz_inputs.interesting_integers(bc_ints),
        )
        base_seeds = dyn_mod.build_seeds(space, bc_ints)

        # Hybrid syntactic pass (run once per method, timed per seed with fuzzing)
        t_syn0 = time.perf_counter()
        syn_sum = hyb_mod.run_syntactic_analysis(suite, policy, mid)
        syn_ms = (time.perf_counter() - t_syn0) * 1000.0
        hyb_consts = list(dict.fromkeys(syn_sum.constants + bc_ints))
        hyb_space = fuzz_inputs.InputSpace(
            tuple(mid.extension.params),
            fuzz_inputs.interesting_integers(hyb_consts),
        )
        hyb_seeds = dyn_mod.build_seeds(hyb_space, hyb_consts)

        for s in seeds:
            # 1-3: D, U, G
            for strat in ("dictionary-random", "unguided-mutation", "coverage-guided"):
                t0 = time.perf_counter()
                camp = coverage_fuzz.fuzz(
                    mid,
                    space,
                    dyn_mod.make_runner(bc, policy),
                    config=coverage_fuzz.FuzzConfig(
                        max_executions=300,
                        step_limit=2500,
                        max_steps=100_000,
                        timeout_seconds=None,
                        seed=s,
                        seed_limit=80,
                    ),
                    seeds=base_seeds,
                    strategy=strat,
                )
                elapsed_ms = (time.perf_counter() - t0) * 1000.0
                for f in camp.findings:
                    witness_pairs.add((m_str, f.inputs.encode()))
                cov_n = len({pc.offset for pc in camp.coverage if pc.method == mid})
                trial_rows.append(
                    {
                        "method": m_str,
                        "seed": s,
                        "strategy": strat,
                        "found": bool(camp.findings),
                        "executions": camp.executions,
                        "steps": camp.steps,
                        "covered_offsets": cov_n,
                        "total_opcodes": total_insns,
                        "coverage_fraction": cov_n / total_insns if total_insns else 1.0,
                        "first_finding_exec": (
                            camp.findings[0].execution if camp.findings else None
                        ),
                        "elapsed_ms": elapsed_ms,
                        "pretaint_found": False,
                    }
                )

            # 4: Hybrid under matched 300-execution primary allowance (12 if warning-free)
            t0 = time.perf_counter()
            effective_execs = 300 if syn_sum.leaks else 12
            hyb_camp = coverage_fuzz.fuzz(
                mid,
                hyb_space,
                hyb_mod.make_hybrid_runner(bc, policy, hybrid_branch_taint=False),
                config=coverage_fuzz.FuzzConfig(
                    max_executions=effective_execs,
                    step_limit=2500,
                    max_steps=100_000,
                    timeout_seconds=None,
                    seed=s,
                    seed_limit=80,
                ),
                seeds=hyb_seeds,
                strategy="coverage-guided",
            )
            cov_n = len({pc.offset for pc in hyb_camp.coverage if pc.method == mid})
            pretaint_hit = False
            probe_execs = 0
            probe_steps = 0
            if syn_sum.leaks and not hyb_camp.findings and cov_n < total_insns:
                probe_camp = coverage_fuzz.fuzz(
                    mid,
                    hyb_space,
                    hyb_mod.make_hybrid_runner(bc, policy, hybrid_branch_taint=True),
                    config=coverage_fuzz.FuzzConfig(
                        max_executions=8,
                        step_limit=2500,
                        timeout_seconds=0.5,
                        seed=s,
                        seed_limit=8,
                    ),
                )
                pretaint_hit = bool(probe_camp.findings)
                probe_execs = probe_camp.executions
                probe_steps = probe_camp.steps
            elapsed_ms = syn_ms + (time.perf_counter() - t0) * 1000.0
            for f in hyb_camp.findings:
                witness_pairs.add((m_str, f.inputs.encode()))
            trial_rows.append(
                {
                    "method": m_str,
                    "seed": s,
                    "strategy": "hybrid",
                    "found": bool(hyb_camp.findings),
                    "executions": hyb_camp.executions,
                    "total_executions_with_probe": hyb_camp.executions + probe_execs,
                    "steps": hyb_camp.steps + probe_steps,
                    "covered_offsets": cov_n,
                    "total_opcodes": total_insns,
                    "coverage_fraction": cov_n / total_insns if total_insns else 1.0,
                    "first_finding_exec": (
                        hyb_camp.findings[0].execution if hyb_camp.findings else None
                    ),
                    "elapsed_ms": elapsed_ms,
                    "pretaint_found": pretaint_hit,
                }
            )

    # Index trials by (method, seed, strategy)
    by_mss: dict[tuple[str, int, str], dict[str, Any]] = {
        (r["method"], r["seed"], r["strategy"]): r for r in trial_rows
    }

    # --- Family & Nested-Loop Statistical Comparisons ---
    raw_comparisons: list[dict[str, Any]] = []

    # 1) Cluster-respecting paired tests per 3-method family (collapsing 3 variants per seed -> N=20 seeds)
    family_summaries: list[dict[str, Any]] = []
    for fid, fname, mlist, ctrl, expected_best in CHALLENGE_FAMILIES:
        counts = {}
        seed_vectors: dict[str, list[float]] = {}
        cov_means: dict[str, float] = {}
        for strat in ("dictionary-random", "unguided-mutation", "coverage-guided", "hybrid"):
            vec = [
                sum(1.0 if by_mss[(m, s, strat)]["found"] else 0.0 for m in mlist) / len(mlist)
                for s in seeds
            ]
            seed_vectors[strat] = vec
            hits = sum(1 for m in mlist for s in seeds if by_mss[(m, s, strat)]["found"])
            counts[strat] = {"hits": hits, "trials": len(mlist) * len(seeds), "rate": hits / (len(mlist) * len(seeds))}
            cov_means[strat] = statistics.mean(
                by_mss[(m, s, strat)]["coverage_fraction"] for m in mlist for s in seeds
            )

        ctrl_hits = {
            strat: sum(1 for s in seeds if by_mss[(ctrl, s, strat)]["found"])
            for strat in ("dictionary-random", "unguided-mutation", "coverage-guided", "hybrid")
        }
        family_summaries.append(
            {
                "id": fid,
                "name": fname,
                "methods": mlist,
                "control": ctrl,
                "expected_best": expected_best,
                "counts": counts,
                "mean_coverage": cov_means,
                "control_false_positives": ctrl_hits,
            }
        )

        # Pairwise comparisons against coverage-guided (RQ2) and Expected Lead vs runner-up
        pairs_to_test = [
            ("coverage-guided", "dictionary-random"),
            ("coverage-guided", "unguided-mutation"),
        ]
        if fid == "opaque":
            pairs_to_test.append(("dictionary-random", "unguided-mutation"))
        elif fid == "neutral":
            pairs_to_test.append(("unguided-mutation", "dictionary-random"))

        for sa, sb in pairs_to_test:
            diffs = [a - b for a, b in zip(seed_vectors[sa], seed_vectors[sb])]
            wil = exact_wilcoxon_signed_rank(diffs)
            ci = paired_bootstrap_ci(diffs, n_boot=10_000, seed=100)
            pa = statistics.mean(seed_vectors[sa])
            pb = statistics.mean(seed_vectors[sb])
            raw_comparisons.append(
                {
                    "scope": fname,
                    "unit": f"Seed-collapsed family rate (N={len(seeds)} seeds)",
                    "test": "Exact paired Wilcoxon signed-rank",
                    "strategy_a": sa,
                    "strategy_b": sb,
                    "rate_a": pa,
                    "rate_b": pb,
                    "diff": pa - pb,
                    "ci95_diff": ci,
                    "cohens_h": cohens_h(pa, pb),
                    "rank_biserial": wil["rank_biserial"],
                    "raw_p": wil["p_value"],
                }
            )

    # 2) Per-method exact McNemar tests on all 14 challenge methods (12 new + 2 nested loops)
    per_method_tests: list[dict[str, Any]] = []
    all_14 = [m for _, _, mlist, _, _ in CHALLENGE_FAMILIES for m in mlist] + [
        m for _, _, m in NESTED_LOOP_METHODS
    ]
    for m_str in all_14:
        short = m_str.split(".")[-1].split(":")[0]
        m_rates = {}
        for strat in ("dictionary-random", "unguided-mutation", "coverage-guided", "hybrid"):
            k = sum(1 for s in seeds if by_mss[(m_str, s, strat)]["found"])
            m_rates[strat] = {
                "hits": k,
                "n": len(seeds),
                "rate": k / len(seeds),
                "wilson_ci95": wilson_ci(k, len(seeds)),
                "mean_cov": statistics.mean(
                    by_mss[(m_str, s, strat)]["coverage_fraction"] for s in seeds
                ),
            }
        per_method_tests.append({"method": m_str, "short": short, "rates": m_rates})

    for lid, lname, m_str in NESTED_LOOP_METHODS:
        for sa, sb in (
            ("dictionary-random", "coverage-guided"),
            ("dictionary-random", "unguided-mutation"),
        ):
            vec_a = [1.0 if by_mss[(m_str, s, sa)]["found"] else 0.0 for s in seeds]
            vec_b = [1.0 if by_mss[(m_str, s, sb)]["found"] else 0.0 for s in seeds]
            n10 = sum(1 for a, b in zip(vec_a, vec_b) if a == 1.0 and b == 0.0)
            n01 = sum(1 for a, b in zip(vec_a, vec_b) if a == 0.0 and b == 1.0)
            p_mc = exact_mcnemar_test(n10, n01)
            diffs = [a - b for a, b in zip(vec_a, vec_b)]
            ci = paired_bootstrap_ci(diffs, n_boot=10_000, seed=200)
            pa, pb = statistics.mean(vec_a), statistics.mean(vec_b)
            raw_comparisons.append(
                {
                    "scope": lname,
                    "unit": f"Paired RNG seeds (N={len(seeds)}, n10={n10}, n01={n01})",
                    "test": "Exact two-sided McNemar",
                    "strategy_a": sa,
                    "strategy_b": sb,
                    "rate_a": pa,
                    "rate_b": pb,
                    "diff": pa - pb,
                    "ci95_diff": ci,
                    "cohens_h": cohens_h(pa, pb),
                    "rank_biserial": (n10 - n01) / (n10 + n01) if (n10 + n01) > 0 else 0.0,
                    "raw_p": p_mc,
                }
            )

    # 3) Hybrid vs. Coverage-Guided concrete discovery across all 14 challenges (RQ3)
    hyb_diffs_14 = [
        statistics.mean(1.0 if by_mss[(m, s, "hybrid")]["found"] else 0.0 for s in seeds)
        - statistics.mean(1.0 if by_mss[(m, s, "coverage-guided")]["found"] else 0.0 for s in seeds)
        for m in all_14
    ]
    wil_hyb_14 = exact_wilcoxon_signed_rank(hyb_diffs_14)
    raw_comparisons.append(
        {
            "scope": "All 14 challenges (RQ3 discovery)",
            "unit": "Method-level detection rate (N=14 methods)",
            "test": "Exact paired Wilcoxon signed-rank",
            "strategy_a": "hybrid",
            "strategy_b": "coverage-guided",
            "rate_a": statistics.mean(
                1.0 if by_mss[(m, s, "hybrid")]["found"] else 0.0
                for m in all_14
                for s in seeds
            ),
            "rate_b": statistics.mean(
                1.0 if by_mss[(m, s, "coverage-guided")]["found"] else 0.0
                for m in all_14
                for s in seeds
            ),
            "diff": statistics.mean(hyb_diffs_14),
            "ci95_diff": paired_bootstrap_ci(hyb_diffs_14, n_boot=10_000, seed=300),
            "cohens_h": 0.0,
            "rank_biserial": wil_hyb_14["rank_biserial"],
            "raw_p": wil_hyb_14["p_value"],
        }
    )

    # 4) Hybrid Budget Triage on Safe Controls (4 controls x 20 seeds collapsed by control/seed + all safe methods in suite!)
    controls = [ctrl for _, _, _, ctrl, _ in CHALLENGE_FAMILIES]
    ctrl_exec_diffs_by_seed = [
        statistics.mean(
            by_mss[(c, s, "hybrid")]["executions"] - by_mss[(c, s, "coverage-guided")]["executions"]
            for c in controls
        )
        for s in seeds
    ]
    ctrl_time_diffs_by_seed = [
        statistics.mean(
            by_mss[(c, s, "hybrid")]["elapsed_ms"] - by_mss[(c, s, "coverage-guided")]["elapsed_ms"]
            for c in controls
        )
        for s in seeds
    ]
    wil_triage_ctrl_exec = exact_wilcoxon_signed_rank(ctrl_exec_diffs_by_seed)
    wil_triage_ctrl_time = exact_wilcoxon_signed_rank(ctrl_time_diffs_by_seed)

    # Also evaluate Hybrid vs Dynamic (80-run budget) across ALL safe methods in the 106-method suite!
    safe_mids = [
        m for m in security_methods if not ground_truth[m.encode()]["has_leak"]
    ]
    suite_safe_exec_hyb: list[float] = []
    suite_safe_exec_dyn: list[float] = []
    suite_safe_time_hyb: list[float] = []
    suite_safe_time_dyn: list[float] = []
    suite_safe_warning_free = 0

    for mid in safe_mids:
        pol = suite.security_policy(mid.classname, eff=eff)
        assert pol is not None
        bc_i, _ = dyn_mod.collect_constants(bc, mid)
        sp = fuzz_inputs.InputSpace(
            tuple(mid.extension.params), fuzz_inputs.interesting_integers(bc_i)
        )
        sds = dyn_mod.build_seeds(sp, bc_i)

        t0 = time.perf_counter()
        c_dyn = coverage_fuzz.fuzz(
            mid,
            sp,
            dyn_mod.make_runner(bc, pol),
            config=coverage_fuzz.FuzzConfig(
                max_executions=80,
                step_limit=2500,
                timeout_seconds=2.0,
                seed=0,
                seed_limit=max(1, len(sds)),
            ),
            seeds=sds,
            strategy="coverage-guided",
        )
        t_dyn = (time.perf_counter() - t0) * 1000.0

        t1 = time.perf_counter()
        h_rep = hyb_mod.analyze_hybrid(
            suite, bc, pol, mid, max_runs=80, max_steps=2500, timeout_sec=2.0
        )
        t_hyb = (time.perf_counter() - t1) * 1000.0

        if not h_rep.syntactic.leaks:
            suite_safe_warning_free += 1
        suite_safe_exec_dyn.append(float(c_dyn.executions))
        suite_safe_exec_hyb.append(float(h_rep.runs))
        suite_safe_time_dyn.append(t_dyn)
        suite_safe_time_hyb.append(t_hyb)

    suite_safe_exec_diffs = [h - d for h, d in zip(suite_safe_exec_hyb, suite_safe_exec_dyn)]
    suite_safe_time_diffs = [h - d for h, d in zip(suite_safe_time_hyb, suite_safe_time_dyn)]
    wil_suite_safe_exec = exact_wilcoxon_signed_rank(suite_safe_exec_diffs)
    wil_suite_safe_time = exact_wilcoxon_signed_rank(suite_safe_time_diffs)

    raw_comparisons.append(
        {
            "scope": f"All {len(safe_mids)} safe methods (Hybrid triage executions)",
            "unit": f"Method-level executions under 80-run cap (N={len(safe_mids)} safe methods)",
            "test": "Exact paired Wilcoxon signed-rank",
            "strategy_a": "hybrid",
            "strategy_b": "coverage-guided",
            "rate_a": statistics.mean(suite_safe_exec_hyb),
            "rate_b": statistics.mean(suite_safe_exec_dyn),
            "diff": statistics.mean(suite_safe_exec_diffs),
            "ci95_diff": paired_bootstrap_ci(suite_safe_exec_diffs, n_boot=10_000, seed=400),
            "cohens_h": 0.0,
            "rank_biserial": wil_suite_safe_exec["rank_biserial"],
            "raw_p": wil_suite_safe_exec["p_value"],
        }
    )

    # Apply Holm-Bonferroni across all raw_comparisons
    adj_ps = holm_bonferroni([c["raw_p"] for c in raw_comparisons])
    for comp, ap in zip(raw_comparisons, adj_ps):
        comp["holm_p"] = ap

    # --- Coverage vs. Discovery Analysis ---
    cov_analysis: dict[str, Any] = {}
    for fid, fname, mlist, _, _ in CHALLENGE_FAMILIES:
        g_rows = [by_mss[(m, s, "coverage-guided")] for m in mlist for s in seeds]
        u_rows = [by_mss[(m, s, "unguided-mutation")] for m in mlist for s in seeds]
        d_rows = [by_mss[(m, s, "dictionary-random")] for m in mlist for s in seeds]
        cov_analysis[fid] = {
            "family": fname,
            "guided_spearman_cov_vs_found": spearman_rho(
                [r["coverage_fraction"] for r in g_rows],
                [1.0 if r["found"] else 0.0 for r in g_rows],
            ),
            "guided_cov_when_found": (
                statistics.mean(r["coverage_fraction"] for r in g_rows if r["found"])
                if any(r["found"] for r in g_rows)
                else None
            ),
            "guided_cov_when_missed": (
                statistics.mean(r["coverage_fraction"] for r in g_rows if not r["found"])
                if any(not r["found"] for r in g_rows)
                else None
            ),
            "mean_cov_D": statistics.mean(r["coverage_fraction"] for r in d_rows),
            "mean_cov_U": statistics.mean(r["coverage_fraction"] for r in u_rows),
            "mean_cov_G": statistics.mean(r["coverage_fraction"] for r in g_rows),
        }

    return (
        {
            "seeds": seeds,
            "family_summaries": family_summaries,
            "per_method_tests": per_method_tests,
            "statistical_comparisons": raw_comparisons,
            "triage_controls": {
                "controls_count": len(controls),
                "hybrid_mean_execs": statistics.mean(
                    by_mss[(c, s, "hybrid")]["executions"] for c in controls for s in seeds
                ),
                "guided_mean_execs": statistics.mean(
                    by_mss[(c, s, "coverage-guided")]["executions"]
                    for c in controls
                    for s in seeds
                ),
                "exec_wilcoxon": wil_triage_ctrl_exec,
                "hybrid_median_ms": statistics.median(
                    by_mss[(c, s, "hybrid")]["elapsed_ms"] for c in controls for s in seeds
                ),
                "guided_median_ms": statistics.median(
                    by_mss[(c, s, "coverage-guided")]["elapsed_ms"]
                    for c in controls
                    for s in seeds
                ),
                "time_wilcoxon": wil_triage_ctrl_time,
            },
            "triage_all_safe": {
                "total_safe_methods": len(safe_mids),
                "warning_free_safe_methods": suite_safe_warning_free,
                "hybrid_execs_stats": summary_stats(suite_safe_exec_hyb),
                "dynamic_execs_stats": summary_stats(suite_safe_exec_dyn),
                "exec_diff_ci95": paired_bootstrap_ci(suite_safe_exec_diffs, n_boot=10_000, seed=401),
                "exec_wilcoxon": wil_suite_safe_exec,
                "hybrid_time_ms_stats": summary_stats(suite_safe_time_hyb),
                "dynamic_time_ms_stats": summary_stats(suite_safe_time_dyn),
                "time_wilcoxon": wil_suite_safe_time,
            },
            "coverage_analysis": cov_analysis,
            "pretaint_only_trials_on_challenges": sum(
                1
                for m in all_14
                for s in seeds
                if by_mss[(m, s, "hybrid")]["pretaint_found"]
                and not by_mss[(m, s, "hybrid")]["found"]
            ),
        },
        witness_pairs,
    )


# =============================================================================
# 7. Independent ASM-Instrumented JVM Oracle Verification of Witnesses
# =============================================================================


def verify_witnesses_on_jvm(
    witness_pairs: set[tuple[str, str]], java_bin: str
) -> dict[str, Any]:
    """Run every distinct (method_id, encoded_input) witness on the real ASM-instrumented
    JVM (`BytecodeInstrumenter.transform` + `SecurityMonitor`, fresh classloader per run,
    identical to `jpamb.Runtime`) and verify that 100% produce `assertion error`.
    """
    sorted_pairs = sorted(witness_pairs)
    if not sorted_pairs:
        return {
            "distinct_witness_pairs": 0,
            "verified_assertion_error": 0,
            "agreement_rate": 1.0,
            "failures": [],
        }

    javac_bin = str(Path(java_bin).with_name("javac"))
    verifier_dir = Path("/tmp/jpamb_oracle_verifier")
    verifier_dir.mkdir(parents=True, exist_ok=True)
    verifier_java = verifier_dir / "BatchOracleVerifier.java"
    verifier_java.write_text(
        r"""
import java.io.*;
import java.lang.reflect.*;
import java.nio.file.*;
import java.util.*;
import java.util.regex.*;
import jpamb.Runtime;
import jpamb.utils.*;
import jpamb.utils.CaseContent.ResultType;

public class BatchOracleVerifier {
  static final class FreshCaseLoader extends ClassLoader {
    FreshCaseLoader() { super(BatchOracleVerifier.class.getClassLoader()); }
    @Override
    protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
      if (!name.startsWith("jpamb.cases.")) return super.loadClass(name, resolve);
      Class<?> c = findLoadedClass(name);
      if (c == null) {
        try (InputStream in = getParent().getResourceAsStream(name.replace('.', '/') + ".class")) {
          if (in == null) throw new ClassNotFoundException(name);
          byte[] transformed = BytecodeInstrumenter.transform(in.readAllBytes(), false);
          c = defineClass(name, transformed, 0, transformed.length);
        } catch (IOException e) { throw new ClassNotFoundException(name, e); }
      }
      if (resolve) resolveClass(c);
      return c;
    }
  }

  public static void main(String[] args) throws Exception {
    Pattern pat = Pattern.compile("(.*)\\.([^.(]*):\\((.*)\\)(.*)");
    List<String> lines = Files.readAllLines(Paths.get(args[0]));
    for (String line : lines) {
      if (line.isEmpty()) continue;
      String[] parts = line.split("\t", 2);
      String thecase = parts[0];
      String inp = parts[1];
      Matcher m = pat.matcher(thecase);
      if (!m.find()) throw new RuntimeException("Bad method id: " + thecase);
      String cls = m.group(1), mth = m.group(2), prams = m.group(3);
      Method method = Class.forName(cls, true, new FreshCaseLoader())
          .getMethod(mth, Runtime.parseMethodSignature(prams));
      Object[] params = InputParser.parse(inp);
      String outcome = ResultType.SUCCESS.toString();
      try {
        method.invoke(null, params);
      } catch (InvocationTargetException e) {
        outcome = ResultType.fromThrowable(e.getCause()).toString();
      }
      System.out.println(thecase + "\t" + inp + "\t" + outcome);
    }
  }
}
""".strip()
        + "\n",
        encoding="utf-8",
    )
    classpath = f"{ROOT / 'target/classes'}:{ROOT / 'lib/*'}"
    subprocess.run(
        [javac_bin, "--release", "17", "-cp", classpath, "-d", str(verifier_dir), str(verifier_java)],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    batch_input = verifier_dir / "witnesses.tsv"
    batch_input.write_text(
        "\n".join(f"{m}\t{i}" for m, i in sorted_pairs) + "\n", encoding="utf-8"
    )

    print(
        f"[JVM-ORACLE] Verifying {len(sorted_pairs)} distinct concrete leak witnesses on ASM-instrumented JVM...",
        file=sys.stderr,
    )
    proc = subprocess.run(
        [
            java_bin,
            "-cp",
            f"{verifier_dir}:{classpath}",
            "-ea",
            "BatchOracleVerifier",
            str(batch_input),
        ],
        cwd=ROOT,
        capture_output=True,
        text=True,
        timeout=60.0,
        check=True,
    )
    verified = 0
    failures = []
    for line in proc.stdout.splitlines():
        m_id, inp_s, actual = line.split("\t")
        if actual == "assertion error":
            verified += 1
        else:
            failures.append({"method": m_id, "input": inp_s, "stdout": actual})

    return {
        "distinct_witness_pairs": len(sorted_pairs),
        "verified_assertion_error": verified,
        "agreement_rate": verified / len(sorted_pairs),
        "failures": failures,
    }


# =============================================================================
# 8. Main Entry Point
# =============================================================================


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=ROOT / "evaluation" / "results",
        help="Directory for reproducible JSON/CSV outputs",
    )
    parser.add_argument(
        "--java-bin",
        type=str,
        default="/opt/homebrew/Cellar/openjdk@17/17.0.20.1/libexec/openjdk.jdk/Contents/Home/bin/java",
    )
    parser.add_argument("--cli-iterations", type=int, default=3)
    parser.add_argument("--warm-repeats", type=int, default=5)
    parser.add_argument("--num-seeds", type=int, default=20)
    parser.add_argument(
        "--only-update-cli",
        type=str,
        default="",
        help="Comma-separated analyzer names to refresh CLI results in existing summary_metrics.json",
    )
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)
    eff = jpamb.Effect(sys.stderr)
    suite = jpamb.Suite.from_workdir(ROOT)

    # 1. Domain audit
    audit = audit_suite(suite, eff)
    security_methods = [
        jpamb.parse_methodid(m) for m in sorted(audit["ground_truth"].keys())
    ]
    print(
        f"[AUDIT] Selected {len(security_methods)} @Lattice methods across "
        f"{len(audit['included_classes'])} classes "
        f"({audit['total_leaking_methods']} leaking, {audit['total_safe_methods']} safe); "
        f"excluded {audit['total_excluded_methods']} methods across {len(audit['excluded_classes'])} non-@Lattice classes.",
        file=sys.stderr,
    )

    if args.only_update_cli:
        targets = {s.strip() for s in args.only_update_cli.split(",") if s.strip()}
        existing_summary = json.loads(
            (args.output_dir / "summary_metrics.json").read_text(encoding="utf-8")
        )
        records = json.loads(
            (args.output_dir / "per_method_records.json").read_text(encoding="utf-8")
        )
        refreshed = run_official_jpamb_cli(
            suite,
            eff,
            security_methods,
            args.output_dir,
            iterations=args.cli_iterations,
            only_analyzers=targets,
        )
        merged_cli = dict(existing_summary["cli_results"])
        for k, v in refreshed.items():
            merged_cli[k] = {
                sk: sv for sk, sv in v.items() if not sk.startswith("per_method")
            }
        existing_summary["cli_results"] = merged_cli
        existing_summary["classification"] = compute_classification_metrics(
            records, merged_cli
        )
        (args.output_dir / "summary_metrics.json").write_text(
            json.dumps(existing_summary, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        print(
            f"[DONE] Refreshed CLI results for {sorted(targets)} in {args.output_dir}",
            file=sys.stderr,
        )
        return 0

    # 2. Official JPAMB CLI runs
    cli_results = run_official_jpamb_cli(
        suite, eff, security_methods, args.output_dir, iterations=args.cli_iterations
    )

    # 3. In-process evaluation & ablations
    records, base_witnesses = evaluate_in_process_all_methods(
        suite, eff, security_methods, audit["ground_truth"], warm_repeats=args.warm_repeats
    )

    # 4. Classification metrics
    classification = compute_classification_metrics(records, cli_results)

    # 5. Cost / transfer stats for Unbounded Static & Dynamic
    unb_all_steps = [r["unbounded"]["steps"] for r in records.values()]
    unb_supported_steps = [
        r["unbounded"]["steps"]
        for r in records.values()
        if r["unbounded"]["status"] in ("safe", "violation")
    ]
    dyn_all_execs = [r["dynamic"]["executions"] for r in records.values()]
    dyn_all_cov = [r["dynamic"]["coverage_fraction"] for r in records.values()]
    hyb_all_execs = [r["hybrid"]["executions"] for r in records.values()]

    # Ablation summary
    pure_label_fps = [
        r["short_name"]
        for r in records.values()
        if not r["has_leak"] and r["unbounded"]["pure_label_status"] == "violation"
    ]
    unbounded_fps = [
        r["short_name"]
        for r in records.values()
        if not r["has_leak"] and r["unbounded"]["status"] == "violation"
    ]
    cleared_by_numeric = sorted(set(pure_label_fps) - set(unbounded_fps))

    # 6. Paired 20-seed fuzzing & Hybrid triage study
    seeds = list(range(args.num_seeds))
    fuzz_study, study_witnesses = run_paired_fuzzing_study(
        suite, eff, security_methods, audit["ground_truth"], seeds=seeds
    )

    # 7. JVM Witness Oracle Verification
    all_witnesses = base_witnesses | study_witnesses
    jvm_verification = verify_witnesses_on_jvm(all_witnesses, args.java_bin)

    full_summary = {
        "audit": {k: v for k, v in audit.items() if k != "ground_truth"},
        "classification": classification,
        "cli_results": {
            k: {sk: sv for sk, sv in v.items() if not sk.startswith("per_method")}
            for k, v in cli_results.items()
        },
        "cost_and_ablation": {
            "unbounded_transfers_all": summary_stats(unb_all_steps),
            "unbounded_transfers_supported": summary_stats(unb_supported_steps),
            "dynamic_100cap_executions": summary_stats(dyn_all_execs),
            "dynamic_100cap_coverage_fraction": summary_stats(dyn_all_cov),
            "hybrid_80cap_executions": summary_stats(hyb_all_execs),
            "pure_label_false_positives": pure_label_fps,
            "unbounded_false_positives": unbounded_fps,
            "warnings_cleared_by_numeric_domain": cleared_by_numeric,
            "large_loop_widening": records.get(
                "jpamb.cases.PrecisionBenchmarks.largeLoopWideningSafe:(I)V", {}
            ).get("unbounded"),
        },
        "fuzz_study": fuzz_study,
        "jvm_witness_verification": jvm_verification,
    }

    (args.output_dir / "summary_metrics.json").write_text(
        json.dumps(full_summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    (args.output_dir / "per_method_records.json").write_text(
        json.dumps(records, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )

    # Also write flat per-method CSV for easy inspection
    csv_path = args.output_dir / "per_method_verdicts.csv"
    with csv_path.open("w", encoding="utf-8", newline="") as fp:
        writer = csv.writer(fp)
        writer.writerow(
            [
                "method",
                "short_name",
                "ground_truth_leak",
                "syntactic_verdict",
                "unbounded_status",
                "unbounded_steps",
                "pure_label_status",
                "dynamic_verdict",
                "dynamic_execs",
                "dynamic_coverage_frac",
                "hybrid_category",
                "hybrid_execs",
                "hybrid_has_witness",
                "hybrid_pretaint_only",
            ]
        )
        for mid_str, r in sorted(records.items()):
            writer.writerow(
                [
                    mid_str,
                    r["short_name"],
                    r["has_leak"],
                    r["syntactic"]["verdict"],
                    r["unbounded"]["status"],
                    r["unbounded"]["steps"],
                    r["unbounded"]["pure_label_status"],
                    r["dynamic"]["verdict"],
                    r["dynamic"]["executions"],
                    round(r["dynamic"]["coverage_fraction"], 4),
                    r["hybrid"]["category"],
                    r["hybrid"]["executions"],
                    r["hybrid"]["has_witness"],
                    r["hybrid"]["has_pretaint_only"],
                ]
            )

    print(
        f"[DONE] Wrote complete evaluation artifacts to {args.output_dir}",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

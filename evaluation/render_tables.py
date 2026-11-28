#!/usr/bin/env python3
"""
Render Markdown and LaTeX `booktabs` tables directly from `summary_metrics.json`
and `per_method_records.json` produced by `evaluate_confidentiality_suite.py`.
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RESULTS_DIR = ROOT / "evaluation" / "results"


def fmt_p(p: float) -> str:
    if p < 0.0001:
        return "<0.0001"
    return f"{p:.4f}"


def fmt_p_tex(p: float) -> str:
    if p < 0.0001:
        return "$<0.0001$"
    return f"${p:.4f}$"


def main() -> int:
    summary = json.loads((RESULTS_DIR / "summary_metrics.json").read_text(encoding="utf-8"))
    records = json.loads((RESULTS_DIR / "per_method_records.json").read_text(encoding="utf-8"))

    cls = summary["classification"]
    fuzz = summary["fuzz_study"]

    paradigm_order = [
        ("syntactic", "Syntactic (AST)"),
        ("unbounded", "Unbounded Static ($I \\times S \\times \\mathcal{L}$)"),
        ("dynamic", "Dynamic (Guided Fuzz, 100 runs)"),
        ("hybrid_warning", "Hybrid (Warning-inclusive)"),
        ("hybrid_witness", "Hybrid (Concrete-witness only)"),
    ]

    # --- Table 1: Markdown & LaTeX ---
    md_lines = [
        "### Table 1: Benchmark Ground Truth (`benchmark.sexp`) vs. Python Analyzers",
        "",
        "| Paradigm | TP | FP | FN | TN | Unk | Precision [95% CI] | Recall (Class. / Total) | FPR | FNR | JPAMB Score | In-Proc Median (IQR) ms | CLI Median (IQR) ms |",
        "| :--- | ---: | ---: | ---: | ---: | ---: | :---: | :---: | ---: | ---: | ---: | ---: | ---: |",
    ]

    tex_lines = [
        "% Table 1: Classification Accuracy, Soundness, JPAMB Score, and Runtime",
        "\\begin{table*}[t]",
        "\\centering",
        "\\caption{Accuracy, soundness, JPAMB score, and runtime across the $N = "
        f"{summary['audit']['total_included_methods']}$ \\texttt{{@Lattice}} confidentiality methods "
        f"({summary['audit']['total_leaking_methods']} policy-violating, "
        f"{summary['audit']['total_safe_methods']} policy-safe).}}",
        "\\label{tab:rq1-paradigms}",
        "\\small",
        "\\begin{tabular}{lrrrrrccccrrr}",
        "\\toprule",
        "Paradigm & TP & FP & FN & TN & Unk & Prec. & Rec. (Cls/All) & FPR & FNR & Score & In-Proc (ms) & CLI (ms) \\\\",
        "\\midrule",
    ]

    for key, label in paradigm_order:
        m = cls[key]
        p_lo, p_hi = m["precision_ci95"]
        in_med = m["inproc_time_ms_stats"]["median"]
        in_iqr = m["inproc_time_ms_stats"]["iqr"]
        cli_med = m["cli_time_ms_stats"]["median"]
        cli_iqr = m["cli_time_ms_stats"]["iqr"]
        plain_label = label.replace("$I \\times S \\times \\mathcal{L}$", "Interval × SignSet × Label")
        md_lines.append(
            f"| {plain_label} | {m['TP']} | {m['FP']} | {m['FN']} | {m['TN']} | {m['Unknown']} | "
            f"{m['precision']*100:.1f}% [{p_lo*100:.1f}, {p_hi*100:.1f}] | "
            f"{m['recall_classified']*100:.1f}% / {m['recall_total']*100:.1f}% | "
            f"{m['fpr']*100:.1f}% | {m['fnr']*100:.1f}% | "
            f"{m['jpamb_score']:.2f} | {in_med:.2f} ({in_iqr:.2f}) | {cli_med:.1f} ({cli_iqr:.1f}) |"
        )
        tex_lines.append(
            f"{label} & {m['TP']} & {m['FP']} & {m['FN']} & {m['TN']} & {m['Unknown']} & "
            f"{m['precision']*100:.1f}\\% & {m['recall_classified']*100:.1f}\\%/{m['recall_total']*100:.1f}\\% & "
            f"{m['fpr']*100:.1f}\\% & {m['fnr']*100:.1f}\\% & "
            f"{m['jpamb_score']:.2f} & {in_med:.2f} ({in_iqr:.2f}) & {cli_med:.1f} ({cli_iqr:.1f}) \\\\"
        )

    tex_lines.extend(["\\bottomrule", "\\end{tabular}", "\\end{table*}", ""])

    # --- Table 2: Statistical Comparisons of Fuzzing Strategies & Hybrid Triage ---
    md_lines.extend(
        [
            "",
            "### Table 2: Paired Statistical Comparisons of Fuzzing Strategies & Hybrid Triage",
            "",
            "| Scope / Family | Comparison ($A$ vs. $B$) | Paired Test & Unit | $A$ vs. $B$ | Diff $\\Delta$ [95% Boot CI] | Effect ($r_{\\text{rb}}$ / $h$) | Raw $p$ | Holm $p$ |",
            "| :--- | :--- | :--- | :---: | :---: | :---: | ---: | ---: |",
        ]
    )
    tex_lines.extend(
        [
            "% Table 2: Statistical Comparisons of Fuzzing Strategies and Hybrid Triage",
            "\\begin{table*}[t]",
            "\\centering",
            "\\caption{Paired statistical comparisons across shared RNG seeds ($0$--$19$, 300-execution budget) and safe-method triage ($N = "
            f"{summary['audit']['total_safe_methods']}$). Family tests collapse three related variants per seed ($N=20$) to avoid pseudo-replication; $p$-values are Holm--Bonferroni adjusted.}}",
            "\\label{tab:rq2-rq3-stats}",
            "\\small",
            "\\begin{tabular}{llcccccc}",
            "\\toprule",
            "Scope & Comparison ($A$ vs.\\ $B$) & Test & $A$ vs.\\ $B$ & $\\Delta$ [95\\% CI] & $r_{\\text{rb}}$ ($h$) & Raw $p$ & Holm $p$ \\\\",
            "\\midrule",
        ]
    )

    short_strat = {
        "coverage-guided": "G",
        "dictionary-random": "D",
        "unguided-mutation": "U",
        "hybrid": "H",
    }

    for comp in fuzz["statistical_comparisons"]:
        sa = short_strat.get(comp["strategy_a"], comp["strategy_a"])
        sb = short_strat.get(comp["strategy_b"], comp["strategy_b"])
        lo, hi = comp["ci95_diff"]
        is_exec = "executions" in comp["scope"]
        if is_exec:
            ab_str = f"{comp['rate_a']:.1f} vs {comp['rate_b']:.1f}"
            diff_str = f"{comp['diff']:+.1f} [{lo:+.1f}, {hi:+.1f}]"
            eff_str = f"{comp['rank_biserial']:+.2f} (--)"
        else:
            ab_str = f"{comp['rate_a']*100:.1f}% vs {comp['rate_b']*100:.1f}%"
            diff_str = f"{comp['diff']*100:+.1f}% [{lo*100:+.1f}, {hi*100:+.1f}]"
            eff_str = f"{comp['rank_biserial']:+.2f} ({comp['cohens_h']:+.2f})"
        t_short = "Wilcoxon" if "Wilcoxon" in comp["test"] else "McNemar"
        md_lines.append(
            f"| {comp['scope']} | {sa} vs. {sb} | {comp['test']} ({comp['unit']}) | "
            f"{ab_str} | {diff_str} | {eff_str} | {fmt_p(comp['raw_p'])} | {fmt_p(comp['holm_p'])} |"
        )
        tex_scope = comp["scope"].replace("&", "\\&")
        tex_ab = ab_str.replace("%", "\\%")
        tex_diff = diff_str.replace("%", "\\%")
        tex_lines.append(
            f"{tex_scope} & {sa} vs.\\ {sb} & {t_short} & {tex_ab} & {tex_diff} & "
            f"{eff_str} & {fmt_p_tex(comp['raw_p'])} & {fmt_p_tex(comp['holm_p'])} \\\\"
        )

    tex_lines.extend(["\\bottomrule", "\\end{tabular}", "\\end{table*}", ""])

    # --- Table 3: Diagnostic Separating Examples ---
    diag_methods = [
        ("jpamb.cases.Hospital.deadBranchLeak:(I)V", "Constant dead branch"),
        ("jpamb.cases.BasicLeaks.skippedLoop:(I)V", "Loop guard initially false"),
        ("jpamb.cases.PrecisionBenchmarks.signHoleRangeSafe:(II)V", "Sign-hole range ($x \\neq 0 \\land x \\ge 0$)"),
        ("jpamb.cases.PrecisionBenchmarks.largeLoopWideningSafe:(I)V", "1,000,000-iter loop widening"),
        ("jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V", "2nd-iteration back-edge leak"),
        ("jpamb.cases.PrecisionBenchmarks.relationalSelfCancelSafe:(II)V", "Relational ($x - y = 0$)"),
        ("jpamb.cases.PrecisionBenchmarks.intervalHullHoleSafe:(II)V", "Convex hull hole ($\\{1,5\\} \\not\\ni 3$)"),
        ("jpamb.cases.FuzzingChallenges.stagedMask3:(IIII)V", "Staged bitmask guards"),
        ("jpamb.cases.FuzzingChallenges.opaquePair17:(III)V", "Opaque XOR/OR pair"),
        ("jpamb.cases.FuzzingChallenges.neutralTarget19:(II)V", "Computed neutral target ($7+12$)"),
        ("jpamb.cases.FuzzingChallenges.productTarget257:(II)V", "Computed product ($257 \\times 263$)"),
        ("jpamb.cases.PrecisionBenchmarks.helperPassthroughLeak:(I)V", "Same-class helper leak"),
        ("jpamb.cases.PrecisionBenchmarks.helperPassthroughSafe:(II)V", "Same-class helper safe"),
        ("jpamb.cases.PrecisionBenchmarks.recursiveCountdownLeak:(II)V", "Tail-recursive countdown leak"),
    ]

    md_lines.extend(
        [
            "",
            "### Table 3: Diagnostic Separating Benchmark Cases Across All Four Paradigms",
            "",
            "| Method | Structural Mechanism | JVM Oracle | Syntactic | Unbounded Static (Transfers) | Dynamic (100-run) | Hybrid Category |",
            "| :--- | :--- | :---: | :---: | :---: | :---: | :---: |",
        ]
    )
    tex_lines.extend(
        [
            "% Table 3: Diagnostic Separating Examples",
            "\\begin{table*}[t]",
            "\\centering",
            "\\caption{Diagnostic benchmark methods separating the JVM oracle, syntactic AST analysis, unbounded abstract interpretation, concrete dynamic fuzzing, and the syntactic--dynamic hybrid.}",
            "\\label{tab:diagnostic-examples}",
            "\\small",
            "\\begin{tabular}{llccccc}",
            "\\toprule",
            "Method & Mechanism & JVM Oracle & Syntactic & Unbounded (Steps) & Dynamic & Hybrid \\\\",
            "\\midrule",
        ]
    )

    for mid_str, mech in diag_methods:
        if mid_str not in records:
            continue
        r = records[mid_str]
        oracle_str = "Leak" if r["has_leak"] else "Safe"
        syn_str = "Warn" if r["syntactic"]["verdict"] == "violation" else "Safe"
        ust = r["unbounded"]["status"]
        unb_str = f"{ust.capitalize()} ({r['unbounded']['steps']})"
        dyn_str = r["dynamic"]["verdict"].capitalize()
        hyb_str = r["hybrid"]["category"]

        plain_mech = (
            mech.replace("$", "")
            .replace("\\neq", "!=")
            .replace("\\land", "&&")
            .replace("\\ge", ">=")
            .replace("\\{", "{")
            .replace("\\}", "}")
            .replace("\\not\\ni", "excludes")
            .replace("\\times", "*")
        )
        md_lines.append(
            f"| `{r['short_name']}` | {plain_mech} | {oracle_str} | {syn_str} | {unb_str} | {dyn_str} | `{hyb_str}` |"
        )
        tex_name = f"\\texttt{{{r['short_name']}}}"
        tex_lines.append(
            f"{tex_name} & {mech} & {oracle_str} & {syn_str} & {unb_str} & {dyn_str} & \\texttt{{{hyb_str}}} \\\\"
        )

    tex_lines.extend(["\\bottomrule", "\\end{tabular}", "\\end{table*}", ""])

    (RESULTS_DIR / "tables.md").write_text("\n".join(md_lines) + "\n", encoding="utf-8")
    (RESULTS_DIR / "tables.tex").write_text("\n".join(tex_lines) + "\n", encoding="utf-8")
    print(f"Rendered {RESULTS_DIR / 'tables.md'} and {RESULTS_DIR / 'tables.tex'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

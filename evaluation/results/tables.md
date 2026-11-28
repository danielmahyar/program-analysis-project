### Table 1: Benchmark Ground Truth (`benchmark.sexp`) vs. Python Analyzers

| Paradigm | TP | FP | FN | TN | Unk | Precision [95% CI] | Recall (Class. / Total) | FPR | FNR | JPAMB Score | In-Proc Median (IQR) ms | CLI Median (IQR) ms |
| :--- | ---: | ---: | ---: | ---: | ---: | :---: | :---: | ---: | ---: | ---: | ---: | ---: |
| Syntactic (AST) | 59 | 12 | 0 | 35 | 0 | 83.1% [72.7, 90.1] | 100.0% / 100.0% | 25.5% | 0.0% | 407.40 | 1.29 (0.32) | 116.9 (9.5) |
| Unbounded Static (Interval × SignSet × Label) | 57 | 7 | 0 | 39 | 3 | 89.1% [79.1, 94.6] | 100.0% / 96.6% | 15.2% | 0.0% | 545.57 | 0.46 (0.65) | 112.1 (8.2) |
| Dynamic (Guided Fuzz, 100 runs) | 44 | 0 | 14 | 46 | 2 | 100.0% [92.0, 100.0] | 75.9% / 74.6% | 0.0% | 24.1% | 428.65 | 9.90 (5.15) | 132.1 (12.6) |
| Hybrid (Warning-inclusive) | 59 | 12 | 0 | 35 | 0 | 83.1% [72.7, 90.1] | 100.0% / 100.0% | 25.5% | 0.0% | 439.69 | 7.02 (7.59) | 130.8 (14.2) |
| Hybrid (Concrete-witness only) | 44 | 0 | 14 | 46 | 2 | 100.0% [92.0, 100.0] | 75.9% / 74.6% | 0.0% | 24.1% | 439.69 | 7.02 (7.59) | 130.8 (14.2) |

### Table 2: Paired Statistical Comparisons of Fuzzing Strategies & Hybrid Triage

| Scope / Family | Comparison ($A$ vs. $B$) | Paired Test & Unit | $A$ vs. $B$ | Diff $\Delta$ [95% Boot CI] | Effect ($r_{\text{rb}}$ / $h$) | Raw $p$ | Holm $p$ |
| :--- | :--- | :--- | :---: | :---: | :---: | ---: | ---: |
| Staged guards | G vs. D | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 30.0% vs 6.7% | +23.3% [+11.7, +35.0] | +0.88 (+0.64) | 0.0044 | 0.0352 |
| Staged guards | G vs. U | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 30.0% vs 0.0% | +30.0% [+20.0, +40.0] | +1.00 (+1.16) | 0.0001 | 0.0015 |
| Opaque pairs | G vs. D | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 5.0% vs 100.0% | -95.0% [-100.0, -85.0] | -1.00 (-2.69) | <0.0001 | <0.0001 |
| Opaque pairs | G vs. U | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 5.0% vs 5.0% | +0.0% [-15.0, +15.0] | +0.00 (+0.00) | 1.0000 | 1.0000 |
| Opaque pairs | D vs. U | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 100.0% vs 5.0% | +95.0% [+85.0, +100.0] | +1.00 (+2.69) | <0.0001 | <0.0001 |
| Neutral targets | G vs. D | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 0.0% vs 0.0% | +0.0% [+0.0, +0.0] | +0.00 (+0.00) | 1.0000 | 1.0000 |
| Neutral targets | G vs. U | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 0.0% vs 45.0% | -45.0% [-65.0, -26.7] | -1.00 (-1.47) | 0.0002 | 0.0024 |
| Neutral targets | U vs. D | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 45.0% vs 0.0% | +45.0% [+26.7, +65.0] | +1.00 (+1.47) | 0.0002 | 0.0024 |
| Product targets | G vs. D | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 0.0% vs 0.0% | +0.0% [+0.0, +0.0] | +0.00 (+0.00) | 1.0000 | 1.0000 |
| Product targets | G vs. U | Exact paired Wilcoxon signed-rank (Seed-collapsed family rate (N=20 seeds)) | 0.0% vs 0.0% | +0.0% [+0.0, +0.0] | +0.00 (+0.00) | 1.0000 | 1.0000 |
| Double loop | D vs. G | Exact two-sided McNemar (Paired RNG seeds (N=20, n10=14, n01=0)) | 100.0% vs 30.0% | +70.0% [+50.0, +90.0] | +1.00 (+1.98) | 0.0001 | 0.0015 |
| Double loop | D vs. U | Exact two-sided McNemar (Paired RNG seeds (N=20, n10=15, n01=0)) | 100.0% vs 25.0% | +75.0% [+55.0, +95.0] | +1.00 (+2.09) | <0.0001 | 0.0008 |
| Triple loop | D vs. G | Exact two-sided McNemar (Paired RNG seeds (N=20, n10=6, n01=3)) | 50.0% vs 35.0% | +15.0% [-15.0, +45.0] | +0.33 (+0.30) | 0.5078 | 1.0000 |
| Triple loop | D vs. U | Exact two-sided McNemar (Paired RNG seeds (N=20, n10=8, n01=1)) | 50.0% vs 15.0% | +35.0% [+10.0, +60.0] | +0.78 (+0.78) | 0.0391 | 0.2734 |
| All 14 challenges (RQ3 discovery) | H vs. G | Exact paired Wilcoxon signed-rank (Method-level detection rate (N=14 methods)) | 12.1% vs 12.1% | +0.0% [+0.0, +0.0] | +0.00 (+0.00) | 1.0000 | 1.0000 |
| All 47 safe methods (Hybrid triage executions) | H vs. G | Exact paired Wilcoxon signed-rank (Method-level executions under 80-run cap (N=47 safe methods)) | 29.4 vs 80.0 | -50.6 [-59.3, -42.0] | -1.00 (--) | <0.0001 | <0.0001 |

### Table 3: Diagnostic Separating Benchmark Cases Across All Four Paradigms

| Method | Structural Mechanism | JVM Oracle | Syntactic | Unbounded Static (Transfers) | Dynamic (100-run) | Hybrid Category |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| `Hospital.deadBranchLeak` | Constant dead branch | Safe | Safe | Safe (6) | Unresolved | `not-found` |
| `BasicLeaks.skippedLoop` | Loop guard initially false | Safe | Safe | Safe (5) | Unresolved | `not-found` |
| `PrecisionBenchmarks.signHoleRangeSafe` | Sign-hole range (x != 0 && x >= 0) | Safe | Warn | Safe (10) | Unresolved | `syntactic-deep-leak` |
| `PrecisionBenchmarks.largeLoopWideningSafe` | 1,000,000-iter loop widening | Safe | Warn | Safe (30) | Unresolved | `syntactic-deep-leak` |
| `BasicLeaks.leakAfterBackEdge` | 2nd-iteration back-edge leak | Leak | Warn | Violation (22) | Witness | `confirmed-leak` |
| `PrecisionBenchmarks.relationalSelfCancelSafe` | Relational (x - y = 0) | Safe | Warn | Violation (9) | Unresolved | `syntactic-deep-leak` |
| `PrecisionBenchmarks.intervalHullHoleSafe` | Convex hull hole ({1,5} excludes 3) | Safe | Warn | Violation (17) | Unresolved | `syntactic-deep-leak` |
| `FuzzingChallenges.stagedMask3` | Staged bitmask guards | Leak | Warn | Violation (18) | Unresolved | `syntactic-deep-leak` |
| `FuzzingChallenges.opaquePair17` | Opaque XOR/OR pair | Leak | Warn | Violation (11) | Unresolved | `syntactic-deep-leak` |
| `FuzzingChallenges.neutralTarget19` | Computed neutral target (7+12) | Leak | Warn | Violation (9) | Unresolved | `syntactic-deep-leak` |
| `FuzzingChallenges.productTarget257` | Computed product (257 * 263) | Leak | Warn | Violation (12) | Unresolved | `syntactic-deep-leak` |
| `PrecisionBenchmarks.helperPassthroughLeak` | Same-class helper leak | Leak | Warn | Unsupported (2) | Unknown | `syntactic-deep-leak` |
| `PrecisionBenchmarks.helperPassthroughSafe` | Same-class helper safe | Safe | Safe | Unsupported (2) | Unknown | `not-found` |
| `PrecisionBenchmarks.recursiveCountdownLeak` | Tail-recursive countdown leak | Leak | Warn | Unsupported (15) | Witness | `confirmed-leak` |

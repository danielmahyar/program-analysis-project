# Confidentiality fuzzing evaluation

The evaluation measures how input selection helps the concrete confidentiality
analyzer discover policy violations. It compares dictionary random sampling,
unguided mutation, and instruction-coverage-guided mutation in the same search
loop. A finding means `join(value label, context) <= destination clearance`
failed on an executed instruction. This is evidence of a violation of the
declared conservative policy, not a proof about semantic noninterference.

## Reproduce the experiment

First generate the Java classes and decompiled JSON with the JPAMB build. From
the repository root, run:

```powershell
.\.venv\Scripts\python.exe solutions/dynamic/src/evaluate_fuzz.py --manifest solutions/dynamic/evaluation/pilot.json --output reports/fuzz-evaluation-pilot --seeds 0 1 2 3 4 --executions 300 --step-limit 2500 --max-steps 100000
.\.venv\Scripts\python.exe solutions/dynamic/src/evaluate_fuzz.py --manifest solutions/dynamic/evaluation/benchmarks.json --output reports/fuzz-evaluation-full --seeds 0 1 2 3 4 --executions 300 --step-limit 2500 --max-steps 100000
```

Use fresh output directories for repeated experiments. The installed entry point
is `coverage-fuzz-evaluate`. `--method ID` can replace the manifest; repeat it for
multiple methods. See the [dynamic README](../solutions/dynamic/README.md#compare-search-strategies)
for configuration and output details.

The pilot has eight methods: three easy leaks, three safe examples, and two
previously hard-to-find nested-loop leaks. The full manifest has the 68
non-recursive methods previously validated in `AdvancedLeaks`, `BasicLeaks`,
`Clearance`, `Compartments`, `Hospital`, and `InfoFlow`. These explicit manifests
select the evaluation targets; they contain no validation inputs or expected
outcomes. Recursion, heap effects, and general calls remain outside the shared
confidentiality subset. This is not a comparison over all JPAMB numeric/string/
array benchmarks.

## Comparison controls

All strategies share executable constants, integer/Boolean typing, the boundary
seed queue, confidentiality settings, and the concrete runner. Dictionary
sampling draws arguments independently from the same dictionary that mutation
uses. Unguided mutation chooses uniformly among every distinct executed input.
Guided mutation chooses uniformly among inputs that added instruction coverage,
plus the initial fallback. The mutation operators are identical in the latter
two strategies. Existing dynamic/hybrid commands keep their guided default.

Every trial gets at most 300 input executions, 100,000 executed instructions in
total, and 2,500 instructions per input. The first exhausted cap stops the trial.
Initial inputs, repeats, and unsuccessful executions cost budget. The common
initial queue is capped at 80 inputs, and nullary methods run once. The five RNG
seeds are 0 through 4. No deadline is enabled in these experiments. Wall time is
recorded as a secondary diagnostic; this is not an isolated runtime benchmark.

The runner and campaign state are fresh per trial. Strategy order rotates across
methods and RNG seeds. A runner error aborts the evaluation and leaves a summary
marked incomplete, rather than recording a search miss. Completed trials remain
available after interruption. Hypothetical hybrid branch taint is excluded.

## Measurements and evidence

`summary.json` contains per-method/strategy detection fractions and paired
found/not-found counts for the same method and RNG seed. `trials.csv` and
`trials.json` retain every trial, including unsuccessful, instruction-limited,
and unsupported runs. Discovery costs are measured at the end of the execution
that first reports a violation. Costs are null if no violation was found; the
consumed execution/instruction budgets remain available as censored observations.
Success-only discovery medians are explicitly named and must not be interpreted
as averages over all trials.

Initial-seed findings, seed cost, and seed coverage are separate from search.
Additional findings and their search costs subtract the seed phase. This matters
because an improved initial queue can find a leak before strategy-specific
exploration starts. A trial that spends its budget on seeds has no search-only
detection estimate. Diagnostic keys distinguish location, destination, and
violation kind; a separate metric counts unique violating instruction locations.

Each trial saves a versioned concrete campaign report under `campaigns/`, with
the strategy, actual settings, program snapshots, findings, and sparse cumulative
progress. Progress records coverage/finding changes, phase boundaries, and the
final execution, supporting plots against executions or instructions. Individual
findings can be replayed with:

```powershell
.\.venv\Scripts\python.exe solutions/dynamic/src/fuzz_cli.py replay reports/fuzz-evaluation-full/campaigns/00001.json
```

Choose a report containing findings; empty reports are evidence of unsuccessful
search and have no witness to replay. Earlier schema-version-1 reports without
the additive `generator.strategy` field still load. Raw generated evaluation
outputs live under the ignored `reports/` directory.

## Initial pilot

The eight-method, five-seed, three-strategy pilot completed all 120 trials.
Every trial reached the 300-execution cap without unsupported or instruction-
limited executions. The three easy leaks were found during the shared initial
queue in every trial. The three safe examples produced no findings.

For the two harder methods, none of the initial seeds found the violation:

| Method | Dictionary random | Unguided mutation | Coverage-guided mutation |
| --- | ---: | ---: | ---: |
| `nestedWhileWeirdCaseLeak` | 5/5 | 1/5 | 0/5 |
| `tripleNestedWhileCornerLeak` | 3/5 | 2/5 | 2/5 |

All 13 distinct hard-example inputs found across these trials were independently
run through the instrumented Java runtime, using the generated classes and host
JDK 25. All 13 produced `assertion error`, matching the concrete Python findings.
The input/output evidence is saved in
`reports/fuzz-evaluation-pilot/hard-witness-jvm-validation.json`.

This pilot does not establish a general ranking. These guards depend on exact
constants and combinations of several arguments. Independent dictionary draws
can combine those constants directly, while instruction coverage may stop
rewarding inputs before they satisfy all the guards. The results justify
measuring the existing design rather than assuming coverage guidance improves
every target. Larger budgets, additional RNG seeds, and broader benchmark
families are separate experiments; retain these baseline results when making
those changes.

## Full 68-method comparison

All 1,020 trials completed: 68 methods, five RNG seeds, and three strategies.
They executed 290,664 inputs and 17,115,024 instructions. The aggregate instruction
cap ended 120 trials; the other 900 used all 300 input executions. There were
5,108 individual step-limited executions and zero unsupported executions. Every
trial reached strategy-specific search. All 120 overlapping pilot trials
reproduced the same non-timing metrics in the full run.

| Metric | Dictionary random | Unguided mutation | Coverage-guided mutation |
| --- | ---: | ---: | ---: |
| Trials with a finding, out of 340 | 203 | 198 | 197 |
| Methods with a finding in at least one of five trials, out of 68 | 41 | 41 | 40 |
| Trials with a finding during initial seeds | 195 | 195 | 195 |
| Trials discovering additional findings during search | 8 | 3 | 2 |

The shared initial inputs already find violations in 39 methods. The only
additional discoveries during search are the two hard nested-loop examples;
their detection counts are the same as in the pilot table above. The overall
trial totals include methods with no observed violation and should not be read
as recall figures. A separate comparison against the previously validated
annotations identified 41 methods with a declared violating case: all 41 were
found by at least one strategy, and no additional method was flagged. Expected
annotations were used only for this retrospective check, never by input selection.

All 628 saved finding diagnostics replayed exactly, including labels, destination,
location, context, and violation kind. Those findings contain 54 distinct
method/input pairs. All 54 were independently executed with the instrumented Java
runtime and produced `assertion error`. This JVM comparison validates terminating
outcomes; the exact structured diagnostic comparison uses the concrete Python
runner. The selected regression suite passed 352 tests with no skips.

A portable aggregate snapshot, including settings, RNG seeds, per-method results,
program digests, and validation counts, is checked in at
[`baseline-results.json`](../solutions/dynamic/evaluation/baseline-results.json).
It records base revision `8b84126` with a dirty working tree containing this
evaluation implementation. Detailed generated evidence remains in
`reports/fuzz-evaluation-full/`, including `finding-replay-validation.json`,
`jvm-witness-validation.json`, and `validation-summary.json`; test results are in
`reports/fuzz-evaluation-tests.xml`.

For this benchmark set and these budgets, executable dictionaries and initial
seeds account for most successful exploration. Instruction coverage guidance did
not improve detection over the two baselines. This is a useful measured limit of
the current design, especially for multi-argument equality guards, rather than
evidence that coverage guidance cannot help other program families.

## Interpretation limits

No finding is not a proof of safety. Full observed instruction coverage is not
coverage of all input values or paths, and a step-limited execution is not proof
of nontermination. Detection fractions here concern the selected benchmark
methods and recorded budgets; they do not estimate recall over all possible
violations. In particular, conservative implicit-flow policy findings can occur
even where two branches compute the same numeric output.

Assess richer feedback, comparison guidance, alternate corpus scheduling, or
minimization only as separately recorded extensions. The baseline harness makes
their benefit measurable without changing the security semantics or silently
adding known validation inputs to the search.

The separate [challenge study](fuzzing-challenge-study.md) now complements this
baseline with four predeclared synthetic families, 12 seed-hard leaking methods,
four safe controls, and 20 RNG seeds per strategy. Its results are reported
separately so the original observations and limitations remain visible.

# Search challenges: hypotheses and observations

The original 68-method evaluation left only two methods unsolved by initial
seeds. This extension creates a separate set of synthetic mechanism tests, so
input strategies can be compared on more than those two examples. It retains
the original baseline and results unchanged.

## What the strategies can learn

The confidentiality monitor answers whether a particular execution violates the
policy. The input strategy decides which execution to try next. All three
strategies use the same monitor, so a difference in discoveries reflects input
exploration rather than a different definition of a leak.

Dictionary sampling independently draws each argument from small values,
executable integer constants, and their neighbours. Unguided mutation keeps
every distinct executed input as a possible parent. Coverage-guided mutation
keeps parents that reached previously unseen instructions, plus an initial
fallback. Both mutation strategies use the same operators: small changes,
dictionary replacements, bit flips, and fresh random integers. Coverage guidance
therefore still has access to dictionary values; the difference is how parents
are retained and selected.

Instruction coverage gives a useful signal when an input opens a new part of
the program. It gives no measure of how close a failed equality was to being
true. Executing the same loop body again also adds no coverage once its
instructions have been visited. An input can consequently be useful for a
future mutation while looking uninteresting to coverage-based retention.

The interpreter computes arithmetic results during execution, but the current
fuzzer does not receive every intermediate value or comparison operand. Its
dictionary comes from executable constants, not from solving expressions or
collecting all computed runtime values. This distinction matters for the
calculated-target families below.

## Predeclared design

[`FuzzingChallenges.java`](../cases/jpamb/cases/FuzzingChallenges.java) contains
12 leaking methods in four families, with three variants per family, and four
safe controls. All guards depend on public parameters. The payload passes a
High-labelled parameter to a Low sink; controls use an allowed High sink.
This holds the confidentiality oracle simple and varies the input search problem.
Existing examples continue to cover implicit flows and compartment lattices.

| Family | Mechanism | Prediction recorded before strategy runs |
| --- | --- | --- |
| Staged coverage | Three nested masked-value guards expose progressively more instructions. | Coverage-guided mutation has the highest family detection fraction. |
| Opaque dictionary | A single predicate combines two exact matches using XOR/OR. Partial matches execute no additional instructions. | Dictionary sampling has the highest detection fraction. |
| Neutral retention | A calculated target is absent from the dictionary. Useful intermediate inputs execute no additional instructions. | Unguided mutation has the highest detection fraction. |
| Arithmetic blind spot | A large calculated product must match exactly, without partial-match feedback. | Every strategy has at most 10% detection; no winner is predicted. |

The exact methods, expectations, rationale, source digest, input-search
implementation digests, compiled program digest, budgets, and RNG seeds are in
[`challenges-protocol.json`](../solutions/dynamic/evaluation/challenges-protocol.json).
The manifest [`challenges.json`](../solutions/dynamic/evaluation/challenges.json)
contains method identifiers only. The protocol was written before comparison
results, and the challenge methods and search strategies were held fixed.

Every strategy gets 300 executions, 100,000 instructions per campaign, and
2,500 instructions per execution. The common seed cap is 80, no deadline is
enabled, and random seeds are 0 through 19. There are 960 campaigns:
16 methods x 20 RNG seeds x 3 strategies. Of these, 720 concern leaking methods
and 240 concern controls. Each family contributes 60 positive trials per strategy.

The shared seed queues have 20 inputs for staged methods and 64 for the other
families. Every seed is charged to the budget. Before any comparison, all seed
queues were executed and checked: every input completed and none found a
violation. Therefore, discoveries in this study require strategy-specific search.
The 32 declared validation cases also matched the Python interpreter and the
instrumented JVM before the study began. Validation examples and expected
outcomes do not enter input generation.

The unit tests check actual bytecode properties: staged guards add instruction
coverage, opaque partial matches do not, and calculated neutral/product targets
are absent from the executable dictionary. These checks do not require any
strategy to win.

## Reproduce

Build the Java cases and reference metadata using the normal JPAMB build:

```powershell
.\.venv\Scripts\python.exe -m cli build --compile --benchmark --document
.\.venv\Scripts\python.exe solutions/dynamic/src/fuzz_study.py --protocol solutions/dynamic/evaluation/challenges-protocol.json --output reports/fuzz-challenges-v1-complete
```

Use a new output directory when repeating the study. The installed command is
`coverage-fuzz-study`. The runner checks protocol/source/program compatibility
and seed eligibility before calling the existing three-strategy evaluator.
Changes to the recorded benchmark or input-search implementation are refused;
a deliberate new experiment needs its own updated protocol and results.

The output includes normal campaign reports, `trials.csv`, `trials.json`, and
`summary.json`, plus a protocol snapshot, initial-seed observations, and
`study-comparison.json`. The comparison includes per-method results, equal-weight
family detection fractions, control counts, the predicted winner, observed ties
or winners, and a descriptive expectation check. To regenerate the comparison
from a completed run, add `--summarize-only` to the same command.

The first execution was interrupted after 917 saved campaigns by a Windows file
lock during aggregate-table replacement. Those reports remain in
`reports/fuzz-challenges-v1/`. Table replacement now retries brief permission
errors and propagates persistent failures. The frozen study was repeated in a
fresh directory; neither methods nor search behavior were adjusted based on
the partial results.

## Results and the hypothetical explanation

All 960 repeated-study campaigns completed, executing 288,000 inputs and
2,362,128 instructions. There were no seed discoveries, unsupported executions,
or instruction-limited executions. Every campaign used its 300-input allowance.

The combined overview includes the original two nested-loop methods as well as
the four new families. The original methods are mixed challenges: they combine
loop-bound requirements, nested guards, and an exact secret value. They are
outside the four deliberately isolated mechanism families. Their original five
seeds were exploratory; the follow-up below records expectations informed by
those observations and checks them on 15 additional RNG seeds.

Every method now has 20 RNG seeds. Counts for each original method are out of
20; each new-family row is out of 60 trials because it aggregates three related
methods. Execution and instruction budget limits are identical. Do not pool
these rows into an overall strategy ranking. Controls are reported separately.

| Family | Predicted best | Dictionary random | Unguided mutation | Coverage-guided mutation | Most likely reason for agreement/disagreement |
| --- | --- | ---: | ---: | ---: | --- |
| Original: `nestedWhileWeirdCaseLeak` | Dictionary, informed follow-up | **20/20** | 5/20 | 6/20 | Loop bounds must reach the corner and the secret must equal 77. Dictionary draws combine relevant values; coverage guidance can also succeed, but less often in these trials. |
| Original: `tripleNestedWhileCornerLeak` | Dictionary, informed follow-up | **10/20** | 3/20 | 7/20 | Three loop bounds and secret -42 must combine. Both coverage progress and exact-value selection matter; the modest difference from guided search remains uncertain. |
| Staged coverage | Coverage-guided | 4/60 | 0/60 | **18/60** | Additional instructions reward partial progress, so coverage retention helps assemble the guards. The narrowest variant still defeats all strategies. |
| Opaque dictionary | Dictionary random | **60/60** | 3/60 | 3/60 | Independent draws combine the two exposed constants. Partial matches supply no instruction-coverage reward. |
| Neutral retention | Unguided mutation | 0/60 | **27/60** | 0/60 | Useful intermediate values add no coverage. Unguided retention keeps them available for further mutations; the other two strategies lack that route. |
| Arithmetic blind spot | All low, no winner | 0/60 | 0/60 | 0/60 | None reasons backwards through the multiplication, and the exact target is absent from the dictionary. |

For the four new families, the observed ordering meets all four predeclared
expectations descriptively. These explanations are consistent with the measured
results and the tested bytecode landscapes; this is not a separate causal
experiment that rules out all other influences, such as scheduling and mutation
probabilities.

Per-method successful trial counts, each out of 20:

| Method | Dictionary random | Unguided mutation | Coverage-guided mutation |
| --- | ---: | ---: | ---: |
| `stagedMask3` | 2 | 0 | 10 |
| `stagedMask4` | 2 | 0 | 8 |
| `stagedMask5` | 0 | 0 | 0 |
| `opaquePair17` | 20 | 1 | 1 |
| `opaquePair29` | 20 | 1 | 1 |
| `opaquePair53` | 20 | 1 | 1 |
| `neutralTarget19` | 0 | 7 | 0 |
| `neutralTarget23` | 0 | 8 | 0 |
| `neutralTarget31` | 0 | 12 | 0 |
| `productTarget257` | 0 | 0 | 0 |
| `productTarget509` | 0 | 0 | 0 |
| `productTarget1031` | 0 | 0 | 0 |

All four safe controls produced zero findings across their combined 240 trials.
The original 917 saved campaigns reproduced the same non-timing metrics in the
completed repetition. All 115 saved finding diagnostics replayed exactly; all 84
distinct method/input witnesses also produced `assertion error` on the
instrumented JVM. The selected regression suite passed 370 tests.

The concise combined export is
[`strategy-comparison.csv`](../solutions/dynamic/evaluation/strategy-comparison.csv).
It has one row per original method or new family, plus a control row. Columns
give the hypothesis basis, expected result, successful-trial counts for each
strategy, their common denominator, and the descriptive interpretation. Counts
are numeric so spreadsheet software does not interpret fractions as dates.
The original methods are explicitly labelled as informed follow-ups, not blind
predictions. Their expectations were checked on the additional 15 seeds; the
CSV's combined twenty-seed counts are descriptive.

This document keeps the explanations, per-method results, budgets, uncertainty,
and validation details. The machine-readable source snapshots remain in
[`challenges-results.json`](../solutions/dynamic/evaluation/challenges-results.json)
and [`nested-loops-results.json`](../solutions/dynamic/evaluation/nested-loops-results.json).
Detailed trial data, reports, progress, replay evidence, and JVM validation are
under `reports/fuzz-challenges-v1-complete/`. Declared case validation, the
initial-seed check, metadata delta, and test XML are under
`reports/fuzz-challenges-validation/`.

The updated conclusion is conditional: coverage guidance helps when intermediate
progress produces new coverage; preserving input diversity helps when useful
steps are coverage-neutral; dictionaries help when exact values are exposed;
all three can fail when no suitable feedback or generator support exists. This
extends the original baseline conclusion rather than replacing it. It does not
support a universal strategy ranking, and it does not turn misses into safety
claims.

## Why these results are plausible

The explanations below connect the code to the observations. The four new
families had expectations recorded before their strategy-specific runs. For the
original nested-loop examples, the expectations were informed by the first five
seeds and checked on additional seeds. Explaining their structure here does not
make those expectations retrospectively blind. The mechanisms are supported by
bytecode checks and the observed outcomes; the experiment does not isolate every
possible influence on the exact success counts.

### Double nested loop: reaching the corner and selecting 77

In `nestedWhileWeirdCaseLeak`, both loop counters start at zero and are capped
below five. The leaking assignment is guarded by:

```java
if (i * 10 + j == 23) {
  if (secret == 77) {
    badge = 999;
  }
}
```

Within those counter ranges, the corner is `i = 2`, `j = 3`. Reaching it requires
`rows >= 3` and `cols >= 4`; the secret must also equal `77`. For example,
`(3, 4, 77)` triggers the violation. Although `999` is a constant, assigning it
under the High-labelled secret condition makes `badge` confidential. Publishing
it to the Low sink then violates the policy.

The structural expectation is that dictionary sampling has an advantage: `77`
occurs directly in bytecode, and many dictionary values make the public bounds
large enough. Independent draws can assemble the whole combination. Coverage
can reward a mutation that first reaches the inner corner and retain that
progress, but subsequent wrong secret values can visit the same instructions.
There is no coverage signal saying that one wrong number is closer to `77`.

The combined results, dictionary 20/20, unguided 5/20, and guided 6/20, fit that
explanation. Guided mutation can still select `77` through its dictionary
operator, so its successes are also expected. Its earlier 0/5 was a small-sample
observation, not evidence that it cannot solve this method.

### Triple nested loop: an additional joint constraint

In `tripleNestedWhileCornerLeak`, the interesting branch requires `i = 1`,
`j = 2`, and `i + j + k = 4`, so `k = 1`. The inputs must allow those iterations:
`a >= 2`, `b >= 3`, and `c >= 2`. The secret must then equal `-42`, at which point
the accumulator explicitly absorbs that confidential value before publication.
A triggering example is `(2, 3, 2, -42)`.

Dictionary sampling can directly supply `-42`, while coverage can help preserve
bounds that expose deeper loop code. The method nevertheless requires four
arguments to work together. That motivates the expectation of lower discovery
than for the double loop: satisfying one condition alone is insufficient, and
mutating a useful input can disturb another condition. This is a qualitative
expectation, not a rule that every method with another loop must be harder;
dictionary composition and mutation probabilities also matter.

Dictionary sampling found the leak in 10/20 trials, guided mutation in 7/20,
and unguided mutation in 3/20. On the additional seeds used to check the
expectation, dictionary sampling led guided mutation only 7/15 to 5/15. Thus the
observed ordering is consistent with the reasoning, but the margin is too small
to justify a strong general ranking.

### Staged guards: partial progress becomes visible

`stagedMask3` contains successive conditions `(a & 7) == 3`, `(b & 7) == 5`,
and `(c & 7) == 6`. Passing the first guard reaches the second test; passing the
second reaches the third. An input such as `(3, 0, 0, secret)` therefore exposes
more instructions than an input that fails immediately, even though neither
has yet triggered a violation.

Coverage-guided retention can keep that intermediate input and mutate another
argument to continue from it. Unguided mutation also retains it, but it selects
parents from all distinct inputs, including many that failed earlier. Dictionary
sampling has to draw a complete successful combination without preserving
partial progress. This is why coverage guidance was predicted to lead.

The observed totals were guided 18/60, dictionary 4/60, and unguided 0/60. The
per-method breakdown is important: guided mutation succeeded in 10/20 trials
with the three-bit mask, 8/20 with the four-bit mask, and 0/20 with the five-bit
mask. Wider masks require more low-order bits to agree, although actual hit
probabilities also depend on the different constants and mutation choices.
Coverage helps preserve progress once found; it does not guarantee enough
progress before the budget ends.

### Opaque pairs: no reward for getting one argument right

The predicate in `opaquePair17` is:

```java
((a ^ 17) | (b ^ 43)) == 0
```

It is true exactly when `a == 17` and `b == 43`. The XOR/OR calculations execute
without separate branches for the two partial matches. Consequently, `(17, 0)`
and `(0, 0)` follow the same failing instruction path. Coverage cannot recognize
that the former has already solved half of the input combination.

Both targets occur directly in the executable dictionary, so independent draws
can combine them. Mutation can also use those constants, but it has to assemble
the pair through its mix of operators and parent choices. Guided retention can
discard a useful partial match because it adds no coverage. This supports the
prediction favouring dictionary sampling and is consistent with dictionary
60/60 versus 3/60 for each mutation strategy.

The secret parameter is only the confidential payload in this family: its
numeric value does not have to equal a particular number. Reaching the Low sink
with its High label is enough. Also, the three pair variants share their shape,
dictionary structure, and RNG seeds. Their repeated success counts should not
be interpreted as 60 independent real-world confirmations.

### Neutral targets: a useful mutation parent can have ordinary coverage

`neutralTarget19` calculates its target using a non-final local:

```java
int target = 7;
target += 12;
if (x == target) {
  publishLow(secret);
}
```

The compiled method contains the operands `7` and `12`, but not the calculated
target `19`. The dictionary includes `11`, as a neighbour of `12`. Executing
`x = 11` does not reach new instructions compared with other wrong values, yet
the supported `+8` mutation can turn it into the successful `x = 19`.

Unguided retention keeps neutral inputs such as `11` available as parents.
Guided retention discards them when they add no coverage; in these methods it
keeps the initial fallback instead. Dictionary sampling cannot draw a target
absent from its dictionary. Guided mutation still has a fresh random-integer
operator that could hit the target, but that is a very rare route within a
300-execution budget. The interpreter calculating `19` does not automatically
teach that value to the input selector.

The other two variants have the same kind of bridge: `15 + 8 = 23` and
`23 + 8 = 31`. Unguided mutation found violations in 27/60 trials, while the
other strategies found none. These results illustrate why preserving value
diversity can matter even when every intermediate input has identical coverage.

### Product targets: all strategies lack useful feedback

`productTarget257` calculates `257 * 263 = 67591` before comparing the result
with `x`. The product is absent from the executable dictionary. Unlike the small
neutral targets, there is also no comparably short, obvious bridge from a
dictionary value using the available small deltas. The only conditional branch
reveals whether the entire equality succeeds, so partial numeric progress adds
no instruction coverage.

The interpreter evaluates the multiplication correctly, but none of the input
strategies works backwards from the equality to choose `x`. Unguided mutation
can retain intermediate values and the mutation strategies can draw fresh
integers; those possibilities do not provide an effective search direction
under this budget. All three strategies produced 0/60 discoveries, consistent
with the prediction that they would struggle. Known violating inputs were
independently validated, so these zero counts show a search limitation, not
that the methods are safe.

### Safe controls: reaching the guarded code need not be a violation

Each control preserves a family's search structure but sends the High-labelled
payload to an allowed High sink. Even an input satisfying every guard should
therefore complete without a confidentiality violation. The 240 control trials
produced no findings, as expected. That is a useful check that the monitor is
enforcing the destination's clearance rather than treating deeper coverage or
any use of a secret as a leak. The zero finding count alone does not establish
that every strategy reached each guarded sink.

## Nested-loop follow-up: informed expectations and additional seeds

The follow-up uses the original two methods and unchanged input strategies,
with the same 300-execution, 100,000-total-instruction, and 2,500-per-input
limits. The source and compiled-program snapshots matched the original baseline
before execution. Expectations were written to
[`nested-loops-protocol.json`](../solutions/dynamic/evaluation/nested-loops-protocol.json)
before inspecting seeds 5 through 19 for these methods:

- Dictionary sampling should have a strictly higher detection fraction than
  each mutation strategy on each method, evaluated on seeds 5 through 19.
- Dictionary sampling should find the triple-loop leak less often than the
  double-loop leak on those additional seeds.
- No ordering between the two mutation strategies was predicted.

These are informed expectations, based on the already seen five-seed results;
they are not hypotheses formed before all observations. Re-executing seeds 0
through 4 tests reproducibility and adds no independent evidence. The primary
expectation checks use only the 15 additional RNG seeds. Combined counts provide
a twenty-seed descriptive estimate.

| Method and partition | Dictionary random | Unguided mutation | Coverage-guided mutation |
| --- | ---: | ---: | ---: |
| Double loop, original seeds 0-4 | 5/5 | 1/5 | 0/5 |
| Double loop, additional seeds 5-19 | **15/15** | 4/15 | 6/15 |
| Double loop, combined seeds 0-19 | **20/20** | 5/20 | 6/20 |
| Triple loop, original seeds 0-4 | 3/5 | 2/5 | 2/5 |
| Triple loop, additional seeds 5-19 | **7/15** | 1/15 | 5/15 |
| Triple loop, combined seeds 0-19 | **10/20** | 3/20 | 7/20 |

Both primary expectations and the secondary expectation match descriptively on
the additional seeds. The triple-loop difference between dictionary and guided
search is only 7/15 versus 5/15, so this is not strong evidence of a general
ranking. The larger sample also changes the earlier zero-success observation:
coverage guidance finds the double-loop leak in 6/20 trials. Zero out of five
was an unsuccessful small sample, not an inability of the strategy to find it.

All 120 follow-up campaigns completed: 36,000 inputs and 5,645,818 instructions,
with no initial-seed discoveries, limited executions, or unsupported executions.
All 30 original campaigns reproduced their non-timing metrics. All 51 saved
finding diagnostics replayed exactly; all 44 distinct witness inputs also
triggered `assertion error` on the instrumented JVM. The selected regression
suite passed 376 tests, including checks that informed expectations are evaluated
only on the additional-seed partition.

[`nested-loops-results.json`](../solutions/dynamic/evaluation/nested-loops-results.json)
preserves the original, additional, and combined partitions. Detailed trial and
validation evidence is in `reports/nested-loops-20-seeds-v1/`. The summarizer can
also export a detailed partition CSV into that run directory.

To repeat the comparison in a fresh output directory, use the existing evaluator
with `evaluation/nested-loops.json`, seeds 0 through 19, and the recorded budget
limits. Save the unchanged protocol as `study-protocol.json` inside that output
directory. The summarizer checks campaign settings, seed partitions, and original
detection-count replication before exporting results:

```powershell
.\.venv\Scripts\python.exe solutions/dynamic/src/evaluate_fuzz.py --manifest solutions/dynamic/evaluation/nested-loops.json --output reports/nested-loops-repeat --seeds 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 --executions 300 --step-limit 2500 --max-steps 100000
Copy-Item -LiteralPath solutions/dynamic/evaluation/nested-loops-protocol.json -Destination reports/nested-loops-repeat/study-protocol.json
.\.venv\Scripts\python.exe solutions/dynamic/src/fuzz_followup.py --protocol solutions/dynamic/evaluation/nested-loops-protocol.json --run reports/nested-loops-repeat --output reports/nested-loops-repeat/followup-results.json
```

## Limits of the experiment

Three variants in a family share a mechanism and are not three independent
real-world programs. Twenty RNG seeds measure run-to-run variation for a fixed
method, not breadth of application coverage. Family averages and the
"expectation met" field are descriptive; they are not statistical significance
tests. Per-method results remain available rather than being hidden by a pooled
score. Controls, ties, misses, and all-zero families remain in the report.

These are deliberately constructed tests of possible strengths and limitations.
Their purpose is to explain when feedback or input diversity helps, not to claim
that any strategy is generally best. Absence of a discovery is not proof of
safety: every positive challenge has an independently validated violating input.
The shared monitor detects the same policy violation whichever strategy supplies
the input. Larger budgets or new families are separate follow-up experiments.

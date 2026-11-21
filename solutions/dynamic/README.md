# Dynamic analysis and independent fuzzing core

The `dynamic-interpreter` and `dynamic-analysis` commands use the concrete
interpreter in `src/dynamic.py` and shadow labels in `src/security_monitor.py`.
The independent fuzzing modules support coverage-guided input exploration with
an injected runner. They consume execution observations without deciding
whether a confidentiality flow is permitted.

## Current milestone

- `src/fuzz_contract.py`: execution results, confidentiality diagnostics, and a
  callable runner protocol.
- `src/fuzz_inputs.py`: immutable JPAMB integer/Boolean inputs, bounded seeds,
  executable constant dictionaries, and signed 32-bit mutations.
- `src/coverage_fuzz.py`: corpus selection, cumulative instruction coverage,
  execution/instruction/time budgets, and deduplicated findings.
- `tests/test_coverage_fuzz.py`: controlled-runner tests, including discovery
  through an intermediate input, partial executions, and reproducibility.
- `tests/test_dynamic_confidentiality.py`: real-interpreter regressions for
  confidentiality policies, control dependencies, and fuzzer integration.

`dynamic.make_runner(bc, policy)` now provides a concrete adapter, and the existing
`dynamic-analysis` command calls the fuzzer for int/boolean inputs. The monitor
uses only the confidentiality dimension and shares boundary-policy initialization
with `jpamb.confidentiality`: fixed parameter/local writes are certified, inferred
locals use strong updates, and returns use the declared or configured clearance.
Branch dependencies on existing stack values survive control-region merges.

Campaigns can be saved as versioned JSON and their findings replayed through the
`coverage-fuzz` command described below. The `coverage-fuzz-evaluate` command runs
controlled comparisons with dictionary sampling and unguided mutation. The
analysis command prints prediction categories and separate counts for
completed, unsupported, and step-limit runs. The `timeout` prediction category
is a heuristic; no infinite execution is recorded as an observed outcome.

## Save and replay campaigns

From the repository root, using the project environment and already generated
bytecode, run:

```powershell
.\.venv\Scripts\python.exe solutions/dynamic/src/fuzz_cli.py run "jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" --executions 100 --output reports/hospital-fuzz.json
.\.venv\Scripts\python.exe solutions/dynamic/src/fuzz_cli.py replay reports/hospital-fuzz.json --finding 1
```

Installing the dynamic project also exposes the same interface as `coverage-fuzz`:

```bash
uv run --project solutions/dynamic coverage-fuzz run "jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" --output reports/hospital-fuzz.json
uv run --project solutions/dynamic coverage-fuzz replay reports/hospital-fuzz.json
```

Replay without `--finding` checks every saved finding. Use `--suite PATH` when
the report is moved to another checkout. Replay restores the recorded input,
actual per-execution instruction limit, and confidentiality settings; ambient
return-clearance environment variables do not override them. It compares the
location, destination, violation kind, effective label, clearance, and context.

Exit codes are 0 for a successfully saved campaign or matching replay, 1 when a
replay does not reproduce the recorded violation, and 2 for invalid input/report,
changed/missing program artifacts, or a report containing no findings to replay.
A campaign with no findings still saves successfully and is not a security proof.

`run` accepts `--seed`, `--executions`, `--step-limit` (per input), `--max-steps`
(campaign total), `--timeout`, `--seed-limit`, `--return-clearance LEVEL`, and
repeatable `--local-clearance SLOT=LEVEL`. Its int/boolean generator uses the
same bytecode constants and boundary seeds as the dynamic analysis. Deadlines
are cooperative between executions. No `@Case` input or expected outcome seeds
the search.

The JSON format is `jpamb-coverage-fuzz`, schema version 1. It records:

- The method, producer/version, checkout revision and dirty flag, and program
  snapshot digests. Digests cover decompiled bytecode and policies, normalized
  as canonical JSON so whitespace, object-key order, and line endings do not
  prevent relocation. Actual artifact changes cause replay to refuse execution.
- Campaign budgets/random seed and confidentiality settings, the dictionary and
  configured seed queue, retained corpus, coverage locations, status counts,
  observed terminating outcomes, stop reason, and elapsed time.
- Numbered findings with encoded inputs, full diagnostics, discovery execution
  and cumulative steps, and the instruction allowance actually used for replay.

Reports are atomically written. A saved report reproduces individual findings;
it does not promise the exact same whole campaign under different runtime code,
wall-clock performance, or custom mutation functions. Git revision metadata is
informational; replay verifies program artifacts and the observed violation.

To export reports from existing JPAMB analysis commands, set:

```powershell
$env:JPAMB_FUZZ_REPORT_DIR = "reports/fuzz"
```

The dynamic and hybrid analyzers then save uniquely named reports for their
int/boolean campaigns, including unsuccessful/incomplete searches. Prediction
stdout remains unchanged; saved file paths go to stderr. Unset the variable to
disable export. Existing string/array fallback paths are outside this reporting
scope.

Concrete and hypothetical evidence are tagged separately. Hybrid optional
untaken-branch reports use mode `hybrid-pretaint` and evidence kind `hypothetical`.
Replay selects that mode and labels its result accordingly; a matched hypothetical
finding is not a concrete leak witness. It requires the hybrid/parser dependencies.
The standalone `run --mode hybrid-pretaint` is also available for explicit probes.

## Compare search strategies

With generated bytecode present, run the eight-method pilot from the repository root:

```powershell
.\.venv\Scripts\python.exe solutions/dynamic/src/evaluate_fuzz.py --manifest solutions/dynamic/evaluation/pilot.json --output reports/fuzz-evaluation-pilot --seeds 0 1 2 3 4 --executions 300 --step-limit 2500 --max-steps 100000
```

Use `evaluation/benchmarks.json` instead of `evaluation/pilot.json` for all 68
previously validated non-recursive methods. The manifests contain method IDs
only; they supply no inputs or expected outcomes. Select individual targets with
repeatable `--method ID` in place of `--manifest`. Each run needs a new or empty
output directory so earlier evidence cannot be overwritten accidentally.
After installing the dynamic project, the same interface is available as
`coverage-fuzz-evaluate` (for example via `uv run --project solutions/dynamic`).

The default comparison uses three strategies in the same campaign loop:

| Strategy | Selection after the shared initial seeds |
| --- | --- |
| `dictionary-random` | Independently draw each integer from the executable constant/small-value dictionary and each Boolean uniformly. No mutation parent. |
| `unguided-mutation` | Select a parent uniformly from every distinct executed input, regardless of coverage, and use the existing typed mutations. |
| `coverage-guided` | Select a parent uniformly from inputs retained for adding instruction coverage, and use the same typed mutations. |

All strategies execute the same boundary seed queue, use the same dictionary,
and receive the same per-input, aggregate instruction, and execution allowances.
`--seed-limit` caps the common initial queue (default 80). Repeated inputs and
seeds cost budget. The first exhausted cap ends a campaign; loop-heavy strategies
may therefore execute fewer inputs. Nullary methods execute once. The default
has no wall-clock deadline; `--timeout SECONDS` enables a separate deadline-based
experiment. Strategy order rotates across methods/trial seeds. Fresh campaign
and runner state is used for every trial.

Output contains `trials.csv`, `trials.json`, `summary.json`, and one saved report
under `campaigns/` for each trial. Each report uses the existing replay format,
records `generator.strategy`, and adds evaluation metrics and sparse cumulative
progress at coverage/discovery changes, phase boundaries, and the final execution.
Replay any finding with `fuzz_cli.py replay PATH`. Reports created before the
strategy field was added still load and replay.

Metrics include detection fraction per method/strategy, executions/instructions/
elapsed time to the first finding, unique violation locations and diagnostic
keys, coverage counts, status counts, and stop reasons. Initial-seed discoveries
and additional discoveries during search are separate. Search-only discovery
costs subtract the seed phase; a trial that never reaches search has no search
detection estimate. Failed trials keep null discovery costs and their consumed
budgets. Success-only medians are explicitly labelled and must be read with the
detection fractions. Coverage is a count of visited instructions, not a percentage
of all feasible instructions or paths.

The summary pairs strategies on the same method/RNG seed, counts findings by both,
either, or neither, and retains unsupported/limited trials in the denominators.
An interrupted run preserves completed trial reports/tables and marks the summary
`complete: false`. Unexpected runner errors abort the experiment instead of being
converted into unsuccessful trials. Runtime includes search, progress recording,
and lazy runner setup; it excludes report writing and is a secondary diagnostic.

The primary comparison uses only concrete confidentiality evidence, with default
policy settings independent of ambient environment variables. Optional
`--return-clearance` and repeatable `--local-clearance SLOT=LEVEL` settings apply
equally to every strategy. No hybrid hypothetical taint is included. No-find is
not evidence that a method is safe, and coverage guidance is not assumed to win.
See [evaluation results and methodology](../../docs/fuzzing-evaluation.md).

## Runner interface

```python
from coverage_fuzz import FuzzConfig, fuzz
from fuzz_inputs import InputSpace

# `method` is an already decoded jvm.Method. `run_once` follows the contract below.
campaign = fuzz(
    method.id,
    InputSpace.from_method(method),
    run_once,
    config=FuzzConfig(max_executions=1000, step_limit=200, max_steps=100_000),
    security_config=your_confidentiality_settings,
)

for finding in campaign.findings:
    print(finding.inputs.encode(), finding.violation)
```

The concrete adapter exposes this interface:

```python
def run_once(method_id, inputs, *, step_limit, security_config):
    # Start fresh concrete/shadow state, run at most step_limit instructions,
    # and return fuzz_contract.RunResult. This is the interpreter's responsibility.
    ...
```

For the concrete adapter, `security_config` is `None` or a
`jpamb.confidentiality.Config`. Its fixed local clearances and return default are
honoured; explicit annotations take precedence, and local constraints cannot
relax a parameter's declared clearance. `JPAMB_CONF_RETURN_CLEARANCE` configures
the CLI's unannotated return default, which otherwise is lattice bottom.

The runner caches initialized policy/CFG models per method body and settings,
within that runner only. It does not execute a static worklist. Every execution
gets fresh concrete locals, shadow locals/stacks, and branch contexts. The
configuration's `max_steps` is the static worklist limit; concrete budgets use
the runner's `step_limit` and `FuzzConfig.max_steps` instead.

The shared confidentiality subset is primitive int/boolean values and
intraprocedural branches/loops with verified empty static void sinks. Heap effects,
references, general calls, and unsupported method metadata produce `unsupported`
when encountered or validated. Ordinary classes without a security policy retain
the wider concrete interpreter, including its numeric runtime outcomes.

Use only the `conf` lattice dimension. Check fixed destinations using
`join(value_label, context) <= clearance`. Inferred local labels may change;
fixed clearances do not. See [the implementation plan](../../docs/coverage-fuzzing-plan.md)
for boundary rules shared with the static analysis.

Return `status="completed"` with a terminating JPAMB outcome. Confidentiality
violations terminate with `outcome="assertion error"` and structured `Violation`
objects; ordinary assertions do not automatically create those diagnostics.
Include the violating instruction in coverage and count it in `steps`.

On exhaustion or unsupported instructions return `status="step-limit"` or
`"unsupported"`, `outcome=None`, and any partial coverage. An unsupported
instruction itself is not counted as executed. Interpreter bugs should propagate
as exceptions. Timeouts are cooperative between runner calls: instruction limits
are the runner's responsibility, and the fuzzer cannot interrupt a blocked call.

Each campaign uses local deterministic randomness and fresh search state. Seeds
and repeated candidates cost executions. Empty seed collections get an all-zero
fallback; methods without arguments are executed once. A corpus entry must add
coverage, except for the first fallback. Novel violation sites are saved even if
coverage does not grow. No expected `@Case` input or outcome is read.

The core does not certify the absence of violations or prove nontermination.
`campaign.outcomes` records observed terminating outcomes only. Counts of
unsupported and limited runs remain separate. The execution runner, rather than
the exploration layer, must reset its own execution state for every call.

## Tests

From the repository root, in an environment with the development dependencies:

```bash
python -m pytest solutions/dynamic/tests -q
```

Root pytest configuration adds both source directories to the import path. These
fixture tests need no Java or Docker. They exercise the exploration core and
real concrete interpreter using decoded bytecode fixtures, including saved report
round-trips and replay. The compiled CLI check skips until generated artifacts
exist; the optional hybrid report check needs the hybrid/parser dependencies.
Running the actual Java benchmark through JPAMB requires generated class/decompiler files.

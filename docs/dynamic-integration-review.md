# Dynamic integration review, 2026-11-18

Reviewed checkout: `d200a57` on `main`. Comparison base: `2897137`, the independent
fuzzing milestone. This review records the local checkout and its existing origin
reference; it did not fetch or modify remote branches.

## Compiled benchmark validation, 2026-11-21

The implementation at `28e47a4` was validated against compiled Java classes,
after starting Docker Desktop and building with the configured
`ghcr.io/kalhauge/jvm2json:jdk-latest` image (digest
`sha256:86c333ed74caf4459a17b05cd03b7b32f3bd5814b7826aa0da7f9a260562b377`).

- 301 selected tests pass, including both formerly skipped compiled-artifact
  suites and two new benchmark-ground-truth regression checks. No selected tests
  are skipped.
- JPAMB interpreter validation passes all 115 non-recursive security cases.
- Direct execution of all 121 declared security inputs completes 118 with zero
  outcome differences from actual JVM executions. The remaining three inputs
  reach recursive calls and return `unsupported`, not a fabricated outcome.
- Bounded JVM tracing covers 202 declared inputs. The 198 terminating traces
  agree with their annotations. Four exceed the 2500-instruction trace budget:
  three declared infinite-loop cases and the finite `Calls.allPrimesArePositive(100)`
  example. Budget exhaustion is not treated as a nontermination proof.
- Both dynamic and hybrid analysis commands run over the 68 non-recursive
  confidentiality methods. This validates command integration, not perfect input
  search or a statistical comparison of their performance.

The analysis smoke runs exposed two omitted legitimate outcomes:
`BasicLeaks.implicitWhile(0)` and `AdvancedLeaks.doWhileLeak(0)` both return `ok`
on the JVM and our concrete interpreter. Their annotations previously listed
only `assertion error`, incorrectly penalizing discovered successful executions.
Both `@Case("(0) -> ok")` annotations were added after JVM verification, and
the case/benchmark metadata was regenerated. The semantic metadata delta is
exactly two new input entries and updated aggregates for those two methods;
existing entries were not removed. Regression tests preserve this evidence.

The default bounded dynamic search still misses the violating input combinations
in `AdvancedLeaks.nestedWhileWeirdCaseLeak` and
`AdvancedLeaks.tripleNestedWhileCornerLeak`. Executing their supplied violating
inputs directly does detect the violations, so this is an exploration limitation
to measure in the planned evaluation, rather than a mismatch in the concrete
confidentiality checks.

Detailed JSON, JVM traces, pytest results, and CLI logs are saved under the ignored
`reports/benchmark-validation-20261121/` directory. The next implementation work
is persistent general-purpose findings/replay and a controlled evaluation harness.

## Implementation follow-up, 2026-11-21

The runtime corrections and real-runner regression tests are now implemented in
the working tree. The remaining sections preserve the original review of
`d200a57` and its pre-fix observations.

- The monitor checks only `conf`, reuses the static engine's boundary/CFG
  initialization, and honours `Config` local constraints and return defaults.
- Fixed parameter/local writes and increments are certified. Successful writes
  retain fixed labels; inferred local temporaries retain strong-update behaviour.
- Branch contexts taint live stack values when their regions end. Context storage
  is bounded by branch locations, and early returns/loops follow the shared scopes.
- Prepared models are scoped to a runner and keyed by method body and settings;
  the global method-id-only post-dominator cache has been removed.
- The adapter enforces caller-supplied instruction budgets and keeps unsupported
  executions distinct. Shadow-stack corruption raises an implementation error.
- CLI summaries separate status counts from terminating outcomes, and
  `JPAMB_CONF_RETURN_CLEARANCE` reaches the actual concrete runner.
- `test_dynamic_confidentiality.py` exercises the real interpreter and monitor,
  safe/violating paths, configuration changes, method-body replacement,
  ordinary assertions/numeric cases, incomplete executions, and campaign replay.

Heap/reference effects and arbitrary calls are explicitly unsupported for
confidentiality runs; ordinary non-security execution remains available. The
compiled validation results above supersede this follow-up's original pending
validation. Persistent reports, CLI replay, and strategy comparisons remain.

## What changed

### Integration of the three additional commits

The subsequent pull fast-forwarded main to `ef2fd23`, incorporating `f0742c9`,
`66ebe39`, and `ef2fd23`. The confidentiality implementation and its regression
tests were preserved. The confidentiality-only annotation/case cleanup agrees
with the current scope.

The new hybrid analyzer subclassed the earlier monitor's product labels and
`ipdom`/`pc_stack` fields. It has been adapted to the current string labels,
prepared CFG models, and bounded branch contexts. Its execution adapter now
delegates to the shared runner through an injectable monitor factory, preserving
configuration, budget checks, and error/status handling. Its orchestration also
keeps step-limit status separate from observed outcomes.

New artifact-independent compatibility tests cover AST constant extraction,
early-return analysis, dead-branch pruning, fixed destinations, settings,
concrete/hypothetical evidence separation, budgets, and a combined AST/fuzzing run.
The AdvancedLeaks recursion examples remain outside the concrete confidentiality
subset. Compiled Java tests still require generated artifacts and Docker.

The pre-pull working tree is preserved in a named Git stash and in the ignored
`target/codex-integration-backup-20261121-1c6b51d1` directory. No local changes were
committed or pushed as part of the integration.

- `4769a8e` adds a substantially expanded concrete interpreter in
  `solutions/dynamic/src/dynamic.py` and Python shadow-label tracking in
  `solutions/dynamic/src/security_monitor.py`.
- `dynamic.make_runner(bc, policy)` already implements the callable interface to
  `fuzz_contract.RunResult`.
- `dynamic.analyse()` already calls `coverage_fuzz.fuzz` for int/boolean inputs.
  It adds constant collection, boundary-combination seeds, a separate fallback
  for strings/arrays, and outcome/prediction reporting.
- The upstream merge adds a decompiler timeout, fixes opcode documentation
  collection/links, and fixes `Benchmark.entries()` deduplication. Those changes
  do not require a redesign of the fuzzing core.
- The earlier fuzzing core and its tests remain intact. No integration tests were
  added in the interpreter commit. The README and plan still described the
  adapter as missing before this review updated them.

The architecture is compatible with the plan. The immediate gap is agreement on
security semantics and evidence that the new runner implements them.

## Checks performed

The following selected existing tests passed: **172 passed**.

```bash
python -m pytest solutions/dynamic/tests tests/test_jpamb_case.py \
    tests/test_jvm_state.py tests/test_confidentiality.py \
    tests/test_static_confidentiality_cli.py -q
```

These tests validate the existing core/static functionality. They do not validate
the newly added concrete interpreter or Python security monitor.

Additional in-memory bytecode probes used the existing `tests.test_confidentiality`
fixture builder with the real `dynamic.make_runner`. Each independent fixture
cleared the monitor's global post-dominator cache, since fixture methods reuse
the same identifier with different code. The results below were observed, not
inferred solely from a source inspection.

| Probe | Expected under current Python confidentiality rules | Actual dynamic result |
| --- | --- | --- |
| Explicit Oncology value passed to a Public sink | Violation | Correctly reports explicit violation |
| Psychiatry branch `score > 30`, then send assigned flag to Oncology | Input 10: ok; input 40: violation | Correctly reports ok / implicit violation |
| Run the previous inputs in sequence 10, 40, 10 | Last execution is independently ok | Correctly reports ok / violation / ok |
| Assign Oncology data to a fixed Public parameter | Violation at assignment | Returns ok, no diagnostic |
| Assign Oncology data to local slot 1 with `Config(local_clearances={1: "Public"})` | Violation at assignment | Returns ok, no diagnostic |
| Return Oncology data without an explicit return annotation | Violation under default bottom/Public return clearance | Returns ok, no diagnostic |
| Overwrite a fixed Oncology parameter with zero, then return it through a Public return | Parameter retains its fixed label; return violates clearance | Returns ok, no diagnostic |
| Choose existing stack values under a secret using swap/pop, then return through Public | Implicit violation | Returns ok, no diagnostic |
| Return Public/Untrusted data through Public/Trusted clearance | No confidentiality violation | Reports an integrity-based violation |

The stack-selection probe is the bytecode sequence from
`test_secret_stack_selection_cannot_escape_at_postdominator`, with an explicit
Public return annotation so the result isolates control-dependency handling.

An end-to-end campaign over the threshold/compartment bytecode fixture used
`InputSpace.from_method`, the real adapter, and 100 executions. It observed both
`ok` and `assertion error`, preserved one implicit violation at instruction 9,
and had zero unsupported/limited executions. The saved input was `(1073741824)`.
This establishes that the exploration-to-runner connection works for that case;
it does not establish correctness on the complete benchmark.

The generated `target/classes` and `target/decompiled` artifacts are absent in
this checkout. Consequently, the compiled Hospital/InfoFlow benchmark pipeline
has not been validated by this review. Source-equivalent bytecode fixtures were
used for the targeted probes instead.

## Required corrections before evaluation

### 1. Use confidentiality consistently

`SecurityMonitor` uses the complete `policy.product_lattice` for joins and
certification. This includes integrity, contrary to the current project scope.
Select the `conf` dimension for every source, context, destination, and diagnostic.
Reuse the existing declared order rather than inventing another lattice model.

The out-of-scope integrity probe used Public confidentiality on both input and
return, Untrusted integrity on the input, and Trusted integrity on the return.
The static confidentiality analysis reports safe; the new dynamic monitor fails.

### 2. Honour security settings and fixed destinations

`run_once` accepts `security_config` but does not pass it to `make_monitor` or use
it anywhere. `store` and `incr` always infer replacement local labels.

Pass through the agreed Python confidentiality configuration. Maintain fixed
parameter/local-slot clearances separately from inferred values. Certify writes
to those slots, preserve their fixed labels, and terminate the execution with a
structured diagnostic on failure. Keep inferred temporary strong updates.

At returns, use the explicit annotation first, then the configured return
clearance, then lattice bottom, matching the static implementation.

### 3. Preserve control dependencies at merge points

`SecurityMonitor.at` pops branch contexts at the merge but does not attach the
leaving context to live stack values. `swap`/`pop` can therefore select a value
under a confidential condition without retaining that dependency.

Use the same boundary model as `confidentiality.AbstractInterpreter.scoped` while
following only the concrete path. Add coverage for stack choices, nested branches,
early returns, loop contexts, and safe public values created after the merge.

### 4. Keep incomplete executions separate in reporting

The adapter correctly returns `status="step-limit"` and no terminal outcome.
However, `analyse` converts those runs into entries in `outcomes["*"]`.

A finite three-iteration loop returned `step-limit` with a five-instruction budget
and `ok` with 100 instructions. The current CLI summary nevertheless printed
`outcomes {'*': 1}` and emitted `*;timeout` with the small budget. The category
`timeout` is not a proof of nontermination, but the summary should distinguish
budget exhaustion from an observed program outcome.

Use campaign status counts for limited/unsupported runs and campaign terminating
outcomes for observed results. Keep any heuristic prediction category explicitly
separate. Avoid duplicate outcome accounting in the wrapper.

## Evaluation and boundary issues

- The CLI now combines boundary enumeration and coverage-guided mutation. With
  executable constants `[0, 30]`, the helper generated 20 seeds for one integer
  argument and 64 for two or three arguments, against a default 100-run budget.
  Account for seed discovery separately and use identical seed lists in ablations.
  A better seed list alone must not be credited to coverage guidance.
- `tracking_runner` changes per-execution allowances after the first 25 calls.
  Use a documented common budget policy for all comparison strategies; simplifying
  this to the caller-supplied instruction limit would make results easier to assess.
- Arrays/strings and general calls extend beyond the shared confidentiality
  subset. The new monitor has no shadow heap for array elements. Keep ordinary
  benchmark support separate from the confidentiality claims and comparisons.
- `_IPDOM_CACHE` is globally keyed only by method identifier. Scope it to a
  prepared bytecode/program instance or include code identity so reloads and
  fixtures cannot reuse control-flow metadata from a different method body.
- Shadow-stack underflow currently synthesizes a bottom-labelled value, and
  several exception types are translated to unsupported results. Make malformed
  shadow state explicit, with regression tests, so interpreter bugs are not
  silently presented as normal analysis limitations.

## Revised delivery order

1. Preserve the existing fuzzing core and reuse `dynamic.make_runner`; another
   adapter or interpreter is unnecessary.
2. Add regression tests for the confirmed discrepancies and correct the monitor's
   confidentiality scope, configuration, fixed writes, returns, and control-flow
   boundaries. Keep ordinary numeric behaviour separate from policy failures.
3. Add runner/fuzzer integration tests using the real interpreter: explicit and
   implicit leaks, compartment joins, fixed destinations, public overwrites,
   context restoration, early returns, bounded loops, independent executions,
   ordinary assertions, unsupported instructions, and budget exhaustion.
4. Rebuild generated bytecode and validate the supported confidentiality cases
   through the actual JPAMB commands. Do not score integrity-only outcomes as
   expected confidentiality violations.
5. Consolidate outcome/status reporting and add persistent reports plus CLI replay.
6. Evaluate constant/small-value testing, unguided mutation, and coverage-guided
   mutation with shared seeds, operators, policy, and budgets.

The original review changed documentation only. Its semantic corrections and
integration regressions have since been implemented and validated on generated
JPAMB bytecode as described in the follow-ups above.

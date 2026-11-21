# Coverage-guided fuzzing for confidentiality

Implementation plan based on the current Python confidentiality analysis. The
independent first milestone is implemented in `solutions/dynamic/src/fuzz_contract.py`,
`fuzz_inputs.py`, and `coverage_fuzz.py`, with controlled-runner tests. Commit
`4769a8e` adds a concrete interpreter, Python shadow monitor, `dynamic.make_runner`,
and CLI calls to the fuzzer. The 2026-11-21 implementation aligns the runner with
the Python confidentiality rules and adds real-runner integration regressions,
including configuration, fixed writes, return defaults, control dependencies,
and a replayable fuzzing campaign. See the
[integration review and follow-up](dynamic-integration-review.md) for the original
discrepancies and their resolution. Compiled JPAMB validation now passes for the
supported subset: 301 selected tests, 115 interpreter cases, and 118 completed
security executions agreeing with the JVM. Three recursive executions remain
unsupported. Versioned user-facing campaign reports and CLI replay are now
implemented in `fuzz_reports.py` and `fuzz_cli.py`, with concrete/hypothetical
provenance and program snapshots. Controlled strategy comparisons remain future work.

## Purpose and scope

Automatically search for concrete inputs that reach confidentiality violations,
preserve replayable examples, and compare input-selection strategies under equal
budgets. Coverage guides exploration; the dynamic interpreter checks security.

The first version supports static, intraprocedural methods with `int` and
`boolean` inputs, inferred locals, structured branches/loops, and the annotated
empty sink methods already supported by the static analysis. It checks
the `conf` dimension. Heap effects, arrays, strings, general calls, timing,
termination channels, and relational non-interference checking are
outside this first version.

Use existing policy extraction and the confidentiality lattice's `join` and `le`
operations. Do not introduce numeric ranks for security levels. Reuse the
teammate's value/label semantics rather than implementing another interpreter.

## The security contract

At a fixed destination with clearance `D`, an expression with label `L` under
security context `C` is permitted exactly when:

```text
join(L, C) <= D
```

Here `<=` is the declared lattice order. The security context describes which
confidential conditions control execution; it is distinct from the bytecode
program counter used for coverage.

For Hospital's lattice:

| Flow | Permitted |
| --- | --- |
| Public -> Oncology | yes |
| Oncology -> Oncology | yes |
| Oncology -> Public | no |
| Psych -> Oncology | no: incomparable compartments |
| join(Oncology, Psych) -> HospitalAdmin | yes |

Follow the current Python bytecode analysis for boundaries:

- Parameters have fixed clearances, from their annotations or configured input
  defaults. Reassignments are certified; the clearance stays fixed.
- Unannotated local temporaries infer their label. Assigning `e` sets their label
  to `join(label(e), context)`. A temporary is not permanently Public just because
  its initial value was the constant zero.
- Explicitly configured fixed local-slot clearances are certified on every write.
  Java `@Sec` does not currently annotate local variables.
- Sink arguments are certified against the sink's confidentiality clearances.
- Non-void returns use the annotated clearance, otherwise the configured default,
  which is lattice bottom in the current Python implementation.
- An uninitialized local remains uninitialized; a read is not silently treated
  as Public.

Entering a conditional raises the security context with the condition's label.
Restore the enclosing context at its immediate post-dominator, retaining control
dependencies already attached to values. Cover nested branches, early returns,
loops, skipped assignments, and values selected on the operand stack. A concrete
execution follows one path; it must not merge hypothetical alternative paths as
the static worklist does.

A violation at a fixed assignment, sink, or return stops that execution and records
the violating instruction as reached. Reset concrete state, shadow labels, and
control contexts before every new input. Subsequent violations hidden behind the
first failure require separate benchmark methods.

Call findings *observed confidentiality-policy violations*. The label policy is
conservative: `sameValueBothBranches` is rejected despite its constant output.
An observed label violation is not by itself a proof of semantic non-interference
failure, and unsuccessful search is not proof of security.

## Runner interface: the integration boundary

Agree on the following behaviour before either implementation depends on the
other. Names are proposed; adapt the teammate's API through one wrapper.

```python
run_once(method_id, inputs, *, step_limit, security_config) -> RunResult
```

`inputs` is an immutable `jpamb.case.Input` containing a tuple of typed values.
Mutations change values, never annotations or security labels.

`RunResult` contains:

| Field | Meaning |
| --- | --- |
| `status` | `completed`, `step-limit`, or `unsupported` |
| `outcome` | A concrete JPAMB outcome when known; otherwise absent |
| `coverage` | Reached `jvm.state.PC` locations, including the terminal instruction |
| `steps` | Number of executed target instructions |
| `violations` | Structured confidentiality diagnostics, separate from ordinary assertions |
| `detail` | Unsupported instruction or other explanatory information |

A violation diagnostic includes method, instruction offset, target, effective
label, allowed clearance, and current security context. Record explicit/implicit
provenance when the runner can establish it; otherwise leave the classification
unknown. A target assertion failure alone must not be classified as a leak.

The step limit is checked between instructions. Exhaustion preserves partial
coverage and produces no claim of nontermination. An unsupported instruction is
not a successful execution. Unexpected Python exceptions identify implementation
errors and must not be disguised as target-program confidentiality violations.
Concrete integer arithmetic must follow JVM semantics.

Prepare policy/bytecode/CFG information once per method. Keep execution in process
and make full tracing optional, so fuzzing does not pay for a process launch or
verbose log on every input. The ordinary interpreter trace interface can remain
available through a separate entry point.

## Input generation and exploration

1. Validate that the method has a confidentiality policy and supported parameter
   types. Reject unsupported signatures explicitly.
2. Prepare a bounded, deterministic seed list: all-zero/all-false input, then
   one-parameter variations using small positive/negative values and true.
   A zero-argument method has one possible input.
3. Extract integer constants only from executable method bytecode, never from
   `@Case` examples, expected outcomes, tags describing leaks, or benchmark traces.
   The mutation dictionary includes constants and their adjacent values, plus
   small integers and signed 32-bit boundaries.
4. Execute each seed within the campaign's total budget. Maintain a corpus and a
   cumulative set of reached instruction locations for this method only.
5. Choose a corpus entry uniformly and mutate it. Usually change one argument;
   occasionally change several to explore combinations. Boolean mutation flips
   its value. Integer mutation uses small deltas, dictionary replacements, bit
   flips, and occasional fresh random signed 32-bit values. Normalize arithmetic
   and bit-flip results to signed 32-bit values; do not emit Python integers
   outside the JVM input range, including when forming neighbours of constants.
6. Execute the candidate. If it adds instruction coverage, retain it as another
   mutation starting point and update the cumulative coverage set.
7. Save every newly observed violation fingerprint even if coverage did not grow.
   Stop-at-first-leak is per execution, not per campaign. Continue exploring other
   inputs and outcomes while the budget remains.
8. Stop at the configured execution count, aggregate instruction budget, or wall
   deadline. Count seed execution and repeated candidates against the budget.

Always keep a mutation starting point even for a method with no useful initial
coverage. Avoid duplicate corpus entries. Fresh random replacements and larger
deltas provide exploration when single-step mutations add no coverage; coverage
does not supply a gradient towards constants such as `1000000`.

Start with instruction coverage, matching the course description. Later,
transition coverage or `(location, confidentiality label/context)` feedback can
be compared as separate extensions. A set of reached instructions cannot be
used to reconstruct the order of transitions.

## Findings, replay, and prediction output

Use `(method, instruction, target, violation kind)` as the initial deduplication
key. Preserve effective/allowed labels in each finding. If distinct label pairs
matter to the research question, report them as an additional metric.

For each finding save the method identifier, encoded input, random seed, campaign
and instruction budgets, security configuration, diagnostic, and analysis version
or commit. Provide replay of that exact input with the same security settings.

Optionally minimize a finding by simplifying integer arguments towards zero and
dictionary values while preserving the same violation key. Give minimization a
separate budget and report its cost separately from discovery.

Expose a JPAMB-compatible analysis command and a detailed JSON report. Keep
diagnostics off the prediction protocol's stdout. Map observed confidentiality
failures to JPAMB's `assertion error` outcome while retaining their cause in the
report. Ordinary assertions remain distinguishable in that report.

Use categories such as `found`, `not-found`, and `unknown` to distinguish evidence
from incomplete search; do not equate `not-found` with impossible. A completed
safe execution establishes only that execution's `ok` outcome. Step exhaustion
must not produce a claim that `*` was observed.

When comparing against the static analysis, report warnings as dynamically
confirmed or not reproduced within budget. Do not turn an unconfirmed static
warning into a safe result. Compare only methods and policy settings shared by
both analyses.

## Examples and acceptance criteria

These inputs are validation/replay examples, not a seed list for the fuzzer.

| Existing example | Required behaviour |
| --- | --- |
| `Hospital.compartmentLeak` | Report a Psych -> Oncology violation regardless of numeric input |
| `Hospital.implicitCompartmentLeak` | 10 completes without a violation; 40 reaches an implicit violation |
| `Hospital.psychSessionCount` | 0 completes; 3 reaches the Public sink with a confidential result |
| `InfoFlow.overwrittenBeforeSink` | Replacing the secret-dependent temporary with Public zero clears its inferred label |
| `InfoFlow.pcRestoredAfterBranch` | A subsequent Public constant can flow to the Low sink |
| `InfoFlow.implicitReturn` | Both branch-dependent returns violate their Low clearance |
| `Clearance.nestedBranches` | Respect both branch conditions and their joined security context |
| `Clearance.secretBranchInLoop` | Preserve dependencies through iterations and keep a finite step budget |
| `Hospital.deadBranchLeak` | No observed violation; never claim the branch is proved unreachable |
| `Hospital.sameValueBothBranches` | Match the declared conservative label policy |

Add focused Python bytecode fixtures for parameter reassignment and fixed local
clearances, because current Java examples do not cover all these boundaries.
Exercise a secrecy-controlled zero-argument sink as well if that form is supported:
the occurrence of a call can be confidential even without argument values.

Meaningful fuzzer tests should demonstrate preservation of an intermediate input
that enables a later discovery, finding retention without new coverage, state
reset between executions, correct budget accounting, replay, and genuine
unsupported/step-limit results. Use controlled runner fixtures before the dynamic
engine is ready. Integration tests must then use the real concrete engine.

If expanding the Java suite, add interpretable families of nested guards,
integer-boundary guards, overwritten values, and bounded loops. Keep known-safe
counterparts. Include equalities that provide little coverage feedback. Do not
select examples solely because they favour coverage guidance.

## Evaluation

Compare ordinary random testing, constant/small-value random testing, and
coverage-guided mutation. Include an unguided mutation variant using the same
initial seeds and mutation operators to isolate the contribution of coverage.
Run every strategy through the same concrete runner and confidentiality policy.

Predeclare budgets and use multiple recorded random seeds. Charge initial seeds
to the budget. Report instruction executions and elapsed time as well as the
number of inputs, since loop-heavy inputs have different costs. Show:

- Distinct confidentiality violation sites found and discovery curves.
- Fraction of trials that discover each known violation within budget.
- Executions/steps/time to first violation, including unsuccessful trials.
- Instruction coverage reached; do not assume dead code is coverable.
- Static warning sites reproduced, alongside unsupported/incomplete cases.

Do not claim recall over all possible violations from fuzzing alone. Use the
known benchmark cases to define the evaluated targets, keeping their expected
results outside the input selector. Report when small-value or dictionary
testing already performs as well as coverage guidance.

## Files and delivery order

Proposed modules under `solutions/dynamic/src/`:

| Module | Responsibility |
| --- | --- |
| `fuzz_contract.py` | Small result/diagnostic types and runner interface |
| `fuzz_inputs.py` | Typed seeds, dictionary extraction, mutation |
| `coverage_fuzz.py` | Corpus, coverage feedback, campaigns, findings, replay |
| `dynamic.make_runner` | Concrete confidentiality adapter with shared policy initialization and tested integration |

Keep the public imports usable under the existing dynamic project's packaging.
Add dedicated fuzzing commands in `solutions/dynamic/pyproject.toml` without
replacing the teammate's existing interpreter/analysis commands. Put tests in
`solutions/dynamic/tests/`. Keep reports in a configurable output directory.

Delivery order:

1. Agree on the security and runner contracts. Implement the independent result
   types, typed inputs, corpus, campaign logic, and controlled-runner tests.
2. Completed: align `dynamic.make_runner` and the Python
   monitor with the confidentiality rules, share fixed-local/return-default
   settings, add real-runner/fuzzer regression tests, and validate the generated
   Java examples through JPAMB. Recursion remains outside the supported subset.
3. Completed: saved campaign reports, exact-input CLI replay, and opt-in export
   from existing dynamic/hybrid JPAMB commands. See the dynamic README for usage.
4. Run the baseline comparisons and document benefits and limits. Add optional
   minimization or richer feedback only after the comparison works.

The current checkout has generated `target/classes` and `target/decompiled`
artifacts from the Docker compile/decompile build. New checkouts still need that
build before compiled benchmark tests can run. Validation outputs are in the
ignored `reports/benchmark-validation-20261121/` directory; they are validation
artifacts, separate from the general-purpose `coverage-fuzz run` and
`coverage-fuzz replay` commands now available.

## References

- [Current Python confidentiality rules](flow-rules.md)
- [Static engine scope and configuration](security.md#python-static-confidentiality-analysis)
- [Course: Coverage-Guided Fuzzing](https://courses.compute.dtu.dk/02242/topics/dynamic-analysis.html#sec:4.3)
- [AFL technical explanation: coverage feedback and evolving the queue](https://aflplus.plus/docs/technical_details/)

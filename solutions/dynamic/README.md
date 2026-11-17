# Dynamic analysis and independent fuzzing core

The existing `dynamic-interpreter` and `dynamic-analysis` commands remain the
concrete interpreter's entry points. The new modules support coverage-guided
input exploration with an injected runner. They do not implement a concrete JVM
or decide whether a confidentiality flow is permitted.

## Current milestone

- `src/fuzz_contract.py`: execution results, confidentiality diagnostics, and a
  callable runner protocol.
- `src/fuzz_inputs.py`: immutable JPAMB integer/Boolean inputs, bounded seeds,
  executable constant dictionaries, and signed 32-bit mutations.
- `src/coverage_fuzz.py`: corpus selection, cumulative instruction coverage,
  execution/instruction/time budgets, and deduplicated findings.
- `tests/test_coverage_fuzz.py`: controlled-runner tests, including discovery
  through an intermediate input, partial executions, and reproducibility.

There is no real-runner adapter or new analysis command yet. Findings are Python
objects containing replayable inputs and diagnostics. Persistent JSON reports,
CLI replay, JPAMB prediction output, and benchmark comparisons are later steps.

## Using an eventual concrete runner

```python
from coverage_fuzz import FuzzConfig, fuzz
from fuzz_inputs import InputSpace

# `method` is an already decoded jvm.Method. `run_once` is your adapter.
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

The adapter must implement:

```python
def run_once(method_id, inputs, *, step_limit, security_config):
    # Start fresh concrete/shadow state, run at most step_limit instructions,
    # and return fuzz_contract.RunResult. This is the interpreter's responsibility.
    ...
```

The security settings object is passed through unchanged. It can be the existing
Python confidentiality `Config` or the teammate's own settings type. Capture
prepared bytecode, the method's confidentiality policy, and control-flow metadata
in the adapter so they need not be rebuilt on each execution. Policy availability,
supported effects, and fresh concrete/shadow state must be checked by that runner.

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
tests need no Java, Docker, compiled cases, or generated decompiler output. They
test exploration and the adapter contract; real confidentiality integration must
be verified once a concrete runner is connected.

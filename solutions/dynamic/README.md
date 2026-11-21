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

Findings are Python objects containing replayable inputs and diagnostics.
Persistent JSON reports, CLI replay, and controlled benchmark comparisons remain
later steps. The command prints prediction categories and separate counts for
completed, unsupported, and step-limit runs. The `timeout` prediction category
is a heuristic; no infinite execution is recorded as an observed outcome.

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
tests need no Java, Docker, compiled cases, or generated decompiler output. They
exercise the exploration core and real concrete interpreter using decoded
bytecode fixtures, including finding replay. Running the actual compiled Java
benchmark through JPAMB additionally requires the generated class/decompiler files.

# Project: unbounded confidentiality analysis

An unbounded static analysis of the JPAMB security cases. It reads JVM
bytecode and uses the class's `@Lattice` and `@Sec` annotations to check
integer and Boolean flows within one method. See the
[security model](../../docs/security.md).

```text
src/unbounded_analysis.py                      JPAMB command
src/unbounded_confidentiality/interpreter.py   bytecode analysis and leak checks
src/unbounded_confidentiality/integer.py       interval and sign abstraction
tests/                                         unit and benchmark case tests
```

## Commands

Run every command from the **repository root**. Use `--project` to select
the analyser's environment while JPAMB uses the current directory as its suite.

```powershell
# Build the Java cases once and after changes under cases/ (requires Docker).
uv run jpamb build --compile

$project = "solutions/project-unbounded-confidentiality"
$tool = "project-unbounded-confidentiality"
uv sync --project $project

# Metadata
uv run --project $project $tool info

# One case (diagnostics on stderr, predictions on stdout)
uv run --project $project $tool "jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V"

# Score the two loop cases through JPAMB.
uv run jpamb analyse -N 1 -f "BasicLeaks\.(skippedLoop|leakAfterBackEdge)" -- uv run --no-sync --project $project $tool

# Tests
uv run --project $project pytest "$project/tests"
```

## What it does

The interpreter follows the bytecode's control-flow graph. Each local and
stack value carries a range, a set of possible signs, and security labels.
The worklist revisits instructions when their input state changes.

| Bytecode | Rule |
| --- | --- |
| Comparison | Refine ranges and signs for each branch and discard impossible branches. |
| Control-flow join | Combine ranges, signs, and security labels from the incoming paths. |
| Loop back edge | Widen growing bounds to thresholds from the method. |
| Fixed-clearance assignment, sink, or annotated return | Check the value and active guard labels against the clearance. |

For `leakAfterBackEdge`, the analyser reports `assertion error;maybe`. The
first iteration skips the sink, and a later iteration can publish the secret.
The leak prediction is `no` when the analysis rules out a leak and
`unknown` when it cannot decide.

Unannotated returns keep their inferred label by default. Set
`JPAMB_CONF_RETURN_CLEARANCE` to require a clearance for those returns.
Set `JPAMB_CONF_MAX_STEPS` to limit the number of bytecode transfers.

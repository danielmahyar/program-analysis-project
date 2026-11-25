# Unbounded confidentiality analysis

This JPAMB solution checks whether a method can send confidential data to a
lower-clearance sink or return. It reads the method's compiled JVM bytecode
and the class's `@Lattice` and `@Sec` annotations. The current analysis covers
intraprocedural integer and boolean value flows.

## Commands

Run these commands from the repository root. The build uses Docker to compile
and decompile the Java cases. Rebuild after changing files under `cases/`.

```powershell
uv run jpamb build --compile
uv sync --project solutions/project-unbounded-confidentiality

$project = "solutions/project-unbounded-confidentiality"
$tool = "project-unbounded-confidentiality"
$method = "jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V"

uv run --project $project $tool info
uv run --project $project $tool $method
uv run --project $project pytest solutions/project-unbounded-confidentiality/tests
```

To score the two loop methods through JPAMB on Windows, pass the installed
command's absolute path to the benchmark runner.

```powershell
$analyser = (Resolve-Path "$project/.venv/Scripts/$tool.exe").Path
uv run jpamb analyse -N 1 -f 'BasicLeaks\.(skippedLoop|leakAfterBackEdge)' $analyser
```

The method command writes JPAMB predictions to stdout and diagnostics with
instruction indices to stderr.

## How it finds a leak

The [project command](src/unbounded_analysis.py) runs its own
[abstract interpreter](src/unbounded_confidentiality/interpreter.py).
JPAMB supplies the bytecode and security policy. The `static-analysis` command
in `solutions/static` uses the [original interpreter](../../src/jpamb/confidentiality.py).

The analyser checks an integer return against the method's `@Sec` clearance.
For an unannotated return it records the value's label. Set
`JPAMB_CONF_RETURN_CLEARANCE` to a level in the class's lattice to enforce a
clearance on those returns as well.

The interpreter builds a control-flow graph and keeps an abstract state at
each reachable instruction. Each local and operand-stack value carries
confidentiality labels and [one abstract integer](src/unbounded_confidentiality/integer.py).
Its possible values must satisfy both a signed JVM integer interval and a
set of signs (negative, zero, positive). Branches and arithmetic operate on
the portions of the interval allowed by those signs. Assignments under a
secret guard inherit its label, even if arithmetic determines the numeric
result exactly. A guarded `swap` labels both moved stack values, and a guarded
`dup` labels the new copy. Values left in place keep their labels when the
paths rejoin. Post-dominators identify where the guard stops controlling
execution.

For example, on the path where a public integer `x != 0`, the sign set drops
zero even when the interval still spans negative and positive values. A
subsequent `x >= 0` then tightens the lower bound to **1**. The analyser can
skip `if (x < 1) publish(secret)` on that path. Changing the guard to
`x < 2` keeps the leak reachable at `x = 1`.

At ordinary merges, the analyser joins labels, takes the interval hull and
unions the signs. Merging `-5` and `5` gives bounds `[-5, 5]` and keeps zero
excluded. An empty comparison result drops the corresponding CFG edge.
On a depth-first search back edge, it widens growing interval endpoints to
the nearest enclosing threshold, or to infinity when no threshold remains.
Thresholds come from the method's integer constants, increment amounts and
zero. For example, widening `[0, 0]` with `[0, 1]` using thresholds
`{0, 10}` gives `[0, 10]`. Unbounded endpoints still denote JVM int values.
The arithmetic rules account for 32-bit wraparound.

The worklist revisits an instruction only on first arrival or when its stored
state grows. Every reachable cycle contains a DFS back edge. Widening on each
such edge can expand a stored bound only finitely often. Sign sets grow by
union and can gain at most three signs. Reducing widened bounds to fit the
signs adds only the boundaries `-1`, `0` and `1`. Confidentiality labels
range over a finite lattice. The remaining edges form a DAG, so their ordinary joins also
stabilise. See the [DTU course notes on widening](https://courses.compute.dtu.dk/02242/topics/unbounded-static-analysis.html).

## Branch and loop cases

| Method in `BasicLeaks` | Expected confidentiality verdict | Reason |
| --- | --- | --- |
| `implicitIf` | Possible leak | A secret determines the value passed to a public sink. |
| `implicitIfSafe` | Safe | The branch condition and the published value are public. |
| `skippedLoop` | Safe | `mode` is exactly zero at the guard, so the body containing `publish(secret)` is unreachable. |
| `leakAfterBackEdge` | Possible leak | Initially `phase` is zero. The back edge brings `phase = 1` to the header and makes the branch to `publish(secret)` feasible. |

The last verdict covers all inputs. A concrete call with `count = 1` returns
safely, while `count = 2` reaches the sink. Unsupported effects such as
general method calls and array operations produce an unknown verdict unless
the analyser has already found a possible leak. See the
[security model](../../docs/security.md) for the supported JVM
operations and boundary rules.

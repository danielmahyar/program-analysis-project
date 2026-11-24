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

The interpreter builds a control-flow graph and keeps an abstract state at
each reachable instruction. Each local and stack value carries confidentiality
labels and a signed JVM integer interval. A conditional follows each edge whose
comparison admits a value in the incoming ranges. On each feasible edge it
narrows the ranges of the compared locals. Assignments under a secret guard
inherit its label, even if arithmetic determines the numeric result exactly.
Post-dominators identify where the guard stops controlling execution.

At ordinary merges, the analyser joins labels and takes the interval hull.
On a depth-first search back edge, it widens growing interval endpoints to
the nearest enclosing threshold, or to infinity when no threshold remains.
Thresholds come from the method's integer constants, increment amounts and
zero. For example, widening `[0, 0]` with `[0, 1]` using thresholds
`{0, 10}` gives `[0, 10]`. Unbounded endpoints still denote JVM int values.
The arithmetic rules account for 32-bit wraparound.

The worklist revisits an instruction only on first arrival or when its stored
state grows. Every reachable cycle contains a DFS back edge. Widening on each
such edge can expand a stored bound only finitely often, and labels range over
a finite lattice. The remaining edges form a DAG, so their ordinary joins also
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

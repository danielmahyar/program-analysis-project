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

The project interpreter builds a CFG from the method's bytecode. At each conditional, it
explores both the taken edge and the fallthrough edge. A return leads to the
virtual exit. Starting at instruction zero, the interpreter keeps an abstract
state for each reachable instruction. A state records labels for the operand
stack, local variables, and active branch conditions. A store inside a secret-controlled branch
inherits that condition's label. Post-dominators identify where a branch
stops controlling execution.

When paths meet, the interpreter joins their states. If that changes a
successor's state, a worklist schedules the successor again. A loop back edge
can therefore expose a flow that first becomes possible on a later iteration.
By default, analysis finishes when the worklist is empty. Each instruction
has finitely many local variables, operand stack slots and controlling branches.
Their labels can rise only finitely many times in the configured lattice.

## Branch and loop cases

| Method in `BasicLeaks` | Expected confidentiality verdict | Reason |
| --- | --- | --- |
| `implicitIf` | Possible leak | A secret determines the value passed to a public sink. |
| `implicitIfSafe` | Safe | The branch condition and the published value are public. |
| `skippedLoop` | Possible leak (false positive) | The analyser visits the edge to `publish(secret)`. At runtime, `mode` starts at zero and the loop body never runs. |
| `leakAfterBackEdge` | Possible leak | The analyser follows the branch to the sink on its first visit. In a concrete run, the sink can first execute on the second iteration. |

The last verdict covers all inputs. A concrete call with `count = 1` returns
safely, while `count = 2` reaches the sink. Unsupported effects such as
general method calls and array operations produce an unknown verdict unless
the analyser has already found a possible leak. See the
[security model](../../docs/security.md) for the supported JVM
operations and boundary rules.

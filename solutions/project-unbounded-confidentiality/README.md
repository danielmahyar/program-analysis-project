# Unbounded confidentiality analysis

This analyser reads the JVM bytecode for one method and checks whether a
secret can reach a public output. It uses the class's `@Lattice` and `@Sec`
annotations to decide which flows are allowed. It supports integer and
boolean values.

## How it finds a leak

In `BasicLeaks.leakAfterBackEdge`, `phase` starts at 0. The first time
through the loop, the method skips `publish(secret)` and sets `phase` to 1.
If the public counter allows a second iteration, the method publishes the
secret. The analyser reports a possible leak for the method.

The [interpreter](src/unbounded_confidentiality/interpreter.py) follows a
control-flow graph of the bytecode. At each instruction it tracks the
possible numbers and security labels in the local variables and on the
stack. When paths meet, it combines what it learned on each path. In the
example above, it revisits the loop and finds that `phase == 1` is possible.
A secret can also leak through a decision, for example when a secret flag
decides whether to publish a public value.

Each number has a range and a set of possible signs. If `x` can be either
`-5` or `5`, its range is `[-5, 5]`, but its signs exclude zero. The
analyser can skip a branch that requires `x == 0`.

## Why widening stops

A loop counter can make a range grow by one on each visit. Widening lets
the analyser jump to a threshold taken from the method. For example, with
thresholds 0, 1 and 10, when `[0, 1]` needs to include 2, it grows to
`[0, 10]`. If it later needs to include 11, the upper end becomes unbounded.

Each jump goes outwards, so the range still covers the old and new values.
There are only finitely many thresholds to cross, and only three signs to
add. Eventually another trip around the loop adds nothing. The analyser
can then stop revisiting it. [DTU notes on widening](https://courses.compute.dtu.dk/02242/topics/unbounded-static-analysis.html)

## Run it

From the repository root in PowerShell, build the Java cases with Docker.
Repeat the build after editing a case.

```powershell
uv run jpamb build --compile
$project = "solutions/project-unbounded-confidentiality"
$tool = "project-unbounded-confidentiality"
uv sync --project $project
uv run --project $project $tool info
uv run --project $project $tool "jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V"
uv run --project $project pytest "$project/tests"
```

For this example, look for `assertion error;maybe` in the output. JPAMB uses
the `assertion error` query for leaks. A prediction of `no` means the
analyser found the method safe under its model. `unknown` means it could
not decide, for example because it reached an unsupported call.

This command scores both loop examples with JPAMB on Windows.

```powershell
$analyser = (Resolve-Path "$project/.venv/Scripts/$tool.exe").Path
uv run jpamb analyse -N 1 -f 'BasicLeaks\.(skippedLoop|leakAfterBackEdge)' $analyser
```

An annotated return must meet its declared clearance. An unannotated return
keeps its inferred label unless you set `JPAMB_CONF_RETURN_CLEARANCE`.
See the [security model](../../docs/security.md) for the flow rules.

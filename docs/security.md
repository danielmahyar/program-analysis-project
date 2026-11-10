# Security Cases

Four case classes describe information-flow policies with annotations:
`Clearance`, `Compartments`, `Hospital` and `InfoFlow` in
[cases/jpamb/cases](../cases/jpamb/cases). JPAMB serves their `@Case`s like any
other case, and every analysis (syntactic, dynamic, abstract) reads their
annotations through the `jpamb` Python package. No other tools are involved.

- `@Lattice` (on the class) declares one dimension of the lattice: `conf`
  (confidentiality) or `integ` (integrity), its levels, its order and the
  default level. See [Lattice.java](../cases/jpamb/utils/Lattice.java).
- `@Sec` gives a label, one level per dimension (a missing dimension gets its
  default). On a parameter of a `@Case` method it is the label of that input
  (a source); on a parameter of any other method it is the clearance of that
  argument (a sink); on a method it is the clearance of its return value. See
  [Sec.java](../cases/jpamb/utils/Sec.java).

A case ends in `assertion error` when a value reaches a sink whose clearance it
does not flow to, counting implicit flows through branches (the exact rules are
in `Sec.java`).

## Building

You need [uv](https://docs.astral.sh/uv/) and Docker (running). From the
repository root:

```bash
uv sync                  # creates .venv (once)
uv run jpamb build       # compile, list cases, decompile, benchmark, document, test
uv run jpamb checkhealth
```

Run `uv run jpamb build` again after changing something in `cases/`. Running an
analysis needs neither Docker nor Java. The steps, all inside the JPAMB docker
image:

| Step | Writes |
| --- | --- |
| Compile `cases/` (with the ASM jars in `lib/`) | `target/classes/` |
| List the cases | `target/stats/cases.txt` |
| Decompile every class, annotations included | `target/decompiled/` |
| Trace every case on the JVM (`jpamb.Runtime --trace 100`) | `target/stats/benchmark.sexp` |
| Count the opcodes of the cases | `OPCODES.md` |
| Run every case and compare with its `@Case` | (log) |

## Reading the annotations in an analysis

`suite.security_policy(classname)` returns the policy of a class, or `None` for
a class without `@Lattice` (an ordinary case). It reads the decompiled class,
the same file `suite.findmethod` uses.

```python
import jpamb

methodid = jpamb.getmethodid("my-analysis", "1.0", "group", ["static"], for_science=False)
suite, eff = jpamb.setup()

policy = suite.security_policy(methodid.classname, eff=eff)
if policy is not None:
    lattice = policy.product_lattice
    method = policy.method(methodid)

    # Labels of the inputs; param_slots says which local variable holds each one
    method.param_labels          # e.g. ((Oncology, Trusted), (Psych, Untrusted))
    method.initial_locals(lattice, max_locals=suite.method_max_locals(methodid, eff=eff))
    method.return_clearance      # a label, or None

    # At an invoke instruction: is the called method a sink, and what may flow into it?
    sink = policy.sink(called_methodid)  # None unless it is a sink of this class
    if sink is not None and not lattice.le(argument_label, sink.param_labels[0]):
        ...                              # leak: "assertion error"
```

| Python | Meaning |
| --- | --- |
| `policy.product_lattice` | `le`, `join`, `meet`, `bot`, `top`, `default_label`, `make_label(conf=..., integ=...)` |
| `policy.product_lattice.lattices[dim]` | one dimension: `levels`, `order_edges`, `le`, `join`, `meet`, `bot`, `top` |
| `policy.method(methodid)` | a `MethodSecurityPolicy`; takes the `AbsMethodID` JPAMB passes, a `MethodID`, or `"name:(II)V"` |
| `policy.sink(methodid)` | the sink's `MethodSecurityPolicy`, or `None` if the method is not a sink |
| `policy.sinks`, `policy.case_methods` | all sinks / all `@Case` methods, by `"name:(desc)ret"` |
| `method.param_labels`, `method.param_slots` | one label and one local variable slot per parameter |
| `method.return_clearance` | clearance of the return value (`@Sec` on the method), or `None` |
| `method.tags`, `method.cases` | the `@Tag`s, and the `@Case`s as `(input, result)` pairs |

To print a policy:
`uv run python solutions/syntactic/src/security_parser.py jpamb.cases.Hospital`
(add `--json` for JSON).

## Where a leak happens (interpreters)

`jpamb interpret` checks that an interpreter reaches every instruction in the
benchmark's coverage. For the security cases that coverage stops where the
leak is detected:

- a sink argument that may not flow: at the `invoke` of the sink (the sink's
  code is not run);
- a return value that may not flow to `return_clearance`: at the `return`.

So an interpreter should report `assertion error` at that instruction, as it
does at `new java/lang/AssertionError` for an ordinary `assert`.

## How the expected results are produced

`jpamb.Runtime` loads every case class through
[BytecodeInstrumenter](../cases/jpamb/utils/BytecodeInstrumenter.java). A class
with `@Lattice` gets the [SecurityMonitor](../cases/jpamb/utils/SecurityMonitor.java),
which tracks the labels at run time and throws `AssertionError` on a leak; other
classes run unchanged. `Runtime --trace` additionally records which instructions
each case executes in its first 100 steps; that is the coverage in
`benchmark.sexp`. For the original cases it is identical to the coverage
recorded before by the reference interpreter.

## Adding a security case

1. Write the class in `cases/jpamb/cases/` with its `@Lattice`s, `@Sec`s and `@Case`s.
2. Add it to `caseclasses` in [Runtime.java](../cases/jpamb/Runtime.java).
3. Run `uv run jpamb build`; it reports any `@Case` the monitor disagrees with.

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

The compiled classes and the decompiled bytecode (`target/**/*.class` and
`target/**/*.json`) are not in git, and every analysis reads the decompiled
bytecode. So run `uv run jpamb build` after cloning, and again after pulling or
making a change to `cases/`. Running an analysis afterwards needs neither
Docker nor Java. The case list, the benchmark and `OPCODES.md` are committed;
commit them again when the build changes them.

The steps, all inside the JPAMB docker image:

| Step | Writes | In git |
| --- | --- | --- |
| Compile `cases/` (with the ASM jars in `lib/`) | `target/classes/` | no |
| List the cases | `target/stats/cases.txt` | yes |
| Decompile every class, annotations included | `target/decompiled/` | no |
| Trace every case on the JVM (`jpamb.Runtime --trace 100`) | `target/stats/benchmark.sexp` | yes |
| Count the opcodes of the cases | `OPCODES.md` | yes |
| Run every case and compare with its `@Case` | (log) | |

## Reading the annotations in an analysis

`suite.security_policy(classname)` returns the policy of a class, or `None` for
a class without `@Lattice` (an ordinary case). It reads the decompiled class,
the same file `suite.findmethod` uses.

```python
import jpamb

methodid = jpamb.getmethodid(
    "my-analysis", "1.0", "group", ["static"], for_science=False
)
suite, eff = jpamb.setup()

policy = suite.security_policy(methodid.classname, eff=eff)
if policy is not None:
    lattice = policy.product_lattice
    method = policy.method(methodid)

    # Labels of the inputs; param_slots says which local variable holds each one
    method.param_labels  # e.g. ((Oncology, Trusted), (Psych, Untrusted))
    method.initial_locals(
        lattice, max_locals=suite.method_max_locals(methodid, eff=eff)
    )
    method.return_clearance  # a label, or None

    # At an invoke instruction: is the called method a sink, and what may flow into it?
    sink = policy.sink(called_methodid)  # None unless it is a sink of this class
    if sink is not None and not lattice.le(argument_label, sink.param_labels[0]):
        ...  # leak: "assertion error"
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

## Python static confidentiality analysis

`static-analysis` in `solutions/static` now uses `jpamb.confidentiality` for
classes declaring security lattices. Classes without a security policy keep the
existing numeric analysis. The new analysis uses only the `conf` dimension;
existing integrity and product-lattice policies can still be parsed, but their
integrity classifications are not checked by this analysis. The Java monitor is
unchanged and may therefore report different outcomes.

The supported model is intraprocedural, termination-insensitive value-flow
confidentiality over JVM `int`/`boolean` values. Integer arithmetic, comparisons,
bitwise operations, shifts, negation, integer narrowing conversions, loads,
stores, `iinc`, branches, `goto`, returns, and category-1 `dup`/`dup2`, `pop`/`pop2`
and `swap` are supported. It does not compute numeric values or prune branches:
both successors are explored, including branches that a numeric domain might
prove unreachable. Selected constants in ternaries and short-circuit expressions
retain their control dependencies.

Each value has a data label and a control-dependency label; its confidentiality
is their join. Assignments strongly update inferred local values after joining
the current security context. CFG merges join both paths, including values left
unchanged by a skipped assignment. Post-dominators restore enclosing control
contexts while dependencies already attached to values remain. Live operand-stack
values retain guard dependencies at control-region merges, including choices made
using only stack reordering. Loop headers
merge entry and back-edge states until the finite label domain converges. In
regions without a path to method exit, contexts are retained conservatively.

Uninitialized locals are `None`, not Public; unreachable instructions have no
incoming state. Loading a local not initialized on every incoming path, stack
underflow, incompatible stack shapes, and malformed CFG edges give an unsupported
result. Security initialization uses `initial_locals(..., uninitialized=True)`;
the legacy bottom-filled default is preserved for existing policy consumers.

Boundary policies are separate from inferred dependencies:

- Unannotated parameters retain the class's configured input default.
- Explicit `@Sec` parameter declarations also constrain subsequent writes to
  those parameter slots. A failed assignment is diagnosed and its actual value
  dependency is retained; the declaration is never raised to accommodate it.
- Unannotated local temporaries infer their labels. Callers can supply fixed
  local-slot clearances through `Config.local_clearances`; these apply throughout
  the method, including reused slots. An additional clearance cannot relax an
  annotated parameter constraint.
- A return uses its explicit method clearance. Otherwise its configurable
  default is lattice bottom, meaning Public (or Low/Unclassified in lattices
  using different names). Configuring this default never overrides an annotation.
- An annotated static void sink with a verified empty body (`return` only) is
  treated as a declared output boundary. Both its arguments and whether the
  call occurs are checked. Arbitrary annotated methods are not assumed pure.

The current Java `@Sec` annotation cannot annotate local variables. Fixed local
constraints are therefore provided through the Python API. Encountering a local
or type-use `@Sec` in supplied bytecode metadata is explicitly unsupported rather
than ignored; decoding scoped local annotations is not implemented.

```python
import jpamb
from jpamb.confidentiality import Config, analyze

suite, eff = jpamb.setup()
policy = suite.security_policy(methodid.classname, eff=eff)
bc = jpamb.Bytecode(suite, eff, {})
result = analyze(
    bc, methodid, policy,
    Config(return_clearance="Public", local_clearances={2: "Public"}),
)
print(result.status, result.return_label)
for diagnostic in result.diagnostics:
    print(diagnostic.offset, diagnostic.kind, diagnostic.message)
```

`result.status` is `safe`, `violation`, `unsupported`, or `incomplete`. Only
`safe` establishes absence of a potential flow within the supported model.
Diagnostics distinguish explicit from implicit dependencies where possible.
Unsupported and incomplete results retain any flow diagnostics already found.
The default worklist has no iteration cap or widening. `Config.max_steps` can
bound instruction transfers; exhausting that limit while work remains produces
`incomplete`, never `safe`.

The existing static entry points read these optional environment variables:

| Variable | Meaning | Default |
| --- | --- | --- |
| `JPAMB_CONF_RETURN_CLEARANCE` | Clearance for returns without `@Sec` | Confidentiality bottom |
| `JPAMB_CONF_MAX_STEPS` | Maximum instruction transfers, a non-negative integer | Until convergence |

The JPAMB prediction protocol reports potential confidentiality violations under
`assertion error`. It reports `unknown` for unsupported/incomplete analysis and
for numeric runtime outcomes this domain cannot answer. The stderr report gives
the security status and diagnostics. Abstract interpretation traces use the same
security worklist; concrete input values do not prune its paths, and a trace
budget can leave the result incomplete.

Heap/field/array effects, references and category-2 values, general calls,
exceptions and handlers, native effects, synchronization, and switch instructions
are unsupported. Decoding failures also produce an explicit unknown result. No
support for timing, termination, or exception-channel non-interference is claimed;
division and remainder only propagate value labels. Identical branches and other
value-independent expressions may still be conservatively flagged.

Focused tests need no generated class files:

```bash
python -m pytest tests/test_confidentiality.py tests/test_static_confidentiality_cli.py
```

Stack transfers follow the category-1 forms in the
[JVM instruction specification](https://docs.oracle.com/javase/specs/jvms/se25/html/jvms-6.html).
The decoder accepts the decompiler's `bitopr`, `pop`, and `swap` forms from the
[jvm2json codec](https://github.com/kalhauge/jvm2json/blob/main/CODEC.txt).

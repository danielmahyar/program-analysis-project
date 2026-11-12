# Flow Rules (Confidentiality)

The rules the analyses use to compute confidentiality labels. They are
implemented in [`jpamb.flow_rules`](../src/jpamb/flow_rules.py), so every
analysis (syntactic, abstract, dynamic) computes labels the same way. The
integrity lattice is ignored completely.

## The powerset compartment lattice

Every security label is a **set of compartments** S ⊆ C, where C is e.g.
{Oncology, Psych} in `Hospital`.

| | Meaning | Python |
| --- | --- | --- |
| Public | ∅, requires zero compartment authorities | `rules.PUBLIC` |
| A single compartment | a singleton, e.g. {Oncology} or {Psych} | `lattice.label("Oncology")` |
| Join (⊔) | set union: combining two labels requires the authority of **all** compartments in either operand | `rules.binary(a, b)` |
| Flow (⊑) | subset: data with L1 may flow into a sink with L2 iff L1 ⊆ L2 | `rules.flows(l1, l2)` |
| Top | C, every compartment | `lattice.top` |

The case classes declare their levels with `@Lattice`; each level is the set
of compartments below it (see [the mapping](#from-the-declared-levels-to-sets)).

## Integer constants

A literal contains no compartment information: L(42) = ∅ (`rules.constant()`).

```java
int x = 42;            // pc = ∅:           L(x) = ∅ ∪ ∅ = ∅
if (secret > 5000) {   // L(secret) = {Oncology}
    int x = 42;        // pc = {Oncology}:  L(x) = ∅ ∪ {Oncology} = {Oncology}
}
```

## Integer arithmetic

The label of the result is the union of the operands' labels
(`rules.binary(la, lb)`):

L(a + b) = L(a − b) = L(a * b) = L(a / b) = L(a % b) = L(a) ∪ L(b)

Integer operations are assumed to evaluate without runtime exceptions; covert
channels through abnormal termination, such as division by zero, are out of
scope.

- `secret + b` with L(secret) = {Oncology}, L(b) = ∅: {Oncology}.
- `a + b` with L(a) = {Oncology}, L(b) = {Psych}: {Oncology, Psych}. The result
  does not jump to `HospitalAdmin`; any recipient of `a + b` must hold the
  authority of **both** Oncology and Psych.
- `int x = secret + 5;` gives {Oncology}; `int x = 5 * 10;` gives ∅.

## Boolean expressions and comparisons

Every comparison `==`, `!=`, `<`, `<=`, `>`, `>=` gives a boolean labelled

**L(x op y) = L(x) ∪ L(y)** (`rules.binary`)

so `x > 10` has L(x) ∪ ∅ = L(x). When a boolean is used as a branch condition,
it raises the pc:

```java
boolean isLarge = secret > 5000;   // {Oncology} ∪ ∅ = {Oncology}
if (isLarge) {                     // pc' = pc ∪ L(isLarge)
    ...
}
```

## Boolean operators

L(a && b) = L(a || b) = L(a ^ b) = L(a) ∪ L(b) (`rules.binary`), and
L(!a) = L(a) (`rules.unary`; also unary `-a`).

`if (onco > 5000 && psych < 1000)` gives {Oncology} ∪ {Psych} =
{Oncology, Psych}.

This assumes the operands are pure. If an assignment or call appears inside a
short-circuit operator, it has to be desugared into an explicit `if`/`else`, so
that the right operand is evaluated under the raised pc.

## Assignment and security certification

How an assignment is handled depends on whether the target's label is inferred
or statically fixed.

### Label inference for local variables

A local variable without a fixed label gets a **strong update**
(`rules.assign(le, pc)`):

**L_out(x) := L(e) ∪ pc**

For `int result = secret + 10;` with L(secret) = {Oncology}:

- outside a sensitive branch (pc = ∅): L_out(result) = {Oncology};
- inside a Psych branch (pc = {Psych}): L_out(result) = {Oncology, Psych}.

Compound assignments and increments read the target first: `x += e` and `x++`
are `x = x + e` and `x = x + 1`.

### Security certification (sinks)

A target with a **statically fixed label** gets no new label. The assignment is
certified instead (`rules.certify(le, pc, fixed)`):

**L(e) ∪ pc ⊆ L_fixed(s)**

If this does not hold, a security violation is reported. Afterwards the target
still has L_fixed. The targets with a fixed label are:

- a method parameter, when it is reassigned (see below);
- a parameter of a sink, i.e. a call `sink(e)` (`lattice.clearance(sec)`);
- the return value of a method with `@Sec`: `return e`. A `return` in a method
  without `@Sec` is not a sink.

`@Sec` can only annotate parameters and methods
([Sec.java](../cases/jpamb/utils/Sec.java)), so there are no fields with fixed
labels in the cases.

## Parameters, local variables, control flow and the worklist

- **Parameters** have a fixed label, the set of their `@Sec(conf = ...)`: e.g.
  `@Sec(conf = "Oncology") int onco` gives L_fixed(onco) = {Oncology}.
  Unannotated parameters are ∅ (`lattice.param_labels(method)`). Reassigning a
  parameter is a security certification (above).
- **Local variables** start at ∅ (Public) and infer their label with
  L_out(x) := L(e) ∪ pc.
- **Control flow (implicit flows).** Entering an `if` or a `while` guarded by
  condition c gives (`rules.enter_branch(pc, lc)`)

  **pc_body = pc_outer ∪ L(c)**

  pc_body is the minimum compartment requirement for every variable assigned
  in the block.
- **Worklist (fixed-point merging).** Where paths meet in the CFG (after an
  `if`/`else`, at a `while` header), each variable gets the union over the
  predecessors p ∈ pred(n) (`rules.merge(env1, env2, ...)`):

  **L_in(x) = ⋃ L_out,p(x)**

  C is finite, so ℘(C) has finite height, and every transfer function is
  monotone (it only takes unions). The labels can only grow, so the worklist
  reaches the least fixed point and terminates.

## From the declared levels to sets

The case classes declare their `conf` levels as a lattice with `@Lattice`.
`SetLattice.from_policy(policy)` turns each level into the set of
compartments below it. The compartments are the levels that are not the join
of the levels below them:

| Class | Levels as sets |
| --- | --- |
| `Hospital` | Public = ∅, Oncology = {Oncology}, Psych = {Psych}, HospitalAdmin = {Oncology, Psych} |
| `Compartments` | None = ∅, Alpha = {Alpha}, ..., AlphaBravo = {Alpha, Bravo}, ..., All = {Alpha, Bravo, Charlie} |
| `Clearance` (a chain) | Unclassified = ∅, Restricted = {Restricted}, Confidential = {Restricted, Confidential}, ... |
| `InfoFlow` | Low = ∅, High = {High} |

With these sets, `flows` gives the same answer as the declared order, also for
unions: L(a) ∪ L(b) ⊆ L(c) exactly when a ⊔ b ≤ c.
[tests/test_flow_rules.py](../tests/test_flow_rules.py) checks this for all
four classes.

## Differences with the expected results

The expected outcomes of the cases come from the run-time monitor
([SecurityMonitor](../cases/jpamb/utils/SecurityMonitor.java)), which differs
from these rules in two places:

- The monitor lowers pc at the branch's immediate post-dominator, not at the
  end of the block. After `if (secret > 0) { return 1; }`, the `return 0` still
  runs under pc = {High}, so `InfoFlow.implicitReturn` with input -5 is an
  `assertion error`. With these rules only `return 1` is flagged; the
  method-level answer is the same. The bytecode analysis
  ([confidentiality.py](../src/jpamb/confidentiality.py)) uses the
  post-dominator, the bytecode form of "the end of the block".
- The monitor does not certify writes to parameters; no case reassigns one.

The rules have no numeric reasoning, so `deadBranchLeak`, whose leaking branch
never runs, is flagged by the static analyses although the expected result is
`ok`.

## Usage

```python
import jpamb
from jpamb import flow_rules as rules

methodid = jpamb.getmethodid(...)
suite, eff = jpamb.setup()
policy = suite.security_policy(methodid.classname, eff=eff)
lattice = rules.SetLattice.from_policy(policy)

# Parameters have fixed labels (names from the AST, or slots: policy.method(...).param_slots)
fixed = dict(zip(param_names, lattice.param_labels(policy.method(methodid))))
env = dict(fixed)
pc = rules.PUBLIC

# int x = a + 5;   (a local: inferred)
env["x"] = rules.assign(rules.binary(env["a"], rules.constant()), pc)

# a = x;           (a parameter: certified, keeps its fixed label)
if not rules.certify(env["x"], pc, fixed["a"]):
    print("leak: a = x")

# if (x > 0) { ... }
body_pc = rules.enter_branch(pc, rules.binary(env["x"], rules.constant()))

# after the if/else
env = rules.merge(then_env, else_env)

# sink(x)
sink = policy.get_method("sink")
if not rules.certify(env["x"], pc, lattice.clearance(sink.param_labels[0])):
    print("leak:", lattice.show(rules.assign(env["x"], pc)))
```

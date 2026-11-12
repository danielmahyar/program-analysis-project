"""
jpamb.flow_rules

The confidentiality flow rules: how labels propagate through constants,
operators, assignments, branches and join points (integrity is ignored). A
label is a set of compartments S ⊆ C; see docs/flow-rules.md for the rules.

    Public / constants   ∅
    join  (⊔)            set union         a | b
    flow  (⊑)            subset inclusion  a <= b
    top                  C, every compartment

Every analysis (syntactic, abstract, dynamic) can use it on top of the policy
JPAMB reads from the annotations:

    from jpamb import flow_rules as rules

    policy = suite.security_policy(methodid.classname, eff=eff)
    lattice = rules.SetLattice.from_policy(policy)
    env = dict(zip(names, lattice.param_labels(policy.method(methodid))))

    env["x"] = rules.assign(rules.binary(env["a"], rules.constant()), pc)   # x = a + 5
    body_pc = rules.enter_branch(pc, env["x"])                           # if (x > 0)
    after = rules.merge(then_env, else_env)                              # join point
    rules.certify(env["x"], pc, lattice.clearance(sink.param_labels[0])) # leak if False

Local variables infer their label (`assign`, a strong update); targets with a
fixed label (parameters, sink parameters, annotated returns) are certified
instead (`certify`) and keep their fixed label.

The case classes declare their `conf` levels as a lattice (e.g. Hospital:
Public <= Oncology, Psych <= HospitalAdmin). Each level becomes the set of
compartments below it, where the compartments are the join-irreducible levels
(those that are not the join of the levels below them):

    Public -> ∅,  Oncology -> {Oncology},  HospitalAdmin -> {Oncology, Psych}

For a chain (Clearance) a level is the set of the non-bottom levels up to it,
e.g. Confidential -> {Restricted, Confidential}. With this mapping `flows`
gives the same answer as the declared order, also for unions of labels.
"""

from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass
from typing import Any

from jpamb.security import (
    ClassSecurityPolicy,
    MethodSecurityPolicy,
    SecurityLabel,
    SecurityLattice,
)

Label = frozenset[str]
"""A set of compartments."""

PUBLIC: Label = frozenset()
"""∅: needs no compartment authority (bottom)."""


# ---------------------------------------------------------------------------
# The rules
# ---------------------------------------------------------------------------


def constant() -> Label:
    """A literal (`42`, `true`): L(c) = ∅."""
    return PUBLIC


def binary(left: Label, right: Label) -> Label:
    """Any binary operator: L(a op b) = L(a) ∪ L(b).

    Arithmetic `+ - * / %`, comparisons `== != < <= > >=`, and boolean
    `&& || ^`.
    """
    return left | right


def unary(operand: Label) -> Label:
    """A unary operator such as `!a`: L(!a) = L(a)."""
    return operand


def assign(expression: Label, pc: Label) -> Label:
    """`x = e`: L(x) := L(e) ∪ pc."""
    return expression | pc


def enter_branch(pc: Label, condition: Label) -> Label:
    """Entering `if (c)` or `while (c)`: pc_body = pc_outer ∪ L(c)."""
    return pc | condition


def merge(*envs: Mapping[Any, Label]) -> dict[Any, Label]:
    """A join point in the CFG: L_in(x) = ⋃ L_out,p(x) over the predecessors p.

    A variable missing from an environment counts as ∅ (not assigned yet).
    """
    merged: dict[Any, Label] = {}
    for env in envs:
        for var, label in env.items():
            merged[var] = merged.get(var, PUBLIC) | label
    return merged


def flows(source: Label, clearance: Label) -> bool:
    """May data with `source` reach a sink with `clearance`? L1 ⊑ L2 iff L1 ⊆ L2."""
    return source <= clearance


def certify(expression: Label, pc: Label, fixed: Label) -> bool:
    """Assigning `e` to a target with a statically fixed label (a parameter, a
    sink's parameter, the return value of an `@Sec` method) infers nothing; it
    is secure iff L(e) ∪ pc ⊆ L_fixed. False is a security violation."""
    return flows(assign(expression, pc), fixed)


# ---------------------------------------------------------------------------
# From the annotations to compartment sets
# ---------------------------------------------------------------------------


@dataclass(frozen=True)
class SetLattice:
    """The compartments of a class, and the set each declared level stands for."""

    compartments: Label
    """C, the top: every compartment."""
    levels: Mapping[str, Label]
    """A declared level (e.g. "HospitalAdmin") -> its set (e.g. {Oncology, Psych})."""

    @classmethod
    def from_lattice(cls, lattice: SecurityLattice) -> SetLattice:
        def below(x: str) -> list[str]:
            return [y for y in lattice.levels if y != x and lattice.le(y, x)]

        compartments = frozenset(
            x
            for x in lattice.levels
            if x != lattice.bot and lattice.join_all(below(x)) != x
        )
        levels = {
            x: frozenset(c for c in compartments if lattice.le(c, x))
            for x in lattice.levels
        }
        return cls(compartments=compartments, levels=levels)

    @classmethod
    def from_policy(
        cls, policy: ClassSecurityPolicy, dim: str = "conf"
    ) -> SetLattice:
        return cls.from_lattice(policy.product_lattice.lattices[dim])

    @property
    def bot(self) -> Label:
        return PUBLIC

    @property
    def top(self) -> Label:
        return self.compartments

    def label(self, level: str | SecurityLabel, dim: str = "conf") -> Label:
        """The set of a level name, or of a `SecurityLabel` from the policy."""
        if isinstance(level, SecurityLabel):
            level = level[dim]
        if level not in self.levels:
            raise ValueError(f"Unknown level {level!r}; known: {sorted(self.levels)}")
        return self.levels[level]

    def clearance(self, sec: SecurityLabel, dim: str = "conf") -> Label:
        """The set of a sink parameter's or a return value's clearance."""
        return self.label(sec, dim)

    def param_labels(
        self, method: MethodSecurityPolicy, dim: str = "conf"
    ) -> tuple[Label, ...]:
        """The fixed set of each parameter, in order; ∅ without `@Sec`."""
        constraints = method.param_constraints or (None,) * len(method.param_labels)
        return tuple(
            PUBLIC if sec is None else self.label(sec, dim) for sec in constraints
        )

    def show(self, label: Label) -> str:
        """`{Oncology, Psych}`, or `∅`."""
        return "{" + ", ".join(sorted(label)) + "}" if label else "∅"

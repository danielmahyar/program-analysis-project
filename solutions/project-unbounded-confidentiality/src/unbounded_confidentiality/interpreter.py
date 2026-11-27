"""Intraprocedural, termination-insensitive confidentiality for JVM int/boolean code.

Sign sets and integer intervals filter infeasible CFG edges. Widening on back edges lets
the worklist converge without unrolling the loop a fixed number of times.
"""

from __future__ import annotations

from collections import deque
from collections.abc import Mapping
from dataclasses import dataclass, field, replace
from typing import TYPE_CHECKING, Literal

import jvm
import sexpr
from jpamb.security import ClassSecurityPolicy, SecurityLattice
from jvm.state import PC

from .integer import AbstractInt, SignSet
from .interval import INT_MAX, INT_MIN, Interval
from .interval_branches import NEGATED_CONDITION, refine_integers

if TYPE_CHECKING:
    from jpamb import Bytecode


class UnsupportedInstruction(ValueError):
    """The method cannot be fully analyzed within the supported model."""


@dataclass(frozen=True)
class Config:
    # Optional clearance for unannotated returns. A method's @Sec takes precedence.
    return_clearance: str | None = None
    max_steps: int | None = None
    # Explicit policies for local slots, applying for the entire method.
    local_clearances: Mapping[int, str] = field(default_factory=dict)

    def __post_init__(self):
        if self.max_steps is not None and self.max_steps < 0:
            raise ValueError("max_steps must be non-negative or None")


@dataclass(frozen=True)
class Value(sexpr.AsSExpr):
    data: str
    control: str
    number: AbstractInt = field(default_factory=AbstractInt.top)
    # A stack value may still be equal to the current contents of a local slot.
    source_slot: int | None = None
    # Lower-bound (must) confidentiality label that holds on every reaching path.
    must: str | None = None

    def label(self, lattice: SecurityLattice) -> str:
        return lattice.join(self.data, self.control)

    def must_label(self, lattice: SecurityLattice) -> str:
        return self.must if self.must is not None else lattice.bot

    def join(
        self,
        other: Value,
        lattice: SecurityLattice,
        widening_thresholds: tuple[int, ...] | None = None,
    ) -> Value:
        number = (
            self.number.join(other.number)
            if widening_thresholds is None
            else self.number.widen(other.number, widening_thresholds)
        )
        return Value(
            lattice.join(self.data, other.data),
            lattice.join(self.control, other.control),
            number,
            self.source_slot if self.source_slot == other.source_slot else None,
            lattice.meet(self.must_label(lattice), other.must_label(lattice)),
        )

    def under(
        self, pc: str, lattice: SecurityLattice, must_pc: str | None = None
    ) -> Value:
        must = self.must_label(lattice)
        if must_pc is not None:
            must = lattice.join(must, must_pc)
        return replace(self, control=lattice.join(self.control, pc), must=must)


@dataclass(frozen=True)
class State(sexpr.AsSExpr):
    # None means not definitely initialized. Unreachable nodes have no State.
    locals: tuple[Value | None, ...]
    stack: tuple[Value, ...] = ()
    # One entry per controlling branch; bounded even on repeated loop visits.
    context: tuple[tuple[int, str], ...] = ()
    # Lower-bound controlling branch contexts active on every reaching path.
    must_context: tuple[tuple[int, str], ...] = ()

    def pc(self, lattice: SecurityLattice) -> str:
        return lattice.join_all(label for _, label in self.context)

    def must_pc(self, lattice: SecurityLattice) -> str:
        return lattice.join_all(label for _, label in self.must_context)

    def join(
        self,
        other: State,
        lattice: SecurityLattice,
        widening_thresholds: tuple[int, ...] | None = None,
    ) -> State:
        if len(self.locals) != len(other.locals) or len(self.stack) != len(other.stack):
            raise UnsupportedInstruction(
                "incompatible local/operand-stack shapes at merge"
            )
        context = dict(self.context)
        for branch, label in other.context:
            context[branch] = lattice.join(context.get(branch, lattice.bot), label)
        self_must = dict(self.must_context)
        other_must = dict(other.must_context)
        must_context = tuple(
            sorted(
                (branch, met)
                for branch in self_must.keys() & other_must.keys()
                if (met := lattice.meet(self_must[branch], other_must[branch]))
                != lattice.bot
            )
        )
        return State(
            tuple(
                a.join(b, lattice, widening_thresholds)
                if a is not None and b is not None
                else None
                for a, b in zip(self.locals, other.locals)
            ),
            tuple(
                a.join(b, lattice, widening_thresholds)
                for a, b in zip(self.stack, other.stack)
            ),
            tuple(sorted(context.items())),
            must_context,
        )

    def pop(self, count: int = 1) -> tuple[tuple[Value, ...], State]:
        if count < 0 or count > len(self.stack):
            raise UnsupportedInstruction("operand-stack underflow")
        if count == 0:
            return (), self
        return self.stack[-count:], replace(self, stack=self.stack[:-count])

    def push(self, *values: Value) -> State:
        return replace(self, stack=self.stack + values)

    def load(self, slot: int) -> Value:
        self.check_slot(slot)
        value = self.locals[slot]
        if value is None:
            raise UnsupportedInstruction(f"local {slot} is not definitely initialized")
        return value

    def check_slot(self, slot: int):
        if not 0 <= slot < len(self.locals):
            raise UnsupportedInstruction(f"invalid local slot {slot}")

    def store(self, slot: int, value: Value) -> State:
        self.check_slot(slot)
        # An older load can still be on the JVM stack after a store or iinc.
        stack = tuple(
            replace(v, source_slot=None) if v.source_slot == slot else v
            for v in self.stack
        )
        return replace(
            self,
            locals=self.locals[:slot]
            + (replace(value, source_slot=None),)
            + self.locals[slot + 1 :],
            stack=stack,
        )

    def refine_local(self, slot: int | None, number: AbstractInt) -> State:
        if slot is None:
            return self
        local = replace(self.load(slot), number=number)
        # Narrow surviving copies of the same value, without performing a store.
        stack = tuple(
            replace(v, number=number) if v.source_slot == slot else v
            for v in self.stack
        )
        return replace(
            self,
            locals=self.locals[:slot] + (local,) + self.locals[slot + 1 :],
            stack=stack,
        )


@dataclass(frozen=True)
class Diagnostic:
    offset: int
    kind: Literal["explicit", "implicit", "unsupported", "incomplete"]
    message: str
    actual: str | None = None
    allowed: str | None = None


@dataclass(frozen=True)
class Result:
    status: Literal["safe", "violation", "unsupported", "incomplete"]
    diagnostics: tuple[Diagnostic, ...]
    states: dict[PC, State]
    steps: int
    return_label: str | None = None
    can_return_ok: bool | None = None
    possible_div_zero: bool | None = None
    has_reachable_cycle: bool | None = None

    @property
    def safe(self) -> bool:
        return self.status == "safe"

    @property
    def complete(self) -> bool:
        return self.status in ("safe", "violation")


def require_int(type_: jvm.Type):
    # Compare descriptors: this also avoids relying on Type's numeric ordering.
    if type_.encode() not in ("I", "Z", "B", "C", "S"):
        raise UnsupportedInstruction(f"type {type_} is outside the int/boolean core")


def control_flow(opcodes: list[jvm.Opcode]) -> tuple[tuple[int, ...], ...]:
    """Successors use instruction indices, like PC and jvm2json branch targets."""
    n = len(opcodes)
    successors = []
    for i, op in enumerate(opcodes):
        match op:
            case jvm.If(target=target) | jvm.Ifz(target=target):
                targets = (target, i + 1)
            case jvm.Goto(target=target):
                targets = (target,)
            case jvm.Return() | jvm.Throw():
                targets = (n,)  # virtual method exit
            case _:
                targets = (i + 1,)
        if any(not 0 <= target < n for target in targets) and not (
            targets == (n,) and not isinstance(op, (jvm.If, jvm.Ifz, jvm.Goto))
        ):
            raise UnsupportedInstruction(f"invalid CFG successor at instruction {i}")
        successors.append(targets)
    return tuple(successors)


def postdominators(
    successors: tuple[tuple[int, ...], ...],
) -> tuple[frozenset[int], ...]:
    """Find where each branch stops controlling execution.

    A node with no path to the exit has only itself as a post-dominator.
    This keeps the guard's label active inside an endless loop.
    """
    n = len(successors)
    exiting = {n}
    changed = True
    while changed:
        before = len(exiting)
        exiting.update(
            i for i, edges in enumerate(successors) if any(t in exiting for t in edges)
        )
        changed = len(exiting) != before
    universe = set(range(n + 1))
    result = [set(universe) if i in exiting else {i} for i in range(n)] + [{n}]
    changed = True
    while changed:
        changed = False
        for i, edges in enumerate(successors):
            if i not in exiting:
                continue
            updated = {i} | set.intersection(*(result[t] for t in edges))
            if updated != result[i]:
                result[i] = updated
                changed = True
    return tuple(frozenset(nodes) for nodes in result)


def back_edges(successors: tuple[tuple[int, ...], ...]) -> set[tuple[int, int]]:
    """DFS edges to active ancestors. Removing these edges breaks every reachable cycle."""
    edges = set()
    seen = {0}
    active = {0}
    path = [(0, iter(successors[0]))]
    while path:
        source, outgoing = path[-1]
        target = next(outgoing, None)
        if target is None:
            path.pop()
            active.remove(source)
        elif target in active:
            edges.add((source, target))
        elif target < len(successors) and target not in seen:
            seen.add(target)
            active.add(target)
            path.append((target, iter(successors[target])))
    return edges


@dataclass
class AbstractInterpreter:
    bc: Bytecode
    method: jvm.Method
    policy: ClassSecurityPolicy
    lattice: SecurityLattice
    config: Config
    local_clearances: dict[int, str]
    return_clearance: str | None
    successors: tuple[tuple[int, ...], ...]
    back_edges: set[tuple[int, int]]
    thresholds: tuple[int, ...]
    postdom: tuple[frozenset[int], ...]
    worklist: deque[PC]
    states: dict[PC, State]
    diagnostics: set[Diagnostic] = field(default_factory=set)
    steps: int = 0
    returned: Value | None = None

    @classmethod
    def initial(
        cls,
        bc: Bytecode,
        methodid: jvm.AbsMethodID,
        policy: ClassSecurityPolicy,
        config: Config | None = None,
    ) -> AbstractInterpreter:
        config = config or Config()
        if "conf" not in policy.product_lattice.lattices:
            raise UnsupportedInstruction("class declares no confidentiality lattice")
        lattice = policy.product_lattice.lattices["conf"]
        declared = policy.method(methodid)
        if not declared.is_static:
            raise UnsupportedInstruction("instance methods/references are unsupported")
        if declared.unsupported_features:
            raise UnsupportedInstruction(", ".join(declared.unsupported_features))
        for type_ in methodid.extension.params:
            require_int(type_)
        if methodid.extension.return_type is not None:
            require_int(methodid.extension.return_type)
        method = bc.getmethod(methodid)
        if not method.opcodes:
            raise UnsupportedInstruction("method has no bytecode")
        slots = declared.param_slots or tuple(range(len(declared.param_labels)))
        if len(slots) != len(methodid.extension.params) or any(
            not 0 <= slot < method.max_locals for slot in slots
        ):
            raise UnsupportedInstruction("invalid parameter slots")
        initial = declared.initial_locals(
            policy.product_lattice,
            method.max_locals,
            uninitialized=True,
        )
        locals_: list[Value | None] = [None] * method.max_locals
        for slot, type_ in zip(slots, methodid.extension.params, strict=True):
            descriptor = type_.encode()
            interval = (
                Interval(0, 1) if descriptor == "Z" else Interval.top().cast(descriptor)
            )
            locals_[slot] = Value(
                initial[slot]["conf"],
                lattice.bot,
                AbstractInt(interval),
                must=initial[slot]["conf"],
            )
        state = State(tuple(locals_))
        # Later writes to a parameter must respect its @Sec or the class input default.
        constraints = declared.param_constraints or (None,) * len(slots)
        clearances = {
            slot: (label if label is not None else initial[slot])["conf"]
            for slot, label in zip(slots, constraints)
        }
        for slot, clearance in config.local_clearances.items():
            state.check_slot(slot)
            lattice.require(clearance)
            # An additional policy must not relax a parameter declaration.
            clearances[slot] = lattice.meet(
                clearances.get(slot, lattice.top), clearance
            )
        for slot, clearance in clearances.items():
            if state.locals[slot] is not None and not lattice.le(
                state.locals[slot].label(lattice), clearance
            ):
                raise UnsupportedInstruction(
                    f"initial local {slot} exceeds its clearance"
                )
        clearance = (
            declared.return_clearance["conf"]
            if declared.return_clearance is not None
            else config.return_clearance
        )
        if clearance is not None:
            lattice.require(clearance)
        successors = control_flow(method.opcodes)
        thresholds = {0}
        for op in method.opcodes:
            if isinstance(op, jvm.Push) and isinstance(op.value, int):
                thresholds.add(op.value)
            elif isinstance(op, jvm.Incr):
                thresholds.add(op.amount)
        pc = PC(methodid, 0)
        return cls(
            bc=bc,
            method=method,
            policy=policy,
            lattice=lattice,
            config=config,
            local_clearances=clearances,
            return_clearance=clearance,
            successors=successors,
            back_edges=back_edges(successors),
            thresholds=tuple(sorted(n for n in thresholds if INT_MIN <= n <= INT_MAX)),
            postdom=postdominators(successors),
            worklist=deque([pc]),
            states={pc: state},
        )

    def scoped(self, index: int, state: State) -> State:
        retained = tuple(
            (branch, label)
            for branch, label in state.context
            if index == branch or index not in self.postdom[branch]
        )
        retained_must = tuple(
            (branch, label)
            for branch, label in state.must_context
            if index == branch or index not in self.postdom[branch]
        )
        return replace(state, context=retained, must_context=retained_must)

    def check_flow(
        self, pc: PC, value: Value, context: str, allowed: str, target: str
    ) -> bool:
        actual = self.lattice.join(value.label(self.lattice), context)
        if self.lattice.le(actual, allowed):
            return True
        kind = "explicit" if not self.lattice.le(value.data, allowed) else "implicit"
        self.diagnostics.add(
            Diagnostic(
                pc.offset,
                kind,
                f"{target}: {actual} cannot flow to {allowed}",
                actual,
                allowed,
            )
        )
        return False

    def assign(self, pc: PC, state: State, slot: int, value: Value) -> State:
        context = state.pc(self.lattice)
        must_ctx = state.must_pc(self.lattice)
        value = value.under(context, self.lattice, must_ctx)
        if slot in self.local_clearances:
            # Check the value and active guard against the slot's declared clearance.
            fixed = self.local_clearances[slot]
            self.check_flow(pc, value, context, fixed, f"local {slot}")
            return state.store(
                slot, Value(fixed, self.lattice.bot, value.number, must=fixed)
            )
        # Unannotated locals infer their label: strong update L(e) ∪ pc.
        return state.store(slot, value)

    def branch(
        self, pc: PC, state: State, op: jvm.If | jvm.Ifz
    ) -> list[tuple[PC, State]]:
        operands, after = state.pop(2 if isinstance(op, jvm.If) else 1)
        left = operands[0]
        right = (
            operands[1]
            if len(operands) == 2
            else Value(
                self.lattice.bot,
                self.lattice.bot,
                AbstractInt.constant(0),
                must=self.lattice.bot,
            )
        )
        guard = self.lattice.join_all(
            (
                state.pc(self.lattice),
                left.label(self.lattice),
                right.label(self.lattice),
            )
        )
        controls = dict(after.context)
        controls[pc.offset] = guard
        must_guard = self.lattice.join_all(
            (
                state.must_pc(self.lattice),
                left.must_label(self.lattice),
                right.must_label(self.lattice),
            )
        )
        must_controls = dict(after.must_context)
        if must_guard != self.lattice.bot:
            must_controls[pc.offset] = must_guard
        else:
            must_controls.pop(pc.offset, None)
        after = replace(
            after,
            context=tuple(sorted(controls.items())),
            must_context=tuple(sorted(must_controls.items())),
        )

        condition = str(op.condition)
        if condition not in NEGATED_CONDITION:
            raise UnsupportedInstruction(f"unsupported integer comparison: {condition}")
        same = left.source_slot is not None and left.source_slot == right.source_slot
        result = []
        for target, test in zip(
            self.successors[pc.offset],
            (condition, NEGATED_CONDITION[condition]),
            strict=True,
        ):
            narrowed = refine_integers(
                test, left.number, right.number, same_operand=same
            )
            if narrowed is not None:
                edge = after.refine_local(left.source_slot, narrowed[0])
                edge = edge.refine_local(right.source_slot, narrowed[1])
                result.append((PC(pc.method, target), edge))
        return result

    def transfer(self, pc: PC, state: State) -> tuple[list[tuple[PC, State]], set[str]]:
        lattice = self.lattice
        context = state.pc(lattice)
        must_ctx = state.must_pc(lattice)
        op = self.method.opcodes[pc.offset]
        finals = set()
        match op:
            case jvm.Push(type=type_, value=value):
                require_int(type_)
                if not isinstance(value, int):
                    raise UnsupportedInstruction("non-integer constant")
                if not INT_MIN <= value <= INT_MAX:
                    raise UnsupportedInstruction(
                        "integer constant outside the JVM int range"
                    )
                after = state.push(
                    Value(
                        lattice.bot,
                        context,
                        AbstractInt.constant(value),
                        must=must_ctx,
                    )
                )
            case jvm.Load(type=type_, index=slot):
                require_int(type_)
                after = state.push(
                    replace(
                        state.load(slot).under(context, lattice, must_ctx),
                        source_slot=slot,
                    )
                )
            case jvm.Store(type=type_, index=slot):
                require_int(type_)
                (value,), after = state.pop()
                after = self.assign(pc, after, slot, value)
            case jvm.Incr(index=slot, amount=amount):
                value = state.load(slot)
                after = self.assign(
                    pc,
                    state,
                    slot,
                    replace(value, number=value.number.add_const(amount)),
                )
            case jvm.Binary() | jvm.Bitopr():
                require_int(op.type)
                (left, right), after = state.pop(2)
                # The decoder gives bitwise instructions their own operator enum.
                operator = jvm.BinaryOpr[op.operant.name]
                number = left.number.binary(operator, right.number)
                if number is None:
                    # Exception handlers are outside the supported method model.
                    return [], {"divide by zero"}
                after = after.push(
                    Value(
                        lattice.join(left.data, right.data),
                        lattice.join_all((left.control, right.control, context)),
                        number,
                        must=lattice.join_all(
                            (
                                left.must_label(lattice),
                                right.must_label(lattice),
                                must_ctx,
                            )
                        ),
                    )
                )
            case jvm.Negate(type=type_):
                require_int(type_)
                (value,), after = state.pop()
                after = after.push(
                    replace(
                        value.under(context, lattice, must_ctx),
                        number=value.number.negate(),
                        source_slot=None,
                    )
                )
            case jvm.Cast(from_=source, to_=target):
                require_int(source)
                require_int(target)
                (value,), after = state.pop()
                after = after.push(
                    replace(
                        value.under(context, lattice, must_ctx),
                        number=value.number.cast(target.encode()),
                        source_slot=None,
                    )
                )
            case jvm.If() | jvm.Ifz():
                return self.branch(pc, state, op), finals
            case jvm.Goto():
                after = state
            case jvm.Dup(words=words):
                if words not in (1, 2):
                    raise UnsupportedInstruction(f"unsupported dup width {words}")
                values, _ = state.pop(words)
                # Only the appended copies occupy positions written under this guard.
                after = state.push(
                    *(value.under(context, lattice, must_ctx) for value in values)
                )
            case jvm.Pop(words=words):
                if words not in (1, 2):
                    raise UnsupportedInstruction(f"unsupported pop width {words}")
                _, after = state.pop(words)
            case jvm.Swap():
                (left, right), after = state.pop(2)
                after = after.push(
                    right.under(context, lattice, must_ctx),
                    left.under(context, lattice, must_ctx),
                )
            case jvm.InvokeStatic(method=called):
                sink = self.policy.sink(called)
                if sink is None or not sink.is_static or sink.unsupported_features:
                    raise UnsupportedInstruction(
                        f"call without a supported sink summary: {called}"
                    )
                if called.extension.return_type is not None:
                    raise UnsupportedInstruction(f"non-void sink call: {called}")
                for type_ in called.extension.params:
                    require_int(type_)
                # A clearance alone is not a summary of arbitrary method effects.
                # Only verified empty static void bodies are boundary summaries.
                try:
                    body = self.bc.getmethod(called).opcodes
                except (
                    OSError,
                    KeyError,
                    ValueError,
                    NotImplementedError,
                    AssertionError,
                ) as exc:
                    raise UnsupportedInstruction(
                        f"cannot inspect sink body: {called}: {exc}"
                    ) from exc
                if (
                    len(body) != 1
                    or not isinstance(body[0], jvm.Return)
                    or body[0].type is not None
                ):
                    raise UnsupportedInstruction(
                        f"sink body has unsummarized effects: {called}"
                    )
                args, after = state.pop(len(sink.param_labels))
                for i, (arg, clearance) in enumerate(zip(args, sink.param_labels)):
                    if not self.check_flow(
                        pc, arg, context, clearance["conf"], f"{called} argument {i}"
                    ):
                        finals.add("assertion error")
            case jvm.Return(type=type_):
                if type_ is None:
                    if self.method.id.extension.return_type is not None or state.stack:
                        raise UnsupportedInstruction(
                            "invalid void return/operand stack"
                        )
                    finals.add("ok")
                else:
                    require_int(type_)
                    if self.method.id.extension.return_type is None:
                        raise UnsupportedInstruction(
                            "value returned from a void method"
                        )
                    (value,), after = state.pop()
                    if after.stack:
                        raise UnsupportedInstruction("extra operands at return")
                    value = value.under(context, lattice, must_ctx)
                    self.returned = (
                        value
                        if self.returned is None
                        else self.returned.join(value, lattice)
                    )
                    valid = self.return_clearance is None or self.check_flow(
                        pc, value, context, self.return_clearance, "return"
                    )
                    finals.add("ok" if valid else "assertion error")
                return [], finals
            case _:
                raise UnsupportedInstruction(f"unsupported instruction: {op!r}")
        return [(PC(pc.method, i), after) for i in self.successors[pc.offset]], finals

    def step(self) -> tuple[PC, set[str]]:
        pc = self.worklist.popleft()
        self.steps += 1
        try:
            successors, finals = self.transfer(pc, self.states[pc])
            if any(
                d.offset == pc.offset and d.kind in ("explicit", "implicit")
                for d in self.diagnostics
            ):
                finals.add("assertion error")
            for target, state in successors:
                if target.offset == len(self.method.opcodes):
                    raise UnsupportedInstruction(
                        "execution falls off the end of the method"
                    )
                state = self.scoped(target.offset, state)
                previous = self.states.get(target)
                thresholds = (
                    self.thresholds
                    if (pc.offset, target.offset) in self.back_edges
                    else None
                )
                merged = (
                    state
                    if previous is None
                    else previous.join(state, self.lattice, thresholds)
                )
                if previous is None or merged != previous:
                    self.states[target] = merged
                    self.worklist.append(target)
        except UnsupportedInstruction as exc:
            self.diagnostics.add(Diagnostic(pc.offset, "unsupported", str(exc)))
            finals = {"unknown"}
        return pc, finals

    def _analyze_outcomes(self) -> tuple[bool, bool, bool]:
        """Compute sound outcome summaries from the converged abstract states.

        Returns `(can_return_ok, possible_div_zero, has_reachable_cycle)`:
        - `can_return_ok` is False only if every feasible path from entry hits a
          definite confidentiality violation (proven via lower-bound `must`
          labels), definitely divides by zero, or cannot reach any `Return`.
        - `possible_div_zero` is False only if no reachable `div`/`rem` permits 0.
        - `has_reachable_cycle` is False only if no feasible back edge is reached.
        """
        lattice = self.lattice
        reachable = {pc.offset: state for pc, state in self.states.items()}
        definite_violations: set[int] = set()
        feasible_edges: dict[int, tuple[int, ...]] = {}
        possible_div_zero = False

        for offset, state in reachable.items():
            op = self.method.opcodes[offset]
            must_pc = state.must_pc(lattice)

            match op:
                case jvm.Store(index=slot) if slot in self.local_clearances:
                    val = state.stack[-1]
                    if not lattice.le(
                        lattice.join(val.must_label(lattice), must_pc),
                        self.local_clearances[slot],
                    ):
                        definite_violations.add(offset)
                    feasible_edges[offset] = self.successors[offset]
                case jvm.Incr(index=slot) if slot in self.local_clearances:
                    val = state.load(slot)
                    if not lattice.le(
                        lattice.join(val.must_label(lattice), must_pc),
                        self.local_clearances[slot],
                    ):
                        definite_violations.add(offset)
                    feasible_edges[offset] = self.successors[offset]
                case jvm.InvokeStatic(method=called):
                    sink = self.policy.sink(called)
                    assert sink is not None
                    nargs = len(sink.param_labels)
                    args = state.stack[-nargs:] if nargs else ()
                    if any(
                        not lattice.le(
                            lattice.join(arg.must_label(lattice), must_pc),
                            clearance["conf"],
                        )
                        for arg, clearance in zip(args, sink.param_labels)
                    ):
                        definite_violations.add(offset)
                    feasible_edges[offset] = self.successors[offset]
                case jvm.Return(type=type_):
                    if type_ is not None and self.return_clearance is not None:
                        val = state.stack[-1]
                        if not lattice.le(
                            lattice.join(val.must_label(lattice), must_pc),
                            self.return_clearance,
                        ):
                            definite_violations.add(offset)
                    feasible_edges[offset] = ()
                case jvm.If() | jvm.Ifz():
                    pc = PC(self.method.id, offset)
                    feasible_edges[offset] = tuple(
                        target.offset for target, _ in self.branch(pc, state, op)
                    )
                case jvm.Binary() | jvm.Bitopr():
                    operator = jvm.BinaryOpr[op.operant.name]
                    left, right = state.stack[-2], state.stack[-1]
                    if (
                        operator in (jvm.BinaryOpr.Div, jvm.BinaryOpr.Rem)
                        and SignSet.ZERO in right.number.signs
                    ):
                        possible_div_zero = True
                    if left.number.binary(operator, right.number) is None:
                        feasible_edges[offset] = ()
                    else:
                        feasible_edges[offset] = self.successors[offset]
                case jvm.Throw():
                    feasible_edges[offset] = ()
                case _:
                    feasible_edges[offset] = self.successors[offset]

        can_return_ok = False
        has_reachable_cycle = False
        if 0 in reachable and 0 not in definite_violations:
            visited = {0}
            queue = deque([0])
            while queue:
                curr = queue.popleft()
                if isinstance(self.method.opcodes[curr], jvm.Return):
                    can_return_ok = True
                for nxt in feasible_edges.get(curr, ()):
                    if nxt in definite_violations or nxt not in reachable:
                        continue
                    if (curr, nxt) in self.back_edges:
                        has_reachable_cycle = True
                    if nxt not in visited:
                        visited.add(nxt)
                        queue.append(nxt)

        return can_return_ok, possible_div_zero, has_reachable_cycle

    def result(self) -> Result:
        diagnostics = set(self.diagnostics)
        if self.worklist:
            status = "incomplete"
            diagnostics.add(
                Diagnostic(-1, "incomplete", "work remains; resource limit reached")
            )
        elif any(d.kind == "unsupported" for d in diagnostics):
            status = "unsupported"
        elif diagnostics:
            status = "violation"
        else:
            status = "safe"
        can_return_ok: bool | None = None
        possible_div_zero: bool | None = None
        has_reachable_cycle: bool | None = None
        if status in ("safe", "violation"):
            (
                can_return_ok,
                possible_div_zero,
                has_reachable_cycle,
            ) = self._analyze_outcomes()
        return Result(
            status,
            tuple(sorted(diagnostics, key=lambda d: (d.offset, d.kind, d.message))),
            dict(self.states),
            self.steps,
            self.returned.label(self.lattice) if self.returned is not None else None,
            can_return_ok=can_return_ok,
            possible_div_zero=possible_div_zero,
            has_reachable_cycle=has_reachable_cycle,
        )

    def run(self) -> Result:
        while self.worklist and (
            self.config.max_steps is None or self.steps < self.config.max_steps
        ):
            self.step()
        return self.result()


def analyze(
    bc: Bytecode,
    methodid: jvm.AbsMethodID,
    policy: ClassSecurityPolicy,
    config: Config | None = None,
) -> Result:
    """Analyze a method, converting unsupported decoding/policies into unknown results."""
    try:
        interpreter = AbstractInterpreter.initial(bc, methodid, policy, config)
    except (
        OSError,
        KeyError,
        ValueError,
        NotImplementedError,
        AssertionError,
        TypeError,
    ) as exc:
        return Result("unsupported", (Diagnostic(-1, "unsupported", str(exc)),), {}, 0)
    return interpreter.run()

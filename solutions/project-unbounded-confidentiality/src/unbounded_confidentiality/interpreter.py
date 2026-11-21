"""Intraprocedural, termination-insensitive confidentiality for JVM int/boolean code.

This domain tracks dependencies, never numeric values. Both conditional successors
are explored. Unsupported effects make the result unknown, even when another path
has returned normally. See docs/security.md for the boundary and threat model.
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

if TYPE_CHECKING:
    from jpamb import Bytecode


class UnsupportedInstruction(ValueError):
    """The method cannot be fully analyzed within the supported model."""


@dataclass(frozen=True)
class Config:
    # None means lattice bottom (Public, Low, Unclassified, etc.).
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

    def label(self, lattice: SecurityLattice) -> str:
        return lattice.join(self.data, self.control)

    def join(self, other: Value, lattice: SecurityLattice) -> Value:
        return Value(
            lattice.join(self.data, other.data),
            lattice.join(self.control, other.control),
        )

    def under(self, pc: str, lattice: SecurityLattice) -> Value:
        return Value(self.data, lattice.join(self.control, pc))


@dataclass(frozen=True)
class State(sexpr.AsSExpr):
    # None means not definitely initialized. Unreachable nodes have no State.
    locals: tuple[Value | None, ...]
    stack: tuple[Value, ...] = ()
    # One entry per controlling branch; bounded even on repeated loop visits.
    context: tuple[tuple[int, str], ...] = ()

    def pc(self, lattice: SecurityLattice) -> str:
        return lattice.join_all(label for _, label in self.context)

    def join(self, other: State, lattice: SecurityLattice) -> State:
        if len(self.locals) != len(other.locals) or len(self.stack) != len(other.stack):
            raise UnsupportedInstruction(
                "incompatible local/operand-stack shapes at merge"
            )
        context = dict(self.context)
        for branch, label in other.context:
            context[branch] = lattice.join(context.get(branch, lattice.bot), label)
        return State(
            tuple(
                a.join(b, lattice) if a is not None and b is not None else None
                for a, b in zip(self.locals, other.locals)
            ),
            tuple(a.join(b, lattice) for a, b in zip(self.stack, other.stack)),
            tuple(sorted(context.items())),
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
        return replace(
            self, locals=self.locals[:slot] + (value,) + self.locals[slot + 1 :]
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
    """Compute control scopes, retaining context conservatively in non-exiting SCCs.

    Nodes without a path to EXIT have only themselves as post-dominators. This
    avoids arbitrary context restoration inside an infinite cycle.
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


@dataclass
class AbstractInterpreter:
    bc: Bytecode
    method: jvm.Method
    policy: ClassSecurityPolicy
    lattice: SecurityLattice
    config: Config
    local_clearances: dict[int, str]
    return_clearance: str
    successors: tuple[tuple[int, ...], ...]
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
        state = State(
            tuple(
                Value(label["conf"], lattice.bot) if label is not None else None
                for label in initial
            )
        )
        # Every parameter has a fixed label: its @Sec, or else the class's
        # input default (Public in every case class). Writes are certified.
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
            if config.return_clearance is not None
            else lattice.bot
        )
        lattice.require(clearance)
        successors = control_flow(method.opcodes)
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
        # A branch can select existing stack values using only swap/pop. Taint
        # live stack positions at the merge before discarding its context, so
        # those choices cannot escape merely because no constant was produced.
        leaving = self.lattice.join_all(
            label
            for branch, label in state.context
            if index != branch and index in self.postdom[branch]
        )
        return replace(
            state,
            stack=tuple(value.under(leaving, self.lattice) for value in state.stack),
            context=retained,
        )

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
        value = value.under(state.pc(self.lattice), self.lattice)
        if slot in self.local_clearances:
            # Security certification: L(e) ∪ pc ⊑ L_fixed. A fixed label is
            # never inferred, so the slot keeps it whether or not the check holds.
            fixed = self.local_clearances[slot]
            self.check_flow(pc, value, state.pc(self.lattice), fixed, f"local {slot}")
            return state.store(slot, Value(fixed, self.lattice.bot))
        # Unannotated locals infer their label: strong update L(e) ∪ pc.
        return state.store(slot, value)

    def transfer(self, pc: PC, state: State) -> tuple[list[tuple[PC, State]], set[str]]:
        lattice = self.lattice
        context = state.pc(lattice)
        op = self.method.opcodes[pc.offset]
        finals = set()
        match op:
            case jvm.Push(type=type_, value=value):
                require_int(type_)
                if not isinstance(value, int):
                    raise UnsupportedInstruction("non-integer constant")
                after = state.push(Value(lattice.bot, context))
            case jvm.Load(type=type_, index=slot):
                require_int(type_)
                after = state.push(state.load(slot).under(context, lattice))
            case jvm.Store(type=type_, index=slot):
                require_int(type_)
                (value,), after = state.pop()
                after = self.assign(pc, after, slot, value)
            case jvm.Incr(index=slot):
                after = self.assign(pc, state, slot, state.load(slot))
            case jvm.Binary(type=type_):
                require_int(type_)
                (left, right), after = state.pop(2)
                after = after.push(left.join(right, lattice).under(context, lattice))
            case jvm.Negate(type=type_):
                require_int(type_)
                (value,), after = state.pop()
                after = after.push(value.under(context, lattice))
            case jvm.Cast(from_=source, to_=target):
                require_int(source)
                require_int(target)
                (value,), after = state.pop()
                after = after.push(value.under(context, lattice))
            case jvm.If() | jvm.Ifz():
                operands, after = state.pop(2 if isinstance(op, jvm.If) else 1)
                condition = lattice.join_all(v.label(lattice) for v in operands)
                controls = dict(after.context)
                controls[pc.offset] = lattice.join(context, condition)
                after = replace(after, context=tuple(sorted(controls.items())))
            case jvm.Goto():
                after = state
            case jvm.Dup(words=words):
                if words not in (1, 2):
                    raise UnsupportedInstruction(f"unsupported dup width {words}")
                values, after = state.pop(words)
                after = after.push(*values, *values)
            case jvm.Pop(words=words):
                if words not in (1, 2):
                    raise UnsupportedInstruction(f"unsupported pop width {words}")
                _, after = state.pop(words)
            case jvm.Swap():
                (left, right), after = state.pop(2)
                after = after.push(right, left)
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
                    value = value.under(context, lattice)
                    self.returned = (
                        value
                        if self.returned is None
                        else self.returned.join(value, lattice)
                    )
                    valid = self.check_flow(
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
                merged = (
                    state if previous is None else previous.join(state, self.lattice)
                )
                if previous is None or merged != previous:
                    self.states[target] = merged
                    self.worklist.append(target)
        except UnsupportedInstruction as exc:
            self.diagnostics.add(Diagnostic(pc.offset, "unsupported", str(exc)))
            finals = {"unknown"}
        return pc, finals

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
        return Result(
            status,
            tuple(sorted(diagnostics, key=lambda d: (d.offset, d.kind, d.message))),
            dict(self.states),
            self.steps,
            self.returned.label(self.lattice) if self.returned is not None else None,
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

"""Concrete confidentiality tracking using the static engine's boundary policies.

Only the conf lattice is checked. Policy initialization and control scopes are
shared with jpamb.confidentiality; execution follows one concrete path.
"""

from __future__ import annotations

import dataclasses

import fuzz_contract

import jpamb
import jpamb.security
import jvm
import jvm.state as jvmc
from jpamb import confidentiality

ShadowValue = confidentiality.Value
PreparedMethods = dict[tuple, confidentiality.AbstractInterpreter]


class ShadowStateError(RuntimeError):
    """The interpreter and shadow state disagree: an implementation error."""


@dataclasses.dataclass
class ShadowFrame:
    model: confidentiality.AbstractInterpreter
    base_pc: str
    locals: dict[int, ShadowValue] = dataclasses.field(default_factory=dict)
    stack: list[ShadowValue] = dataclasses.field(default_factory=list)
    contexts: dict[int, str] = dataclasses.field(default_factory=dict)


class NoMonitor:
    """Ordinary cases retain their concrete execution without security checks."""

    active = False

    def __init__(self):
        self.last_violation: str | None = None
        self.violations: list[fuzz_contract.Violation] = []

    def at(self, pc: jvmc.PC): ...
    def push(self, n: int = 1): ...
    def load(self, index: int): ...
    def dup(self, words: int = 1): ...
    def pop(self, n: int = 1): ...
    def swap(self): ...
    def op(self, consumed: int, produced: int = 1): ...
    def branch(self, offset: int, consumed: int): ...

    def store(self, index: int) -> bool:
        return False

    def incr(self, index: int) -> bool:
        return False

    def invoke(self, callee: jvm.AbsMethodID, nargs: int, enters: bool) -> bool:
        return False

    def ret(self, has_value: bool) -> bool:
        return False


class SecurityMonitor(NoMonitor):
    """Fresh shadow state; prepared policy/CFG models belong to one runner."""

    active = True

    def __init__(
        self,
        bc: jpamb.Bytecode,
        policy: jpamb.security.ClassSecurityPolicy,
        methodid: jvm.AbsMethodID,
        config: confidentiality.Config | None = None,
        *,
        prepared: PreparedMethods | None = None,
    ):
        super().__init__()
        self.bc = bc
        self.policy = policy
        self.config = config if config is not None else confidentiality.Config()
        if not isinstance(self.config, confidentiality.Config):
            raise TypeError("security_config must be a jpamb.confidentiality.Config")
        self.prepared = prepared if prepared is not None else {}
        self.current_location = jvmc.PC(methodid, 0)
        model = self._prepare(methodid, self.config)
        self.lattice = model.lattice
        self.bot = self.lattice.bot
        self.frames = [self._new_frame(model, self.bot)]

    def _prepare(self, methodid, config):
        method = self.bc.getmethod(methodid)
        key = (
            methodid,
            id(method),
            config.return_clearance,
            tuple(sorted(config.local_clearances.items())),
        )
        if key not in self.prepared:
            # Initialize the shared policy/CFG, but never run its static worklist.
            self.prepared[key] = confidentiality.AbstractInterpreter.initial(
                self.bc, methodid, self.policy, config
            )
        return self.prepared[key]

    @staticmethod
    def _new_frame(model, base_pc):
        initial = model.states[jvmc.PC(model.method.id, 0)]
        return ShadowFrame(
            model,
            base_pc,
            locals={
                i: value for i, value in enumerate(initial.locals) if value is not None
            },
        )

    @property
    def frame(self) -> ShadowFrame:
        return self.frames[-1]

    def join(self, *labels: str) -> str:
        return self.lattice.join_all(labels)

    def pc(self) -> str:
        return self.join(self.frame.base_pc, *self.frame.contexts.values())

    def _pop(self) -> ShadowValue:
        if not self.frame.stack:
            raise ShadowStateError(f"shadow stack underflow at {self.current_location}")
        return self.frame.stack.pop()

    def _local(self, index: int) -> ShadowValue:
        if index not in self.frame.locals:
            raise confidentiality.UnsupportedInstruction(
                f"local {index} is not initialized at {self.current_location}"
            )
        return self.frame.locals[index]

    def _certify(self, sv: ShadowValue, clearance: str, where: str) -> bool:
        ctx = self.pc()
        effective = self.join(sv.label(self.lattice), ctx)
        if self.lattice.le(effective, clearance):
            return True
        data_bad = not self.lattice.le(sv.data, clearance)
        control_bad = not self.lattice.le(self.join(sv.control, ctx), clearance)
        kind = (
            "mixed"
            if data_bad and control_bad
            else "explicit"
            if data_bad
            else "implicit"
        )
        self.violations.append(
            fuzz_contract.Violation(
                self.current_location, where, effective, clearance, ctx, kind
            )
        )
        self.last_violation = (
            f"CONFIDENTIALITY VIOLATION ({kind}) at {where}: "
            f"{effective} cannot flow to {clearance}"
        )
        return False

    def at(self, pc: jvmc.PC):
        self.current_location = pc
        f = self.frame
        if pc.method != f.model.method.id:
            raise ShadowStateError("concrete and shadow frames disagree")
        op = f.model.method.opcodes[pc.offset]
        # Heap/reference effects have no shadow model. Ordinary cases can still
        # use the wider concrete interpreter through NoMonitor.
        match op:
            case (
                jvm.Push(type=t)
                | jvm.Load(type=t)
                | jvm.Store(type=t)
                | jvm.Binary(type=t)
                | jvm.Bitopr(type=t)
                | jvm.Negate(type=t)
            ):
                confidentiality.require_int(t)
            case jvm.Cast(from_=source, to_=target):
                confidentiality.require_int(source)
                confidentiality.require_int(target)
            case jvm.Return(type=t) if t is not None:
                confidentiality.require_int(t)
            case jvm.Dup(words=n) | jvm.Pop(words=n) if n not in (1, 2):
                raise confidentiality.UnsupportedInstruction(
                    f"unsupported stack width {n}"
                )
            case jvm.New(classname=jvm.ClassName("java.lang.AssertionError")):
                pass  # Ordinary assertions are outcomes, not policy diagnostics.
            case jvm.Get(static=True, field=field) if (
                field.extension.name == "$assertionsDisabled"
            ):
                pass
            case (
                jvm.If()
                | jvm.Ifz()
                | jvm.Goto()
                | jvm.Incr()
                | jvm.Dup()
                | jvm.Pop()
                | jvm.Swap()
                | jvm.InvokeStatic()
                | jvm.Return()
            ):
                pass
            case _:
                raise confidentiality.UnsupportedInstruction(
                    f"unsupported security effect: {op}"
                )

        leaving = [
            branch
            for branch in f.contexts
            if branch != pc.offset and pc.offset in f.model.postdom[branch]
        ]
        context = self.join(*(f.contexts.pop(branch) for branch in leaving))
        f.stack = [value.under(context, self.lattice) for value in f.stack]

    def push(self, n: int = 1):
        self.frame.stack.extend(ShadowValue(self.bot, self.pc()) for _ in range(n))

    def load(self, index: int):
        self.frame.stack.append(self._local(index).under(self.pc(), self.lattice))

    def _assign(self, index: int, value: ShadowValue) -> bool:
        if not 0 <= index < self.frame.model.method.max_locals:
            raise confidentiality.UnsupportedInstruction(f"invalid local slot {index}")
        value = value.under(self.pc(), self.lattice)
        fixed = self.frame.model.local_clearances.get(index)
        if fixed is not None:
            if not self._certify(value, fixed, f"local {index}"):
                return True
            self.frame.locals[index] = ShadowValue(fixed, self.bot)
        else:
            self.frame.locals[index] = value
        return False

    def store(self, index: int) -> bool:
        return self._assign(index, self._pop())

    def incr(self, index: int) -> bool:
        return self._assign(index, self._local(index))

    def dup(self, words: int = 1):
        values = [self._pop() for _ in range(words)][::-1]
        self.frame.stack.extend(values + values)

    def pop(self, n: int = 1):
        for _ in range(n):
            self._pop()

    def swap(self):
        b, a = self._pop(), self._pop()
        self.frame.stack.extend((b, a))

    def op(self, consumed: int, produced: int = 1):
        operands = [self._pop() for _ in range(consumed)]
        value = ShadowValue(
            self.join(*(o.data for o in operands)),
            self.join(*(o.control for o in operands), self.pc()),
        )
        self.frame.stack.extend([value] * produced)

    def branch(self, offset: int, consumed: int):
        operands = [self._pop() for _ in range(consumed)]
        condition = self.join(*(o.label(self.lattice) for o in operands))
        # One entry per branch bounds context storage across loop iterations.
        self.frame.contexts[offset] = self.join(self.pc(), condition)

    def invoke(self, callee: jvm.AbsMethodID, nargs: int, enters: bool) -> bool:
        sink = self.policy.sink(callee)
        if (
            not enters
            or sink is None
            or not sink.is_static
            or sink.unsupported_features
        ):
            raise confidentiality.UnsupportedInstruction(
                f"call without supported sink: {callee}"
            )
        if callee.extension.return_type is not None:
            raise confidentiality.UnsupportedInstruction(f"non-void sink: {callee}")
        for parameter in callee.extension.params:
            confidentiality.require_int(parameter)
        try:
            body = self.bc.getmethod(callee).opcodes
        except (OSError, KeyError, ValueError, NotImplementedError) as exc:
            raise confidentiality.UnsupportedInstruction(
                f"cannot inspect sink body: {callee}: {exc}"
            ) from exc
        if (
            len(body) != 1
            or not isinstance(body[0], jvm.Return)
            or body[0].type is not None
        ):
            raise confidentiality.UnsupportedInstruction(
                f"sink body has unsummarized effects: {callee}"
            )
        args = [self._pop() for _ in range(nargs)][::-1]
        for index, (value, clearance) in enumerate(zip(args, sink.param_labels)):
            if not self._certify(
                value, clearance["conf"], f"{sink.name} argument {index}"
            ):
                return True
        self.frames.append(
            self._new_frame(self._prepare(callee, confidentiality.Config()), self.pc())
        )
        return False

    def ret(self, has_value: bool) -> bool:
        if has_value != (self.frame.model.method.id.extension.return_type is not None):
            raise confidentiality.UnsupportedInstruction(
                "return does not match method type"
            )
        if has_value:
            value = self._pop()
            if self.frame.stack:
                raise confidentiality.UnsupportedInstruction("extra operands at return")
            if not self._certify(
                value,
                self.frame.model.return_clearance,
                f"{self.frame.model.method.id.extension.name}:return",
            ):
                return True
        elif self.frame.stack:
            raise confidentiality.UnsupportedInstruction(
                "nonempty stack at void return"
            )
        self.frames.pop()
        return False


def make_monitor(
    bc: jpamb.Bytecode,
    policy: jpamb.security.ClassSecurityPolicy | None,
    methodid: jvm.AbsMethodID,
    config: confidentiality.Config | None = None,
    *,
    prepared: PreparedMethods | None = None,
) -> NoMonitor:
    if policy is None:
        return NoMonitor()
    return SecurityMonitor(bc, policy, methodid, config, prepared=prepared)

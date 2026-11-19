"""Dynamic information-flow monitor (shadow labels) for the concrete interpreter.

Every concrete value the interpreter puts in a local variable or on the operand
stack gets a *shadow value* `(data, control)` from the class's confidentiality
lattice L_C. The labels move with the values, one small step at a time, following
the rules in `cases/jpamb/utils/Sec.java`:

    push c                  data := bot,           control := pc
    load i                  data := data(local i), control := control(local i) ⊔ pc
    store i                 local i := (data, control ⊔ pc)          (strong update)
    iinc i                  local i := (data(local i), control(local i) ⊔ pc)
    a op b, -a, (cast) a    data := data(a) ⊔ data(b), control := ctrl(a) ⊔ ctrl(b) ⊔ pc
    if / ifz on c           push (ipdom(i), pc ⊔ full(c)) on the pc stack
    reaching ipdom(i)       pop that entry again                     (implicit flows end)
    sink(v1..vk)            leak iff full(vj) ⊔ pc ⋢ clearance_j  -> "assertion error"
    return v  (@Sec method) leak iff full(v)  ⊔ pc ⋢ return clearance

Tracking `data` (explicit provenance) and `control` (implicit provenance from
branches) separately lets the monitor classify every detected violation as
`"explicit"`, `"implicit"`, or `"mixed"` in `fuzz_contract.Violation`.
"""

from __future__ import annotations

import dataclasses

import fuzz_contract
import jpamb
import jpamb.confidentiality
import jpamb.security
import jvm
import jvm.state as jvmc

_IPDOM_CACHE: dict[jvm.AbsMethodID, list[int]] = {}


def immediate_postdominators(
    opcodes: list[jvm.Opcode], methodid: jvm.AbsMethodID | None = None
) -> list[int]:
    """ipdom[i]: the first instruction every path leaving i must pass through.

    The value len(opcodes) is the virtual EXIT node: when the two arms of a
    branch end in different returns, the branch context lasts until the method
    exits (so `if (s > 0) return 1; return 0;` leaks at both returns).
    """
    if methodid is not None and methodid in _IPDOM_CACHE:
        return _IPDOM_CACHE[methodid]
    n = len(opcodes)
    pdom = jpamb.confidentiality.postdominators(
        jpamb.confidentiality.control_flow(opcodes)
    )
    ipdom = []
    for i in range(n):
        strict = pdom[i] - {i}
        ipdom.append(next((d for d in strict if pdom[d] == strict), n))
    if methodid is not None:
        _IPDOM_CACHE[methodid] = ipdom
    return ipdom


@dataclasses.dataclass(frozen=True)
class ShadowValue:
    """Explicit data provenance (`data`) and implicit branch provenance (`control`)."""

    data: jpamb.security.SecurityLabel
    control: jpamb.security.SecurityLabel


@dataclasses.dataclass
class ShadowFrame:
    """The shadow of one JVM frame: a ShadowValue per local and per stack slot."""

    method: jvm.AbsMethodID
    ipdom: list[int]
    base_pc: jpamb.security.SecurityLabel
    locals: dict[int, ShadowValue] = dataclasses.field(default_factory=dict)
    stack: list[ShadowValue] = dataclasses.field(default_factory=list)
    pc_stack: list[tuple[int, jpamb.security.SecurityLabel]] = dataclasses.field(
        default_factory=list
    )


class NoMonitor:
    """Used for classes without @Lattice: every hook does nothing."""

    active = False
    last_violation: str | None = None
    violations: list[fuzz_contract.Violation] = []

    def at(self, pc: jvmc.PC): ...
    def push(self, n: int = 1): ...
    def load(self, index: int): ...
    def store(self, index: int): ...
    def incr(self, index: int): ...
    def dup(self): ...
    def pop(self, n: int = 1): ...
    def swap(self): ...
    def op(self, consumed: int, produced: int = 1): ...
    def branch(self, offset: int, consumed: int): ...

    def invoke(self, callee: jvm.AbsMethodID, nargs: int, enters: bool) -> bool:
        return False

    def ret(self, has_value: bool) -> bool:
        return False


class SecurityMonitor(NoMonitor):
    """Shadow state for a class that declares @Lattice."""

    active = True

    def __init__(
        self,
        bc: jpamb.Bytecode,
        policy: jpamb.security.ClassSecurityPolicy,
        methodid: jvm.AbsMethodID,
    ):
        self.bc = bc
        self.policy = policy
        self.lattice: jpamb.security.ProductLattice = policy.product_lattice
        self.bot: jpamb.security.SecurityLabel = self.lattice.bot
        self.case: jpamb.security.MethodSecurityPolicy = policy.method(methodid)
        self.frames: list[ShadowFrame] = []
        self.current_location: jvmc.PC = jvmc.PC(methodid, 0)
        self.last_violation: str | None = None
        self.violations: list[fuzz_contract.Violation] = []

        root = self._new_frame(methodid, self.bot)
        for slot, label in zip(self.case.param_slots, self.case.param_labels):
            root.locals[slot] = ShadowValue(data=label, control=self.bot)
        self.frames.append(root)

    # -- helpers ---------------------------------------------------------------

    def _new_frame(
        self, methodid: jvm.AbsMethodID, base_pc: jpamb.security.SecurityLabel
    ):
        opcodes = self.bc.getmethod(methodid).opcodes
        return ShadowFrame(
            methodid, immediate_postdominators(opcodes, methodid), base_pc
        )

    @property
    def frame(self) -> ShadowFrame:
        return self.frames[-1]

    def join(
        self, *labels: jpamb.security.SecurityLabel
    ) -> jpamb.security.SecurityLabel:
        result = self.bot
        for label in labels:
            result = self.lattice.join(result, label)
        return result

    def full(self, sv: ShadowValue) -> jpamb.security.SecurityLabel:
        return self.join(sv.data, sv.control)

    def pc(self) -> jpamb.security.SecurityLabel:
        """τ_pc: the security context of the current instruction."""
        f = self.frame
        return self.join(f.base_pc, f.pc_stack[-1][1]) if f.pc_stack else f.base_pc

    def _bot_value(self) -> ShadowValue:
        return ShadowValue(self.bot, self.bot)

    def _pop(self) -> ShadowValue:
        return (
            self.frame.stack.pop()
            if self.frame.stack
            else ShadowValue(self.bot, self.pc())
        )

    def _classify(
        self,
        sv: ShadowValue,
        ctx: jpamb.security.SecurityLabel,
        clearance: jpamb.security.SecurityLabel,
    ) -> fuzz_contract.ViolationKind:
        data_bad = not self.lattice.le(sv.data, clearance)
        ctrl_bad = not self.lattice.le(self.join(sv.control, ctx), clearance)
        if data_bad and ctrl_bad:
            return "mixed"
        if data_bad:
            return "explicit"
        if ctrl_bad:
            return "implicit"
        return "explicit"

    def _certify(
        self,
        sv: ShadowValue,
        clearance: jpamb.security.SecurityLabel,
        where: str,
    ) -> bool:
        """full(v) ⊔ pc ⊑ clearance? Records a structured Violation if not."""
        ctx = self.pc()
        effective = self.join(sv.data, sv.control, ctx)
        if self.lattice.le(effective, clearance):
            return True
        kind = self._classify(sv, ctx, clearance)
        self.violations.append(
            fuzz_contract.Violation(
                pc=self.current_location,
                target=where,
                effective=str(effective),
                allowed=str(clearance),
                context=str(ctx),
                kind=kind,
            )
        )
        self.last_violation = (
            f"SECURITY VIOLATION ({kind}) at {where}: "
            f"{effective} cannot flow to {clearance}"
        )
        return False

    # -- hooks, called by the interpreter before it executes an instruction -----

    def at(self, pc: jvmc.PC):
        """Record current PC and pop every branch context whose merge point is here."""
        self.current_location = pc
        f = self.frame
        while f.pc_stack and f.pc_stack[-1][0] == pc.offset:
            f.pc_stack.pop()

    def push(self, n: int = 1):
        """Constants (push, getstatic): data is bot, control is pc."""
        for _ in range(n):
            self.frame.stack.append(ShadowValue(self.bot, self.pc()))

    def load(self, index: int):
        sv = self.frame.locals.get(index, self._bot_value())
        self.frame.stack.append(ShadowValue(sv.data, self.join(sv.control, self.pc())))

    def store(self, index: int):
        sv = self._pop()
        self.frame.locals[index] = ShadowValue(
            sv.data, self.join(sv.control, self.pc())
        )

    def incr(self, index: int):
        sv = self.frame.locals.get(index, self._bot_value())
        self.frame.locals[index] = ShadowValue(
            sv.data, self.join(sv.control, self.pc())
        )

    def dup(self):
        sv = self._pop()
        self.frame.stack += [sv, sv]

    def pop(self, n: int = 1):
        for _ in range(n):
            self._pop()

    def swap(self):
        b, a = self._pop(), self._pop()
        self.frame.stack += [b, a]

    def op(self, consumed: int, produced: int = 1):
        """Any operation: joins operand data labels and joins operand control + pc."""
        operands = [self._pop() for _ in range(consumed)]
        data = self.join(*(o.data for o in operands))
        ctrl = self.join(*(o.control for o in operands), self.pc())
        self.frame.stack += [ShadowValue(data, ctrl)] * produced

    def branch(self, offset: int, consumed: int):
        """if/ifz: raise pc with the condition's full label until ipdom(offset)."""
        operands = [self._pop() for _ in range(consumed)]
        cond = self.join(*(self.full(o) for o in operands))
        f = self.frame
        f.pc_stack.append((f.ipdom[offset], self.join(self.pc(), cond)))

    def invoke(self, callee: jvm.AbsMethodID, nargs: int, enters: bool) -> bool:
        """A call. Returns True if it is a leak (a sink that may not receive an argument)."""
        args = [self._pop() for _ in range(nargs)][::-1]
        sink = self.policy.sink(callee)
        if sink is not None:
            for j, (sv, clearance) in enumerate(zip(args, sink.param_labels)):
                if not self._certify(sv, clearance, f"{sink.name} argument {j}"):
                    return True
        if enters:
            callee_frame = self._new_frame(callee, self.pc())
            for i, sv in enumerate(args):
                callee_frame.locals[i] = ShadowValue(
                    sv.data, self.join(sv.control, self.pc())
                )
            self.frames.append(callee_frame)
        else:
            data = self.join(*(a.data for a in args))
            ctrl = self.join(*(a.control for a in args), self.pc())
            self.frame.stack.append(ShadowValue(data, ctrl))
        return False

    def ret(self, has_value: bool) -> bool:
        """A return. Returns True if the root method leaks through its return value."""
        sv = self._pop() if has_value else None
        if sv is not None:
            sv = ShadowValue(sv.data, self.join(sv.control, self.pc()))
        if len(self.frames) == 1:
            clearance = self.case.return_clearance
            if sv is not None and clearance is not None:
                method_name = self.frame.method.extension.name
                if not self._certify(sv, clearance, f"{method_name}:return"):
                    self.frames.pop()
                    return True
        self.frames.pop()
        if self.frames and sv is not None:
            self.frame.stack.append(
                ShadowValue(sv.data, self.join(sv.control, self.pc()))
            )
        return False


def make_monitor(
    bc: jpamb.Bytecode,
    policy: jpamb.security.ClassSecurityPolicy | None,
    methodid: jvm.AbsMethodID,
) -> NoMonitor:
    """A fresh SecurityMonitor for a security case, NoMonitor for an ordinary case."""
    if policy is None:
        return NoMonitor()
    return SecurityMonitor(bc, policy, methodid)

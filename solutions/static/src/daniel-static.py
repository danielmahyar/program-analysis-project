import sys
from collections import deque
from collections.abc import Iterable
from dataclasses import dataclass, field

from abstractions import SignSet

import jpamb
import sexpr
from jpamb import jvm
from jvm.state import PC, StackInt


@dataclass(frozen=True)
class State(sexpr.AsSExpr):
    locals: tuple[SignSet, ...]
    stack: tuple[SignSet, ...]

    def __post_init__(self):
        assert isinstance(self.locals, tuple)
        assert isinstance(self.stack, tuple)

    def __str__(self):
        return f"{', '.join(map(str, self.locals))}/{':'.join(map(str, self.stack))}"

    def __or__(self, other):
        assert isinstance(other, State), f"Expected State but got {other!r}"
        assert len(self.stack) == len(other.stack), "Stacks should be equal lenght"
        assert len(self.locals) == len(other.locals), "Locals should be equal lenght"

        return State(
            tuple(s1 | s2 for s1, s2 in zip(self.locals, other.locals)),
            tuple(s1 | s2 for s1, s2 in zip(self.stack, other.stack)),
        )

    def push(self, value: SignSet):
        assert isinstance(value, SignSet), f"Expected sign set but got {value}"
        return State(self.locals, self.stack + (value,))

    def pop(self, number=1):
        return self.stack[-number:], State(self.locals, self.stack[:-number])

    def load(self, index):
        return self.locals[index]

    def store(self, index, value):
        return State(
            tuple(self.locals[:index]) + (value,) + tuple(self.locals[index + 1 :]),
            self.stack,
        )


def is_array_ref_null(ref: SignSet) -> set[bool]:
    return SignSet.compare(ref, SignSet.from_sign("0"), jvm.CmpOpr.Eq)


def array_access(pc: PC, index: SignSet, after: State):
    """Bounds check for an array access on a non-null array.

    We don't track array lengths, so any index may be past the end (out of
    bounds), and a negative index always is. The access can only succeed if
    the index may be non-negative.
    """
    if True in SignSet.compare(index, SignSet.abstract([StackInt(0)]), jvm.CmpOpr.Ge):
        yield (pc + 1, after)
    yield "out of bounds"


def manystep(
    bc: jpamb.Bytecode,
    pc: PC,
    state: State,
) -> Iterable[tuple[PC, object] | str]:
    opr = bc[pc]
    match opr:
        case jvm.Get(static=True, field=field):
            # Hack - Only handle the assertion case
            assert field.extension.name == "$assertionsDisabled"

            # Hack - Assuming assertions are never disabled
            va = SignSet.abstract([StackInt(0)])

            yield (pc + 1, state.push(va))

        case jvm.Dup():
            (val,), after = state.pop()
            yield (pc + 1, after.push(val).push(val))

        case jvm.Goto(target=target):
            yield (pc % target, state)

        case jvm.Store(type=t, index=i):
            if state.stack.__sizeof__() == 0:
                yield "out of bounds"
            (val,), after = state.pop()
            yield (pc + 1, after.store(i, val))

        case jvm.Cast(from_=f, to_=t):
            match f, t:
                case jvm.Int(), jvm.Boolean():
                    (val,), after = state.pop()
                    yield (pc + 1, after.push(val))
                case jvm.Int(), jvm.Short():
                    (val,), after = state.pop()
                    yield (pc + 1, after.push(val))
                case jvm.Int(), jvm.Char():
                    (val,), after = state.pop()
                    yield (pc + 1, after.push(val))
                case _:
                    yield "unsupported cast"

        case jvm.NewArray(type=t, dim=d):
            if d != 1:
                yield "unsupported array dimension"
            (size,), after = state.pop()
            for res in SignSet.compare(
                size, SignSet.abstract([StackInt(0)]), jvm.CmpOpr.Gt
            ):
                match res:
                    case True:
                        yield (pc + 1, after.push(SignSet.from_sign("+")))
                    case False:
                        if True in SignSet.compare(
                            size, SignSet.abstract([StackInt(0)]), jvm.CmpOpr.Eq
                        ):
                            # An empty array is still a non-null reference.
                            yield (pc + 1, after.push(SignSet.from_sign("+")))
                    case err:
                        yield err

        case jvm.ArrayStore(type=t):
            [arrayref, index, val], after = state.pop(3)

            for n in is_array_ref_null(arrayref):
                match n:
                    case True:
                        yield "null pointer"
                    case False:
                        yield from array_access(pc, index, after)
        case jvm.Push(type=t, value=v):
            match t:
                case jvm.Reference():
                    if not isinstance(v, int):
                        raise TypeError(f"Expected reference but got {v!r}")
                    if v == 0:
                        yield (pc + 1, state.push(SignSet.from_sign("0")))
                    else:
                        yield (pc + 1, state.push(SignSet.from_sign("+")))
                case jvm.Int():
                    if not isinstance(v, int):
                        raise TypeError(f"Expected int but got {v!r}")
                    yield (pc + 1, state.push(SignSet.abstract([StackInt(v)])))
                case _:
                    yield (pc + 1, state)

        case jvm.ArrayLength():
            [arrayref], after = state.pop(1)

            for res in is_array_ref_null(arrayref):
                print(f"Array length check: {res} for {arrayref}", file=sys.stderr)
                match res:
                    case True:
                        yield "null pointer"
                    case False:
                        # The array length is always non-negative, but we don't know the exact length, so we abstract it to 0 or 1.
                        yield (
                            pc + 1,
                            after.push(SignSet.abstract([StackInt(0), StackInt(1)])),
                        )
                    case err:
                        yield err

        case jvm.ArrayLoad(type=t):
            [arrayref, index], after = state.pop(2)

            for n in is_array_ref_null(arrayref):
                match n:
                    case True:
                        yield "null pointer"
                    case False:
                        yield from array_access(
                            pc, index, after.push(SignSet.from_sign("-+0"))
                        )

        case jvm.Incr(index=i, amount=a):
            va = state.load(i)
            res, errors = SignSet.arithmetic(
                va, SignSet.abstract([StackInt(a)]), jvm.BinaryOpr.Add
            )
            yield from errors
            if res.signs:
                yield (pc + 1, state.store(i, res))

        case jvm.Load(type=t, index=i):
            va = state.load(i)
            yield (pc + 1, state.push(va))

        case jvm.If(condition=op, target=target):
            [v1, v2], after = state.pop(2)

            for res in SignSet.compare(v1, v2, op):
                match res:
                    case True:
                        yield (pc % target, after)
                    case False:
                        yield (pc + 1, after)
                    case err:
                        yield err

        case jvm.Ifz(condition=op, target=target):
            [val], after = state.pop(1)

            for res in SignSet.compare(val, SignSet.abstract([StackInt(0)]), op):
                match res:
                    case True:
                        yield (pc % target, after)
                    case False:
                        yield (pc + 1, after)
                    case err:
                        yield err

        case jvm.Negate(type=t):
            [val], after = state.pop(1)
            res, errors = SignSet.arithmetic(
                val, SignSet.abstract([StackInt(-1)]), jvm.BinaryOpr.Mul
            )
            yield from errors
            if res.signs:
                yield (pc + 1, after.push(res))

        case jvm.Binary(operant=op):
            [v1, v2], after = state.pop(2)
            res, errors = SignSet.arithmetic(v1, v2, op)
            yield from errors
            if res.signs:
                yield (pc + 1, after.push(res))

        case jvm.Return(type=None):
            yield "ok"

        case jvm.Return(type=t):
            # Hack -- we assume that we always return.
            yield "ok"

        case jvm.New(classname=jvm.ClassName("java.lang.AssertionError")):
            # Hack -- if we create an assertion error, we probably also throw it.
            yield "assertion error"


def initialstate(
    bc: jpamb.Bytecode,
    methodid: jvm.AbsMethodID,
    inputs: jpamb.Input | None,
) -> dict[PC, State]:
    method = bc.getmethod(methodid)
    locals = [SignSet.bot()] * method.max_locals

    if inputs is None:
        for i, p in enumerate(methodid.extension.params):
            locals[i] = SignSet.top()
    else:
        for i, x in enumerate(inputs.values):
            match x:
                case jpamb.case.Boolean(value=value):
                    locals[i] = SignSet.abstract([StackInt(int(value))])
                case jpamb.case.Int(value=value):
                    locals[i] = SignSet.abstract([StackInt(int(value))])
                case jpamb.case.Array() | jpamb.case.String():
                    locals[i] = SignSet.from_sign("+")
                case _:
                    raise NotImplementedError(f"Unsupported value {x!r}")

    state = State(tuple(locals), ())
    return {PC(methodid, 0): state}


@dataclass
class AbstractInterpreter:
    bc: jpamb.Bytecode
    entry: jvm.AbsMethodID
    worklist: deque[PC]
    states: dict[PC, State]
    # The pcs on the paths leading to each pc. Reaching a pc that is already
    # on its own path means we are in a loop, which might never terminate.
    seen: dict[PC, frozenset[PC]] = field(default_factory=dict)
    # For each analysed callee: the caller's return pc -> the caller's state
    # after popping the arguments.
    callsites: dict[jvm.AbsMethodID, dict[PC, State]] = field(default_factory=dict)
    # For each analysed callee that has returned: the join of its return values.
    returns: dict[jvm.AbsMethodID, SignSet] = field(default_factory=dict)

    @staticmethod
    def initial(bc: jpamb.Bytecode, methodid: jvm.AbsMethodID, inputs):
        states = initialstate(bc, methodid, inputs)
        worklist = deque(states.keys())

        return AbstractInterpreter(bc, methodid, worklist, states)

    def step(self) -> tuple[PC, set[str]]:
        pc = self.worklist.pop()
        state = self.states[pc]

        print(f"Stepping {pc}:\n > {self.bc[pc]}", file=sys.stderr)

        match self.bc[pc]:
            case (
                jvm.InvokeStatic(method=m)
                | jvm.InvokeVirtual(method=m)
                | jvm.InvokeInterface(method=m)
                | jvm.InvokeSpecial(method=m)
            ) as op:
                results = self.invoke(pc, op, m, state)
            case jvm.Return(type=t) if pc.method != self.entry:
                results = self.return_(pc, t, state)
            case _:
                results = manystep(self.bc, pc, state)

        finals = set()
        for res in results:
            if isinstance(res, str):
                finals.add(res)
            else:
                pc_, st = res
                self.propagate(pc, pc_, st, finals)

        return pc, finals

    def propagate(self, pc: PC, pc_: PC, st: State, finals: set[str]):
        path = self.seen.get(pc, frozenset()) | {pc}
        if pc_ in path:
            finals.add("*")

        before = self.states.get(pc_, None)
        after = st if before is None else before | st
        seen_before = self.seen.get(pc_, frozenset())
        seen_after = seen_before | path
        if before is None or after != before or seen_after != seen_before:
            self.states[pc_] = after
            self.seen[pc_] = seen_after
            self.worklist.append(pc_)

    def invoke(self, pc: PC, op, m: jvm.AbsMethodID, state: State):
        nargs = len(m.extension.params)
        if not isinstance(op, jvm.InvokeStatic):
            nargs += 1  # the receiver
        args, after = state.pop(nargs) if nargs > 0 else ((), state)
        ret_pc = pc + 1

        if not self.bc.suite.decompiledfile(m.classname).exists():
            # A library method we can't analyse: assume it can return anything.
            if m.extension.return_type is not None:
                after = after.push(SignSet.top())
            yield (ret_pc, after)
            return

        sites = self.callsites.setdefault(m, {})
        sites[ret_pc] = sites[ret_pc] | after if ret_pc in sites else after

        locals = [SignSet.bot()] * self.bc.getmethod(m).max_locals
        for i, a in enumerate(args):
            locals[i] = a
        yield (PC(m, 0), State(tuple(locals), ()))

        if m in self.returns:
            yield from self.resume(m, ret_pc)

    def return_(self, pc: PC, t, state: State):
        m = pc.method
        if t is None:
            self.returns.setdefault(m, SignSet.bot())
        else:
            (val,), _ = state.pop()
            self.returns[m] = self.returns[m] | val if m in self.returns else val

        for ret_pc in self.callsites.get(m, {}):
            yield from self.resume(m, ret_pc)

    def resume(self, m: jvm.AbsMethodID, ret_pc: PC):
        st = self.callsites[m][ret_pc]
        if m.extension.return_type is not None:
            st = st.push(self.returns[m])
        yield (ret_pc, st)


def interpret():
    """The static analysis"""
    methodid, input, steps = jpamb.getcase(
        "static",
        "1.0",
        "LineaRIZZability",
        ["static", "python"],
        for_science=True,
    )
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})

    ai = AbstractInterpreter.initial(bc, methodid, input)

    x = jpamb.emit_init(ai.states)
    reported = set()

    while steps > 0 and ai.worklist:
        pc, final = ai.step()
        # Each result only needs reporting once, so don't spend steps repeating it.
        for f in final - reported:
            if steps <= 0:
                return
            jpamb.emit_step(x, pc, f, depth=1)
            reported.add(f)
            steps -= 1

        if steps <= 0:
            return
        x = jpamb.emit_step(x, pc, ai.states, depth=1)
        steps -= 1


def analyse():
    """The static analysis"""

    methodid = jpamb.getmethodid(
        "static",
        "1.0",
        "LineaRIZZability",
        ["static", "python"],
        for_science=True,
    )

    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})

    steps = 300

    ai = AbstractInterpreter.initial(bc, methodid, None)

    final = set()
    while steps > 0 and ai.worklist:
        _pc, finals = ai.step()
        final |= finals
        steps -= 1

    for f in jpamb.QUERIES:
        if f not in final:
            print(f"{f};no")
        else:
            print(f"{f};maybe")

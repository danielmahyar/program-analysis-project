#!/usr/bin/env python3
"""Dynamic analysis for JPAMB: a concrete JVM interpreter with shadow security labels,
connected directly to the coverage-guided fuzzer (`coverage_fuzz`, `fuzz_inputs`, `fuzz_contract`).

Run from the repository root:

    uv run jpamb interpret -f Hospital -- uv run python solutions/dynamic/src/dynamic.py
    uv run jpamb analyse -f Hospital -N 1 -- uv run python solutions/dynamic/src/dynamic.py
"""

from __future__ import annotations

import itertools
import os
import random
import sys
import time
from collections.abc import Iterator

import coverage_fuzz
import fuzz_contract
import fuzz_inputs
import jpamb
import jpamb.security
import jvm
import jvm.state as jvmc
import security_monitor

NAME = "dynamic"
VERSION = "2.0"
GROUP = "LineaRIZZability"
TAGS = ["dynamic", "python"]

VERBOSE = bool(os.environ.get("JPAMB_DYNAMIC_VERBOSE"))


def log(msg: str):
    if VERBOSE:
        print(msg, file=sys.stderr)


# -----------------------------------------------------------------------------
# 32-bit integer arithmetic (the JVM wraps around, Python does not)
# -----------------------------------------------------------------------------


def i32(x: int) -> int:
    return fuzz_inputs.signed_int(x)


def binary(op: jvm.BinaryOpr, a: int, b: int) -> int | str:
    match op:
        case jvm.BinaryOpr.Add:
            return i32(a + b)
        case jvm.BinaryOpr.Sub:
            return i32(a - b)
        case jvm.BinaryOpr.Mul:
            return i32(a * b)
        case jvm.BinaryOpr.Div:
            if b == 0:
                return "divide by zero"
            q = abs(a) // abs(b)
            return i32(q if (a < 0) == (b < 0) else -q)
        case jvm.BinaryOpr.Rem:
            if b == 0:
                return "divide by zero"
            r = abs(a) % abs(b)
            return i32(r if a >= 0 else -r)
        case jvm.BinaryOpr.And:
            return i32(a & b)
        case jvm.BinaryOpr.Or:
            return i32(a | b)
        case jvm.BinaryOpr.Xor:
            return i32(a ^ b)
        case jvm.BinaryOpr.Shl:
            return i32(a << (b & 31))
        case jvm.BinaryOpr.Shr:
            return i32(a >> (b & 31))
        case jvm.BinaryOpr.Ushr:
            return i32((a & 0xFFFFFFFF) >> (b & 31))
    raise NotImplementedError(f"Unhandled binary {op!r}")


def compare(op: jvm.CmpOpr, a: int, b: int) -> bool:
    match op:
        case jvm.CmpOpr.Eq:
            return a == b
        case jvm.CmpOpr.Ne:
            return a != b
        case jvm.CmpOpr.Lt:
            return a < b
        case jvm.CmpOpr.Le:
            return a <= b
        case jvm.CmpOpr.Gt:
            return a > b
        case jvm.CmpOpr.Ge:
            return a >= b
    raise NotImplementedError(f"Unhandled comparison {op!r}")


def cast(to: jvm.Type, v: int) -> int:
    match to:
        case jvm.Short():
            v &= 0xFFFF
            return v - 0x10000 if v & 0x8000 else v
        case jvm.Byte():
            v &= 0xFF
            return v - 0x100 if v & 0x80 else v
        case jvm.Char():
            return v & 0xFFFF
        case jvm.Int() | jvm.Boolean():
            return v
    raise NotImplementedError(f"Missing cast to {to}")


def raw(v: jvmc.StackValue) -> int:
    if isinstance(v, (jvmc.StackInt, jvmc.StackReference)):
        return v.value
    raise TypeError(f"Expected int or reference, got {v!r}")


def as_int(v: jvmc.StackValue) -> int:
    if not isinstance(v, jvmc.StackInt):
        raise TypeError(f"Expected int, got {v!r}")
    return v.value


def as_ref(v: jvmc.StackValue) -> jvmc.StackReference:
    if not isinstance(v, jvmc.StackReference):
        raise TypeError(f"Expected reference, got {v!r}")
    return v


# -----------------------------------------------------------------------------
# Small-step semantics: bc |- <η, μ> -> <η', μ'>  (or a final string)
# -----------------------------------------------------------------------------


def step(
    bc: jpamb.Bytecode, state: jvmc.State, mon: security_monitor.NoMonitor
) -> tuple[jvmc.PC, jvmc.State | str]:
    """Execute one instruction. Returns the pc it executed and the new state,
    or a final result: "ok", "assertion error", "divide by zero", ...

    `mon` moves the shadow labels along (`NoMonitor` for ordinary cases).
    """
    frame = state.frames.peek()
    pc = frame.pc
    opr = bc[pc]
    log(f"Stepping {pc}: {opr}")
    mon.at(pc)

    match opr:
        case jvm.Push(type=t, value=v):
            mon.push()
            match t:
                case jvm.Reference():
                    frame.stack.push(jvmc.StackReference(0))
                case jvm.Object(jvm.ClassName("java.lang.String")):
                    frame.stack.push(state.heap.new(jvmc.HeapString(str(v))))
                case _:
                    frame.stack.push(jvmc.StackInt(int(v)))
            frame.pc += 1

        case jvm.Load(index=i):
            mon.load(i)
            frame.stack.push(frame.locals[i])
            frame.pc += 1

        case jvm.Store(index=i):
            mon.store(i)
            frame.locals[i] = frame.stack.pop()
            frame.pc += 1

        case jvm.Incr(index=i, amount=a):
            mon.incr(i)
            frame.locals[i] = jvmc.StackInt(i32(as_int(frame.locals[i]) + a))
            frame.pc += 1

        case jvm.Dup(words=1):
            mon.dup()
            v = frame.stack.pop()
            frame.stack.push(v)
            frame.stack.push(v)
            frame.pc += 1

        case jvm.Pop(words=n):
            mon.pop(n)
            for _ in range(n):
                frame.stack.pop()
            frame.pc += 1

        case jvm.Swap():
            mon.swap()
            b, a = frame.stack.pop(), frame.stack.pop()
            frame.stack.push(b)
            frame.stack.push(a)
            frame.pc += 1

        case jvm.Binary(type=jvm.Int(), operant=op):
            b, a = as_int(frame.stack.pop()), as_int(frame.stack.pop())
            result = binary(op, a, b)
            if isinstance(result, str):
                return pc, result
            mon.op(2)
            frame.stack.push(jvmc.StackInt(result))
            frame.pc += 1

        case jvm.Negate(type=jvm.Int()):
            mon.op(1)
            frame.stack.push(jvmc.StackInt(i32(-as_int(frame.stack.pop()))))
            frame.pc += 1

        case jvm.Cast(to_=to):
            mon.op(1)
            frame.stack.push(jvmc.StackInt(cast(to, as_int(frame.stack.pop()))))
            frame.pc += 1

        case jvm.Ifz(condition=c, target=t):
            mon.branch(pc.offset, 1)
            v = raw(frame.stack.pop())
            frame.pc = pc % t if compare(c, v, 0) else pc + 1

        case jvm.If(condition=c, target=t):
            mon.branch(pc.offset, 2)
            b, a = raw(frame.stack.pop()), raw(frame.stack.pop())
            frame.pc = pc % t if compare(c, a, b) else pc + 1

        case jvm.Goto(target=t):
            frame.pc = pc % t

        case jvm.Get(static=True, field=field) if (
            field.extension.name == "$assertionsDisabled"
        ):
            mon.push()
            frame.stack.push(jvmc.StackInt(0))
            frame.pc += 1

        case jvm.New(classname=jvm.ClassName("java.lang.AssertionError")):
            return pc, "assertion error"

        case jvm.NewArray(type=t, dim=1):
            mon.op(1)
            count = as_int(frame.stack.pop())
            if not 0 <= count <= 10_000:
                raise NotImplementedError(f"unsupported array size {count}")
            frame.stack.push(state.heap.new(jvmc.HeapArray(t, [0] * count)))
            frame.pc += 1

        case jvm.ArrayLength():
            ref = as_ref(frame.stack.pop())
            if ref.value == 0:
                return pc, "null pointer"
            mon.op(1)
            frame.stack.push(jvmc.StackInt(len(array(state, ref).values)))
            frame.pc += 1

        case jvm.ArrayLoad():
            index, ref = as_int(frame.stack.pop()), as_ref(frame.stack.pop())
            if ref.value == 0:
                return pc, "null pointer"
            values = array(state, ref).values
            if not 0 <= index < len(values):
                return pc, "out of bounds"
            mon.op(2)
            frame.stack.push(jvmc.StackInt(values[index]))
            frame.pc += 1

        case jvm.ArrayStore():
            value = as_int(frame.stack.pop())
            index, ref = as_int(frame.stack.pop()), as_ref(frame.stack.pop())
            if ref.value == 0:
                return pc, "null pointer"
            values = array(state, ref).values
            if not 0 <= index < len(values):
                return pc, "out of bounds"
            mon.op(3, produced=0)
            values[index] = value
            frame.pc += 1

        case jvm.InvokeStatic(method=callee):
            nargs = len(callee.extension.params)
            if mon.invoke(callee, nargs, enters=True):
                return pc, "assertion error"
            child = jvmc.Frame.from_method(bc.getmethod(callee))
            for i in reversed(range(nargs)):
                child.locals[i] = frame.stack.pop()
            frame.pc += 1
            state.frames.push(child)

        case jvm.InvokeVirtual(method=callee) if callee.extension.name == "equals":
            argument, receiver = as_ref(frame.stack.pop()), as_ref(frame.stack.pop())
            if receiver.value == 0:
                return pc, "null pointer"
            mon.invoke(callee, 2, enters=False)
            other = state.heap[argument] if argument.value != 0 else None
            equal = isinstance(other, jvmc.HeapString) and (
                state.heap[receiver].content == other.content
            )
            frame.stack.push(jvmc.StackInt(int(equal)))
            frame.pc += 1

        case jvm.Return(type=t):
            if mon.ret(t is not None):
                return pc, "assertion error"
            child = state.frames.pop()
            if not state.frames:
                return pc, "ok"
            if t is not None:
                state.frames.peek().stack.push(child.stack.pop())

        case other:
            raise NotImplementedError(f"Unsupported instruction {other}")

    return pc, state


def array(state: jvmc.State, ref: jvmc.StackReference) -> jvmc.HeapArray:
    arr = state.heap[ref]
    if not isinstance(arr, jvmc.HeapArray):
        raise TypeError(f"Expected an array, got {arr!r}")
    return arr


def initial(bc: jpamb.Bytecode, methodid: jvm.AbsMethodID, input: jpamb.case.Input):
    """The initial state: the inputs in the locals of the first frame."""
    frame = jvmc.Frame.from_method(bc.getmethod(methodid))
    state = jvmc.State(jvmc.Heap(), jvmc.CallStack.from_frames([frame]))
    for slot, v in enumerate(input.values):
        match v:
            case jpamb.case.Boolean(value=b):
                frame.locals[slot] = jvmc.StackInt(int(b))
            case jpamb.case.Int(value=n):
                frame.locals[slot] = jvmc.StackInt(n)
            case jpamb.case.Char(value=c):
                frame.locals[slot] = jvmc.StackInt(ord(c))
            case jpamb.case.Array(contains=jvm.Char(), values=values):
                arr = jvmc.HeapArray(jvm.Char(), [ord(c) for c in values])
                frame.locals[slot] = state.heap.new(arr)
            case jpamb.case.Array(contains=t, values=values):
                frame.locals[slot] = state.heap.new(
                    jvmc.HeapArray(t, [int(x) for x in values])
                )
            case jpamb.case.String(value=s):
                frame.locals[slot] = state.heap.new(jvmc.HeapString(s))
            case other:
                raise NotImplementedError(f"Cannot convert input {other!r}")
    return state


# -----------------------------------------------------------------------------
# Runner adapter for `fuzz_contract.Runner` / `coverage_fuzz.fuzz`
# -----------------------------------------------------------------------------


def make_runner(
    bc: jpamb.Bytecode, policy: jpamb.security.ClassSecurityPolicy | None
):
    """Build a `fuzz_contract.Runner` callable that executes `method_id` on `inputs`
    using the concrete JVM interpreter and `security_monitor.SecurityMonitor`."""

    def run_once(
        method_id: jvm.AbsMethodID,
        inputs: jpamb.case.Input,
        *,
        step_limit: int,
        security_config: object | None = None,
    ) -> fuzz_contract.RunResult:
        if step_limit < 0:
            raise ValueError("step_limit must be non-negative")
        try:
            state = initial(bc, method_id, inputs)
            mon = security_monitor.make_monitor(bc, policy, method_id)
        except (NotImplementedError, TypeError, IndexError) as exc:
            return fuzz_contract.RunResult(
                "unsupported", frozenset(), 0, detail=str(exc)
            )

        coverage: set[jvmc.PC] = set()
        steps = 0
        for _ in range(step_limit):
            current_pc = state.frames.peek().pc
            try:
                pc, nxt = step(bc, state, mon)
            except (NotImplementedError, TypeError, IndexError) as exc:
                return fuzz_contract.RunResult(
                    "unsupported",
                    frozenset(coverage),
                    steps,
                    detail=f"at {current_pc}: {exc}",
                )
            steps += 1
            coverage.add(pc)
            if isinstance(nxt, str):
                return fuzz_contract.RunResult(
                    "completed",
                    frozenset(coverage),
                    steps,
                    outcome=nxt,
                    violations=tuple(mon.violations),
                    detail=mon.last_violation,
                )
            state = nxt

        return fuzz_contract.RunResult("step-limit", frozenset(coverage), steps)

    return run_once


# -----------------------------------------------------------------------------
# Seed & dictionary helpers for `coverage_fuzz.fuzz`
# -----------------------------------------------------------------------------


def collect_constants(
    bc: jpamb.Bytecode, methodid: jvm.AbsMethodID
) -> tuple[list[int], list[str]]:
    """Collect integer and string constants from a method and its static callees."""
    ints: list[int] = []
    strings: list[str] = []
    seen: set[jvm.AbsMethodID] = set()

    def visit(mid: jvm.AbsMethodID):
        if mid in seen:
            return
        seen.add(mid)
        try:
            opcodes = bc.getmethod(mid).opcodes
        except (OSError, KeyError, IndexError, ValueError, NotImplementedError):
            return
        for op in opcodes:
            match op:
                case jvm.Push(type=jvm.Int(), value=int() as v):
                    ints.append(v)
                case jvm.Push(value=str() as s):
                    strings.append(s)
                case jvm.Incr(amount=a):
                    ints.append(a)
                case jvm.InvokeStatic(method=callee) | jvm.InvokeSpecial(method=callee):
                    visit(callee)

    visit(methodid)
    return ints, strings


def build_seeds(
    space: fuzz_inputs.InputSpace, raw_constants: list[int]
) -> list[jpamb.case.Input]:
    """Combine `InputSpace.seeds` with dictionary boundary combinations."""
    ordered_consts = sorted(set(raw_constants), key=abs, reverse=True)
    dict_vals = [
        fuzz_inputs.signed_int(c + d) for c in ordered_consts for d in (1, 0, -1)
    ]
    small_vals = [0, 1, -1, 2, -2, 3, -3, 4, 5, -5, 8, 10, -10, 24, 50, 100, 1024]
    int_pool = list(dict.fromkeys([0, 1, -1] + dict_vals + small_vals))

    columns: list[list[jpamb.case.Value]] = []
    for p in space.parameters:
        if isinstance(p, jvm.Boolean):
            columns.append([jpamb.case.Boolean(False), jpamb.case.Boolean(True)])
        else:
            columns.append([jpamb.case.Int(v) for v in int_pool])

    if not columns:
        return [jpamb.case.Input(())]

    seeds = list(space.seeds())
    seen = set(seeds)
    for k in range(1, max(len(c) for c in columns) + 1):
        prefix = [c[:k] for c in columns]
        if k > 1 and math_prod(len(c) for c in prefix) > 80:
            break
        for combo in itertools.product(*prefix):
            inp = jpamb.case.Input(combo)
            if inp not in seen:
                seen.add(inp)
                seeds.append(inp)
    return seeds


def math_prod(iterable) -> int:
    p = 1
    for x in iterable:
        p *= x
    return p


def fallback_complex_inputs(
    bc: jpamb.Bytecode, methodid: jvm.AbsMethodID
) -> Iterator[jpamb.case.Input]:
    """Fallback generator for String/Array parameters outside InputSpace's int/boolean scope."""
    ints, strings = collect_constants(bc, methodid)
    char_word = "".join(chr(c) for c in ints if 32 < c < 127)
    str_pool = list(dict.fromkeys(strings + ["", "a", char_word]))
    int_pool = list(
        dict.fromkeys([0, 1, -1, 2, 3, 6, 11] + [fuzz_inputs.signed_int(c) for c in ints])
    )
    columns: list[list[jpamb.case.Value]] = []
    for t in methodid.extension.params:
        match t:
            case jvm.Boolean():
                columns.append([jpamb.case.Boolean(False), jpamb.case.Boolean(True)])
            case jvm.Int() | jvm.Short() | jvm.Byte():
                columns.append([jpamb.case.Int(v) for v in int_pool])
            case jvm.Char():
                chars = list(dict.fromkeys(list(char_word) + ["a", "0"]))
                columns.append([jpamb.case.Char(c) for c in chars])
            case jvm.Object(jvm.ClassName("java.lang.String")):
                columns.append([jpamb.case.String(s) for s in str_pool])
            case jvm.Array(contains=jvm.Char()):
                columns.append(
                    [jpamb.case.Array(jvm.Char(), tuple(w)) for w in str_pool]
                )
            case jvm.Array(contains=jvm.Int()):
                arrs = [(), (0,), (1,), (50, 100, 200), tuple(int_pool[:4])]
                columns.append([jpamb.case.Array(jvm.Int(), a) for a in arrs])
            case _:
                raise NotImplementedError(f"Unsupported parameter type {t}")
    rand = random.Random(0)
    for combo in itertools.islice(itertools.product(*columns), 80):
        yield jpamb.case.Input(combo)
    for _ in range(20):
        yield jpamb.case.Input(tuple(rand.choice(c) for c in columns))


# -----------------------------------------------------------------------------
# Entry points
# -----------------------------------------------------------------------------


def interpret():
    """Interpret one case and emit every step (jpamb interpret)."""
    methodid, input, max_steps = jpamb.getcase(
        NAME, VERSION, GROUP, TAGS, for_science=True
    )
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})
    policy = suite.security_policy(methodid.classname, eff=eff)

    state = initial(bc, methodid, input)
    mon = security_monitor.make_monitor(bc, policy, methodid)
    last = jpamb.emit_init(state)

    for _ in range(max_steps):
        try:
            pc, state = step(bc, state, mon)
        except (NotImplementedError, TypeError, IndexError) as e:
            print(f"Interpreter stopped: {e}", file=sys.stderr)
            return
        last = jpamb.emit_step(last, pc, state)
        if isinstance(state, str):
            if mon.last_violation:
                print(mon.last_violation, file=sys.stderr)
            return


def analyse():
    """Predict the outcomes of a method using `coverage_fuzz.fuzz` and `run_once`."""
    methodid = jpamb.getmethodid(NAME, VERSION, GROUP, TAGS, for_science=True)
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})
    policy = suite.security_policy(methodid.classname, eff=eff)
    method = bc.getmethod(methodid)

    max_runs = int(os.environ.get("JPAMB_DYNAMIC_RUNS", "100"))
    max_steps = int(os.environ.get("JPAMB_DYNAMIC_STEPS", "2500"))
    timeout_sec = float(os.environ.get("JPAMB_DYNAMIC_SECONDS", "2.0"))

    base_runner = make_runner(bc, policy)
    outcomes: dict[str, int] = {}
    witnesses: dict[str, tuple[jpamb.case.Input, str | None]] = {}
    covered_offsets: set[int] = set()
    runs = 0

    def tracking_runner(
        mid, inputs, *, step_limit, security_config=None
    ) -> fuzz_contract.RunResult:
        nonlocal runs
        runs += 1
        budget = max_steps if runs <= 25 else min(step_limit, 500)
        res = base_runner(
            mid, inputs, step_limit=budget, security_config=security_config
        )
        for pc in res.coverage:
            if pc.method == methodid:
                covered_offsets.add(pc.offset)
        if res.status == "completed" and res.outcome is not None:
            outcomes[res.outcome] = outcomes.get(res.outcome, 0) + 1
            if res.outcome not in witnesses:
                witnesses[res.outcome] = (inputs, res.detail)
        elif res.status == "step-limit":
            outcomes["*"] = outcomes.get("*", 0) + 1
        return res

    # Use coverage_fuzz.fuzz + InputSpace for int/boolean methods (all Security cases!),
    # falling back only for String/Array methods.
    if all(isinstance(p, (jvm.Int, jvm.Boolean)) for p in methodid.extension.params):
        raw_ints, _ = collect_constants(bc, methodid)
        space = fuzz_inputs.InputSpace(
            tuple(methodid.extension.params),
            fuzz_inputs.interesting_integers(raw_ints),
        )
        seeds = build_seeds(space, raw_ints)
        campaign = coverage_fuzz.fuzz(
            methodid,
            space,
            tracking_runner,
            config=coverage_fuzz.FuzzConfig(
                max_executions=max_runs,
                step_limit=max_steps,
                timeout_seconds=timeout_sec,
                seed=0,
                seed_limit=max(1, len(seeds)),
            ),
            seeds=seeds,
        )
        for finding in campaign.findings:
            log(f"finding: {finding.inputs.encode()} -> {finding.violation}")
    else:
        deadline = time.monotonic() + timeout_sec
        for inp in fallback_complex_inputs(bc, methodid):
            if runs >= max_runs or time.monotonic() > deadline:
                break
            tracking_runner(methodid, inp, step_limit=max_steps)

    total = len(method.opcodes)
    full_coverage = len(covered_offsets) == total
    print(
        f"dynamic: {runs} runs, outcomes {outcomes}, coverage {len(covered_offsets)}/{total}",
        file=sys.stderr,
    )
    for outcome, (w_input, violation) in witnesses.items():
        detail = f" [{violation}]" if violation else ""
        print(f"  witness {w_input.encode()} -> {outcome}{detail}", file=sys.stderr)

    for query in jpamb.QUERIES:
        print(f"{query};{predict(query, outcomes, runs, full_coverage)}")


def predict(query: str, outcomes: dict[str, int], runs: int, full_coverage: bool) -> str:
    """Classify each query into a category; JPAMB computes the optimal wager
    from the empirical hit/miss ratio across the benchmark."""
    if query == "*":
        return "timeout" if outcomes.get("*", 0) == runs and runs > 0 else "not-found"
    if query in outcomes:
        return "found"
    return "covered-not-found" if full_coverage else "not-found"


if __name__ == "__main__":
    if len(sys.argv) == 4 or (len(sys.argv) == 2 and sys.argv[1] == "info"):
        interpret()
    else:
        analyse()

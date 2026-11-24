from pathlib import Path

import pytest
from unbounded_confidentiality.integer import AbstractInt, SignSet
from unbounded_confidentiality.interpreter import AbstractInterpreter, Config, analyze
from unbounded_confidentiality.interval import INT_MAX, INT_MIN, Interval

import jpamb
import jvm


def test_join_and_threshold_widening():
    previous = Interval(2, 4)
    incoming = Interval(1, 6)
    assert previous.join(incoming) == Interval(1, 6)
    assert previous.widen(incoming) == Interval(None, None)
    widened = previous.widen(incoming, (0, 4, 8))
    assert widened == Interval(0, 8)
    assert widened.widen(incoming, (0, 4, 8)) == widened
    assert widened.widen(Interval(0, 9), (0, 4, 8)) == Interval(0, None)


def test_product_widening_preserves_nonzero_until_zero_reaches_the_loop():
    nonzero = SignSet.NEGATIVE | SignSet.POSITIVE
    thresholds = (-10, 0, 10)
    previous = AbstractInt.constant(-2).join(AbstractInt.constant(2))
    assert previous == AbstractInt(Interval(-2, 2), nonzero)
    widened = previous.widen(AbstractInt.constant(3), thresholds)
    assert widened == AbstractInt(Interval(-2, 10), nonzero)
    assert widened.widen(previous, thresholds) == widened
    with_zero = widened.widen(AbstractInt.constant(0), thresholds)
    assert with_zero.interval == widened.interval
    assert with_zero.signs == SignSet.ALL
    assert with_zero.widen(previous, thresholds) == with_zero


def test_product_arithmetic_preserves_sign_holes_and_jvm_wraparound():
    nonzero = SignSet.NEGATIVE | SignSet.POSITIVE
    choice = AbstractInt.constant(-5).join(AbstractInt.constant(5))
    assert choice.negate() == choice
    assert choice.cast("B") == choice
    assert choice.binary(jvm.BinaryOpr.Mul, AbstractInt.constant(2)) == AbstractInt(
        Interval(-10, 10), nonzero
    )
    assert AbstractInt.constant(INT_MAX).add_const(1) == AbstractInt.constant(INT_MIN)
    wrapped = AbstractInt(Interval(INT_MAX - 1, INT_MAX)).add_const(1)
    assert wrapped.interval.minimum <= INT_MIN and wrapped.signs & SignSet.NEGATIVE
    assert wrapped.interval.maximum >= INT_MAX and wrapped.signs & SignSet.POSITIVE
    assert AbstractInt.constant(INT_MIN).negate() == AbstractInt.constant(INT_MIN)
    assert AbstractInt(Interval.top(), nonzero).negate().signs == nonzero
    assert AbstractInt.constant(256).cast("B") == AbstractInt.constant(0)


@pytest.mark.parametrize(
    ("left", "op", "right", "expected"),
    [
        (2**31 - 1, jvm.BinaryOpr.Add, 1, -(2**31)),
        (-(2**31), jvm.BinaryOpr.Div, -1, -(2**31)),
        (-7, jvm.BinaryOpr.Div, 3, -2),
        (-7, jvm.BinaryOpr.Rem, 3, -1),
        (-1, jvm.BinaryOpr.Ushr, 33, 2**31 - 1),
    ],
)
def test_singletons_use_jvm_integer_arithmetic(left, op, right, expected):
    result = Interval.constant(left).binary(op, Interval.constant(right))
    assert result == Interval.constant(expected)


def load(slot):
    return {"opr": "load", "type": "int", "index": slot}


def push(value):
    return {"opr": "push", "value": {"type": "integer", "value": value}}


def compare_zero(condition, target):
    return {"opr": "ifz", "condition": condition, "target": target}


def loop_method():
    root = Path(__file__).resolve().parents[3]
    suite = jpamb.Suite.from_workdir(root)
    eff = jpamb.Effect(None)
    mid = jpamb.parse_methodid("jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V")
    return (
        jpamb.Bytecode(suite, eff),
        mid,
        suite.security_policy(mid.classname, eff=eff),
    )


def check_body(instructions, *, max_steps=None):
    """Reuse the benchmark's (High, Low) parameters and real public sink policy."""
    bc, mid, policy = loop_method()
    sink = jpamb.parse_methodid("jpamb.cases.BasicLeaks.publish:(I)V")
    opcodes = [
        jvm.InvokeStatic(method=sink, offset=i)
        if op == "publish"
        else jvm.Opcode.from_json(dict(op, offset=i))
        for i, op in enumerate(instructions)
    ]
    bc.methods[mid] = jvm.Method(mid, opcodes, 3)
    return analyze(bc, mid, policy, Config(max_steps=max_steps))


RETURN = {"opr": "return", "type": None}


@pytest.mark.parametrize(("limit", "verdict"), [(1, "safe"), (2, "violation")])
def test_nonzero_and_nonnegative_refine_the_lower_bound(limit, verdict):
    # if (x != 0 && x >= 0 && x < limit) publish(secret);
    # With limit=1 the last test is impossible. With limit=2, x=1 reaches the sink.
    result = check_body(
        [
            load(1),
            compare_zero("eq", 9),
            load(1),
            compare_zero("lt", 9),
            load(1),
            push(limit),
            {"opr": "if", "condition": "ge", "target": 9},
            load(0),
            "publish",
            RETURN,
        ]
    )
    state = next(state for pc, state in result.states.items() if pc.offset == 4)
    assert state.load(1).number == AbstractInt(Interval(1, None), SignSet.POSITIVE)
    assert result.status == verdict


def test_stack_merge_remembers_nonzero_through_a_store_and_reload():
    # int x = publicFlag == 0 ? 5 : -5; if (x == 0) publish(secret);
    result = check_body(
        [
            load(1),
            compare_zero("eq", 4),
            push(-5),
            {"opr": "goto", "target": 5},
            push(5),
            {"opr": "store", "type": "int", "index": 2},
            load(2),
            compare_zero("ne", 10),
            load(0),
            "publish",
            RETURN,
        ]
    )
    state = next(state for pc, state in result.states.items() if pc.offset == 5)
    assert state.stack[-1].number == AbstractInt(
        Interval(-5, 5), SignSet.NEGATIVE | SignSet.POSITIVE
    )
    assert all(pc.offset != 9 for pc in result.states)
    assert result.safe


def test_loop_revisits_guard_when_only_the_sign_set_grows():
    # The first visit brings -1 or 1. The back edge brings 0 within those same bounds.
    result = check_body(
        [
            load(1),
            compare_zero("eq", 4),
            push(-1),
            {"opr": "goto", "target": 5},
            push(1),
            {"opr": "store", "type": "int", "index": 2},
            load(2),
            compare_zero("ne", 11),
            load(0),
            "publish",
            RETURN,
            push(0),
            {"opr": "store", "type": "int", "index": 2},
            {"opr": "goto", "target": 6},
        ],
        max_steps=100,
    )
    state = next(state for pc, state in result.states.items() if pc.offset == 6)
    assert state.load(2).number == AbstractInt(Interval(-1, 1), SignSet.ALL)
    assert result.complete and result.status == "violation"


def test_branch_refines_a_reloaded_public_argument():
    # Both ways through the guards bypass publish(secret): x cannot be >= 0 and < 0.
    result = check_body(
        [
            load(1),
            compare_zero("lt", 6),
            load(1),
            compare_zero("ge", 6),
            load(0),
            "publish",
            RETURN,
        ]
    )
    assert result.safe


def test_stale_stack_copy_cannot_refine_a_reassigned_local():
    # Compare the old x after assigning x = 1. An old negative x reaches the sink.
    result = check_body(
        [
            load(1),
            push(1),
            {"opr": "store", "type": "int", "index": 1},
            compare_zero("ge", 8),
            load(1),
            compare_zero("lt", 8),
            load(0),
            "publish",
            RETURN,
        ]
    )
    assert result.status == "violation"


def test_integer_overflow_keeps_a_reachable_sink():
    result = check_body(
        [
            push(2**31 - 1),
            push(1),
            {"opr": "binary", "type": "int", "operant": "add"},
            compare_zero("ge", 6),
            load(0),
            "publish",
            RETURN,
        ]
    )
    assert result.status == "violation"


def test_known_secret_guard_keeps_its_control_dependency():
    # if (secret * 0 == 0) publish(0); the taken path still runs under High.
    result = check_body(
        [
            load(0),
            push(0),
            {"opr": "binary", "type": "int", "operant": "mul"},
            compare_zero("ne", 6),
            push(0),
            "publish",
            RETURN,
        ]
    )
    assert result.status == "violation"
    assert [diagnostic.kind for diagnostic in result.diagnostics] == ["implicit"]


@pytest.mark.parametrize("op", ["div", "rem"])
def test_zero_divisor_has_no_normal_successor(op):
    result = check_body(
        [
            load(0),
            push(0),
            {"opr": "binary", "type": "int", "operant": op},
            "publish",
            RETURN,
        ]
    )
    assert result.safe
    assert all(pc.offset < 3 for pc in result.states)


def test_sink_first_becomes_reachable_after_loop_back_edge():
    # phase starts at zero and is assigned one in the loop body before the back edge.
    analyzer = AbstractInterpreter.initial(*loop_method())
    guard = next(
        i for i, op in enumerate(analyzer.method.opcodes) if isinstance(op, jvm.If)
    )
    sink_edge = guard + 1  # phase == 1 falls through to publish(secret).
    feasible_on_visits = []
    while analyzer.worklist and analyzer.steps < 100:
        pc = analyzer.worklist[0]
        if pc.offset == guard:
            successors, _ = analyzer.transfer(pc, analyzer.states[pc])
            feasible_on_visits.append(any(t.offset == sink_edge for t, _ in successors))
        analyzer.step()
    assert analyzer.result().status == "violation"
    assert feasible_on_visits[0] is False
    assert any(feasible_on_visits[1:])


def test_large_loop_converges_and_refines_its_exit():
    # for (i = 0; i < limit; i++) {} if (i < limit) publish(secret);
    limit = 1_000_000
    result = check_body(
        [
            push(0),
            {"opr": "store", "type": "int", "index": 2},
            load(2),
            push(limit),
            {"opr": "if", "condition": "ge", "target": 7},
            {"opr": "incr", "index": 2, "amount": 1},
            {"opr": "goto", "target": 2},
            load(2),
            push(limit),
            {"opr": "if", "condition": "ge", "target": 12},
            load(0),
            "publish",
            RETURN,
        ],
        max_steps=100,
    )
    assert result.safe
    assert result.steps < 100

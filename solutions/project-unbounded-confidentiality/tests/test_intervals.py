from pathlib import Path

import pytest
from unbounded_confidentiality.interpreter import AbstractInterpreter, Config, analyze
from unbounded_confidentiality.interval import Interval

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

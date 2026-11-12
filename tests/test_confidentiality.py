"""Security transfers use real decoded JVM instructions, without generated classes."""

from dataclasses import replace

import pytest

import jvm
import sexpr
from jpamb.confidentiality import AbstractInterpreter, Config, State, Value, analyze
from jpamb.security import ClassSecurityPolicy, ProductLattice, SecurityLattice
from jvm.state import PC

from .test_security_lattice import _ann, _class, _lattice, _method, _param, _str

LATTICE = _lattice(
    "conf",
    ["Public", "Oncology", "Psych", "HospitalAdmin"],
    [
        "Public <= Oncology",
        "Public <= Psych",
        "Oncology <= HospitalAdmin",
        "Psych <= HospitalAdmin",
    ],
    "Public",
)


class Bytecode:
    def __init__(self, methods):
        self.methods = methods

    def getmethod(self, methodid):
        return self.methods[methodid]

    def __getitem__(self, pc):
        return self.methods[pc.method].opcodes[pc.offset]


def push(value=0):
    return {"opr": "push", "value": {"type": "integer", "value": value}}


def load(slot):
    return {"opr": "load", "type": "int", "index": slot}


def store(slot):
    return {"opr": "store", "type": "int", "index": slot}


def branch(target, condition="eq", opr="ifz"):
    return {"opr": opr, "condition": condition, "target": target}


def goto(target):
    return {"opr": "goto", "target": target}


RETURN = {"opr": "return", "type": "int"}
VOID = {"opr": "return", "type": None}


def program(
    ops,
    labels=("Oncology",),
    *,
    returns=True,
    clearance=None,
    max_locals=4,
    constraints=True,
    default="Public",
    extra_methods=(),
):
    params = [
        _param("int", *([_ann("Sec", conf=_str(label))] if label else []))
        for label in labels
    ]
    main = _method(
        "main", params, *([_ann("Sec", conf=_str(clearance))] if clearance else [])
    )
    main["returns"]["type"] = {"base": "int"} if returns else None
    main["code"] = {
        "max_locals": max_locals,
        "exceptions": [],
        "bytecode": [dict(op, offset=i) for i, op in enumerate(ops)],
    }
    lattice = dict(LATTICE, values=dict(LATTICE["values"], defaultLevel=_str(default)))
    policy = ClassSecurityPolicy.from_json(_class([lattice], [main, *extra_methods]))
    methodid = jvm.AbsMethodID.decode(
        f"{policy.classname}.main:({'I' * len(labels)}){'I' if returns else 'V'}"
    )
    if not constraints:
        policy = replace(
            policy,
            methods={
                **policy.methods,
                policy.method(methodid).id: replace(
                    policy.method(methodid), param_constraints=()
                ),
            },
        )
    methods = {methodid: jvm.Method.from_json(methodid, main)}
    for mj in extra_methods:
        declared = next(m for m in policy.methods.values() if m.name == mj["name"])
        mid = jvm.AbsMethodID.decode(f"{policy.classname}.{declared.id}")
        methods[mid] = jvm.Method.from_json(mid, mj)
    return Bytecode(methods), methodid, policy


def run(ops, labels=("Oncology",), config=None, **kwargs):
    bc, mid, policy = program(ops, labels, **kwargs)
    return analyze(bc, mid, policy, config)


@pytest.mark.parametrize(
    "operator",
    ["add", "sub", "mul", "div", "rem", "and", "or", "xor", "shl", "shr", "ushr"],
)
@pytest.mark.parametrize("reverse", [False, True])
def test_binary_dependencies(operator, reverse):
    operands = [push(1), load(0)] if reverse else [load(0), push(1)]
    op = {
        "opr": "bitopr"
        if operator in ("and", "or", "xor", "shl", "shr", "ushr")
        else "binary",
        "type": "int",
        "operant": operator,
    }
    result = run([*operands, op, RETURN])
    assert result.status == "violation"
    assert result.return_label == "Oncology"
    assert result.diagnostics[0].kind == "explicit"


@pytest.mark.parametrize(
    "op",
    [
        {"opr": "negate", "type": "int"},
        {"opr": "cast", "from": "int", "to": "byte"},
        {"opr": "cast", "from": "int", "to": "short"},
        {"opr": "cast", "from": "int", "to": "char"},
    ],
)
def test_unary_dependencies(op):
    assert run([load(0), op, RETURN]).return_label == "Oncology"


def test_unannotated_temporaries_and_compartments():
    result = run(
        [
            load(0),
            load(1),
            {"opr": "binary", "type": "int", "operant": "add"},
            store(2),
            load(2),
            RETURN,
        ],
        labels=("Oncology", "Psych"),
        clearance="HospitalAdmin",
    )
    assert result.safe
    assert result.return_label == "HospitalAdmin"
    assert (
        result.states[PC(next(iter(result.states)).method, 4)].locals[2].data
        == "HospitalAdmin"
    )
    forbidden = run([load(0), RETURN], labels=("Psych",), clearance="Oncology")
    assert forbidden.status == "violation"


def test_strong_public_overwrite_is_safe():
    result = run([load(0), store(1), push(42), store(1), load(1), RETURN])
    assert result.safe
    assert result.return_label == "Public"


def test_fixed_local_and_parameter_constraints():
    result = run(
        [load(0), store(1), push(), RETURN],
        config=Config(local_clearances={1: "Public"}),
    )
    assert result.status == "violation"
    assert result.diagnostics[0].offset == 1
    # An explicitly Public parameter stays a Public destination on reassignment.
    result = run([load(1), store(0), push(), RETURN], labels=("Public", "Oncology"))
    assert result.status == "violation"
    assert result.diagnostics[0].message.startswith("local 0:")


def test_unannotated_parameter_is_fixed_public():
    # void main(int a, @Sec(conf = "Oncology") int b) { a = b; }
    result = run(
        [load(1), store(0), {"opr": "return", "type": None}],
        labels=(None, "Oncology"),
        returns=False,
    )
    assert result.status == "violation"
    assert result.diagnostics[0].message.startswith("local 0:")


def test_parameter_keeps_its_fixed_label_after_a_write():
    # @Sec(conf = "Public") int main(@Sec(conf = "Oncology") int p) { p = 0; return p; }
    # Certification of p = 0 passes, but p is never inferred: it stays {Oncology}.
    result = run([push(), store(0), load(0), RETURN], clearance="Public")
    assert result.status == "violation"
    assert result.diagnostics[0].offset == 3


def test_configured_input_and_output_defaults():
    assert run([load(0), RETURN], labels=(None,)).safe
    assert (
        run([load(0), RETURN], labels=(None,), default="Oncology").status == "violation"
    )
    assert run([load(0), RETURN], config=Config(return_clearance="Oncology")).safe
    # A configurable default must never relax an explicit declaration.
    assert (
        run(
            [load(0), RETURN],
            clearance="Public",
            config=Config(return_clearance="HospitalAdmin"),
        ).status
        == "violation"
    )


def test_uninitialized_is_not_public_or_unreachable():
    result = run([load(1), RETURN])
    assert result.status == "unsupported"
    assert "not definitely initialized" in result.diagnostics[0].message
    initial = next(iter(result.states.values()))
    assert initial.locals[1] is None
    assert len(result.states) == 1  # Unvisited CFG states are absent.


def test_security_state_join_rejects_stack_shape_mismatch():
    lattice = SecurityLattice("conf", ("L", "H"), (("L", "H"),), "L")
    with pytest.raises(ValueError, match="shapes"):
        State((None,), ()).join(State((None,), (Value("L", "L"),)), lattice)
    assert State((None,)).join(State((Value("H", "L"),)), lattice).locals == (None,)


@pytest.mark.parametrize("words", [1, 2])
def test_dup_and_pop_preserve_exact_stack_order(words):
    ops = [load(0)] if words == 1 else [load(0), load(1)]
    ops += [{"opr": "dup", "words": words}, {"opr": "pop", "words": words}]
    if words == 2:
        ops += [{"opr": "swap"}, {"opr": "pop", "words": 1}]
    expected = "Oncology" if words == 1 else "Psych"
    result = run([*ops, RETURN], labels=("Oncology", "Psych"), clearance=expected)
    assert result.safe
    assert result.return_label == expected


def test_dup_assignment_cannot_drop_secret():
    result = run([load(0), {"opr": "dup", "words": 1}, store(1), RETURN])
    assert result.status == "violation"


def sink(name="publish", label="Public", body=None):
    method = _method(name, [_param("int", _ann("Sec", conf=_str(label)))])
    method["code"] = {
        "max_locals": 1,
        "bytecode": [dict(op, offset=i) for i, op in enumerate(body or [VOID])],
    }
    return method


def invoke(name="publish", owner="jpamb/cases/Fake"):
    return {
        "opr": "invoke",
        "access": "static",
        "method": {
            "ref": {"kind": "class", "name": owner},
            "name": name,
            "args": ["int"],
            "returns": None,
        },
    }


def test_fixed_sink_boundary_and_confidentiality_only():
    result = run([load(0), invoke(), VOID], returns=False, extra_methods=[sink()])
    assert result.status == "violation"
    assert "argument 0" in result.diagnostics[0].message
    bc, mid, policy = program([load(0), RETURN], labels=("Public",))
    integ = SecurityLattice(
        "integ", ("Trusted", "Untrusted"), (("Trusted", "Untrusted"),), "Untrusted"
    )
    product = ProductLattice({**policy.product_lattice.lattices, "integ": integ})
    declared = replace(
        policy.method(mid),
        param_labels=(product.make_label(conf="Public", integ="Untrusted"),),
        param_constraints=(product.make_label(conf="Public", integ="Untrusted"),),
        return_clearance=product.make_label(conf="Public", integ="Trusted"),
    )
    policy = replace(policy, product_lattice=product, methods={declared.id: declared})
    assert analyze(bc, mid, policy).safe


@pytest.mark.parametrize(
    "op",
    [
        {"opr": "new", "class": "java/lang/AssertionError"},
        {"opr": "newarray", "type": "int", "dim": 1},
        {"opr": "throw"},
        invoke("external", "Unknown"),
    ],
)
def test_unsupported_is_never_safe(op):
    result = run([push(), op, VOID], returns=False)
    assert result.status == "unsupported"
    assert not result.safe and not result.complete
    assert any(d.kind == "unsupported" for d in result.diagnostics)


def test_sink_annotation_is_not_an_arbitrary_call_summary():
    result = run(
        [push(), invoke(), VOID],
        returns=False,
        extra_methods=[sink(body=[push(), store(0), VOID])],
    )
    assert result.status == "unsupported"
    assert "unsummarized effects" in result.diagnostics[0].message


def test_resource_limit_is_incomplete():
    result = run([load(0), RETURN], config=Config(max_steps=1))
    assert result.status == "incomplete"
    assert not result.safe and not result.complete
    assert any(d.kind == "incomplete" for d in result.diagnostics)


def test_engine_initializes_existing_worklist_shape():
    bc, mid, policy = program([push(), RETURN])
    interpreter = AbstractInterpreter.initial(bc, mid, policy)
    assert list(interpreter.worklist) == [PC(mid, 0)]
    assert interpreter.run().safe


def test_skipped_assignment_is_joined_and_pc_is_restored():
    prefix = [push(), store(1), load(0), branch(6), push(1), store(1)]
    leak = run([*prefix, load(1), RETURN])
    assert leak.status == "violation"
    assert leak.return_label == "Oncology"
    assert leak.diagnostics[0].kind == "implicit"
    at_merge = next(s for pc, s in leak.states.items() if pc.offset == 6)
    assert at_merge.context == ()
    assert at_merge.locals[1].control == "Oncology"
    assert run([*prefix, push(42), RETURN]).safe


def test_nested_conditions_join_incomparable_contexts():
    ops = [
        push(),
        store(2),
        load(0),
        branch(11),
        load(1),
        branch(9),
        push(1),
        store(2),
        goto(11),
        push(2),
        store(2),
        load(2),
        RETURN,
    ]
    result = run(ops, labels=("Oncology", "Psych"))
    assert result.return_label == "HospitalAdmin"
    assert result.status == "violation"
    assert all(d.kind == "implicit" for d in result.diagnostics)


@pytest.mark.parametrize("condition", ["eq", "ne", "lt", "le", "gt", "ge"])
@pytest.mark.parametrize("two_operands", [False, True])
def test_comparison_and_boolean_choice_keep_condition_label(condition, two_operands):
    operands = [load(0), load(1)] if two_operands else [load(0)]
    i = len(operands)
    result = run(
        [
            *operands,
            branch(i + 3, condition, "if" if two_operands else "ifz"),
            push(1),
            goto(i + 4),
            push(),
            RETURN,
        ],
        labels=("Oncology", "Psych"),
    )
    assert result.status == "violation"
    assert result.return_label == ("HospitalAdmin" if two_operands else "Oncology")
    assert result.diagnostics[0].kind == "implicit"


def test_short_circuit_boolean_joins_both_conditions():
    # a && b: either branch can select the false constant on the stack.
    result = run(
        [load(0), branch(6), load(1), branch(6), push(1), goto(7), push(), RETURN],
        labels=("Oncology", "Psych"),
    )
    assert result.return_label == "HospitalAdmin"
    assert result.status == "violation"


def test_secret_controlled_sink_call_is_observable():
    result = run(
        [load(0), branch(4), push(), invoke(), VOID],
        returns=False,
        extra_methods=[sink()],
    )
    assert result.status == "violation"
    assert result.diagnostics[0].kind == "implicit"


def test_fixed_assignment_in_secret_branch_and_compound_increment():
    result = run(
        [
            push(),
            store(1),
            load(0),
            branch(5),
            {"opr": "incr", "index": 1, "amount": 1},
            push(),
            RETURN,
        ],
        config=Config(local_clearances={1: "Public"}),
    )
    assert result.status == "violation"
    assert result.diagnostics[0].offset == 4
    assert result.diagnostics[0].kind == "implicit"


def test_secret_loop_converges_and_keeps_zero_iteration_state():
    ops = [
        push(),
        store(1),
        load(0),
        branch(7),
        {"opr": "incr", "index": 1, "amount": 1},
        {"opr": "incr", "index": 0, "amount": -1},
        goto(2),
        load(1),
        RETURN,
    ]
    result = run(ops)
    assert result.status == "violation"
    assert result.return_label == "Oncology"
    assert result.steps < 60
    assert run([*ops[:7], push(42), RETURN]).safe


def test_loop_condition_is_reevaluated_after_backedge():
    ops = [
        push(),
        store(2),
        push(),
        store(3),
        load(2),
        branch(11),
        load(0),
        store(2),
        push(1),
        store(3),
        goto(4),
        load(3),
        RETURN,
    ]
    result = run(ops)
    assert result.status == "violation"
    assert result.return_label == "Oncology"
    assert result.steps < 100


def test_skipped_initialization_is_unknown():
    result = run([load(0), branch(4), push(1), store(1), load(1), RETURN])
    assert result.status == "unsupported"
    assert any("not definitely initialized" in d.message for d in result.diagnostics)


def test_one_unsupported_path_overrides_normal_returns():
    result = run(
        [
            load(0),
            branch(5),
            push(),
            {"opr": "newarray", "type": "int", "dim": 1},
            {"opr": "pop", "words": 1},
            push(),
            RETURN,
        ]
    )
    assert result.status == "unsupported"
    assert not result.safe


def test_no_hidden_300_step_limit_and_nonterminating_cycle_converges():
    result = run(
        [op for _ in range(200) for op in (push(), {"opr": "pop", "words": 1})]
        + [push(), RETURN]
    )
    assert result.safe
    assert result.steps == 402
    assert run(
        [goto(0)], returns=False
    ).safe  # No value observation; termination is out of scope.


def test_multiple_returns_keep_secret_context():
    result = run([load(0), branch(4), push(1), RETURN, push(), RETURN])
    assert result.status == "violation"
    assert {d.offset for d in result.diagnostics} == {3, 5}


def test_invalid_merge_and_cfg_are_unknown():
    assert (
        run([load(0), branch(4), push(1), goto(4), push(), RETURN]).status
        == "unsupported"
    )
    assert run([goto(2)], returns=False).status == "unsupported"


def test_secret_stack_selection_cannot_escape_at_postdominator():
    # Both constants predate the condition. Only their stack order is selected.
    result = run(
        [
            push(),
            push(1),
            load(0),
            branch(5),
            {"opr": "swap"},
            {"opr": "pop", "words": 1},
            RETURN,
        ]
    )
    assert result.status == "violation"
    assert result.return_label == "Oncology"
    assert result.diagnostics[0].kind == "implicit"


@pytest.mark.parametrize(
    "operator",
    ["add", "sub", "mul", "div", "rem", "and", "or", "xor", "shl", "shr", "ushr"],
)
def test_public_only_operations_remain_public(operator):
    result = run(
        [
            load(0),
            push(1),
            {"opr": "binary", "type": "int", "operant": operator},
            RETURN,
        ],
        labels=("Public",),
    )
    assert result.safe
    assert result.return_label == "Public"


@pytest.mark.parametrize(
    "op",
    [
        {
            "opr": "get",
            "static": True,
            "field": {"class": "Fake", "name": "external", "type": "int"},
        },
        {"opr": "array_load", "type": "int"},
        {"opr": "array_store", "type": "int"},
        dict(invoke(), access="virtual"),
        {"opr": "push", "value": None},
    ],
)
def test_heap_references_and_virtual_calls_are_unknown(op):
    assert run([op, VOID], returns=False).status == "unsupported"


def test_incomplete_analysis_retains_known_violation():
    result = run(
        [load(0), store(1), push(), RETURN],
        config=Config(local_clearances={1: "Public"}, max_steps=2),
    )
    assert result.status == "incomplete"
    assert any(d.kind == "explicit" for d in result.diagnostics)
    assert not result.safe


def test_nested_loops_converge_with_both_contexts():
    result = run(
        [
            push(),
            store(2),
            load(0),
            branch(11),
            load(1),
            branch(9),
            {"opr": "incr", "index": 2, "amount": 1},
            {"opr": "incr", "index": 1, "amount": -1},
            goto(4),
            {"opr": "incr", "index": 0, "amount": -1},
            goto(2),
            load(2),
            RETURN,
        ],
        labels=("Oncology", "Psych"),
    )
    assert result.status == "violation"
    assert result.return_label == "HospitalAdmin"
    assert result.steps < 200


@pytest.mark.parametrize(
    "feature",
    ["exception handlers", "synchronized method", "local/type @Sec annotations"],
)
def test_unsupported_method_metadata_never_reports_safe(feature):
    bc, mid, policy = program([push(), RETURN])
    declared = replace(policy.method(mid), unsupported_features=(feature,))
    policy = replace(policy, methods={declared.id: declared})
    result = analyze(bc, mid, policy)
    assert result.status == "unsupported"
    assert feature in result.diagnostics[0].message


@pytest.mark.parametrize(
    "instruction",
    [
        {"opr": "bitopr", "type": "int", "operant": "ushr"},
        {"opr": "cast", "from": "int", "to": "byte"},
        {"opr": "cast", "from": "int", "to": "char"},
        {"opr": "cast", "from": "int", "to": "short"},
        {"opr": "dup", "words": 2},
        {"opr": "pop", "words": 1},
        {"opr": "pop", "words": 2},
        {"opr": "swap"},
    ],
)
def test_extended_opcodes_roundtrip_and_have_jvm_names(instruction):
    op = jvm.Opcode.from_json(dict(instruction, offset=0))
    assert op.real()
    assert jvm.Opcode.from_sexpr(sexpr.sexpr(op)) == op

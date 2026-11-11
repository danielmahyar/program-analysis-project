from itertools import product

import pytest

import jpamb
import jvm
from jpamb.security import (
    ClassSecurityPolicy,
    ProductLattice,
    SecurityLabel,
    SecurityLattice,
)

suite, eff = jpamb.setup()

SECURITY_CLASSES = ["Clearance", "Compartments", "Hospital", "InfoFlow"]


def policy_of(name: str) -> ClassSecurityPolicy:
    policy = suite.security_policy(jvm.ClassName(f"jpamb.cases.{name}"), eff=eff)
    assert policy is not None, f"{name} should declare a lattice"
    return policy


def test_single_lattice_construction_and_closure():
    # Diamond lattice: Public <= Oncology, Public <= Psych, Oncology <= Admin, Psych <= Admin
    lat = SecurityLattice(
        dim="conf",
        levels=("Public", "Oncology", "Psych", "HospitalAdmin"),
        order_edges=(
            ("Public", "Oncology"),
            ("Public", "Psych"),
            ("Oncology", "HospitalAdmin"),
            ("Psych", "HospitalAdmin"),
        ),
        default_level="Public",
    )

    assert lat.dim == "conf"
    assert lat.bot == "Public"
    assert lat.top == "HospitalAdmin"

    # Reflexivity
    for lvl in lat.levels:
        assert lat.le(lvl, lvl)

    # Transitivity
    assert lat.le("Public", "HospitalAdmin")

    # Incomparability
    assert not lat.le("Oncology", "Psych")
    assert not lat.le("Psych", "Oncology")

    # Join (Least Upper Bound)
    assert lat.join("Oncology", "Psych") == "HospitalAdmin"
    assert lat.join("Public", "Oncology") == "Oncology"
    assert lat.join("HospitalAdmin", "Psych") == "HospitalAdmin"

    # Meet (Greatest Lower Bound)
    assert lat.meet("Oncology", "Psych") == "Public"
    assert lat.meet("HospitalAdmin", "Psych") == "Psych"


def test_lattice_algebraic_laws():
    # Test all formal lattice identities on the Hospital lattice
    lat = SecurityLattice(
        dim="conf",
        levels=("Public", "Oncology", "Psych", "HospitalAdmin"),
        order_edges=(
            ("Public", "Oncology"),
            ("Public", "Psych"),
            ("Oncology", "HospitalAdmin"),
            ("Psych", "HospitalAdmin"),
        ),
        default_level="Public",
    )

    for x in lat.levels:
        # Idempotence: x ⊔ x = x, x ⊓ x = x
        assert lat.join(x, x) == x
        assert lat.meet(x, x) == x

        # Identities with Top & Bottom
        assert lat.join(x, lat.bot) == x
        assert lat.meet(x, lat.top) == x
        assert lat.join(x, lat.top) == lat.top
        assert lat.meet(x, lat.bot) == lat.bot

        for y in lat.levels:
            # Commutativity: x ⊔ y = y ⊔ x, x ⊓ y = y ⊓ x
            assert lat.join(x, y) == lat.join(y, x)
            assert lat.meet(x, y) == lat.meet(y, x)

            # Absorption: x ⊔ (x ⊓ y) = x, x ⊓ (x ⊔ y) = x
            assert lat.join(x, lat.meet(x, y)) == x
            assert lat.meet(x, lat.join(x, y)) == x

            # Order equivalence: x <= y <=> x ⊔ y = y <=> x ⊓ y = x
            if lat.le(x, y):
                assert lat.join(x, y) == y
                assert lat.meet(x, y) == x
            else:
                assert lat.join(x, y) != y or x == y


def test_integrity_lattice():
    # Integrity: Trusted <= Untrusted (Trusted flows to Untrusted, untrusted cannot flow to trusted)
    integ = SecurityLattice(
        dim="integ",
        levels=("Trusted", "Untrusted"),
        order_edges=(("Trusted", "Untrusted"),),
        default_level="Untrusted",
    )

    assert integ.bot == "Trusted"
    assert integ.top == "Untrusted"
    assert integ.le("Trusted", "Untrusted")
    assert not integ.le("Untrusted", "Trusted")
    assert integ.join("Trusted", "Untrusted") == "Untrusted"
    assert integ.meet("Trusted", "Untrusted") == "Trusted"


def test_product_lattice():
    conf = SecurityLattice(
        dim="conf",
        levels=("Public", "Oncology", "Psych", "HospitalAdmin"),
        order_edges=(
            ("Public", "Oncology"),
            ("Public", "Psych"),
            ("Oncology", "HospitalAdmin"),
            ("Psych", "HospitalAdmin"),
        ),
        default_level="Public",
    )
    integ = SecurityLattice(
        dim="integ",
        levels=("Trusted", "Untrusted"),
        order_edges=(("Trusted", "Untrusted"),),
        default_level="Untrusted",
    )

    prod = ProductLattice({"conf": conf, "integ": integ})

    l_onco_trusted = prod.make_label(conf="Oncology", integ="Trusted")
    l_psych_untrusted = prod.make_label(conf="Psych", integ="Untrusted")
    l_pub_trusted = prod.make_label(conf="Public", integ="Trusted")
    l_pub_untrusted = prod.make_label(conf="Public", integ="Untrusted")

    # (Public, Trusted) <= (Public, Untrusted)
    assert prod.le(l_pub_trusted, l_pub_untrusted)

    # (Oncology, Trusted) ⋢ (Public, Untrusted) because Oncology ⋢ Public
    assert not prod.le(l_onco_trusted, l_pub_untrusted)

    # (Psych, Untrusted) ⋢ (Oncology, Untrusted) because Psych ⋢ Oncology
    assert not prod.le(l_psych_untrusted, l_onco_trusted)

    # Join of Oncology and Psych becomes HospitalAdmin; Trusted and Untrusted becomes Untrusted
    j = prod.join(l_onco_trusted, l_psych_untrusted)
    assert j["conf"] == "HospitalAdmin"
    assert j["integ"] == "Untrusted"


def test_parse_hospital():
    policy = policy_of("Hospital")

    assert "conf" in policy.product_lattice.lattices
    assert "integ" in policy.product_lattice.lattices

    conf_lat = policy.product_lattice.lattices["conf"]
    assert set(conf_lat.levels) == {"Public", "Oncology", "Psych", "HospitalAdmin"}
    assert conf_lat.bot == "Public"
    assert conf_lat.top == "HospitalAdmin"

    # Verify process method parameters from Listing 1
    # public static void process(@Sec(conf = "Oncology", integ = "Trusted") int onco,
    #                            @Sec(conf = "Psych", integ = "Untrusted") int psych)
    process_m = policy.get_method("process")
    assert process_m is not None
    assert len(process_m.param_labels) == 2

    onco_lbl = process_m.param_labels[0]
    psych_lbl = process_m.param_labels[1]

    assert onco_lbl["conf"] == "Oncology"
    assert onco_lbl["integ"] == "Trusted"

    assert psych_lbl["conf"] == "Psych"
    assert psych_lbl["integ"] == "Untrusted"

    # Verify tags
    assert "EXPLICIT_FLOW" in process_m.tags
    assert "CONDITIONAL" in process_m.tags

    # Verify sink method: publicDashboard(@Sec(conf = "Public") int value)
    pub_dash = policy.get_method("publicDashboard")
    assert pub_dash is not None
    assert len(pub_dash.param_labels) == 1
    assert pub_dash.param_labels[0]["conf"] == "Public"
    # missing integ dimension automatically gets defaultLevel "Untrusted"
    assert pub_dash.param_labels[0]["integ"] == "Untrusted"

    # Verify return clearance on publicRiskScore
    prs = policy.get_method("publicRiskScore")
    assert prs is not None
    assert prs.return_clearance is not None
    assert prs.return_clearance["conf"] == "Public"


def test_lookup_by_jpamb_method_ids():
    policy = policy_of("Hospital")

    # The method id an analysis receives from JPAMB
    process = policy.method(
        jvm.AbsMethodID.decode("jpamb.cases.Hospital.process:(II)V")
    )
    assert process.is_case and not process.is_sink and process.is_static
    assert process.param_slots == (0, 1)
    assert ("(6000, 1)", "assertion error") in process.cases

    # The method of an invoke instruction: sinks give their clearances, others None
    sink = policy.sink(
        jvm.AbsMethodID.decode("jpamb.cases.Hospital.publicDashboard:(I)V")
    )
    assert sink is not None and sink.is_static
    assert sink.param_labels == (policy.product_lattice.make_label(conf="Public"),)
    assert (
        policy.sink(jvm.AbsMethodID.decode("jpamb.cases.Hospital.process:(II)V"))
        is None
    )
    assert (
        policy.sink(jvm.AbsMethodID.decode("jpamb.cases.Simple.assertFalse:()V"))
        is None
    )

    assert set(policy.sinks) == {
        "publicDashboard:(I)V",
        "oncologyRecords:(I)V",
        "adminReport:(I)V",
        "auditLog:(I)V",
        "billing:(Z)V",
    }

    with pytest.raises(KeyError):
        policy.method("noSuchMethod:()V")


def test_parse_infoflow():
    policy = policy_of("InfoFlow")
    assert "conf" in policy.product_lattice.lattices
    assert "integ" in policy.product_lattice.lattices

    conf_lat = policy.product_lattice.lattices["conf"]
    assert conf_lat.bot == "Low"
    assert conf_lat.top == "High"

    integ_lat = policy.product_lattice.lattices["integ"]
    assert integ_lat.bot == "Trusted"
    assert integ_lat.top == "Untrusted"

    # explicitLeak(@Sec(conf = "High") int secret)
    leak_m = policy.get_method("explicitLeak")
    assert leak_m is not None
    assert leak_m.param_labels[0]["conf"] == "High"
    assert leak_m.param_labels[0]["integ"] == "Untrusted"

    # unannotatedInput(int input) gets default level in every dimension: (Low, Untrusted)
    unann = policy.get_method("unannotatedInput")
    assert unann is not None
    assert unann.param_labels[0]["conf"] == "Low"
    assert unann.param_labels[0]["integ"] == "Untrusted"


def test_parse_clearance_and_compartments():
    policy = policy_of("Clearance")
    conf_lat = policy.product_lattice.lattices["conf"]
    assert conf_lat.bot == "Unclassified"
    assert conf_lat.top == "TopSecret"
    assert conf_lat.le("Restricted", "Secret")  # Transitive closure
    assert policy.product_lattice.lattices["integ"].levels == (
        "Trusted",
        "Partner",
        "Untrusted",
    )

    policy = policy_of("Compartments")
    conf_lat = policy.product_lattice.lattices["conf"]
    assert len(conf_lat.levels) == 8
    assert conf_lat.join("Alpha", "Bravo") == "AlphaBravo"
    assert conf_lat.join("AlphaBravo", "Charlie") == "All"


def test_case_classes_without_lattice_have_no_policy():
    for name in ["Simple", "Calls", "Arrays", "InformationFlow"]:
        assert (
            suite.security_policy(jvm.ClassName(f"jpamb.cases.{name}"), eff=eff) is None
        )


@pytest.mark.parametrize("name", SECURITY_CLASSES)
def test_policy_cases_are_served_by_jpamb(name):
    """Every @Case of a security class is a JPAMB case and is in the benchmark."""
    policy = policy_of(name)
    from_policy = {
        (f"{policy.classname}.{m.id}", inp, out)
        for m in policy.case_methods.values()
        for inp, out in m.cases
    }
    served = {
        (
            f"{c.methodid.classname}.{c.methodid.extension.encode()}",
            c.input.encode(),
            c.result,
        )
        for c in suite.cases(eff=eff)
        if str(c.methodid.classname) == policy.classname
    }
    assert from_policy == served

    benchmark = suite.benchmark(eff=eff)
    for case in suite.cases(eff=eff):
        if str(case.methodid.classname) == policy.classname:
            assert benchmark.experiments[case.experiment].results == {case.result}


# Hand-written classes in the decompiled (jvm2json) format


def _str(v):
    return {"type": "string", "value": v}


def _ann(type, **values):
    return {"type": f"jpamb/utils/{type}", "is_runtime_visible": True, "values": values}


def _lattice(dim, levels, order, default):
    return _ann(
        "Lattice",
        dim=_str(dim),
        levels={"type": "array", "value": [_str(x) for x in levels]},
        order={"type": "array", "value": [_str(x) for x in order]},
        defaultLevel=_str(default),
    )


def _param(base, *annotations):
    return {
        "visible": True,
        "type": {"base": base, "annotations": []},
        "annotations": list(annotations),
    }


def _method(name, params, *annotations, access=("public", "static")):
    return {
        "name": name,
        "access": list(access),
        "annotations": list(annotations),
        "params": params,
        "returns": {"type": None, "annotations": []},
    }


def _class(annotations, methods):
    return {"name": "jpamb/cases/Fake", "annotations": annotations, "methods": methods}


LOW_HIGH = _lattice("conf", ["Low", "High"], ["Low <= High"], "Low")


def test_single_lattice_without_container():
    policy = ClassSecurityPolicy.from_json(
        _class(
            [LOW_HIGH],
            [_method("sink", [_param("int", _ann("Sec", conf=_str("Low")))])],
        )
    )
    assert policy is not None
    assert list(policy.product_lattice.lattices) == ["conf"]
    assert policy.sink("sink:(I)V").param_labels == (SecurityLabel(conf="Low"),)


def test_parameter_slots_of_instance_method_with_long():
    policy = ClassSecurityPolicy.from_json(
        _class(
            [LOW_HIGH],
            [_method("m", [_param("long"), _param("int")], access=("public",))],
        )
    )
    m = policy.method("m:(JI)V")
    assert m.param_slots == (1, 3)
    bot = policy.product_lattice.bot
    assert m.initial_locals(policy.product_lattice, max_locals=5) == (
        bot,
        m.param_labels[0],
        bot,
        m.param_labels[1],
        bot,
    )


@pytest.mark.parametrize(
    ("classjson", "message"),
    [
        (
            _class(
                [LOW_HIGH],
                [_method("m", [_param("int", _ann("Sec", conf=_str("Secret")))])],
            ),
            "Unknown level 'Secret'",
        ),
        (
            _class(
                [LOW_HIGH],
                [_method("m", [_param("int", _ann("Sec", integ=_str("Trusted")))])],
            ),
            "Unknown dimension 'integ'",
        ),
        (
            _class([], [_method("m", [_param("int", _ann("Sec", conf=_str("Low")))])]),
            "declares no @Lattice",
        ),
        (
            _class([_lattice("color", ["Red"], [], "Red")], []),
            "not one of",
        ),
        (
            _class([_lattice("conf", ["Low", "High"], ["Low < High"], "Low")], []),
            "not of the form",
        ),
        (
            _class([LOW_HIGH, LOW_HIGH], []),
            "declared twice",
        ),
    ],
)
def test_inconsistent_annotations_are_rejected(classjson, message):
    with pytest.raises(ValueError, match=message):
        ClassSecurityPolicy.from_json(classjson)


@pytest.mark.parametrize(
    "shape", ["singleton", "chain", "diamond", "pentagon", "powerset"]
)
def test_configurable_confidentiality_lattice_laws(shape):
    shapes = {
        "singleton": (("P",), ()),
        "chain": (("P", "M", "T"), (("P", "M"), ("M", "T"))),
        "diamond": (
            ("P", "A", "B", "T"),
            (("P", "A"), ("P", "B"), ("A", "T"), ("B", "T")),
        ),
        "pentagon": (
            ("P", "A", "B", "C", "T"),
            (("P", "A"), ("A", "B"), ("B", "T"), ("P", "C"), ("C", "T")),
        ),
        "powerset": (
            tuple(str(x) for x in range(8)),
            tuple(
                (str(a), str(b))
                for a, b in product(range(8), repeat=2)
                if a != b and a & b == a
            ),
        ),
    }
    levels, edges = shapes[shape]
    lattice = SecurityLattice("conf", levels, edges, levels[0])
    assert lattice.join_all([]) == lattice.bot
    assert lattice.meet_all([]) == lattice.top
    for a, b, c in product(levels, repeat=3):
        assert lattice.contains(lattice.join(a, b))
        assert lattice.contains(lattice.meet(a, b))
        assert lattice.join(a, a) == lattice.meet(a, a) == a
        assert lattice.join(a, b) == lattice.join(b, a)
        assert lattice.meet(a, b) == lattice.meet(b, a)
        assert lattice.join(lattice.join(a, b), c) == lattice.join(
            a, lattice.join(b, c)
        )
        assert lattice.meet(lattice.meet(a, b), c) == lattice.meet(
            a, lattice.meet(b, c)
        )
        assert lattice.join(a, lattice.meet(a, b)) == a
        assert lattice.meet(a, lattice.join(a, b)) == a
        assert (
            lattice.le(a, b) == (lattice.join(a, b) == b) == (lattice.meet(a, b) == a)
        )
        if lattice.le(a, b):
            assert lattice.le(lattice.join(a, c), lattice.join(b, c))
        if lattice.le(a, c) and lattice.le(b, c):
            assert lattice.le(lattice.join(a, b), c)
        if lattice.le(c, a) and lattice.le(c, b):
            assert lattice.le(c, lattice.meet(a, b))


@pytest.mark.parametrize(
    ("levels", "edges", "default"),
    [
        ((), (), "P"),
        (("P", "P"), (), "P"),
        (("P", "T"), (("P", "T"), ("T", "P")), "P"),
        (("P", "T"), (("P", "Unknown"),), "P"),
        (("P", "T"), (), "P"),
        (("P", "T"), (("P", "T"),), "Unknown"),
        (
            ("P", "A", "B", "X", "Y", "T"),
            (
                ("P", "A"),
                ("P", "B"),
                ("A", "X"),
                ("A", "Y"),
                ("B", "X"),
                ("B", "Y"),
                ("X", "T"),
                ("Y", "T"),
            ),
            "P",
        ),
    ],
)
def test_invalid_confidentiality_lattices_are_rejected(levels, edges, default):
    with pytest.raises(ValueError):
        SecurityLattice("conf", levels, edges, default)


def test_unknown_labels_are_rejected_consistently():
    lattice = SecurityLattice("conf", ("P", "T"), (("P", "T"),), "P")
    assert not lattice.contains("Unknown")
    for operation in (lattice.le, lattice.join, lattice.meet):
        with pytest.raises(ValueError, match="Unknown level"):
            operation("Unknown", "P")


def test_policy_keeps_explicit_constraints_and_uninitialized_slots():
    policy = ClassSecurityPolicy.from_json(
        _class(
            [LOW_HIGH],
            [
                _method(
                    "m", [_param("int", _ann("Sec", conf=_str("High"))), _param("int")]
                ),
            ],
        )
    )
    method = policy.method("m:(II)V")
    assert method.param_constraints == (SecurityLabel(conf="High"), None)
    assert method.initial_locals(policy.product_lattice, 3, uninitialized=True) == (
        SecurityLabel(conf="High"),
        SecurityLabel(conf="Low"),
        None,
    )


@pytest.mark.parametrize("feature", ["exceptions", "synchronized", "local_annotation"])
def test_policy_retains_unsupported_security_features(feature):
    method = _method("m", [])
    method["code"] = {}
    if feature == "exceptions":
        method["code"]["exceptions"] = [{"start": 0, "end": 1, "handler": 2}]
    elif feature == "synchronized":
        method["access"].append("synchronized")
    else:
        method["code"]["annotations"] = [{"annotation": _ann("Sec", conf=_str("Low"))}]
    policy = ClassSecurityPolicy.from_json(_class([LOW_HIGH], [method]))
    assert policy.method("m:()V").unsupported_features

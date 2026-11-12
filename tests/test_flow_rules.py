from itertools import product

import pytest

import jpamb
import jvm
from jpamb import flow_rules as rules
from jpamb.security import SecurityLattice

ONCO = frozenset({"Oncology"})
PSYCH = frozenset({"Psych"})
BOTH = ONCO | PSYCH

HOSPITAL = SecurityLattice(
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

CHAIN = SecurityLattice(
    dim="conf",
    levels=("Unclassified", "Restricted", "Confidential", "Secret"),
    order_edges=(
        ("Unclassified", "Restricted"),
        ("Restricted", "Confidential"),
        ("Confidential", "Secret"),
    ),
    default_level="Unclassified",
)


# --- the rules (docs/flow-rules.md) --------------------------------------


def test_constants_are_public():
    assert rules.constant() == rules.PUBLIC == frozenset()
    # int x = 42; outside a branch, and inside `if (secret > 5000)`
    assert rules.assign(rules.constant(), rules.PUBLIC) == rules.PUBLIC
    assert rules.assign(rules.constant(), ONCO) == ONCO


def test_arithmetic_and_comparisons_are_union():
    assert rules.binary(ONCO, rules.constant()) == ONCO  # secret + 5, x > 10
    assert rules.binary(ONCO, PSYCH) == BOTH  # a + b: both, not HospitalAdmin
    assert rules.binary(rules.constant(), rules.constant()) == rules.PUBLIC  # 5 * 10


def test_boolean_operators():
    # onco > 5000 && psych < 1000
    left = rules.binary(ONCO, rules.constant())
    right = rules.binary(PSYCH, rules.constant())
    assert rules.binary(left, right) == BOTH
    assert rules.unary(ONCO) == ONCO  # !a


def test_assignment_and_branches():
    # int result = secret + 10;
    expr = rules.binary(ONCO, rules.constant())
    assert rules.assign(expr, rules.PUBLIC) == ONCO
    assert rules.assign(expr, PSYCH) == BOTH
    # boolean isLarge = secret > 5000; if (isLarge) { ... }
    assert rules.enter_branch(rules.PUBLIC, ONCO) == ONCO
    assert rules.enter_branch(PSYCH, ONCO) == BOTH


def test_merge_is_pointwise_union():
    merged = rules.merge({"x": ONCO, "y": ONCO}, {"x": PSYCH, "z": PSYCH})
    assert merged == {"x": BOTH, "y": ONCO, "z": PSYCH}


def test_certify_includes_pc():
    # A sink, a parameter or an annotated return with a fixed label:
    # secure iff L(e) ∪ pc ⊆ L_fixed.
    assert rules.certify(ONCO, rules.PUBLIC, ONCO)
    assert not rules.certify(rules.constant(), ONCO, rules.PUBLIC)  # sink(0) under a secret if
    assert not rules.certify(ONCO, PSYCH, ONCO)
    assert rules.certify(ONCO, PSYCH, BOTH)


def test_flows_is_subset():
    assert rules.flows(rules.PUBLIC, ONCO)
    assert rules.flows(ONCO, BOTH)
    assert not rules.flows(BOTH, ONCO)
    assert not rules.flows(ONCO, PSYCH)


# --- declared levels -> compartment sets ------------------------------------


def test_hospital_levels():
    lat = rules.SetLattice.from_lattice(HOSPITAL)
    assert lat.compartments == BOTH == lat.top
    assert lat.label("Public") == rules.PUBLIC
    assert lat.label("Oncology") == ONCO
    assert lat.label("HospitalAdmin") == BOTH
    assert lat.show(BOTH) == "{Oncology, Psych}"
    assert lat.show(rules.PUBLIC) == "∅"
    with pytest.raises(ValueError):
        lat.label("Psychiatry")


def test_chain_levels():
    lat = rules.SetLattice.from_lattice(CHAIN)
    assert lat.label("Unclassified") == rules.PUBLIC
    assert lat.label("Confidential") == {"Restricted", "Confidential"}
    assert lat.top == {"Restricted", "Confidential", "Secret"}


# --- on the case classes (needs `uv run jpamb build`) -------------------------

suite, eff = jpamb.setup()


@pytest.mark.parametrize("name", ["Clearance", "Compartments", "Hospital", "InfoFlow"])
def test_sets_agree_with_declared_order(name):
    policy = suite.security_policy(jvm.ClassName(f"jpamb.cases.{name}"), eff=eff)
    assert policy is not None
    conf = policy.product_lattice.lattices["conf"]
    lat = rules.SetLattice.from_policy(policy)
    L = lat.label
    for a, b, c in product(conf.levels, repeat=3):
        assert rules.flows(L(a), L(b)) == conf.le(a, b)
        # a union of labels flows exactly when the declared join does
        assert rules.flows(rules.binary(L(a), L(b)), L(c)) == conf.le(conf.join(a, b), c)


def test_param_labels_of_a_case():
    policy = suite.security_policy(jvm.ClassName("jpamb.cases.Hospital"), eff=eff)
    assert policy is not None
    lat = rules.SetLattice.from_policy(policy)
    method = next(m for m in policy.case_methods.values() if m.name == "compartmentLeak")
    assert lat.param_labels(method) == (PSYCH,)

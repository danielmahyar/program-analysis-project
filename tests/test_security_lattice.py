import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "src"))

try:
    from jpamb.security import (
        SecurityLattice,
        ProductLattice,
        SecurityLabel,
        BytecodeAnnotationParser,
    )
except ModuleNotFoundError:
    sys.path.insert(0, str(PROJECT_ROOT / "src" / "jpamb"))
    from security import (  # type: ignore
        SecurityLattice,
        ProductLattice,
        SecurityLabel,
        BytecodeAnnotationParser,
    )


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


def test_parse_hospital_classfile():
    classfile = Path("target/classes/jpamb/cases/Hospital.class")
    assert classfile.exists(), "Hospital.class must be compiled"

    policy = BytecodeAnnotationParser.parse_classfile(classfile)

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


def test_parse_infoflow_classfile():
    classfile = Path("target/classes/jpamb/cases/InfoFlow.class")
    assert classfile.exists()

    policy = BytecodeAnnotationParser.parse_classfile(classfile)
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
    c_clearance = Path("target/classes/jpamb/cases/Clearance.class")
    if c_clearance.exists():
        policy = BytecodeAnnotationParser.parse_classfile(c_clearance)
        assert "conf" in policy.product_lattice.lattices
        conf_lat = policy.product_lattice.lattices["conf"]
        assert conf_lat.bot == "Unclassified"
        assert conf_lat.top == "TopSecret"
        assert conf_lat.le("Restricted", "Secret")  # Transitive closure

    c_compartments = Path("target/classes/jpamb/cases/Compartments.class")
    if c_compartments.exists():
        policy = BytecodeAnnotationParser.parse_classfile(c_compartments)
        assert "conf" in policy.product_lattice.lattices
        conf_lat = policy.product_lattice.lattices["conf"]
        assert len(conf_lat.levels) == 8
        assert conf_lat.join("Alpha", "Bravo") == "AlphaBravo"
        assert conf_lat.join("AlphaBravo", "Charlie") == "All"


if __name__ == "__main__":
    test_single_lattice_construction_and_closure()
    test_lattice_algebraic_laws()
    test_integrity_lattice()
    test_product_lattice()
    test_parse_hospital_classfile()
    test_parse_infoflow_classfile()
    test_parse_clearance_and_compartments()
    print("All security lattice & bytecode annotation parser tests passed!")

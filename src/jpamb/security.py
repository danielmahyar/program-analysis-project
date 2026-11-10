"""
jpamb.security

Security lattices, product lattices and security labels, and the policy a case
class declares with the annotations `@Lattice`/`@Lattices` (on the class) and
`@Sec` (on parameters and methods).

The policy is read from the decompiled class (`target/decompiled/...json`), the
same JSON every analysis already gets from JPAMB, so no Java tools are needed:

    suite, eff = jpamb.setup()
    policy = suite.security_policy(methodid.classname, eff=eff)
    if policy is not None:                       # the class declares a lattice
        method = policy.method(methodid)
        method.param_labels                      # labels of the inputs (sources)
        policy.sink(invoked_methodid)            # clearances of a called sink, or None
        policy.product_lattice.le(label, clearance)
"""

from __future__ import annotations

from collections.abc import Iterable, Mapping
from dataclasses import dataclass, field
from typing import Any

import jvm

SEC = "jpamb/utils/Sec"
LATTICE = "jpamb/utils/Lattice"
LATTICES = "jpamb/utils/Lattices"
CASE = "jpamb/utils/Case"
CASES = "jpamb/utils/Cases"
TAG = "jpamb/utils/Tag"

SEC_DIMENSIONS = ("conf", "integ")
"""The dimensions a lattice can describe: the elements of `@Sec`."""


@dataclass(frozen=True)
class SecurityLabel:
    """A multi-dimensional security label, e.g. (conf='Oncology', integ='Trusted')."""

    levels: tuple[tuple[str, str], ...]

    def __init__(
        self,
        mapping: Mapping[str, str] | Iterable[tuple[str, str]] | None = None,
        **kwargs: str,
    ):
        pairs: dict[str, str] = {}
        if mapping is not None:
            if isinstance(mapping, Mapping):
                pairs.update(mapping)
            else:
                pairs.update(dict(mapping))
        pairs.update(kwargs)
        object.__setattr__(self, "levels", tuple(sorted(pairs.items())))

    def get(self, dim: str, default: str | None = None) -> str | None:
        for d, lvl in self.levels:
            if d == dim:
                return lvl
        return default

    def __getitem__(self, dim: str) -> str:
        val = self.get(dim)
        if val is None:
            raise KeyError(f"Dimension {dim!r} not in label {self}")
        return val

    def __contains__(self, dim: str) -> bool:
        return self.get(dim) is not None

    def as_dict(self) -> dict[str, str]:
        return dict(self.levels)

    def with_dim(self, dim: str, level: str) -> SecurityLabel:
        d = self.as_dict()
        d[dim] = level
        return SecurityLabel(d)

    def __str__(self) -> str:
        if not self.levels:
            return "()"
        if len(self.levels) == 1:
            return self.levels[0][1]
        return "(" + ", ".join(f"{lvl}" for _, lvl in self.levels) + ")"

    def __repr__(self) -> str:
        inner = ", ".join(f"{d}={lvl!r}" for d, lvl in self.levels)
        return f"SecurityLabel({inner})"


@dataclass(frozen=True)
class SecurityLattice:
    """A single security lattice dimension (e.g. confidentiality or integrity).

    Validates that the reflexive-transitive closure of given edges forms
    a valid partial order (poset) and a finite lattice where unique join
    and meet exist for all pairs of levels.
    """

    dim: str
    levels: tuple[str, ...]
    order_edges: tuple[tuple[str, str], ...]
    default_level: str
    closure: frozenset[tuple[str, str]] = field(init=False)
    _join_table: dict[tuple[str, str], str] = field(init=False, repr=False)
    _meet_table: dict[tuple[str, str], str] = field(init=False, repr=False)
    bot: str = field(init=False)
    top: str = field(init=False)

    def __post_init__(self):
        levels_set = set(self.levels)
        if len(levels_set) != len(self.levels):
            raise ValueError(f"Duplicate levels in lattice {self.dim}: {self.levels}")

        if self.default_level not in levels_set:
            raise ValueError(
                f"Default level {self.default_level!r} not in levels of lattice {self.dim}"
            )

        # 1. Compute reflexive-transitive closure
        # Start with reflexivity: x <= x for all x in levels
        closure: set[tuple[str, str]] = {(x, x) for x in self.levels}

        # Add declared edges
        for lo, hi in self.order_edges:
            if lo not in levels_set:
                raise ValueError(f"Unknown level {lo!r} in order edge for {self.dim}")
            if hi not in levels_set:
                raise ValueError(f"Unknown level {hi!r} in order edge for {self.dim}")
            closure.add((lo, hi))

        # Transitive closure (Warshall's algorithm)
        changed = True
        while changed:
            changed = False
            to_add: set[tuple[str, str]] = set()
            for a, b in closure:
                for c, d in closure:
                    if b == c and (a, d) not in closure:
                        to_add.add((a, d))
            if to_add:
                closure.update(to_add)
                changed = True

        # 2. Check Antisymmetry: if a <= b and b <= a => a == b
        for a in self.levels:
            for b in self.levels:
                if (a, b) in closure and (b, a) in closure and a != b:
                    raise ValueError(
                        f"Cycle detected in lattice {self.dim}: {a} <= {b} and {b} <= {a}"
                    )

        # 3. Compute join (least upper bound) and meet (greatest lower bound)
        join_table: dict[tuple[str, str], str] = {}
        meet_table: dict[tuple[str, str], str] = {}

        for a in self.levels:
            for b in self.levels:
                # Upper bounds: {c | a <= c and b <= c}
                upper_bounds = [
                    c for c in self.levels if (a, c) in closure and (b, c) in closure
                ]
                if not upper_bounds:
                    raise ValueError(
                        f"No upper bound for pair ({a}, {b}) in lattice {self.dim}"
                    )
                # Least upper bound: u in upper_bounds such that for all v in upper_bounds: u <= v
                lubs = [
                    u
                    for u in upper_bounds
                    if all((u, v) in closure for v in upper_bounds)
                ]
                if len(lubs) != 1:
                    raise ValueError(
                        f"No unique least upper bound (join) for pair ({a}, {b}) in {self.dim}: candidates {lubs}"
                    )
                join_table[(a, b)] = lubs[0]

                # Lower bounds: {c | c <= a and c <= b}
                lower_bounds = [
                    c for c in self.levels if (c, a) in closure and (c, b) in closure
                ]
                if not lower_bounds:
                    raise ValueError(
                        f"No lower bound for pair ({a}, {b}) in lattice {self.dim}"
                    )
                # Greatest lower bound: g in lower_bounds such that for all v in lower_bounds: v <= g
                glbs = [
                    g
                    for g in lower_bounds
                    if all((v, g) in closure for v in lower_bounds)
                ]
                if len(glbs) != 1:
                    raise ValueError(
                        f"No unique greatest lower bound (meet) for pair ({a}, {b}) in {self.dim}: candidates {glbs}"
                    )
                meet_table[(a, b)] = glbs[0]

        # 4. Find bottom and top
        bots = [x for x in self.levels if all((x, y) in closure for y in self.levels)]
        tops = [x for x in self.levels if all((y, x) in closure for y in self.levels)]
        if len(bots) != 1:
            raise ValueError(f"Lattice {self.dim} has no unique bottom element")
        if len(tops) != 1:
            raise ValueError(f"Lattice {self.dim} has no unique top element")

        object.__setattr__(self, "closure", frozenset(closure))
        object.__setattr__(self, "_join_table", join_table)
        object.__setattr__(self, "_meet_table", meet_table)
        object.__setattr__(self, "bot", bots[0])
        object.__setattr__(self, "top", tops[0])

    def le(self, a: str, b: str) -> bool:
        """Returns True iff a <= b (information is allowed to flow from a to b)."""
        return (a, b) in self.closure

    def join(self, a: str, b: str) -> str:
        """Least Upper Bound (⊔)."""
        return self._join_table[(a, b)]

    def meet(self, a: str, b: str) -> str:
        """Greatest Lower Bound (⊓)."""
        return self._meet_table[(a, b)]


@dataclass(frozen=True)
class ProductLattice:
    """Cartesian product of multiple security lattices L = L_1 x L_2 x ... x L_k."""

    lattices: dict[str, SecurityLattice]
    bot: SecurityLabel = field(init=False)
    top: SecurityLabel = field(init=False)
    default_label: SecurityLabel = field(init=False)

    def __post_init__(self):
        bot_dict = {dim: lat.bot for dim, lat in self.lattices.items()}
        top_dict = {dim: lat.top for dim, lat in self.lattices.items()}
        default_dict = {dim: lat.default_level for dim, lat in self.lattices.items()}

        object.__setattr__(self, "bot", SecurityLabel(bot_dict))
        object.__setattr__(self, "top", SecurityLabel(top_dict))
        object.__setattr__(self, "default_label", SecurityLabel(default_dict))

    def make_label(
        self, mapping: Mapping[str, str] | None = None, **kwargs: str
    ) -> SecurityLabel:
        """Create a SecurityLabel where any missing (or empty) dimension gets defaultLevel.

        Raises ValueError for a dimension or level the lattice does not declare.
        """
        raw = dict(mapping or {})
        raw.update(kwargs)
        for dim, level in raw.items():
            if dim not in self.lattices:
                raise ValueError(
                    f"Unknown dimension {dim!r}; the lattices are {sorted(self.lattices)}"
                )
            if level and level not in self.lattices[dim].levels:
                raise ValueError(
                    f"Unknown level {level!r} in dimension {dim!r}; "
                    f"the levels are {list(self.lattices[dim].levels)}"
                )
        res = {}
        for dim, lat in self.lattices.items():
            res[dim] = raw.get(dim) or lat.default_level
        return SecurityLabel(res)

    def le(self, l1: SecurityLabel, l2: SecurityLabel) -> bool:
        """Point-wise partial order check: l1 <= l2 iff forall d: l1[d] <=_d l2[d]."""
        for dim, lat in self.lattices.items():
            v1 = l1.get(dim, lat.default_level)
            v2 = l2.get(dim, lat.default_level)
            if not lat.le(v1, v2):
                return False
        return True

    def join(self, l1: SecurityLabel, l2: SecurityLabel) -> SecurityLabel:
        """Point-wise join (⊔)."""
        res = {}
        for dim, lat in self.lattices.items():
            v1 = l1.get(dim, lat.default_level)
            v2 = l2.get(dim, lat.default_level)
            res[dim] = lat.join(v1, v2)
        return SecurityLabel(res)

    def meet(self, l1: SecurityLabel, l2: SecurityLabel) -> SecurityLabel:
        """Point-wise meet (⊓)."""
        res = {}
        for dim, lat in self.lattices.items():
            v1 = l1.get(dim, lat.default_level)
            v2 = l2.get(dim, lat.default_level)
            res[dim] = lat.meet(v1, v2)
        return SecurityLabel(res)


@dataclass(frozen=True)
class MethodSecurityPolicy:
    """Security annotations for a single method.

    For a case method (one with `@Case`) the parameter labels are the labels of
    the inputs. For a sink (any other method with an `@Sec` parameter) they are
    the clearances its arguments must flow to. Parameters without `@Sec` get the
    default level of every dimension.
    """

    name: str
    signature: str
    param_labels: tuple[SecurityLabel, ...]
    return_clearance: SecurityLabel | None
    is_static: bool
    is_sink: bool = False
    param_slots: tuple[int, ...] = ()
    tags: frozenset[str] = field(default_factory=frozenset)
    cases: tuple[tuple[str, str], ...] = field(default_factory=tuple)

    @property
    def id(self) -> str:
        return f"{self.name}:{self.signature}"

    @property
    def is_case(self) -> bool:
        return bool(self.cases)

    def initial_locals(
        self, product_lattice: ProductLattice, max_locals: int | None = None
    ) -> tuple[SecurityLabel, ...]:
        """Returns initial security labels for local variables at PC=0.

        Each parameter's label is placed in the local variable slot the JVM puts
        that parameter in (`long` and `double` take two slots, `this` takes slot
        0 of an instance method). Every other slot starts at bottom (⊥).
        """
        slots = self.param_slots or tuple(range(len(self.param_labels)))
        needed = max(slots, default=-1) + 1
        locals_list = [product_lattice.bot] * max(needed, max_locals or 0)
        for slot, label in zip(slots, self.param_labels):
            locals_list[slot] = label
        return tuple(locals_list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "signature": self.signature,
            "is_static": self.is_static,
            "is_sink": self.is_sink,
            "param_labels": [lbl.as_dict() for lbl in self.param_labels],
            "param_slots": list(self.param_slots),
            "return_clearance": (
                self.return_clearance.as_dict() if self.return_clearance else None
            ),
            "tags": sorted(self.tags),
            "cases": [{"input": cinp, "expected": cout} for cinp, cout in self.cases],
        }


@dataclass(frozen=True)
class ClassSecurityPolicy:
    """Complete security policy declared on a Java class."""

    classname: str
    product_lattice: ProductLattice
    methods: dict[str, MethodSecurityPolicy]

    @classmethod
    def from_json(cls, classjson: Mapping[str, Any]) -> ClassSecurityPolicy | None:
        """Read the policy from a decompiled class (as returned by `Suite.findclass`).

        Returns None for a class that declares no `@Lattice` (an ordinary case
        class). Raises ValueError if the annotations are inconsistent, e.g. an
        `@Sec` level that is not in the lattice.
        """
        classname = str(classjson["name"]).replace("/", ".")
        methods_json = [
            m for m in classjson.get("methods", []) if not m["name"].startswith("<")
        ]

        lattices: dict[str, SecurityLattice] = {}
        for ann in _annotations(classjson.get("annotations", [])):
            if ann.type != LATTICE:
                continue
            lattice = _lattice(ann, where=classname)
            if lattice.dim in lattices:
                raise ValueError(
                    f"{classname}: dimension {lattice.dim!r} is declared twice"
                )
            lattices[lattice.dim] = lattice

        if not lattices:
            if any(_uses_sec(m) for m in methods_json):
                raise ValueError(f"{classname} uses @Sec but declares no @Lattice")
            return None

        product = ProductLattice(lattices)
        methods: dict[str, MethodSecurityPolicy] = {}
        for mj in methods_json:
            method = _method_policy(classname, mj, product)
            methods[method.id] = method
        return cls(classname=classname, product_lattice=product, methods=methods)

    def method(
        self, methodid: jvm.AbsMethodID | jvm.MethodID | str
    ) -> MethodSecurityPolicy:
        """The policy of a method, given as a method id (e.g. the one JPAMB passes to an analysis)."""
        key = self._key(methodid)
        if key is None or key not in self.methods:
            raise KeyError(f"No method {methodid} in {self.classname}")
        return self.methods[key]

    def sink(
        self, methodid: jvm.AbsMethodID | jvm.MethodID | str
    ) -> MethodSecurityPolicy | None:
        """The called method if it is a sink of this class, else None.

        Use it on the method of an `invoke` instruction; the clearance of
        argument i is `sink.param_labels[i]`.
        """
        key = self._key(methodid)
        method = self.methods.get(key) if key is not None else None
        return method if method is not None and method.is_sink else None

    @property
    def sinks(self) -> dict[str, MethodSecurityPolicy]:
        return {mid: m for mid, m in self.methods.items() if m.is_sink}

    @property
    def case_methods(self) -> dict[str, MethodSecurityPolicy]:
        return {mid: m for mid, m in self.methods.items() if m.is_case}

    def get_method(self, name_or_sig: str) -> MethodSecurityPolicy | None:
        if name_or_sig in self.methods:
            return self.methods[name_or_sig]
        # Match by simple method name if unique
        matching = [m for m in self.methods.values() if m.name == name_or_sig]
        if len(matching) == 1:
            return matching[0]
        return None

    def get_sink_clearances(self) -> dict[str, tuple[SecurityLabel, ...]]:
        """Returns a mapping from sink method IDs (and names) to their parameter clearances."""
        sinks: dict[str, tuple[SecurityLabel, ...]] = {}
        for mid, m in self.sinks.items():
            sinks[mid] = m.param_labels
            sinks[m.name] = m.param_labels
        return sinks

    def _key(self, methodid: jvm.AbsMethodID | jvm.MethodID | str) -> str | None:
        """The key in `methods`; None if the method belongs to another class."""
        if isinstance(methodid, jvm.AbsMethodID):
            if str(methodid.classname) != self.classname:
                return None
            return methodid.extension.encode()
        if isinstance(methodid, jvm.MethodID):
            return methodid.encode()
        return methodid.removeprefix(self.classname + ".")

    def to_dict(self) -> dict[str, Any]:
        return {
            "classname": self.classname,
            "lattices": {
                dim: {
                    "levels": list(lat.levels),
                    "order": [f"{lo} <= {hi}" for lo, hi in lat.order_edges],
                    "defaultLevel": lat.default_level,
                    "bot": lat.bot,
                    "top": lat.top,
                }
                for dim, lat in self.product_lattice.lattices.items()
            },
            "product_lattice": {
                "bot": self.product_lattice.bot.as_dict(),
                "top": self.product_lattice.top.as_dict(),
                "default": self.product_lattice.default_label.as_dict(),
            },
            "methods": {k: m.to_dict() for k, m in self.methods.items()},
        }


# ---------------------------------------------------------------------------
# Reading annotations from the decompiled JSON (jvm2json format)
# ---------------------------------------------------------------------------


@dataclass(frozen=True)
class Annotation:
    """A decoded annotation: its type (e.g. "jpamb/utils/Sec") and element values."""

    type: str
    values: dict[str, Any]


def _decode_value(value: Mapping[str, Any]) -> Any:
    kind, inner = value["type"], value["value"]
    if kind == "array":
        return [_decode_value(v) for v in inner]
    if kind == "annotation":
        return _decode_annotation(inner)
    if kind == "enum":
        return inner["name"]
    return inner


def _decode_annotation(annotation: Mapping[str, Any]) -> Annotation:
    return Annotation(
        type=annotation["type"],
        values={k: _decode_value(v) for k, v in annotation.get("values", {}).items()},
    )


def _annotations(raw: Iterable[Mapping[str, Any]]) -> list[Annotation]:
    """Decode annotations, unpacking the containers of repeated annotations
    (`@Lattices` holds the `@Lattice`s, `@Cases` the `@Case`s)."""
    result = []
    for annotation in map(_decode_annotation, raw):
        if annotation.type in (LATTICES, CASES):
            result.extend(annotation.values.get("value", []))
        else:
            result.append(annotation)
    return result


def _find(annotations: Iterable[Annotation], type: str) -> Annotation | None:
    return next((a for a in annotations if a.type == type), None)


def _lattice(ann: Annotation, *, where: str) -> SecurityLattice:
    dim = ann.values["dim"]
    if dim not in SEC_DIMENSIONS:
        raise ValueError(
            f"{where}: @Lattice dimension {dim!r} is not one of {list(SEC_DIMENSIONS)}"
        )
    edges = []
    for edge in ann.values.get("order", []):
        lo, sep, hi = edge.partition("<=")
        if not sep or not lo.strip() or not hi.strip():
            raise ValueError(
                f"{where}: order edge {edge!r} is not of the form 'lo <= hi'"
            )
        edges.append((lo.strip(), hi.strip()))
    return SecurityLattice(
        dim=dim,
        levels=tuple(ann.values.get("levels", [])),
        order_edges=tuple(edges),
        default_level=ann.values["defaultLevel"],
    )


def _label(
    product: ProductLattice, sec: Annotation | None, *, where: str
) -> SecurityLabel:
    """The label an `@Sec` describes; dimensions it leaves out get their default."""
    try:
        return product.make_label(sec.values if sec is not None else {})
    except ValueError as e:
        raise ValueError(f"{where}: {e}") from None


def _uses_sec(method: Mapping[str, Any]) -> bool:
    if _find(_annotations(method.get("annotations", [])), SEC):
        return True
    return any(
        _find(_annotations(p.get("annotations", [])), SEC)
        for p in method.get("params", [])
    )


_BASE_DESCRIPTORS = {
    "int": "I",
    "integer": "I",
    "boolean": "Z",
    "char": "C",
    "short": "S",
    "byte": "B",
    "long": "J",
    "float": "F",
    "double": "D",
}


def _descriptor(type_json: Mapping[str, Any] | None) -> str:
    """The JVM descriptor of a jvm2json type (`None` is void)."""
    if type_json is None:
        return "V"
    if "base" in type_json:
        return _BASE_DESCRIPTORS[type_json["base"]]
    if type_json.get("kind") == "array":
        return "[" + _descriptor(type_json["type"])
    if type_json.get("kind") == "class":
        return f"L{type_json['name']};"
    raise ValueError(f"Unknown type {type_json!r}")


def _method_policy(
    classname: str, mj: Mapping[str, Any], product: ProductLattice
) -> MethodSecurityPolicy:
    name = mj["name"]
    params = mj.get("params", [])
    signature = (
        "("
        + "".join(_descriptor(p["type"]) for p in params)
        + ")"
        + _descriptor(mj.get("returns", {}).get("type"))
    )
    where = f"{classname}.{name}:{signature}"
    is_static = "static" in mj.get("access", [])

    annotations = _annotations(mj.get("annotations", []))
    cases = tuple(
        (inp.strip(), out.strip())
        for a in annotations
        if a.type == CASE
        for inp, _, out in [a.values["value"].rpartition("->")]
    )
    tags = frozenset(
        tag for a in annotations if a.type == TAG for tag in a.values.get("value", [])
    )
    return_sec = _find(annotations, SEC)
    return_clearance = (
        _label(product, return_sec, where=f"{where} return") if return_sec else None
    )

    labels, slots, has_sec_param = [], [], False
    slot = 0 if is_static else 1
    for i, p in enumerate(params):
        sec = _find(_annotations(p.get("annotations", [])), SEC)
        has_sec_param |= sec is not None
        labels.append(_label(product, sec, where=f"{where} parameter {i}"))
        slots.append(slot)
        slot += 2 if _descriptor(p["type"]) in ("J", "D") else 1

    return MethodSecurityPolicy(
        name=name,
        signature=signature,
        param_labels=tuple(labels),
        return_clearance=return_clearance,
        is_static=is_static,
        is_sink=has_sec_param and not cases,
        param_slots=tuple(slots),
        tags=tags,
        cases=cases,
    )

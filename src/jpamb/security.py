"""
jpamb.security

Data structures and parsing utilities for configurable security lattices,
product lattices, and security annotations (@Lattice, @Lattices, @Sec)
extracted from Java bytecode.
"""

from __future__ import annotations

import re
import subprocess
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence


@dataclass(frozen=True)
class SecurityLabel:
    """A multi-dimensional security label, e.g. (conf='Oncology', integ='Trusted')."""

    levels: tuple[tuple[str, str], ...]

    def __init__(self, mapping: Mapping[str, str] | Iterable[tuple[str, str]] | None = None, **kwargs: str):
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
                    raise ValueError(f"No upper bound for pair ({a}, {b}) in lattice {self.dim}")
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
                    raise ValueError(f"No lower bound for pair ({a}, {b}) in lattice {self.dim}")
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
        bots = [
            x for x in self.levels if all((x, y) in closure for y in self.levels)
        ]
        tops = [
            x for x in self.levels if all((y, x) in closure for y in self.levels)
        ]
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

    def make_label(self, mapping: Mapping[str, str] | None = None, **kwargs: str) -> SecurityLabel:
        """Create a SecurityLabel where any missing dimension gets defaultLevel."""
        raw = dict(mapping or {})
        raw.update(kwargs)
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
    """Security annotations for a single method."""

    name: str
    signature: str
    param_labels: tuple[SecurityLabel, ...]
    return_clearance: SecurityLabel | None
    is_static: bool
    tags: frozenset[str] = field(default_factory=frozenset)
    cases: tuple[tuple[str, str], ...] = field(default_factory=tuple)

    @property
    def id(self) -> str:
        return f"{self.name}:{self.signature}"

    def initial_locals(
        self, product_lattice: ProductLattice, max_locals: int | None = None
    ) -> tuple[SecurityLabel, ...]:
        """Returns initial security labels for local variables at PC=0.

        Parameters receive their @Sec source labels (or defaultLevel per dimension),
        while non-parameter local slots start at the product lattice bottom (⊥).
        """
        total = max(len(self.param_labels), max_locals or len(self.param_labels))
        locals_list = list(self.param_labels)
        while len(locals_list) < total:
            locals_list.append(product_lattice.bot)
        return tuple(locals_list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "signature": self.signature,
            "is_static": self.is_static,
            "param_labels": [lbl.as_dict() for lbl in self.param_labels],
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
    fields: dict[str, SecurityLabel]

    def get_method(self, name_or_sig: str) -> MethodSecurityPolicy | None:
        if name_or_sig in self.methods:
            return self.methods[name_or_sig]
        # Match by simple method name if unique
        matching = [m for m in self.methods.values() if m.name == name_or_sig]
        if len(matching) == 1:
            return matching[0]
        return None

    def get_sink_clearances(self) -> dict[str, tuple[SecurityLabel, ...]]:
        """Returns a mapping from sink method IDs to their parameter clearance labels."""
        sinks: dict[str, tuple[SecurityLabel, ...]] = {}
        for mid, m in self.methods.items():
            if not m.cases and m.param_labels:
                sinks[mid] = m.param_labels
                sinks[m.name] = m.param_labels
        return sinks

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
            "fields": {k: v.as_dict() for k, v in self.fields.items()},
            "methods": {k: m.to_dict() for k, m in self.methods.items()},
        }


# ---------------------------------------------------------------------------
# Bytecode Annotation Parser (ISY)
# ---------------------------------------------------------------------------

class BytecodeAnnotationParser:
    """Extracts @Lattice, @Lattices, and @Sec annotations from Java bytecode.

    Parses compiled classfiles using javap (available in any standard JDK).
    """

    @classmethod
    def parse_classfile(cls, classfile_path: Path | str) -> ClassSecurityPolicy:
        path = Path(classfile_path)
        if not path.is_file():
            raise FileNotFoundError(f"Classfile not found: {path}")

        # Run javap -v -p to inspect full constant pool and attributes
        cmd = ["javap", "-v", "-p", str(path)]
        res = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return cls.parse_javap_output(res.stdout, classname=path.stem)

    @classmethod
    def parse_javap_output(cls, output: str, classname: str = "") -> ClassSecurityPolicy:
        # 1. Parse class name if not given
        if not classname:
            match_class = re.search(r"public class ([^\s<]+)", output)
            if match_class:
                classname = match_class.group(1).replace("/", ".")

        # 2. Extract @Lattice annotations from the class-level RuntimeVisibleAnnotations
        # In javap, class-level annotations appear at the bottom under "SourceFile: ... RuntimeVisibleAnnotations:"
        lattices = cls._extract_class_lattices(output)
        if not lattices:
            # Fallback default: single two-point confidentiality lattice if none declared
            default_lat = SecurityLattice(
                dim="conf",
                levels=("Low", "High"),
                order_edges=(("Low", "High"),),
                default_level="Low",
            )
            product_lattice = ProductLattice({"conf": default_lat})
        else:
            product_lattice = ProductLattice(lattices)

        # 3. Extract methods, parameter annotations, and return annotations
        methods = cls._extract_methods(output, product_lattice)

        # 4. Extract static fields and their annotations
        fields = cls._extract_fields(output, product_lattice)

        return ClassSecurityPolicy(
            classname=classname,
            product_lattice=product_lattice,
            methods=methods,
            fields=fields,
        )

    @classmethod
    def _extract_class_lattices(cls, output: str) -> dict[str, SecurityLattice]:
        lattices: dict[str, SecurityLattice] = {}

        # Look for Lattice patterns:
        # @Lattice(
        #   dim="conf"
        #   levels=["Public","Oncology",...]
        #   order=["Public <= Oncology",...]
        #   defaultLevel="Public"
        # )
        lattice_pattern = re.compile(
            r"@(?:jpamb\.utils\.)?Lattice\s*\(\s*dim=\"([^\"]+)\"\s*levels=\[([^\]]*)\]\s*order=\[([^\]]*)\]\s*defaultLevel=\"([^\"]+)\"\s*\)",
            re.MULTILINE,
        )

        for match in lattice_pattern.finditer(output):
            dim = match.group(1).strip()
            raw_levels = match.group(2)
            raw_order = match.group(3)
            default_level = match.group(4).strip()

            levels = tuple(
                lvl.strip().strip('"') for lvl in raw_levels.split(",") if lvl.strip()
            )
            edges: list[tuple[str, str]] = []
            for edge_str in raw_order.split(","):
                edge_clean = edge_str.strip().strip('"')
                if "<=" in edge_clean:
                    lo, hi = edge_clean.split("<=", 1)
                    edges.append((lo.strip(), hi.strip()))

            lat = SecurityLattice(
                dim=dim,
                levels=levels,
                order_edges=tuple(edges),
                default_level=default_level,
            )
            lattices[dim] = lat

        return lattices

    @classmethod
    def _extract_sec_annotation(
        cls, block: str, product_lattice: ProductLattice
    ) -> SecurityLabel | None:
        """Finds a @Sec annotation in a text block and converts it to a SecurityLabel."""
        sec_pattern = re.compile(
            r"(?:jpamb\.utils\.)?Sec\s*\(\s*([^)]*)\)", re.DOTALL
        )
        m = sec_pattern.search(block)
        if not m:
            return None

        inner = m.group(1)
        vals: dict[str, str] = {}
        for dim in product_lattice.lattices:
            match_dim = re.search(rf"{dim}\s*=\s*\"([^\"]+)\"", inner)
            if match_dim:
                vals[dim] = match_dim.group(1).strip()

        return product_lattice.make_label(vals)

    @classmethod
    def _extract_methods(
        cls, output: str, product_lattice: ProductLattice
    ) -> dict[str, MethodSecurityPolicy]:
        methods: dict[str, MethodSecurityPolicy] = {}

        # Split javap output into method sections
        # A method in javap looks like:
        #   public static void process(int, int);
        #     descriptor: (II)V
        #     flags: (0x0009) ACC_PUBLIC, ACC_STATIC
        #     Code:
        #     ...
        #     RuntimeVisibleParameterAnnotations:
        #       ...
        #
        method_blocks = re.split(r"\n\s*(?:public|protected|private|static|\/\*)\s+", output)
        method_header_re = re.compile(
            r"^(?:(?:public|protected|private|static|final|synchronized)\s+)*([^\s(]+)\s+([^\s(]+)\(([^)]*)\);\s*descriptor:\s*([^\s]+)",
            re.MULTILINE,
        )

        for block in method_blocks:
            m_hdr = method_header_re.search(block)
            if not m_hdr:
                continue

            return_type_str = m_hdr.group(1)
            method_name = m_hdr.group(2)
            raw_params = m_hdr.group(3)
            descriptor = m_hdr.group(4)
            is_static = "static" in block.split("Code:")[0]

            # Parse parameter count from raw_params
            param_types = [p.strip() for p in raw_params.split(",") if p.strip()]
            num_params = len(param_types)

            # Extract parameter annotations
            param_labels: list[SecurityLabel] = []
            param_ann_match = re.search(
                r"RuntimeVisibleParameterAnnotations:\s*(.*?)(?=\n\s*(?:RuntimeVisibleAnnotations|StackMapTable|LineNumberTable|[A-Z])|\Z)",
                block,
                re.DOTALL,
            )

            param_blocks: dict[int, str] = {}
            if param_ann_match:
                param_text = param_ann_match.group(1)
                p_splits = re.split(r"parameter\s+(\d+):", param_text)
                for i in range(1, len(p_splits), 2):
                    idx = int(p_splits[i])
                    param_blocks[idx] = p_splits[i + 1]

            for i in range(num_params):
                if i in param_blocks:
                    lbl = cls._extract_sec_annotation(param_blocks[i], product_lattice)
                    param_labels.append(lbl if lbl else product_lattice.default_label)
                else:
                    param_labels.append(product_lattice.default_label)

            # Method return annotation (in method-level RuntimeVisibleAnnotations)
            ret_label = None
            m_ann_match = re.search(
                r"RuntimeVisibleAnnotations:\s*(.*?)(?=\n\s*(?:RuntimeVisibleParameterAnnotations|StackMapTable|LineNumberTable|[A-Z])|\Z)",
                block,
                re.DOTALL,
            )
            if m_ann_match:
                ret_label = cls._extract_sec_annotation(m_ann_match.group(1), product_lattice)

            # Tags and Cases
            tags: set[str] = set()
            tag_match = re.search(r"TagType;\.([A-Z_]+)", block)
            if tag_match:
                for tm in re.finditer(r"TagType;\.([A-Z_]+)", block):
                    tags.add(tm.group(1))

            cases: list[tuple[str, str]] = []
            for cm in re.finditer(r'value="(\([^)]*\)\s*->\s*[^"]+)"', block):
                case_str = cm.group(1)
                if "->" in case_str:
                    cinp, cout = case_str.split("->", 1)
                    cases.append((cinp.strip(), cout.strip()))

            policy = MethodSecurityPolicy(
                name=method_name,
                signature=descriptor,
                param_labels=tuple(param_labels),
                return_clearance=ret_label,
                is_static=is_static,
                tags=frozenset(tags),
                cases=tuple(cases),
            )
            methods[f"{method_name}:{descriptor}"] = policy

        return methods

    @classmethod
    def _extract_fields(
        cls, output: str, product_lattice: ProductLattice
    ) -> dict[str, SecurityLabel]:
        fields: dict[str, SecurityLabel] = {}
        # Example in javap:
        #   static int publicDashboard;
        #     descriptor: I
        #     flags: (0x0008) ACC_STATIC
        #     RuntimeVisibleAnnotations:
        #       0: #... Sec(conf="Public", integ="Untrusted")
        field_matches = re.finditer(
            r"static\s+[^\s;]+\s+([a-zA-Z0-9_$]+);.*?RuntimeVisibleAnnotations:\s*(.*?)(?=\n\s*(?:static|[a-z]+ void|[a-z]+ int|\}))",
            output,
            re.DOTALL,
        )
        for fm in field_matches:
            fname = fm.group(1)
            fblock = fm.group(2)
            lbl = cls._extract_sec_annotation(fblock, product_lattice)
            if lbl:
                fields[fname] = lbl
        return fields

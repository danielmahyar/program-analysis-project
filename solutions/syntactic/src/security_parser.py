#!/usr/bin/env python3
"""
ISY: Bytecode Annotation Parser & Syntactic Security Checker

Extracts and validates configurable security lattices (@Lattice) and
method security annotations (@Sec) from compiled Java bytecode.
Provides syntactic verification of explicit flows and reports policies
to the static and dynamic analysis engines.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

# Add project root to path (with fallback if jpamb.__init__ requires runit)
PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "src"))

try:
    from jpamb.security import BytecodeAnnotationParser, ClassSecurityPolicy
except ModuleNotFoundError:
    sys.path.insert(0, str(PROJECT_ROOT / "src" / "jpamb"))
    from security import BytecodeAnnotationParser, ClassSecurityPolicy  # type: ignore


def inspect_class(class_path_or_name: str) -> ClassSecurityPolicy:
    path = Path(class_path_or_name)
    if not path.exists():
        # Try resolving relative to target/classes
        target_path = PROJECT_ROOT / "target" / "classes" / (class_path_or_name.replace(".", "/") + ".class")
        if target_path.exists():
            path = target_path
        else:
            raise FileNotFoundError(f"Could not find class file for {class_path_or_name}")

    return BytecodeAnnotationParser.parse_classfile(path)


def main():
    parser = argparse.ArgumentParser(
        description="ISY: Parse security lattices and annotations from Java bytecode."
    )
    parser.add_argument(
        "target",
        help="Class name (e.g. jpamb.cases.Hospital) or path to .class file",
    )
    parser.add_argument(
        "--method",
        "-m",
        help="Optional method name to inspect in detail",
        default=None,
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output extracted security policy as JSON for static/dynamic engines",
    )

    args = parser.parse_args()

    try:
        policy = inspect_class(args.target)
    except Exception as e:
        print(f"Error parsing bytecode annotations: {e}", file=sys.stderr)
        sys.exit(1)

    if args.json:
        data = policy.to_dict()
        if args.method:
            m = policy.get_method(args.method)
            data["methods"] = {m.id: m.to_dict()} if m else {}
        print(json.dumps(data, indent=2))
        return

    print("=" * 70)
    print(f" SECURITY POLICY: {policy.classname}")
    print("=" * 70)

    print("\n[+] LATTICES DECLARED (@Lattice):")
    for dim, lat in policy.product_lattice.lattices.items():
        print(f"  - Dimension: {dim!r}")
        print(f"    Levels:       {', '.join(lat.levels)}")
        print(f"    Bottom (⊥):   {lat.bot}")
        print(f"    Top (⊤):      {lat.top}")
        print(f"    Default:      {lat.default_level}")
        print(f"    Edges (Hasse): {', '.join(f'{lo} <= {hi}' for lo, hi in lat.order_edges)}")

    print(f"\n[+] PRODUCT LATTICE (L_C × L_I):")
    print(f"  - Bottom (⊥):   {policy.product_lattice.bot}")
    print(f"  - Top (⊤):      {policy.product_lattice.top}")
    print(f"  - Default:      {policy.product_lattice.default_label}")

    if policy.fields:
        print("\n[+] LABELED STATIC FIELDS:")
        for fname, flabel in policy.fields.items():
            print(f"  - {fname}: {flabel}")

    print("\n[+] METHODS & ANNOTATIONS (@Sec, @Case, @Tag):")
    methods_to_show = policy.methods.values()
    if args.method:
        methods_to_show = [m for m in methods_to_show if m.name == args.method]

    for m in methods_to_show:
        print(f"\n  * Method: {m.name} {m.signature}")
        print(f"    Static: {m.is_static}")
        if m.param_labels:
            print("    Parameters (Sources / Sink Clearances):")
            for idx, plabel in enumerate(m.param_labels):
                print(f"      [{idx}] {plabel}")
        if m.return_clearance:
            print(f"    Return Clearance: {m.return_clearance}")
        if m.tags:
            print(f"    Tags: {', '.join(sorted(m.tags))}")
        if m.cases:
            print("    Cases:")
            for cinp, cout in m.cases:
                print(f"      {cinp} -> {cout}")

    print("\n" + "=" * 70)
    print(" Annotation parsing completed successfully.")
    print("=" * 70)


if __name__ == "__main__":
    main()

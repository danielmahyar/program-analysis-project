#!/usr/bin/env python3
"""
ISY: print the security policy of a case class.

Shows the lattices (@Lattice), the product lattice, and the @Sec labels of every
method, as JPAMB gives them to the analyses: read from the decompiled class in
target/decompiled, with `suite.security_policy` (see jpamb.security).

Run from the repository root:

    uv run python solutions/syntactic/src/security_parser.py jpamb.cases.Hospital
    uv run python solutions/syntactic/src/security_parser.py jpamb.cases.Hospital --method process
    uv run python solutions/syntactic/src/security_parser.py jpamb.cases.Hospital --json
"""

from __future__ import annotations

import argparse
import io
import json
import sys

import jpamb
import jvm


def main():
    if isinstance(sys.stdout, io.TextIOWrapper):
        sys.stdout.reconfigure(encoding="utf-8")  # ⊥/⊤ on Windows consoles

    parser = argparse.ArgumentParser(
        description="ISY: print the security lattices and annotations of a case class."
    )
    parser.add_argument("target", help="Class name, e.g. jpamb.cases.Hospital")
    parser.add_argument(
        "--method", "-m", default=None, help="Only show the method with this name"
    )
    parser.add_argument("--json", action="store_true", help="Print the policy as JSON")
    args = parser.parse_args()

    suite, eff = jpamb.setup()
    try:
        policy = suite.security_policy(jvm.ClassName(args.target), eff=eff)
    except FileNotFoundError:
        sys.exit(f"{args.target} is not decompiled; run `uv run jpamb build` first.")
    except ValueError as e:
        sys.exit(f"Invalid security annotations: {e}")
    if policy is None:
        sys.exit(f"{args.target} declares no @Lattice.")

    methods = [
        m
        for m in policy.methods.values()
        if args.method is None or m.name == args.method
    ]

    if args.json:
        data = policy.to_dict()
        data["methods"] = {m.id: m.to_dict() for m in methods}
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
        print(
            f"    Edges (Hasse): {', '.join(f'{lo} <= {hi}' for lo, hi in lat.order_edges)}"
        )

    print("\n[+] PRODUCT LATTICE:")
    print(f"  - Bottom (⊥):   {policy.product_lattice.bot}")
    print(f"  - Top (⊤):      {policy.product_lattice.top}")
    print(f"  - Default:      {policy.product_lattice.default_label}")

    print("\n[+] METHODS & ANNOTATIONS (@Sec, @Case, @Tag):")
    for m in methods:
        kind = "case" if m.is_case else "sink" if m.is_sink else "helper"
        print(f"\n  * Method: {m.name} {m.signature}  [{kind}]")
        print(f"    Static: {m.is_static}")
        if m.param_labels:
            title = "Input labels (sources)" if m.is_case else "Argument clearances"
            print(f"    {title}:")
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


if __name__ == "__main__":
    main()

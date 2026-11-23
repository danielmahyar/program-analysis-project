"""Run the project confidentiality analysis."""

import argparse

from unbounded_confidentiality.cli import (
    report_security,
    security_config,
    unknown_result,
)
from unbounded_confidentiality.interpreter import AbstractInterpreter

import jpamb


def analyse() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("method", help="JPAMB method ID, or 'info' for metadata")
    args = parser.parse_args()
    if args.method == "info":
        jpamb.printinfo(
            "project-unbounded-confidentiality",
            "0.1.0",
            "loop cancelled",
            ["static", "python"],
            for_science=True,
        )

    method_id = jpamb.parse_methodid(args.method)
    suite, eff = jpamb.setup()
    try:
        policy = suite.security_policy(method_id.classname, eff=eff)
        if policy is None:
            raise ValueError("class has no declared security lattice")
        interpreter = AbstractInterpreter.initial(
            jpamb.Bytecode(suite, eff, {}), method_id, policy, security_config()
        )
    except (
        OSError,
        LookupError,
        ValueError,
        NotImplementedError,
        AssertionError,
        TypeError,
    ) as exc:
        report_security(unknown_result(exc))
        return

    report_security(interpreter.run())


if __name__ == "__main__":
    analyse()

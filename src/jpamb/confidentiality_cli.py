"""Configuration and JPAMB output shared by the confidentiality commands."""

import os
import sys

import jpamb
from jpamb import confidentiality


def security_config() -> confidentiality.Config:
    limit = os.environ.get("JPAMB_CONF_MAX_STEPS")
    return confidentiality.Config(
        return_clearance=os.environ.get("JPAMB_CONF_RETURN_CLEARANCE"),
        max_steps=int(limit) if limit is not None else None,
    )


def unknown_result(exc: Exception) -> confidentiality.Result:
    return confidentiality.Result(
        "unsupported",
        (confidentiality.Diagnostic(-1, "unsupported", str(exc)),),
        {},
        0,
    )


def report_security(result: confidentiality.Result):
    print(
        f"confidentiality: {result.status} after {result.steps} steps", file=sys.stderr
    )
    for diagnostic in result.diagnostics:
        print(
            f"  {diagnostic.offset}: {diagnostic.kind}: {diagnostic.message}",
            file=sys.stderr,
        )
    leaks = any(d.kind in ("explicit", "implicit") for d in result.diagnostics)
    for query in jpamb.QUERIES:
        # This domain answers confidentiality, not numeric runtime outcomes.
        prediction = "unknown"
        if query == "assertion error":
            prediction = "maybe" if leaks else "no" if result.safe else "unknown"
        print(f"{query};{prediction}")

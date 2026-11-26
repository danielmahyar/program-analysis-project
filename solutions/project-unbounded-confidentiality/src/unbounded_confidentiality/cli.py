"""Configuration and JPAMB output for the project interpreter."""

import os
import sys

import jpamb

from .interpreter import Config, Diagnostic, Result


def security_config() -> Config:
    limit = os.environ.get("JPAMB_CONF_MAX_STEPS")
    return Config(
        return_clearance=os.environ.get("JPAMB_CONF_RETURN_CLEARANCE"),
        max_steps=int(limit) if limit is not None else None,
    )


def unknown_result(exc: Exception) -> Result:
    return Result(
        "unsupported",
        (Diagnostic(-1, "unsupported", str(exc)),),
        {},
        0,
    )


def report_security(result: Result) -> None:
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
        # JPAMB uses the assertion error query for confidentiality leaks.
        prediction = "unknown"
        if query == "assertion error":
            prediction = "maybe" if leaks else "no" if result.safe else "unknown"
        print(f"{query};{prediction}")

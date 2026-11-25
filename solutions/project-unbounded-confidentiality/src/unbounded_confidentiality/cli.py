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
        prediction = "unknown"
        if query == "assertion error":
            prediction = "maybe" if leaks else "no" if result.safe else "unknown"
        elif query == "ok":
            if result.complete and result.can_return_ok is not None:
                if not result.can_return_ok:
                    prediction = "no"
                elif result.safe:
                    prediction = "ok-safe"
                else:
                    prediction = "ok-maybe"
        elif query == "divide by zero":
            if result.complete and result.possible_div_zero is not None:
                prediction = "maybe-div0" if result.possible_div_zero else "no"
        elif query in ("null pointer", "out of bounds"):
            if result.complete:
                prediction = "no"
        elif query == "*" and result.complete and result.has_reachable_cycle is False:
            prediction = "no"
        print(f"{query};{prediction}")

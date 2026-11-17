"""Boundary between input exploration and a concrete confidentiality interpreter.

An adapter owns policy checks, JVM execution, state reset, and step accounting.
The fuzzer only consumes its observations; it never interprets security labels.
"""

from dataclasses import dataclass
from typing import Literal, Protocol

import jvm
from jpamb.case import Input
from jvm.state import PC

RunStatus = Literal["completed", "step-limit", "unsupported"]
ViolationKind = Literal["explicit", "implicit", "mixed", "unknown"]
OUTCOMES = frozenset(
    {"ok", "assertion error", "divide by zero", "out of bounds", "null pointer"}
)


@dataclass(frozen=True)
class Violation:
    """A failed confidentiality certification reported by the concrete runner."""

    pc: PC
    target: str
    effective: str
    allowed: str
    context: str
    kind: ViolationKind = "unknown"

    def __post_init__(self):
        if self.kind not in {"explicit", "implicit", "mixed", "unknown"}:
            raise ValueError(f"unknown violation kind: {self.kind}")
        if not isinstance(self.pc, PC) or self.pc.offset < 0:
            raise ValueError("a violation needs a valid instruction location")

    @property
    def fingerprint(self) -> tuple[PC, str, ViolationKind]:
        return self.pc, self.target, self.kind


@dataclass(frozen=True)
class RunResult:
    """One fresh execution, including coverage before an incomplete result.

    A policy violation terminates execution with ``assertion error`` and a
    structured diagnostic. An ordinary assertion can have the same outcome
    without any confidentiality diagnostics. Budget exhaustion is not ``*``.
    """

    status: RunStatus
    coverage: frozenset[PC]
    steps: int
    outcome: str | None = None
    violations: tuple[Violation, ...] = ()
    detail: str | None = None

    def __post_init__(self):
        object.__setattr__(self, "coverage", frozenset(self.coverage))
        object.__setattr__(self, "violations", tuple(self.violations))
        if self.status not in {"completed", "step-limit", "unsupported"}:
            raise ValueError(f"unknown execution status: {self.status}")
        if type(self.steps) is not int or self.steps < 0:
            raise ValueError("steps must be a non-negative integer")
        if any(not isinstance(pc, PC) or pc.offset < 0 for pc in self.coverage):
            raise ValueError("coverage must contain valid instruction locations")
        if len(self.coverage) > self.steps:
            raise ValueError("reached instructions exceed executed steps")
        if self.status == "completed":
            if self.outcome not in OUTCOMES:
                raise ValueError("completed runs need a concrete terminating outcome")
        elif self.outcome is not None:
            raise ValueError("incomplete runs cannot claim a terminal outcome")
        if self.violations and (
            self.status != "completed" or self.outcome != "assertion error"
        ):
            raise ValueError(
                "a confidentiality violation must terminate with assertion error"
            )
        if any(v.pc not in self.coverage for v in self.violations):
            raise ValueError("the violating instruction must be included in coverage")


class Runner(Protocol):
    """An adapter may be a function or any callable object.

    Reset all concrete/shadow state for every call. Execute at most step_limit
    target instructions. Treat security_config as caller-owned policy settings;
    do not mutate it. Unexpected interpreter errors should propagate.
    """

    def __call__(
        self,
        method_id: jvm.AbsMethodID,
        inputs: Input,
        *,
        step_limit: int,
        security_config: object | None,
    ) -> RunResult: ...

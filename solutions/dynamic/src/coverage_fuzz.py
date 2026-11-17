"""Coverage-guided campaigns independent of any interpreter implementation."""

import math
import random
import time
from collections import Counter
from collections.abc import Callable, Iterable
from dataclasses import dataclass
from itertools import islice
from typing import Literal

from fuzz_contract import Runner, Violation
from fuzz_inputs import InputSpace

import jvm
from jpamb.case import Input
from jvm.state import PC

StopReason = Literal["executions", "steps", "deadline", "input-exhausted"]
Mutator = Callable[[Input, random.Random], Input]


@dataclass(frozen=True)
class FuzzConfig:
    max_executions: int = 1000
    step_limit: int = 200
    max_steps: int | None = None
    timeout_seconds: float | None = None
    seed: int = 0
    seed_limit: int = 32

    def __post_init__(self):
        for name in ("max_executions", "step_limit", "seed_limit"):
            value = getattr(self, name)
            minimum = 0 if name == "max_executions" else 1
            if type(value) is not int or value < minimum:
                raise ValueError(f"{name} must be an integer >= {minimum}")
        if self.max_steps is not None and (
            type(self.max_steps) is not int or self.max_steps < 0
        ):
            raise ValueError("max_steps must be a non-negative integer")
        if self.timeout_seconds is not None and (
            not math.isfinite(self.timeout_seconds) or self.timeout_seconds <= 0
        ):
            raise ValueError("timeout_seconds must be finite and positive")
        if type(self.seed) is not int:
            raise ValueError("seed must be an integer")


class Corpus:
    """Retain inputs that expand cumulative coverage, plus one initial fallback."""

    def __init__(self):
        self.inputs: list[Input] = []
        self.coverage: set[PC] = set()
        self._known: set[Input] = set()

    def consider(self, inputs: Input, coverage: frozenset[PC]) -> bool:
        interesting = not self.inputs or bool(coverage - self.coverage)
        self.coverage.update(coverage)
        if interesting and inputs not in self._known:
            self.inputs.append(inputs)
            self._known.add(inputs)
            return True
        return False


@dataclass(frozen=True)
class Finding:
    inputs: Input
    violation: Violation
    execution: int
    total_steps: int
    step_limit: int


@dataclass(frozen=True)
class FuzzResult:
    method_id: jvm.AbsMethodID
    config: FuzzConfig
    security_config: object | None
    corpus: tuple[Input, ...]
    coverage: frozenset[PC]
    findings: tuple[Finding, ...]
    outcomes: frozenset[str]
    executions: int
    steps: int
    completed_runs: int
    limited_runs: int
    unsupported_runs: int
    stop_reason: StopReason
    elapsed_seconds: float


def fuzz(
    method_id: jvm.AbsMethodID,
    input_space: InputSpace,
    runner: Runner,
    *,
    config: FuzzConfig | None = None,
    security_config: object | None = None,
    seeds: Iterable[Input] | None = None,
    mutator: Mutator | None = None,
    clock: Callable[[], float] = time.monotonic,
) -> FuzzResult:
    """Explore a method using observations from an injected concrete runner.

    Seeds and repeated candidates count against budgets. Partial coverage from
    unsupported/limited runs remains useful, but cannot establish an outcome.
    The deadline is cooperative: checked between calls, not an interrupt of an
    in-flight runner. The adapter must enforce the instruction limit itself.
    """
    if tuple(method_id.extension.params) != input_space.parameters:
        raise ValueError("input space does not match the method signature")
    config = config or FuzzConfig()
    rand = random.Random(config.seed)
    pending = iter(
        islice(
            seeds if seeds is not None else input_space.seeds(config.seed_limit),
            config.seed_limit,
        )
    )
    mutate = mutator if mutator is not None else input_space.mutate
    corpus = Corpus()
    findings: dict[tuple, Finding] = {}
    outcomes: set[str] = set()
    counts: Counter[str] = Counter()
    executions = steps = 0
    started = clock()
    deadline = (
        started + config.timeout_seconds if config.timeout_seconds is not None else None
    )
    seeding = True

    while True:
        if executions >= config.max_executions:
            reason: StopReason = "executions"
            break
        if config.max_steps is not None and steps >= config.max_steps:
            reason = "steps"
            break
        if deadline is not None and clock() >= deadline:
            reason = "deadline"
            break
        if executions and not input_space.parameters:
            reason = "input-exhausted"
            break

        if seeding:
            try:
                candidate = next(pending)
            except StopIteration:
                seeding = False
        if not seeding:
            if corpus.inputs:
                candidate = mutate(rand.choice(corpus.inputs), rand)
            else:
                candidate = input_space.seeds(1)[0]
        input_space.validate(candidate)

        limit = config.step_limit
        if config.max_steps is not None:
            limit = min(limit, config.max_steps - steps)
        observed = runner(
            method_id, candidate, step_limit=limit, security_config=security_config
        )
        if observed.steps > limit:
            raise ValueError("runner exceeded the supplied instruction limit")
        executions += 1
        steps += observed.steps
        counts[observed.status] += 1
        corpus.consider(candidate, observed.coverage)
        if observed.outcome is not None:
            outcomes.add(observed.outcome)
        for violation in observed.violations:
            findings.setdefault(
                violation.fingerprint,
                Finding(candidate, violation, executions, steps, limit),
            )

    return FuzzResult(
        method_id=method_id,
        config=config,
        security_config=security_config,
        corpus=tuple(corpus.inputs),
        coverage=frozenset(corpus.coverage),
        findings=tuple(findings.values()),
        outcomes=frozenset(outcomes),
        executions=executions,
        steps=steps,
        completed_runs=counts["completed"],
        limited_runs=counts["step-limit"],
        unsupported_runs=counts["unsupported"],
        stop_reason=reason,
        elapsed_seconds=clock() - started,
    )

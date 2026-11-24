"""Reduced product of sign sets and signed JVM integer intervals."""

from __future__ import annotations

from collections.abc import Iterable
from dataclasses import dataclass
from enum import IntFlag

import sexpr
from jvm import BinaryOpr

from .interval import INT_MIN, Interval


class SignSet(IntFlag):
    NEGATIVE = 1
    ZERO = 2
    POSITIVE = 4
    ALL = NEGATIVE | ZERO | POSITIVE

    @classmethod
    def covering(cls, interval: Interval) -> SignSet:
        signs = cls(0)
        if interval.minimum < 0:
            signs |= cls.NEGATIVE
        if interval.minimum <= 0 <= interval.maximum:
            signs |= cls.ZERO
        if interval.maximum > 0:
            signs |= cls.POSITIVE
        return signs


SIGN_RANGES = {
    SignSet.NEGATIVE: Interval(None, -1),
    SignSet.ZERO: Interval.constant(0),
    SignSet.POSITIVE: Interval(1, None),
}


def _parts(interval: Interval, signs: SignSet) -> tuple[Interval, ...]:
    parts = []
    for sign, bounds in SIGN_RANGES.items():
        if sign & signs:
            part = interval.intersect(bounds)
            if part is not None:
                parts.append(part)
    return tuple(parts)


@dataclass(frozen=True)
class AbstractInt(sexpr.AsSExpr):
    """An integer must satisfy both constraints. Zero can be a hole in the interval."""

    interval: Interval
    signs: SignSet = SignSet.ALL

    def __post_init__(self):
        available = SignSet.covering(self.interval)
        signs = self.signs & available
        if not signs:
            raise ValueError("integer interval and sign set have no common value")
        object.__setattr__(self, "signs", signs)
        if signs != available:
            parts = _parts(self.interval, signs)
            object.__setattr__(
                self, "interval", Interval(parts[0].lower, parts[-1].upper)
            )

    @classmethod
    def top(cls) -> AbstractInt:
        return cls(Interval.top())

    @classmethod
    def constant(cls, value: int) -> AbstractInt:
        return cls(Interval.constant(value))

    def parts(self) -> tuple[Interval, ...]:
        """At most three intervals, each containing just one possible sign."""
        if self.signs in SIGN_RANGES:
            return (self.interval,)
        return _parts(self.interval, self.signs)

    def join(self, other: AbstractInt) -> AbstractInt:
        return AbstractInt(self.interval.join(other.interval), self.signs | other.signs)

    def widen(self, other: AbstractInt, thresholds: tuple[int, ...]) -> AbstractInt:
        return AbstractInt(
            self.interval.widen(other.interval, thresholds), self.signs | other.signs
        )

    @classmethod
    def enclose(cls, intervals: Iterable[Interval]) -> AbstractInt:
        """Least product value containing a nonempty collection of interval results."""
        it = iter(intervals)
        bounds = next(it)
        signs = SignSet.covering(bounds)
        for part in it:
            bounds = bounds.join(part)
            signs |= SignSet.covering(part)
        return cls(bounds, signs)

    def add_const(self, amount: int) -> AbstractInt:
        return self.enclose(p.add_const(amount) for p in self.parts())

    def negate(self) -> AbstractInt:
        # Only zero negates to zero. Negating INT_MIN wraps back to INT_MIN.
        signs = self.signs & SignSet.ZERO
        if self.signs & SignSet.POSITIVE or self.interval.minimum == INT_MIN:
            signs |= SignSet.NEGATIVE
        if self.signs & SignSet.NEGATIVE:
            signs |= SignSet.POSITIVE
        return AbstractInt(self.interval.negate(), signs)

    def cast(self, descriptor: str) -> AbstractInt:
        return self.enclose(p.cast(descriptor) for p in self.parts())

    def binary(self, operator: BinaryOpr, other: AbstractInt) -> AbstractInt | None:
        # Apply JVM arithmetic to each allowed sign combination. A zero divisor
        # has only an exceptional successor and contributes no normal result.
        right_parts = other.parts()
        if operator in (BinaryOpr.Div, BinaryOpr.Rem):
            right_parts = tuple(
                p for p in right_parts if p != SIGN_RANGES[SignSet.ZERO]
            )
            if not right_parts:
                return None
        return self.enclose(
            a.binary(operator, b) for a in self.parts() for b in right_parts
        )

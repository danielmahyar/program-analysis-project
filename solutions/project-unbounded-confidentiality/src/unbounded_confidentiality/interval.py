"""Intervals for signed JVM int values. An absent endpoint denotes infinity."""

from __future__ import annotations

from bisect import bisect_left, bisect_right
from dataclasses import dataclass

import sexpr
from jvm import BinaryOpr

INT_MIN = -(1 << 31)
INT_MAX = (1 << 31) - 1


def _quotient(a: int, b: int) -> int:
    """Integer division truncated toward zero, before JVM overflow handling."""
    magnitude = abs(a) // abs(b)
    return -magnitude if (a < 0) != (b < 0) else magnitude


@dataclass(frozen=True)
class Interval(sexpr.AsSExpr):
    lower: int | None
    upper: int | None

    def __post_init__(self):
        if not INT_MIN <= self.minimum <= self.maximum <= INT_MAX:
            raise ValueError("expected a nonempty interval of JVM integers")

    @property
    def minimum(self) -> int:
        return INT_MIN if self.lower is None else self.lower

    @property
    def maximum(self) -> int:
        return INT_MAX if self.upper is None else self.upper

    @classmethod
    def top(cls) -> Interval:
        return cls(None, None)

    @classmethod
    def constant(cls, n: int) -> Interval:
        return cls(n, n)

    def join(self, other: Interval) -> Interval:
        lower = (
            None
            if self.lower is None or other.lower is None
            else min(self.lower, other.lower)
        )
        upper = (
            None
            if self.upper is None or other.upper is None
            else max(self.upper, other.upper)
        )
        return Interval(lower, upper)

    def intersect(self, other: Interval) -> Interval | None:
        lower = max(self.minimum, other.minimum)
        upper = min(self.maximum, other.maximum)
        if lower > upper:
            return None
        return Interval(
            None if self.lower is None and other.lower is None else lower,
            None if self.upper is None and other.upper is None else upper,
        )

    def widen(self, other: Interval, thresholds: tuple[int, ...] = ()) -> Interval:
        """Round an expanding endpoint out to a sorted threshold or infinity."""
        lower, upper = self.lower, self.upper
        if other.lower is None:
            lower = None
        elif lower is not None and other.lower < lower:
            index = bisect_right(thresholds, other.lower)
            lower = thresholds[index - 1] if index else None
        if other.upper is None:
            upper = None
        elif upper is not None and other.upper > upper:
            index = bisect_left(thresholds, other.upper)
            upper = thresholds[index] if index < len(thresholds) else None
        return Interval(lower, upper)

    @staticmethod
    def _wrapped(
        low: int, high: int, minimum: int = INT_MIN, maximum: int = INT_MAX
    ) -> Interval:
        """Enclose a mathematical interval after JVM modular conversion."""
        modulus = maximum - minimum + 1
        low_cycle, low_offset = divmod(low - minimum, modulus)
        high_cycle, high_offset = divmod(high - minimum, modulus)
        if low_cycle == high_cycle:
            low, high = minimum + low_offset, minimum + high_offset
        else:
            # Crossing a wrap boundary includes both extreme machine values.
            low, high = minimum, maximum
        if (low, high) == (INT_MIN, INT_MAX):
            return Interval.top()
        return Interval(low, high)

    def add_const(self, n: int) -> Interval:
        return self._wrapped(self.minimum + n, self.maximum + n)

    def negate(self) -> Interval:
        return self._wrapped(-self.maximum, -self.minimum)

    def cast(self, to_descriptor: str) -> Interval:
        match to_descriptor:
            case "I" | "Z":
                return self
            case "B":
                return self._wrapped(self.minimum, self.maximum, -128, 127)
            case "S":
                return self._wrapped(self.minimum, self.maximum, -32768, 32767)
            case "C":
                return self._wrapped(self.minimum, self.maximum, 0, 65535)
            case _:
                raise ValueError(f"unsupported integer cast to {to_descriptor}")

    def binary(self, operator: BinaryOpr, other: Interval) -> Interval:
        a, b = self.minimum, self.maximum
        c, d = other.minimum, other.maximum
        match operator:
            case BinaryOpr.Add:
                return self._wrapped(a + c, b + d)
            case BinaryOpr.Sub:
                return self._wrapped(a - d, b - c)
            case BinaryOpr.Mul:
                products = (a * c, a * d, b * c, b * d)
                return self._wrapped(min(products), max(products))
            case BinaryOpr.Div:
                if c == d == 0:
                    return Interval.top()
                # Quotients can be extreme at either side of a zero divisor.
                divisors = {v for v in (c, d, -1, 1) if c <= v <= d and v != 0}
                quotients = [_quotient(v, w) for v in (a, b) for w in divisors]
                return self._wrapped(min(quotients), max(quotients))
            case BinaryOpr.Rem:
                if c == d == 0:
                    return Interval.top()
                if a == b and c == d:
                    return Interval.constant(a - _quotient(a, c) * c)
                # The remainder has the dividend's sign and magnitude < |divisor|.
                limit = max(abs(c), abs(d)) - 1
                return Interval(max(-limit, min(a, 0)), min(limit, max(b, 0)))
            case BinaryOpr.And:
                if a == b and c == d:
                    return Interval.constant(a & c)
                if a >= 0 or c >= 0:
                    bound = min(x for x, low in ((b, a), (d, c)) if low >= 0)
                    return Interval(0, bound)
            case BinaryOpr.Or | BinaryOpr.Xor:
                if a == b and c == d:
                    return Interval.constant(
                        a | c if operator == BinaryOpr.Or else a ^ c
                    )
            case BinaryOpr.Shl | BinaryOpr.Shr | BinaryOpr.Ushr if c == d:
                shift = c & 31
                if shift == 0:
                    return self
                if operator == BinaryOpr.Shl:
                    return self._wrapped(a << shift, b << shift)
                if operator == BinaryOpr.Shr:
                    return Interval(a >> shift, b >> shift)
                mask = (1 << 32) - 1
                if a < 0 <= b:
                    return Interval(0, mask >> shift)
                return Interval((a & mask) >> shift, (b & mask) >> shift)
        # Variable shifts and general bitwise operations can span the int range.
        return Interval.top()

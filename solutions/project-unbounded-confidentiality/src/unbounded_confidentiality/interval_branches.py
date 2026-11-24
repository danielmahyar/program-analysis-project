"""Refine both numeric constraints for each edge of an integer comparison."""

from .integer import AbstractInt
from .interval import Interval

NEGATED_CONDITION = {
    "eq": "ne",
    "ne": "eq",
    "lt": "ge",
    "le": "gt",
    "gt": "le",
    "ge": "lt",
}


def _exclude(interval: Interval, value: int) -> Interval | None:
    """Remove a singleton when the remaining values fit in one interval."""
    if interval.minimum == interval.maximum == value:
        return None
    if interval.minimum == value:
        return Interval(value + 1, interval.upper)
    if interval.maximum == value:
        return Interval(interval.lower, value - 1)
    # Removing an interior value leaves a hole that an interval cannot represent.
    return interval


def _ordered(
    left: Interval, right: Interval, *, strict: bool
) -> tuple[Interval, Interval] | None:
    """Project left < right (or left <= right) onto each operand."""
    gap = 1 if strict else 0
    upper = right.maximum - gap
    lower = left.minimum + gap
    if left.minimum > upper:
        return None
    if left.maximum > upper:
        left = Interval(left.lower, upper)
    if right.minimum < lower:
        right = Interval(lower, right.upper)
    return left, right


def refine_comparison(
    condition: str, left: Interval, right: Interval, *, same_operand: bool = False
) -> tuple[Interval, Interval] | None:
    """Return operand ranges on the edge where the comparison holds.

    An empty edge has no compatible operands. Callers can set same_operand
    when both expressions are known to denote the same concrete value.
    """
    if condition not in NEGATED_CONDITION:
        raise ValueError(f"unsupported comparison {condition!r}")
    if same_operand or condition == "eq":
        if condition in ("lt", "gt", "ne"):
            return None
        common = left.intersect(right)
        return (common, common) if common is not None else None
    if condition == "ne":
        if left.minimum == left.maximum:
            narrowed = _exclude(right, left.minimum)
            return (left, narrowed) if narrowed is not None else None
        if right.minimum == right.maximum:
            narrowed = _exclude(left, right.minimum)
            return (narrowed, right) if narrowed is not None else None
        return left, right
    if condition in ("le", "lt"):
        return _ordered(left, right, strict=condition == "lt")
    swapped = _ordered(right, left, strict=condition == "gt")
    return (swapped[1], swapped[0]) if swapped is not None else None


def refine_integers(
    condition: str, left: AbstractInt, right: AbstractInt, *, same_operand: bool = False
) -> tuple[AbstractInt, AbstractInt] | None:
    """Project each feasible pair back onto its operands, preserving zero exclusions."""
    left_results, right_results = [], []
    right_parts = right.parts()
    for a in left.parts():
        for b in right_parts:
            pair = refine_comparison(condition, a, b, same_operand=same_operand)
            if pair is not None:
                left_results.append(pair[0])
                right_results.append(pair[1])
    if not left_results:
        return None
    return AbstractInt.enclose(left_results), AbstractInt.enclose(right_results)

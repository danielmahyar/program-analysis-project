"""Immutable int/boolean inputs, executable constants, and typed mutations."""

import random
from dataclasses import dataclass

import jvm
from jpamb.case import Boolean, Input, Int

INT_MIN = -(1 << 31)
INT_MAX = (1 << 31) - 1


def signed_int(value: int) -> int:
    """Normalize mutations using JVM signed 32-bit wrapping."""
    return ((value - INT_MIN) % (1 << 32)) + INT_MIN


def interesting_integers(constants=()) -> tuple[int, ...]:
    values = [0, 1, -1, 2, -2, INT_MIN, INT_MAX]
    for constant in constants:
        if type(constant) is not int:
            raise ValueError("integer dictionary constants must be integers")
        values.extend(signed_int(constant + delta) for delta in (0, -1, 1))
    return tuple(dict.fromkeys(values))


@dataclass(frozen=True)
class InputSpace:
    parameters: tuple[jvm.Type, ...]
    dictionary: tuple[int, ...] = interesting_integers()

    def __post_init__(self):
        object.__setattr__(self, "parameters", tuple(self.parameters))
        object.__setattr__(self, "dictionary", tuple(dict.fromkeys(self.dictionary)))
        if any(not isinstance(p, (jvm.Int, jvm.Boolean)) for p in self.parameters):
            raise ValueError(
                "fuzzing currently supports only int and boolean parameters"
            )
        if not self.dictionary or any(
            type(v) is not int or not INT_MIN <= v <= INT_MAX for v in self.dictionary
        ):
            raise ValueError("the dictionary needs signed 32-bit integers")

    @classmethod
    def from_method(cls, method: jvm.Method) -> "InputSpace":
        # No policy/case metadata is consulted. Only executable constants count.
        constants = []
        for op in method.opcodes:
            if isinstance(op, jvm.Push) and isinstance(op.type, jvm.Int):
                constants.append(op.value)
            elif isinstance(op, jvm.Incr):
                constants.append(op.amount)
        return cls(tuple(method.id.extension.params), interesting_integers(constants))

    def validate(self, inputs: Input) -> None:
        if not isinstance(inputs, Input) or not isinstance(inputs.values, tuple):
            raise TypeError(
                "inputs must be a jpamb Input with an immutable values tuple"
            )
        if len(inputs.values) != len(self.parameters):
            raise ValueError("input arity does not match the method signature")
        for parameter, value in zip(self.parameters, inputs.values):
            if isinstance(parameter, jvm.Boolean):
                valid = isinstance(value, Boolean) and type(value.value) is bool
            else:
                valid = (
                    isinstance(value, Int)
                    and type(value.value) is int
                    and INT_MIN <= value.value <= INT_MAX
                )
            if not valid:
                raise ValueError(f"invalid value {value!r} for {parameter}")

    def seeds(self, limit: int = 32) -> tuple[Input, ...]:
        """Bounded seeds; no Cartesian expansion over argument combinations."""
        if type(limit) is not int or limit < 1:
            raise ValueError("seed limit must be a positive integer")
        zero = Input(
            tuple(
                Boolean(False) if isinstance(p, jvm.Boolean) else Int(0)
                for p in self.parameters
            )
        )
        seeds = [zero]
        for index, parameter in enumerate(self.parameters):
            replacements = (
                (Boolean(True),)
                if isinstance(parameter, jvm.Boolean)
                else (Int(1), Int(-1))
            )
            for replacement in replacements:
                if len(seeds) >= limit:
                    return tuple(seeds)
                values = list(zero.values)
                values[index] = replacement
                seeds.append(Input(tuple(values)))
        return tuple(seeds)

    def mutate(self, inputs: Input, rand: random.Random) -> Input:
        self.validate(inputs)
        if not self.parameters:
            return inputs
        values = list(inputs.values)
        count = 1
        if len(values) > 1 and rand.random() < 0.15:
            count = rand.randint(2, len(values))
        for index in rand.sample(range(len(values)), count):
            value = values[index]
            if isinstance(value, Boolean):
                values[index] = Boolean(not value.value)
                continue
            operation = rand.randrange(4)
            match operation:
                case 0:
                    changed = value.value + rand.choice((-32, -8, -2, -1, 1, 2, 8, 32))
                case 1:
                    changed = rand.choice(self.dictionary)
                case 2:
                    changed = value.value ^ (1 << rand.randrange(32))
                case _:
                    changed = rand.randint(INT_MIN, INT_MAX)
            changed = signed_int(changed)
            # Keep a selected argument mutation effective, even for a repeat draw.
            if changed == value.value:
                changed = signed_int(changed + 1)
            values[index] = Int(changed)
        return Input(tuple(values))

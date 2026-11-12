"""Read the security labels for a case before running it in a dynamic interpreter.

This uses the same setup as `dynamic.py`'s `interpret()`, but it stops right
after the labels are attached to the initial state, so you can see what the
interpreter would start from. Nothing is executed.

    uv run python solutions/dynamic/src/read_labels.py \
        'jpamb.cases.InfoFlow.explicitLeak:(I)V' '(42)' 100
"""

import sys

import jpamb
import jvm


def main():
    # 1. Same entry point as the interpreter: method id, concrete input, step budget.
    methodid, input, max_steps = jpamb.getcase(
        "dynamic-labels", "1.0", "The Rice Theorem Cookers", ["dynamic"], for_science=False
    )
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})

    # 2. Read @Lattice / @Sec / @Case from target/decompiled/<Class>.json.
    policy = suite.security_policy(methodid.classname, eff=eff)
    if policy is None:
        print(f"{methodid.classname} declares no @Lattice: ordinary case, no labels.")
        return

    lattice = policy.product_lattice
    method = policy.method(methodid)  # MethodSecurityPolicy of the case being run

    print(f"case     {methodid}")
    print(f"lattices", {d: l.levels for d, l in lattice.lattices.items()})
    print(f"bottom   {lattice.bot}   (label of constants)")

    # 3. Initial shadow locals: one label per local slot, aligned with frame.locals.
    #    Parameters get their @Sec label (missing dimensions get their default level);
    #    every other slot is None until the program writes to it.
    max_locals = suite.method_max_locals(methodid, eff=eff)
    labels = method.initial_locals(lattice, max_locals, uninitialized=True)

    print("\ninitial locals (value, label):")
    values = dict(zip(method.param_slots, input.values))
    for slot, label in enumerate(labels):
        print(f"  local[{slot}] = {values.get(slot, '-')!s:>8}   label {label}")

    print(f"\nreturn clearance: {method.return_clearance}")  # None = unchecked

    # 4. Sinks: where the interpreter must check a label against a clearance.
    #    Look them up at each invoke while stepping; here we just list them.
    print("\nsink calls in this method:")
    for op in bc.getmethod(methodid).opcodes:
        if isinstance(op, (jvm.InvokeStatic, jvm.InvokeVirtual, jvm.InvokeSpecial)):
            sink = policy.sink(op.method)
            if sink is not None:
                clearances = ", ".join(str(c) for c in sink.param_labels)
                print(f"  offset {op.offset}: {sink.name} needs args <= ({clearances})")

    # 5. The check the interpreter does at such an invoke, shown on the first parameter.
    if method.param_labels and policy.sinks:
        sink = next(iter(policy.sinks.values()))
        arg = method.param_labels[0]
        ok = lattice.le(arg, sink.param_labels[0])
        print(f"\nexample: passing {arg} to {sink.name}: "
              f"{'ok' if ok else 'leak -> assertion error'}")


if __name__ == "__main__":
    main()

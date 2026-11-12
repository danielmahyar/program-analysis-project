"""A tiny label-tracking interpreter that shows how an `if` in bytecode raises the
security context (the "pc label") and where it is lowered again.

It mirrors what jpamb's SecurityMonitor does on the JVM:

  * every value on the stack and in a local carries a label next to it;
  * at an `if`, the condition's label is pushed onto a pc stack, together with
    the branch's merge point (its immediate post-dominator, "ipdom");
  * while that entry is on the stack, every constant, load, store and sink call
    is joined with the pc label;
  * when execution reaches the ipdom, the entry is popped: the context is restored.

Only the handful of opcodes the InfoFlow branch cases use are supported.

    uv run python solutions/dynamic/src/branch_labels.py \
        'jpamb.cases.InfoFlow.implicitLeak:(Z)V' '(true)' 100
"""

import jpamb
import jvm
from jpamb.confidentiality import control_flow, postdominators
from jpamb.security import SecurityLabel


def immediate_postdominators(opcodes) -> list[int]:
    """ipdom[i] = the instruction where all paths leaving branch i meet again."""
    pdom = postdominators(control_flow(opcodes))
    ipdom = []
    for i in range(len(opcodes)):
        strict = pdom[i] - {i}
        # The closest strict post-dominator is the one post-dominated by all the others.
        ipdom.append(next(d for d in strict if pdom[d] == strict))
    return ipdom


def holds(cond: jvm.CmpOpr, a: int, b: int) -> bool:
    return {
        jvm.CmpOpr.Eq: a == b, jvm.CmpOpr.Ne: a != b,
        jvm.CmpOpr.Lt: a < b, jvm.CmpOpr.Le: a <= b,
        jvm.CmpOpr.Gt: a > b, jvm.CmpOpr.Ge: a >= b,
    }[cond]


def main():
    methodid, input, max_steps = jpamb.getcase(
        "branch-labels", "1.0", "The Rice Theorem Cookers", ["dynamic"], for_science=False
    )
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})
    method = bc.getmethod(methodid)
    opcodes = method.opcodes

    # --- Labels from the annotations (see read_labels.py) ------------------
    policy = suite.security_policy(methodid.classname, eff=eff)
    lat = policy.product_lattice
    mpol = policy.method(methodid)
    bot: SecurityLabel = lat.bot

    ipdom = immediate_postdominators(opcodes)

    # --- Concrete state with a shadow label for every value ----------------
    locals_: dict[int, tuple[int, SecurityLabel]] = {}
    for slot, label, v in zip(mpol.param_slots, mpol.param_labels, input.values):
        locals_[slot] = (int(v.value), label)  # booleans become 0/1 like on the JVM
    stack: list[tuple[int, SecurityLabel]] = []
    pc_stack: list[tuple[int, SecurityLabel]] = []  # (ipdom, pc label)

    def pc_label() -> SecurityLabel:
        return pc_stack[-1][1] if pc_stack else bot

    i = 0
    for _ in range(max_steps):
        # 1. Leaving a branch scope: pop every context whose merge point we reached.
        while pc_stack and pc_stack[-1][0] == i:
            merged_at, old = pc_stack.pop()
            print(f"      -- reached merge point {merged_at}: pc {old} -> {pc_label()}")

        op = opcodes[i]
        print(f"[{i:2}] pc={str(pc_label()):18} {type(op).__name__:12}", end=" ")
        nxt = i + 1

        match op:
            case jvm.Push(value=v):
                # A constant is public, but *where* it is pushed is not.
                stack.append((v, lat.join(bot, pc_label())))

            case jvm.Load(index=n):
                val, lbl = locals_.get(n, (0, bot))
                stack.append((val, lat.join(lbl, pc_label())))

            case jvm.Store(index=n):
                val, lbl = stack.pop()
                locals_[n] = (val, lat.join(lbl, pc_label()))  # implicit flow lands here
                print(f"local[{n}] := {val} : {locals_[n][1]}", end="")

            case jvm.Ifz(condition=c, target=t) | jvm.If(condition=c, target=t):
                if isinstance(op, jvm.If):
                    (b, lb), (a, la) = stack.pop(), stack.pop()
                    cond_label = lat.join(la, lb)
                else:
                    (a, cond_label), b = stack.pop(), 0
                # 2. Entering a branch: raise the context until the merge point.
                new_pc = lat.join(pc_label(), cond_label)
                pc_stack.append((ipdom[i], new_pc))
                taken = holds(c, a, b)
                nxt = t if taken else i + 1
                print(f"cond {cond_label} -> pc {new_pc} until [{ipdom[i]}], "
                      f"{'jump' if taken else 'fall through'} to [{nxt}]", end="")

            case jvm.Goto(target=t):
                nxt = t

            case jvm.InvokeStatic(method=callee):
                sink = policy.sink(callee)
                if sink is None:
                    raise NotImplementedError(f"only sink calls are supported: {callee}")
                n = len(sink.param_labels)
                args = stack[len(stack) - n:]
                del stack[len(stack) - n:]
                for (val, lbl), clearance in zip(args, sink.param_labels):
                    # 3. A sink sees the value's label joined with the context.
                    effective = lat.join(lbl, pc_label())
                    ok = lat.le(effective, clearance)
                    print(f"{sink.name}({val}): {effective} <= {clearance}? {ok}")
                    if not ok:
                        print("=> assertion error")
                        return

            case jvm.Return():
                print("\n=> ok")
                return

            case other:
                raise NotImplementedError(other)
        print()
        i = nxt

    print("=> *")


if __name__ == "__main__":
    main()

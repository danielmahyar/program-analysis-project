import random
import sys

import jpamb
import jvm
import jvm.state as jvmc


def binary(op, v1: int, v2: int) -> int | str:
    match op:
        case jvm.BinaryOpr.Div:
            try:
                return v1 // v2
            except ZeroDivisionError:
                return "divide by zero"
        case jvm.BinaryOpr.Sub:
            return v1 - v2
        case jvm.BinaryOpr.Add:
            return v1 + v2
        case jvm.BinaryOpr.Mul:
            return v1 * v2
        case jvm.BinaryOpr.Rem:
            return v1 % v2
        case a:
            raise NotImplementedError(f"Unhandled binary {op!r}")

def is_array_ref_null(ref: jvmc.StackReference):
    return ref.value == 0
    

def compare(op, v1: int, v2: int) -> bool:
    match op:
        case jvm.CmpOpr.Eq:
            return v1 == v2
        case jvm.CmpOpr.Ne:
            return v1 != v2
        case jvm.CmpOpr.Lt:
            return v1 < v2
        case jvm.CmpOpr.Gt:
            return v1 > v2
        case jvm.CmpOpr.Le:
            return v1 <= v2
        case jvm.CmpOpr.Ge:
            return v1 >= v2
        case _:
            raise NotImplementedError(f"Unhandled comparation {op!r}")


def step(bc: jpamb.Bytecode, state: jvmc.State) -> tuple[jvmc.PC, jvmc.State | str]:
    assert isinstance(state, jvmc.State), f"expected state but got {state}"
    frame = state.frames.peek()
    locals = frame.locals
    pc = frame.pc
    opr = bc[pc]
    output = state
    print(f"Stepping {pc}:\n > {opr}", file=sys.stderr)
    match opr:
        case jvm.Dup():
            # duplicate the value on top of the stack
            dup = frame.stack.pop()
            frame.stack.push(dup)
            frame.stack.push(dup)
            frame.pc += 1
        
        case jvm.Goto(target=target):
            frame.pc %= target
            
        case jvm.Store(type=t, index=i):
            if frame.stack.__sizeof__() == 0:
                raise ValueError(f"There is no int in Operand Stack to store in locals {i}")
            val = frame.stack.pop()
            frame.locals[i] = val
            frame.pc += 1
            
        case jvm.Cast(from_=f, to_=t):
            match f, t:
                case jvm.Int(), jvm.Short():
                    v = frame.stack.pop()
                    if not isinstance(v, jvmc.StackInt):
                        raise ValueError("Must be integer [i2s]")
                    print(f"Before {v}", file=sys.stderr)
                    # Extract 16 last bits
                    nv = v.value & (0xFFFF)
                    print(f"After {nv}", file=sys.stderr) 
                    frame.stack.push(jvmc.StackInt(nv))
                
                case _,_: 
                    raise NotImplementedError(f"Missing casting from {f} to {t}")

            frame.pc += 1
        
        case jvm.NewArray(type=t, dim=d):
            count = frame.stack.pop()
            if not isinstance(count, jvmc.StackInt):
                raise ValueError("Count is not value")

            arr = [0 for _ in range(count.value)]
            heaparr = jvmc.HeapArray(t, arr)
            ref = state.heap.new(heaparr)
            frame.stack.push(ref)
            frame.pc += 1
            pass
        
        case jvm.ArrayStore(type=t):
            value, index, arrayref = frame.stack.pop(), frame.stack.pop(), frame.stack.pop()
            if not isinstance(arrayref, jvmc.StackReference):
                raise ValueError("Reference is not reference")
            
            if is_array_ref_null(arrayref):
                output = "null pointer"
                return frame.pc, output
            
            if not isinstance(index, jvmc.StackInt):
                raise ValueError("Index not an integer")
            
            if not isinstance(value, jvmc.StackInt):
                raise ValueError(f"Value is not a reference {value}")

            array = state.heap.memory[arrayref.value - 1]
            if not isinstance(array, jvmc.HeapArray) :
                raise ValueError("Reference did not point to Array")
            
            if index.value >= array.values.__len__():
                output = "out of bounds"
                return frame.pc, output
            
            array.values[index.value] = value.value

            frame.pc += 1 
       
        case jvm.ArrayLength():
            arrayref = frame.stack.pop()
            if not isinstance(arrayref, jvmc.StackReference):
                raise ValueError("Reference is not reference")
            if is_array_ref_null(arrayref):
                output = "null pointer"
                return frame.pc, output
            
            l = state.heap.memory[arrayref.value - 1]
            if not isinstance(l, jvmc.HeapArray):
                raise ValueError("Expected arary")
            frame.stack.push(jvmc.StackInt(l.values.__len__()))
            frame.pc += 1
            
        case jvm.ArrayLoad(type=t):
            index, ref = frame.stack.pop(), frame.stack.pop()
            if not isinstance(ref, jvmc.StackReference):
                raise ValueError("Reference is not reference")
            if not isinstance(index, jvmc.StackInt):
                raise ValueError("Index not an integer")
            
            array = state.heap.memory[ref.value - 1]
            
            if not isinstance(array, jvmc.HeapArray):
                raise ValueError("Expected arary")

            if index.value >= array.values.__len__():
                output = "out of bounds"
                return frame.pc, output
            val = array.values[index.value]
            frame.stack.push(jvmc.StackInt(val))
            frame.pc += 1 
        
        case jvm.InvokeStatic(method=methodid): 
            method = bc.getmethod(methodid)
            child = jvmc.Frame.from_method(method)
            # We need to create new frame and push it to the stack, but we also need to pop the arguments from the stack and put them in the new frame's locals
            for i in range(methodid.extension.params.__len__() - 1, -1, -1):
                arg = frame.stack.pop()
                child.locals[i] = arg
                
            # Now we make sure to push the new frame to the stack
            state.frames.push(child)
            # This should make sure that the next step will be in the new frame
            frame.pc += 1
            pass
        
        case jvm.Incr(index=i,amount=a):
            val = frame.locals.locals[i]
            if not isinstance(val, jvmc.StackInt):
                raise ValueError("Can not use incremenet on non-integer value")
            
            frame.locals.locals[i] = jvmc.StackInt(val.value + a)
            frame.pc += 1 

        case jvm.Load(type=t, index=i):
            local_variable = locals[i] 
            frame.stack.push(local_variable)
            frame.pc += 1
            pass 
        
        case jvm.If(condition=op, target=target):
            v2, v1 = frame.stack.pop(), frame.stack.pop()
            if not isinstance(v1, jvmc.StackInt) or not isinstance(v2, jvmc.StackInt):
                raise ValueError(f"Expected int but got {v1} and {v2}")
            
            if compare(op, v1.value, v2.value):
                frame.pc %= target
            else:
                frame.pc += 1
        
        case jvm.Ifz(condition=op, target=target):
            print(f"Condition: {op}, target: {target}", file=sys.stderr)
            cond = frame.stack.pop()
            if not isinstance(cond, jvmc.StackInt):
                raise ValueError(f"Expected int but got {cond}")
            if compare(op, cond.value, 0):
                frame.pc %= target
            else:
                frame.pc += 1
                
        case jvm.Push(type=t, value=v):
            print(f"{t} and {v}", file=sys.stderr)
            match t:
                case jvm.Reference():
                    if not isinstance(v, int):
                        raise ValueError("null ref not int")

                    frame.stack.push(jvmc.StackReference(v))
                case jvm.Int():
                    if not isinstance(v, int):
                        raise ValueError("Expected int")
                    frame.stack.push(jvmc.StackInt(v))
                case jvm.Object(jvm.ClassName("java.lang.String")):
                    if not isinstance(v, str):
                        raise ValueError("Expected string")
                    frame.stack.push(state.heap.new(jvmc.HeapString(v)))
            frame.pc += 1

        case jvm.InvokeVirtual(method=methodid):
            if methodid.extension.name != "equals":
                raise NotImplementedError(f"Unhandled virtual method {methodid}")

            argument = frame.stack.pop()
            receiver = frame.stack.pop()
            if not isinstance(receiver, jvmc.StackReference):
                raise ValueError("String receiver is not a reference")
            if not isinstance(argument, jvmc.StackReference):
                raise ValueError("String argument is not a reference")

            if receiver.value == 0:
                output = "null pointer"
            elif argument.value == 0:
                frame.stack.push(jvmc.StackInt(0))
                frame.pc += 1
            else:
                receiver_value = state.heap[receiver]
                argument_value = state.heap[argument]
                if not isinstance(receiver_value, jvmc.HeapString):
                    raise ValueError("String receiver does not reference a string")
                if not isinstance(argument_value, jvmc.HeapString):
                    frame.stack.push(jvmc.StackInt(0))
                else:
                    frame.stack.push(
                        jvmc.StackInt(
                            1 if receiver_value.content == argument_value.content else 0
                        )
                    )
                frame.pc += 1
        
        case jvm.Negate(type=t):
            # We have to negate the first int in top of stack
            val = frame.stack.pop()
            
            if not isinstance(val, jvmc.StackInt):
                raise ValueError("The value on top of Op Stack is not an int")
            
            negated = val.value * (-1)
            frame.stack.push(jvmc.StackInt(negated))
            frame.pc += 1 

        case jvm.Binary(type=jvm.Int(), operant=op):
            v2, v1 = frame.stack.pop(), frame.stack.pop()
            assert isinstance(v1, jvmc.StackInt), f"expected int, but got {v1}"
            assert isinstance(v2, jvmc.StackInt), f"expected int, but got {v2}"

            value = binary(op, v1.value, v2.value)

            if isinstance(value, str):
                output = value
            else:
                frame.stack.push(jvmc.StackInt(value))
                frame.pc += 1

        case jvm.Return(type=t):
            child = state.frames.pop()

            if state.frames:
                if t is not None:
                    value = child.stack.pop()
                    state.frames.peek().stack.push(value)
                output = state
            else:
                output = "ok"

        case jvm.Get(static=True, field=field):
            # Hack - Only handle the assertion case
            assert field.extension.name == "$assertionsDisabled"

            # Hack - Assuming assertions are never disabled
            frame.stack.push(jvmc.StackInt(0))
            frame.pc += 1

        case jvm.New(classname=jvm.ClassName("java.lang.AssertionError")):
            # Hack -- if we create an assertion error, we probably also throw it.
            output = "assertion error"

        case a:
            raise NotImplementedError(a.help())

    assert isinstance(output, (jvmc.State, str))

    return pc, output


def initial(bc: jpamb.Bytecode, methodid: jvm.AbsMethodID, input: jpamb.Input):
    frame = jvmc.Frame.from_method(bc.getmethod(methodid))
    state = jvmc.State(jvmc.Heap(), jvmc.CallStack.from_frames([frame]))
    for i, v in enumerate(input.values):
        # Convert arbitrary values into local values
        match v:
            case jpamb.case.Boolean(value):
                frame.locals[i] = jvmc.StackInt(1 if value else 0)
            case jpamb.case.Int(value):
                frame.locals[i] = jvmc.StackInt(value)
            case jpamb.case.Array(contains=type, values=values):
                match type:
                    case jvm.Char():
                        ref = state.heap.new(
                            jvmc.HeapArray(type, [ord(a) for a in values])
                        )
                    case jvm.Int():
                        ref = state.heap.new(jvmc.HeapArray(type, [a for a in values]))
                frame.locals[i] = ref
            case jpamb.case.String(value=value):
                ref = state.heap.new(jvmc.HeapString(value))
                frame.locals[i] = ref
            case a:
                raise NotImplementedError(
                    f"Do not know how to convert values of type {a!r} to a local value"
                )

    return state


def interpret():
    """The entry point for the interpreter"""

    methodid, input, max_steps = jpamb.getcase(
        "dynamic",
        "1.0",
        "LineaRIZZability",
        ["dynamic", "python"],
        for_science=True,
    )

    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})

    state = initial(bc, methodid, input)

    last = jpamb.emit_init(state)

    for x in range(max_steps):
        pc, state = step(bc, state)
        last = jpamb.emit_step(last, pc, state)

        if isinstance(state, str):
            break


def fuzz_input(rand: random.Random, methodid: jvm.AbsMethodID) -> jpamb.case.Input:
    input = []
    # 1. come up with possible inputs
    for p in methodid.extension.params:
        match p:
            case jvm.Int():
                input.append(jpamb.case.Int(rand.randint(-(1 << 31), 1 << 31)))
            case jvm.Boolean():
                input.append(jpamb.case.Boolean(1 == rand.randint(0, 1)))
            case jvm.Object(jvm.ClassName("java.lang.String")):
                length = rand.randint(0, 10)
                value = "".join(chr(rand.randint(0, 255)) for _ in range(length))
                input.append(jpamb.case.String(value))
            case jvm.Array(contains=jvm.Int()):
                length = rand.randint(0, 10)
                values = [rand.randint(-(1 << 31), 1 << 31) for _ in range(length)]
                input.append(jpamb.case.Array(contains=jvm.Int(), values=values))
            case jvm.Array(contains=jvm.Char()):
                length = rand.randint(0, 10)
                values = [chr(rand.randint(0, 255)) for _ in range(length)]
                input.append(jpamb.case.Array(contains=jvm.Char(), values=values))
            case a:
                
                raise NotImplementedError(
                    f"Don't know how to create random values for {a}"
                )

    return jpamb.case.Input(input)


def analyse():
    """The dynamic analysis, e.g. in this case a (dumb) fuzzer."""

    methodid = jpamb.getmethodid(
        "dynamic",
        "1.0",
        "LineaRIZZability",
        ["dynamic", "python"],
        for_science=True,
    )

    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})

    MAX_STEPS = 200

    import random

    # Make the randomness deterministic
    rand = random.Random(0)

    behaviors = set()
    # Try 10 random inputs
    for i in range(100):
        input = fuzz_input(rand, methodid)
        state = initial(bc, methodid, input)

        for x in range(MAX_STEPS):
            _, state = step(bc, state)
            if isinstance(state, str):
                behaviors.add(state)
                break

    for query in jpamb.QUERIES:
        if query in behaviors:
            if query == "*":
                print(f"{query};timeout")
            else:
                print(f"{query};found")
        else:
            print(f"{query};not-found")

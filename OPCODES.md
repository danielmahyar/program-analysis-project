#Bytecode instructions
| Mnemonic | Opcode Name |  Exists in |  Count |
| :---- | :---- | :----- | -----: |
| [iload_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iload_n) | [Load](src/jvm/opcode.py?plain=1#L808) |  Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Loops Simple Tricky | 658 |
| [iconst_i](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iconst_i) | [Push](src/jvm/opcode.py?plain=1#L102) |  Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow Loops Simple Tricky | 456 |
| [istore_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.istore_n) | [Store](src/jvm/opcode.py?plain=1#L637) |  Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow Loops Tricky | 282 |
| [return](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.return) | [Return](src/jvm/opcode.py?plain=1#L1198) |  Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Loops Simple Strings Tricky | 264 |
| [invokestatic](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.invokestatic) | [InvokeStatic](src/jvm/opcode.py?plain=1#L514) |  BasicLeaks Calls Clearance Compartments Hospital InfoFlow InformationFlow | 223 |
| [if_cond](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.if_cond) | [Ifz](src/jvm/opcode.py?plain=1#L976) |  Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Loops Simple Strings Tricky | 219 |
| [dup](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.dup) | [Dup](src/jvm/opcode.py?plain=1#L258) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 132 |
| [if_icmp_cond](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.if_icmp_cond) | [If](src/jvm/opcode.py?plain=1#L847) |  Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Simple Tricky | 129 |
| [ldc](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.ldc) | [Push](src/jvm/opcode.py?plain=1#L102) |  Arrays Calls Dependent Hospital InfoFlow Simple Strings | 95 |
| [getstatic](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.getstatic) | [Get](src/jvm/opcode.py?plain=1#L914) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 82 |
| [new](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.new) | [New](src/jvm/opcode.py?plain=1#L1046) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 82 |
| [invokespecial](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.invokespecial) | [InvokeSpecial](src/jvm/opcode.py?plain=1#L587) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 82 |
| [athrow](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.athrow) | [Throw](src/jvm/opcode.py?plain=1#L1088) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 82 |
| [iadd](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iadd) | [Binary](src/jvm/opcode.py?plain=1#L762) |  Arrays BasicLeaks Clearance Compartments Hospital InfoFlow Loops Simple Tricky | 78 |
| [aload_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.aload_n) | [Load](src/jvm/opcode.py?plain=1#L808) |  Arrays Calls Strings | 70 |
| [goto](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.goto) | [Goto](src/jvm/opcode.py?plain=1#L1158) |  Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow Loops Tricky | 70 |
| [ireturn](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.ireturn) | [Return](src/jvm/opcode.py?plain=1#L1198) |  BasicLeaks Dependent Hospital InfoFlow Loops Simple | 65 |
| [iastore](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iastore) | [ArrayStore](src/jvm/opcode.py?plain=1#L341) |  Arrays | 59 |
| [idiv](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.idiv) | [Binary](src/jvm/opcode.py?plain=1#L762) |  Arrays Dependent Hospital Loops Simple Tricky | 47 |
| [astore_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.astore_n) | [Store](src/jvm/opcode.py?plain=1#L637) |  Arrays Calls | 27 |
| [isub](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.isub) | [Binary](src/jvm/opcode.py?plain=1#L762) |  Arrays Dependent Hospital InfoFlow Simple | 26 |
| [arraylength](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.arraylength) | [ArrayLength](src/jvm/opcode.py?plain=1#L445) |  Arrays Calls | 21 |
| [caload](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.caload) | [ArrayLoad](src/jvm/opcode.py?plain=1#L411) |  Arrays | 20 |
| [iaload](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iaload) | [ArrayLoad](src/jvm/opcode.py?plain=1#L411) |  Arrays Calls | 17 |
| [newarray](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.newarray) | [NewArray](src/jvm/opcode.py?plain=1#L224) |  Arrays | 16 |
| [iload](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iload) | [Load](src/jvm/opcode.py?plain=1#L808) |  Arrays Calls | 16 |
| [iinc](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iinc) | [Incr](src/jvm/opcode.py?plain=1#L1125) |  Arrays Calls Dependent | 14 |
| [ineg](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.ineg) | [Negate](src/jvm/opcode.py?plain=1#L194) |  Dependent | 10 |
| [imul](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.imul) | [Binary](src/jvm/opcode.py?plain=1#L762) |  InfoFlow Simple Tricky | 10 |
| [aconst_null](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.aconst_null) | [Push](src/jvm/opcode.py?plain=1#L102) |  Arrays | 7 |
| [istore](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.istore) | [Store](src/jvm/opcode.py?plain=1#L637) |  Arrays Calls | 7 |
| [invokevirtual](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.invokevirtual) | [InvokeVirtual](src/jvm/opcode.py?plain=1#L479) |  Strings | 3 |
| [irem](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.irem) | [Binary](src/jvm/opcode.py?plain=1#L762) |  Tricky | 3 |
| [i2s](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.i2s) | [Cast](src/jvm/opcode.py?plain=1#L373) |  Loops | 2 |

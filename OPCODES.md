#Bytecode instructions
| Mnemonic | Opcode Name |  Exists in |  Count |
| :---- | :---- | :----- | -----: |
| [iload_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iload_n) | [Load](src/jvm/opcode.py?plain=1#L808) |  AdvancedLeaks Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Loops Simple Tricky | 752 |
| [iconst_i](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iconst_i) | [Push](src/jvm/opcode.py?plain=1#L102) |  AdvancedLeaks Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow Loops Simple Tricky | 596 |
| [istore_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.istore_n) | [Store](src/jvm/opcode.py?plain=1#L637) |  AdvancedLeaks Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow Loops Tricky | 325 |
| [return](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.return) | [Return](src/jvm/opcode.py?plain=1#L1198) |  AdvancedLeaks Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Loops Simple Strings Tricky | 299 |
| [invokestatic](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.invokestatic) | [InvokeStatic](src/jvm/opcode.py?plain=1#L514) |  AdvancedLeaks BasicLeaks Calls Clearance Compartments Hospital InfoFlow InformationFlow | 253 |
| [if_cond](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.if_cond) | [Ifz](src/jvm/opcode.py?plain=1#L976) |  AdvancedLeaks Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Loops Simple Strings Tricky | 236 |
| [if_icmp_cond](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.if_icmp_cond) | [If](src/jvm/opcode.py?plain=1#L847) |  AdvancedLeaks Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow InformationFlow Simple Tricky | 219 |
| [ldc](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.ldc) | [Push](src/jvm/opcode.py?plain=1#L102) |  AdvancedLeaks Arrays Calls Dependent Hospital InfoFlow Simple Strings | 138 |
| [iload](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iload) | [Load](src/jvm/opcode.py?plain=1#L808) |  AdvancedLeaks Arrays Calls | 136 |
| [dup](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.dup) | [Dup](src/jvm/opcode.py?plain=1#L258) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 128 |
| [iadd](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iadd) | [Binary](src/jvm/opcode.py?plain=1#L762) |  AdvancedLeaks Arrays BasicLeaks Clearance Compartments Hospital InfoFlow Loops Simple Tricky | 120 |
| [goto](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.goto) | [Goto](src/jvm/opcode.py?plain=1#L1158) |  AdvancedLeaks Arrays BasicLeaks Calls Clearance Compartments Dependent Hospital InfoFlow Loops Tricky | 99 |
| [getstatic](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.getstatic) | [Get](src/jvm/opcode.py?plain=1#L914) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 78 |
| [new](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.new) | [New](src/jvm/opcode.py?plain=1#L1046) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 78 |
| [invokespecial](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.invokespecial) | [InvokeSpecial](src/jvm/opcode.py?plain=1#L587) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 78 |
| [athrow](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.athrow) | [Throw](src/jvm/opcode.py?plain=1#L1088) |  Arrays Calls Dependent InformationFlow Loops Simple Strings Tricky | 78 |
| [aload_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.aload_n) | [Load](src/jvm/opcode.py?plain=1#L808) |  Arrays Calls Strings | 70 |
| [istore](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.istore) | [Store](src/jvm/opcode.py?plain=1#L637) |  AdvancedLeaks Arrays Calls | 67 |
| [ireturn](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.ireturn) | [Return](src/jvm/opcode.py?plain=1#L1198) |  BasicLeaks Dependent Hospital InfoFlow Loops Simple | 65 |
| [iastore](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iastore) | [ArrayStore](src/jvm/opcode.py?plain=1#L341) |  Arrays | 59 |
| [idiv](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.idiv) | [Binary](src/jvm/opcode.py?plain=1#L762) |  Arrays Dependent Hospital Loops Simple Tricky | 47 |
| [isub](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.isub) | [Binary](src/jvm/opcode.py?plain=1#L762) |  AdvancedLeaks Arrays Dependent Hospital InfoFlow Simple | 37 |
| [iinc](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iinc) | [Incr](src/jvm/opcode.py?plain=1#L1125) |  AdvancedLeaks Arrays Calls Dependent | 30 |
| [astore_n](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.astore_n) | [Store](src/jvm/opcode.py?plain=1#L637) |  Arrays Calls | 27 |
| [arraylength](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.arraylength) | [ArrayLength](src/jvm/opcode.py?plain=1#L445) |  Arrays Calls | 21 |
| [caload](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.caload) | [ArrayLoad](src/jvm/opcode.py?plain=1#L411) |  Arrays | 20 |
| [iaload](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.iaload) | [ArrayLoad](src/jvm/opcode.py?plain=1#L411) |  Arrays Calls | 17 |
| [newarray](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.newarray) | [NewArray](src/jvm/opcode.py?plain=1#L224) |  Arrays | 16 |
| [imul](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.imul) | [Binary](src/jvm/opcode.py?plain=1#L762) |  AdvancedLeaks InfoFlow Simple Tricky | 14 |
| [ineg](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.ineg) | [Negate](src/jvm/opcode.py?plain=1#L194) |  Dependent | 10 |
| [aconst_null](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.aconst_null) | [Push](src/jvm/opcode.py?plain=1#L102) |  Arrays | 7 |
| [invokevirtual](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.invokevirtual) | [InvokeVirtual](src/jvm/opcode.py?plain=1#L479) |  Strings | 3 |
| [irem](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.irem) | [Binary](src/jvm/opcode.py?plain=1#L762) |  Tricky | 3 |
| [i2s](https://docs.oracle.com/javase/specs/jvms/se23/html/jvms-6.html#jvms-6.5.i2s) | [Cast](src/jvm/opcode.py?plain=1#L373) |  Loops | 2 |

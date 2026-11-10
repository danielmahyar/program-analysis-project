package jpamb.utils;

import org.objectweb.asm.*;
import org.objectweb.asm.tree.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;

/**
 * ASM-based Bytecode Instrumenter for Information Flow & Integrity Runtime Monitoring (NIN).
 * Instruments compiled Java classes to inject shadow tracking, immediate post-dominator
 * pc-context tracking, and sink clearance assertions.
 */
public class BytecodeInstrumenter {

  /** Adds the security monitor to a class, whether or not it declares a lattice. */
  public static byte[] instrument(byte[] classBytes) {
    ClassNode cn = read(classBytes);
    instrumentSecurity(cn, false);
    return write(cn);
  }

  /**
   * Prepares a case class for running under JPAMB. A class that declares a security lattice
   * ({@link jpamb.utils.Lattice}) gets the security monitor, so a leak ends in an {@link
   * AssertionError}. With {@code coverage}, every method also reports the instructions it executes
   * to {@link Coverage}. A class that needs neither is returned unchanged.
   */
  public static byte[] transform(byte[] classBytes, boolean coverage) {
    ClassNode cn = read(classBytes);
    boolean security = declaresLattice(cn);
    if (!security && !coverage) {
      return classBytes;
    }
    if (security) {
      instrumentSecurity(cn, coverage);
    } else {
      for (MethodNode mn : cn.methods) {
        if (hasCode(mn)) {
          addCoverageProbes(cn, mn);
        }
      }
    }
    return write(cn);
  }

  private static ClassNode read(byte[] classBytes) {
    ClassNode cn = new ClassNode();
    new ClassReader(classBytes).accept(cn, 0);
    return cn;
  }

  private static byte[] write(ClassNode cn) {
    ClassWriter cw = new ClassWriter(ClassWriter.COMPUTE_FRAMES | ClassWriter.COMPUTE_MAXS);
    cn.accept(cw);
    return cw.toByteArray();
  }

  private static boolean declaresLattice(ClassNode cn) {
    if (cn.visibleAnnotations == null) return false;
    for (AnnotationNode an : cn.visibleAnnotations) {
      if (an.desc.equals("Ljpamb/utils/Lattice;") || an.desc.equals("Ljpamb/utils/Lattices;")) {
        return true;
      }
    }
    return false;
  }

  /** Methods with code that a case can execute (constructors and static initializers excluded). */
  private static boolean hasCode(MethodNode mn) {
    return (mn.access & (Opcodes.ACC_ABSTRACT | Opcodes.ACC_NATIVE)) == 0 && !mn.name.startsWith("<");
  }

  private static String coverageKey(ClassNode cn, MethodNode mn) {
    return cn.name.replace('/', '.') + "." + mn.name + ":" + mn.desc;
  }

  private static void emitProbe(InsnList out, String key, int index, AbstractInsnNode insn) {
    boolean createsAssertionError =
        insn.getOpcode() == Opcodes.NEW
            && ((TypeInsnNode) insn).desc.equals("java/lang/AssertionError");
    out.add(new LdcInsnNode(key));
    out.add(new LdcInsnNode(index));
    out.add(new MethodInsnNode(
        Opcodes.INVOKESTATIC,
        "jpamb/utils/Coverage",
        createsAssertionError ? "hitLast" : "hit",
        "(Ljava/lang/String;I)V",
        false));
  }

  /** Puts a {@link Coverage#hit} probe before every real instruction (labels and frames skipped). */
  private static void addCoverageProbes(ClassNode cn, MethodNode mn) {
    String key = coverageKey(cn, mn);
    InsnList out = new InsnList();
    int index = 0;
    for (AbstractInsnNode insn : mn.instructions.toArray()) {
      if (insn.getOpcode() >= 0) {
        emitProbe(out, key, index++, insn);
      }
      out.add(insn);
    }
    mn.instructions = out;
  }

  private static void instrumentSecurity(ClassNode cn, boolean coverage) {
    // 1. Extract class-level @Lattice annotations
    Map<String, List<String>> latticeLevels = new HashMap<>();
    Map<String, List<String>> latticeOrders = new HashMap<>();
    Map<String, String> latticeDefaults = new HashMap<>();

    if (cn.visibleAnnotations != null) {
      for (AnnotationNode an : cn.visibleAnnotations) {
        if (an.desc.contains("Lattices")) {
          List<?> values = (List<?>) getAnnotationValue(an, "value");
          if (values != null) {
            for (Object item : values) {
              if (item instanceof AnnotationNode) {
                parseLatticeAnnotation((AnnotationNode) item, latticeLevels, latticeOrders, latticeDefaults);
              }
            }
          }
        } else if (an.desc.contains("Lattice")) {
          parseLatticeAnnotation(an, latticeLevels, latticeOrders, latticeDefaults);
        }
      }
    }

    // Register lattices in SecurityMonitor
    for (String dim : latticeLevels.keySet()) {
      String[] lvls = latticeLevels.get(dim).toArray(new String[0]);
      String[] orders = latticeOrders.get(dim).toArray(new String[0]);
      String def = latticeDefaults.getOrDefault(dim, lvls[0]);
      SecurityMonitor.registerLattice(dim, lvls, orders, def);
    }

    String defaultConf = latticeDefaults.getOrDefault("conf", "Public");
    String defaultInteg = latticeDefaults.getOrDefault("integ", "Untrusted");

    // 2. Discover sink methods (non-@Case methods with @Sec parameters) and their clearances
    Map<String, Map<Integer, SecurityMonitor.Label>> sinkClearances = new HashMap<>();
    for (MethodNode mn : cn.methods) {
      if (hasCaseAnnotation(mn)) {
        continue;
      }
      String key = mn.name + mn.desc;
      Map<Integer, SecurityMonitor.Label> paramMap = new HashMap<>();
      if (mn.visibleParameterAnnotations != null) {
        for (int p = 0; p < mn.visibleParameterAnnotations.length; p++) {
          List<AnnotationNode> pAnns = mn.visibleParameterAnnotations[p];
          if (pAnns != null) {
            for (AnnotationNode an : pAnns) {
              if (an.desc.contains("Sec")) {
                String conf = (String) getAnnotationValue(an, "conf");
                String integ = (String) getAnnotationValue(an, "integ");
                paramMap.put(p, new SecurityMonitor.Label(
                    (conf != null && !conf.isEmpty()) ? conf : defaultConf,
                    (integ != null && !integ.isEmpty()) ? integ : defaultInteg));
              }
            }
          }
        }
      }
      if (!paramMap.isEmpty()) {
        sinkClearances.put(key, paramMap);
      }
    }

    // 3. Instrument @Case methods with shadow tracking, ipdom pc-context, and sink checks.
    //    With coverage, the remaining methods (the sinks) only get coverage probes.
    for (MethodNode mn : cn.methods) {
      if (!hasCode(mn)) {
        continue;
      }
      String probeKey = coverage ? coverageKey(cn, mn) : null;
      if (hasCaseAnnotation(mn)) {
        instrumentMethod(cn, mn, sinkClearances, defaultConf, defaultInteg, probeKey);
      } else if (coverage) {
        addCoverageProbes(cn, mn);
      }
    }
  }

  private static boolean hasCaseAnnotation(MethodNode mn) {
    if (mn.visibleAnnotations == null) return false;
    for (AnnotationNode an : mn.visibleAnnotations) {
      if (an.desc.contains("Case")) {
        return true;
      }
    }
    return false;
  }

  private static void parseLatticeAnnotation(
      AnnotationNode an,
      Map<String, List<String>> levels,
      Map<String, List<String>> orders,
      Map<String, String> defaults) {
    String dim = (String) getAnnotationValue(an, "dim");
    List<?> lvls = (List<?>) getAnnotationValue(an, "levels");
    List<?> ords = (List<?>) getAnnotationValue(an, "order");
    String def = (String) getAnnotationValue(an, "defaultLevel");

    if (dim != null) {
      List<String> lvlList = new ArrayList<>();
      if (lvls != null) {
        for (Object o : lvls) lvlList.add(o.toString());
      }
      levels.put(dim, lvlList);

      List<String> ordList = new ArrayList<>();
      if (ords != null) {
        for (Object o : ords) ordList.add(o.toString());
      }
      orders.put(dim, ordList);

      if (def != null) {
        defaults.put(dim, def);
      }
    }
  }

  private static Object getAnnotationValue(AnnotationNode an, String name) {
    if (an.values == null) return null;
    for (int i = 0; i < an.values.size(); i += 2) {
      if (an.values.get(i).equals(name)) {
        return an.values.get(i + 1);
      }
    }
    return null;
  }

  /**
   * Computes the immediate post-dominator instruction index for every instruction in mn.
   * Node N = mn.instructions.size() represents the virtual EXIT node.
   */
  private static int[] computeImmediatePostDominators(MethodNode mn) {
    int n = mn.instructions.size();
    int exitNode = n;
    List<Set<Integer>> succ = new ArrayList<>(n + 1);
    for (int i = 0; i <= n; i++) {
      succ.add(new HashSet<>());
    }

    for (int i = 0; i < n; i++) {
      AbstractInsnNode insn = mn.instructions.get(i);
      int op = insn.getOpcode();
      if ((op >= Opcodes.IRETURN && op <= Opcodes.RETURN) || op == Opcodes.ATHROW) {
        succ.get(i).add(exitNode);
      } else if (insn instanceof JumpInsnNode) {
        JumpInsnNode jin = (JumpInsnNode) insn;
        int targetIdx = mn.instructions.indexOf(jin.label);
        succ.get(i).add(targetIdx);
        if (op != Opcodes.GOTO) {
          succ.get(i).add(i + 1);
        }
      } else if (i + 1 < n) {
        succ.get(i).add(i + 1);
      } else {
        succ.get(i).add(exitNode);
      }
    }

    // Standard iterative post-dominator fixed point
    List<Set<Integer>> pdom = new ArrayList<>(n + 1);
    Set<Integer> allNodes = new HashSet<>();
    for (int i = 0; i <= n; i++) allNodes.add(i);

    for (int i = 0; i < n; i++) {
      pdom.add(new HashSet<>(allNodes));
    }
    Set<Integer> exitSet = new HashSet<>();
    exitSet.add(exitNode);
    pdom.add(exitSet);

    boolean changed = true;
    while (changed) {
      changed = false;
      for (int i = n - 1; i >= 0; i--) {
        Set<Integer> newPdom = null;
        for (int s : succ.get(i)) {
          if (newPdom == null) {
            newPdom = new HashSet<>(pdom.get(s));
          } else {
            newPdom.retainAll(pdom.get(s));
          }
        }
        if (newPdom == null) {
          newPdom = new HashSet<>();
        }
        newPdom.add(i);
        if (!newPdom.equals(pdom.get(i))) {
          pdom.set(i, newPdom);
          changed = true;
        }
      }
    }

    int[] ipdom = new int[n];
    Arrays.fill(ipdom, exitNode);
    for (int i = 0; i < n; i++) {
      Set<Integer> strictPdom = new HashSet<>(pdom.get(i));
      strictPdom.remove(i);
      for (int d : strictPdom) {
        if (pdom.get(d).equals(strictPdom)) {
          ipdom[i] = d;
          break;
        }
      }
    }
    return ipdom;
  }

  private static void instrumentMethod(
      ClassNode cn,
      MethodNode mn,
      Map<String, Map<Integer, SecurityMonitor.Label>> sinkClearances,
      String defaultConf,
      String defaultInteg,
      String probeKey) {

    AbstractInsnNode[] origInsns = mn.instructions.toArray();
    int realIndex = 0;
    int[] ipdom = computeImmediatePostDominators(mn);

    // Collect which instruction indices are immediate post-dominators of conditional branches
    Set<Integer> ipdomTargets = new HashSet<>();
    for (int i = 0; i < origInsns.length; i++) {
      AbstractInsnNode insn = origInsns[i];
      if (insn instanceof JumpInsnNode && insn.getOpcode() != Opcodes.GOTO) {
        ipdomTargets.add(ipdom[i]);
      }
    }

    InsnList newInstructions = new InsnList();

    // 1. At method start: reset monitor and init parameter shadow labels
    newInstructions.add(new LdcInsnNode(cn.name));
    newInstructions.add(new MethodInsnNode(
        Opcodes.INVOKESTATIC,
        "jpamb/utils/SecurityMonitor",
        "reset",
        "(Ljava/lang/String;)V",
        false));

    Type[] argTypes = Type.getArgumentTypes(mn.desc);
    int localSlot = ((mn.access & Opcodes.ACC_STATIC) != 0) ? 0 : 1;
    for (int i = 0; i < argTypes.length; i++) {
      String conf = defaultConf;
      String integ = defaultInteg;
      if (mn.visibleParameterAnnotations != null && i < mn.visibleParameterAnnotations.length) {
        List<AnnotationNode> pAnns = mn.visibleParameterAnnotations[i];
        if (pAnns != null) {
          for (AnnotationNode an : pAnns) {
            if (an.desc.contains("Sec")) {
              String c = (String) getAnnotationValue(an, "conf");
              String in = (String) getAnnotationValue(an, "integ");
              if (c != null && !c.isEmpty()) conf = c;
              if (in != null && !in.isEmpty()) integ = in;
            }
          }
        }
      }
      newInstructions.add(new IntInsnNode(Opcodes.BIPUSH, localSlot));
      newInstructions.add(new LdcInsnNode(conf));
      newInstructions.add(new LdcInsnNode(integ));
      newInstructions.add(new MethodInsnNode(
          Opcodes.INVOKESTATIC,
          "jpamb/utils/SecurityMonitor",
          "initLocal",
          "(ILjava/lang/String;Ljava/lang/String;)V",
          false));
      localSlot += argTypes[i].getSize();
    }

    // 2. Instrument instructions in body
    for (int i = 0; i < origInsns.length; i++) {
      AbstractInsnNode insn = origInsns[i];
      int opcode = insn.getOpcode();

      // If this node is a LabelNode, keep the label first so jumps land BEFORE atInsn(i)
      if (insn instanceof LabelNode) {
        newInstructions.add(insn);
        if (ipdomTargets.contains(i)) {
          newInstructions.add(new IntInsnNode(Opcodes.SIPUSH, i));
          newInstructions.add(new MethodInsnNode(
              Opcodes.INVOKESTATIC,
              "jpamb/utils/SecurityMonitor",
              "atInsn",
              "(I)V",
              false));
        }
        continue;
      }

      // Coverage probe first, so an instruction whose sink check fails still counts as reached
      if (probeKey != null && opcode >= 0) {
        emitProbe(newInstructions, probeKey, realIndex++, insn);
      }

      if (ipdomTargets.contains(i)) {
        newInstructions.add(new IntInsnNode(Opcodes.SIPUSH, i));
        newInstructions.add(new MethodInsnNode(
            Opcodes.INVOKESTATIC,
            "jpamb/utils/SecurityMonitor",
            "atInsn",
            "(I)V",
            false));
      }

      // Check sink calls (pop arguments in reverse parameter order)
      if (opcode == Opcodes.INVOKESTATIC || opcode == Opcodes.INVOKEVIRTUAL) {
        MethodInsnNode minsn = (MethodInsnNode) insn;
        String calleeKey = minsn.name + minsn.desc;
        if (sinkClearances.containsKey(calleeKey)) {
          Map<Integer, SecurityMonitor.Label> clearances = sinkClearances.get(calleeKey);
          Type[] calleeArgs = Type.getArgumentTypes(minsn.desc);
          for (int p = calleeArgs.length - 1; p >= 0; p--) {
            SecurityMonitor.Label req = clearances.getOrDefault(
                p, new SecurityMonitor.Label(defaultConf, defaultInteg));
            newInstructions.add(new LdcInsnNode(minsn.name));
            newInstructions.add(new LdcInsnNode(req.conf));
            newInstructions.add(new LdcInsnNode(req.integ));
            newInstructions.add(new MethodInsnNode(
                Opcodes.INVOKESTATIC,
                "jpamb/utils/SecurityMonitor",
                "checkSink",
                "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                false));
          }
        }
      }

      // Check return clearance
      if (opcode >= Opcodes.IRETURN && opcode <= Opcodes.ARETURN) {
        if (mn.visibleAnnotations != null) {
          for (AnnotationNode an : mn.visibleAnnotations) {
            if (an.desc.contains("Sec")) {
              String conf = (String) getAnnotationValue(an, "conf");
              String integ = (String) getAnnotationValue(an, "integ");
              newInstructions.add(new LdcInsnNode(mn.name + ":return"));
              newInstructions.add(new LdcInsnNode((conf != null && !conf.isEmpty()) ? conf : defaultConf));
              newInstructions.add(new LdcInsnNode((integ != null && !integ.isEmpty()) ? integ : defaultInteg));
              newInstructions.add(new MethodInsnNode(
                  Opcodes.INVOKESTATIC,
                  "jpamb/utils/SecurityMonitor",
                  "checkSink",
                  "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
                  false));
            }
          }
        }
      }

      // Track loads
      if (opcode >= Opcodes.ILOAD && opcode <= Opcodes.ALOAD) {
        VarInsnNode vin = (VarInsnNode) insn;
        newInstructions.add(new IntInsnNode(Opcodes.BIPUSH, vin.var));
        newInstructions.add(new MethodInsnNode(
            Opcodes.INVOKESTATIC,
            "jpamb/utils/SecurityMonitor",
            "loadLocal",
            "(I)V",
            false));
      }

      // Track stores
      if (opcode >= Opcodes.ISTORE && opcode <= Opcodes.ASTORE) {
        VarInsnNode vin = (VarInsnNode) insn;
        newInstructions.add(new IntInsnNode(Opcodes.BIPUSH, vin.var));
        newInstructions.add(new MethodInsnNode(
            Opcodes.INVOKESTATIC,
            "jpamb/utils/SecurityMonitor",
            "storeLocal",
            "(I)V",
            false));
      }

      // Track iinc
      if (opcode == Opcodes.IINC) {
        IincInsnNode iinc = (IincInsnNode) insn;
        newInstructions.add(new IntInsnNode(Opcodes.BIPUSH, iinc.var));
        newInstructions.add(new MethodInsnNode(
            Opcodes.INVOKESTATIC,
            "jpamb/utils/SecurityMonitor",
            "iincLocal",
            "(I)V",
            false));
      }

      // Track constants
      if ((opcode >= Opcodes.ICONST_M1 && opcode <= Opcodes.ICONST_5)
          || opcode == Opcodes.BIPUSH
          || opcode == Opcodes.SIPUSH
          || opcode == Opcodes.LDC) {
        newInstructions.add(new MethodInsnNode(
            Opcodes.INVOKESTATIC,
            "jpamb/utils/SecurityMonitor",
            "pushConstant",
            "()V",
            false));
      }

      // Track binary operations
      if (opcode >= Opcodes.IADD && opcode <= Opcodes.DREM) {
        newInstructions.add(new MethodInsnNode(
            Opcodes.INVOKESTATIC,
            "jpamb/utils/SecurityMonitor",
            "binaryOp",
            "()V",
            false));
      }

      // Track unary negation
      if (opcode >= Opcodes.INEG && opcode <= Opcodes.DNEG) {
        newInstructions.add(new MethodInsnNode(
            Opcodes.INVOKESTATIC,
            "jpamb/utils/SecurityMonitor",
            "unaryOp",
            "()V",
            false));
      }

      // Track conditional branch entries (1-operand vs 2-operand)
      if (insn instanceof JumpInsnNode && opcode != Opcodes.GOTO) {
        int branchIpdom = ipdom[i];
        newInstructions.add(new IntInsnNode(Opcodes.SIPUSH, branchIpdom));
        if ((opcode >= Opcodes.IFEQ && opcode <= Opcodes.IFLE)
            || opcode == Opcodes.IFNULL
            || opcode == Opcodes.IFNONNULL) {
          newInstructions.add(new MethodInsnNode(
              Opcodes.INVOKESTATIC,
              "jpamb/utils/SecurityMonitor",
              "enterBranch1",
              "(I)V",
              false));
        } else {
          newInstructions.add(new MethodInsnNode(
              Opcodes.INVOKESTATIC,
              "jpamb/utils/SecurityMonitor",
              "enterBranch2",
              "(I)V",
              false));
        }
      }

      newInstructions.add(insn);
    }

    mn.instructions = newInstructions;
  }

  public static void main(String[] args) throws Exception {
    if (args.length < 2) {
      System.out.println("Usage: BytecodeInstrumenter <input.class> <output.class>");
      return;
    }
    byte[] inBytes = Files.readAllBytes(Paths.get(args[0]));
    byte[] outBytes = instrument(inBytes);
    Path outPath = Paths.get(args[1]);
    if (outPath.getParent() != null) {
      Files.createDirectories(outPath.getParent());
    }
    Files.write(outPath, outBytes);
    System.out.println("Successfully instrumented " + args[0] + " -> " + args[1]);
  }
}

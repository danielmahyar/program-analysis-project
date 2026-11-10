package jpamb.utils;

import java.util.*;

/**
 * Runtime Security Monitor for Dynamic Bytecode Instrumentation (NIN).
 * Maintains dynamic shadow labels for the operand stack, local variables,
 * static fields, and the program-counter (pc) security context using
 * immediate post-dominators.
 */
public class SecurityMonitor {

  public static class DimensionLattice {
    public final String dim;
    public final Set<String> levels = new LinkedHashSet<>();
    public final Set<String> closure = new HashSet<>(); // pairs "a->b"
    public final String defaultLevel;
    public String bot;
    public String top;

    public DimensionLattice(String dim, String[] levelArray, String[] orderEdges, String defaultLevel) {
      this.dim = dim;
      this.defaultLevel = defaultLevel;
      Collections.addAll(this.levels, levelArray);

      // Reflexivity
      for (String lvl : levelArray) {
        closure.add(lvl + "->" + lvl);
      }
      // Declared edges
      for (String edge : orderEdges) {
        String[] parts = edge.split("<=");
        if (parts.length == 2) {
          closure.add(parts[0].trim() + "->" + parts[1].trim());
        }
      }
      // Transitive closure (Warshall)
      boolean changed = true;
      while (changed) {
        changed = false;
        Set<String> toAdd = new HashSet<>();
        for (String e1 : closure) {
          String[] p1 = e1.split("->");
          for (String e2 : closure) {
            String[] p2 = e2.split("->");
            if (p1[1].equals(p2[0])) {
              String trans = p1[0] + "->" + p2[1];
              if (!closure.contains(trans)) {
                toAdd.add(trans);
                changed = true;
              }
            }
          }
        }
        closure.addAll(toAdd);
      }

      // Determine bot and top
      for (String l1 : levelArray) {
        boolean isBot = true;
        boolean isTop = true;
        for (String l2 : levelArray) {
          if (!canFlow(l1, l2)) isBot = false;
          if (!canFlow(l2, l1)) isTop = false;
        }
        if (isBot) this.bot = l1;
        if (isTop) this.top = l1;
      }
    }

    public boolean canFlow(String from, String to) {
      return closure.contains(from + "->" + to);
    }

    public String join(String a, String b) {
      if (canFlow(a, b)) return b;
      if (canFlow(b, a)) return a;
      // Search for least upper bound
      String candidate = top;
      for (String lvl : levels) {
        if (canFlow(a, lvl) && canFlow(b, lvl)) {
          if (canFlow(lvl, candidate)) {
            candidate = lvl;
          }
        }
      }
      return candidate;
    }
  }

  public static class Label {
    public final String conf;
    public final String integ;

    public Label(String conf, String integ) {
      this.conf = conf;
      this.integ = integ;
    }

    @Override
    public String toString() {
      return "(" + conf + ", " + integ + ")";
    }
  }

  private static class PcEntry {
    public final int ipdom;
    public final Label label;

    public PcEntry(int ipdom, Label label) {
      this.ipdom = ipdom;
      this.label = label;
    }
  }

  // Active lattices for the executing class
  private static final Map<String, DimensionLattice> activeLattices = new HashMap<>();

  // Shadow storage
  private static final Deque<Label> shadowStack = new ArrayDeque<>();
  private static final Label[] shadowLocals = new Label[128];
  private static final Deque<PcEntry> pcStack = new ArrayDeque<>();

  public static synchronized void registerLattice(
      String dim, String[] levels, String[] order, String defaultLevel) {
    activeLattices.put(dim, new DimensionLattice(dim, levels, order, defaultLevel));
  }

  public static synchronized void ensureClassLattices(String className) {
    try {
      Class<?> cls = Class.forName(className.replace('/', '.'));
      Lattice[] lats = cls.getAnnotationsByType(Lattice.class);
      if (lats != null && lats.length > 0) {
        activeLattices.clear();
        for (Lattice lat : lats) {
          registerLattice(lat.dim(), lat.levels(), lat.order(), lat.defaultLevel());
        }
      }
    } catch (Exception ignored) {
    }
  }

  private static Label botLabel() {
    DimensionLattice confLat = activeLattices.get("conf");
    DimensionLattice integLat = activeLattices.get("integ");
    String botConf = confLat != null ? confLat.bot : "Public";
    String botInteg = integLat != null ? integLat.bot : "Trusted";
    return new Label(botConf, botInteg);
  }

  private static Label defaultLabel() {
    DimensionLattice confLat = activeLattices.get("conf");
    DimensionLattice integLat = activeLattices.get("integ");
    String defConf = confLat != null ? confLat.defaultLevel : "Public";
    String defInteg = integLat != null ? integLat.defaultLevel : "Untrusted";
    return new Label(defConf, defInteg);
  }

  private static Label currentPc() {
    return pcStack.isEmpty() ? botLabel() : pcStack.peek().label;
  }

  public static synchronized void reset(String ownerClass) {
    ensureClassLattices(ownerClass);
    shadowStack.clear();
    pcStack.clear();
    pcStack.push(new PcEntry(-1, botLabel()));
    Arrays.fill(shadowLocals, null);
  }

  public static synchronized void initLocal(int index, String conf, String integ) {
    DimensionLattice confLat = activeLattices.get("conf");
    DimensionLattice integLat = activeLattices.get("integ");
    String c = (conf == null || conf.isEmpty())
        ? (confLat != null ? confLat.defaultLevel : "Public")
        : conf;
    String in = (integ == null || integ.isEmpty())
        ? (integLat != null ? integLat.defaultLevel : "Untrusted")
        : integ;
    shadowLocals[index] = new Label(c, in);
  }

  public static synchronized void atInsn(int insnIndex) {
    while (pcStack.size() > 1 && pcStack.peek().ipdom == insnIndex) {
      pcStack.pop();
    }
  }

  public static synchronized void loadLocal(int index) {
    Label l = shadowLocals[index];
    if (l == null) {
      l = botLabel();
    }
    shadowStack.push(join(l, currentPc()));
  }

  public static synchronized void storeLocal(int index) {
    Label val = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    shadowLocals[index] = join(val, currentPc());
  }

  public static synchronized void iincLocal(int index) {
    Label l = shadowLocals[index];
    if (l == null) {
      l = botLabel();
    }
    shadowLocals[index] = join(l, currentPc());
  }

  public static synchronized void pushConstant() {
    shadowStack.push(join(botLabel(), currentPc()));
  }

  public static synchronized void binaryOp() {
    Label l2 = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    Label l1 = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    Label res = join(join(l1, l2), currentPc());
    shadowStack.push(res);
  }

  public static synchronized void unaryOp() {
    Label l1 = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    shadowStack.push(join(l1, currentPc()));
  }

  public static synchronized void enterBranch1(int ipdom) {
    Label cond = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    pcStack.push(new PcEntry(ipdom, join(currentPc(), cond)));
  }

  public static synchronized void enterBranch2(int ipdom) {
    Label cond2 = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    Label cond1 = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    Label cond = join(cond1, cond2);
    pcStack.push(new PcEntry(ipdom, join(currentPc(), cond)));
  }

  public static synchronized void checkSink(String sinkName, String requiredConf, String requiredInteg) {
    Label val = shadowStack.isEmpty() ? currentPc() : shadowStack.pop();
    Label effective = join(val, currentPc());

    DimensionLattice confLat = activeLattices.get("conf");
    DimensionLattice integLat = activeLattices.get("integ");

    String reqConf = (requiredConf == null || requiredConf.isEmpty())
        ? (confLat != null ? confLat.defaultLevel : "Public")
        : requiredConf;
    String reqInteg = (requiredInteg == null || requiredInteg.isEmpty())
        ? (integLat != null ? integLat.defaultLevel : "Untrusted")
        : requiredInteg;

    boolean confOk = (confLat == null) || confLat.canFlow(effective.conf, reqConf);
    boolean integOk = (integLat == null) || integLat.canFlow(effective.integ, reqInteg);

    if (!confOk || !integOk) {
      throw new AssertionError(
          "SECURITY VIOLATION at sink " + sinkName + ": effective " + effective
          + " cannot flow to required clearance (" + reqConf + ", " + reqInteg + ")");
    }
  }

  public static synchronized Label join(Label a, Label b) {
    if (a == null) return b;
    if (b == null) return a;
    DimensionLattice confLat = activeLattices.get("conf");
    DimensionLattice integLat = activeLattices.get("integ");

    String conf = (confLat != null) ? confLat.join(a.conf, b.conf) : a.conf;
    String integ = (integLat != null) ? integLat.join(a.integ, b.integ) : a.integ;
    return new Label(conf, integ);
  }
}

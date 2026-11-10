package jpamb.utils;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * Records which bytecode instructions a traced case executes. Probes inserted by {@link
 * BytecodeInstrumenter#transform} call {@link #hit} before every original instruction; the index is
 * the position of that instruction in the method's code, the same index used by the decompiled JSON
 * and by {@code target/stats/benchmark.sexp}.
 *
 * <p>A trace counts one step per executed instruction, like a JPAMB interpreter, and stops with
 * {@link StepLimit} once the step budget is used up.
 */
public final class Coverage {

  /** Thrown by {@link #hit} when the step budget is exhausted. */
  public static final class StepLimit extends Error {
    StepLimit() {
      super("step limit reached", null, false, false);
    }
  }

  /** Reached indices per method, methods in the order they were first reached. */
  private static final Map<String, SortedSet<Integer>> reached = new LinkedHashMap<>();
  private static boolean tracing = false;
  private static int steps = 0;
  private static int budget = 0;

  private Coverage() {}

  /** Start a new trace that allows at most {@code maxSteps} executed instructions. */
  public static void start(int maxSteps) {
    reached.clear();
    steps = 0;
    budget = maxSteps;
    tracing = true;
  }

  /** Stop tracing and return the reached instruction indices per method id. */
  public static Map<String, SortedSet<Integer>> stop() {
    tracing = false;
    return new LinkedHashMap<>(reached);
  }

  public static void hit(String method, int index) {
    if (!tracing) return;
    if (steps >= budget) throw new StepLimit();
    steps++;
    reached.computeIfAbsent(method, k -> new TreeSet<>()).add(index);
  }

  /**
   * Like {@link #hit}, for an instruction that ends the trace: JPAMB interpreters report {@code
   * assertion error} at {@code new java/lang/AssertionError}, so the instructions that build and
   * throw the error are not part of the trace.
   */
  public static void hitLast(String method, int index) {
    hit(method, index);
    tracing = false;
  }
}

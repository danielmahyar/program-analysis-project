package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/**
 * Precision and over-approximation benchmarks designed to separate the four analysis
 * paradigms (Syntactic AST, Unbounded Interval/Sign Abstract Interpretation, Dynamic
 * Coverage-Guided Fuzzing, and Hybrid):
 *
 * <ul>
 *   <li>Family 1 (Non-relational, convex-hull, parity, widening, bitwise-OR): safe
 *       methods whose unreachable leak branches expose over-approximation false positives
 *       in Unbound, Syntactic, and Hybrid, while Dynamic achieves 0 false positives.
 *   <li>Family 2 (Range contradiction, sign-hole, loop-exit bound, bitmask bound): safe
 *       methods where Unbound's Interval x SignSet domain proves safety, separating it
 *       from Syntactic and Hybrid false positives.
 *   <li>Family 3 (32-bit JVM integer overflow): separates JVM-faithful 32-bit arithmetic
 *       (Unbound, Dynamic, Hybrid dynamic-only-leak) from Syntactic's unbounded Python
 *       constant folding.
 *   <li>Family 4 (Relational always-leak): leak-only method exposing over-approximation
 *       in Unbound's "ok" reachability.
 * </ul>
 */
@Lattice(dim = "conf", levels = {"Low", "High"}, order = {"Low <= High"}, defaultLevel = "Low")
public class PrecisionBenchmarks {

  static void publish(@Sec(conf = "Low") int value) {}

  // =========================================================================
  // Family 1: Over-approximation false positives in Unbound, Syntactic, Hybrid
  // =========================================================================

  // 1. Relational self-cancellation: y == x, so x - y is always 0.
  @Case("(5, 99) -> ok")
  @Case("(-3, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void relationalSelfCancelSafe(int x, @Sec(conf = "High") int secret) {
    int y = x;
    if (x - y != 0) {
      publish(secret);
    }
  }

  // 2. Relational ordering without overflow: x in [1, 99] and y = x + 1 => y > x always.
  @Case("(10, 99) -> ok")
  @Case("(50, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void relationalOrderSafe(int x, @Sec(conf = "High") int secret) {
    if (x > 0 && x < 100) {
      int y = x + 1;
      if (y <= x) {
        publish(secret);
      }
    }
  }

  // 3. Path-sensitivity / correlated branches: x == 1 holds only when flag > 0.
  @Case("(1, 99) -> ok")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void correlatedBranchSafe(int flag, @Sec(conf = "High") int secret) {
    int x = 0;
    if (flag > 0) {
      x = 1;
    }
    if (flag <= 0 && x == 1) {
      publish(secret);
    }
  }

  // 4. Non-convex interval hull: {1, 5} joins to [1, 5], which spuriously contains 3.
  @Case("(1, 99) -> ok")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void intervalHullHoleSafe(int cond, @Sec(conf = "High") int secret) {
    int x = (cond > 0) ? 1 : 5;
    if (x == 3) {
      publish(secret);
    }
  }

  // 5. Parity / congruence loss: 2 * k is always even, so (2 * k) % 2 == 1 is impossible.
  @Case("(3, 99) -> ok")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void paritySafe(int k, @Sec(conf = "High") int secret) {
    if (k >= 0 && k <= 10) {
      int even = k * 2;
      if (even % 2 == 1) {
        publish(secret);
      }
    }
  }

  // 6. Loop widening overshoot: sum stops at 10, but widening pushes unguarded sum past 20.
  @Case("(99) -> ok")
  @Tag({LOOP, CONDITIONAL, CALL})
  public static void wideningOvershootSafe(@Sec(conf = "High") int secret) {
    int i = 0;
    int sum = 0;
    while (i < 5) {
      sum = sum + 2;
      i = i + 1;
    }
    if (sum > 20) {
      publish(secret);
    }
  }

  // 7. Bitwise-OR tautology: (x | 1) always has bit 0 set, so it can never be 0.
  @Case("(0, 99) -> ok")
  @Case("(-1, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void bitwiseOrNonZeroSafe(int x, @Sec(conf = "High") int secret) {
    if ((x | 1) == 0) {
      publish(secret);
    }
  }

  // =========================================================================
  // Family 2: Interval / Sign-Set precision where Unbound beats Syntactic & Hybrid
  // =========================================================================

  // 8. Contradictory range on public parameter: x > 10 and x < 5 is impossible.
  @Case("(0, 99) -> ok")
  @Case("(20, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void contradictoryRangeSafe(int x, @Sec(conf = "High") int secret) {
    if (x > 10) {
      if (x < 5) {
        publish(secret);
      }
    }
  }

  // 9. Sign-hole tightening: x != 0 && x >= 0 implies x >= 1, so x < 1 is impossible.
  @Case("(0, 99) -> ok")
  @Case("(1, 99) -> ok")
  @Case("(-1, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void signHoleRangeSafe(int x, @Sec(conf = "High") int secret) {
    if (x != 0) {
      if (x >= 0) {
        if (x < 1) {
          publish(secret);
        }
      }
    }
  }

  // 10. Loop exit bound: after `while (i < 10) i++`, i == 10 so i < 10 is impossible.
  @Case("(99) -> ok")
  @Tag({LOOP, CONDITIONAL, CALL})
  public static void loopExitBoundSafe(@Sec(conf = "High") int secret) {
    int i = 0;
    while (i < 10) {
      i = i + 1;
    }
    if (i < 10) {
      publish(secret);
    }
  }

  // 11. Bitmask upper bound: (x & 7) is always in [0, 7], so > 7 is impossible.
  @Case("(255, 99) -> ok")
  @Case("(-1, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void bitwiseMaskBoundSafe(int x, @Sec(conf = "High") int secret) {
    int m = x & 7;
    if (m > 7) {
      publish(secret);
    }
  }

  // =========================================================================
  // Family 3: 32-bit JVM integer overflow semantics
  // =========================================================================

  // 12. Signed 32-bit overflow makes y == INT_MIN < 0, reaching the leak on JVM.
  @Case("(99) -> assertion error")
  @Tag({EXPLICIT_FLOW, CONDITIONAL, CALL})
  public static void overflowPrunedBySyntacticLeak(@Sec(conf = "High") int secret) {
    int x = 2147483647;
    int y = x + 1;
    if (y < 0) {
      publish(secret);
    }
  }

  // 13. Signed 32-bit overflow makes y == INT_MIN, so y > 0 is dead on JVM.
  @Case("(99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void overflowDeadBranchSafe(@Sec(conf = "High") int secret) {
    int x = 2147483647;
    int y = x + 1;
    if (y > 0) {
      publish(secret);
    }
  }

  // =========================================================================
  // Family 4: Relational always-leak (exposes Unbound over-approximating "ok")
  // =========================================================================

  // 14. y == x always holds, so publish(secret) runs on every input ("ok" never happens).
  @Case("(5, 99) -> assertion error")
  @Case("(-3, 99) -> assertion error")
  @Tag({EXPLICIT_FLOW, CONDITIONAL, CALL})
  public static void relationalAlwaysLeak(int x, @Sec(conf = "High") int secret) {
    int y = x;
    if (x == y) {
      publish(secret);
    }
  }

  // =========================================================================
  // Family 5: Large counting loop for threshold widening
  // =========================================================================

  // 15. Counting to 1,000,000: threshold widening jumps directly to 1,000,000 and proves
  // i < 1,000,000 unreachable at exit, whereas Dynamic hits its step limit and Syntactic warns.
  @Case("(99) -> ok")
  @Tag({LOOP, CONDITIONAL, CALL})
  public static void largeLoopWideningSafe(@Sec(conf = "High") int secret) {
    int i = 0;
    while (i < 1000000) {
      i = i + 1;
    }
    if (i < 1000000) {
      publish(secret);
    }
  }

  // =========================================================================
  // Family 6: Interprocedural helper calls and recursion boundaries
  // =========================================================================

  static int passthroughHelper(int value) {
    return value;
  }

  // 16. Same-class helper forwarding a High secret to a Low sink.
  @Case("(99) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void helperPassthroughLeak(@Sec(conf = "High") int secret) {
    int forwarded = passthroughHelper(secret);
    publish(forwarded);
  }

  // 17. Same-class helper forwarding a Low value safely.
  @Case("(7, 99) -> ok")
  @Tag({CALL})
  public static void helperPassthroughSafe(int open, @Sec(conf = "High") int secret) {
    int forwarded = passthroughHelper(open);
    publish(forwarded);
  }

  // 18. Tail-recursive countdown to a leaking base case.
  @Case("(2, 99) -> assertion error")
  @Case("(-1, 99) -> ok")
  @Tag({EXPLICIT_FLOW, CONDITIONAL, CALL, RECURSION})
  public static void recursiveCountdownLeak(int steps, @Sec(conf = "High") int secret) {
    if (steps < 0) {
      publish(0);
      return;
    }
    if (steps == 0) {
      publish(secret);
      return;
    }
    recursiveCountdownLeak(steps - 1, secret);
  }
}

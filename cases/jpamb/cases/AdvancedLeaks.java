package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/**
 * Advanced confidentiality leak patterns exercising:
 * - Abrupt control flow / early returns before a sink (`earlyReturnBeforeSink`)
 * - Ternary conditional expressions (`ternaryImplicitLeak`, `ternaryDeadBranchSafe`)
 * - For loops and do-while loops (`forLoopLeak`, `forLoopSafe`, `doWhileLeak`)
 * - Computed constant propagation and dead-branch pruning (`computedDeadBranchSafe`)
 * - Value overwriting after a secret branch (`overwrittenAfterBranchSafe`)
 * - Multi-threshold nested guards (`nestedThresholdLeak`)
 * - Multiple nested while loops with specific corner-case leaks (`nestedWhileWeirdCaseLeak`,
 *   `tripleNestedWhileCornerLeak`, `nestedWhileSafe`)
 * - Recursive confidentiality flows (`recursiveCountdownLeak`, `recursiveExplicitLeak`,
 *   `recursiveSafe`)
 */
@Lattice(
    dim = "conf",
    levels = {"Low", "Mid", "High"},
    order = {"Low <= Mid", "Mid <= High"},
    defaultLevel = "Low")
public class AdvancedLeaks {

  static void publishLow(@Sec(conf = "Low") int value) {}

  static void publishMid(@Sec(conf = "Mid") int value) {}

  static void publishHigh(@Sec(conf = "High") int value) {}

  // 1. Early return under a High branch makes the subsequent sink control-dependent on High.
  @Case("(10) -> ok")
  @Case("(-5) -> assertion error")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void earlyReturnBeforeSink(@Sec(conf = "High") int secret) {
    if (secret > 0) {
      return;
    }
    publishLow(0);
  }

  // 2. Early return under a Low branch does not taint a Low sink.
  @Case("(10) -> ok")
  @Case("(-5) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void earlyReturnSafe(@Sec(conf = "Low") int open) {
    if (open > 0) {
      return;
    }
    publishLow(0);
  }

  // 3. Ternary expression implicit leak: L((secret > 50) ? 1 : 0) = High.
  @Case("(100) -> assertion error")
  @Case("(0) -> assertion error")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void ternaryImplicitLeak(@Sec(conf = "High") int secret) {
    int x = (secret > 50) ? 1 : 0;
    publishLow(x);
  }

  // 4. Ternary expression with constant condition: dead arm has `secret`, live arm is `0`.
  @Case("(42) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void ternaryDeadBranchSafe(@Sec(conf = "High") int secret) {
    int flag = 0;
    int x = (flag == 1) ? secret : 0;
    publishLow(x);
  }

  // 5. For-loop implicit leak: loop bound depends on High secret.
  @Case("(4) -> assertion error")
  @Case("(0) -> ok")
  @Tag({IMPLICIT_FLOW, LOOP, CALL})
  public static void forLoopLeak(@Sec(conf = "High") int secret) {
    int sum = 0;
    for (int i = 0; i < secret; i++) {
      sum += 2;
    }
    publishLow(sum);
  }

  // 6. For-loop safe: loop bound is Mid and sink is Mid.
  @Case("(4) -> ok")
  @Case("(0) -> ok")
  @Tag({LOOP, CALL})
  public static void forLoopSafe(@Sec(conf = "Mid") int midVal) {
    int sum = 0;
    for (int i = 0; i < midVal; i++) {
      sum += 1;
    }
    publishMid(sum);
  }

  // 7. Do-while loop implicit leak: condition at end of loop taints subsequent iterations.
  @Case("(3) -> assertion error")
  @Tag({IMPLICIT_FLOW, LOOP, CALL})
  public static void doWhileLeak(@Sec(conf = "High") int secret) {
    int count = 0;
    int i = 0;
    do {
      count += 1;
      i += 1;
    } while (i < secret);
    publishLow(count);
  }

  // 8. Computed constant dead-branch safe: arithmetic on constants proves branch is dead.
  @Case("(99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void computedDeadBranchSafe(@Sec(conf = "High") int secret) {
    int a = 3;
    int b = 4;
    int c = a * b - 12;
    if (c != 0) {
      publishLow(secret);
    }
    publishLow(a + b);
  }

  // 9. Variable tainted inside a High branch is overwritten with a public constant after the branch.
  @Case("(5) -> ok")
  @Case("(-5) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void overwrittenAfterBranchSafe(@Sec(conf = "High") int secret) {
    int x = 0;
    if (secret > 0) {
      x = 1;
    }
    x = 0;
    publishLow(x);
  }

  // 10. Multi-threshold nested guard requiring constant extraction (`secret > 400`).
  @Case("(500, 1) -> assertion error")
  @Case("(100, 1) -> ok")
  @Case("(500, 0) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void nestedThresholdLeak(
      @Sec(conf = "High") int secret, @Sec(conf = "Mid") int midGate) {
    int out = 0;
    if (midGate > 0) {
      if (secret > 400) {
        out = 1;
      }
    }
    publishMid(out);
  }

  // ---------------------------------------------------------------------------
  // Multiple nested while loops with specific corner-case leaks
  // ---------------------------------------------------------------------------

  // 11. Two nested while loops (outer and inner bounds are Low), but at a very specific
  // weird corner combination of (i, j) AND a specific secret value (`i * 10 + j == 23 && secret == 77`),
  // a High taint is injected into `badge`.
  @Case("(3, 4, 77) -> assertion error")
  @Case("(3, 4, 10) -> ok")
  @Case("(2, 2, 77) -> ok")
  @Tag({IMPLICIT_FLOW, LOOP, CONDITIONAL, CALL})
  public static void nestedWhileWeirdCaseLeak(
      @Sec(conf = "Low") int rows,
      @Sec(conf = "Low") int cols,
      @Sec(conf = "High") int secret) {
    int badge = 0;
    int i = 0;
    while (i < rows && i < 5) {
      int j = 0;
      while (j < cols && j < 5) {
        if (i * 10 + j == 23) {
          if (secret == 77) {
            badge = 999;
          }
        }
        j = j + 1;
      }
      i = i + 1;
    }
    publishLow(badge);
  }

  // 12. Triple-nested while loops: only when `i == 1`, `j == 2`, `k == 1` AND `secret == -42`
  // does the inner accumulator absorb `secret` (explicit flow buried inside 3 nested loops).
  @Case("(2, 3, 2, -42) -> assertion error")
  @Case("(2, 3, 2, 5) -> ok")
  @Case("(1, 1, 1, -42) -> ok")
  @Tag({EXPLICIT_FLOW, IMPLICIT_FLOW, LOOP, CONDITIONAL, CALL})
  public static void tripleNestedWhileCornerLeak(
      @Sec(conf = "Low") int a,
      @Sec(conf = "Low") int b,
      @Sec(conf = "Low") int c,
      @Sec(conf = "High") int secret) {
    int result = 0;
    int i = 0;
    while (i < a && i < 3) {
      int j = 0;
      while (j < b && j < 4) {
        int k = 0;
        while (k < c && k < 3) {
          if (i + j + k == 4 && i == 1 && j == 2) {
            if (secret == -42) {
              result = result + secret;
            }
          }
          k = k + 1;
        }
        j = j + 1;
      }
      i = i + 1;
    }
    publishLow(result);
  }

  // 13. Safe counterpart: nested while loops where the weird corner case only writes to a High sink.
  @Case("(3, 4, 77) -> ok")
  @Case("(1, 1, 0) -> ok")
  @Tag({LOOP, CONDITIONAL, CALL})
  public static void nestedWhileSafe(
      @Sec(conf = "Low") int rows,
      @Sec(conf = "Low") int cols,
      @Sec(conf = "High") int secret) {
    int publicCount = 0;
    int i = 0;
    while (i < rows && i < 5) {
      int j = 0;
      while (j < cols && j < 5) {
        publicCount = publicCount + 1;
        if (i == 2 && j == 3 && secret == 77) {
          publishHigh(secret);
        }
        j = j + 1;
      }
      i = i + 1;
    }
    publishLow(publicCount);
  }

  // ---------------------------------------------------------------------------
  // Recursive confidentiality flows
  // ---------------------------------------------------------------------------

  // 14. Direct recursion on a `@Case` method: counts down a High secret recursively
  // and leaks at the base case (`n == 0`) because reaching the base case depends on `n > 0`.
  @Case("(3) -> assertion error")
  @Case("(0) -> assertion error")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL, RECURSION})
  public static void recursiveCountdownLeak(@Sec(conf = "High") int n) {
    if (n <= 0) {
      publishLow(0);
      return;
    }
    if (n == 1) {
      publishLow(1);
      return;
    }
    recursiveCountdownLeak(n - 1);
  }

  // 15. Direct recursion with explicit secret pass-through that only leaks when the
  // recursive depth hits a specific step (`steps == 0` after decrementing from a positive start).
  @Case("(2, 99) -> assertion error")
  @Case("(-1, 99) -> ok")
  @Tag({EXPLICIT_FLOW, CONDITIONAL, CALL, RECURSION})
  public static void recursiveExplicitLeak(
      @Sec(conf = "Low") int steps, @Sec(conf = "High") int secret) {
    if (steps < 0) {
      publishLow(0);
      return;
    }
    if (steps == 0) {
      publishLow(secret);
      return;
    }
    recursiveExplicitLeak(steps - 1, secret);
  }

  // 16. Safe recursive method: recurses on a Low counter and publishes to a Low sink,
  // while forwarding a High secret only to a High sink at the base case.
  @Case("(3, 99) -> ok")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL, RECURSION})
  public static void recursiveSafe(
      @Sec(conf = "Low") int steps, @Sec(conf = "High") int secret) {
    if (steps <= 0) {
      publishLow(steps);
      publishHigh(secret);
      return;
    }
    recursiveSafe(steps - 1, secret);
  }

  // 17. Observing the public sink call reveals that the High skip flag is zero.
  @Case("(0) -> assertion error")
  @Case("(1) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, LOOP, CALL})
  public static void continueSkipsSink(@Sec(conf = "High") int skip) {
    for (int i = 0; i < 2; i++) {
      if (skip != 0) {
        continue;
      }
      publishLow(i);
    }
  }

  // 18. The same loop may safely reveal whether a Low skip flag is zero.
  @Case("(0) -> ok")
  @Case("(1) -> ok")
  @Tag({CONDITIONAL, LOOP, CALL})
  public static void continueSkipsSinkSafe(@Sec(conf = "Low") int skip) {
    for (int i = 0; i < 2; i++) {
      if (skip != 0) {
        continue;
      }
      publishLow(i);
    }
  }
}

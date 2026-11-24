package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/**
 * The smallest possible confidentiality leaks, one idea per method, over the
 * two-point lattice Low
 * <= High. Every leak has a safe twin that differs in one place, so an analyser
 * can be checked for
 * both missed leaks and false alarms.
 */
@Lattice(dim = "conf", levels = { "Low", "High" }, order = { "Low <= High" }, defaultLevel = "Low")
public class BasicLeaks {

  static void publish(@Sec(conf = "Low") int value) {
  }

  // ---------------------------------------------------------------- explicit

  @Case("(7) -> assertion error")
  @Tag({ EXPLICIT_FLOW, CALL })
  public static void explicitDirect(@Sec(conf = "High") int secret) {
    publish(secret);
  }

  @Case("(7) -> ok")
  @Tag({ CALL })
  public static void explicitDirectSafe(@Sec(conf = "Low") int open) {
    publish(open);
  }

  @Case("(7) -> assertion error")
  @Tag({ EXPLICIT_FLOW, CALL })
  public static void explicitCopy(@Sec(conf = "High") int secret) {
    int x = secret;
    publish(x);
  }

  @Case("(7) -> ok")
  @Tag({ CALL })
  public static void explicitConstantSafe(@Sec(conf = "High") int secret) {
    int x = 0;
    publish(x);
  }

  @Case("(7) -> assertion error")
  @Tag({ EXPLICIT_FLOW, CALL })
  public static void explicitArithmetic(@Sec(conf = "High") int secret) {
    publish(secret + 1);
  }

  @Case("(7, 1) -> assertion error")
  @Tag({ EXPLICIT_FLOW, CALL })
  public static void explicitMixed(@Sec(conf = "Low") int open, @Sec(conf = "High") int secret) {
    publish(open + secret);
  }

  @Case("(7, 1) -> ok")
  @Tag({ CALL })
  public static void explicitMixedSafe(@Sec(conf = "Low") int open, @Sec(conf = "High") int secret) {
    publish(open + 1);
  }

  @Case("(7) -> assertion error")
  @Tag({ EXPLICIT_FLOW })
  @Sec(conf = "Low")
  public static int explicitReturn(@Sec(conf = "High") int secret) {
    return secret;
  }

  @Case("(7) -> ok")
  @Tag({})
  @Sec(conf = "High")
  public static int explicitReturnSafe(@Sec(conf = "High") int secret) {
    return secret;
  }

  // ---------------------------------------------------------------- implicit

  // The leaking store only runs when the branch is taken.
  @Case("(1) -> assertion error")
  @Case("(0) -> ok")
  @Tag({ IMPLICIT_FLOW, CONDITIONAL, CALL })
  public static void implicitIf(@Sec(conf = "High") int secret) {
    int x = 0;
    if (secret > 0) {
      x = 1;
    }
    publish(x);
  }

  @Case("(1) -> ok")
  @Case("(0) -> ok")
  @Tag({ CONDITIONAL, CALL })
  public static void implicitIfSafe(@Sec(conf = "Low") int open) {
    int x = 0;
    if (open > 0) {
      x = 1;
    }
    publish(x);
  }

  // Both arms store, so both inputs leak.
  @Case("(1) -> assertion error")
  @Case("(0) -> assertion error")
  @Tag({ IMPLICIT_FLOW, CONDITIONAL, CALL })
  public static void implicitIfElse(@Sec(conf = "High") int secret) {
    int x;
    if (secret > 0) {
      x = 1;
    } else {
      x = 0;
    }
    publish(x);
  }

  // Calling the sink at all is observable.
  @Case("(1) -> assertion error")
  @Case("(0) -> ok")
  @Tag({ IMPLICIT_FLOW, CONDITIONAL, CALL })
  public static void implicitSinkInBranch(@Sec(conf = "High") int secret) {
    if (secret > 0) {
      publish(0);
    }
  }

  // The branch is on a secret, but the sink comes after it and ignores it.
  @Case("(1, 5) -> ok")
  @Case("(0, 5) -> ok")
  @Tag({ CONDITIONAL, CALL })
  public static void implicitAfterBranchSafe(
      @Sec(conf = "High") int secret, @Sec(conf = "Low") int open) {
    int x = 0;
    if (secret > 0) {
      x = 1;
    }
    publish(open);
  }

  // The loop count reveals the secret.
  @Case("(3) -> assertion error")
  @Case("(0) -> ok")
  @Tag({ IMPLICIT_FLOW, LOOP, CALL })
  public static void implicitWhile(@Sec(conf = "High") int secret) {
    int i = 0;
    while (i < secret) {
      i = i + 1;
    }
    publish(i);
  }

  @Case("(1) -> assertion error")
  @Case("(0) -> assertion error")
  @Tag({ IMPLICIT_FLOW, CONDITIONAL })
  @Sec(conf = "Low")
  public static int implicitReturn(@Sec(conf = "High") int secret) {
    if (secret > 0) {
      return 1;
    }
    return 0;
  }

  @Case("(1) -> ok")
  @Case("(0) ->  ok")
  @Tag({ IMPLICIT_FLOW, CONDITIONAL })
  @Sec(conf = "Low")
  public static void staticFlagsButDynamicDoesnt(@Sec(conf = "High") int secret) {
    int x = 0;
    if (secret > 0) {
      x = 1;
    }
    x = 0;
    publish(x);
  }

  // ------------------------------------------------ novel datatypes (Strings & Arrays)

  // Branching on secret.equals(...) raises pc to High, tainting `out`.
  @Case("(s'High') -> assertion error")
  @Case("(s'Low') -> ok")
  @Tag({ IMPLICIT_FLOW, CONDITIONAL, CALL })
  public static void stringEqualsImplicitLeak(@Sec(conf = "High") String secret) {
    int out = 0;
    if (secret.equals("High")) {
      out = 1;
    }
    publish(out);
  }

  @Case("(s'High') -> ok")
  @Case("(s'Low') -> ok")
  @Tag({ CONDITIONAL, CALL })
  public static void stringEqualsSafe(@Sec(conf = "Low") String open) {
    int out = 0;
    if (open.equals("High")) {
      out = 1;
    }
    publish(out);
  }

  // Writing to an array at a High index taints the monolithic array label:
  // L(notes') = L(notes) ∪ L(1) ∪ L(secretIndex) ∪ pc = High.
  @Case("(1) -> assertion error")
  @Tag({ EXPLICIT_FLOW, ARRAY, CALL })
  public static void arrayIndexWriteLeak(@Sec(conf = "High") int secretIndex) {
    int[] notes = { 0, 0, 0, 0 };
    notes[secretIndex] = 1;
    publish(notes[0]);
  }

  @Case("(1) -> ok")
  @Tag({ ARRAY, CALL })
  public static void arrayIndexWriteSafe(@Sec(conf = "Low") int openIndex) {
    int[] notes = { 0, 0, 0, 0 };
    notes[openIndex] = 1;
    publish(notes[0]);
  }

  @Case("(7) -> ok")
  @Tag({ LOOP, CONDITIONAL, CALL })
  public static void skippedLoop(@Sec(conf = "High") int secret) {
    int mode = 0;
    while (mode != 0) {
      publish(secret);
      mode = 0;
    }
  }

  @Case("(7, 1) -> ok")
  @Case("(7, 2) -> assertion error")
  @Tag({ LOOP, CONDITIONAL, CALL, EXPLICIT_FLOW })
  public static void leakAfterBackEdge(
      @Sec(conf = "High") int secret, @Sec(conf = "Low") int count) {
    int phase = 0;
    while (count > 0) {
      if (phase == 1) {
        publish(secret);
      }
      phase = 1;
      count--;
    }
  }
}

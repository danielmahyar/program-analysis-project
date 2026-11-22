package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/**
 * Synthetic search challenges, separate from the original confidentiality baseline.
 * Public guards isolate input discovery from the already tested confidentiality oracle.
 * Validation cases are witnesses, never inputs supplied to the fuzzer.
 */
@Lattice(
    dim = "conf",
    levels = {"Low", "High"},
    order = {"Low <= High"},
    defaultLevel = "Low")
public class FuzzingChallenges {
  static void publishLow(@Sec(conf = "Low") int value) {}

  static void publishHigh(@Sec(conf = "High") int value) {}

  // Family 1: each successful guard reaches additional instructions. Keeping
  // intermediate coverage may help assemble the three public gate values.
  @Case("(3, 5, 6, 99) -> assertion error")
  @Case("(0, 0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void stagedMask3(int a, int b, int c, @Sec(conf = "High") int secret) {
    if ((a & 7) == 3) {
      if ((b & 7) == 5) {
        if ((c & 7) == 6) {
          publishLow(secret);
        }
      }
    }
  }

  @Case("(11, 9, 14, 99) -> assertion error")
  @Case("(0, 0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void stagedMask4(int a, int b, int c, @Sec(conf = "High") int secret) {
    if ((a & 15) == 11) {
      if ((b & 15) == 9) {
        if ((c & 15) == 14) {
          publishLow(secret);
        }
      }
    }
  }

  @Case("(19, 25, 22, 99) -> assertion error")
  @Case("(0, 0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void stagedMask5(int a, int b, int c, @Sec(conf = "High") int secret) {
    if ((a & 31) == 19) {
      if ((b & 31) == 25) {
        if ((c & 31) == 22) {
          publishLow(secret);
        }
      }
    }
  }

  @Case("(3, 5, 6, 99) -> ok")
  @Case("(0, 0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void stagedMaskSafe(int a, int b, int c, @Sec(conf = "High") int secret) {
    if ((a & 7) == 3) {
      if ((b & 7) == 5) {
        if ((c & 7) == 6) {
          publishHigh(secret);
        }
      }
    }
  }

  // Family 2: one final branch, with no partial-match coverage. The exact
  // public targets occur in bytecode and can be combined by dictionary draws.
  @Case("(17, 43, 99) -> assertion error")
  @Case("(0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void opaquePair17(int a, int b, @Sec(conf = "High") int secret) {
    if (((a ^ 17) | (b ^ 43)) == 0) {
      publishLow(secret);
    }
  }

  @Case("(29, 71, 99) -> assertion error")
  @Case("(0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void opaquePair29(int a, int b, @Sec(conf = "High") int secret) {
    if (((a ^ 29) | (b ^ 71)) == 0) {
      publishLow(secret);
    }
  }

  @Case("(53, 113, 99) -> assertion error")
  @Case("(0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void opaquePair53(int a, int b, @Sec(conf = "High") int secret) {
    if (((a ^ 53) | (b ^ 113)) == 0) {
      publishLow(secret);
    }
  }

  @Case("(17, 43, 99) -> ok")
  @Case("(0, 0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void opaquePairSafe(int a, int b, @Sec(conf = "High") int secret) {
    if (((a ^ 17) | (b ^ 43)) == 0) {
      publishHigh(secret);
    }
  }

  // Family 3: javac keeps these non-final local calculations in bytecode.
  // The target is absent from the dictionary. Neutral inputs such as 11 can
  // mutate to 19, but reach no new instructions and are discarded by guidance.
  @Case("(19, 99) -> assertion error")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void neutralTarget19(int x, @Sec(conf = "High") int secret) {
    int target = 7;
    target += 12;
    if (x == target) {
      publishLow(secret);
    }
  }

  @Case("(23, 99) -> assertion error")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void neutralTarget23(int x, @Sec(conf = "High") int secret) {
    int target = 7;
    target += 16;
    if (x == target) {
      publishLow(secret);
    }
  }

  @Case("(31, 99) -> assertion error")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void neutralTarget31(int x, @Sec(conf = "High") int secret) {
    int target = 7;
    target += 24;
    if (x == target) {
      publishLow(secret);
    }
  }

  @Case("(19, 99) -> ok")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void neutralTargetSafe(int x, @Sec(conf = "High") int secret) {
    int target = 7;
    target += 12;
    if (x == target) {
      publishHigh(secret);
    }
  }

  // Family 4: rare arithmetic targets with no partial-match coverage. None of
  // the current strategies reasons backwards through multiplication.
  @Case("(67591, 99) -> assertion error")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void productTarget257(int x, @Sec(conf = "High") int secret) {
    int target = 257;
    target *= 263;
    if (x == target) {
      publishLow(secret);
    }
  }

  @Case("(265189, 99) -> assertion error")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void productTarget509(int x, @Sec(conf = "High") int secret) {
    int target = 509;
    target *= 521;
    if (x == target) {
      publishLow(secret);
    }
  }

  @Case("(1065023, 99) -> assertion error")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void productTarget1031(int x, @Sec(conf = "High") int secret) {
    int target = 1031;
    target *= 1033;
    if (x == target) {
      publishLow(secret);
    }
  }

  @Case("(67591, 99) -> ok")
  @Case("(0, 99) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void productTargetSafe(int x, @Sec(conf = "High") int secret) {
    int target = 257;
    target *= 263;
    if (x == target) {
      publishHigh(secret);
    }
  }
}

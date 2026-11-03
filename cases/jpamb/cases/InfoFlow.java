package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/** Basic information-flow cases over the classic two-point lattices. */
@Lattice(dim = "conf", levels = {"Low", "High"}, order = {"Low <= High"}, defaultLevel = "Low")
@Lattice(
    dim = "integ",
    levels = {"Trusted", "Untrusted"},
    order = {"Trusted <= Untrusted"},
    defaultLevel = "Untrusted")
public class InfoFlow {

  static void publish(@Sec(conf = "Low") int value) {}

  static void writeTrusted(@Sec(conf = "High", integ = "Trusted") int value) {}

  @Case("(0) -> assertion error")
  @Case("(42) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void explicitLeak(@Sec(conf = "High") int secret) {
    publish(secret);
  }

  @Case("(0) -> ok")
  @Case("(42) -> ok")
  @Tag({CALL})
  public static void explicitSafe(@Sec(conf = "Low") int open) {
    publish(open + 1);
  }

  // The value is always 0, but labels are joined through arithmetic.
  @Case("(0) -> assertion error")
  @Case("(42) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void launderedThroughArithmetic(@Sec(conf = "High") int secret) {
    int x = secret * 0;
    publish(x);
  }

  @Case("(0) -> ok")
  @Case("(42) -> ok")
  @Tag({CALL})
  public static void overwrittenBeforeSink(@Sec(conf = "High") int secret) {
    int t = secret;
    t = 0;
    publish(t);
  }

  @Case("(true) -> assertion error")
  @Case("(false) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void implicitLeak(@Sec(conf = "High") boolean secret) {
    int x = 0;
    if (secret) {
      x = 1;
    }
    publish(x);
  }

  // Calling a sink under a secret branch is itself observable.
  @Case("(true) -> assertion error")
  @Case("(false) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void sinkUnderSecretBranch(@Sec(conf = "High") boolean secret) {
    if (secret) {
      publish(0);
    }
  }

  // Both returns are control-dependent on the secret (the post-dominator is the exit).
  @Case("(5) -> assertion error")
  @Case("(-5) -> assertion error")
  @Tag({IMPLICIT_FLOW, CONDITIONAL})
  @Sec(conf = "Low")
  public static int implicitReturn(@Sec(conf = "High") int secret) {
    if (secret > 0) {
      return 1;
    }
    return 0;
  }

  // pc must be lowered again at the merge point.
  @Case("(5) -> ok")
  @Case("(-5) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void pcRestoredAfterBranch(@Sec(conf = "High") int secret) {
    int x = 0;
    if (secret > 0) {
      x = 1;
    }
    int y = 5;
    publish(y);
  }

  @Case("(3) -> assertion error")
  @Case("(0) -> ok")
  @Tag({IMPLICIT_FLOW, LOOP, CALL})
  public static void loopCountLeak(@Sec(conf = "High") int secret) {
    int count = 0;
    int i = secret;
    while (i > 0) {
      count = count + 1;
      i = i - 1;
    }
    publish(count);
  }

  // Only termination depends on the secret; termination-insensitive non-interference holds.
  @Case("(3) -> ok")
  @Case("(0) -> ok")
  @Tag({LOOP, CALL})
  public static void loopThenConstant(@Sec(conf = "High") int secret) {
    int i = secret;
    while (i > 0) {
      i = i - 1;
    }
    publish(1);
  }

  // The leaking branch is dead; Interval analysis can prove it.
  @Case("(7) -> ok")
  @Case("(0) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void deadBranchLeak(@Sec(conf = "High") int secret) {
    int mode = 0;
    if (mode == 1) {
      publish(secret);
    }
  }

  @Case("(1) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void integrityExplicit(@Sec(integ = "Untrusted") int input) {
    writeTrusted(input);
  }

  @Case("(true) -> assertion error")
  @Case("(false) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void integrityImplicit(@Sec(integ = "Untrusted") boolean flag) {
    int v = 0;
    if (flag) {
      v = 1;
    }
    writeTrusted(v);
  }

  @Case("(1) -> ok")
  @Tag({CALL})
  public static void integritySafe(@Sec(conf = "High", integ = "Trusted") int input) {
    writeTrusted(input * 2);
  }

  // Unannotated inputs get the default level in every dimension: (Low, Untrusted).
  @Case("(1) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void unannotatedInput(int input) {
    writeTrusted(input);
  }
}

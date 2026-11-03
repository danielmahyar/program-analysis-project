package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/** Deep chain lattices: military-style clearances and a three-level integrity chain. */
@Lattice(
    dim = "conf",
    levels = {"Unclassified", "Restricted", "Confidential", "Secret", "TopSecret"},
    order = {
      "Unclassified <= Restricted",
      "Restricted <= Confidential",
      "Confidential <= Secret",
      "Secret <= TopSecret"
    },
    defaultLevel = "Unclassified")
@Lattice(
    dim = "integ",
    levels = {"Trusted", "Partner", "Untrusted"},
    order = {"Trusted <= Partner", "Partner <= Untrusted"},
    defaultLevel = "Untrusted")
public class Clearance {

  static void broadcast(@Sec(conf = "Unclassified") int value) {}

  static void confidentialChannel(@Sec(conf = "Confidential") int value) {}

  static void secretChannel(@Sec(conf = "Secret") int value) {}

  static void partnerFeed(@Sec(conf = "Restricted", integ = "Partner") int value) {}

  static void commandSystem(@Sec(conf = "TopSecret", integ = "Trusted") int order) {}

  // Needs the transitive closure: Restricted <= Confidential <= Secret.
  @Case("(1) -> ok")
  @Tag({CALL})
  public static void flowUpTwoLevels(@Sec(conf = "Restricted") int x) {
    secretChannel(x);
  }

  @Case("(1) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void flowDownOneLevel(@Sec(conf = "Secret") int x) {
    confidentialChannel(x);
  }

  @Case("(1) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void topSecretBroadcast(@Sec(conf = "TopSecret") int x) {
    broadcast(x);
  }

  @Case("(1, 2) -> ok")
  @Tag({CALL})
  public static void joinStaysConfidential(
      @Sec(conf = "Restricted") int a, @Sec(conf = "Confidential") int b) {
    confidentialChannel(a + b);
  }

  @Case("(1, 2) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void joinBecomesSecret(
      @Sec(conf = "Restricted") int a, @Sec(conf = "Secret") int b) {
    confidentialChannel(a + b);
  }

  // pc is Confidential ⊔ Secret = Secret inside the inner branch.
  @Case("(1, 1) -> assertion error")
  @Case("(1, -1) -> assertion error")
  @Case("(-1, 1) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void nestedBranches(
      @Sec(conf = "Confidential") int conf, @Sec(conf = "Secret") int sec) {
    int x = 0;
    if (conf > 0) {
      if (sec > 0) {
        x = 1;
      } else {
        x = 2;
      }
    }
    confidentialChannel(x);
  }

  // The Secret pc of the first branch must not reach the second.
  @Case("(1, 1) -> ok")
  @Case("(-1, -1) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void sequentialBranches(
      @Sec(conf = "Confidential") int conf, @Sec(conf = "Secret") int sec) {
    int a = 0;
    if (sec > 0) {
      a = 1;
    }
    int b = 0;
    if (conf > 0) {
      b = 1;
    }
    confidentialChannel(b);
  }

  @Case("(3, 5) -> assertion error")
  @Case("(0, 5) -> ok")
  @Case("(3, -1) -> ok")
  @Tag({IMPLICIT_FLOW, LOOP, CONDITIONAL, CALL})
  public static void secretBranchInLoop(
      @Sec(conf = "Confidential") int n, @Sec(conf = "Secret") int sec) {
    int acc = 0;
    int i = 0;
    while (i < n) {
      if (sec > i) {
        acc = acc + 1;
      }
      i = i + 1;
    }
    confidentialChannel(acc);
  }

  @Case("(1) -> ok")
  @Tag({CALL})
  public static void partnerToPartnerFeed(@Sec(conf = "Restricted", integ = "Partner") int x) {
    partnerFeed(x);
  }

  @Case("(1) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void untrustedToPartnerFeed(@Sec(integ = "Untrusted") int x) {
    partnerFeed(x);
  }

  @Case("(1) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void partnerCommand(@Sec(conf = "Secret", integ = "Partner") int order) {
    commandSystem(order);
  }

  @Case("(1, 2) -> ok")
  @Tag({CALL})
  public static void trustedCommand(
      @Sec(conf = "Secret", integ = "Trusted") int a,
      @Sec(conf = "TopSecret", integ = "Trusted") int b) {
    commandSystem(a + b);
  }
}

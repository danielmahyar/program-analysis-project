package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.Case;
import jpamb.utils.Tag;

/**
 * Information-flow cases using self-composition: each case runs the same computation twice with
 * only the secret input changed, and asserts that the observable output is the same. An assertion
 * error therefore means the secret influences the output, i.e. non-interference is violated.
 */
public class InformationFlow {

  // Explicit flow: the public dashboard shows the oncology value in thousands.
  static int dashboard(int onco) {
    return onco / 1000;
  }

  @Case("(4200, 4900) -> ok")
  @Case("(4200, 1300) -> assertion error")
  public static void explicitLeak(int onco1, int onco2) {
    assert dashboard(onco1) == dashboard(onco2);
  }

  // Implicit flow: only the branch on the secret decides the public output.
  static int alertFlag(int onco) {
    int temp = 0;
    if (onco > 5000) {
      temp = 1;
    }
    return temp;
  }

  @Case("(6000, 7000) -> ok")
  @Case("(100, 200) -> ok")
  @Case("(6000, 0) -> assertion error")
  @Tag({CONDITIONAL})
  public static void implicitBranchLeak(int onco1, int onco2) {
    assert alertFlag(onco1) == alertFlag(onco2);
  }

  // Implicit flow: the number of loop iterations reveals the secret.
  static int sessionCount(int psych) {
    int count = 0;
    int i = psych;
    while (i > 0) {
      count = count + 1;
      i = i - 1;
    }
    return count;
  }

  @Case("(3, 3) -> ok")
  @Case("(-1, -4) -> ok")
  @Case("(3, 5) -> assertion error")
  @Tag({LOOP})
  public static void implicitLoopLeak(int psych1, int psych2) {
    assert sessionCount(psych1) == sessionCount(psych2);
  }

  // Compartment flow: an oncology risk score must not depend on psychiatry data.
  static int oncologyRisk(int tumorSizeMm, int psychScore) {
    int risk = 0;
    if (tumorSizeMm > 20) {
      risk = risk + 2;
    }
    if (psychScore > 30) {
      risk = risk + 1;
    }
    return risk;
  }

  @Case("(25, 10, 20) -> ok")
  @Case("(25, 40, 50) -> ok")
  @Case("(25, 10, 40) -> assertion error")
  @Tag({CONDITIONAL})
  public static void compartmentLeak(int tumorSizeMm, int psych1, int psych2) {
    assert oncologyRisk(tumorSizeMm, psych1) == oncologyRisk(tumorSizeMm, psych2);
  }

  // Integrity: a trusted audit counter must not depend on an untrusted vendor flag.
  static int auditCounter(int trustedAccesses, boolean vendorSaysAccessed) {
    int counter = 0;
    int i = 0;
    while (i < trustedAccesses) {
      counter = counter + 1;
      i = i + 1;
    }
    if (vendorSaysAccessed) {
      counter = counter + 1;
    }
    return counter;
  }

  @Case("(3, true, true) -> ok")
  @Case("(0, false, false) -> ok")
  @Case("(3, true, false) -> assertion error")
  @Tag({LOOP, CONDITIONAL})
  public static void integrityViolation(int trustedAccesses, boolean vendor1, boolean vendor2) {
    assert auditCounter(trustedAccesses, vendor1) == auditCounter(trustedAccesses, vendor2);
  }
}

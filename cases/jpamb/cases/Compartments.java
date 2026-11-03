package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/** Powerset lattice over three projects (8 levels), where most pairs are incomparable. */
@Lattice(
    dim = "conf",
    levels = {
      "None",
      "Alpha",
      "Bravo",
      "Charlie",
      "AlphaBravo",
      "AlphaCharlie",
      "BravoCharlie",
      "All"
    },
    order = {
      "None <= Alpha",
      "None <= Bravo",
      "None <= Charlie",
      "Alpha <= AlphaBravo",
      "Alpha <= AlphaCharlie",
      "Bravo <= AlphaBravo",
      "Bravo <= BravoCharlie",
      "Charlie <= AlphaCharlie",
      "Charlie <= BravoCharlie",
      "AlphaBravo <= All",
      "AlphaCharlie <= All",
      "BravoCharlie <= All"
    },
    defaultLevel = "None")
@Lattice(
    dim = "integ",
    levels = {"Trusted", "Untrusted"},
    order = {"Trusted <= Untrusted"},
    defaultLevel = "Untrusted")
public class Compartments {

  static void alphaBravoSink(@Sec(conf = "AlphaBravo") int value) {}

  static void alphaCharlieSink(@Sec(conf = "AlphaCharlie") int value) {}

  static void bravoCharlieSink(@Sec(conf = "BravoCharlie") int value) {}

  static void allSink(@Sec(conf = "All") int value) {}

  @Case("(1, 2) -> ok")
  @Tag({CALL})
  public static void joinOfTwo(@Sec(conf = "Alpha") int a, @Sec(conf = "Bravo") int b) {
    alphaBravoSink(a + b);
  }

  @Case("(1, 2, 3) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void joinOfThree(
      @Sec(conf = "Alpha") int a, @Sec(conf = "Bravo") int b, @Sec(conf = "Charlie") int c) {
    alphaBravoSink(a + b + c);
  }

  @Case("(1, 2, 3) -> ok")
  @Tag({CALL})
  public static void joinOfThreeToTop(
      @Sec(conf = "Alpha") int a, @Sec(conf = "Bravo") int b, @Sec(conf = "Charlie") int c) {
    allSink(a + b + c);
  }

  // Bravo and AlphaCharlie are incomparable.
  @Case("(1) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void incomparableSink(@Sec(conf = "Bravo") int b) {
    alphaCharlieSink(b);
  }

  // AlphaBravo ⊔ Charlie = All, not AlphaCharlie.
  @Case("(1, 2) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void joinIsLeastUpperBound(
      @Sec(conf = "AlphaBravo") int ab, @Sec(conf = "Charlie") int c) {
    alphaCharlieSink(ab + c);
  }

  // x is Alpha ⊔ Charlie when the branch is taken.
  @Case("(1, 5) -> ok")
  @Case("(-1, 5) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void implicitWithinSink(@Sec(conf = "Alpha") int a, @Sec(conf = "Charlie") int c) {
    int x = 0;
    if (a > 0) {
      x = c;
    }
    alphaCharlieSink(x);
  }

  // Charlie ⋢ AlphaBravo already holds for the data alone, so the leak counts as explicit.
  @Case("(1, 5) -> assertion error")
  @Case("(-1, 5) -> ok")
  @Tag({EXPLICIT_FLOW, CONDITIONAL, CALL})
  public static void explicitDominatesImplicit(
      @Sec(conf = "Alpha") int a, @Sec(conf = "Charlie") int c) {
    int x = 0;
    if (a > 0) {
      x = c;
    }
    alphaBravoSink(x);
  }

  // The data (Charlie) fits BravoCharlie; only the Alpha branch condition does not.
  @Case("(1, 5) -> assertion error")
  @Case("(-1, 5) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void implicitOutsideSink(
      @Sec(conf = "Alpha") int a, @Sec(conf = "Charlie") int c) {
    int x = 0;
    if (a > 0) {
      x = c;
    }
    bravoCharlieSink(x);
  }

  // Bravo flows in through the loop condition only.
  @Case("(2, 4) -> assertion error")
  @Case("(0, 4) -> ok")
  @Tag({IMPLICIT_FLOW, LOOP, CALL})
  public static void loopGuardAddsCompartment(
      @Sec(conf = "Bravo") int rounds, @Sec(conf = "Alpha") int a) {
    int acc = 0;
    int i = 0;
    while (i < rounds) {
      acc = acc + a;
      i = i + 1;
    }
    alphaCharlieSink(acc);
  }
}

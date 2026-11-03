import java.lang.annotation.*;

// -----------------------------------------------------------------------------------------------
// Policy annotations
// -----------------------------------------------------------------------------------------------

/** Declares one security lattice (one dimension of the product lattice). */
@Repeatable(Lattices.class)
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@interface Lattice {
  /** Name of the dimension; it must match an element name of {@link Sec}. */
  String dim();

  /** All levels in this lattice. */
  String[] levels();

  /** Hasse diagram edges, each written {@code "lo <= hi"}. */
  String[] order();

  /** Level given to an annotated location that does not mention this dimension. */
  String defaultLevel();
}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@interface Lattices {
  Lattice[] value();
}

/**
 * Security label: one level per lattice dimension.
 *
 * <ul>
 *   <li>On a parameter: the label of the incoming value (a source).
 *   <li>On a static field: the clearance of that storage location (a sink). Writing a value
 *       {@code v} under program-counter label {@code pc} is allowed only if {@code label(v) ⊔ pc
 *       ⊑ label(field)} in <i>every</i> dimension. Reading it gives the value that label.
 *   <li>On a method: the clearance of the return value (a sink for {@code return}).
 * </ul>
 *
 * <p>An empty string means "not given": the lattice's {@code defaultLevel} is used.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.PARAMETER, ElementType.FIELD, ElementType.METHOD})
@interface Sec {
  String conf() default "";

  String integ() default "";
}

/**
 * Hospital diagnostics platform: an example of the security policy language.
 *
 * <p>The policy lives in two places:
 *
 * <ol>
 *   <li><b>Lattice declarations</b> ({@link Lattice}) on the class. Each one names a dimension
 *       (e.g. {@code conf}, {@code integ}), lists its levels, and gives the partial order as Hasse
 *       diagram edges {@code "lo <= hi"}. The analyzer takes the reflexive-transitive closure of
 *       those edges, checks that every pair of levels has a join (otherwise the poset is not a
 *       lattice and is rejected), and builds the product of all declared dimensions.
 *   <li><b>Labels</b> ({@link Sec}) on parameters (sources), static fields and return values
 *       (sinks), and parameters of sink methods. Each element of {@code @Sec} is named after a
 *       lattice dimension; a dimension that is left out gets that lattice's {@code defaultLevel}.
 * </ol>
 *
 * <p>All annotations use {@code RetentionPolicy.RUNTIME}, so they are stored in the class file
 * ({@code RuntimeVisible[Parameter]Annotations}) where ASM and jvm2json can read them. Local
 * variables are not annotated: declaration annotations on locals are not kept in bytecode, so
 * locals start at the product bottom and are labelled flow-sensitively by the analysis.
 *
 * <p>Each method's comment gives the expected verdict, for use as ground truth in the evaluation.
 */
@Lattice(
    dim = "conf",
    levels = {"Public", "Oncology", "Psych", "HospitalAdmin"},
    order = {
      "Public <= Oncology",
      "Public <= Psych",
      "Oncology <= HospitalAdmin",
      "Psych <= HospitalAdmin"
      // Oncology and Psych have no edge between them, so they are incomparable compartments.
    },
    defaultLevel = "Public")
@Lattice(
    dim = "integ",
    levels = {"Trusted", "Untrusted"},
    order = {"Trusted <= Untrusted"},
    defaultLevel = "Untrusted") // unannotated inputs are assumed to be attacker-controlled
public class Test {

  // ---------------------------------------------------------------------------------------------
  // Platform state (labelled storage locations)
  // ---------------------------------------------------------------------------------------------

  /** Telemetry shown on the public dashboard. */
  @Sec(conf = "Public", integ = "Untrusted")
  static int publicDashboard;

  /** Oncology department's private result store. */
  @Sec(conf = "Oncology", integ = "Untrusted")
  static int oncologyResults;

  /** Psychiatry department's private result store. */
  @Sec(conf = "Psych", integ = "Untrusted")
  static int psychResults;

  /** Cross-department report, readable only by HospitalAdmin. */
  @Sec(conf = "HospitalAdmin", integ = "Untrusted")
  static int adminReport;

  /** Audit counter: public to read, but only trusted code may influence it. */
  @Sec(conf = "Public", integ = "Trusted")
  static int auditCounter;

  /** Billing flag consumed by the trusted billing system. */
  @Sec(conf = "HospitalAdmin", integ = "Trusted")
  static boolean billingApproved;

  /**
   * A sink method. Its body is not analysed (the analysis is intraprocedural); a call is checked by
   * comparing each argument's label, joined with pc, against the callee's parameter label.
   */
  static void sendToPublicLog(@Sec(conf = "Public", integ = "Untrusted") int value) {
    publicDashboard = value;
  }

  // ---------------------------------------------------------------------------------------------
  // Benchmark methods
  // ---------------------------------------------------------------------------------------------

  /**
   * Listing 1 from the proposal. Expected: 4 violations.
   *
   * <ol>
   *   <li>explicit leak Oncology -> Public
   *   <li>compartment leak Psych -> Oncology
   *   <li>implicit leak: the branch on {@code onco} makes {@code temp} Oncology
   *   <li>integrity violation Untrusted -> Trusted
   * </ol>
   */
  public static void process(
      @Sec(conf = "Oncology", integ = "Trusted") int onco,
      @Sec(conf = "Psych", integ = "Untrusted") int psych) {
    int temp = 0;

    publicDashboard = onco; // (1) Oncology ⋢ Public
    oncologyResults = psych; // (2) Psych ⋢ Oncology
    if (onco > 5000) {
      temp = 1; // temp : (Oncology, Trusted), because pc = (Oncology, Trusted)
    }
    publicDashboard = temp; // (3) Oncology ⋢ Public
    auditCounter = psych; // (4) Untrusted ⋢ Trusted (also Psych ⋢ Public)
  }

  /** Data stays in its own compartment. Expected: ok. */
  public static void oncologyOnly(
      @Sec(conf = "Oncology", integ = "Trusted") int tumorSizeMm,
      @Sec(conf = "Oncology", integ = "Trusted") int ageYears) {
    int risk = 0;
    if (tumorSizeMm > 20) {
      risk = risk + 2;
    }
    if (ageYears > 65) {
      risk = risk + 1;
    }
    oncologyResults = risk; // (Oncology, Trusted) ⊑ (Oncology, Untrusted)
  }

  /** HospitalAdmin is the join of both compartments, so it may combine them. Expected: ok. */
  public static void adminCombinedReport(
      @Sec(conf = "Oncology") int oncoPatients, @Sec(conf = "Psych") int psychPatients) {
    adminReport = oncoPatients + psychPatients; // Oncology ⊔ Psych = HospitalAdmin
  }

  /**
   * The method's own return label is the sink. Expected: 1 violation (Oncology ⋢ Public on {@code
   * return}).
   */
  @Sec(conf = "Public")
  public static int publicRiskScore(@Sec(conf = "Oncology", integ = "Trusted") int tumorSizeMm) {
    return tumorSizeMm / 10;
  }

  /**
   * Implicit leak through a loop: the number of iterations reveals {@code sessions}. The pc stays
   * raised for the whole loop body, and the fixed point must make {@code count} Psych. Expected: 1
   * violation (Psych ⋢ Public).
   */
  public static void psychSessionCount(@Sec(conf = "Psych", integ = "Trusted") int sessions) {
    int count = 0;
    int i = sessions;
    while (i > 0) {
      count = count + 1;
      i = i - 1;
    }
    sendToPublicLog(count); // Psych ⋢ Public at the call site
  }

  /**
   * Flow-sensitivity: {@code t} first holds a secret, but is overwritten with a constant outside
   * any branch before it reaches the sink. Expected: ok.
   */
  public static void overwrittenBeforeSink(@Sec(conf = "Oncology", integ = "Trusted") int onco) {
    int t = onco;
    oncologyResults = t;
    t = 0; // t : (Public, Trusted) again
    publicDashboard = t;
  }

  /**
   * Leak on a branch that can never run: {@code mode} is always 0. A label-only analysis reports a
   * violation; combining it with Interval analysis proves the branch dead and removes the false
   * positive. Expected: ok (false positive without the numeric domain).
   */
  public static void deadBranchLeak(@Sec(conf = "Oncology", integ = "Trusted") int onco) {
    int mode = 0;
    if (mode == 1) {
      publicDashboard = onco;
    }
  }

  /**
   * Integrity, implicit flow: untrusted input decides <i>whether</i> the trusted counter is
   * incremented. The written value is computed only from trusted data, but pc is Untrusted.
   * Expected: 1 violation (Untrusted ⋢ Trusted).
   */
  public static void untrustedControlsAudit(
      @Sec(conf = "Public", integ = "Untrusted") boolean vendorSaysAccessed) {
    if (vendorSaysAccessed) {
      auditCounter = auditCounter + 1;
    }
  }

  /**
   * Trusted, public control flow updating the audit counter. Expected: ok.
   */
  public static void trustedAudit(@Sec(conf = "Public", integ = "Trusted") int accesses) {
    int i = 0;
    while (i < accesses) {
      auditCounter = auditCounter + 1;
      i = i + 1;
    }
  }

  /**
   * Both dimensions at once. The billing flag needs (HospitalAdmin, Trusted): confidentiality is
   * fine (Psych ⊑ HospitalAdmin) but integrity is not, because the diagnosis code comes from the
   * third-party tool. Expected: 1 violation (integ only).
   */
  public static void approveBilling(
      @Sec(conf = "Psych", integ = "Untrusted") int diagnosisCode,
      @Sec(conf = "Oncology", integ = "Trusted") int insuranceTier) {
    boolean ok = diagnosisCode > 100 && insuranceTier >= 2;
    billingApproved = ok; // (HospitalAdmin, Untrusted) ⋢ (HospitalAdmin, Trusted)
  }

  /**
   * Unannotated parameter: it gets {@code defaultLevel} in each dimension, i.e. (Public,
   * Untrusted). Expected: 1 violation (Untrusted ⋢ Trusted).
   */
  public static void unannotatedInput(int fromNetwork) {
    auditCounter = fromNetwork;
  }

  /**
   * Both branches assign the same constant, so no information about {@code psych} actually
   * reaches the output. A pc-based analysis still reports it, because the pc is only lowered at
   * the merge point after the assignment. Expected: ok semantically; a reported violation here is
   * a known false positive of the approach.
   */
  public static void sameValueBothBranches(@Sec(conf = "Psych", integ = "Trusted") int psych) {
    int out;
    if (psych > 0) {
      out = 1;
    } else {
      out = 1;
    }
    publicDashboard = out;
  }
}

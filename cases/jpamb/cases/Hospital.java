package jpamb.cases;

import static jpamb.utils.Tag.TagType.*;

import jpamb.utils.*;

/** Hospital platform from the proposal: incomparable department compartments under an admin. */
@Lattice(
    dim = "conf",
    levels = {"Public", "Oncology", "Psych", "HospitalAdmin"},
    order = {
      "Public <= Oncology",
      "Public <= Psych",
      "Oncology <= HospitalAdmin",
      "Psych <= HospitalAdmin"
    },
    defaultLevel = "Public")
@Lattice(
    dim = "integ",
    levels = {"Trusted", "Untrusted"},
    order = {"Trusted <= Untrusted"},
    defaultLevel = "Untrusted")
public class Hospital {

  static void publicDashboard(@Sec(conf = "Public") int value) {}

  static void oncologyRecords(@Sec(conf = "Oncology") int value) {}

  static void adminReport(@Sec(conf = "HospitalAdmin") int value) {}

  static void auditLog(@Sec(conf = "Public", integ = "Trusted") int value) {}

  static void billing(@Sec(conf = "HospitalAdmin", integ = "Trusted") boolean approved) {}

  // Listing 1 from the proposal; the first sink already fails on every input.
  @Case("(6000, 1) -> assertion error")
  @Case("(0, 0) -> assertion error")
  @Tag({EXPLICIT_FLOW, CONDITIONAL, CALL})
  public static void process(
      @Sec(conf = "Oncology", integ = "Trusted") int onco,
      @Sec(conf = "Psych", integ = "Untrusted") int psych) {
    int temp = 0;
    publicDashboard(onco);
    oncologyRecords(psych);
    if (onco > 5000) {
      temp = 1;
    }
    publicDashboard(temp);
    auditLog(psych);
  }

  @Case("(4) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void compartmentLeak(@Sec(conf = "Psych", integ = "Trusted") int psych) {
    oncologyRecords(psych);
  }

  @Case("(25, 70) -> ok")
  @Case("(5, 30) -> ok")
  @Tag({CONDITIONAL, CALL})
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
    oncologyRecords(risk);
  }

  // Oncology ⊔ Psych = HospitalAdmin.
  @Case("(10, 20) -> ok")
  @Tag({CALL})
  public static void adminCombinesDepartments(
      @Sec(conf = "Oncology") int oncoPatients, @Sec(conf = "Psych") int psychPatients) {
    adminReport(oncoPatients + psychPatients);
  }

  @Case("(10, 20) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void combinedToOneDepartment(
      @Sec(conf = "Oncology") int oncoPatients, @Sec(conf = "Psych") int psychPatients) {
    oncologyRecords(oncoPatients + psychPatients);
  }

  @Case("(35) -> assertion error")
  @Tag({EXPLICIT_FLOW})
  @Sec(conf = "Public")
  public static int publicRiskScore(@Sec(conf = "Oncology", integ = "Trusted") int tumorSizeMm) {
    return tumorSizeMm / 10;
  }

  @Case("(40) -> assertion error")
  @Case("(10) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void implicitCompartmentLeak(@Sec(conf = "Psych", integ = "Trusted") int score) {
    int flag = 0;
    if (score > 30) {
      flag = 1;
    }
    oncologyRecords(flag);
  }

  @Case("(3) -> assertion error")
  @Case("(0) -> ok")
  @Tag({IMPLICIT_FLOW, LOOP, CALL})
  public static void psychSessionCount(@Sec(conf = "Psych", integ = "Trusted") int sessions) {
    int count = 0;
    int i = sessions;
    while (i > 0) {
      count = count + 1;
      i = i - 1;
    }
    publicDashboard(count);
  }

  @Case("(7000) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void deadBranchLeak(@Sec(conf = "Oncology", integ = "Trusted") int onco) {
    int mode = 0;
    if (mode == 1) {
      publicDashboard(onco);
    }
  }

  // Both branches store the same constant, so nothing is actually leaked, but the value is still
  // stored under a Psych pc. Rejected by both the monitor and the static analysis.
  @Case("(1) -> assertion error")
  @Case("(-1) -> assertion error")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void sameValueBothBranches(@Sec(conf = "Psych", integ = "Trusted") int psych) {
    int out;
    if (psych > 0) {
      out = 1;
    } else {
      out = 1;
    }
    publicDashboard(out);
  }

  @Case("(true) -> assertion error")
  @Case("(false) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void untrustedControlsAudit(
      @Sec(conf = "Public", integ = "Untrusted") boolean vendorSaysAccessed) {
    if (vendorSaysAccessed) {
      auditLog(1);
    }
  }

  @Case("(3) -> ok")
  @Case("(0) -> ok")
  @Tag({LOOP, CALL})
  public static void trustedAudit(@Sec(conf = "Public", integ = "Trusted") int accesses) {
    int i = 0;
    while (i < accesses) {
      auditLog(i);
      i = i + 1;
    }
  }

  // Integrity holds, confidentiality does not.
  @Case("(9) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void trustedButSecret(@Sec(conf = "Oncology", integ = "Trusted") int onco) {
    auditLog(onco);
  }

  // Confidentiality holds (Psych ⊔ Oncology ⊑ HospitalAdmin), integrity does not.
  @Case("(150, 3) -> assertion error")
  @Case("(50, 3) -> assertion error")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void approveBilling(
      @Sec(conf = "Psych", integ = "Untrusted") int diagnosisCode,
      @Sec(conf = "Oncology", integ = "Trusted") int insuranceTier) {
    boolean approved = diagnosisCode > 100 && insuranceTier >= 2;
    billing(approved);
  }

  @Case("(3) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void approveBillingTrusted(
      @Sec(conf = "Oncology", integ = "Trusted") int insuranceTier) {
    boolean approved = insuranceTier >= 2;
    billing(approved);
  }
}

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
public class Hospital {

  static void publicDashboard(@Sec(conf = "Public") int value) {}

  static void oncologyRecords(@Sec(conf = "Oncology") int value) {}

  static void adminReport(@Sec(conf = "HospitalAdmin") int value) {}

  // Listing 1 from the proposal; the first sink already fails on every input.
  @Case("(6000, 1) -> assertion error")
  @Case("(0, 0) -> assertion error")
  @Tag({EXPLICIT_FLOW, CONDITIONAL, CALL})
  public static void process(
      @Sec(conf = "Oncology") int onco,
      @Sec(conf = "Psych") int psych) {
    int temp = 0;
    publicDashboard(onco);
    oncologyRecords(psych);
    if (onco > 5000) {
      temp = 1;
    }
    publicDashboard(temp);
  }

  @Case("(4) -> assertion error")
  @Tag({EXPLICIT_FLOW, CALL})
  public static void compartmentLeak(@Sec(conf = "Psych") int psych) {
    oncologyRecords(psych);
  }

  @Case("(25, 70) -> ok")
  @Case("(5, 30) -> ok")
  @Tag({CONDITIONAL, CALL})
  public static void oncologyOnly(
      @Sec(conf = "Oncology") int tumorSizeMm,
      @Sec(conf = "Oncology") int ageYears) {
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
  public static int publicRiskScore(@Sec(conf = "Oncology") int tumorSizeMm) {
    return tumorSizeMm / 10;
  }

  @Case("(40) -> assertion error")
  @Case("(10) -> ok")
  @Tag({IMPLICIT_FLOW, CONDITIONAL, CALL})
  public static void implicitCompartmentLeak(@Sec(conf = "Psych") int score) {
    int flag = 0;
    if (score > 30) {
      flag = 1;
    }
    oncologyRecords(flag);
  }

  @Case("(3) -> assertion error")
  @Case("(0) -> ok")
  @Tag({IMPLICIT_FLOW, LOOP, CALL})
  public static void psychSessionCount(@Sec(conf = "Psych") int sessions) {
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
  public static void deadBranchLeak(@Sec(conf = "Oncology") int onco) {
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
  public static void sameValueBothBranches(@Sec(conf = "Psych") int psych) {
    int out;
    if (psych > 0) {
      out = 1;
    } else {
      out = 1;
    }
    publicDashboard(out);
  }
}

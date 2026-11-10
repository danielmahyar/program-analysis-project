package jpamb.utils;

import java.lang.reflect.*;
import java.nio.file.*;
import java.util.*;

/**
 * Verifies ASM Runtime Bytecode Instrumentation (NIN) across the security benchmark classes
 * (Hospital, InfoFlow, Clearance, Compartments).
 */
public class InstrumentationTestRunner {

  private static Class<?> loadInstrumentedClass(String className, byte[] instrumentedBytes)
      throws ClassNotFoundException {
    ClassLoader customLoader = new ClassLoader(ClassLoader.getSystemClassLoader()) {
      @Override
      protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        if (name.equals(className)) {
          Class<?> c = findLoadedClass(name);
          if (c == null) {
            c = defineClass(name, instrumentedBytes, 0, instrumentedBytes.length);
          }
          if (resolve) resolveClass(c);
          return c;
        }
        return super.loadClass(name, resolve);
      }
    };
    return customLoader.loadClass(className);
  }

  public static void main(String[] args) throws Exception {
    System.out.println("======================================================================");
    System.out.println(" NIN: ASM Dynamic Bytecode Instrumentation & Shadow Monitor Runner");
    System.out.println("======================================================================\n");

    // 1. Demonstration on uninstrumented vs instrumented Hospital.process(6000, 1)
    jpamb.cases.Hospital.process(6000, 1);
    System.out.println("[1] UNINSTRUMENTED Hospital.process(6000, 1): completed with OK (leaks ignored)");

    Path hospitalIn = Paths.get("target/classes/jpamb/cases/Hospital.class");
    byte[] hospitalInst = BytecodeInstrumenter.instrument(Files.readAllBytes(hospitalIn));
    Path hospitalOut = Paths.get("target/instrumented/jpamb/cases/Hospital.class");
    Files.createDirectories(hospitalOut.getParent());
    Files.write(hospitalOut, hospitalInst);

    Class<?> instHospital = loadInstrumentedClass("jpamb.cases.Hospital", hospitalInst);
    Method processM = instHospital.getMethod("process", int.class, int.class);
    try {
      processM.invoke(null, 6000, 1);
      throw new RuntimeException("Expected AssertionError on Hospital.process(6000, 1)");
    } catch (InvocationTargetException ite) {
      System.out.println("[2] INSTRUMENTED Hospital.process(6000, 1): caught expected AssertionError:");
      System.out.println("    -> " + ite.getCause().getMessage() + "\n");
    }

    // 2. Verify all @Case methods across Hospital, InfoFlow, Clearance, and Compartments
    String[] classes = {
      "jpamb.cases.Hospital",
      "jpamb.cases.InfoFlow",
      "jpamb.cases.Clearance",
      "jpamb.cases.Compartments"
    };

    int totalCases = 0;
    int passedCases = 0;

    for (String clsName : classes) {
      String relPath = clsName.replace('.', '/') + ".class";
      byte[] rawBytes = Files.readAllBytes(Paths.get("target/classes", relPath));
      byte[] instBytes = BytecodeInstrumenter.instrument(rawBytes);
      Path outFile = Paths.get("target/instrumented", relPath);
      Files.createDirectories(outFile.getParent());
      Files.write(outFile, instBytes);

      Class<?> instCls = loadInstrumentedClass(clsName, instBytes);
      for (Method m : instCls.getDeclaredMethods()) {
        Case[] cases = jpamb.Runtime.cases(m);
        for (Case c : cases) {
          totalCases++;
          CaseContent content = CaseContent.parse(c.value());
          Object[] params = content.params();
          String expected = content.result().toString();
          String actual = "ok";
          try {
            m.invoke(null, params);
          } catch (InvocationTargetException ite) {
            actual = CaseContent.ResultType.fromThrowable(ite.getCause()).toString();
          }
          if (expected.equals(actual)) {
            passedCases++;
          } else {
            System.err.printf(
                "FAIL: %s.%s %s -> expected '%s', got '%s'%n",
                clsName, m.getName(), c.value(), expected, actual);
          }
        }
      }
    }

    System.out.printf(
        "Verified %d / %d instrumented @Case executions across %d security benchmark classes.%n",
        passedCases, totalCases, classes.length);
    if (passedCases != totalCases) {
      System.exit(1);
    }
  }
}

package jpamb;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.regex.*;
import java.util.stream.Stream;
import jpamb.cases.*;
import jpamb.utils.*;
import jpamb.utils.CaseContent.ResultType;

/**
 * The runtime method runs a single test-case and print the result or the exeception.
 *
 * <p>Usage:
 *
 * <ul>
 *   <li>{@code Runtime}: list every case.
 *   <li>{@code Runtime <method> <input>...}: run a method and print the result.
 *   <li>{@code Runtime --trace <max-steps>}: run every case and print, per case, one JSON line with
 *       the result and the instructions reached in the first {@code max-steps} steps.
 * </ul>
 *
 * <p>Case classes are loaded through {@link BytecodeInstrumenter#transform}, so a class that
 * declares a {@link Lattice} runs under the security monitor and a leak is an assertion error.
 */
public class Runtime {
  static List<Class<?>> caseclasses =
      List.of(
          Simple.class,
          Loops.class,
          Tricky.class,
          jpamb.cases.Arrays.class,
          jpamb.cases.Strings.class,
          Dependent.class,
          Calls.class,
          InformationFlow.class,
          InfoFlow.class,
          Hospital.class,
          Clearance.class,
          Compartments.class);

  /** Loads the classes in {@code jpamb.cases} through {@link BytecodeInstrumenter#transform}. */
  static final class CaseLoader extends ClassLoader {
    private final boolean coverage;

    CaseLoader(boolean coverage) {
      super(Runtime.class.getClassLoader());
      this.coverage = coverage;
    }

    @Override
    protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
      if (!name.startsWith("jpamb.cases.")) {
        return super.loadClass(name, resolve);
      }
      synchronized (getClassLoadingLock(name)) {
        Class<?> c = findLoadedClass(name);
        if (c == null) {
          byte[] bytes;
          try (InputStream in = getParent().getResourceAsStream(name.replace('.', '/') + ".class")) {
            if (in == null) {
              throw new ClassNotFoundException(name);
            }
            bytes = in.readAllBytes();
          } catch (IOException e) {
            throw new ClassNotFoundException(name, e);
          }
          byte[] transformed = BytecodeInstrumenter.transform(bytes, coverage);
          c = defineClass(name, transformed, 0, transformed.length);
        }
        if (resolve) {
          resolveClass(c);
        }
        return c;
      }
    }
  }

  public static Case[] cases(Method m) {
    var cases = m.getAnnotation(Cases.class);
    if (cases == null) {
      var c = m.getAnnotation(Case.class);
      if (c == null) return new Case[] {};
      return new Case[] {c};
    } else {
      return cases.value();
    }
  }

  public static void printType(Class<?> c, StringBuilder b) {
    if (c.equals(void.class)) {
      b.append("V");
    } else if (c.equals(int.class)) {
      b.append("I");
    } else if (c.equals(boolean.class)) {
      b.append("Z");
    } else if (c.equals(double.class)) {
      b.append("D");
    } else if (c.equals(float.class)) {
      b.append("F");
    } else if (c.equals(char.class)) {
      b.append("C");
    } else if (c.equals(int[].class)) {
      b.append("[I");
    } else if (c.equals(char[].class)) {
      b.append("[C");
    } else if (c.equals(String.class)) {
      b.append("Ljava/lang/String;");
    } else {
      throw new RuntimeException("Unknown type:" + c.toString());
    }
  }

  public static String printMethodSignature(Method m) {
    StringBuilder b = new StringBuilder();
    b.append("(");
    for (Class<?> c : m.getParameterTypes()) {
      printType(c, b);
    }
    b.append(")");
    printType(m.getReturnType(), b);
    return b.toString();
  }

  public static Class<?>[] parseMethodSignature(String s) {
    List<Class<?>> params = new ArrayList<>();
    for (int i = 0; i < s.length(); i++) {
      switch (s.charAt(i)) {
        case 'I' -> {
          params.add(int.class);
          break;
        }
        case 'Z' -> {
          params.add(boolean.class);
          break;
        }
        case 'C' -> {
          params.add(char.class);
          break;
        }
        case 'L' -> {
          i += 1;
          var start = i;
          while (i < s.length()) {
            if (s.charAt(i) == ';') {
              var str = s.substring(start, i);
              if (str.equals("java/lang/String")) {
                params.add(String.class);
                break;
              }
              throw new InputParser.ParseError("Invalid type", str);
            }
            i += 1;
          }
          break;
        }
        case '[' -> {
          i += 1;
          switch (s.charAt(i)) {
            case 'I' -> {
              params.add(int[].class);
              break;
            }
            case 'Z' -> {
              params.add(boolean[].class);
              break;
            }
            case 'C' -> {
              params.add(char[].class);
              break;
            }
          }
        }
      }
    }
    Class<?>[] rparams = new Class<?>[params.size()];
    params.toArray(rparams);

    return rparams;
  }

  public static void main(String[] args) throws ReflectiveOperationException {
    if (args.length == 0) {
      var mths = caseclasses.stream().flatMap(c -> Stream.of(c.getMethods())).toList();
      for (Method m : mths) {
        for (Case c : cases(m)) {
          CaseContent content = CaseContent.parse(c.value());
          String sig = printMethodSignature(m);
          String id = m.getDeclaringClass().getName() + "." + m.getName() + ":" + sig;
          if (!Modifier.isStatic(m.getModifiers())) {
            throw new RuntimeException("Expected " + id + " to be static");
          }
          System.out.printf("%-60s %s%n", id, content);
        }
      }
      return;
    }
    if (args[0].equals("--trace")) {
      trace(Integer.parseInt(args[1]));
      return;
    }
    String thecase = args[0];
    Pattern pattern = Pattern.compile("(.*)\\.([^.(]*):\\((.*)\\)(.*)");
    Matcher matcher = pattern.matcher(thecase);
    if (matcher.find()) {
      String cls = matcher.group(1);
      String mth = matcher.group(2);
      String prams = matcher.group(3);
      System.err.printf("Found method %s in %s with %s%n", mth, cls, prams);
      Method m =
          Class.forName(cls, true, new CaseLoader(false))
              .getMethod(mth, parseMethodSignature(prams));
      if (!Modifier.isStatic(m.getModifiers())) {
        throw new RuntimeException("Expected " + pattern + " to be static");
      }
      for (int i = 1; i < args.length; i++) {
        Object[] params = InputParser.parse(args[i]);
        System.err.printf("Running %s with %s%n", m, Arrays.toString(params));
        try {
          m.invoke(null, params);
        } catch (InvocationTargetException e) {
          System.out.println(ResultType.fromThrowable(e.getCause()));
          return;
        }
      }
      System.out.println(ResultType.SUCCESS);
    }
  }

  /**
   * Runs every case with coverage probes, each in a fresh class loader, and prints one JSON line
   * per case: the case, its result ({@code null} if the step limit was hit first) and the reached
   * instruction indices per method.
   */
  static void trace(int maxSteps) throws ReflectiveOperationException {
    for (Class<?> caseclass : caseclasses) {
      for (Method m : caseclass.getMethods()) {
        for (Case c : cases(m)) {
          CaseContent content = CaseContent.parse(c.value());
          String id = m.getDeclaringClass().getName() + "." + m.getName() + ":" + printMethodSignature(m);
          Method traced =
              Class.forName(caseclass.getName(), true, new CaseLoader(true))
                  .getMethod(m.getName(), m.getParameterTypes());

          String result;
          Coverage.start(maxSteps);
          try {
            traced.invoke(null, content.params());
            result = ResultType.SUCCESS.toString();
          } catch (InvocationTargetException e) {
            result =
                e.getCause() instanceof Coverage.StepLimit
                    ? null
                    : ResultType.fromThrowable(e.getCause()).toString();
          }
          Map<String, SortedSet<Integer>> reached = Coverage.stop();

          StringBuilder b = new StringBuilder();
          b.append("{\"case\": ").append(json(id + " " + content));
          b.append(", \"result\": ").append(result == null ? "null" : json(result));
          b.append(", \"coverage\": {");
          String sep = "";
          for (var e : reached.entrySet()) {
            b.append(sep).append(json(e.getKey())).append(": ").append(e.getValue());
            sep = ", ";
          }
          b.append("}}");
          System.out.println(b);
        }
      }
    }
  }

  static String json(String s) {
    StringBuilder b = new StringBuilder("\"");
    for (char ch : s.toCharArray()) {
      switch (ch) {
        case '"' -> b.append("\\\"");
        case '\\' -> b.append("\\\\");
        default -> {
          if (ch < 0x20) {
            b.append(String.format("\\u%04x", (int) ch));
          } else {
            b.append(ch);
          }
        }
      }
    }
    return b.append('"').toString();
  }
}

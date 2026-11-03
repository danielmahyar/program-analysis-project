package jpamb.utils;

import java.lang.annotation.*;

/**
 * Security label: one level per lattice dimension declared with {@link Lattice} on the class. An
 * empty string means the dimension is not given and its {@code defaultLevel} is used.
 *
 * <ul>
 *   <li>On a parameter of a {@link Case} method: the label of the input (a source).
 *   <li>On a parameter of any other method: the clearance of that argument (a sink).
 *   <li>On a method: the clearance of its return value (a sink).
 * </ul>
 *
 * <p>Under bytecode instrumentation every value carries two shadow labels, and pc is the join of the
 * conditions of all branches whose immediate post-dominator has not been reached yet:
 *
 * <ul>
 *   <li>{@code explicit(v)}: the join of the labels of the values {@code v} was computed from (data
 *       dependencies only; constants are bottom).
 *   <li>{@code full(v)}: the same, but every value produced (constant, operator result, load,
 *       store) is also joined with pc, so e.g. the {@code 0}/{@code 1} pushed by {@code a && b}
 *       carries the branch labels.
 * </ul>
 *
 * <p>Reaching a sink with a value {@code v} where {@code full(v) ⊔ pc ⋢ clearance} throws an {@link
 * AssertionError}; this is the outcome {@code "assertion error"} in a {@link Case}. A method is
 * tagged {@code EXPLICIT_FLOW} if its leak already shows in {@code explicit(v) ⋢ clearance}, and
 * {@code IMPLICIT_FLOW} if it only shows once pc is included. Integrity violations are tagged the
 * same way.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.PARAMETER, ElementType.METHOD})
public @interface Sec {
  String conf() default "";

  String integ() default "";
}

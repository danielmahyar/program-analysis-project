package jpamb.utils;

import java.lang.annotation.*;

/**
 * Declares one security lattice, i.e. one dimension of the product lattice used to label a case
 * class. The order is given as Hasse diagram edges {@code "lo <= hi"}; the analysis takes the
 * reflexive-transitive closure and rejects the declaration if some pair of levels has no join.
 */
@Repeatable(Lattices.class)
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Lattice {
  /** Name of the dimension; must match an element of {@link Sec} ({@code conf} or {@code integ}). */
  String dim();

  String[] levels();

  /** Hasse diagram edges, each written {@code "lo <= hi"}. */
  String[] order();

  /** Level used when a {@link Sec} annotation does not mention this dimension. */
  String defaultLevel();
}

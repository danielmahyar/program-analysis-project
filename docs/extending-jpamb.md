# Extending the Benchmark Suite

To get started with adding your own cases, please make sure to download
either `docker` or `podman` (recommended).

You can add your own cases to the benchmark suite by adding
them in the source folder:

```
src/main/java/jpamb/cases
    ├── Arrays.java
    ├── Calls.java
    ├── Loops.java
    ├── Simple.java
    ├── Tricky.java
    └── <YOUR_FILE_HERE>.java
```

Add it to the top of `src/main/java/jpamb/Runtime.java`:

```
public class Runtime {
  static List<Class<?>> caseclasses = List.of(
      Simple.class,
      Loops.class,
      Tricky.class,
      jpamb.cases.Arrays.class,
      Dependent.class, 
      Calls.class, 
      // >> INSERT CLASS HERE
);
```

You then have to update the `caseclasses` list in `src/main/java/jpamb/Runtime.java`, if
you have added a new class and then run:

```
$ uv run jpamb build
```

This will download a docker container and run the build in that. This ensures
consistent builds across systems.

**Warning:** If you create new folders and use docker, it might create them as root. To fix
this either use podman or change the permissions after.

## Updating the `benchmark.sexp` file

Finally, when everything looks good you should update the benchmark file, which contains
information about which instructions are covered by what.

In this fork the benchmark is made by running every case on the JVM with a
coverage probe before each instruction (`jpamb.Runtime --trace`), so the file
records what the code actually does, and interpreters are graded against that.
A plain `uv run jpamb build` also rebuilds the benchmark; to only rebuild it
(after compiling) run:

```
$ uv run jpamb build --benchmark
```

As upstream, you can instead record the steps an interpreter takes:

```
$ uv run jpamb build --benchmark <your_interpreter>
```

This is useful for comparing an interpreter with the JVM: run it, look at
`git diff target/stats/benchmark.sexp`, and restore the file afterwards. Do not
commit a benchmark made this way, since it would grade interpreters against that
interpreter instead of the JVM (CI rebuilds the benchmark on the JVM and fails if
it differs).

Please inspect the `target/stats/benchmark.sexp` file and ensure that only the
newly added cases has changed.

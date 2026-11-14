# Project: syntactic confidentiality analysis

A syntactic (AST) analysis of the JPAMB security cases, for confidentiality
only. It parses the Java source with tree-sitter and reads the lattice and the
`@Sec` labels from `jpamb.security` (see [docs/security.md](../../docs/security.md)).

```
src/syntactic_confidentiality.py         the analysis (main), with a MINIMUM example in find_leaks
tests/test_syntactic_confidentiality.py  runs it on a few cases
```

## Commands

Run every command from the **repository root**. `jpamb.setup()` uses the
current directory as the suite, so use `--project`, not `--directory`.

```bash
# Once, and after every change to cases/ (needs Docker running).
# --compile only compiles and decompiles; it does not touch the committed files.
uv run jpamb build --compile

# Install this project's environment
uv sync --project solutions/project-syntactic-confidentiality

# Metadata, as jpamb asks for it
uv run --project solutions/project-syntactic-confidentiality project-syntactic-confidentiality info

# One case (logs on stderr, answer on stdout)
uv run --project solutions/project-syntactic-confidentiality project-syntactic-confidentiality \
    "jpamb.cases.Clearance.flowDownOneLevel:(I)V"

# Score it on the security cases (InformationFlow has no lattice and is not matched)
uv run jpamb analyse -f "Clearance|Compartments|Hospital|InfoFlow|BasicLeaks" -- \
    uv run --project solutions/project-syntactic-confidentiality project-syntactic-confidentiality

# Quicker: one iteration, one class
uv run jpamb analyse -N 1 -f "Clearance" -- \
    uv run --project solutions/project-syntactic-confidentiality project-syntactic-confidentiality

# Tests
uv run --project solutions/project-syntactic-confidentiality \
    pytest solutions/project-syntactic-confidentiality/tests

# The lattices and labels of a class, to see what the analysis should find
uv run python solutions/syntactic/src/security_parser.py jpamb.cases.Hospital
```

## What it does

It walks the AST of the case method and gives every variable a label (a set of
compartments) with the rules in `jpamb.flow_rules`
([docs/flow-rules.md](../../docs/flow-rules.md)):

| Java | Rule |
| --- | --- |
| `42`, `true` | `rules.constant()` |
| `a + b`, `a > b`, `a && b` | `rules.binary(la, lb)` |
| `!a`, `-a` | `rules.unary(la)` |
| `int x = e;`, `x = e;`, `x += e;`, `x++;` (local) | `rules.assign(le, pc)`: inferred |
| `p = e;` (parameter) | `rules.certify(le, pc, fixed)`: `p` keeps its `@Sec` set |
| `if (c)`, `while (c)` | `rules.enter_branch(pc, lc)` |
| after `if`/`else`, `while` (until nothing changes) | `rules.merge(env1, env2)` |
| `sink(e)`, `return e` (method with `@Sec`) | `rules.certify(le, pc, clearance)` |

A leak gives `assertion error;90%`, otherwise `50%`; every other query is
`skip`. Labels and leaks are printed on stderr:

```
labels: score={Psych}, flag={Psych}
leak at line 104: oncologyRecords(flag)  ({Psych} -> {Oncology})
```

It only runs on the security cases (classes with `@Lattice`).

On the 51 security methods: 25 leaks caught, 17 correct `ok`, 7 missed, 2 false
leaks. The misses are integrity leaks (the rules only check confidentiality).
The false leaks are `deadBranchLeak`, whose leaking branch never runs, which a
syntactic analysis cannot see.

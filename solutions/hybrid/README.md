# Hybrid Confidentiality Analyzer (Syntactic AST + Dynamic Coverage-Guided Fuzzing)

A hybrid confidentiality analyzer for the JPAMB security benchmark (`@Lattice` and `@Sec`) that combines:
1. **Syntactic AST Confidentiality Analysis** (`tree-sitter` + `jpamb.flow_rules`), enhanced with:
   - **AST Constant Extraction:** pulls integer thresholds from AST expressions to seed the dynamic fuzzer.
   - **Early-Return Postdominator Propagation:** retains elevated `pc` labels after `if (secret) return ...;` statements so sequential returns are certified under the secret context.
2. **Dynamic Concrete Interpreter & Shadow Label Monitor** (`solutions/dynamic`), enhanced with:
   - **Confidentiality Monitor (`conf` dimension):** tracks explicit and implicit confidentiality violations across the lattice.
   - **Suspicion-Guided Fuzzing Budget:** scales the coverage-guided fuzzing campaign (`coverage_fuzz`) based on whether the syntactic pass detected a potential leak.
   - **Hybrid Untaken-Branch Pre-Tainting:** when a syntactic leak is not witnessed dynamically under partial coverage, probes whether an untaken branch condition was confidential and taints variables modified inside the untaken branch at its immediate postdominator (`ipdom`).
3. **Confidence-Calibrated Decision Matrix:** fuses static leak warnings, concrete runtime violation witnesses, and instruction coverage into calibrated JPAMB predictions.

## Layout

The concrete stage uses `dynamic.make_runner` and the shared confidentiality
monitor, including fixed destinations, `jpamb.confidentiality.Config`, return
defaults, control-dependency handling, and incomplete-execution statuses. Optional
untaken-branch tainting remains a separate hypothetical analysis: its findings
are stored separately from concrete witnesses.

Prediction names such as `confirmed-safe` and `syntactic-false-positive` are
JPAMB calibration categories, not proofs derived from instruction coverage.
General calls and recursion in the new AdvancedLeaks cases are outside the
shared concrete confidentiality subset and return `unsupported`. They need
separate interprocedural support before claiming full concrete benchmark coverage.

Run the artifact-independent integration checks from the repository root with:

```bash
python -m pytest solutions/hybrid/tests/test_hybrid_runner_compatibility.py -q
```

The original `test_hybrid.py` additionally requires generated JPAMB bytecode.

```text
solutions/hybrid/
├── pyproject.toml
├── README.md
├── src/
│   └── hybrid.py
└── tests/
    └── test_hybrid.py
```

## Commands

Run from the **repository root**:

```bash
# Single security case
uv run --project solutions/project-syntactic-confidentiality \
    python solutions/hybrid/src/hybrid.py \
    "jpamb.cases.Hospital.deadBranchLeak:(I)V"

# Run tests
uv run --project solutions/project-syntactic-confidentiality \
    pytest solutions/hybrid/tests

# Score on the security cases
uv run jpamb analyse -f "Clearance|Compartments|Hospital|InfoFlow|BasicLeaks" -- \
    uv run --project solutions/project-syntactic-confidentiality \
    python solutions/hybrid/src/hybrid.py
```

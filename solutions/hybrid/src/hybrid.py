#!/usr/bin/env python3
"""
Hybrid Confidentiality Analyzer (Syntactic AST + Dynamic Coverage-Guided Fuzzing).

Combines:
1. Syntactic AST Confidentiality Analysis (`tree-sitter` + `jpamb.flow_rules`),
   including postdominator-style branch context propagation across early returns
   and AST constant extraction for fuzzing seeds.
2. Dynamic Concrete Bytecode Interpreter + Shadow Label Monitor (`security_monitor`)
   driven by the coverage-guided fuzzer (`coverage_fuzz`), enhanced with
   hybrid untaken-branch control-label pre-tainting at branch postdominators.
3. Confidence-calibrated decision fusion combining static syntactic findings
   with dynamic runtime witnesses and bytecode instruction coverage.

Run from the repository root:

    uv run jpamb analyse -f "Clearance|Compartments|Hospital|InfoFlow|BasicLeaks" -N 1 -- \
        uv run --project solutions/hybrid python solutions/hybrid/src/hybrid.py
"""

from __future__ import annotations

import sys
import time
from dataclasses import dataclass, field
from pathlib import Path

# Allow importing sibling modules in `solutions/dynamic/src` and `solutions/project-syntactic-confidentiality/src`
ROOT = Path(__file__).resolve().parents[3]
DYNAMIC_SRC = ROOT / "solutions" / "dynamic" / "src"
SYNTACTIC_SRC = ROOT / "solutions" / "project-syntactic-confidentiality" / "src"
for p in (str(DYNAMIC_SRC), str(SYNTACTIC_SRC)):
    if p not in sys.path:
        sys.path.insert(0, p)

import coverage_fuzz
import dynamic as dyn
import fuzz_contract
import fuzz_inputs
import fuzz_reports
import security_monitor
import syntactic_confidentiality as sc
import tree_sitter
import tree_sitter_java

import jpamb
import jvm
import jvm.state as jvmc
from jpamb import flow_rules as rules
from jpamb.flow_rules import Label
from jpamb.security import ClassSecurityPolicy

NAME = "hybrid-confidentiality"
VERSION = "1.0"
GROUP = "LineaRIZZability"
TAGS = ["hybrid", "syntactic", "dynamic", "confidentiality", "python"]

JAVA = tree_sitter.Language(tree_sitter_java.language())

Env = dict[str, Label]

LITERALS = {
    "decimal_integer_literal",
    "hex_integer_literal",
    "octal_integer_literal",
    "binary_integer_literal",
    "decimal_floating_point_literal",
    "character_literal",
    "string_literal",
    "true",
    "false",
    "null_literal",
}


def text(node: tree_sitter.Node | None) -> str:
    return node.text.decode() if node is not None and node.text is not None else ""


# -----------------------------------------------------------------------------
# Stage 1: Syntactic AST Confidentiality Pass & AST Constant / Branch Analysis
# -----------------------------------------------------------------------------


@dataclass
class SyntacticSummary:
    leaks: list[str] = field(default_factory=list)
    env: Env = field(default_factory=dict)
    constants: list[int] = field(default_factory=list)
    has_secret_early_return: bool = False
    has_unconditional_leak: bool = False


def _extract_ast_constants(node: tree_sitter.Node | None, out: list[int]):
    if node is None:
        return
    if node.type in (
        "decimal_integer_literal",
        "hex_integer_literal",
        "octal_integer_literal",
        "binary_integer_literal",
    ):
        raw = text(node).replace("_", "").rstrip("lL")
        try:
            out.append(fuzz_inputs.signed_int(int(raw, 0)))
        except ValueError:
            pass
    elif node.type == "unary_expression":
        op_node = node.child_by_field_name("operand")
        if (
            text(node).strip().startswith("-")
            and op_node is not None
            and "integer_literal" in op_node.type
        ):
            raw = text(node).replace("_", "").rstrip("lL")
            try:
                out.append(fuzz_inputs.signed_int(int(raw, 0)))
            except ValueError:
                pass
            return
    for child in node.named_children:
        _extract_ast_constants(child, out)


def _has_secret_early_return(
    node: tree_sitter.Node | None,
    analysis: sc.Analysis,
    env: Env,
    pc: Label,
) -> bool:
    if node is None:
        return False
    if node.type == "if_statement":
        cond_node = node.child_by_field_name("condition")
        cond_lbl = analysis.expr(cond_node, env, pc)
        body_pc = rules.enter_branch(pc, cond_lbl)
        conseq = node.child_by_field_name("consequence")
        alt = node.child_by_field_name("alternative")
        if body_pc != rules.PUBLIC and (
            analysis._has_abrupt_flow(conseq) or analysis._has_abrupt_flow(alt)
        ):
            return True
    return any(
        _has_secret_early_return(c, analysis, env, pc) for c in node.named_children
    )


def run_syntactic_analysis(
    suite: jpamb.Suite,
    policy: ClassSecurityPolicy,
    methodid: jvm.AbsMethodID,
) -> SyntacticSummary:
    """Run the enhanced syntactic AST confidentiality pass (`sc.Analysis`) on `methodid`."""
    method_policy = policy.method(methodid)
    source = suite.sourcefile(methodid.classname).read_bytes()
    tree = tree_sitter.Parser(JAVA).parse(source)
    query = tree_sitter.Query(
        JAVA,
        f"""
        (method_declaration
            name: ((identifier) @name (#eq? @name "{methodid.extension.name}"))) @method
        """,
    )
    matches = tree_sitter.QueryCursor(query).captures(tree.root_node).get("method", [])
    target_node = None
    for candidate in matches:
        p_node = candidate.child_by_field_name("parameters")
        params = p_node.named_children if p_node is not None else []
        if len(params) == len(methodid.extension.params):
            target_node = candidate
            break
    if target_node is None and matches:
        target_node = matches[0]

    analysis = sc.Analysis(policy, method_policy, tree_root=tree.root_node)
    constants: list[int] = []
    secret_early_ret = False
    if target_node is not None:
        p_node = target_node.child_by_field_name("parameters")
        params = p_node.named_children if p_node is not None else []
        names = [text(p.child_by_field_name("name")) for p in params]
        analysis.fixed = dict(zip(names, analysis.lattice.param_labels(method_policy)))
        env = dict(analysis.fixed)
        body_node = target_node.child_by_field_name("body")
        _extract_ast_constants(body_node, constants)
        secret_early_ret = _has_secret_early_return(
            body_node, analysis, dict(env), rules.PUBLIC
        )
        env = analysis.stmt(body_node, env, rules.PUBLIC)
    else:
        env = {}

    return SyntacticSummary(
        leaks=list(analysis.leaks.keys()),
        env=env,
        constants=list(dict.fromkeys(constants)),
        has_secret_early_return=secret_early_ret,
        has_unconditional_leak=bool(analysis.unconditional_leaks),
    )


# -----------------------------------------------------------------------------
# Stage 2: Hybrid Dynamic Monitor (with Untaken-Branch Static Pre-Tainting)
# -----------------------------------------------------------------------------


def branch_modified_slots(
    opcodes: list[jvm.Opcode], ipdom: list[int]
) -> dict[int, set[int]]:
    """For each conditional branch instruction `i`, compute the set of local slots
    written (`Store` / `Incr`) along any path from `i` before reaching `ipdom[i]`.

    This allows the dynamic monitor to optionally pre-taint locals modified in
    untaken branches when a secret branch condition is evaluated at runtime."""
    succs = jpamb.confidentiality.control_flow(opcodes)
    n = len(opcodes)
    result: dict[int, set[int]] = {}

    for i, op in enumerate(opcodes):
        if not isinstance(op, (jvm.If, jvm.Ifz)):
            continue
        merge = ipdom[i]
        visited: set[int] = set()
        stack = list(succs[i])
        slots: set[int] = set()
        while stack:
            curr = stack.pop()
            if curr == merge or curr >= n or curr in visited:
                continue
            visited.add(curr)
            cop = opcodes[curr]
            if isinstance(cop, (jvm.Store, jvm.Incr)):
                slots.add(cop.index)
            for nxt in succs[curr]:
                if nxt not in visited:
                    stack.append(nxt)
        result[i] = slots
    return result


class HybridSecurityMonitor(security_monitor.SecurityMonitor):
    """Shared concrete confidentiality rules plus optional hypothetical branch taints.

    The optional taints account for unexecuted writes. They are hybrid analysis
    evidence, not a concrete witness for the input that was actually executed.
    """

    def __init__(
        self,
        bc,
        policy,
        methodid,
        config=None,
        *,
        prepared=None,
        hybrid_branch_taint: bool = False,
    ):
        super().__init__(bc, policy, methodid, config, prepared=prepared)
        self.hybrid_branch_taint = hybrid_branch_taint
        self._modified_slots_cache = {}
        self._pending_branch_taints = {}

    def at(self, pc: jvmc.PC):
        super().at(pc)
        for key, (merge, label, slots) in list(self._pending_branch_taints.items()):
            if key[0] == pc.method and merge == pc.offset:
                for slot in slots:
                    # Do not invent an initialized concrete/shadow local merely
                    # because another branch could have assigned it.
                    if slot in self.frame.locals:
                        self.frame.locals[slot] = self.frame.locals[slot].under(
                            label, self.lattice
                        )
                del self._pending_branch_taints[key]

    def branch(self, offset: int, consumed: int):
        super().branch(offset, consumed)
        if not self.hybrid_branch_taint:
            return
        frame = self.frame
        elevated = frame.contexts[offset]
        if self.lattice.le(elevated, self.bot):
            return
        model = frame.model
        mid = model.method.id
        if mid not in self._modified_slots_cache:
            pdom = model.postdom
            ipdom = []
            for index in range(len(model.method.opcodes)):
                strict = pdom[index] - {index}
                ipdom.append(
                    next(
                        (node for node in strict if pdom[node] == strict),
                        len(model.method.opcodes),
                    )
                )
            self._modified_slots_cache[mid] = (
                ipdom,
                branch_modified_slots(model.method.opcodes, ipdom),
            )
        ipdom, modified = self._modified_slots_cache[mid]
        slots = modified.get(offset, set())
        if slots:
            self._pending_branch_taints[(mid, offset)] = (
                ipdom[offset],
                elevated,
                slots,
            )


def make_hybrid_runner(
    bc: jpamb.Bytecode,
    policy: ClassSecurityPolicy | None,
    *,
    hybrid_branch_taint: bool = False,
):
    """Use the shared runner's budgets, fresh state, configuration, and results."""

    def monitor_factory(bytecode, active_policy, method_id, config, *, prepared):
        if active_policy is None:
            return security_monitor.NoMonitor()
        return HybridSecurityMonitor(
            bytecode,
            active_policy,
            method_id,
            config,
            prepared=prepared,
            hybrid_branch_taint=hybrid_branch_taint,
        )

    return dyn.make_runner(bc, policy, monitor_factory=monitor_factory)


# -----------------------------------------------------------------------------
# Stage 3: Hybrid Orchestration & Decision Fusion
# -----------------------------------------------------------------------------


@dataclass
class HybridReport:
    syntactic: SyntacticSummary
    dynamic_outcomes: dict[str, int]
    dynamic_findings: tuple[coverage_fuzz.Finding, ...]
    hybrid_pre_taint_findings: tuple[coverage_fuzz.Finding, ...]
    runs: int
    covered_instructions: int
    total_instructions: int
    predictions: dict[str, str]
    execution_statuses: dict[str, int] = field(default_factory=dict)

    @property
    def full_coverage(self) -> bool:
        return (
            self.total_instructions > 0
            and self.covered_instructions >= self.total_instructions
        )


def analyze_hybrid(
    suite: jpamb.Suite,
    bc: jpamb.Bytecode,
    policy: ClassSecurityPolicy,
    methodid: jvm.AbsMethodID,
    *,
    max_runs: int = 80,
    max_steps: int = 2500,
    timeout_sec: float = 2.0,
) -> HybridReport:
    """Execute the full hybrid confidentiality pipeline on `methodid`:
    1. Run the Syntactic AST pass to find candidate leaks and extract AST literals.
    2. Seed the coverage-guided fuzzer with both AST and bytecode constants.
       Scale the fuzzing budget based on syntactic suspicion:
       - If syntactic finds no leak, run a lightweight verification campaign (8 runs).
       - If syntactic flags a leak, run the full budget to confirm with a concrete witness
         or rule out dead-branch false positives (`deadBranchLeak`).
    3. If syntactic flagged a leak that pure concrete execution did not trigger
       and coverage was partial, run a single pass with `hybrid_branch_taint=True`
       to distinguish a secret-dependent untaken branch from a public dead branch (`if (mode == 1)`).
    4. Fuse syntactic and dynamic results into calibrated JPAMB predictions.
    """
    syntactic = run_syntactic_analysis(suite, policy, methodid)
    method = bc.getmethod(methodid)

    # Budget allocation guided by syntactic suspicion
    effective_runs = max_runs if syntactic.leaks else min(12, max_runs)

    base_runner = make_hybrid_runner(bc, policy, hybrid_branch_taint=False)
    outcomes: dict[str, int] = {}
    statuses: dict[str, int] = {}
    settings = dyn.security_settings()
    covered_offsets: set[int] = set()
    runs = 0
    findings: list[coverage_fuzz.Finding] = []

    def tracking_runner(
        mid, inputs, *, step_limit, security_config=None
    ) -> fuzz_contract.RunResult:
        nonlocal runs
        runs += 1
        res = base_runner(
            mid, inputs, step_limit=step_limit, security_config=security_config
        )
        statuses[res.status] = statuses.get(res.status, 0) + 1
        for pc in res.coverage:
            if pc.method == methodid:
                covered_offsets.add(pc.offset)
        if res.status == "completed" and res.outcome is not None:
            outcomes[res.outcome] = outcomes.get(res.outcome, 0) + 1
        return res

    # Combine AST constants and bytecode constants for fuzzing seeds
    bc_ints, _ = dyn.collect_constants(bc, methodid)
    combined_constants = list(dict.fromkeys(syntactic.constants + bc_ints))

    if all(isinstance(p, (jvm.Int, jvm.Boolean)) for p in methodid.extension.params):
        space = fuzz_inputs.InputSpace(
            tuple(methodid.extension.params),
            fuzz_inputs.interesting_integers(combined_constants),
        )
        seeds = dyn.build_seeds(space, combined_constants)
        campaign = coverage_fuzz.fuzz(
            methodid,
            space,
            tracking_runner,
            config=coverage_fuzz.FuzzConfig(
                max_executions=effective_runs,
                step_limit=max_steps,
                timeout_seconds=timeout_sec,
                seed=0,
                seed_limit=max(1, len(seeds)),
            ),
            seeds=seeds,
            security_config=settings,
        )
        findings = list(campaign.findings)
        saved = fuzz_reports.maybe_save_campaign(
            campaign,
            suite=suite,
            bytecode=bc,
            input_space=space,
            seed_inputs=seeds,
            producer=NAME,
            producer_version=VERSION,
        )
        if saved is not None:
            print(f"saved fuzz report: {saved}", file=sys.stderr)
    else:
        deadline = time.monotonic() + timeout_sec
        for inp in dyn.fallback_complex_inputs(bc, methodid):
            if runs >= effective_runs or time.monotonic() > deadline:
                break
            tracking_runner(
                methodid, inp, step_limit=max_steps, security_config=settings
            )

    # Secondary check: if syntactic found a leak, but concrete dynamic execution
    # found no violation and coverage was incomplete, check with hybrid untaken-branch
    # pre-tainting on the seed corpus to distinguish secret-guarded branches from
    # public dead branches (like `int mode = 0; if (mode == 1) publish(secret);`).
    hybrid_pre_taint_findings: list[coverage_fuzz.Finding] = []
    total_insns = len(method.opcodes)
    full_cov = len(covered_offsets) >= total_insns

    if (
        syntactic.leaks
        and not findings
        and not full_cov
        and all(
            isinstance(p, (jvm.Int, jvm.Boolean)) for p in methodid.extension.params
        )
    ):
        pre_taint_runner = make_hybrid_runner(bc, policy, hybrid_branch_taint=True)
        space = fuzz_inputs.InputSpace(
            tuple(methodid.extension.params),
            fuzz_inputs.interesting_integers(combined_constants),
        )
        probe_campaign = coverage_fuzz.fuzz(
            methodid,
            space,
            pre_taint_runner,
            config=coverage_fuzz.FuzzConfig(
                max_executions=min(8, max_runs),
                step_limit=max_steps,
                timeout_seconds=0.5,
                seed=0,
                seed_limit=8,
            ),
            security_config=settings,
        )
        hybrid_pre_taint_findings = list(probe_campaign.findings)
        saved = fuzz_reports.maybe_save_campaign(
            probe_campaign,
            suite=suite,
            bytecode=bc,
            input_space=space,
            seed_inputs=space.seeds(8),
            mode="hybrid-pretaint",
            producer=NAME,
            producer_version=VERSION,
            generator="typed-mutation-v1/typed-seeds",
        )
        if saved is not None:
            print(f"saved hypothetical fuzz report: {saved}", file=sys.stderr)

    predictions = fuse_predictions(
        syntactic=syntactic,
        outcomes=outcomes,
        findings=tuple(findings),
        hybrid_pre_taint_findings=tuple(hybrid_pre_taint_findings),
        runs=runs,
        full_coverage=full_cov,
        limited_runs=statuses.get("step-limit", 0),
    )

    return HybridReport(
        syntactic=syntactic,
        dynamic_outcomes=outcomes,
        dynamic_findings=tuple(findings),
        hybrid_pre_taint_findings=tuple(hybrid_pre_taint_findings),
        runs=runs,
        covered_instructions=len(covered_offsets),
        total_instructions=total_insns,
        predictions=predictions,
        execution_statuses=statuses,
    )


def fuse_predictions(
    *,
    syntactic: SyntacticSummary,
    outcomes: dict[str, int],
    findings: tuple[coverage_fuzz.Finding, ...],
    hybrid_pre_taint_findings: tuple[coverage_fuzz.Finding, ...],
    runs: int,
    full_coverage: bool,
    limited_runs: int = 0,
) -> dict[str, str]:
    """Fuse syntactic AST leak detection with dynamic concrete witnesses and coverage.

    Uses distinct hybrid categories so JPAMB calculates the empirical optimal wager
     across the benchmark, combining syntactic + dynamic evidence."""
    has_syntactic_leak = bool(syntactic.leaks)
    has_dynamic_violation = bool(findings) or ("assertion error" in outcomes)
    has_hybrid_pretaint_violation = bool(hybrid_pre_taint_findings)
    has_dynamic_ok = "ok" in outcomes

    preds: dict[str, str] = {}
    for q in jpamb.QUERIES:
        if q == "*":
            if limited_runs == runs and runs > 0:
                preds[q] = "timeout"
            else:
                preds[q] = "not-found"
        elif q == "assertion error":
            if has_dynamic_violation and has_syntactic_leak:
                # Both static AST rules and a concrete runtime witness agree
                preds[q] = "confirmed-leak"
            elif has_dynamic_violation:
                # Concrete runtime witness found a leak without syntactic flag
                preds[q] = "dynamic-only-leak"
            elif has_syntactic_leak and full_coverage:
                # A calibrated category for an unconfirmed warning with full
                # instruction coverage; this does not prove a false positive.
                preds[q] = "syntactic-false-positive"
            elif has_syntactic_leak and not full_coverage:
                # A static warning remains unconfirmed under incomplete coverage.
                preds[q] = "syntactic-deep-leak"
            elif not has_syntactic_leak and full_coverage:
                preds[q] = "confirmed-safe"
            else:
                preds[q] = "not-found"
        elif q == "ok":
            if has_dynamic_ok and not has_dynamic_violation:
                preds[q] = "confirmed-ok"
            elif has_dynamic_ok:
                preds[q] = "partial-ok"
            else:
                preds[q] = "not-found"
        else:
            if q in outcomes:
                preds[q] = "found"
            elif full_coverage:
                preds[q] = "covered-not-found"
            else:
                preds[q] = "not-found"
    return preds


# -----------------------------------------------------------------------------
# CLI Entry Points
# -----------------------------------------------------------------------------


def interpret():
    """Step-by-step concrete interpreter entry point (`jpamb interpret`)."""
    methodid, input_val, max_steps = jpamb.getcase(
        NAME, VERSION, GROUP, TAGS, for_science=True
    )
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})
    policy = suite.security_policy(methodid.classname, eff=eff)

    state = dyn.initial(bc, methodid, input_val)
    mon = (
        HybridSecurityMonitor(bc, policy, methodid, dyn.security_settings())
        if policy is not None
        else security_monitor.NoMonitor()
    )
    last = jpamb.emit_init(state)

    for _ in range(max_steps):
        try:
            pc, state = dyn.step(bc, state, mon)
        except (NotImplementedError, jpamb.confidentiality.UnsupportedInstruction) as e:
            print(f"Interpreter stopped: {e}", file=sys.stderr)
            return
        last = jpamb.emit_step(last, pc, state)
        if isinstance(state, str):
            if mon.last_violation:
                print(mon.last_violation, file=sys.stderr)
            return


def analyse():
    """Hybrid confidentiality analysis entry point (`jpamb analyse`)."""
    methodid = jpamb.getmethodid(NAME, VERSION, GROUP, TAGS, for_science=True)
    suite, eff = jpamb.setup()
    bc = jpamb.Bytecode(suite, eff, {})
    policy = suite.security_policy(methodid.classname, eff=eff)
    assert policy is not None, (
        "hybrid confidentiality analyzer runs on security cases (@Lattice)"
    )

    report = analyze_hybrid(suite, bc, policy, methodid)

    lattice = rules.SetLattice.from_policy(policy)
    print(
        "syntactic labels: "
        + ", ".join(
            f"{x}={lattice.show(lbl)}" for x, lbl in report.syntactic.env.items()
        ),
        file=sys.stderr,
    )
    for leak in report.syntactic.leaks:
        print(f"syntactic {leak}", file=sys.stderr)
    print(
        f"dynamic: {report.runs} runs, outcomes {report.dynamic_outcomes}, "
        f"statuses {report.execution_statuses}, "
        f"coverage {report.covered_instructions}/{report.total_instructions}",
        file=sys.stderr,
    )
    for finding in report.dynamic_findings:
        print(
            f"  witness {finding.inputs.encode()} -> {finding.violation}",
            file=sys.stderr,
        )
    for finding in report.hybrid_pre_taint_findings:
        print(
            f"  hybrid-pretaint {finding.inputs.encode()} -> {finding.violation}",
            file=sys.stderr,
        )

    for query in jpamb.QUERIES:
        print(f"{query};{report.predictions[query]}")


def main():
    if len(sys.argv) == 4:
        interpret()
    else:
        analyse()


if __name__ == "__main__":
    main()

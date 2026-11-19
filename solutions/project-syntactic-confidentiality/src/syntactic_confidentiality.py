#!/usr/bin/env python3
"""
Project: syntactic confidentiality analysis.

Walks the AST of the case method and computes a label (a set of compartments)
for every variable with the rules in `jpamb.flow_rules` (docs/flow-rules.md):

    literal          rules.constant()              ∅
    a op b           rules.binary(la, lb)          L(a) ∪ L(b)
    !a, -a           rules.unary(la)               L(a)
    c ? a : b        enter_branch(pc, lc) on a, b  L(c) ∪ L(a) ∪ L(b)
    local = e        rules.assign(le, pc)          L(e) ∪ pc  (inferred, strong update)
    param = e        rules.certify(le, pc, fixed)  L(e) ∪ pc ⊆ L_fixed, label stays fixed
    sink(e), return  rules.certify(le, pc, fixed)  L(e) ∪ pc ⊆ clearance, else a leak
    if/while/for/do  rules.enter_branch(pc, lc)    pc ∪ L(c)
    after if/else    rules.merge(then, else)       union per variable

Includes:
1. Postdominator-style `pc` propagation across abrupt control flow (`return`, `break`, `continue`, `throw`).
2. Full control-flow support for `for_statement`, `do_statement`, `switch_expression` / `switch_statement`, and `ternary_expression`.
3. Interprocedural helper method AST walking for non-sink helper calls in the same class.
4. Constant propagation & dead-branch pruning (`const_env`) to statically eliminate unreachable branch false positives (`deadBranchLeak`).
5. Calibrated predictions for all JPAMB queries (`assertion error`, `ok`, `*`, etc.).

Leaks are printed on stderr; stdout is the answer jpamb reads.
"""

from __future__ import annotations

import sys

import tree_sitter
import tree_sitter_java

import jpamb
from jpamb import flow_rules as rules
from jpamb.flow_rules import Label
from jpamb.security import ClassSecurityPolicy, MethodSecurityPolicy

JAVA = tree_sitter.Language(tree_sitter_java.language())

Env = dict[str, Label]  # variable name -> its label
ConstVal = int | bool | None
ConstEnv = dict[str, ConstVal]  # variable name -> known constant value (or None)

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

ABRUPT_NODES = {
    "return_statement",
    "break_statement",
    "continue_statement",
    "throw_statement",
}


def text(node: tree_sitter.Node | None) -> str:
    return node.text.decode() if node is not None and node.text is not None else ""


def merge_consts(*cenvs: ConstEnv) -> ConstEnv:
    """Merge constant environments at a join point: keep a constant only if all
    incoming paths agree on the exact same type and value."""
    if not cenvs:
        return {}
    keys = set().union(*(c.keys() for c in cenvs))
    merged: ConstEnv = {}
    for k in keys:
        vals = [c.get(k) for c in cenvs]
        first = vals[0]
        if first is not None and all(
            type(v) is type(first) and v == first for v in vals[1:]
        ):
            merged[k] = first
        else:
            merged[k] = None
    return merged


class Analysis:
    def __init__(
        self,
        policy: ClassSecurityPolicy,
        method: MethodSecurityPolicy,
        tree_root: tree_sitter.Node | None = None,
    ):
        self.policy = policy
        self.method = method
        self.lattice = rules.SetLattice.from_policy(policy)
        self.fixed: Env = {}  # parameters: their @Sec set, never inferred
        self.leaks: dict[str, None] = {}  # ordered set: loops visit a leak again
        self.tree_root: tree_sitter.Node | None = tree_root
        self.const_env: ConstEnv = {}
        self.conditional_leaks: set[str] = set()
        self.unconditional_leaks: set[str] = set()
        self._active_helpers: set[tuple[str, int]] = set()
        self._cond_depth: int = 0

    # -- constant folding helpers (Improvement 4) -----------------------------

    def eval_const(
        self, node: tree_sitter.Node | None, cenv: ConstEnv | None = None
    ) -> ConstVal:
        """Evaluate an AST expression to a compile-time `int` or `bool` if known,
        otherwise `None`."""
        if node is None:
            return None
        cenv = self.const_env if cenv is None else cenv
        match node.type:
            case "true":
                return True
            case "false":
                return False
            case (
                "decimal_integer_literal"
                | "hex_integer_literal"
                | "octal_integer_literal"
                | "binary_integer_literal"
            ):
                raw = text(node).replace("_", "").rstrip("lL")
                try:
                    return int(raw, 0)
                except ValueError:
                    return None
            case "identifier":
                return cenv.get(text(node))
            case "parenthesized_expression" if node.named_children:
                return self.eval_const(node.named_children[0], cenv)
            case "unary_expression":
                op_val = self.eval_const(node.child_by_field_name("operand"), cenv)
                if op_val is None:
                    return None
                raw_text = text(node).strip()
                if raw_text.startswith("!") and isinstance(op_val, bool):
                    return not op_val
                if raw_text.startswith("-") and type(op_val) is int:
                    return -op_val
                if raw_text.startswith("+") and type(op_val) is int:
                    return op_val
                return None
            case "binary_expression":
                op_node = node.child_by_field_name("operator")
                op = text(op_node)
                left = self.eval_const(node.child_by_field_name("left"), cenv)
                if op == "&&" and left is False:
                    return False
                if op == "||" and left is True:
                    return True
                right = self.eval_const(node.child_by_field_name("right"), cenv)
                if left is None or right is None:
                    return None
                if type(left) is int and type(right) is int:
                    match op:
                        case "+":
                            return left + right
                        case "-":
                            return left - right
                        case "*":
                            return left * right
                        case "/" if right != 0:
                            q = abs(left) // abs(right)
                            return q if (left < 0) == (right < 0) else -q
                        case "%" if right != 0:
                            r = abs(left) % abs(right)
                            return r if left >= 0 else -r
                        case "==":
                            return left == right
                        case "!=":
                            return left != right
                        case "<":
                            return left < right
                        case "<=":
                            return left <= right
                        case ">":
                            return left > right
                        case ">=":
                            return left >= right
                if isinstance(left, bool) and isinstance(right, bool):
                    match op:
                        case "&&" | "&":
                            return left and right
                        case "||" | "|":
                            return left or right
                        case "^" | "!=":
                            return left != right
                        case "==":
                            return left == right
                return None
            case _:
                return None

    # -- expressions: compute L(e) --------------------------------------------

    def expr(self, node: tree_sitter.Node | None, env: Env, pc: Label) -> Label:
        if node is None:
            return rules.constant()
        match node.type:
            case t if t in LITERALS:  # 42, true
                return rules.constant()
            case "identifier":  # x; a local not assigned yet is ∅
                return env.get(text(node), rules.PUBLIC)
            case "parenthesized_expression":  # (e)
                return self.expr(node.named_children[0], env, pc)
            case "binary_expression":  # a + b, a > b, a && b, ...
                left = self.expr(node.child_by_field_name("left"), env, pc)
                right = self.expr(node.child_by_field_name("right"), env, pc)
                return rules.binary(left, right)
            case "unary_expression":  # !a, -a
                operand = self.expr(node.child_by_field_name("operand"), env, pc)
                return rules.unary(operand)
            case "ternary_expression":  # c ? a : b (Improvement 2)
                cond_node = node.child_by_field_name("condition")
                then_node = node.child_by_field_name("consequence")
                else_node = node.child_by_field_name("alternative")
                cond_label = self.expr(cond_node, env, pc)
                branch_pc = rules.enter_branch(pc, cond_label)
                cond_const = self.eval_const(cond_node)
                if cond_const is True:
                    return rules.assign(self.expr(then_node, env, branch_pc), cond_label)
                if cond_const is False:
                    return rules.assign(self.expr(else_node, env, branch_pc), cond_label)
                self._cond_depth += 1
                try:
                    t_lbl = self.expr(then_node, env, branch_pc)
                    e_lbl = self.expr(else_node, env, branch_pc)
                finally:
                    self._cond_depth -= 1
                return rules.binary(cond_label, rules.binary(t_lbl, e_lbl))
            case "method_invocation":  # f(a, b)
                return self.call(node, env, pc)
            case _:  # anything else: the union of its parts
                label = rules.constant()
                for child in node.named_children:
                    label = rules.binary(label, self.expr(child, env, pc))
                return label

    def _find_helper_node(
        self, name: str, arity: int
    ) -> tree_sitter.Node | None:
        if self.tree_root is None:
            return None
        query = tree_sitter.Query(
            JAVA,
            f"""
            (method_declaration
                name: ((identifier) @name (#eq? @name "{name}"))) @method
            """,
        )
        for candidate in (
            tree_sitter.QueryCursor(query).captures(self.tree_root).get("method", [])
        ):
            p_node = candidate.child_by_field_name("parameters")
            params = p_node.named_children if p_node is not None else []
            if len(params) == arity:
                return candidate
        return None

    def _analyze_helper(
        self,
        helper_node: tree_sitter.Node,
        callee_policy: MethodSecurityPolicy | None,
        arg_labels: list[Label],
        arg_consts: list[ConstVal],
        caller_pc: Label,
    ) -> Label:
        """Interprocedurally walk a non-sink helper method in the same class
        under the caller's argument labels and `pc` (Improvement 3)."""
        p_node = helper_node.child_by_field_name("parameters")
        params = p_node.named_children if p_node is not None else []
        param_names = [text(p.child_by_field_name("name")) for p in params]

        saved_method = self.method
        saved_fixed = self.fixed
        saved_consts = self.const_env
        try:
            if callee_policy is not None:
                self.method = callee_policy
                fixed_labels = self.lattice.param_labels(callee_policy)
                # Certify arguments against helper parameter @Sec annotations if present
                if callee_policy.param_constraints:
                    for lbl, constraint in zip(
                        arg_labels, callee_policy.param_constraints
                    ):
                        if constraint is not None:
                            self.check(
                                helper_node,
                                lbl,
                                caller_pc,
                                self.lattice.clearance(constraint),
                            )
                self.fixed = {
                    name: fixed
                    for name, fixed, constraint in zip(
                        param_names, fixed_labels, callee_policy.param_constraints
                    )
                    if constraint is not None
                }
            else:
                self.fixed = {}

            helper_env: Env = {
                name: rules.assign(lbl, caller_pc)
                for name, lbl in zip(param_names, arg_labels)
            }
            self.const_env = dict(zip(param_names, arg_consts))
            body = helper_node.child_by_field_name("body")
            final_env = self.stmt(body, helper_env, caller_pc)

            # Collect the union of all returned expression labels in the helper
            ret_label = rules.constant()
            if body is not None:
                ret_q = tree_sitter.Query(JAVA, "(return_statement) @ret")
                for rnode in (
                    tree_sitter.QueryCursor(ret_q).captures(body).get("ret", [])
                ):
                    if rnode.named_children:
                        ret_label = rules.binary(
                            ret_label,
                            self.expr(rnode.named_children[0], final_env, caller_pc),
                        )
            return ret_label
        finally:
            self.method = saved_method
            self.fixed = saved_fixed
            self.const_env = saved_consts

    def call(self, node: tree_sitter.Node, env: Env, pc: Label) -> Label:
        args_node = node.child_by_field_name("arguments")
        args = args_node.named_children if args_node is not None else []
        labels = [self.expr(a, env, pc) for a in args]
        arg_consts = [self.eval_const(a) for a in args]

        callee_name = text(node.child_by_field_name("name"))
        callee = self.policy.get_method(callee_name)
        if callee is not None and callee.is_sink:
            for label, sec in zip(labels, callee.param_labels):
                # Passing a value assigns the sink's fixed parameter: certify it.
                self.check(node, label, pc, self.lattice.clearance(sec))
        else:
            # Improvement 3: Interprocedural helper method analysis
            key = (callee_name, len(args))
            if key not in self._active_helpers:
                helper_node = self._find_helper_node(callee_name, len(args))
                if helper_node is not None:
                    self._active_helpers.add(key)
                    try:
                        ret_lbl = self._analyze_helper(
                            helper_node, callee, labels, arg_consts, pc
                        )
                        return rules.binary(
                            ret_lbl,
                            rules.assign(
                                rules.binary(
                                    rules.constant(),
                                    frozenset().union(*labels) if labels else rules.PUBLIC,
                                ),
                                rules.PUBLIC,
                            ),
                        )
                    finally:
                        self._active_helpers.discard(key)

        # The result of a call depends on all its arguments.
        result = rules.constant()
        for label in labels:
            result = rules.binary(result, label)
        return result

    def check(self, node: tree_sitter.Node, label: Label, pc: Label, fixed: Label):
        """Security certification: L(e) ∪ pc ⊆ L_fixed, else a leak."""
        if not rules.certify(label, pc, fixed):
            show = self.lattice.show
            msg = (
                f"leak at line {node.start_point.row + 1}: {text(node)}"
                f"  ({show(rules.assign(label, pc))} -> {show(fixed)})"
            )
            self.leaks[msg] = None
            if self._cond_depth > 0:
                self.conditional_leaks.add(msg)
            else:
                self.unconditional_leaks.add(msg)

    def write(
        self,
        node: tree_sitter.Node,
        name: str,
        label: Label,
        env: Env,
        pc: Label,
        const_val: ConstVal = None,
    ) -> Env:
        """`name = e` with L(e) = label: certify a parameter, infer a local."""
        self.const_env = {**self.const_env, name: const_val}
        if name in self.fixed:
            self.check(node, label, pc, self.fixed[name])
            return {**env, name: self.fixed[name]}
        return {**env, name: rules.assign(label, pc)}

    def _has_abrupt_flow(self, node: tree_sitter.Node | None) -> bool:
        """True if `node` contains a `return`, `break`, `continue`, or `throw`
        that exits the current branch (Improvement 1)."""
        if node is None:
            return False
        if node.type in ABRUPT_NODES:
            return True
        # Do not confuse a `break`/`continue` inside a nested loop with breaking the outer `if`
        if node.type in ("while_statement", "for_statement", "do_statement", "switch_expression", "switch_statement"):
            return any(
                c.type in ("return_statement", "throw_statement")
                or self._has_return_or_throw(c)
                for c in node.named_children
            )
        return any(self._has_abrupt_flow(c) for c in node.named_children)

    def _has_return_or_throw(self, node: tree_sitter.Node | None) -> bool:
        if node is None:
            return False
        if node.type in ("return_statement", "throw_statement"):
            return True
        return any(self._has_return_or_throw(c) for c in node.named_children)

    def _invalidate_assigned_consts(self, node: tree_sitter.Node | None):
        """Clear constant values for any variable modified inside a loop body."""
        if node is None:
            return
        if node.type == "assignment_expression":
            name = text(node.child_by_field_name("left"))
            self.const_env = {**self.const_env, name: None}
        elif node.type == "update_expression" and node.named_children:
            name = text(node.named_children[0])
            self.const_env = {**self.const_env, name: None}
        elif node.type == "local_variable_declaration":
            for decl in node.children_by_field_name("declarator"):
                name = text(decl.child_by_field_name("name"))
                self.const_env = {**self.const_env, name: None}
        for child in node.named_children:
            self._invalidate_assigned_consts(child)

    # -- statements: Env in, Env out ------------------------------------------

    def stmt(self, node: tree_sitter.Node | None, env: Env, pc: Label) -> Env:
        env, _ = self._stmt(node, env, pc)
        return env

    def _stmt(
        self, node: tree_sitter.Node | None, env: Env, pc: Label
    ) -> tuple[Env, Label]:
        if node is None:
            return env, pc
        match node.type:
            case "block":
                cur_pc = pc
                for child in node.named_children:
                    env, cur_pc = self._stmt(child, env, cur_pc)
                return env, cur_pc

            case "local_variable_declaration":  # int x = e;
                for decl in node.children_by_field_name("declarator"):
                    value = decl.child_by_field_name("value")
                    name = text(decl.child_by_field_name("name"))
                    label = self.expr(value, env, pc) if value else rules.constant()
                    cval = self.eval_const(value) if value else None
                    self.const_env = {**self.const_env, name: cval}
                    env = {**env, name: rules.assign(label, pc)}
                return env, pc

            case "expression_statement":
                e = node.named_children[0]
                return self._expr_stmt(e, env, pc), pc

            case "if_statement":
                cond_node = node.child_by_field_name("condition")
                consequence = node.child_by_field_name("consequence")
                alternative = node.child_by_field_name("alternative")

                cond = self.expr(cond_node, env, pc)
                cond_const = self.eval_const(cond_node)
                body_pc = rules.enter_branch(pc, cond)

                # Improvement 4: Constant folding / Dead-branch pruning
                if cond_const is True:
                    then_env, then_pc = self._stmt(consequence, env, body_pc)
                    next_pc = body_pc if self._has_abrupt_flow(consequence) else pc
                    return then_env, next_pc
                if cond_const is False:
                    else_env, else_pc = self._stmt(alternative, env, body_pc)
                    next_pc = body_pc if self._has_abrupt_flow(alternative) else pc
                    return else_env, next_pc

                entry_consts = dict(self.const_env)
                self._cond_depth += 1
                try:
                    self.const_env = dict(entry_consts)
                    then_env, _ = self._stmt(consequence, env, body_pc)
                    then_consts = dict(self.const_env)

                    self.const_env = dict(entry_consts)
                    else_env, _ = self._stmt(alternative, env, body_pc)
                    else_consts = dict(self.const_env)
                finally:
                    self._cond_depth -= 1

                self.const_env = merge_consts(then_consts, else_consts)

                # Improvement 1: If a branch exits abruptly (e.g. `return 1;`),
                # its arm does not merge into the fall-through environment, and
                # the elevated `body_pc` persists for subsequent statements!
                then_abrupt = self._has_abrupt_flow(consequence)
                else_abrupt = self._has_abrupt_flow(alternative)
                if then_abrupt and not else_abrupt:
                    merged_env = else_env
                    self.const_env = else_consts
                    next_pc = body_pc
                elif else_abrupt and not then_abrupt:
                    merged_env = then_env
                    self.const_env = then_consts
                    next_pc = body_pc
                elif then_abrupt and else_abrupt:
                    merged_env = rules.merge(then_env, else_env)
                    next_pc = body_pc
                else:
                    merged_env = rules.merge(then_env, else_env)
                    next_pc = pc

                return merged_env, next_pc

            case "while_statement":  # iterate to a fixed point
                cond_node = node.child_by_field_name("condition")
                body_node = node.child_by_field_name("body")
                if self.eval_const(cond_node) is False:
                    return env, pc
                self._invalidate_assigned_consts(body_node)
                next_pc = pc
                self._cond_depth += 1
                try:
                    while True:
                        cond = self.expr(cond_node, env, pc)
                        body_pc = rules.enter_branch(pc, cond)
                        body_env, _ = self._stmt(body_node, env, body_pc)
                        if self._has_abrupt_flow(body_node):
                            next_pc = body_pc
                        new_env = rules.merge(env, body_env)
                        if new_env == env:
                            return env, next_pc
                        env = new_env
                finally:
                    self._cond_depth -= 1

            case "do_statement":  # do { body } while (cond); (Improvement 2)
                body_node = node.child_by_field_name("body")
                cond_node = node.child_by_field_name("condition")
                self._invalidate_assigned_consts(body_node)
                cur_pc = pc
                while True:
                    body_env, _ = self._stmt(body_node, env, cur_pc)
                    cond = self.expr(cond_node, body_env, cur_pc)
                    next_pc = rules.enter_branch(cur_pc, cond)
                    new_env = rules.merge(env, body_env)
                    if new_env == env and next_pc == cur_pc:
                        return body_env, (next_pc if self._has_abrupt_flow(body_node) else pc)
                    env = new_env
                    cur_pc = next_pc

            case "for_statement":  # for (init; cond; update) body (Improvement 2)
                init_node = node.child_by_field_name("init")
                cond_node = node.child_by_field_name("condition")
                update_node = node.child_by_field_name("update")
                body_node = node.child_by_field_name("body")

                if init_node is not None:
                    if init_node.type == "local_variable_declaration":
                        env, pc = self._stmt(init_node, env, pc)
                    else:
                        env = self._expr_stmt(init_node, env, pc)

                if cond_node is not None and self.eval_const(cond_node) is False:
                    return env, pc

                self._invalidate_assigned_consts(body_node)
                self._invalidate_assigned_consts(update_node)
                next_pc = pc
                self._cond_depth += 1
                try:
                    while True:
                        cond = (
                            self.expr(cond_node, env, pc)
                            if cond_node is not None
                            else rules.constant()
                        )
                        body_pc = rules.enter_branch(pc, cond)
                        body_env, _ = self._stmt(body_node, env, body_pc)
                        for upd in node.children_by_field_name("update"):
                            body_env = self._expr_stmt(upd, body_env, body_pc)
                        if self._has_abrupt_flow(body_node):
                            next_pc = body_pc
                        new_env = rules.merge(env, body_env)
                        if new_env == env:
                            return env, next_pc
                        env = new_env
                finally:
                    self._cond_depth -= 1

            case "switch_expression" | "switch_statement":  # switch (c) { ... } (Improvement 2)
                cond_node = node.child_by_field_name("condition")
                body_node = node.child_by_field_name("body")
                cond = self.expr(cond_node, env, pc)
                switch_pc = rules.enter_branch(pc, cond)
                if body_node is None:
                    return env, pc
                self._invalidate_assigned_consts(body_node)
                arm_envs: list[Env] = []
                any_abrupt = False
                self._cond_depth += 1
                try:
                    for group in body_node.named_children:
                        arm_env = dict(env)
                        cur_pc = switch_pc
                        for child in group.named_children:
                            if child.type == "switch_label":
                                for lchild in child.named_children:
                                    cur_pc = rules.enter_branch(
                                        cur_pc, self.expr(lchild, arm_env, cur_pc)
                                    )
                            else:
                                arm_env, cur_pc = self._stmt(child, arm_env, cur_pc)
                        if self._has_abrupt_flow(group):
                            any_abrupt = True
                        arm_envs.append(arm_env)
                finally:
                    self._cond_depth -= 1
                merged = rules.merge(env, *arm_envs) if arm_envs else env
                return merged, (switch_pc if any_abrupt else pc)

            case "return_statement":  # a sink only with @Sec on the method
                if node.named_children and self.method.return_clearance is not None:
                    label = self.expr(node.named_children[0], env, pc)
                    clearance = self.lattice.clearance(self.method.return_clearance)
                    self.check(node, label, pc, clearance)
                return env, pc

            case _:
                return env, pc

    def _expr_stmt(self, e: tree_sitter.Node, env: Env, pc: Label) -> Env:
        if e.type == "assignment_expression":  # x = e;  x += e;
            name = text(e.child_by_field_name("left"))
            rhs = e.child_by_field_name("right")
            op = text(e.child_by_field_name("operator"))
            label = self.expr(rhs, env, pc)
            cval = self.eval_const(rhs)
            if op != "=":
                label = rules.binary(env.get(name, rules.PUBLIC), label)
                old_c = self.const_env.get(name)
                if type(old_c) is int and type(cval) is int:
                    match op:
                        case "+=":
                            cval = old_c + cval
                        case "-=":
                            cval = old_c - cval
                        case "*=":
                            cval = old_c * cval
                        case _:
                            cval = None
                else:
                    cval = None
            return self.write(e, name, label, env, pc, cval)
        if e.type == "update_expression":  # x++;  is  x = x + 1;
            name = text(e.named_children[0])
            label = rules.binary(env.get(name, rules.PUBLIC), rules.constant())
            old_c = self.const_env.get(name)
            cval: ConstVal = None
            if type(old_c) is int:
                cval = old_c + 1 if "++" in text(e) else old_c - 1
            return self.write(e, name, label, env, pc, cval)
        self.expr(e, env, pc)  # e.g. a call to a sink
        return env


def predict_queries(analysis: Analysis) -> dict[str, str]:
    """Improvement 5: Predict all JPAMB queries (`assertion error`, `ok`, `*`, etc.)
    with calibrated probabilities instead of `50%` and `skip`."""
    has_leak = bool(analysis.leaks)
    has_uncond_leak = bool(analysis.unconditional_leaks)

    preds: dict[str, str] = {}
    for query in jpamb.QUERIES:
        if query == "assertion error":
            preds[query] = "90%" if has_leak else "10%"
        elif query == "ok":
            if not has_leak:
                preds[query] = "95%"
            elif not has_uncond_leak:
                # Leak occurs only inside a conditional branch; the other branch returns ok!
                preds[query] = "80%"
            else:
                # Top-level unconditional leak fails on every input
                preds[query] = "10%"
        else:
            preds[query] = "5%"
    return preds


def main():
    methodid = jpamb.getmethodid(
        "project-syntactic-confidentiality",
        "0.2.0",
        "LineaRIZZability",
        ["syntactic", "python"],
        for_science=True,
    )
    suite, eff = jpamb.setup()

    # The policy jpamb read from the @Lattice / @Sec annotations.
    policy = suite.security_policy(methodid.classname, eff=eff)
    assert policy is not None, "only the security cases (classes with @Lattice)"
    method = policy.method(methodid)

    # The AST of the case method.
    source = suite.sourcefile(methodid.classname).read_bytes()
    tree = tree_sitter.Parser(JAVA).parse(source)
    query = tree_sitter.Query(
        JAVA,
        f"""
        (method_declaration
            name: ((identifier) @name (#eq? @name "{methodid.extension.name}"))) @method
        """,
    )
    matches = tree_sitter.QueryCursor(query).captures(tree.root_node)["method"]
    node = matches[0]
    for candidate in matches:
        p_node = candidate.child_by_field_name("parameters")
        params = p_node.named_children if p_node is not None else []
        if len(params) == len(methodid.extension.params):
            node = candidate
            break

    # Parameters have the fixed @Sec set (∅ without one), the pc starts at ∅.
    analysis = Analysis(policy, method, tree_root=tree.root_node)
    params = node.child_by_field_name("parameters").named_children
    names = [text(p.child_by_field_name("name")) for p in params]
    analysis.fixed = dict(zip(names, analysis.lattice.param_labels(method)))
    env = dict(analysis.fixed)

    env = analysis.stmt(node.child_by_field_name("body"), env, rules.PUBLIC)

    show = analysis.lattice.show
    print(
        "labels: " + ", ".join(f"{x}={show(lbl)}" for x, lbl in env.items()),
        file=sys.stderr,
    )
    for leak in analysis.leaks:
        print(leak, file=sys.stderr)

    predictions = predict_queries(analysis)
    for query in jpamb.QUERIES:
        print(f"{query};{predictions[query]}")


if __name__ == "__main__":
    main()

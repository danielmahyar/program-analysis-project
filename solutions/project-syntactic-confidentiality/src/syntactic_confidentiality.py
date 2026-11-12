#!/usr/bin/env python3
"""
Project: syntactic confidentiality analysis.

Walks the AST of the case method and computes a label (a set of compartments)
for every variable with the rules in `jpamb.flow_rules` (docs/flow-rules.md):

    literal          rules.constant()              ∅
    a op b           rules.binary(la, lb)          L(a) ∪ L(b)
    !a, -a           rules.unary(la)               L(a)
    local = e        rules.assign(le, pc)          L(e) ∪ pc  (inferred, strong update)
    param = e        rules.certify(le, pc, fixed)  L(e) ∪ pc ⊆ L_fixed, label stays fixed
    sink(e), return  rules.certify(le, pc, fixed)  L(e) ∪ pc ⊆ clearance, else a leak
    if/while (c)     rules.enter_branch(pc, lc)    pc ∪ L(c)
    after if/else    rules.merge(then, else)       union per variable

Leaks are printed on stderr; stdout is the answer jpamb reads.
"""

import sys

import tree_sitter
import tree_sitter_java

import jpamb
from jpamb import flow_rules as rules
from jpamb.flow_rules import Label
from jpamb.security import ClassSecurityPolicy, MethodSecurityPolicy

JAVA = tree_sitter.Language(tree_sitter_java.language())

Env = dict[str, Label]  # variable name -> its label

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


def text(node: tree_sitter.Node) -> str:
    return node.text.decode() if node.text is not None else ""


class Analysis:
    def __init__(self, policy: ClassSecurityPolicy, method: MethodSecurityPolicy):
        self.policy = policy
        self.method = method
        self.lattice = rules.SetLattice.from_policy(policy)
        self.fixed: Env = {}  # parameters: their @Sec set, never inferred
        self.leaks: dict[str, None] = {}  # ordered set: loops visit a leak again

    # -- expressions: compute L(e) --------------------------------------------

    def expr(self, node: tree_sitter.Node, env: Env, pc: Label) -> Label:
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
            case "method_invocation":  # f(a, b)
                return self.call(node, env, pc)
            case _:  # anything else: the union of its parts
                label = rules.constant()
                for child in node.named_children:
                    label = rules.binary(label, self.expr(child, env, pc))
                return label

    def call(self, node: tree_sitter.Node, env: Env, pc: Label) -> Label:
        args = node.child_by_field_name("arguments").named_children
        labels = [self.expr(a, env, pc) for a in args]

        sink = self.policy.get_method(text(node.child_by_field_name("name")))
        if sink is not None and sink.is_sink:
            for label, sec in zip(labels, sink.param_labels):
                # Passing a value assigns the sink's fixed parameter: certify it.
                self.check(node, label, pc, self.lattice.clearance(sec))

        # The result of a call depends on all its arguments.
        result = rules.constant()
        for label in labels:
            result = rules.binary(result, label)
        return result

    def check(self, node: tree_sitter.Node, label: Label, pc: Label, fixed: Label):
        """Security certification: L(e) ∪ pc ⊆ L_fixed, else a leak."""
        if not rules.certify(label, pc, fixed):
            show = self.lattice.show
            self.leaks[
                f"leak at line {node.start_point.row + 1}: {text(node)}"
                f"  ({show(rules.assign(label, pc))} -> {show(fixed)})"
            ] = None

    def write(self, node: tree_sitter.Node, name: str, label: Label, env: Env, pc: Label) -> Env:
        """`name = e` with L(e) = label: certify a parameter, infer a local."""
        if name in self.fixed:
            self.check(node, label, pc, self.fixed[name])
            return {**env, name: self.fixed[name]}
        return {**env, name: rules.assign(label, pc)}

    # -- statements: Env in, Env out ------------------------------------------

    def stmt(self, node: tree_sitter.Node | None, env: Env, pc: Label) -> Env:
        if node is None:
            return env
        match node.type:
            case "block":
                for child in node.named_children:
                    env = self.stmt(child, env, pc)
                return env

            case "local_variable_declaration":  # int x = e;
                for decl in node.children_by_field_name("declarator"):
                    value = decl.child_by_field_name("value")
                    label = self.expr(value, env, pc) if value else rules.constant()
                    env = {**env, text(decl.child_by_field_name("name")): rules.assign(label, pc)}
                return env

            case "expression_statement":
                e = node.named_children[0]
                if e.type == "assignment_expression":  # x = e;  x += e;
                    name = text(e.child_by_field_name("left"))
                    label = self.expr(e.child_by_field_name("right"), env, pc)
                    if text(e.child_by_field_name("operator")) != "=":
                        label = rules.binary(env.get(name, rules.PUBLIC), label)
                    return self.write(e, name, label, env, pc)
                if e.type == "update_expression":  # x++;  is  x = x + 1;
                    name = text(e.named_children[0])
                    label = rules.binary(env.get(name, rules.PUBLIC), rules.constant())
                    return self.write(e, name, label, env, pc)
                self.expr(e, env, pc)  # e.g. a call to a sink
                return env

            case "if_statement":
                cond = self.expr(node.child_by_field_name("condition"), env, pc)
                body_pc = rules.enter_branch(pc, cond)
                then_env = self.stmt(node.child_by_field_name("consequence"), env, body_pc)
                else_env = self.stmt(node.child_by_field_name("alternative"), env, body_pc)
                return rules.merge(then_env, else_env)

            case "while_statement":  # iterate to a fixed point
                while True:
                    cond = self.expr(node.child_by_field_name("condition"), env, pc)
                    body_pc = rules.enter_branch(pc, cond)
                    body_env = self.stmt(node.child_by_field_name("body"), env, body_pc)
                    new_env = rules.merge(env, body_env)
                    if new_env == env:
                        return env
                    env = new_env

            case "return_statement":  # a sink only with @Sec on the method
                if node.named_children and self.method.return_clearance is not None:
                    label = self.expr(node.named_children[0], env, pc)
                    clearance = self.lattice.clearance(self.method.return_clearance)
                    self.check(node, label, pc, clearance)
                return env

            case _:
                return env


def main():
    methodid = jpamb.getmethodid(
        "project-syntactic-confidentiality",
        "0.1.0",
        "TODO: group name",
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
    node = tree_sitter.QueryCursor(query).captures(tree.root_node)["method"][0]

    # Parameters have the fixed @Sec set (∅ without one), the pc starts at ∅.
    analysis = Analysis(policy, method)
    params = node.child_by_field_name("parameters").named_children
    names = [text(p.child_by_field_name("name")) for p in params]
    analysis.fixed = dict(zip(names, analysis.lattice.param_labels(method)))
    env = dict(analysis.fixed)

    env = analysis.stmt(node.child_by_field_name("body"), env, rules.PUBLIC)

    show = analysis.lattice.show
    print("labels: " + ", ".join(f"{x}={show(l)}" for x, l in env.items()), file=sys.stderr)
    for leak in analysis.leaks:
        print(leak, file=sys.stderr)

    # One line per query.
    for query in jpamb.QUERIES:
        if query == "assertion error":
            print(f"{query};{'90%' if analysis.leaks else '50%'}")
        else:
            print(f"{query};skip")


if __name__ == "__main__":
    main()

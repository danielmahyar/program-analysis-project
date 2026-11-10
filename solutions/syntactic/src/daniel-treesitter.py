#!/usr/bin/env python3
"""A very stupid syntactic analysis, that only checks for assertion errors."""

import logging
import re
import sys
from pathlib import Path

import tree_sitter
import tree_sitter_java

import jpamb


def main():
    methodid = jpamb.getmethodid(
        "syntaxer",
        "1.0",
        "LineaRIZZability",
        ["syntactic", "python"],
        for_science=True,
    )

    JAVA_LANGUAGE = tree_sitter.Language(tree_sitter_java.language())
    parser = tree_sitter.Parser(JAVA_LANGUAGE)

    log = logging
    log.basicConfig(level=logging.DEBUG)

    suite, _ = jpamb.setup()

    srcfile = suite.sourcefile(methodid.classname).relative_to(Path.cwd())

    with open(srcfile, "rb") as f:
        log.debug("parse sourcefile %s", srcfile)
        tree = parser.parse(f.read())

    simple_classname = str(methodid.classname.name)

    log.debug(f"{simple_classname}")

    # To figure out how to write these you can consult the
    # https://tree-sitter.github.io/tree-sitter/playground
    class_q = tree_sitter.Query(
        JAVA_LANGUAGE,
        f"""
        (class_declaration 
            name: ((identifier) @class-name 
                   (#eq? @class-name "{simple_classname}"))) @class
    """,
    )

    for node in tree_sitter.QueryCursor(class_q).captures(tree.root_node)["class"]:
        break
    else:
        log.error(f"could not find a class of name {simple_classname} in {srcfile}")

        sys.exit(-1)

    method_name = methodid.extension.name

    method_q = tree_sitter.Query(
        JAVA_LANGUAGE,
        f"""
        (method_declaration name: 
          ((identifier) @method-name (#eq? @method-name "{method_name}"))
        ) @method
    """,
    )

    for snode in tree_sitter.QueryCursor(method_q).captures(node)["method"]:
        if not (p := snode.child_by_field_name("parameters")):
            log.debug(f"Could not find parameteres of {method_name}")
            continue

        params = [c for c in p.children if c.type == "formal_parameter"]

        if len(params) != len(methodid.extension.params):
            continue

        # log.debug(methodid.extension.params)
        # log.debug(params)

        for tn, t in zip(methodid.extension.params, params):
            if (tp := t.child_by_field_name("type")) is None:
                break

            if tp.text is None:
                break

            # todo check for type.
        else:
            break
    else:
        log.warning(
            f"could not find a method of name {method_name} in {simple_classname}"
        )
        sys.exit(-1)

    # log.debug("Found method %s %s", method_name, node.range)

    body = snode.child_by_field_name("body")
    assert body and body.text
    for t in body.text.splitlines():
        log.debug("line: %s", t.decode())

    predictions = {q: "skip" for q in jpamb.QUERIES}
    predictions["null pointer"] = "-2.8"

    assert_q = tree_sitter.Query(JAVA_LANGUAGE, """(assert_statement) @assert""")
    assert_true_q = tree_sitter.Query(
        JAVA_LANGUAGE, """(assert_statement (true) @assert_true)"""
    )
    assert_false_q = tree_sitter.Query(
        JAVA_LANGUAGE, """(assert_statement (false) @assert_false)"""
    )
    assert_binary_q = tree_sitter.Query(
        JAVA_LANGUAGE,
        """(assert_statement (binary_expression) @assert_binary)""",
    )

    assert_caps = tree_sitter.QueryCursor(assert_q).captures(body)
    true_caps = tree_sitter.QueryCursor(assert_true_q).captures(body)
    false_caps = tree_sitter.QueryCursor(assert_false_q).captures(body)
    binary_caps = tree_sitter.QueryCursor(assert_binary_q).captures(body)

    assert_found = bool(assert_caps.get("assert"))
    assert_true_found = bool(true_caps.get("assert_true"))
    assert_false_found = bool(false_caps.get("assert_false"))
    assert_binary_found = bool(binary_caps.get("assert_binary"))

    assertion_error = "assert-none"
    ok_prediction = "ok-none"

    if assert_binary_found:
        log.debug("Found binary-expression assert")
        assertion_error = "assert-binary"
        ok_prediction = "ok-assert-binary"
    elif assert_true_found:
        log.debug("Found literal true assert")
        assertion_error = "assert-literal-true"
        ok_prediction = "ok-assert-literal-true"
    elif assert_false_found:
        log.debug("Found literal false assert")
        assertion_error = "assert-literal-false"
        ok_prediction = "ok-assert-literal-false"
    elif assert_found:
        log.debug("Found assertion (fallback rule)")
        assertion_error = "assert-generic"
        ok_prediction = "ok-assert-generic"
    else:
        log.debug("No assertion")
        assertion_error = "assert-none"
        ok_prediction = "ok-none"

    predictions["assertion error"] = assertion_error
    predictions["ok"] = ok_prediction

    res = tree_sitter.Query(
        JAVA_LANGUAGE,
        """(binary_expression
    left: (_)
    operator: "/"
    right: [
        (decimal_integer_literal)
        (identifier)
    ] @division_by_zero)""",
    )

    log.debug(tree_sitter.QueryCursor(res).captures(body).items())
    division_by_zero = any(
        capture_name == "division_by_zero"
        for capture_name, _ in tree_sitter.QueryCursor(res).captures(body).items()
    )

    if division_by_zero:
        predictions["divide by zero"] = "division-present"
        log.debug("Division op present: %s", division_by_zero)
    else:
        predictions["divide by zero"] = "-4.7"
        log.debug("No division op in method body")

    array_q = tree_sitter.Query(
        JAVA_LANGUAGE,
        """
        [
          (array_type)
          (array_creation_expression)
          (array_access)
        ] @array
        """,
    )
    array_found = bool(
        tree_sitter.QueryCursor(array_q).captures(snode).get("array", [])
    )
    if array_found:
        predictions["out of bounds"] = "array-present"
        log.debug("Found array usage")
    else:
        predictions["out of bounds"] = "-5.1"
        log.debug("No array usage")

    while_any_q = tree_sitter.Query(JAVA_LANGUAGE, """(while_statement) @while_any""")
    while_true_q = tree_sitter.Query(
        JAVA_LANGUAGE,
        """(while_statement
              condition: (parenthesized_expression (true)) @while_true
           ) @while_true_stmt""",
    )
    while_false_q = tree_sitter.Query(
        JAVA_LANGUAGE,
        """(while_statement
              condition: (parenthesized_expression (false)) @while_false)""",
    )

    while_nodes = (
        tree_sitter.QueryCursor(while_any_q).captures(body).get("while_any", [])
    )
    while_true_caps = tree_sitter.QueryCursor(while_true_q).captures(body)
    while_true_nodes = while_true_caps.get("while_true", [])
    while_true_stmt_nodes = while_true_caps.get("while_true_stmt", [])
    while_false_nodes = (
        tree_sitter.QueryCursor(while_false_q).captures(body).get("while_false", [])
    )

    while_any_found = bool(while_nodes)
    while_true_found = bool(while_true_nodes)
    all_while_false = bool(while_nodes) and len(while_false_nodes) == len(while_nodes)

    def has_return_statement(loop_node):
        return_q = tree_sitter.Query(
            JAVA_LANGUAGE,
            """(return_statement) @return""",
        )
        return bool(
            tree_sitter.QueryCursor(return_q).captures(loop_node).get("return", [])
        )

    while_true_with_return = any(
        has_return_statement(while_node) for while_node in while_true_stmt_nodes
    )
    while_true_without_return = while_true_found and not all(
        has_return_statement(while_node) for while_node in while_true_stmt_nodes
    )

    empty_body_non_termination = False
    for while_node in while_nodes:
        condition = while_node.child_by_field_name("condition")
        loop_body = while_node.child_by_field_name("body")
        if not condition or not loop_body or not condition.text or not loop_body.text:
            continue

        cond_text = condition.text.decode()
        body_text = loop_body.text.decode().strip()
        has_identifier_condition = re.search(r"[A-Za-z_][A-Za-z0-9_]*", cond_text)
        if body_text in ("{}", "{ }") and has_identifier_condition:
            empty_body_non_termination = True
            break

    if while_true_without_return or empty_body_non_termination:
        star_prediction = "loop-nonterminating-likely"
    elif while_true_with_return:
        star_prediction = "loop-true-with-return"
    elif all_while_false:
        star_prediction = "loop-all-false"
    elif while_any_found:
        star_prediction = "loop-unknown"
    else:
        star_prediction = "loop-none"

    log.debug(
        "loop hints - any:%s true:%s all_false:%s empty_nonterm:%s => *;%s",
        while_any_found,
        while_true_found,
        all_while_false,
        empty_body_non_termination,
        star_prediction,
    )
    predictions["*"] = star_prediction

    for q in jpamb.QUERIES:
        print(f"{q};{predictions[q]}")

    sys.exit(0)

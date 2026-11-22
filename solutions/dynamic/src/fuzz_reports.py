"""Versioned campaign reports and exact-input replay, without executing report code."""

import hashlib
import json
import math
import os
import re
import subprocess
import tempfile
import uuid
from dataclasses import asdict, dataclass
from datetime import UTC, datetime
from pathlib import Path

from coverage_fuzz import STRATEGIES, Finding, FuzzConfig, FuzzResult
from fuzz_contract import OUTCOMES, Runner, RunResult, Violation
from fuzz_inputs import InputSpace

import jpamb
import jvm
from jpamb.confidentiality import Config
from jvm.state import PC

FORMAT = "jpamb-coverage-fuzz"
VERSION = 1
ARTIFACT_DIGEST = "sha256-canonical-json-v1"
MODES = {"concrete": "concrete", "hybrid-pretaint": "hypothetical"}


class ReportError(ValueError):
    """A malformed report or a program that no longer matches its snapshot."""


@dataclass(frozen=True)
class SavedReport:
    document: dict
    method_id: jvm.AbsMethodID
    mode: str
    config: FuzzConfig
    security_config: Config
    findings: tuple[Finding, ...]


@dataclass(frozen=True)
class ReplayResult:
    finding: int
    matched: bool
    observed: RunResult
    reason: str


def _integer(value, minimum=0):
    if type(value) is not int or value < minimum:
        raise ReportError(f"expected an integer >= {minimum}")
    return value


def _mapping(value):
    if not isinstance(value, dict):
        raise ReportError("expected a JSON object")
    return value


def _list(value):
    if not isinstance(value, list):
        raise ReportError("expected a JSON array")
    return value


def _string(value):
    if not isinstance(value, str):
        raise ReportError("expected a string")
    return value


def _classname(value):
    value = _string(value)
    if not re.fullmatch(r"[A-Za-z_$][\w$]*(?:\.[A-Za-z_$][\w$]*)*", value):
        raise ReportError(f"invalid Java class name: {value!r}")
    return jvm.ClassName(value)


def _method(value):
    value = _string(value)
    method = jvm.AbsMethodID.decode(value)
    _classname(str(method.classname))
    if method.encode() != value:
        raise ReportError("method identifiers must use their canonical encoding")
    return method


def _pc(value):
    pc = PC.decode(_string(value))
    _method(pc.method.encode())
    if pc.offset < 0:
        raise ReportError("negative instruction offset")
    return pc


def _input(value, space):
    value = _string(value)
    inputs = jpamb.case.Input.decode(value)
    space.validate(inputs)
    if inputs.encode() != value:
        raise ReportError("inputs must use their canonical encoding")
    return inputs


def _security(value):
    value = _mapping(value)
    if set(value) != {"return_clearance", "local_clearances", "max_steps"}:
        raise ReportError("unrecognized confidentiality configuration fields")
    clearances = {}
    for slot, label in _mapping(value["local_clearances"]).items():
        if not re.fullmatch(r"0|[1-9][0-9]*", slot):
            raise ReportError("local clearance slots must be non-negative integers")
        clearances[int(slot)] = _string(label)
    returned = value["return_clearance"]
    if returned is not None:
        _string(returned)
    maximum = value["max_steps"]
    if maximum is not None:
        _integer(maximum)
    return Config(returned, maximum, clearances)


def parse_report(document) -> SavedReport:
    """Validate replay-critical fields before any program files are opened."""
    try:
        document = _mapping(document)
        if (
            document["format"] != FORMAT
            or type(document["schema_version"]) is not int
            or document["schema_version"] != VERSION
        ):
            raise ReportError("unsupported fuzz report format or schema version")
        mode = document["runner"]["mode"]
        if mode not in MODES or document["evidence_kind"] != MODES[mode]:
            raise ReportError("runner mode and evidence kind do not agree")
        program = _mapping(document["program"])
        if program["artifact_digest"] != ARTIFACT_DIGEST:
            raise ReportError("unsupported program snapshot digest format")
        method = _method(program["method"])
        _string(program["suite_root"])
        classes = set()
        for artifact in _list(program["artifacts"]):
            name = _classname(artifact["class"])
            if name in classes or not re.fullmatch(
                r"[0-9a-f]{64}", _string(artifact["sha256"])
            ):
                raise ReportError("invalid or duplicate program artifact")
            classes.add(name)
        if method.classname not in classes:
            raise ReportError("report is missing the root class snapshot")
        fuzz_settings = _mapping(document["configuration"]["fuzz"])
        if set(fuzz_settings) != set(asdict(FuzzConfig())):
            raise ReportError("missing or unrecognized fuzz configuration fields")
        config = FuzzConfig(**fuzz_settings)
        security = _security(document["configuration"]["confidentiality"])
        space = InputSpace(
            tuple(method.extension.params), tuple(document["generator"]["dictionary"])
        )
        for encoded in _list(document["corpus"]):
            _input(encoded, space)
        if document["generator"].get("strategy", "coverage-guided") not in STRATEGIES:
            raise ReportError("unknown search strategy")
        seeds = document["generator"]["seed_inputs"]
        if seeds is not None:
            for encoded in _list(seeds):
                _input(encoded, space)
        summary = _mapping(document["summary"])
        executions, steps = _integer(summary["executions"]), _integer(summary["steps"])
        elapsed = summary["elapsed_seconds"]
        if (
            type(elapsed) not in (int, float)
            or not math.isfinite(elapsed)
            or elapsed < 0
        ):
            raise ReportError("elapsed time must be finite and non-negative")
        if summary["stop_reason"] not in {
            "executions",
            "steps",
            "deadline",
            "input-exhausted",
        }:
            raise ReportError("unknown campaign stop reason")
        if (
            sum(
                _integer(summary["statuses"][key])
                for key in ("completed", "step-limit", "unsupported")
            )
            != executions
        ):
            raise ReportError("execution status counts do not sum to the total")
        if executions > config.max_executions or (
            config.max_steps is not None and steps > config.max_steps
        ):
            raise ReportError("reported execution budget was exceeded")
        if not set(_list(summary["outcomes"])) <= OUTCOMES:
            raise ReportError("unknown terminating outcome")
        for location in _list(summary["coverage"]):
            _pc(location)
        findings = []
        for index, entry in enumerate(_list(document["findings"]), start=1):
            if _integer(entry["id"], 1) != index:
                raise ReportError("finding IDs must be sequential, starting at one")
            violation = Violation(
                _pc(entry["violation"]["pc"]),
                *(
                    _string(entry["violation"][key])
                    for key in ("target", "effective", "allowed", "context", "kind")
                ),
            )
            finding = Finding(
                _input(entry["input"], space),
                violation,
                _integer(entry["discovered_at"]["execution"], 1),
                _integer(entry["discovered_at"]["total_steps"]),
                _integer(entry["step_limit"], 1),
            )
            if (
                finding.execution > executions
                or finding.total_steps > steps
                or finding.step_limit > config.step_limit
            ):
                raise ReportError("finding lies outside its campaign budget")
            if violation.pc.method.classname not in classes:
                raise ReportError("finding class is absent from the program snapshot")
            findings.append(finding)
        return SavedReport(document, method, mode, config, security, tuple(findings))
    except ReportError:
        raise
    except (
        KeyError,
        TypeError,
        ValueError,
        IndexError,
        AssertionError,
        NotImplementedError,
    ) as exc:
        raise ReportError(f"invalid fuzz report: {exc}") from exc


def _artifact_path(suite, classname):
    path = suite.decompiledfile(_classname(str(classname))).resolve()
    if not path.is_relative_to(suite.decompiled_folder.resolve()):
        raise ReportError("program artifact escapes the decompiled directory")
    return path


def _revision(root):
    try:
        commit = (
            subprocess.check_output(
                ["git", "rev-parse", "HEAD"],
                cwd=root,
                stderr=subprocess.DEVNULL,
                timeout=5,
            )
            .decode()
            .strip()
        )
        dirty = bool(
            subprocess.check_output(
                ["git", "status", "--porcelain"],
                cwd=root,
                stderr=subprocess.DEVNULL,
                timeout=5,
            ).strip()
        )
        return {"commit": commit, "dirty": dirty}
    except (OSError, subprocess.SubprocessError):
        return {"commit": None, "dirty": None}


def _artifact_digest(path):
    # Normalize formatting so snapshots survive newline/key-order differences.
    payload = json.loads(path.read_text(encoding="utf-8"))
    canonical = json.dumps(
        payload, sort_keys=True, separators=(",", ":"), allow_nan=False
    )
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def create_report(
    campaign: FuzzResult,
    *,
    suite,
    bytecode,
    input_space: InputSpace,
    seed_inputs=None,
    mode="concrete",
    producer="coverage-fuzz",
    producer_version="1",
    generator="unspecified",
) -> SavedReport:
    if mode not in MODES:
        raise ReportError(f"unknown runner mode: {mode}")
    if tuple(campaign.method_id.extension.params) != input_space.parameters:
        raise ReportError("input space does not match the saved method signature")
    settings = campaign.security_config
    if settings is None:
        settings = Config()
    if not isinstance(settings, Config):
        raise ReportError("only jpamb.confidentiality.Config can be saved for replay")
    artifacts = []
    classes = {campaign.method_id.classname} | {
        mid.classname for mid in bytecode.methods
    }
    for classname in sorted(classes, key=str):
        path = _artifact_path(suite, classname)
        artifacts.append(
            {
                "class": str(classname),
                "sha256": _artifact_digest(path),
            }
        )
    security = {
        "return_clearance": settings.return_clearance,
        "max_steps": settings.max_steps,
        "local_clearances": {
            str(slot): label
            for slot, label in sorted(settings.local_clearances.items())
        },
    }
    document = {
        "format": FORMAT,
        "schema_version": VERSION,
        "created_at": datetime.now(UTC).isoformat(),
        "runner": {"mode": mode, "producer": producer, "version": producer_version},
        "evidence_kind": MODES[mode],
        "program": {
            "artifact_digest": ARTIFACT_DIGEST,
            "method": campaign.method_id.encode(),
            "suite_root": str(suite.workdir),
            "artifacts": artifacts,
            "revision": _revision(suite.workdir),
        },
        "configuration": {"fuzz": asdict(campaign.config), "confidentiality": security},
        "generator": {
            "name": generator,
            "strategy": campaign.strategy,
            "dictionary": list(input_space.dictionary),
            "seed_inputs": None
            if seed_inputs is None
            else [v.encode() for v in seed_inputs[: campaign.config.seed_limit]],
        },
        "summary": {
            "executions": campaign.executions,
            "steps": campaign.steps,
            "elapsed_seconds": campaign.elapsed_seconds,
            "stop_reason": campaign.stop_reason,
            "statuses": {
                "completed": campaign.completed_runs,
                "step-limit": campaign.limited_runs,
                "unsupported": campaign.unsupported_runs,
            },
            "outcomes": sorted(campaign.outcomes),
            "coverage": sorted(pc.encode() for pc in campaign.coverage),
        },
        "corpus": [value.encode() for value in campaign.corpus],
        "findings": [
            {
                "id": index,
                "input": finding.inputs.encode(),
                "violation": {
                    **asdict(finding.violation),
                    "pc": finding.violation.pc.encode(),
                },
                "step_limit": finding.step_limit,
                "discovered_at": {
                    "execution": finding.execution,
                    "total_steps": finding.total_steps,
                },
            }
            for index, finding in enumerate(campaign.findings, start=1)
        ],
    }
    return parse_report(document)


def write_report(report: SavedReport, path: Path) -> Path:
    """Atomically replace the requested output file, including a valid empty report."""
    parse_report(report.document)
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            newline="\n",
            dir=path.parent,
            prefix=".fuzz-report-",
            delete=False,
        ) as stream:
            temporary = Path(stream.name)
            json.dump(
                report.document, stream, indent=2, sort_keys=True, allow_nan=False
            )
            stream.write("\n")
        os.replace(temporary, path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)
    return path


def _nonfinite(value):
    raise ReportError(f"non-finite JSON number: {value}")


def read_report(path: Path) -> SavedReport:
    return parse_report(
        json.loads(Path(path).read_text(encoding="utf-8"), parse_constant=_nonfinite)
    )


def verify_program(report: SavedReport, suite):
    for artifact in report.document["program"]["artifacts"]:
        path = _artifact_path(suite, artifact["class"])
        if not path.is_file():
            raise ReportError(
                f"missing bytecode/policy artifact {path}; build the saved program first"
            )
        if _artifact_digest(path) != artifact["sha256"]:
            raise ReportError(
                f"program changed: {artifact['class']}; replay requires the saved bytecode and policies"
            )


def replay_finding(report: SavedReport, number: int, runner: Runner) -> ReplayResult:
    if type(number) is not int or not 1 <= number <= len(report.findings):
        raise ReportError(f"finding must be between 1 and {len(report.findings)}")
    finding = report.findings[number - 1]
    observed = runner(
        report.method_id,
        finding.inputs,
        step_limit=finding.step_limit,
        security_config=report.security_config,
    )
    if observed.steps > finding.step_limit:
        raise ReportError("replay runner exceeded the recorded instruction budget")
    matched = (
        observed.status == "completed" and finding.violation in observed.violations
    )
    reason = (
        "same violation reproduced"
        if matched
        else (
            observed.detail
            or f"recorded violation was not reproduced ({observed.status}, {observed.outcome})"
        )
    )
    return ReplayResult(number, matched, observed, reason)


def maybe_save_campaign(
    campaign,
    *,
    suite,
    bytecode,
    input_space,
    seed_inputs,
    mode="concrete",
    producer="dynamic",
    producer_version="2.0",
    generator="typed-mutation-v1/boundary-seeds",
):
    """Opt-in export for JPAMB entry points; never writes to prediction stdout."""
    directory = os.environ.get("JPAMB_FUZZ_REPORT_DIR")
    if not directory:
        return None
    report = create_report(
        campaign,
        suite=suite,
        bytecode=bytecode,
        input_space=input_space,
        seed_inputs=seed_inputs,
        mode=mode,
        producer=producer,
        producer_version=producer_version,
        generator=generator,
    )
    stem = re.sub(r"[^A-Za-z0-9._-]", "_", campaign.method_id.encode())[:140]
    path = Path(directory) / f"{stem}-{producer}-{mode}-{uuid.uuid4().hex[:8]}.json"
    return write_report(report, path)

#!/usr/bin/env python3
"""Build one PDF containing every standalone proof dossier in the repository.

The script compiles each dossier independently, then assembles the resulting PDFs in
`proofs/compendium-manifest.txt` order. Generated TeX, auxiliary files, and PDFs live in a temporary
workspace; only the requested final PDF is copied out.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass


def find_repo_root() -> Path:
    for candidate in Path(__file__).resolve().parents:
        if (candidate / "lakefile.toml").is_file() and (candidate / "proofs").is_dir():
            return candidate
    raise RuntimeError("could not locate the projectkoios-formal repository root")


REPO_ROOT = find_repo_root()
PROOFS_ROOT = REPO_ROOT / "proofs"
LEAN_ROOT = REPO_ROOT / "ProjectKoios"
THEOREM_MANIFEST = REPO_ROOT / "docs" / "theorem-manifest.md"
DEFAULT_MANIFEST = PROOFS_ROOT / "compendium-manifest.txt"
EXCLUDED_NAMES = {"template.tex", "compendium.tex", "dossier-preamble.tex"}
WARNING_RE = re.compile(r"Overfull|Underfull|LaTeX Warning")
ID_RE = re.compile(r"^(.+?-(?:THM|LEM|DEF)-\d+)(?:-|$)")
DOC_ID_RE = re.compile(r"`([A-Z][A-Z0-9-]*-(?:THM|LEM|DEF)-\d+)`")
MANIFEST_ROW_RE = re.compile(r"^\| `([^`]+)` \| `([^`]+)` \|", re.MULTILINE)
PROOF_SCHEMATIC_RE = re.compile(
    r"##\s+(?:[A-Z]\.\s+)?Proof schematic\s+```mermaid\s*\n(.*?)```", re.DOTALL
)


@dataclass(frozen=True)
class Dossier:
    index: int
    source: Path
    relative: Path
    domain: str
    module: Path
    statement_id: str
    work_dir: Path
    pdf: Path
    log: Path


@dataclass(frozen=True)
class ModuleSchematic:
    pdf: Path
    source_defined: bool


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest",
        type=Path,
        default=DEFAULT_MANIFEST,
        help="ordered dossier manifest (default: proofs/compendium-manifest.txt)",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("/tmp/projectkoios-formal-proof-compendium.pdf"),
        help="final PDF path (default: /tmp/projectkoios-formal-proof-compendium.pdf)",
    )
    parser.add_argument(
        "--jobs",
        type=int,
        default=min(8, os.cpu_count() or 1),
        help="parallel dossier compilations (default: min(8, CPU count))",
    )
    parser.add_argument(
        "--strict-warnings",
        action="store_true",
        help="fail if any dossier or the assembled compendium emits a LaTeX warning",
    )
    parser.add_argument(
        "--keep-work",
        action="store_true",
        help="retain and print the temporary build workspace",
    )
    return parser.parse_args()


def discover_dossiers() -> set[Path]:
    return {
        path.relative_to(REPO_ROOT)
        for path in PROOFS_ROOT.rglob("*.tex")
        if "fragments" not in path.parts and path.name not in EXCLUDED_NAMES
    }


def read_manifest(path: Path) -> list[Path]:
    manifest = path if path.is_absolute() else REPO_ROOT / path
    if not manifest.is_file():
        raise ValueError(f"manifest does not exist: {manifest}")

    entries: list[Path] = []
    for line_number, raw in enumerate(manifest.read_text().splitlines(), start=1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        relative = Path(line)
        if relative.is_absolute():
            raise ValueError(f"manifest line {line_number} must be repository-relative: {line}")
        entries.append(relative)

    if len(entries) != len(set(entries)):
        raise ValueError("manifest contains duplicate dossier paths")

    missing = [entry for entry in entries if not (REPO_ROOT / entry).is_file()]
    if missing:
        raise ValueError("manifest paths do not exist:\n" + "\n".join(map(str, missing)))

    discovered = discover_dossiers()
    listed = set(entries)
    omitted = sorted(discovered - listed)
    stale = sorted(listed - discovered)
    if omitted or stale:
        details: list[str] = []
        if omitted:
            details.append("dossiers omitted from manifest:\n" + "\n".join(map(str, omitted)))
        if stale:
            details.append("manifest entries excluded from dossier discovery:\n" + "\n".join(map(str, stale)))
        raise ValueError("\n".join(details))

    return entries


def statement_id(path: Path) -> str:
    match = ID_RE.match(path.stem)
    return match.group(1) if match else path.stem


def declaration_manifest() -> dict[str, str]:
    return dict(MANIFEST_ROW_RE.findall(THEOREM_MANIFEST.read_text()))


def declaration_pattern(short_name: str) -> re.Pattern[str]:
    declaration_kinds = r"(?:def|lemma|theorem|structure|class|abbrev|instance)"
    qualified_name = rf"(?:[^\n\s:()\[\]]+\.)?{re.escape(short_name)}"
    return re.compile(rf"\b{declaration_kinds}\s+{qualified_name}(?![\w'])")


def resolve_owning_modules(entries: list[Path]) -> dict[str, Path]:
    lean_sources = {
        path.relative_to(REPO_ROOT): path.read_text(errors="replace")
        for path in LEAN_ROOT.rglob("*.lean")
    }
    documented_modules: dict[str, set[Path]] = {}
    for module, text in lean_sources.items():
        for identifier in DOC_ID_RE.findall(text):
            documented_modules.setdefault(identifier, set()).add(module)

    declarations = declaration_manifest()
    resolved: dict[str, Path] = {}
    for relative in entries:
        identifier = statement_id(relative)
        declaration = declarations.get(identifier)
        if declaration is None:
            raise ValueError(
                f"statement ID is absent from the theorem manifest: {identifier}"
            )
        pattern = declaration_pattern(declaration.rsplit(".", 1)[-1])
        candidates = {
            module for module, text in lean_sources.items() if pattern.search(text)
        }
        if len(candidates) != 1:
            candidates &= documented_modules.get(identifier, set())
        if len(candidates) != 1:
            rendered = ", ".join(map(str, sorted(candidates))) or "none"
            raise ValueError(
                f"could not resolve one owning Lean module for {identifier}; candidates: {rendered}"
            )
        resolved[identifier] = next(iter(candidates))
    return resolved


def make_dossiers(entries: list[Path], workspace: Path) -> list[Dossier]:
    owning_modules = resolve_owning_modules(entries)
    dossiers: list[Dossier] = []
    seen_modules: set[Path] = set()
    current_module: Path | None = None
    for index, relative in enumerate(entries, start=1):
        identifier = statement_id(relative)
        module = owning_modules[identifier]
        if module != current_module:
            if module in seen_modules:
                raise ValueError(
                    f"manifest entries for owning module are not contiguous: {module}"
                )
            seen_modules.add(module)
            current_module = module
        work_dir = workspace / "dossiers" / f"{index:04d}-{relative.stem}"
        dossiers.append(
            Dossier(
                index=index,
                source=REPO_ROOT / relative,
                relative=relative,
                domain=relative.parts[1],
                module=module,
                statement_id=identifier,
                work_dir=work_dir,
                pdf=work_dir / f"{relative.stem}.pdf",
                log=work_dir / "latexmk.log",
            )
        )
    return dossiers


def compile_dossier(dossier: Dossier) -> tuple[Dossier, str | None, list[str]]:
    dossier.work_dir.mkdir(parents=True, exist_ok=True)
    command = [
        "latexmk",
        "-pdf",
        "-interaction=nonstopmode",
        "-halt-on-error",
        f"-outdir={dossier.work_dir}",
        str(dossier.relative),
    ]
    environment = os.environ.copy()
    # Biber is a Perl PAR executable on macOS. A per-dossier extraction directory avoids races when
    # the two bibliography-bearing dossiers compile concurrently.
    par_cache = dossier.work_dir / "par-cache"
    par_cache.mkdir(parents=True, exist_ok=True)
    environment["PAR_GLOBAL_TMPDIR"] = str(par_cache)
    completed = subprocess.run(
        command,
        cwd=REPO_ROOT,
        env=environment,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    dossier.log.write_text(completed.stdout)
    tex_log = dossier.pdf.with_suffix(".log")
    warning_text = tex_log.read_text(errors="replace") if tex_log.is_file() else completed.stdout
    warnings = [line for line in warning_text.splitlines() if WARNING_RE.search(line)]
    if completed.returncode != 0 or not dossier.pdf.is_file():
        return dossier, f"latexmk failed with exit code {completed.returncode}", warnings
    return dossier, None, warnings


def tex_escape(text: str) -> str:
    replacements = {
        "\\": r"\textbackslash{}",
        "&": r"\&",
        "%": r"\%",
        "$": r"\$",
        "#": r"\#",
        "_": r"\_",
        "{": r"\{",
        "}": r"\}",
        "~": r"\textasciitilde{}",
        "^": r"\textasciicircum{}",
    }
    return "".join(replacements.get(character, character) for character in text)


def domain_title(domain: str) -> str:
    return {
        "BandGauge": "Band gauge",
        "Crosswalks": "Crosswalks",
        "DensityFunctionalTheory": "Density-functional theory",
        "QuantumMechanics": "Quantum mechanics",
        "SolidState": "Solid state",
    }.get(domain, domain)


def module_title(module: Path, domain: str) -> str:
    parts = module.with_suffix("").parts
    domain_index = parts.index(domain)
    local_parts = parts[domain_index + 1 :]
    return ".".join(local_parts) if local_parts else domain


def module_groups(dossiers: list[Dossier]) -> list[tuple[Path, list[Dossier]]]:
    groups: list[tuple[Path, list[Dossier]]] = []
    for dossier in dossiers:
        if not groups or groups[-1][0] != dossier.module:
            groups.append((dossier.module, [dossier]))
        else:
            groups[-1][1].append(dossier)
    return groups


def generated_inventory_schematic(module: Path, dossiers: list[Dossier]) -> str:
    module_name = ".".join(module.with_suffix("").parts)
    lines = [
        "flowchart LR",
        f'    module["{module_name}"]',
        '    inventory["Selected declaration dossiers<br/>(presentation inventory, not proof dependency)"]',
        "    module --> inventory",
    ]
    for index, dossier in enumerate(dossiers, start=1):
        node = f"statement{index:03d}"
        lines.append(f'    {node}["{dossier.statement_id}"]')
        lines.append(f"    inventory --> {node}")
    return "\n".join(lines)


def chrome_executable() -> Path | None:
    configured = os.environ.get("PUPPETEER_EXECUTABLE_PATH")
    candidates = [
        Path(configured) if configured else None,
        Path("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"),
        Path("/Applications/Chromium.app/Contents/MacOS/Chromium"),
    ]
    for candidate in candidates:
        if candidate is not None and candidate.is_file():
            return candidate
    for command in ("google-chrome", "chromium", "chromium-browser"):
        resolved = shutil.which(command)
        if resolved:
            return Path(resolved)
    return None


def render_module_schematics(
    dossiers: list[Dossier], workspace: Path
) -> tuple[dict[Path, ModuleSchematic], int]:
    if shutil.which("mmdc") is None:
        raise RuntimeError("Mermaid CLI `mmdc` is required to render module proof schematics")

    schematic_dir = workspace / "module-schematics"
    schematic_dir.mkdir(parents=True, exist_ok=True)
    markdown = schematic_dir / "module-schematics.md"
    rendered_markdown = schematic_dir / "rendered.md"
    groups = module_groups(dossiers)
    blocks: list[str] = []
    source_defined: list[bool] = []
    for module, module_dossiers in groups:
        source_text = (REPO_ROOT / module).read_text(errors="replace")
        match = PROOF_SCHEMATIC_RE.search(source_text)
        if match:
            schematic = match.group(1).strip()
            source_defined.append(True)
        else:
            schematic = generated_inventory_schematic(module, module_dossiers)
            source_defined.append(False)
        blocks.append(f"```mermaid\n{schematic}\n```")
    markdown.write_text("\n\n".join(blocks) + "\n")

    command = [
        "mmdc",
        "-i",
        str(markdown),
        "-o",
        str(rendered_markdown),
        "-e",
        "pdf",
        "-b",
        "transparent",
    ]
    browser = chrome_executable()
    if browser is not None:
        puppeteer_config = schematic_dir / "puppeteer.json"
        puppeteer_config.write_text(
            json.dumps({"executablePath": str(browser)}) + "\n"
        )
        command[1:1] = ["-p", str(puppeteer_config)]

    completed = subprocess.run(
        command,
        cwd=schematic_dir,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    (schematic_dir / "mmdc.log").write_text(completed.stdout)
    if completed.returncode != 0:
        raise RuntimeError(
            f"Mermaid schematic rendering failed with exit code {completed.returncode}; "
            f"log: {schematic_dir / 'mmdc.log'}"
        )

    result: dict[Path, ModuleSchematic] = {}
    output_stem = rendered_markdown.stem
    for index, ((module, _), is_source_defined) in enumerate(
        zip(groups, source_defined, strict=True), start=1
    ):
        pdf = schematic_dir / f"{output_stem}-{index}.pdf"
        if not pdf.is_file():
            raise RuntimeError(f"Mermaid did not produce expected module schematic: {pdf}")
        result[module] = ModuleSchematic(pdf=pdf, source_defined=is_source_defined)
    return result, sum(source_defined)


def write_master(
    dossiers: list[Dossier], schematics: dict[Path, ModuleSchematic], workspace: Path
) -> Path:
    master = workspace / "whole-repository-compendium.tex"
    lines = [
        r"\documentclass[11pt]{article}",
        r"\usepackage[T1]{fontenc}",
        r"\usepackage[margin=0.75in]{geometry}",
        r"\usepackage[hidelinks]{hyperref}",
        r"\usepackage{graphicx}",
        r"\usepackage{pdfpages}",
        r"\makeatletter",
        r"\renewcommand{\@pnumwidth}{3.2em}",
        r"\renewcommand*\l@section{\@dottedtocline{1}{1.5em}{4.5em}}",
        r"\renewcommand*\l@subsection{\@dottedtocline{2}{3.8em}{5.2em}}",
        r"\makeatother",
        r"\title{Project Koios Formal Proof Compendium\\\large Whole-repository declaration dossiers}",
        r"\author{Eugene Joseph M. Ragasa}",
        r"\date{Generated from the repository dossier manifest}",
        r"\begin{document}",
        r"\maketitle",
        rf"\noindent This compendium assembles {len(dossiers)} independently compiled proof dossiers. ",
        r"Each included dossier remains the declaration-level audit record; this PDF is an ordered presentation of those records.",
        r"\tableofcontents",
        r"\clearpage",
    ]

    current_domain: str | None = None
    current_module: Path | None = None
    for dossier in dossiers:
        if dossier.domain != current_domain:
            current_domain = dossier.domain
            current_module = None
            lines.append(rf"\part{{{tex_escape(domain_title(current_domain))}}}")

        if dossier.module != current_module:
            current_module = dossier.module
            module_heading = tex_escape(module_title(current_module, current_domain))
            module_path = tex_escape(current_module.as_posix())
            schematic = schematics[current_module]
            schematic_pdf = schematic.pdf.relative_to(workspace).as_posix()
            schematic_origin = (
                "Proof schematic extracted from the Lean module docstring."
                if schematic.source_defined
                else "Generated dossier-inventory fallback; source proof schematic is pending."
            )
            lines.extend(
                [
                    r"\clearpage",
                    r"\phantomsection",
                    rf"\addcontentsline{{toc}}{{section}}{{{module_heading}}}",
                    rf"\section*{{Module: {module_heading}}}",
                    rf"\noindent\texttt{{{module_path}}}",
                    r"\begin{center}",
                    rf"\includegraphics[width=\textwidth,height=0.72\textheight,keepaspectratio]{{{schematic_pdf}}}",
                    r"\end{center}",
                    rf"\noindent\emph{{{tex_escape(schematic_origin)}}}",
                    r"\clearpage",
                ]
            )

        statement_heading = tex_escape(dossier.statement_id)
        relative_pdf = dossier.pdf.relative_to(workspace).as_posix()
        lines.extend(
            [
                r"\includepdf[",
                r"  pages=-,",
                r"  pagecommand={},",
                rf"  addtotoc={{1,subsection,2,{{{statement_heading}}},{{dossier-{dossier.index:04d}}}}}",
                rf"]{{{relative_pdf}}}",
            ]
        )

    lines.append(r"\end{document}")
    master.write_text("\n".join(lines) + "\n")
    return master


def compile_master(master: Path, workspace: Path) -> tuple[Path, Path, list[str]]:
    out_dir = workspace / "compendium"
    out_dir.mkdir(parents=True, exist_ok=True)
    log = out_dir / "latexmk.log"
    command = [
        "latexmk",
        "-pdf",
        "-interaction=nonstopmode",
        "-halt-on-error",
        f"-outdir={out_dir}",
        master.name,
    ]
    completed = subprocess.run(
        command,
        cwd=workspace,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    log.write_text(completed.stdout)
    pdf = out_dir / f"{master.stem}.pdf"
    tex_log = out_dir / f"{master.stem}.log"
    warning_text = tex_log.read_text(errors="replace") if tex_log.is_file() else completed.stdout
    warnings = [line for line in warning_text.splitlines() if WARNING_RE.search(line)]
    if completed.returncode != 0 or not pdf.is_file():
        raise RuntimeError(
            f"compendium latexmk failed with exit code {completed.returncode}; log: {log}"
        )
    return pdf, log, warnings


def main() -> int:
    args = parse_args()
    if args.jobs < 1:
        print("--jobs must be positive", file=sys.stderr)
        return 2

    try:
        entries = read_manifest(args.manifest)
    except ValueError as error:
        print(error, file=sys.stderr)
        return 2

    workspace = Path(tempfile.mkdtemp(prefix="projectkoios-proof-compendium-"))
    keep_workspace = args.keep_work
    try:
        try:
            dossiers = make_dossiers(entries, workspace)
        except ValueError as error:
            print(error, file=sys.stderr)
            return 2
        print(f"Compiling {len(dossiers)} dossiers with {args.jobs} workers...")
        failures: list[tuple[Dossier, str]] = []
        warning_count = 0
        warning_sources: list[tuple[Path, int]] = []
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as executor:
            futures = [executor.submit(compile_dossier, dossier) for dossier in dossiers]
            completed_count = 0
            for future in concurrent.futures.as_completed(futures):
                dossier, error, warnings = future.result()
                completed_count += 1
                warning_count += len(warnings)
                if warnings:
                    warning_sources.append((dossier.relative, len(warnings)))
                if error:
                    failures.append((dossier, error))
                if completed_count % 25 == 0 or completed_count == len(dossiers):
                    print(f"  compiled {completed_count}/{len(dossiers)}")

        if failures:
            print("Dossier compilation failures:", file=sys.stderr)
            for dossier, error in failures:
                print(f"  {dossier.relative}: {error}; log: {dossier.log}", file=sys.stderr)
            keep_workspace = True
            return 1

        print("Rendering module-level Mermaid proof schematics...")
        try:
            schematics, source_schematic_count = render_module_schematics(dossiers, workspace)
        except RuntimeError as error:
            print(error, file=sys.stderr)
            keep_workspace = True
            return 1
        print(
            f"  source-defined: {source_schematic_count}; "
            f"generated inventory fallbacks: {len(schematics) - source_schematic_count}"
        )

        master = write_master(dossiers, schematics, workspace)
        print("Assembling whole-repository compendium...")
        try:
            compiled_pdf, _master_log, master_warnings = compile_master(master, workspace)
        except RuntimeError as error:
            print(error, file=sys.stderr)
            keep_workspace = True
            return 1

        warning_count += len(master_warnings)
        if master_warnings:
            warning_sources.append((Path("<assembled compendium>"), len(master_warnings)))
        if args.strict_warnings and warning_count:
            print(
                f"strict warning check failed: {warning_count} matching LaTeX warning lines; "
                f"workspace: {workspace}",
                file=sys.stderr,
            )
            keep_workspace = True
            return 1

        output = args.output if args.output.is_absolute() else Path.cwd() / args.output
        output.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(compiled_pdf, output)
        print(f"Compendium written to {output}")
        print(f"Dossiers: {len(dossiers)}; matching warning lines: {warning_count}")
        if warning_count:
            print(f"Warning sources: {len(warning_sources)}")
            print("Re-run with --keep-work to inspect per-dossier and compendium logs.")
        return 0
    finally:
        if keep_workspace:
            print(f"Build workspace retained at {workspace}", file=sys.stderr)
        else:
            shutil.rmtree(workspace, ignore_errors=True)


if __name__ == "__main__":
    raise SystemExit(main())

# Whole-repository proof compendium builder

## Source

`src/python/projectkoios/formal/documents/proofs/compendium.py`

## Inputs

- `proofs/compendium-manifest.txt`: repository-relative standalone dossier paths grouped by owning
  Lean module.
- `docs/theorem-manifest.md` and repository-owned Lean declarations: declaration-to-module identity;
  stable-ID docstrings disambiguate if a short declaration name occurs in multiple modules.
- The LaTeX dossier sources listed by the compendium manifest.
- A local TeX installation providing `latexmk`, `pdflatex`, `pdfpages`, `graphicx`, and, for
  bibliography-bearing dossiers, `biber`.
- Mermaid CLI (`mmdc`) and a compatible Chromium or Chrome executable for module-schematic
  rendering.

The builder independently discovers eligible dossier sources and requires exact agreement with the
manifest. It excludes templates, shared preambles, domain compendia, and reusable body fragments.
Each statement ID must resolve to exactly one owning Lean module, and all entries for that module
must form one contiguous manifest group.

## Build

From the repository root:

```bash
python3 src/python/projectkoios/formal/documents/proofs/compendium.py \
  --output /tmp/projectkoios-formal-proof-compendium.pdf
```

The default output is `/tmp/projectkoios-formal-proof-compendium.pdf`. `--jobs` controls parallel
standalone compilation. `--strict-warnings` turns matching LaTeX warnings into a build failure.
`--keep-work` retains the temporary workspace for diagnosis.

## Isolation and assembly

Each dossier receives its own output directory. A separate `PAR_GLOBAL_TMPDIR` is also assigned so
parallel `biber` processes do not race while extracting their packaged executable on macOS.

For every dossier-owning Lean module, the builder extracts the Mermaid block under `## Proof
schematic` in the module docstring. When the source block is absent during migration, it generates an
explicitly labeled dossier-inventory fallback that does not claim proof dependency. All module
schematics are rendered in one Mermaid CLI invocation.

After all standalone PDFs compile, the builder generates a temporary `pdfpages` master organized by
repository domain, owning Lean module, and statement ID. Domain entries are parts, module divider
pages are sections, and declaration dossiers are subsections. Each module divider includes the
rendered schematic and states whether it came from the Lean source or from the migration fallback.
Only the requested final PDF is copied out; generated Mermaid, LaTeX, auxiliary, standalone PDF, and
log files are not stored in the repository.

## Authority boundary

The assembled PDF is an index and presentation of existing dossiers. It does not replace the
individual dossier paths, Lean kernel checking, the theorem manifest, source provenance records, or
the scientific manuscript in `projectkoios-dft`.

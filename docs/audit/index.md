# Audit documentation

This directory owns repository audit records and derived audit views. These documents record trust,
dependency, provenance, and compiled-declaration evidence; they do not establish scientific
validation, publication authority, or runtime numerical correctness.

## Current audit records

| Document | Purpose | Authority boundary |
|---|---|---|
| [`dependency-audit.md`](dependency-audit.md) | immutable dependency identities, adoption decisions, API roles, and revalidation boundaries | dependency selection and compatibility, not theorem status or physical applicability |
| [`trusted-base-audit.md`](trusted-base-audit.md) | trusted-base policy, validation gates, and current evidence identified by stable `AUD-VAL-*` records | compilation and axiom evidence, not scientific or publication acceptance |
| [`validation-history.md`](validation-history.md) | superseded and tranche-specific build and audit evidence identified by stable `AUD-HIST-*` records | historical evidence for its recorded tree only, not current-tree validation |
| [`source-audit.md`](source-audit.md) | inventory and status vocabulary for stable `AUD-SRC-*` provenance records | routing and record identity, not transfer of source or scientific authority |
| [`source-literature.md`](source-literature.md) | literature and primary-source inspections | inspected statements and identity limits only |
| [`source-publications.md`](source-publications.md) | publication and manuscript inspections | inspected publication bytes and locators, not publication authority |
| [`source-owner-repositories.md`](source-owner-repositories.md) | owner-repository and computational-contract inspections | inspected source bytes and contract scope, not runtime or scientific validation |
| [`source-library-provenance.md`](source-library-provenance.md) | external proof provenance and internal source-neutral derivations | proof-source attribution and internal provenance only |

## Query routing

| Question | Read first | Then consult |
|---|---|---|
| What is pinned, adopted, or deliberately not adopted? | [`dependency-audit.md`](dependency-audit.md) | `lake-manifest.json` and the linked `AUD-VAL-*` evidence |
| Which checks passed for which source tree? | [`trusted-base-audit.md`](trusted-base-audit.md) | [`validation-history.md`](validation-history.md) only for older tranches |
| Which exact external bytes or publication locators were inspected? | [`source-audit.md`](source-audit.md) | the detailed `AUD-SRC-*` record linked from its inventory |
| What is the formal status and presentation kind of a declaration? | [`../theorem-manifest.md`](../theorem-manifest.md) | `ProjectKoios/Audit.lean` for named axiom reports |
| What directly depends on a declaration? | [`declaration-dependency-graph.md`](declaration-dependency-graph.md) | the compiled environment and declaration manifest |
| What may be claimed in a publication? | [`../publication-crosswalk.md`](../publication-crosswalk.md) | [`../authority-boundaries.md`](../authority-boundaries.md) and the relevant source record |

Current records supersede historical records only for the scope they explicitly cover. Historical
validation must not be read as current-tree evidence, and source records must not be read as theorem
or publication status.

## Derived audit views

| Document | Purpose | Authority boundary |
|---|---|---|
| [`declaration-dependency-graph.md`](declaration-dependency-graph.md) | procedure and interpretation for generating a read-only dependency graph from an already validated compiled audit environment | derived graph view only; the Lean environment and declaration manifest remain authoritative |

## Related authoritative records

- [`../theorem-manifest.md`](../theorem-manifest.md): declaration identity, presentation kind, and
  theorem status.
- [`../authority-boundaries.md`](../authority-boundaries.md): separation of formal, computational,
  scientific, and publication authority.
- [`../formal-vs-numerical-evidence.md`](../formal-vs-numerical-evidence.md): formal and numerical
  evidence boundary.
- [`../publication-crosswalk.md`](../publication-crosswalk.md): publication-facing statement
  correspondence.
- [`../reference-crosswalk-policy.md`](../reference-crosswalk-policy.md): reference identity and
  evidence policy.

## Maintenance rules

- Keep current dependency identity and adoption decisions in `dependency-audit.md`.
- Keep current validation commands, tree scope, build-reuse statements, and audit coverage in
  `trusted-base-audit.md`; keep superseded or tranche-specific evidence in `validation-history.md`.
- Keep source-record routing and status in `source-audit.md`; keep repository, revision, path, hash,
  access mode, dirty-state limits, and authority boundaries in the linked detailed record.
- Do not recycle stable `AUD-DEP-*`, `AUD-VAL-*`, `AUD-HIST-*`, or `AUD-SRC-*` identifiers.
- Do not duplicate detailed build histories across audit files; link to the owning record.
- Distinguish targeted validation from repository-wide builds and identify reused evidence
  explicitly.
- Generated dependency graphs, PDFs, logs, and build state remain ignored and untracked.

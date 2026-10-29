# Documentation

These files record policy, provenance, status, and plans. They do not establish theorem or evidence status by themselves.

## Authoritative ledgers

Five ledgers control status and provenance.

- `theorem-manifest.md`: declarations and proof status.
- `source-audit.md`: inspected source identities and byte hashes.
- `publication-crosswalk.md`: source claims and formalization mapping.
- `trusted-base-audit.md`: audit requirements and recorded checks.
- `dependency-audit.md`: Lean, Mathlib, and Physlib evaluation.

## Policy

Policy files define evidence and workflow boundaries.

- `authority-boundaries.md`: proof, certificate, numerical, and runtime authority.
- `formal-vs-numerical-evidence.md`: permitted bridges and prohibited status transfers.
- `certificates.md`: certificate classes and lifecycle.
- `BandGauge/publication-evidence-contract.md`: publication-package acceptance requirements.
- `reference-crosswalk-policy.md`: literature identity and relation policy.
- `conventions.md`: required theorem-family conventions.
- `agent-workflow.md`: bounded development and promotion procedure.

## Architecture and planning

Planning files organize work without changing formal status.

- `effort-portfolio.md`: active, ready, blocked, deferred, and completed work.
- `module-layout.md`: semantic ownership and import direction.
- `definition-and-lemma-inventory.md`: implemented and candidate mathematics.
- `roadmap.md`: dependency-ordered future work.
- `ecosystem-architecture.md`: repository boundaries.
- `ksdft2effmass-calculations-formal-support-inventory.md`: calculation-to-formal-support assessment.
- `witness-catalog.md`: candidate exact examples.
- `BandGauge/Geometry/witness-separation-statement-selection.md`: `BG-PLAN-001` decision record.
- `BandGauge/higher-rank-composite-band-formalization-plan.md`: higher-rank D1 plan.
- `BandGauge/Papers/`: series and per-paper plans.
- `papers/`: Formal-owned, publication-quality proof companions and their publication boundaries.
- `SolidState/TightBinding/vogl-sp3s-star-formalization.md`: Vogl exact-algebra scope.

## Related indexes

These indexes point to explanatory material.

- `../proofs/README.md`: proof-dossier policy.
- `papers/README.md`: Formal-owned proof-companion policy and index.
- `../papers/README.md`: legacy synthesis-manuscript policy.
- Module README files: local scope and exclusions.

## Status terms

Status terms have fixed meanings.

- **metadata:** traceability only.
- **planned:** no declaration exists.
- **implemented:** a declaration exists.
- **proved:** Lean accepts the declaration without admissions and the audit record exists.
- **blocked:** a required source, convention, dependency, or authority decision is unresolved.

Only `theorem-manifest.md` assigns formal status.

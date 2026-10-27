# Project Koios Formal instructions

This repository owns reusable Lean formalizations, proofs, audit metadata, dependency pins, and
publication crosswalks. It does not own source publications, runtime calculations, numerical
evidence, or scientific-validation claims.

## Identity

Use these names consistently.

- Repository: `projectkoios-formal`
- Lake package: `ProjectKoiosFormal`
- Harness namespace: `ProjectKoios.Formal`
- Initial scientific namespace: `ProjectKoios.BandGauge`

## Start

Establish toolchain and source identity before formalization.

1. Inventory local Lean and Lake versions.
2. Inspect cited owner repositories read-only; record repository, branch, commit, path, and dirty-state limits.
3. Pin external dependencies to immutable commits, never floating branches or tags.
4. Build the smallest compiling harness before adding mathematics.
5. Report axioms, admissions, assumptions, theorem status, and source ambiguities truthfully.

## References

Read only the repository documents relevant to the task.

- Declaration status: `docs/theorem-manifest.md`
- Authority and evidence: `docs/authority-boundaries.md`, `docs/formal-vs-numerical-evidence.md`, `docs/certificates.md`
- Provenance: `docs/source-audit.md`, `docs/publication-crosswalk.md`, `docs/reference-crosswalk-policy.md`
- Trust and dependencies: `docs/dependency-audit.md`, `docs/trusted-base-audit.md`
- Organization: `docs/module-layout.md`, `docs/conventions.md`, `docs/definition-and-lemma-inventory.md`
- Proof dossiers and agent procedure: `proofs/README.md`, `docs/agent-workflow.md`

Use current official Lean and Mathlib guidance, but verify every declaration against the pinned
revision. Consult current Physlib rules only for an actual proposed Physlib contribution.

## Boundaries

Keep formal, computational, scientific, and publication authority separate.

- Copying a publication statement into Lean does not prove it.
- Numerical output is not exact evidence without an explicit checked certificate boundary.
- Do not strengthen, generalize, rename, or combine source claims without evidence and review.
- Never hide `sorry`, axioms, admitted assumptions, placeholders, or unresolved obligations.
- Trace publication crosswalks to exact source locations and revisions.
- Do not copy private source bytes or generated publication artifacts.
- Do not mutate, clean, stage, or commit inspected owner repositories.
- Do not add workflow engines, daemons, registries, telemetry, credentials, runtime state, generated build output, compatibility facades, or broad catch-all modules.
- Keep package initializers and namespace roots narrow.

## Dependencies

Dependency identity must be immutable and tested.

- Pin Mathlib to an immutable commit.
- Evaluate Physlib at an immutable revision against the selected Lean/Mathlib toolchain before adoption.
- Record compatibility evidence and limitations; metadata alone is insufficient.

## Validation

Validate each distinct candidate tree once.

- During development, compile only the smallest affected module or audit target.
- Before promotion, run one cached or incremental `lake build`, pin inspection, axiom/admission audit, and generated-state check.
- Identify build evidence by source tree, `lean-toolchain`, and `lake-manifest.json`.
- Reuse populated `.lake` state and prefer one persistent clean integration worktree.
- Create another worktree only for required concurrent isolation.
- Run `lake update` only for an intentional dependency change.
- Never delete `.lake` or rematerialize dependencies merely to call a build clean.
- Do not rebuild after staging, committing, or merging a byte-identical tree.
- Rebuild only after a tree, toolchain, or manifest change, a failed/interrupted build, or loss of trusted evidence.

## Protected actions

Local read-only exploration and authorized edits are allowed.

- Commits, checkpoints, remotes, pushes, publication, releases, deployments, theorem-completion claims, and scientific-validation claims require separate explicit authorization.

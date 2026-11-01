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

## Declaration presentation

Declaration kinds and stable IDs must reflect how the mathematics is presented, not merely the fact
that Lean represents both `lemma` and `theorem` as proved constants.

- Use `*-DEF-*` for definitions, abbreviations, structures, and named constructions.
- Use `*-LEM-*` and the Lean `lemma` keyword for supporting identities, rewrite rules, and
  intermediate results.
- Use `*-THM-*` and the Lean `theorem` keyword for principal mathematical results.
- Do not promote a supporting lemma to `THM` merely because it is public, proved, audited, or has a
  proof dossier.
- Record the exact presentation kind in the declaration manifest, and audit every proved lemma and
  theorem. Publication-facing lemmas may have dossiers under their `LEM` IDs.
- Apply this classification prospectively. Preserve established IDs and attached propositions unless
  a separately reviewed migration explicitly authorizes relabeling.

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

Use affected-target validation by default; a repository-wide build is an escalation gate, not a
routine per-tree requirement.

- During development and ordinary promotion, compile every changed Lean module, its bounded affected consumers, and the smallest relevant audit target. Run pin inspection, axiom/admission coverage, manifest/crosswalk review, and generated-state checks appropriate to the changed surface.
- Documentation-only changes do not require Lean compilation unless they change a theorem-status, axiom, dependency, or reproducibility claim that must be replayed.
- Require a repository-wide `lake build` only when dependency or toolchain identity changes; Lake/package configuration or namespace roots change; a broadly shared foundation makes the affected target set unreliable; targeted validation fails or leaves import coverage ambiguous; a release or publication snapshot is being frozen; or the operator/reviewer explicitly requests it.
- Record targeted and repository-wide evidence separately. Identify each by source tree, `lean-toolchain`, and `lake-manifest.json`; never imply that targeted compilation was a full build.
- Except when freezing a release or publication snapshot, reuse prior repository-wide build evidence when toolchain and dependency identity are unchanged, and validate descendant source changes through their affected modules and audit targets. A frozen release or publication snapshot requires a repository-wide build of that exact tree.
- Reuse populated `.lake` state and prefer one persistent clean integration worktree.
- Create another worktree only for required concurrent isolation.
- Run `lake update` only for an intentional dependency change.
- Never delete `.lake` or rematerialize dependencies merely to call a build clean.
- Do not repeat a validation command after staging, committing, or merging a byte-identical tree.

## Protected actions

Local read-only exploration and authorized edits are allowed.

- Commits, checkpoints, remotes, pushes, publication, releases, deployments, theorem-completion claims, and scientific-validation claims require separate explicit authorization.

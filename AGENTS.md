# Project Koios Formal instructions

This repository owns the reusable Lean formalization harness for Project Koios. It may encode formally stated mathematics, machine-checked proofs, theorem inventories, dependency pins, audit tooling, and publication-to-formalization crosswalks. It does not own scientific publication claims, numerical evidence, calculator/runtime authority, or the source documents maintained by consuming repositories.

## Repository identity

- Repository: `projectkoios-formal`
- Lake package: `ProjectKoiosFormal`
- Harness namespace: `ProjectKoios.Formal`
- Initial scientific namespace: `ProjectKoios.BandGauge`

## Start

1. Inventory the local Lean and Lake toolchain before choosing versions.
2. Inspect cited owner-repository sources read-only and record their exact repository, branch, commit, path, and dirty-state limitations.
3. Pin every external dependency to an immutable revision. Do not use floating branches or tags as the durable pin.
4. Build the smallest compiling harness before adding mathematical content.
5. Report axioms, `sorry`, theorem status, assumptions, and unresolved source ambiguities truthfully.

## Boundaries

- Keep formal proof, exact certificate verification, numerical evidence, and calculator/runtime authority distinct.
- A publication statement is not a proved theorem merely because it is copied into Lean.
- A numerical result is not exact formal evidence unless an explicit checked certificate boundary establishes that fact.
- Do not strengthen, generalize, rename, or combine source claims without owner-relevant evidence and explicit review.
- Use placeholders that cannot be mistaken for completed theorems. Never hide `sorry`, axioms, or admitted assumptions.
- Keep publication crosswalks traceable to exact source locations and revisions.
- Do not copy private source bytes or generated publication artifacts into this repository.
- Do not mutate, clean, stage, or commit in inspected owner repositories.
- Do not add workflow engines, daemons, registries, telemetry, credentials, runtime state, generated build output, compatibility facades, or broad catch-all modules.
- Package initializers and namespace roots must remain narrow; avoid re-export surfaces until separately justified.

## Dependencies

Use Mathlib through an immutable Lake pin. Evaluate Physlib against an immutable revision and the selected Lean/Mathlib toolchain before adopting it. Record compatibility evidence and residual limitations; do not claim compatibility from metadata alone.

## Validation

At minimum, require a clean Lake build, dependency-pin inspection, an axiom/`sorry` audit, and checks that generated build state is ignored. The theorem manifest and publication crosswalk must distinguish placeholders, statements, proved declarations, axioms, and external numerical obligations.

## Protected actions

Local exploration and the authorized startup skeleton are allowed. Commits/checkpoints, remote creation, push, publication, release, deployment, theorem-completion claims, and scientific-validation claims require separate explicit authorization.

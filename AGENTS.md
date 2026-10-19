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

## Required references

Read the repository-local documents relevant to the task before changing declarations or
publication-facing status:

- [theorem manifest](docs/theorem-manifest.md) — authoritative declaration IDs and statuses;
- [authority boundaries](docs/authority-boundaries.md) and
  [formal-versus-numerical evidence](docs/formal-vs-numerical-evidence.md) — separation of proof,
  certificates, runtime output, and scientific claims;
- [source audit](docs/source-audit.md), [publication crosswalk](docs/publication-crosswalk.md), and
  [reference policy](docs/reference-crosswalk-policy.md) — source provenance and literature ownership;
- [dependency audit](docs/dependency-audit.md) and
  [trusted-base audit](docs/trusted-base-audit.md) — immutable pins and trusted assumptions;
- [module layout](docs/module-layout.md), [conventions](docs/conventions.md), and
  [definition and lemma inventory](docs/definition-and-lemma-inventory.md) — repository organization
  and current mathematical scope;
- [certificate boundary](docs/certificates.md) — requirements for any numerical-to-formal bridge; and
- [proof dossier instructions](proofs/README.md) — publication-facing proof documentation.

For Lean and Mathlib syntax, style, naming, and documentation, use the current official guidance:

- [Lean reference manual](https://lean-lang.org/doc/reference/latest/);
- [Lean project style guide](https://github.com/leanprover/lean4/blob/master/doc/style.md);
- [Mathlib contribution overview and AI policy](https://leanprover-community.github.io/contribute/index.html);
- [Mathlib library style](https://leanprover-community.github.io/contribute/style.html);
- [Mathlib naming conventions](https://leanprover-community.github.io/contribute/naming.html);
- [Mathlib documentation style](https://leanprover-community.github.io/contribute/doc.html);
- [Mathlib pull-request review guidance](https://leanprover-community.github.io/contribute/pr-review.html);
- [Mathlib generated API documentation](https://leanprover-community.github.io/mathlib4_docs/);
- [Mathlib theorem-search guide](https://leanprover-community.github.io/blog/posts/searching-for-theorems-in-mathlib/),
  including `exact?`, `apply?`, `rw?`, Loogle, LeanSearch, and Moogle;
- [Aesop documentation and source](https://github.com/leanprover-community/aesop); and
- [Moogle semantic search](https://www.moogle.ai/).

Treat Aesop and search engines as discovery tools, not proof or compatibility authority. Replace
successful `aesop?`, `simp?`, or search suggestions with inspectable proof steps when that improves
maintenance, and verify every suggested declaration against the repository's pinned Mathlib revision.

PhysLean has merged into **Physlib**. For any proposed Physlib or PhyslibAlpha contribution, inspect
its current rules rather than relying on the former project name or remembered conventions:

- [Physlib repository and contribution overview](https://github.com/leanprover-community/physlib);
- [Physlib getting started](https://physlib.io/GettingStarted.html) and
  [getting involved](https://physlib.io/get-involved);
- [Physlib review guidelines](https://github.com/leanprover-community/physlib/blob/master/docs/ReviewGuidelines.md);
- [Physlib required linters and development scripts](https://github.com/leanprover-community/physlib/blob/master/scripts/README.md);
- [PhyslibAlpha required checks](https://github.com/leanprover-community/physlib/blob/master/scripts/lint/required/alpha/README.md); and
- [Physlib generated API documentation](https://physlib.io/docs/).

These external documents govern an actual upstream contribution only. Local declarations remain
Project Koios Formal work until separately reviewed and explicitly authorized for upstreaming.

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

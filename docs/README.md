# Documentation map

This directory records the formalization contract, provenance, planning state, and audit evidence for Project Koios Formal. Documentation does not itself establish a Lean theorem, certificate result, numerical result, or scientific conclusion.

## Current evidence

- [`theorem-manifest.md`](theorem-manifest.md) — declarations that exist in Lean, their proof status, and a clearly separate planning inventory.
- [`publication-crosswalk.md`](publication-crosswalk.md) — publication statements, source status, assumptions, and current Lean status.
- [`source-audit.md`](source-audit.md) — immutable owner-source identity and cited-byte hashes.
- [`dependency-audit.md`](dependency-audit.md) — selected Lean/Mathlib pins and the bounded Physlib evaluation.
- [`trusted-base-audit.md`](trusted-base-audit.md) — trusted-base policy and required admission/axiom checks.

## Formalization contract

- [`authority-boundaries.md`](authority-boundaries.md) — exact proof, checked certificate, numerical evidence, and runtime authority.
- [`conventions.md`](conventions.md) — conventions that every future statement must make explicit.
- [`formal-vs-numerical-evidence.md`](formal-vs-numerical-evidence.md) — permitted bridges and prohibited status transfers.
- [`certificates.md`](certificates.md) — certificate vocabulary and present availability.
- [`reference-crosswalk-policy.md`](reference-crosswalk-policy.md) — theorem-to-literature traceability without duplicating References-owned bibliography authority.

## Architecture and workflow

- [`ecosystem-architecture.md`](ecosystem-architecture.md) — horizontal hub-and-spoke relationship, shallow dependencies, and cross-repository bridges.
- [`agent-workflow.md`](agent-workflow.md) — bounded Pi/Lean development loop and criteria for evaluating optional agent tooling.
- [`agent-tooling-candidates.md`](agent-tooling-candidates.md) — operator-recorded repositories to consider later; currently unevaluated and not adopted.

## Planning

- [`module-layout.md`](module-layout.md) — intended ownership of documentation-only source folders.
- [`definition-and-lemma-inventory.md`](definition-and-lemma-inventory.md) — concepts and library searches required before theorem encoding.
- [`witness-catalog.md`](witness-catalog.md) — bounded candidate examples and their source limitations.
- [`roadmap.md`](roadmap.md) — gated order of future formalization work.

## Status vocabulary

- **metadata** — traceability information only; no proposition is encoded.
- **planned** — a candidate theorem family or definition has been identified, but its Lean statement is not approved.
- **statement** — an exact Lean proposition exists without a completed proof; any admission must be visible and audited.
- **proved** — the stated Lean declaration has a checked proof and an recorded axiom report.
- **blocked** — work cannot proceed without resolving a source, convention, dependency, or authority question.

Only the theorem manifest may report a repository declaration as proved. Planning documents must not use “proved” to describe a publication argument or an intended Lean result.

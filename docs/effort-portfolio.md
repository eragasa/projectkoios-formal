<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-27
-->

# Effort portfolio

## Purpose and authority

This document organizes current and prospective work without changing the authority of any
proof, source, certificate, numerical result, publication, or protected action. It is the
current execution map for Project Koios Formal, not a replacement for the detailed ledgers and
plans.

Authoritative status remains separated as follows:

- [`theorem-manifest.md`](theorem-manifest.md) owns Lean declaration and proof status;
- [`trusted-base-audit.md`](trusted-base-audit.md) owns audit requirements;
- [`source-audit.md`](source-audit.md) owns inspected source identity and limitations;
- [`publication-crosswalk.md`](publication-crosswalk.md) owns publication-to-formalization mapping;
- [`formal-vs-numerical-evidence.md`](formal-vs-numerical-evidence.md) owns evidence boundaries;
- [`module-layout.md`](module-layout.md) owns semantic source placement; and
- [`roadmap.md`](roadmap.md) records mathematical dependency stages.

The portfolio snapshot below was reviewed against remote `main` merge commit
`265fb7cb1a0b448cf3d069d4c1de9e5af1a912f8` on 2026-10-27. A later repository state does
not inherit this snapshot automatically.

## Mission

Maintain an audit-first Lean verification sidecar that proves exact propositions and checks
explicit exact certificates without acquiring authority over computational execution, numerical
evidence, scientific applicability, novelty, or publication status.

## Portfolio hierarchy

### 1. Trust, provenance, and promotion

Owns toolchain and dependency pins, admission and axiom audits, manifest consistency, source
identity, proof-dossier policy, release nonclaims, and promotion gates.

It does not establish source fidelity or scientific validity merely from a successful build.

### 2. Reusable exact mathematics

Owns theorem families whose statements are independent of a particular runtime artifact or
publication:

- BandGauge foundations, Bloch sewing, Fourier algebra, Hilbert losses, geometry, finite
  decisions, and generic certificate soundness;
- QuantumMechanics finite-dimensional, finite-difference, state, measurement, Dirac,
  rigged-space, and test-domain algebra;
- SolidState folding, route, tight-binding, gauge-loop, and projector--Bargmann algebra; and
- narrow immutable-source crosswalks where exact constants require an external owner.

A paper or calculation may consume these results but does not become their semantic owner.

### 3. Controlled-model applications

Owns bounded applications of reusable mathematics, including QHO1D, PIAB1D, Mathieu1D,
rank-one defects, finite periodic reductions, and the abstract Vogl `sp³s⋆` model.

A controlled model remains separate from runtime validation and material applicability.

### 4. Exact certificate bridges

Owns frozen exact schemas, exact data, fail-closed checkers, checker soundness theorems,
immutable source bindings, and retained hashes. A bridge must keep the producer, independent
verifier, Lean checker, and scientific interpretation distinct.

Floating-point JSON, runtime arrays, eigensolver output, and external-calculator execution do not
become exact Lean inputs without a separately reviewed certificate boundary.

### 5. Publication crosswalks

Owns thin source-faithful instantiations and claim mapping for the Ragasa paper sequence and
monograph. Reusable proofs remain in semantic modules. Publication crosswalks do not transfer
formal status to numerical evidence or publication status.

### 6. External numerical and scientific evidence

This portfolio is owned outside Formal. It includes KSD calculation packages, independent
numerical verification, Quantum ESPRESSO and Wannier90 execution, retained evidence, model
applicability, novelty, and publication acceptance.

Formal records only explicit source crosswalks, exact certificate bridges, and named external
obligations.

### 7. Repository operations

Owns bounded topic branches, worktree isolation, checkpoint review, integration, pull-request
review, post-merge validation, and separately authorized cleanup. A dirty multi-topic worktree is
a partition source, not a promotion unit.

## Status axes

No effort receives one aggregate completion percentage. Report each axis independently:

| Axis | States |
|---|---|
| Formal statement | absent / candidate / frozen |
| Lean implementation | absent / implemented / proved |
| Trusted-base audit | absent / incomplete / passed |
| Source provenance | absent / dirty-byte fingerprint / immutable |
| Exact certificate | absent / schema candidate / checker proved / artifact checked |
| Numerical evidence | absent / development / independently verified / retained |
| Integration | isolated / checkpointed / merged to main |
| Publication | unmapped / planning / source-crosswalked / externally governed |

A status on one axis never transfers to another. In particular, `proved`, `artifact checked`,
`retained`, `merged to main`, and `published` are different claims.

## Work-in-progress rule

Keep at most:

- one active mathematical or certificate effort; and
- one active trust, documentation, or maintenance effort.

All other work belongs in `Ready`, `Blocked`, `Deferred`, or `Completed on main`. Adding a new
active effort requires moving or closing an existing one.

## Current execution board

### Active

#### Exact-certificate readiness audit

Rank these candidates without implementing a bridge prematurely:

1. rank-one defect analytical oracle;
2. single-band finite Fourier reduction; and
3. rank-two separation certificates.

For each candidate require an immutable schema, exact integer or rational inputs, separate
producer and verifier, retained hashes, and a precise mapping to an existing Lean proposition.
If none qualifies, record blockers rather than manufacturing a weaker boundary.

#### Portfolio maintenance

Keep this execution board synchronized only when an effort changes category. Do not copy theorem
inventories, source hashes, or detailed paper plans into this file.

### Ready for bounded review

1. **Rank-two box certificates:** `work/rank-two-kappa-mu-enclosure` contains a checkpointed
   old-base candidate. It requires rebase, source review, the current audit-coverage gate, and a
   fresh promotion review before integration.
2. **Finite first-passing cutoffs:** extract `FiniteCutoff.lean` and its direct manifest, audit,
   documentation, and dossier changes from the dirty primary checkout into one clean topic.
3. **Rank-two spectral perturbation:** extract `RankTwoSpectralPerturbation.lean` separately;
   do not combine it with cutoff semantics or diagnostic-interface design.
4. **Paper A diagnostic specification:** review the mathematical and Python-interface documents
   as owner-side schema recommendations, not runtime implementation or accepted evidence.

### Blocked

- projection/nonlocality promotion pending provenance, theorem-dossier, spectral-characterization,
  and completion-status corrections;
- a Paper A retained runtime certificate and active experiment package;
- Paper B retained production evidence and a checked exhaustive objective table;
- Paper C retained independent evidence and fail-closed calculator contract;
- exact impurity-defect-2d Stage C replay;
- rigorous QHO finite-box, discretization, and spectral bounds; and
- authorized Vogl source reacquisition and rights review.

### Deferred

- continuum topology and Chern integrality;
- Wilson eigenphase extraction and phase unwrapping;
- general Wannier obstruction and Wannier90 execution;
- broad generic theorem expansion without a selected consumer;
- Physlib adoption;
- declaration-graph tooling and unrelated AGENTS-policy changes; and
- branch or worktree deletion until separately authorized.

### Completed on main

The merged calculation-support tranche includes:

- the Paper A diagnostic-producer audit;
- QHO and PIAB1D exact finite mathematics;
- the PhysKit FCC--Bain crosswalk;
- reduction-basis, spin, finite-folding, and route algebra;
- tetrahedral Vogl `sp³s⋆` exact algebra;
- finite measurement and test-domain foundations;
- arbitrary-rank fixed-unitary Fourier equivariance;
- conditional rank-one resolvent-defect algebra;
- finite gauge loops and the projector--Bargmann crosswalk; and
- complete named axiom-report coverage for manifest declarations marked proved.

This completion status means merged and audited exact Formal content only. It is not a release,
scientific-evidence promotion, material-validation claim, or publication-completion claim.

## Publication-program summary

| Program | Formal position | Principal missing gate |
|---|---|---|
| Paper A | conditional source-specific results and one exact internal analytic construction | immutable runtime instance, accepted weights, independent checking, retained artifact |
| Paper B | metadata placeholder | projection/tail results, frozen exhaustive decision table, checked Pareto mask |
| Paper C | metadata placeholder | fail-closed owner calculator and retained rank/depth/dimension evidence |
| Paper D | planning only; no source key or Lean namespace | owner-approved immutable protocol and first-principles target |
| Monograph projection | dirty isolated work | source, statement, dossier, and status corrections |

Detailed scientific and readiness requirements remain in
[`BandGauge/Papers/ragasa-series-research-plan.md`](BandGauge/Papers/ragasa-series-research-plan.md)
and the per-paper plans.

## Change discipline

When updating this portfolio:

1. preserve the independent status axes;
2. link to an authoritative detailed document instead of duplicating it;
3. keep historical roadmaps and source audits intact;
4. do not move or rename Lean declarations merely to match the portfolio hierarchy;
5. do not treat a local worktree as a checkpoint;
6. keep protected actions separately authorized; and
7. record unresolved ambiguity rather than assigning optimistic status.

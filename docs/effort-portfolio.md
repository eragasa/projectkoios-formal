<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-27
-->

# Effort portfolio

This file is the execution board. Detailed status remains in the linked ledgers.

- Proof status: `theorem-manifest.md`
- Trust: `trusted-base-audit.md`
- Source identity: `source-audit.md`
- Publication mapping: `publication-crosswalk.md`
- Evidence boundary: `formal-vs-numerical-evidence.md`
- Module ownership: `module-layout.md`
- Dependency order: `roadmap.md`

Historical portfolio snapshot: remote `main` merge commit `95a6724ca2472d674fc90d879dd64c7d1c3d4e83`, reviewed 2026-10-27.

Supplemental snapshot after the rank-two box-certificate merge: `1f9e3c56b4e85c1efa75916719a50fc57c8f978a`.

Current board baseline: remote `main` merge commit `d72865262927453197eee89d0be62bf388c0ed07`.

## Mission

Maintain an audit-first Lean sidecar for exact propositions and exact certificate checking. Formal does not own runtime execution, numerical evidence, scientific applicability, novelty, or publication status.

## Portfolios

Seven portfolios separate ownership and evidence types.

1. **Trust and provenance:** pins, audits, source identity, dossiers, and promotion gates.
2. **Reusable mathematics:** BandGauge, QuantumMechanics, SolidState, and narrow exact crosswalks.
3. **Controlled models:** QHO1D, PIAB1D, Mathieu1D, defects, finite periodic reductions, and abstract Vogl algebra.
4. **Certificate bridges:** exact schemas, checkers, source bindings, and retained hashes.
5. **Publication crosswalks:** thin source-faithful mappings and instantiations.
6. **External evidence:** KSD calculations, independent verification, QE/Wannier90, applicability, and publication review; owned outside Formal.
7. **Repository operations:** topic isolation, checkpoint review, integration, and authorized cleanup.

## Status axes

Report axes independently.

| Axis | States |
|---|---|
| Statement | absent / candidate / frozen |
| Lean | absent / implemented / proved |
| Audit | absent / incomplete / passed |
| Provenance | absent / dirty-byte fingerprint / immutable |
| Certificate | absent / schema candidate / checker proved / artifact checked |
| Numerical evidence | absent / development / independently verified / retained |
| Integration | isolated / checkpointed / merged |
| Publication | unmapped / planning / source-crosswalked / externally governed |

No status transfers between axes.

## Work-in-progress limit

Keep at most:

- one mathematical or certificate effort; and
- one trust, documentation, or maintenance effort.

Everything else is ready, blocked, deferred, or completed.

## Active

Two efforts occupy the current WIP limit.

### Finite root-mean-square Fourier-tail normalization

This is the active mathematical effort.

- Derive the exact squared finite root-mean-square norm of the deliberate-truncation
  channel from the existing finite Parseval and residual-tail equalities.
- Add the corresponding matrix Frobenius root-mean-square specialization rather than
  silently using the ambient matrix norm.
- State the required finite nonempty-domain hypotheses explicitly and preserve the
  existing Fourier normalization.
- Do not bind the result to KSD binary64 values, runtime meshes, eigensolvers, thresholds,
  first-passage outcomes, or scientific adequacy.

### KSD boundary and portfolio maintenance

This is the active maintenance effort.

- Track the Periodic1D rank-one design as an external pre-execution source, not a Formal
  certificate or immutable source binding.
- Keep the seven-paper planning boundary synchronized at the level of effort categories;
  detailed numerical controls and source hashes remain with the owner and source ledgers.
- Update the source-specific crosswalk only after KSD supplies an immutable reviewed
  revision.

The current KSD rank-one owner is observed on branch
`work/periodic1d-rank1-control-v3` at base
`bc1601f3a50dda19b994eea474ca522f2d836c26` with uncommitted documentation. Its
Option B parent and finite controls are owner-local design inputs. The uncommitted owner
material now records prospective three-channel maximum and root-mean-square controls, but
no typed family implementation, execution, result, retained package, or Formal
request/result wire exists.

## Ready

Ready work has a bounded next action.

1. Update the Formal proof companion from the merged gauge--truncation declaration.
2. Resume the Paper A diagnostic owner-side schema recommendation only when it does not
   displace the active mathematical effort.

## Blocked

Blocked work lacks a required source or evidence gate.

- KSD Periodic1D rank-one exact request/result wire pending an immutable owner revision,
  typed configuration and result wires, a producer-independent verifier, retained hashes,
  and joint schema review. The current owner-local design freeze is not an immutable
  Formal source binding.
- KSD Periodic1D rank-two and rank-N certificate bindings pending stable successor wires,
  independently verified results, and retained finite objective inventories.
- Projection/nonlocality promotion pending provenance, dossier, spectral-characterization, and status fixes.
- Paper A retained runtime certificate and active package.
- Paper B retained production evidence and exhaustive checked table.
- Paper C retained independent evidence and fail-closed calculator contract.
- Exact impurity-defect-2d Stage C replay.
- Rigorous QHO finite-box, discretization, and spectral bounds.
- Authorized Vogl source reacquisition and rights review.

## Deferred

Deferred work is outside the current WIP limit.

- Continuum topology and Chern integrality.
- Wilson eigenphases and phase unwrapping.
- General Wannier obstruction and Wannier90 execution.
- Broad theorem expansion without a selected consumer.
- Physlib adoption.
- Branch and worktree deletion without explicit authorization.

## Completed on main

These items are merged Formal content only.

- Paper A diagnostic-producer audit.
- QHO and PIAB1D finite mathematics.
- PhysKit FCC--Bain bridge.
- Reduction, spin, folding, and route algebra.
- Tetrahedral Vogl algebra.
- Finite measurement and test-domain foundations.
- Fixed-unitary Fourier equivariance.
- Pointwise-gauge and Fourier boundaries.
- Exact rank-two gauge--truncation noncommutation witness.
- Finite orthonormal-frame algebra.
- Sewn aligned-operator differences.
- Admissible alignment-family semantics.
- Rank-one resolvent algebra.
- Gauge loops and projector--Bargmann crosswalk.
- Rank-two box checker, conditional Paper A bridge, and exact regression.
- Finite first-passing cutoff semantics.
- Three-way interval threshold, joint-feasibility, and first-passing certificates.
- Rank-two canonical spectral perturbation and unnormalized Frobenius band-error bound.
- Finite three-channel residual identity with pointwise, maximum, and root-mean-square
  triangle bounds and exact deliberate-truncation Fourier-tail bridges.
- Complete named axiom coverage for manifest rows marked proved.

Completion means merged Formal content only. It does not mean release, evidence promotion, material validation, or publication completion.

## Publication programs

Each program retains independent formal and evidence status.

| Program | Formal position | External position and missing gate |
|---|---|---|
| Paper A | conditional results and one exact analytic construction | KSD has analytic and development calculations but no retained active-calculation package; an immutable runtime instance and independently checked package remain missing |
| Paper B | metadata placeholder | KSD has bounded replaceable dimensional and strain development ladders; retained production evidence and a checked exhaustive table remain missing |
| Paper C | metadata placeholder | KSD has a D1 protocol candidate and development code; a stable result wire, independent full-result verification, and retained rank/depth evidence remain missing |
| Paper D | planning only | KSD owns a bulk-silicon plan and provisional C48/K8 setting, but has no accepted production parent or qualified Wannier bridge |
| Paper E | absent | KSD has pre-results common-space defect methodology but no immutable experiment or retained defect operator |
| Paper F | finite gauge-loop and projector--Bargmann algebra only | KSD has pre-results obstruction methodology but no selected model family, invariant protocol, or retained classification; current Formal results do not establish topology |
| Paper G | absent | KSD has a pre-results matched-SOC application plan but no authorized matched pristine/Si:P/Si:B branches or retained material result |
| Monograph projection | dirty isolated work | provenance, statement, dossier, and status corrections |

## Change rules

Board changes must not rewrite detailed ledgers.

- Preserve independent axes.
- Link detailed ledgers instead of copying them.
- Preserve historical source records.
- Do not move Lean declarations to match this portfolio.
- Do not treat a worktree as a checkpoint.
- Keep protected actions separately authorized.
- Record ambiguity instead of optimistic status.

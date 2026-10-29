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

Current board baseline: remote `main` merge commit
`ad5fd4472d3bbdabe63a976dcf148f8a3eaee2d5`, tree
`7bb5e3c2f4d7fa452b51e4e567738dd7f208d297`, integrating PR #26.

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

One mathematical effort occupies the WIP limit: pointwise self-adjointness closure for ordinary
and aligned reference-minus-candidate continuous-linear-map fields under explicit complete-space
and pointwise self-adjointness hypotheses. It does not choose an alignment, authenticate runtime
operators, or establish spectral or numerical adequacy. No certificate, runtime-evidence, trust,
documentation, or maintenance effort is active.

## Ready

Ready work has a bounded next action.

1. Obtain independent review of the proof companion's provenance-audited background
   bibliography before publication extraction.
2. Resume proposition-specific schema design only after KSD supplies a frozen exact or
   outward-rounded request/result contract.
3. Treat commits, pushes, PRs, merges, and cleanup as separate authorization gates.

## Blocked

Blocked work lacks a required source or evidence gate.

- KSD Periodic1D rank-one exact request/result wire pending an immutable reviewed owner
  revision, retained hashes, a proposition-specific exact or outward-rounded schema, and
  joint schema review. The passing uncommitted finite software slice and provisional
  report are not an immutable Formal source binding or a checked certificate.
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
- Generic finite spectral--operator compatibility with central infimum semantics, stronger
  common-alignment witness semantics, explicit conformant embeddings, metric separation,
  and first-compatible-class selection; its finite-separation extension proves compact
  nonempty-set distance attainment and specializes finite central admissible sets to
  attained distance under nonemptiness, zero distance exactly for compatibility, and
  positive distance exactly for incompatibility. The extension merged through PR #24 at
  commit `db403cd95893766c010cb85a43bf21ca59524f1f`, tree
  `47ffab7ffe3c26abb23301c7179aed1088c997cf`.
- Three-way interval threshold, joint-feasibility, and first-passing certificates.
- Rank-two canonical spectral perturbation and unnormalized Frobenius band-error bound.
- Finite three-channel residual identity with pointwise, maximum, and root-mean-square
  triangle bounds and exact deliberate-truncation Fourier-tail bridges.
- Exact Hilbert and explicit matrix-Frobenius root-mean-square Fourier-tail identities.
- Pointwise and finite-maximum ambient-norm omitted-tail bounds.
- Exact positive-even centered integer inventories, a distinguished negative-Nyquist mode,
  singleton-removal support, full-versus-removed reconstruction with the deleted term explicit,
  normalized removed-block Frobenius power, and symmetric ordinary support below half the mesh
  size. This abstract slice merged through PR #26 at commit
  `ad5fd4472d3bbdabe63a976dcf148f8a3eaee2d5`, tree
  `7bb5e3c2f4d7fa452b51e4e567738dd7f208d297`; it supplies no NumPy FFT/`fftshift`
  binding, binary64 identity, retained execution, runtime certificate, or scientific-validation
  claim.
- The Formal-owned spectral--operator compatibility proof companion, initially merged at
  `ca00a56b2462d00a67dd830742c2c27eef4c34cd` and refreshed at
  `b998c09550161193e8edbe3aeaa9d93d183693fa` with the finite compatibility schema; its
  directly supporting aligned-difference dossiers `BG-BLOCH-THM-012--020` and
  alignment-family dossiers `BG-ALIGNMENT-THM-011--029` now carry expanded proof records.
- A bounded external-background bibliography with DOI-level provenance, explicit
  citation-use boundaries, and a citation audit distinct from novelty assessment and
  owner-source authority.
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

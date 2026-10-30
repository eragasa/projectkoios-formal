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
`24263f08a5b69fc34be3073bc724a3b0ad4b80d6`, tree
`2cbef2a05174f5ad491392b40dd4265a751ed932`, integrating PR #44.

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

One mathematical effort occupies the WIP limit: the isolated
`work/one-circle-bessel-integral` topic, based on remote `main` merge commit
`7188b05149c598d2edc7ec8eb2af331c54b313ad`, ports the minimum source-neutral full-angle `J₀`
integral proof with Apache-2.0 attribution to immutable `LeanCondensedMatter` merge commit
`47d64b9d2e85522dbbef295bf0ce3d2a1d0afe87`. It adds the normalized period-one circle sine bridge,
arbitrary finite product powers, exact 2-D `J₀(a)²`, and exact 3-D `J₀(2a/3)³` scaling corollaries.
It includes immutable source identity, declaration and axiom ledgers, module/source documentation,
smallest-target checks, and selected explanatory dossiers. It does not bind an external coordinate
or phase convention, authenticate quadrature or a runtime mesh, establish finite-to-continuum
convergence, or certify a KSD comparator or scientific conclusion. No separate trust,
documentation, or maintenance effort occupies the second WIP slot.

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
- KSD Periodic1D rank-two and rank-N certificate bindings pending a frozen proposition-specific
  exact or outward-rounded request/result contract, separate review, separate implementation
  authorization, independently verified results, and retained finite objective inventories. The
  two-notification coordination requirement is complete for the native Phase 5 first slice at KSD
  revision `806ecb0418fd9ec4da76d7caf826e4d9356322f5`, tree
  `37a173ed220b81394706e0af3c76f279ca6f1b3c`, but that binary64 transport/status API is not a
  Formal certificate input; no parser or runtime binding is authorized, and the checked
  runtime-certificate count remains zero.
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
- Sewn aligned-operator differences, including pointwise self-adjointness closure for ordinary
  subtraction, unitary pullback, and reference-minus-pulled-back-candidate fields under complete
  fiber-space and explicit pointwise self-adjointness hypotheses. The closure merged through PR #28
  at commit `71d078d36b361fced70595d95bc987a73f7e93f1`, tree
  `8d2ea1a81b222b34ba77accb60dddda17ac83d91`; it does not select an alignment, authenticate
  runtime operators, or establish spectral or numerical adequacy.
- Exact unitary-pullback action/operator-norm preservation, aligned-difference action and
  operator-norm bounds, same-alignment subtraction identities, and pointwise/operator-norm
  Lipschitz stability are proved as `BG-BLOCH-THM-024--032`. Five selected explanatory dossiers
  cover `BG-BLOCH-THM-024`, `027`, `029`, `031`, and `032`. The slice merged through PR #34 at
  commit `77d2f88eb48cf91de7350af66483c51fb7d15f55`, tree
  `75e082cb85f30625963f2f8b6244ccc5f66fab62`; it requires supplied exact pointwise unitary
  alignments, uses one common alignment for pair stability, and does not authenticate runtime
  operators, compare different gauges without a bridge, establish spectral or scientific adequacy,
  or create a certificate.
- Precise mandatory operator channels and finite alignment-family attainment are proved as
  `BG-DECISION-DEF-032--040` and `BG-DECISION-THM-051--060`. The slice merged through PR #37
  at commit `0062d687c1306c1df85d9c674fdf0239d05a8624`, tree
  `cd60a1bb5cd005547338398621be3c596c865aa4`; exact upper-bounded error values remain distinct
  from nonnumeric structural requirements, finite minimization does not imply mandatory-channel
  passage, and the result authenticates no runtime inventory, optimizer, external value, or
  certificate.
- The source-neutral four-stage residual ledger and narrow precise-channel adapter are proved as
  `BG-HILBERT-DEF-019--020`, `BG-HILBERT-THM-022--025`, `BG-DECISION-DEF-041--044`, and
  `BG-DECISION-THM-061--064`, with three selected explanatory dossiers. The slice merged through
  PR #38 at commit `01c9b0a0cd3776d2edfc82e514e11408d6a96f34`, tree
  `fddc9e3225b0edf9e80e9301e3b7426d1df6e788`; component fields add exactly, scalar summaries
  satisfy inequalities only, the structural inventory is empty, and no runtime stage, complete
  study ledger, certificate, or scientific adequacy is established.
- Four-stage budget synthesis and exact component-level compatibility witnesses are proved as
  `BG-DECISION-DEF-045--050` and `BG-DECISION-THM-065--072`, with two selected explanatory
  dossiers. The slice merged through PR #39 at commit
  `5ce81b3f5373b57177179abb93700a097f9e1ba3`, tree
  `137ecc251a934f95f79feb2518ebe1f9c6b6f929`; total-channel redundancy requires explicit
  component-budget headroom, every theorem retains one common model/candidate/alignment witness,
  and no runtime headroom, structural coverage, external completeness, certificate, or scientific
  adequacy is inferred.
- Mandatory-channel composition and the extended four-stage witness expansion are proved as
  `BG-DECISION-DEF-051--053` and `BG-DECISION-THM-073--086`, with two selected explanatory
  dossiers. The slice merged through PR #40 at commit
  `00e9ee158fb153b5109fbb35f156ca087ea079fd`, tree
  `fe5e9cd5b440745e3644a1478c6f5639a5282b5b`; disjoint tags prevent identifier collision but
  prove no external inventory completeness, all composed obligations retain one common
  model/candidate/alignment witness, and no runtime value, optimizer, certificate, or scientific
  adequacy is authenticated.
- Exact complex-unitary right Procrustes algebra is proved as `BG-ALIGNMENT-DEF-017--020` and
  `BG-ALIGNMENT-THM-030--045`, with selected dossiers for global minimality and conditional
  uniqueness. The slice merged through PR #41 at commit
  `66523cbd5065d5fa3a3ad0f326e40b29c753f574`, tree
  `c3b79feef16671ddf55044af0754bf91728384b4`; the objective is ordinary right-unitary
  `‖candidate * gauge - reference‖_F²` with cross matrix `candidateᴴ * reference`, the polar witness
  is exact supplied data, uniqueness requires positive definiteness, and no runtime SVD, rank,
  tolerance, optimizer, null-space completion, certificate, or scientific adequacy is authenticated.
- Exact complex-unitary rank-two conjugation invariance is proved as
  `BG-FOUNDATION-DEF-014--016` and `BG-FOUNDATION-THM-015--025`, with selected dossiers for
  canonical-band equality and the pointwise finite-field corollary. The slice merged through PR #44
  at commit `24263f08a5b69fc34be3073bc724a3b0ad4b80d6`, tree
  `2cbef2a05174f5ad491392b40dd4265a751ed932`; exact supplied unitary and coordinate witnesses are
  required, and no runtime gauge, eigensolver, band tracker, momentum mesh, external artifact,
  certificate, or scientific adequacy is authenticated.
- Complete finite metric-shell mathematics is proved as `BG-FOURIER-DEF-045--051` and
  `BG-FOURIER-THM-089--118`, with selected dossiers for shell-change characterization and capped
  no-skipped-shell semantics. The slice merged through PR #43 at commit
  `2b3e6d7f7acfdf78d48b3b8177f7676e16bd1287`, tree
  `15bf4cebd53772f2c8b6e559c634f5e0d75c9f30`; completeness is relative to a supplied finite
  inventory, exact radius, cutoff cap, and explicit invariance hypotheses, and does not authenticate
  external inventories, physical hopping ranges, runtime counts, convergence, material adequacy,
  certificates, or scientific acceptance.
- The finite-mesh Procrustes hierarchy is proved as `BG-ALIGNMENT-DEF-021--029` and
  `BG-ALIGNMENT-THM-046--058`, with selected dossiers for summed global minimality and the exact
  known-inverse/unique-polar-field control. The slice merged through PR #42 at commit
  `4902864c19b412320e56c984fe9cc98a4ad3bd89`, tree
  `8e0e7bfdd20b245ff8160cd7fc6f302c8bfd661a`; one supplied exact polar witness per mesh point
  yields the summed minimum, uniqueness requires positive definiteness at every point, the
  matrix-unitary bridge supplies exact identity/global/complete family membership, and no mesh,
  runtime SVD/rank/tolerance behavior, optimizer, null-space completion, certificate, or
  scientific adequacy is authenticated.
- Normalized finite product-torus integration is proved as `BG-FOURIER-DEF-052--056` and
  `BG-FOURIER-THM-119--127`, with selected dossiers for exponential factorization and the
  equal-phase power law. The slice merged through PR #45 at commit
  `7188b05149c598d2edc7ec8eb2af331c54b313ad`, tree
  `de6d0fc700670a27fe7ccaf79eb8da3a4838e17e`; it fixes the carrier and product Haar probability
  measure and proves exact 2-D square and 3-D cube laws, but by itself binds no external coordinate,
  phase, quadrature, finite mesh, runtime comparator, convergence claim, certificate, or scientific
  conclusion.
- The finite aligned-operator budget and compatibility-adapter slice is proved as
  `BG-DECISION-DEF-028--031` and `BG-DECISION-THM-039--050`, with four selected explanatory
  dossiers. It merged through PR #36 at commit
  `af55852071a3d15cd21ccde31db095c5596da40c`, tree
  `5ce8ba5215b6f2880d36bf484afa9980b2ae0770`; it preserves the richer common alignment carrier
  while projecting its exact pointwise unitary field, uses one common alignment for stability and
  mandatory channels, and establishes no runtime binding, optimizer attainment, cross-gauge
  comparison, external inventory coverage, certificate, or scientific adequacy.
- Admissible alignment-family semantics.
- Rank-one resolvent algebra.
- Gauge loops and projector--Bargmann crosswalk.
- Selected publication-facing proof dossiers for aligned-difference self-adjointness
  (`BG-BLOCH-THM-021--023`), fixed-unitary Fourier algebra (`BG-FOURIER-THM-035`, `043`, `046`,
  and `047`), finite rank-one resolvent algebra (`QM-RESOLVENT-THM-005`, `008`, `010`, and `013`),
  and finite gauge/projector loops (`SS-GAUGE-THM-008`, `011`, `020`, and `023`). The 15-dossier
  tranche merged through PR #32 at commit `3b394c3aa56c6909d29cfa69fcbb53f7d494e2fd`, tree
  `89c1e237a76e93b30a57e5424a5f36b796f6f966`; it adds no theorem and confers no runtime,
  certificate, scientific-validation, topology, novelty, independent-review, or publication status.
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
  claim. Human-readable proof dossiers for `BG-FOURIER-THM-081`, `084`, `086`, and `087` merged
  through PR #30 at commit `c4ef5f33543225849fcd07606d5d4d4a3f258dc4`, tree
  `f38d62af57ea678fc47f3aa2df4e6f4de4d6d10d`; they explain the checked propositions but do not
  replace Lean or establish independent expert review, novelty, or publication readiness.
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

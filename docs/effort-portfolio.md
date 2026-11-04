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

Current board reconciliation source baseline: remote `main` merge commit
`80145602d4d84e26a4c5ccd7bbd362618598e39b`, tree
`a595559e72657e1f84975b19c2f123a4a35e3cf0`, integrating PR #63.

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

The current mathematical milestone adds exact approximate-compression structure for nonempty
finite retained spaces. It proves matrix-`L2Operator` bounds for two orthonormal-frame compressions,
the frozen right-unitary specialization, and differing ambient projector sandwiches; it also defines
an exact compressed-action reproduction residual, proves its algebraic zero criterion, and proves its invariant-range interpretation under exact orthonormality. The mixed operator/Frobenius estimate and
general-rank spectral-error transfer remain next. Certificate and numerical-evidence status remain
absent, and no runtime orthonormality, leakage, frame/projector binding, eigensolver output, or
scientific applicability is claimed.

## Ready

Ready work has a bounded next action.

1. Validate and independently review the active matrix-`L2Operator` approximate-compression slice,
   then extend it to the mixed Frobenius target and general-rank spectral bounds in dependency order.
2. Obtain independent review of the proof companion's provenance-audited background bibliography
   before publication extraction.
3. Resume proposition-specific schema design only after KSD supplies a frozen exact or
   outward-rounded request/result contract.
4. Treat commits, pushes, PRs, merges, and cleanup as separate authorization gates.

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
- Any external promotion of the exact projection/nonlocality counterexample to a quantitative or
  scientific locality claim pending an owner-specific source binding, quantitative decay/locality
  theorem, applicability review, and independent scientific review.
- Paper A retained runtime certificate and active package.
- Paper B retained production evidence and exhaustive checked table.
- Paper C retained independent evidence and fail-closed calculator contract.
- Exact impurity-defect-2d Stage C replay.
- Rigorous QHO finite-box, discretization, and spectral bounds.
- Authorized Vogl source reacquisition and rights review.

## Deferred

Deferred work is outside the current WIP limit.

- Exact KSD centered-FFT/product-quotient applicability binding after the polar and approximate-representation slices.
- Quantitative gauge-tail convolution and omitted-power bounds.
- Twist-gauge conjugacy and multidimensional seam consistency.
- Continuum topology and Chern integrality.
- Wilson eigenphases, branch-safe phase unwrapping, and Wilson--Chern equivalence.
- General Wannier obstruction, source-specific `_u.mat`/`_hr.dat` semantics, and Wannier90 execution.
- Defect-root monotonicity/count, higher-rank Woodbury/Feshbach bounds, and finite-to-infinite-volume limits.
- Effective-mass curvature, envelope approximation, and continuum convergence under a selected physical model.
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
- Cyclic quotient-radius support bounds, arbitrary-finite-rank and character-gauge locality
  separation, canonical finite-periodic coordinate characters with supplied-shell specializations,
  and the conditional fixed-subspace representation bridge.
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
- The full-angle `J₀` integral and normalized one-circle bridge are proved as
  `BG-SPECIAL-DEF-001--002`, `BG-SPECIAL-THM-001--014`, `BG-FOURIER-DEF-057--058`, and
  `BG-FOURIER-THM-128--133`, with selected dossiers for the full-angle and normalized-circle
  identities. The source-neutral Apache-2.0 port is attributed to immutable `LeanCondensedMatter`
  merge commit `47d64b9d2e85522dbbef295bf0ce3d2a1d0afe87`. The slice merged through PR #46 at
  commit `9f27941db0472683fd3971c462301ab6e0a3d046`, tree
  `cc5030f6227b0c2acfa7cfd48dd9a2d1fe038d5e`; it fixes standard Haar probability measure,
  positive phase, the coordinate `sin (2πx)`, and no extra `2π` in the real amplitude, then derives
  arbitrary finite product powers and exact 2-D/3-D corollaries. It does not bind an external
  coordinate or phase convention, authenticate quadrature or a runtime mesh, establish
  finite-to-continuum convergence, or certify a KSD comparator, external certificate, or scientific
  conclusion.
- The reusable projection and finite multidimensional gauge-locality slices are proved as
  `BG-PROJECTION-DEF-001--011`, `BG-PROJECTION-THM-001--008`,
  `BG-FOURIER-DEF-059--064`, and `BG-FOURIER-THM-134--159`. They merged through PR #50 at
  commit `7d475b0815d447b84337096e083f486aecd242fc`, tree
  `c0d6aad8c42debe1d02e72d8911456544013468c`; the projection result is one exact rank-two
  counterexample, while the finite product witnesses establish equal ordered bands alongside
  truncation noncommutation and positive omitted power. Neither slice authenticates runtime
  coefficients, physical hopping range, quantitative decay, model adequacy, or production evidence.
- The Fourier declaration domain is organized into the `FiniteAbelian`, `Gauge`, `Support`, `Torus`,
  and `Residual` ownership families, with a complete migration manifest and no compatibility
  facade. The controlled structural migration merged through PR #51 at commit
  `681b14f50a559f0ecf49d45c0a7d60adfc187eb5`, tree
  `b9a24d0a9e9cb73f8bd100529b79477e6006e0da`; historical stable IDs and propositions remain
  preserved.
- Gauge identity, represented-dimension, Euclidean-metric, right-action, and rank-one carrier laws
  are proved as `BG-ALIGNMENT-DEF-030--037` and `BG-ALIGNMENT-THM-059--067`. They merged
  through PR #52 at commit `f982fd299a96b280d331e2c7d3569d4aec995b3a`, tree
  `f1ec8567cbde025ac8cc2cba90ecb42125e28453`; the laws do not authenticate runtime frames,
  metric-aware objectives, optimizer recovery, or numerical alignment quality.
- Affected-target validation policy, exact-tree release-build requirements, and status-free quantum
  roadmap reconciliation merged through PRs #53 and #54 at commits
  `ad0cf798fd4aaac176ca427d0fa678e6a51ffaad` and
  `953b776945c413e848881ce4447e9bdee8fbd925`. These are policy and documentation results, not
  new mathematical, runtime, scientific, or publication evidence. The non-building dependency-graph
  tooling and Paper A documentation reconciliation likewise merged through PRs #48 and #49 without
  creating proof or evidence-status transfers.
- Exact finite matrix-product convolution, conjugate-transpose mode reversal, the pointwise-unitary
  triple-convolution law, and finite support inclusion in `(-S_U + S_A) + S_U` are implemented as
  `BG-FOURIER-FINITE-DEF-001--002`, `BG-FOURIER-FINITE-LEM-001`,
  `BG-FOURIER-FINITE-THM-001--002`, `BG-FOURIER-GAUGE-LEM-001--003`, and
  `BG-FOURIER-GAUGE-THM-001--002`. They merged through PR #55 at commit
  `500e84a52a90c89fda48132c07e9706ecd989453`, tree
  `f7bf17426c6e18213b0601b8dc9c191fca54c558`; support is an inclusion in a supplied finite
  character inventory and establishes no support equality, runtime binding, continuum decay,
  physical hopping range, or scientific adequacy.
- Source-neutral subadditive-radius growth for pointwise gauges, including the exact
  `R_A + 2 R_U` complete-shell inclusion under supplied inversion and triangle laws, merged through
  PR #57 at commit `6b8c7ec767cae6348ee818e4495edda0e1fcbfe2`, tree `df11021c2965f7eb87a7ab3af65494498376ebfe`. It does not bind
  finite quotient seams, runtime support, physical range, or decay.
- Exact FCC--Bain quotient-admission algebra, including the fail-closed mixed-modulus criterion
  `N₂=N₃ ∧ N₁∣N₂`, merged through PR #58 at commit `b98d23fe23bb5bc940c6be4cfcbc79c3569c45e7`, tree
  `c10259e93c6615a126b6066f609536e695823541`. It certifies quotient well-definedness only, not a
  runtime mesh or common-cell application.
- Exact finite-abelian and finite-periodic-lattice matrix-Frobenius least-squares identities merged
  through PR #59 at commit `fc8b085f6669f9af7046f92dc735b0c7fbf40ffa`, tree `923c0c409598d023262cb2f55228b7da60c055fe`.
  Exact onsite/nononsite direct power partitioning merged through PR #60 at commit `48c4b6c2cc9912ed418350633de1878991e22730`, tree
  `d558073dbfe1f4728fef26f0173d850823e88c2c`. Neither result validates NumPy solves, binary64
  summation, runtime classification, conditioning, or route agreement.
- Exact finite-rank analytic-parent gap and retained-ordering controls merged through PR #61 at
  commit `ea5e48253d86e973c54a187435d9e08f002b6d34`, tree `e44b8d78468c0ee7259c0b81ce3a0d57f355da31`; exact finite-rank
  right-unitary frame/operator construction, spectrum preservation, and known-inverse recovery
  merged through PR #62 at commit `0cc2bd7e707393853e34a427e964af355d7ab17a`, tree
  `f1c0fdf8f299990eebeb962c185de0c75bbc70a7`. These are source-neutral controls and do not
  authenticate runtime bonds, frames, gauges, eigensolvers, or sampled gaps.
- Exact additive Euclidean lattice radii for square, triangular, simple-cubic, and normalized FCC
  coordinates merged through PR #63 at commit `80145602d4d84e26a4c5ccd7bbd362618598e39b`, tree
  `a595559e72657e1f84975b19c2f123a4a35e3cf0`. Their squared norms equal the source-neutral shell
  indices and satisfy inversion and triangle laws, but they do not identify finite quotient
  characters with centered representatives or physical distances.
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
| Monograph projection | exact reusable rank-two projection/non-finite-support counterexample merged on `main` | owner-specific source binding, quantitative decay or locality consequences, retained production evidence, applicability review, and scientific validation remain missing |

## Change rules

Board changes must not rewrite detailed ledgers.

- Preserve independent axes.
- Link detailed ledgers instead of copying them.
- Preserve historical source records.
- Do not move Lean declarations to match this portfolio.
- Do not treat a worktree as a checkpoint.
- Keep protected actions separately authorized.
- Record ambiguity instead of optimistic status.

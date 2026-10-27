# Ragasa2026A paper and proof plan

This plan maps Paper A claims to reusable Lean results and explicit external obligations. It does not authorize publication or promote numerical evidence.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

## Source

One immutable manuscript supplies the source claims.

- Repository: `ksdft2effmass`
- Commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`
- Path: `docs/publications/papers/Ragasa2026a/v3/manuscript.tex`
- Constructed-proposition locator: `manuscript.tex:851–889`
- SHA-256: `2565cf464adb9da72061cad9a3e42d94834e22455bdce7fbba2cf6452572e340`
- Claim inventory: `docs/publications/papers/Ragasa2026a/v3/claim-and-commitment-inventory.md`
- Inspection limit: the final cited file was clean at the immutable commit; later worktree changes are excluded.

## Thesis

Agreement of band eigenvalues need not imply agreement of represented operators or hopping structure. A common finite-range model class can therefore pass a spectral tolerance and fail an operator tolerance.

The paper requires two distinct layers:

- exact rank-two separation geometry; and
- externally produced evidence that a concrete parent model satisfies the theorem hypotheses.

## Frozen mathematical setting

The source-facing statements retain the following hypotheses and conventions.

- Finite retained rank two with complex Hermitian matrix fields.
- Strictly positive normalized sample weights and a positive reference energy.
- One common global real rotation, with canonical angle in `[-π/2, π/2)`.
- Explicit spectral and aligned-operator losses, candidate domain, and positive thresholds.
- Exact centering, shared-power, correlation, containment, and separation premises.

The immutable source leaves general raw objective weights parametrized. A concrete publication instance therefore needs an a-priori or certified optimized quadrature rule; weights tuned against the reported losses are not admissible. The exact two-observation construction uses uniform counting weights.

## Formal status

Implemented:

- pointwise sewing and aligned sampled fields;
- weighted Frobenius power, correlation, and loss bridges;
- rank-two Pauli decomposition and second-harmonic optimization;
- ellipse and candidate-rectangle intersection/distance geometry;
- exact-center, interval, and joint box certificate checkers;
- exact two-observation analytic false-positive construction;
- exact checker acceptance, disjointness, distance, and degenerate-curvature regression.

Not implemented or not bound:

- periodic-potential construction of the parent fields;
- concrete four-state-parent runtime data;
- independent exact or interval certificate for a calculated instance;
- continuum Bloch-space theory; and
- material applicability.

See `docs/theorem-manifest.md` for declaration status.

## Source-to-Lean structure

Each source layer has one formal or external owner.

| Source layer | Formal owner | Status |
|---|---|---|
| centered rank-two fields and shared power | `BandGauge/Papers/Ragasa2026A/RankTwoFields.lean` | proved conditionally |
| optimized alignment correlation | `CorrelationHarmonic.lean` | proved |
| spectral and operator loss geometry | `Hilbert/`, `Geometry/`, `OptimizedLossGeometry.lean` | proved |
| exact scalar certificate | `Certificates/RankTwoSeparation*.lean` | checker and soundness proved |
| source-specific bridge | `CertificateBridge.lean`, `KappaEnclosureBridge.lean` | conditional bridge proved |
| analytic witness | `ConstructedFalsePositive.lean` | proved exactly |
| calculated parent instance | owner runtime and retained evidence | absent |

## Certificate path

A runtime-backed publication certificate must provide:

1. frozen schema and calculation identity;
2. exact rational or outward-rounded inputs;
3. strict parser with unknown-field rejection;
4. producer and independent verifier;
5. retained hashes and provenance;
6. proof that parsed fields satisfy the Lean hypotheses; and
7. exact checker acceptance.

Existing binary64 JSON must not be reinterpreted as exact input.

A runtime-backed scientific instance must also freeze the matrices or field summaries, reference energy, positive weights, bounds for `κ` and `μmax`, candidate rectangle, thresholds, spectral witness, and positive operator-separation bound. A robust interval or open parameter region is preferable to one finely tuned point.

## Remaining exact work

The highest-value unresolved theorem and bridge families are:

- persistence under structured field perturbations beyond the checked `(κ, μmax)` box;
- the source's smooth monotone threshold-continuum result;
- the operator-residual/nonlocal-hopping identity under frozen Fourier conventions;
- transported-frame covariance and attainment under explicit regularity premises; and
- binding an immutable runtime artifact to the existing checker.

The last item checks a certificate proposition; it does not establish physical validity.

## Proof order

Work proceeds from reusable mathematics to a narrow binding.

1. Keep reusable geometry and algebra source-neutral.
2. Keep source names and assumptions in thin Paper A modules.
3. Freeze an owner-controlled certificate schema only after KSD ownership stabilizes.
4. Verify one retained instance independently.
5. Add the narrow Lean bridge.
6. Update the publication crosswalk and dossiers.

## Publication evidence gates

A publication-facing result requires independent review of:

- source fidelity and assumption deltas;
- exact field and weight definitions;
- alignment-family completeness;
- certificate coverage and rounding;
- runtime provenance and retained hashes;
- scientific interpretation; and
- novelty/citation status.

## Nonclaims

The current formalization does not establish runtime correctness, a calculated four-state-parent result, continuum convergence, material validity, novelty, independent expert review, release, or publication readiness.

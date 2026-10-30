# BandGauge foundations

This directory owns small reusable rank-two definitions.

- `RankTwoRotation.lean`: the standard real planar rotation as a complex unitary matrix.
- `HarmonicOptimization.lean`: the second-harmonic maximum and canonical angle in `[-π/2, π/2)`.
- `RankTwoPauli.lean`: Pauli coordinates, real-rotation action, canonical decomposition, and Frobenius pairing.
- `RankTwoSpectralPerturbation.lean`: exact rank-two band values, Hermitian coordinate representation, Frobenius coefficient identity, and an unnormalized Frobenius band-error bound.
- `RankTwoConjugation.lean`: exact complex-unitary spectrum, trace, determinant, scalar-coordinate, Pauli-radius, and lower/upper-band invariance, with a pointwise field corollary.

## Boundaries

These modules provide supporting mathematics only.

- These declarations are supporting mathematics, not novelty claims.
- The perturbation theorem does not make the rank-normalized Frobenius quantity a general Weyl bound.
- Conjugation theorems accept an exact supplied unitary and exact post-conjugation coordinate equality; they do not authenticate a runtime gauge, eigensolver, band tracker, or mesh.
- The spectrum statement is a thin rank-two specialization of Mathlib's unitary spectrum invariance; no novelty claim is made.
- New declarations must not silently generalize source claims or duplicate Mathlib or Physlib APIs.
- `docs/theorem-manifest.md` is the declaration ledger.

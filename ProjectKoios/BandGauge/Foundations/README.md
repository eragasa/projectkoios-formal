# BandGauge foundations

This directory owns small reusable rank-two definitions.

- `RankTwoRotation.lean`: the standard real planar rotation as a complex unitary matrix.
- `HarmonicOptimization.lean`: the second-harmonic maximum and canonical angle in `[-π/2, π/2)`.
- `RankTwoPauli.lean`: Pauli coordinates, real-rotation action, canonical decomposition, and Frobenius pairing.

## Boundaries

These modules provide supporting mathematics only.

- These declarations are supporting mathematics, not novelty claims.
- New declarations must not silently generalize source claims or duplicate Mathlib or Physlib APIs.
- `docs/theorem-manifest.md` is the declaration ledger.

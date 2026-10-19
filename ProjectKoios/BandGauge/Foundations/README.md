# BandGauge foundations

This folder owns small reusable definitions needed across theorem families: finite
indices, support vocabulary, state-space and frame maps, gauge actions, and elementary
matrix algebra.

`RankTwoRotation.lean` owns:

- `BG-FOUNDATION-DEF-001` — the standard real planar rotation embedded as a complex
  unitary `2 × 2` matrix; status `implemented`.

`HarmonicOptimization.lean` owns `BG-FOUNDATION-DEF-002--004/006` and
`BG-FOUNDATION-THM-001/002/005/006`: the standard second-harmonic upper bound, exact
complex-argument maximizer, and reduction to `[-π/2, π/2)`.

`RankTwoPauli.lean` owns `BG-FOUNDATION-DEF-005/007--009` and
`BG-FOUNDATION-THM-003/004/007`: standard real Pauli matrices, their canonical coordinate
extraction from traceless Hermitian complex `2 × 2` matrices, their transformation under
the real rotation, and their Frobenius pairing.

These results are standard supporting infrastructure, not paper contributions or novelty
claims. New definitions must not silently generalize a source claim or duplicate an
existing Mathlib/Physlib concept.

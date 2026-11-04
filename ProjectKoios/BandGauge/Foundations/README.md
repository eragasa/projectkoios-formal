# BandGauge foundations

This directory owns small reusable finite-rank foundations.

- `RankTwoRotation.lean`: the standard real planar rotation as a complex unitary matrix.
- `HarmonicOptimization.lean`: the second-harmonic maximum and canonical angle in `[-π/2, π/2)`.
- `RankTwoPauli.lean`: Pauli coordinates, real-rotation action, canonical decomposition, and Frobenius pairing.
- `RankTwoSpectralPerturbation.lean`: exact rank-two band values, Hermitian coordinate representation, Frobenius coefficient identity, and an unnormalized Frobenius band-error bound.
- `RankTwoConjugation.lean`: exact complex-unitary spectrum, trace, determinant, scalar-coordinate, Pauli-radius, and lower/upper-band invariance, with a pointwise field corollary.
- `FiniteRankAnalyticParent.lean`: exact finite-bond structure-factor bounds, evenly spaced rank-N orbital coordinates, retained/exterior analytic-parent energy bounds, the `19/10` external-gap certificate, the adjacent-gap lower bound, and strict adjacent retained-energy ordering.
- `HermitianSpectralError.lean`: canonical decreasing Hermitian eigenvalue vectors on `Fin (Fintype.card n)`, separate maximum and RMS ordered-eigenvalue errors, their finite comparison, and zero-error characterization by characteristic-polynomial equality.
- `HermitianEigenvaluePerturbation.lean`: direct finite-dimensional leading/trailing-eigenspace proof of the maximum-form Weyl bound for symmetric maps, its Hermitian matrix `L2Operator` specialization, and the maximum ordered-eigenvalue-error consequence.
- `HermitianEigenvalueRmsPerturbation.lean`: Birkhoff--von Neumann, rearrangement, eigenbasis-overlap, and Hilbert--Schmidt proof of the unnormalized Hoffman--Wielandt square-sum bound, followed by its dimension-normalized RMS consequence.

## Boundaries

These modules provide supporting mathematics only.

- These declarations are supporting mathematics, not novelty claims.
- The perturbation theorem does not make the rank-normalized Frobenius quantity a general Weyl bound.
- Conjugation theorems accept an exact supplied unitary and exact post-conjugation coordinate equality; they do not authenticate a runtime gauge, eigensolver, band tracker, or mesh.
- The spectrum statement is a thin rank-two specialization of Mathlib's unitary spectrum invariance; no novelty claim is made.
- The finite-rank analytic-parent results validate exact formulas under exact interval premises. They do not authenticate NumPy evaluation, floating-point structure factors, sampled gaps, eigensolver output, mesh adequacy, alignment recovery, runtime artifacts, or scientific applicability.
- The ordered-eigenvalue layer retains algebraic multiplicity through Mathlib's Hermitian characteristic-polynomial roots. Its Weyl theorem controls pointwise and maximum errors by the `L2Operator` norm, while the separate Hoffman--Wielandt theorem controls the unnormalized square sum and dimension-normalized RMS error by entrywise Frobenius power. Neither route authenticates runtime eigenvalue ordering, degeneracy handling, or matrix entries.
- New declarations must not silently generalize source claims or duplicate Mathlib or Physlib APIs.
- `docs/theorem-manifest.md` is the declaration ledger.

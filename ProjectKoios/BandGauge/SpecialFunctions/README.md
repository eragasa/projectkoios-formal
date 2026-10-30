# BandGauge special functions

This directory owns source-neutral exact special-function identities used by BandGauge consumers.

- `BesselJZeroIntegral.lean`: full-angle cosine moments, termwise exponential integration, the exact bridge to Mathlib's regularized-hypergeometric definition of `Complex.besselJ`, and
  \(\int_0^{2\pi} e^{iz\cos\theta}\,d\theta = 2\pi J_0(z)\) for real `z`.

The proof architecture is adapted with Apache-2.0 attribution from theorem
`QuantumTheory.Transport.polarFourierZerothAngularKernel_eq_besselJ` in
`naoki-cpp/LeanCondensedMatter` merge commit
`47d64b9d2e85522dbbef295bf0ce3d2a1d0afe87`. The external package is not a dependency.

This module does not supply a full Jacobi--Anger expansion, nonzero-order Bessel identities,
shell-tail estimates, runtime values, quadrature certification, external phase binding, or physical
interpretation.

# Source-neutral finite-dimensional quantum algebra

This directory owns exact source-neutral finite-dimensional constructions.

- `OrthogonalCompression.lean`: compression and discarded-sector identities.
- `DecompositionIdentifiability.lean`: exact additive decomposition nonuniqueness.
- `ModelClassFitting.lean`: Frobenius-optimal coordinate-mask, diagonal, tridiagonal, and scalar fits.
- `OrbitalExpansion.lean`: finite complex basis-function and coefficient expansion of pointwise orbital amplitudes.
- `ReductionBasis.lean`: rectangular basis `Φ` under `Φᵀ Φ = I`, projector `P = Φ Φᵀ`, coefficient round-trip, reduction, embedding, and symmetry preservation.
- `RankOneResolvent.lean`: rank-one determinant, singularity, inverse, resolvent, and supplied-secular-root identities.
- `SpinEmbedding.lean`: orbital-major `A ⊗ₖ I₂` lifts and spin injections.
- `SpinIndependentProjection.lean`: half-partial-trace projection and least-distance characterization.
- `SpinPauliResidual.lean`: Pauli-channel blocks and exact Frobenius residuals.
- `SpinPauliVector.lean`: ordered Pauli-vector multiplication, trace, commutator, and unitary algebra.
- `SpinPauliDecomposition.lean`: canonical scalar-plus-Pauli reconstruction and fixed-`z`
  collinearity criteria.
- `SpinFrameRotation.lean`: active global `SU(2)` lifting and conjugation on spinful matrices.
- `SpinSO3Covariance.lean`: induced `SU(2) → SO(3)` homomorphism and Pauli-coefficient covariance.
- `SpinGlobalCollinearity.lean`: existence and invariance of one global frame making all orbital
  spin blocks fixed-axis collinear.
- `SpinorDensityMatrix.lean`: finite pointwise spinor outer products, occupation-weighted density
  matrices, positive semidefiniteness, and trace formulas.

## Boundaries

Notation and theorem scope remain explicit.

- `Q` is reserved for `I - P`.
- Resolvent results require explicit invertibility and denominator premises; root existence is not proved.
- Orbital expansion does not assert basis completeness, normalization, orthogonality, density semantics, or coefficient uniqueness.
- Global-frame collinearity uses one `SU(2)` rotation for the entire finite orbital matrix.
- Finite spinor density matrices are pointwise algebra only: they contain no measure space, `Lᵖ`
  equivalence class, spatial basis, discretization error, or convergence claim.
- The finite modules do not define position-dependent or almost-everywhere frames, continuum spin
  densities, DFT effective-potential bindings, or spin--orbit Hamiltonians.
- The modules do not bind runtime matrices, binary64 values, eigensolvers, root finders, serialized data, authored physical coefficients, time-reversal implementations, or applicability.

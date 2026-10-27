# Source-neutral finite-dimensional quantum algebra

This directory owns exact finite matrix constructions.

- `OrthogonalCompression.lean`: compression and discarded-sector identities.
- `DecompositionIdentifiability.lean`: exact additive decomposition nonuniqueness.
- `ModelClassFitting.lean`: Frobenius-optimal coordinate-mask, diagonal, tridiagonal, and scalar fits.
- `ReductionBasis.lean`: rectangular basis `Φ` under `Φᵀ Φ = I`, projector `P = Φ Φᵀ`, coefficient round-trip, reduction, embedding, and symmetry preservation.
- `RankOneResolvent.lean`: rank-one determinant, singularity, inverse, resolvent, and supplied-secular-root identities.
- `SpinEmbedding.lean`: orbital-major `A ⊗ₖ I₂` lifts and spin injections.
- `SpinIndependentProjection.lean`: half-partial-trace projection and least-distance characterization.
- `SpinPauliResidual.lean`: Pauli-channel blocks and exact Frobenius residuals.

## Boundaries

Notation and theorem scope remain explicit.

- `Q` is reserved for `I - P`.
- Resolvent results require explicit invertibility and denominator premises; root existence is not proved.
- The modules do not bind runtime matrices, binary64 values, eigensolvers, root finders, serialized data, authored physical coefficients, time-reversal implementations, or applicability.

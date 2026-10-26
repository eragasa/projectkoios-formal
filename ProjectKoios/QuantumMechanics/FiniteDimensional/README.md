# Source-neutral finite-dimensional quantum algebra

- `OrthogonalCompression.lean` separates consistent compression, unmatched compression, and the
  discarded sector under explicit idempotence and commutation premises.
- `DecompositionIdentifiability.lean` proves that a nonzero additive shift yields a distinct exact
  decomposition of the same matrix.
- `ModelClassFitting.lean` proves squared-Frobenius optimality for coordinate masks, including
  diagonal and tridiagonal classes, the finite-mean scalar diagonal fit, and the unrestricted exact
  fit.

`ReductionBasis.lean` uses `Φ` for a rectangular map from reduced coefficients into a full finite
space. It uses the exact orthonormal-column premise `Φᵀ Φ = I` and defines

- the retained projector, `P = Φ Φᵀ`;
- the reduced Hamiltonian, `Hred = Φᵀ H Φ`; and
- its full-space embedding, `Hemb = Φ Hred Φᵀ`.

The proved identities include coefficient round-trip, projector idempotence and symmetry,
`Hemb = P H P`, and preservation of real-matrix symmetry by reduction and embedding. The letter
`Q` is intentionally reserved for the complementary projector `I - P`, matching the PIAB1D
calculation protocol.

`RankOneResolvent.lean` formalizes complex finite-matrix rank-one updates. It proves the matrix
determinant factorization, exact scalar singularity condition, Sherman--Morrison inverse identity,
Hermitian real-coupling specializations, and the resolvent-constructed eigenvector equation at a
supplied secular zero. Base invertibility and nonzero-denominator premises are explicit. The module
does not prove that a secular root exists, select a numerical root, certify bisection or eigensolver
execution, or attach physical-defect meaning to an abstract matrix update.

`SpinEmbedding.lean` adjoins a two-state spin coordinate in orbital-major product order. It defines
the exact spin-degenerate lift `A ⊗ₖ I₂`, selected-spin injections, and injection-sandwich
pullbacks. The proved identities recover diagonal spin blocks, annihilate cross-spin blocks, show
that the injections are mutually orthogonal isometries, preserve Hermiticity and multiplication,
double trace and squared Frobenius norm, and establish injectivity of the lift.

`SpinIndependentProjection.lean` defines the partial spin trace, its half-average, and the exact
projection `M ↦ ((Tr_spin M) / 2) ⊗ₖ I₂`. It proves recovery of degenerate lifts, idempotence, the
fixed-point characterization, the entrywise averaged-block formula, preservation of trace and
Hermiticity, Frobenius orthogonality, the Pythagorean identity, and the unique least-distance
property.

`SpinPauliResidual.lean` defines the standard Pauli matrices and the general finite orbital term
`Bx ⊗ₖ σx + By ⊗ₖ σy + Bz ⊗ₖ σz`. It proves exact spin-block formulas, zero partial spin trace,
Hermiticity under explicit hypotheses, and the collinear and three-channel squared Frobenius
residual identities.

No module assigns physical meaning to a decomposition or verifies runtime matrices, binary64
orthogonality, eigensolver output, root-finding, serialization, authored coefficient matrices,
time-reversal implementations, or physical applicability.

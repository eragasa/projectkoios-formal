# Finite-lattice algebra

This directory owns exact finite folding, route, gauge-loop, and lattice-quotient algebra.

- `Folding.lean`: normalized character folding, block supercells, Bloch fibers, and exact block diagonalization; `G = ZMod N` is the cyclic specialization.
- `RouteCommutativity.lean`: coordinate pullback, energy shifts, defect subtraction, folding, composition, Hermiticity, and spin-lift identities.
- `GaugeLoops.lean`: path covariance, loop conjugation, scalar/Bargmann phase invariance, and Wilson determinant invariance.
- `ProjectorBargmann.lean`: rank-one projector products and the exact Bargmann trace identity.
- `QuotientAdmission.lean`: exact integer-lattice preservation certificates, induced quotient maps, full-rank quotient finiteness from `det B ≠ 0` via the adjugate identity, and two-sided bijectivity criteria. A certificate `A B = B C` is the division-free form of the integrality condition for `B⁻¹ A B` when `B` is nonsingular.

## Boundaries

The results remain finite algebraic identities.

- Gauge values are units; link values need not be invertible.
- In the noncommutative setting, a closed product transforms by conjugation. Equality requires commutativity or a conjugation-invariant observable.
- Projector idempotence requires unit normalization.
- `Complex.arg` is totalized; phase invariance proves neither nonvanishing nor branch unwrapping.
- Runtime link matrices, loop orientation, boundary sewing, finite-mesh identities, tolerances, and spectra remain external.
- Quotient-map well-definedness and bijectivity are separate: the forward and inverse integer maps must each preserve the declared lattice.
- The modules do not infer topology, prove Chern integrality or a Wannier obstruction, execute Wannier90, validate meshes, or establish physical applicability.

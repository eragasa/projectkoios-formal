# Finite-lattice algebra

This directory owns exact finite folding, route, and gauge-loop algebra.

- `Folding.lean`: normalized character folding, block supercells, Bloch fibers, and exact block diagonalization; `G = ZMod N` is the cyclic specialization.
- `RouteCommutativity.lean`: coordinate pullback, energy shifts, defect subtraction, folding, composition, Hermiticity, and spin-lift identities.
- `GaugeLoops.lean`: path covariance, loop conjugation, scalar/Bargmann phase invariance, and Wilson determinant invariance.
- `ProjectorBargmann.lean`: rank-one projector products and the exact Bargmann trace identity.

## Boundaries

The results remain finite algebraic identities.

- Gauge values are units; link values need not be invertible.
- In the noncommutative setting, a closed product transforms by conjugation. Equality requires commutativity or a conjugation-invariant observable.
- Projector idempotence requires unit normalization.
- `Complex.arg` is totalized; phase invariance proves neither nonvanishing nor branch unwrapping.
- Runtime link matrices, loop orientation, boundary sewing, tolerances, and spectra remain external.
- The modules do not infer topology, prove Chern integrality or a Wannier obstruction, execute Wannier90, validate meshes, or establish physical applicability.

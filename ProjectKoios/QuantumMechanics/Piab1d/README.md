# PIAB1D formalization

This directory owns exact mathematics for the concrete one-dimensional particle-in-a-box model.
The name is intentionally dimension-specific.

Implemented boundaries:

- the scaled centered interior-coordinate Dirichlet matrix and its symmetry;
- a separately declared cyclic corner coupling, its exact support, and its equality with the
  source-neutral PBC matrix corner realization;
- PIAB1D Dirichlet modes as antisymmetric combinations of counter-propagating complex exponential modes;
- exact endpoint conditions, the local centered-difference eigen-equation, and its finite
  `Matrix.mulVec` realization;
- canonical phases `exp(i kπ/(N+1))`, their root-of-unity and conjugation properties, real
  representability of sine-normalized modes, the exact eigenvalue `2-2 cos(kπ/(N+1))`, and the
  signed inverse-square scaling bridge to the declared PIAB1D Hamiltonian;
- the exact identification of each Dirichlet mode with the first-half restriction of an
  antisymmetric reciprocal-character eigenmode on the doubled PBC cycle.

The reusable translation-character, scalar-twisted/PBC, and doubled-cycle odd-extension algebra
lives in `QuantumMechanics/FiniteDifference/ExponentialMode1D.lean`,
`TwistedCyclic1D.lean`, and `OddExtension1D.lean`. Reusable compression,
decomposition-identifiability, and Frobenius model-class fitting live in
`QuantumMechanics/FiniteDimensional/`.

Not proved here:

- identification of the exact Lean matrix with a concrete runtime binary64 array;
- continuum spectral completeness, operator domains, or self-adjointness;
- second-order finite-box or grid-convergence bounds;
- correctness of binary64 arrays or retained JSON outputs;
- a Bloch--Floquet theorem. Scalar real-space twists and exponential translation laws are only
  algebraic infrastructure for a later reviewed bridge to reciprocal-fiber sewing.

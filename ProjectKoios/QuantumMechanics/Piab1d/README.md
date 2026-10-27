# PIAB1D formalization

This directory owns the exact finite one-dimensional particle-in-a-box specialization.

- Scaled centered Dirichlet and explicitly supported cyclic-corner matrices.
- Antisymmetric exponential Dirichlet modes, endpoint conditions, and real sine representatives.
- Canonical phases `exp(i kπ/(N+1))`, their root-of-unity and conjugation laws, eigenvalues `2 - 2 cos(kπ/(N+1))`, and the signed inverse-square Hamiltonian scaling bridge.
- Exact finite `Matrix.mulVec` eigen-equations.
- Restriction from the doubled periodic odd sector.

Reusable lattice algebra remains in `QuantumMechanics/FiniteDifference/`; compression and fitting remain in `QuantumMechanics/FiniteDimensional/`.

## Boundaries

The specialization remains finite and exact.

- No runtime-array, JSON, or binary64 binding.
- No continuum completeness, operator-domain, self-adjointness, or convergence claim.
- No Bloch--Floquet theorem or identification of scalar twists with reciprocal-fiber sewing.

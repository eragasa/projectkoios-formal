# Source-neutral finite-difference algebra

This directory owns exact one-dimensional lattice algebra.

- `CenteredDirichlet1D.lean`: centered Dirichlet stencil and symmetry.
- `ExponentialMode1D.lean`: lattice characters, translation covariance, and exact difference eigenvalues.
- `DirichletMatrixMode1D.lean`: finite zero-ghost matrix eigenmodes.
- `TwistedCyclic1D.lean`: twisted cycles, PBC, Hermiticity, and shifted-cosine modes.
- `OddExtension1D.lean`: doubled-cycle odd extension and Dirichlet restriction.
- `ConstantPotential1D.lean`: constant-region residuals and determinant-one transfer matrices.
- `FiniteBarrier1D.lean`: symbolic piecewise barriers and exact propagation.
- `BarrierMatching1D.lean`: interface amplitudes and uniqueness away from coincident reciprocal roots.

## Boundaries

The modules prove exact finite algebra only.

- Parameters, roots, and amplitudes remain symbolic.
- The modules do not solve scattering amplitudes, assign flux probabilities, take an infinite-barrier or continuum limit, identify a finite barrier with a boundary condition, bind runtime arrays, or prove Bloch--Floquet decomposition.
- Scalar real-space twists are not reciprocal-fiber sewing data.

# Source-neutral finite-difference algebra

- `CenteredDirichlet1D.lean` defines the real centered one-dimensional interior-coordinate stencil
  and proves symmetry.
- `ExponentialMode1D.lean` defines complex integer-lattice translation modes, proves translation
  covariance, their exact centered-difference eigenvalue, periodicity under a root-of-unity
  condition, and the corresponding antisymmetric-mode identities.
- `DirichletMatrixMode1D.lean` restricts antisymmetric lattice modes to interior coordinates and
  proves their exact finite `Matrix.mulVec` eigen-equation with zero ghost boundaries.
- `TwistedCyclic1D.lean` defines scalar-twisted finite cycles, realizes them as exact matrices,
  proves their two-corner relation to the Dirichlet matrix, derives PBC as twist one, proves
  Hermiticity for unit-circle twists, and supplies canonical twisted and periodic character modes
  with exact shifted-cosine dispersion relations.
- `OddExtension1D.lean` extends Dirichlet vectors oddly to a doubled periodic cycle, proves the
  reflection-odd law, and proves that restricting the periodic difference recovers the Dirichlet
  difference exactly.

The scalar twist relation `v(n+L) = τ v(n)` is a finite real-space boundary condition. It is not
silently identified with the separate reciprocal-fiber sewing API in `BandGauge/Bloch`.
These modules do not bind floating-point arrays, establish continuum convergence, or prove a
Bloch--Floquet decomposition.

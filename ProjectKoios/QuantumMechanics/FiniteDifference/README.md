# Source-neutral finite-difference algebra

- `CenteredDirichlet1D.lean` defines the real centered one-dimensional interior-coordinate stencil
  and proves symmetry.
- `ExponentialMode1D.lean` defines complex integer-lattice translation modes, proves translation
  covariance, their exact centered-difference eigenvalue, periodicity under a root-of-unity
  condition, and the corresponding antisymmetric-mode identities.
- `DirichletMatrixMode1D.lean` restricts antisymmetric lattice modes to interior coordinates and
  proves their exact finite `Matrix.mulVec` eigen-equation with zero ghost boundaries.

These modules do not bind floating-point arrays or establish continuum convergence.

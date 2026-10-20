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
- `ConstantPotential1D.lean` defines the exact constant-region lattice residual, reciprocal
  character superpositions, the one-site transfer matrix, its determinant-one property and
  character eigenvector, and exact finite-step propagation.
- `FiniteBarrier1D.lean` defines a symbolic left/barrier/right piecewise-constant potential,
  specializes its recurrence in each region, and proves determinant-one transfer and exact
  interface-state propagation through a barrier of arbitrary natural-number width.
- `BarrierMatching1D.lean` maps reciprocal-character amplitudes to interface states, proves the
  interface determinant and its non-band-edge criterion, states exact left/right amplitude
  matching, bridges it to shifted lattice-mode states, and proves existence and uniqueness of a
  right amplitude representation away from coincident reciprocal roots.

The barrier parameters, energy, character roots, and amplitudes remain universally quantified.
The module does not select scattering normalization, solve amplitudes, take an infinite-barrier
limit, or identify a finite barrier with a boundary condition.

The scalar twist relation `v(n+L) = τ v(n)` is a finite real-space boundary condition. It is not
silently identified with the separate reciprocal-fiber sewing API in `BandGauge/Bloch`.
These modules do not bind floating-point arrays, establish continuum convergence, prove a
Bloch--Floquet decomposition, or certify a numerical transmission/reflection calculation.

# Quantum-mechanics formalization

This directory owns source-neutral quantum mathematics, not a complete physical postulate system.

## Modules

The modules separate state, operator, and controlled-model mathematics.

- `State.lean`: normalized vector representatives and unit-modulus phase shifts; representatives are not quotient rays.
- `Measurement/FinitePureState.lean`: finite bounded operations with explicit norm completeness.
- `QuantumInformation/`: thin bindings to the pinned `QuantumInfo` pure-ray, mixed-state, POVM,
  CPTP-channel, tensor-product, partial-trace, and separability APIs.
- `Dirac.lean`: typed bras, kets, brackets, outer products, and normalized rank-one projectors.
- `RiggedHilbertSpace.lean`: test-space inclusion and generalized bra/ket embeddings.
- `Operator/`: dense partial operators, formal adjoints, self-adjointness criteria, continuum
  Schrödinger bridges, and the bounded hydrogenic symmetry/closability boundary.
- `AngularMomentum/`: stable Physlib three-dimensional orbital-angular-momentum operators and
  PhyslibAlpha finite spin-half and dimensionless spin-orbit bindings.
- `Fourier/`: function-level pointwise Fourier-integral injectivity.
- `Evolution/`: the physical convention `U(t)=exp(-itH/ℏ)` and its domain-aware PhyslibAlpha
  adapter.
- `FiniteDimensional/`: compression, reduction, fitting, rank-one resolvents, finite spin algebra
  through global-frame collinearity, and separate pointwise spinor density-matrix algebra.
- `SpinDensity/`: representative-safe matrix-valued `L¹` spin densities, almost-everywhere global
  collinearity, particle-density invariance, induced `SO(3)` magnetization covariance, Ullrich-style
  Pauli reconstruction, and finite weighted `L²` spinor outer products.
- `FiniteDifference/`: exact lattice, boundary, and transfer algebra.
- `HarmonicOscillator/`: continuum self-adjointness/closure packaging plus Hermite, ladder,
  truncation, finite-difference, and comparison results.
- `Piab1d/`: finite particle-in-a-box specialization.

## Conventions and boundaries

The namespace follows Mathlib's analytic conventions.

- Mathlib's inner product is conjugate-linear in its first argument.
- Ordinary Riesz bras depend conjugate-linearly on kets; current generalized bras are linear and generalized kets are conjugate-linear on test vectors.
- Dense-domain and formal-adjoint results do not imply closedness, closability, adjoint equality, essential self-adjointness, generalized eigenvectors, or spectral completeness.
- Named definitions, not decorative Dirac notation, determine type orientation.
- Generic layers do not select a Hamiltonian. The harmonic-oscillator module packages one proved
  self-adjoint closure and binds it to the adopted domain-aware Cayley spectral measure and physical
  strong Stone evolution; this does not supply an eigenfunction expansion or physical validation.
- Finite quantum-information declarations reuse the pinned `QuantumInfo` carriers; they do not
  introduce competing mixed-state, measurement, channel, or entanglement abstractions.
- The continuum angular-momentum layer proves symmetry and closability only. The finite spin-orbit
  layer uses PhyslibAlpha's dimensionless `ℏ=1` convention and is not yet a continuum or DFT SOC
  Hamiltonian binding.
- Continuum spin-density equality is equality of matrix-valued `L¹` classes. Hermiticity,
  positive semidefiniteness, and collinearity are almost-everywhere predicates. Positivity and
  particle-number identities require explicit occupation and normalization hypotheses.
- Finite pointwise density matrices and continuum `L¹` densities remain separate. The continuum
  layer now proves componentwise, full-matrix, and fixed-occupation finite-family `L² → L¹` error
  bounds, plus conditional convergence transfer to matrix, particle, and magnetization densities.
  An explicit finite-index continuum-spinor reconstruction map now connects supplied `L²` basis
  functions and coefficient tables to these bounds. An idempotent strongly complete projection
  contract now states sufficient conditions for convergence, and a countable Mathlib Hilbert basis
  canonically constructs it using finite rank-one partial sums. The proved one-dimensional
  oscillator/Hermite eigenstates now provide the first concrete instance and yield spin-density,
  particle-density, and magnetization convergence. Kohn--Sham or numerical basis identification is
  still separate and is not inferred by definitional identification. Exact coefficient-tail errors
  now also admit explicit cutoff rates and density-error budgets under supplied summable global
  weighted coefficient moments; finite coefficients alone do not justify those moment contracts.
  For components in the selected oscillator Hamiltonian closure domain, the `p=2` contract is now
  derived from Hamiltonian-image norms, giving inverse-linear orbital and full density-error bounds.
  The same reconstructed components equal the domain-valued oscillator partial sums used to prove
  graph-norm convergence and oscillator energy-expectation convergence. Normalized-state energy
  results require nonzero or unit-norm targets as stated, and normalized partial sums are unit
  vectors only eventually; no Kohn--Sham total-energy or numerical energy convergence is inferred.
- The existing finite diagonal oscillator matrix is now bound by a Euclidean coefficient isometry
  to the selected continuum closure: exact intertwining, adjoint compression, equal quadratic
  energies, and the `K+1`-term partial-sum crosswalk are proved. Finite eigenpair residuals now
  transport exactly with equal continuum norms; unit coefficients yield proximity to some retained
  level, and an explicit positive gap from the trial energy to other retained levels bounds the
  selected eigenstate's orthogonal component. This does not authenticate sampled grids, quadrature,
  floating-point arrays, numerical residual reports, or numerical eigensolvers. A separate exact
  rational checker now computes mass `S` and an endpoint residual budget: acceptance plus a proved
  enclosure of actual `ℏω₀` gives a normalized continuum residual and retained-energy tolerance
  `sqrt (B/S)`. The checker does not produce that enclosure, parse runtime data, or check gaps.
- Exchange-correlation semantics, local frames, and SOC dynamics require downstream bindings.
- The modules do not verify runtime artifacts or establish physical applicability. Governed
  postulate and literature crosswalks remain external, and protected source bytes do not belong
  here.

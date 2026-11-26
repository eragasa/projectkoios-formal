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
- `FiniteDimensional/`: compression, reduction, fitting, rank-one resolvents, and spin algebra.
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
- The modules do not verify runtime artifacts or establish physical applicability. Governed
  postulate and literature crosswalks remain external, and protected source bytes do not belong
  here.

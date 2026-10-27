# Quantum-mechanics formalization

This directory owns source-neutral quantum mathematics, not a complete physical postulate system.

## Modules

The modules separate state, operator, and controlled-model mathematics.

- `State.lean`: normalized vector representatives and unit-modulus phase shifts; representatives are not quotient rays.
- `Measurement/FinitePureState.lean`: finite bounded operations with explicit norm completeness.
- `Dirac.lean`: typed bras, kets, brackets, outer products, and normalized rank-one projectors.
- `RiggedHilbertSpace.lean`: test-space inclusion and generalized bra/ket embeddings.
- `Operator/TestDomain.lean`: dense partial operators, formal adjoints, and maximal-adjoint containment.
- `FiniteDimensional/`: compression, reduction, fitting, rank-one resolvents, and spin algebra.
- `FiniteDifference/`: exact lattice, boundary, and transfer algebra.
- `HarmonicOscillator/`: Hermite, ladder, truncation, finite-difference, and comparison results.
- `Piab1d/`: finite particle-in-a-box specialization.

## Conventions and boundaries

The namespace follows Mathlib's analytic conventions.

- Mathlib's inner product is conjugate-linear in its first argument.
- Ordinary Riesz bras depend conjugate-linearly on kets; current generalized bras are linear and generalized kets are conjugate-linear on test vectors.
- Dense-domain and formal-adjoint results do not imply closedness, closability, adjoint equality, essential self-adjointness, generalized eigenvectors, or spectral completeness.
- Named definitions, not decorative Dirac notation, determine type orientation.
- The modules do not select concrete Hamiltonians, verify runtime artifacts, or establish physical applicability. Governed postulate and literature crosswalks remain external, and protected source bytes do not belong here.

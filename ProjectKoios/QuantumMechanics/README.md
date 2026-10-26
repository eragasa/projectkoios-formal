# Quantum-mechanics formalization modules

This directory owns source-neutral mathematical foundations for later quantum-mechanics
formalization. It does not claim to encode a complete textbook postulate system, validate numerical
execution or serialized artifacts, select a concrete Hamiltonian, or establish physical
applicability.

## Current modules

- `State.lean` defines normalized complex state-vector representatives and unit-modulus phase
  changes. Representatives are not quotient rays.
- `Measurement/FinitePureState.lean` defines a finite family of bounded measurement operations.
  Squared-norm completeness is supplied explicitly as structure data.
- `Dirac.lean` defines ordinary kets, bras, brackets, outer products, and normalized rank-one
  projectors using Mathlib's conjugate-linear-first inner-product convention.
- `RiggedHilbertSpace.lean` defines a Hausdorff locally convex test-space embedding core and both
  convention-sensitive Hilbert-to-test-dual injections.
- `Operator/TestDomain.lean` reuses Mathlib's partial-linear-map theory to turn a test-space
  endomorphism into a densely defined Hilbert-space operator, prove test-domain invariance, and lift
  a supplied formal-adjoint identity to maximal-adjoint containment.
- `FiniteDimensional/` owns compression, decomposition-identifiability, model-class fitting,
  rectangular reduction-basis, and two-state spin algebra.
- `FiniteDifference/` owns source-neutral centered-difference, boundary-cycle, odd-extension,
  constant-region, and finite-barrier algebra.
- `HarmonicOscillator/` owns exact QHO Hermite, finite-ladder, truncation, finite-difference, and
  finite-comparison mechanisms.
- `Piab1d/` owns the concrete finite one-dimensional box specialization.

## Dependency direction

```text
State ──→ Measurement/FinitePureState
  └─────→ Dirac ──→ RiggedHilbertSpace ──→ Operator/TestDomain

FiniteDifference ──→ Piab1d
FiniteDimensional and HarmonicOscillator remain narrow reusable families
```

Future closedness, closability, adjoint equality, essential self-adjointness, dual extensions,
generalized eigenvectors, and qualified spectral expansions must build in the first direction. They
must not be inferred from dense-domain or formal-adjoint containment alone.

## Convention boundary

For Mathlib, `⟪ψ, φ⟫_ℂ` is conjugate-linear in `ψ` and linear in `φ`. Consequently:

- an ordinary bra is a continuous linear functional on kets;
- conversion from a ket to its ordinary Riesz bra is conjugate-linear;
- a generalized bra in the current rigged-space convention is linear on test vectors; and
- a generalized ket is conjugate-linear on test vectors.

Named definitions are authoritative. Decorative Dirac notation should be added only after its
parser behavior and type orientation are separately reviewed.

## Source status

The modules are source-neutral. Exact Shankar postulate crosswalks remain blocked on governed Search
admission and equation-locator evidence. Concrete rigged-space choices and group-theory theorem
crosswalks likewise require separately governed sources. No local PDF bytes or protected archive
expression belong in this directory.

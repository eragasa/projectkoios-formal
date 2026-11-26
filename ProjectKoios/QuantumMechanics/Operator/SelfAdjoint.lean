/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.Operator.TestDomain
public import Physlib.QuantumMechanics.Operators.SpectralTheory.Symmetric
public import Physlib.QuantumMechanics.Operators.StateObservables.ExpectedValue

/-!
# Test-space symmetry and self-adjointness

This module connects Project Koios test-space operators to the adopted Physlib unbounded-operator
and observable APIs. A symmetric endomorphism of the declared test carrier induces a densely
defined symmetric and closable Hilbert-space operator. Physlib then supplies the domain criteria for
self-adjointness and essential self-adjointness, as well as real expectation values.

## i. Overview

For a rigged-space inclusion `i : Φ → H` and a test-space endomorphism `A : Φ →ₗ[ℂ] Φ`, the
existing construction `testSpaceOperator R A` has domain `i(Φ)` and action `iφ ↦ i(Aφ)`. The new
bridge records symmetry through the included Hilbert-space inner product and derives:

- symmetry in Physlib's `LinearPMap.IsSymmetric` sense;
- dense-domain closability, called `LinearPMap.IsUnbounded` by Physlib;
- real expectation values for vectors in the test domain;
- exact adjoint-domain criteria for self-adjointness and essential self-adjointness; and
- essential self-adjointness when supplied test-space eigenvectors have dense Hilbert-space span.

The last result is a specialization of Physlib's dense-span eigenvector criterion. It does not
establish that a concrete differential operator has the required eigenvectors or dense span.

## ii. Key results

- `testSpaceOperator_isSymmetric`
- `testSpaceOperator_isUnbounded`
- `testSpaceOperator_isSelfAdjoint_iff_adjoint_domain_eq`
- `testSpaceOperator_isEssentiallySelfAdjoint_iff_adjoint_domain_eq_closure_domain`
- `testSpaceOperator_isEssentiallySelfAdjoint_of_dense_span_eigenvectors`

## iii. Table of contents

- A. Proof schematic
- B. Test-space symmetry
- C. Operator consequences
- D. Domain criteria
- E. Dense eigenvector criterion

## iv. References

The operator notions and criteria are reused from Physlib revision
`101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`, especially
`Physlib.QuantumMechanics.Operators.Unbounded` and
`Physlib.QuantumMechanics.Operators.SpectralTheory.Symmetric`.

No spectral measure associated to a self-adjoint operator, functional calculus, Stone theorem, or
concrete Schrödinger Hamiltonian is constructed here.

## A. Proof schematic

```mermaid
flowchart TD
    formal["QM-OPERATOR-DEF-005<br/>test-space formal adjoint"]
    symmetricDef["QM-OPERATOR-DEF-006<br/>test-space symmetry"]
    dense["QM-OPERATOR-THM-001<br/>dense induced domain"]
    symmetric["QM-OPERATOR-LEM-006<br/>Physlib symmetry"]
    closable["QM-OPERATOR-LEM-007<br/>dense and closable"]
    expectation["QM-OPERATOR-LEM-008<br/>real expectation identity"]
    domains["QM-OPERATOR-LEM-009/010<br/>adjoint-domain criteria"]
    eigen["supplied test eigenvectors<br/>with dense included span"]
    esa["QM-OPERATOR-LEM-011<br/>essential self-adjointness"]

    formal --> symmetricDef
    symmetricDef --> symmetric
    dense --> closable
    symmetric --> closable
    symmetric --> expectation
    dense --> domains
    symmetric --> domains
    symmetric --> esa
    eigen --> esa
```
-/

@[expose] public section

open scoped LinearPMap

namespace ProjectKoios.QuantumMechanics

open ContinuousLinearMap InnerProductSpace

variable {Φ H : Type*}
  [TopologicalSpace Φ] [AddCommGroup Φ] [Module ℝ Φ] [Module ℂ Φ]
  [IsScalarTower ℝ ℂ Φ] [IsTopologicalAddGroup Φ] [ContinuousSMul ℂ Φ]
  [LocallyConvexSpace ℝ Φ] [T2Space Φ]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-! ## B. Test-space symmetry -/

/-- A test-space endomorphism is symmetric when its included action obeys the Hilbert-space
symmetry identity on all test vectors.

Project Koios ID: `QM-OPERATOR-DEF-006`. -/
def IsTestSpaceSymmetric
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ) : Prop :=
  IsTestSpaceFormalAdjoint R A A

/-- Test-space symmetry lifts to Physlib's symmetry predicate for the induced partial
Hilbert-space operator.

Project Koios ID: `QM-OPERATOR-LEM-006`. -/
lemma testSpaceOperator_isSymmetric
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ)
    (hA : IsTestSpaceSymmetric R A) :
    (testSpaceOperator R A).IsSymmetric := by
  exact isFormalAdjoint_testSpaceOperator R A A hA

/-! ## C. Operator consequences -/

/-- Every symmetric test-space operator induces a densely defined closable Hilbert-space
operator. Physlib calls this conjunction `IsUnbounded`; it does not assert failure of boundedness.

Project Koios ID: `QM-OPERATOR-LEM-007`. -/
lemma testSpaceOperator_isUnbounded
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ)
    (hA : IsTestSpaceSymmetric R A) :
    (testSpaceOperator R A).IsUnbounded := by
  exact (testSpaceOperator_isSymmetric R A hA).isUnbounded_iff_hasDenseDomain.mpr
    (testSpaceOperator_dense_domain R A)

/-- For a symmetric induced test-space operator, its complex expectation is the coercion of
Physlib's real expectation value.

Project Koios ID: `QM-OPERATOR-LEM-008`. -/
lemma testSpaceOperator_inner_eq_expectedValue
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ)
    (hA : IsTestSpaceSymmetric R A) (ψ : (testSpaceOperator R A).domain) :
    ⟪(ψ : H), testSpaceOperator R A ψ⟫_ℂ =
      (LinearPMap.expectedValue (testSpaceOperator R A) ψ : ℂ) := by
  exact LinearPMap.expectedValue_eq_inner _ (testSpaceOperator_isSymmetric R A hA) ψ

/-! ## D. Domain criteria -/

/-- Self-adjointness of a symmetric induced test-space operator is exactly equality between its
adjoint domain and its original included test domain.

Project Koios ID: `QM-OPERATOR-LEM-009`. -/
lemma testSpaceOperator_isSelfAdjoint_iff_adjoint_domain_eq
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ)
    (hA : IsTestSpaceSymmetric R A) :
    IsSelfAdjoint (testSpaceOperator R A) ↔
      (testSpaceOperator R A)†.domain = testDomain R := by
  rw [← testSpaceOperator_domain R A]
  exact (testSpaceOperator_isSymmetric R A hA).isSelfAdjoint_iff
    (testSpaceOperator_dense_domain R A)

/-- Essential self-adjointness is exactly equality between the adjoint domain and the closure
domain for the symmetric induced operator.

Project Koios ID: `QM-OPERATOR-LEM-010`. -/
lemma testSpaceOperator_isEssentiallySelfAdjoint_iff_adjoint_domain_eq_closure_domain
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ)
    (hA : IsTestSpaceSymmetric R A) :
    (testSpaceOperator R A).IsEssentiallySelfAdjoint ↔
      (testSpaceOperator R A)†.domain = (testSpaceOperator R A).closure.domain := by
  exact (testSpaceOperator_isSymmetric R A hA).isEssentiallySelfAdjoint_iff
    (testSpaceOperator_dense_domain R A)

/-! ## E. Dense eigenvector criterion -/

/-- A symmetric test-space operator is essentially self-adjoint when a supplied family of
test-space eigenvectors has dense span after inclusion into the Hilbert space.

This is an exact domain theorem. It does not prove the eigenvector equations or density premise for
a concrete Hamiltonian.

Project Koios ID: `QM-OPERATOR-LEM-011`. -/
lemma testSpaceOperator_isEssentiallySelfAdjoint_of_dense_span_eigenvectors
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ)
    (hA : IsTestSpaceSymmetric R A)
    {ι : Type*} (v : ι → Φ) (c : ι → ℂ)
    (hv : ∀ j, A (v j) = c j • v j)
    (hspan : Dense
      (Submodule.span ℂ (Set.range fun j ↦ R.inclusion (v j)) : Set H)) :
    (testSpaceOperator R A).IsEssentiallySelfAdjoint := by
  apply (testSpaceOperator_isSymmetric R A hA).isEssentiallySelfAdjoint_of_dense_span_eigenvectors
    (v := fun j ↦ includedTestVector R (v j)) (c := c)
  · intro j
    rw [testSpaceOperator_apply_includedTestVector, hv]
    simp [coe_includedTestVector]
  · simpa [coe_includedTestVector] using hspan

end ProjectKoios.QuantumMechanics

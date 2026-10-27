/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.QuantumMechanics.RiggedHilbertSpace
public import Mathlib.Analysis.InnerProductSpace.LinearPMap

/-!
# Test-space operators as densely defined Hilbert-space operators

This module connects a linear operator on the test space of a `RiggedHilbertSpaceCore` to Mathlib's
existing `LinearPMap` API for partially defined, potentially unbounded operators. It does not create
a competing unbounded-operator representation.

For a continuous injective dense inclusion `i : Φ → H` and a linear map `A : Φ →ₗ[ℂ] Φ`, the
induced partial operator on `H` has domain `i(Φ)` and action

`i(φ) ↦ i(A φ)`.

The action is well-defined because `i` is injective. Its domain is dense because the rigged-space
core records dense range. Continuity of `A` in the test-space topology, closedness, closability,
self-adjointness, essential self-adjointness, and a spectral theorem are not asserted.

## Equations implemented

- Test domain: `Dᵢ = LinearMap.range i`.
- Included test vector: `testVector(φ) = i(φ)` as an element of `Dᵢ`.
- Induced partial action: `T_A(testVector(φ)) = i(A φ)`.
- Domain invariance: `T_A(Dᵢ) ⊆ Dᵢ`.
- Dense domain: `Dense (T_A.domain : Set H)`.
- Formal-adjoint lift: a supplied test-space inner-product identity for `A` and `B` implies
  `T_A.IsFormalAdjoint T_B` in Mathlib's partial-operator sense.
- Adjoint containment: under the same identity, `T_B ≤ T_A†`.

## Library selection

The pinned Mathlib module `Mathlib.Analysis.InnerProductSpace.LinearPMap` already supplies partial
linear operators, adjoint domains, formal adjoints, closedness, closability, and self-adjointness.
This module reuses that API and owns only the bridge from the declared rigged-space test carrier.
Physlib remains unadopted.

## Source status

These are source-neutral functional-analytic foundations. They do not establish fidelity to a
textbook postulate, select a concrete test space, or bind a physical Hamiltonian. No local PDF or
protected archive expression was used to author this module.
-/

open scoped LinearPMap

@[expose] public section

namespace ProjectKoios.QuantumMechanics

open ContinuousLinearMap

variable {Φ H : Type*}
  [TopologicalSpace Φ] [AddCommGroup Φ] [Module ℝ Φ] [Module ℂ Φ]
  [IsScalarTower ℝ ℂ Φ] [IsTopologicalAddGroup Φ] [ContinuousSMul ℂ Φ]
  [LocallyConvexSpace ℝ Φ] [T2Space Φ]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- `QM-OPERATOR-DEF-001`: the Hilbert-space submodule consisting of included test-space
vectors. -/
def testDomain (R : RiggedHilbertSpaceCore Φ H) : Submodule ℂ H :=
  R.inclusion.toLinearMap.range

/-- `QM-OPERATOR-DEF-002`: the linear equivalence between the test carrier and its included
Hilbert-space range. -/
noncomputable def testDomainEquiv (R : RiggedHilbertSpaceCore Φ H) :
    Φ ≃ₗ[ℂ] testDomain R :=
  -- Injectivity is essential: without it, a Hilbert vector in the range would not determine a
  -- unique test-space representative on which to evaluate an operator.
  LinearEquiv.ofInjective R.inclusion.toLinearMap R.inclusion_injective

/-- `QM-OPERATOR-DEF-003`: a test-space vector packaged as an element of the induced Hilbert-space
domain. -/
def includedTestVector (R : RiggedHilbertSpaceCore Φ H) (φ : Φ) : testDomain R :=
  ⟨R.inclusion φ, ⟨φ, rfl⟩⟩

/-- `QM-OPERATOR-DEF-004`: the partial Hilbert-space operator induced by a linear endomorphism of
the test carrier. No continuity, symmetry, or closedness of `A` is inferred. -/
noncomputable def testSpaceOperator
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ) : H →ₗ.[ℂ] H where
  domain := testDomain R
  -- Recover the unique test representative, apply `A`, and include the result back into `H`.
  toFun := R.inclusion.toLinearMap.comp
    (A.comp (testDomainEquiv R).symm.toLinearMap)

/-- `QM-OPERATOR-DEF-005`: the test-space identity sufficient to make the induced operators
formal adjoints on their common dense Hilbert-space domain. -/
def IsTestSpaceFormalAdjoint
    (R : RiggedHilbertSpaceCore Φ H) (A B : Φ →ₗ[ℂ] Φ) : Prop :=
  ∀ φ ψ : Φ,
    inner ℂ (R.inclusion (A φ)) (R.inclusion ψ) =
      inner ℂ (R.inclusion φ) (R.inclusion (B ψ))

/-- `QM-OPERATOR-LEM-001`: forgetting the domain membership proof recovers the included Hilbert
vector. -/
lemma coe_includedTestVector (R : RiggedHilbertSpaceCore Φ H) (φ : Φ) :
    (includedTestVector R φ : H) = R.inclusion φ := by
  rfl

/-- `QM-OPERATOR-LEM-002`: the range equivalence sends a test vector to its explicitly packaged
included vector. -/
lemma testDomainEquiv_apply (R : RiggedHilbertSpaceCore Φ H) (φ : Φ) :
    testDomainEquiv R φ = includedTestVector R φ := by
  rfl

/-- `QM-OPERATOR-LEM-003`: the induced partial operator has exactly the included test-space
range as its domain. -/
lemma testSpaceOperator_domain
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ) :
    (testSpaceOperator R A).domain = testDomain R := by
  rfl

/-- `QM-OPERATOR-LEM-004`: the induced partial operator acts on an included test vector by applying
the test-space operator before inclusion. -/
lemma testSpaceOperator_apply_includedTestVector
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ) (φ : Φ) :
    testSpaceOperator R A (includedTestVector R φ) = R.inclusion (A φ) := by
  -- Rewrite the explicit vector through the range equivalence, then cancel the equivalence with
  -- its inverse. The remaining maps are definitionally the inclusion after `A`.
  change R.inclusion (A ((testDomainEquiv R).symm (includedTestVector R φ))) = _
  rw [← testDomainEquiv_apply R φ]
  simp

/-- `QM-OPERATOR-THM-001`: every operator induced from the declared test carrier is densely
defined on the Hilbert space. -/
theorem testSpaceOperator_dense_domain
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ) :
    Dense ((testSpaceOperator R A).domain : Set H) := by
  rw [testSpaceOperator_domain]
  -- The ordinary set range of the inclusion lies in its linear range. Density therefore passes
  -- to the partial operator's domain.
  refine R.inclusion_denseRange.mono ?_
  rintro _ ⟨φ, rfl⟩
  exact ⟨φ, rfl⟩

/-- `QM-OPERATOR-LEM-005`: the induced operator sends every domain element back into the same test
domain. -/
lemma testSpaceOperator_maps_domain
    (R : RiggedHilbertSpaceCore Φ H) (A : Φ →ₗ[ℂ] Φ)
    (x : (testSpaceOperator R A).domain) :
    testSpaceOperator R A x ∈ (testSpaceOperator R A).domain := by
  -- Choose the unique test representative of `x`, compute the action, and exhibit `A φ` as the
  -- representative of the output.
  rcases x.property with ⟨φ, hφ⟩
  have hx : x = includedTestVector R φ := Subtype.ext hφ.symm
  subst x
  rw [testSpaceOperator_apply_includedTestVector]
  exact (includedTestVector R (A φ)).property

/-- `QM-OPERATOR-THM-002`: a supplied formal-adjoint identity on the test carrier lifts to
Mathlib's formal-adjoint relation for the induced densely defined Hilbert-space operators. -/
theorem isFormalAdjoint_testSpaceOperator
    (R : RiggedHilbertSpaceCore Φ H) (A B : Φ →ₗ[ℂ] Φ)
    (h : IsTestSpaceFormalAdjoint R A B) :
    (testSpaceOperator R A).IsFormalAdjoint (testSpaceOperator R B) := by
  intro x y
  -- Pull arbitrary domain vectors back to their unique test-space representatives.
  let φ := (testDomainEquiv R).symm x
  let ψ := (testDomainEquiv R).symm y
  have hx : includedTestVector R φ = x := by
    rw [← testDomainEquiv_apply]
    exact (testDomainEquiv R).apply_symm_apply x
  have hy : includedTestVector R ψ = y := by
    rw [← testDomainEquiv_apply]
    exact (testDomainEquiv R).apply_symm_apply y
  -- Rewrite both domain vectors, compute both induced actions, and apply the supplied identity.
  rw [← hx, ← hy]
  simpa [testSpaceOperator_apply_includedTestVector,
    coe_includedTestVector] using h φ ψ

/-- `QM-OPERATOR-THM-003`: the induced formal adjoint is contained in Mathlib's adjoint partial
operator. This is an adjoint-containment result, not equality or self-adjointness. -/
theorem testSpaceOperator_le_adjoint
    (R : RiggedHilbertSpaceCore Φ H) (A B : Φ →ₗ[ℂ] Φ)
    (h : IsTestSpaceFormalAdjoint R A B) :
    testSpaceOperator R B ≤ (testSpaceOperator R A)† := by
  -- Mathlib's maximal-adjoint theorem requires density of the left operator's domain, which was
  -- proved above from the rigged-space inclusion rather than assumed again.
  exact (isFormalAdjoint_testSpaceOperator R A B h).le_adjoint
    (testSpaceOperator_dense_domain R A)

end ProjectKoios.QuantumMechanics

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-27
-/
module

public import Mathlib.Analysis.InnerProductSpace.Adjoint
public import ProjectKoios.BandGauge.Bloch.Sewing

/-!
# Sewn aligned-operator differences

This module defines subtraction of finite-fiber operator fields and the difference between a
reference field and a candidate field pulled back through a pointwise unitary alignment. Sewing
covariance is closed under subtraction, so a sewing-compatible alignment yields a sewn difference
field on the reference fibers.

The results are exact pointwise algebra. Under complete-space and pointwise self-adjointness
hypotheses, subtraction and unitary pullback preserve self-adjointness. The module does not choose
an alignment, bind runtime arrays, verify a numerical transport, or establish physical or spectral
adequacy.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Bloch

variable {Γ K E Eref Ecand : Type*}
variable [Group Γ] [MulAction Γ K]
variable [NormedAddCommGroup E] [InnerProductSpace ℂ E]
variable [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
variable [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand]

/-- `BG-BLOCH-DEF-012`: pointwise subtraction of two operator fields on one finite-fiber
space. -/
def operatorFieldDifference
    (reference candidate : K → E →L[ℂ] E) : K → E →L[ℂ] E :=
  fun k => reference k - candidate k

/-- `BG-BLOCH-THM-012`: operator-field subtraction evaluates as pointwise operator-value
subtraction. -/
theorem operatorFieldDifference_apply
    (reference candidate : K → E →L[ℂ] E) (k : K) (v : E) :
    operatorFieldDifference reference candidate k v =
      reference k v - candidate k v := by
  rfl

/-- `BG-BLOCH-THM-013`: subtraction of two operator fields with the same sewing covariance
preserves that covariance. -/
theorem isBlochOperatorField_operatorFieldDifference
    {sewing : SewingData Γ K E}
    {reference candidate : K → E →L[ℂ] E}
    (href : IsBlochOperatorField sewing reference)
    (hcand : IsBlochOperatorField sewing candidate) :
    IsBlochOperatorField sewing (operatorFieldDifference reference candidate) := by
  intro g k v
  change reference (g • k) (sewing.transport g k v) -
      candidate (g • k) (sewing.transport g k v) =
    sewing.transport g k (reference k v - candidate k v)
  rw [href g k v, hcand g k v, map_sub]

/-- `BG-BLOCH-THM-014`: reversing reference and candidate negates the operator difference. -/
theorem operatorFieldDifference_swap (reference candidate : K → E →L[ℂ] E) :
    operatorFieldDifference candidate reference =
      -operatorFieldDifference reference candidate := by
  funext k
  simp [operatorFieldDifference, neg_sub]

/-- `BG-BLOCH-THM-015`: adding the candidate field back to its reference-minus-candidate
difference recovers the reference field. -/
theorem operatorFieldDifference_add_right (reference candidate : K → E →L[ℂ] E) :
    operatorFieldDifference reference candidate + candidate = reference := by
  funext k
  simp [operatorFieldDifference]

/-- `BG-BLOCH-THM-016`: an operator difference field vanishes exactly when its two fields are
equal. -/
theorem operatorFieldDifference_eq_zero_iff (reference candidate : K → E →L[ℂ] E) :
    operatorFieldDifference reference candidate = 0 ↔ reference = candidate := by
  constructor
  · intro hzero
    funext k
    apply sub_eq_zero.mp
    simpa only [operatorFieldDifference, Pi.zero_apply] using congrFun hzero k
  · rintro rfl
    funext k
    simp [operatorFieldDifference]

/-- `BG-BLOCH-DEF-013`: difference between a reference operator field and a candidate field
pulled back through a pointwise unitary alignment. -/
noncomputable def alignedOperatorDifferenceField
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) :
    K → Eref →L[ℂ] Eref :=
  operatorFieldDifference reference (alignedOperatorField alignment candidate)

/-- `BG-BLOCH-THM-017`: the aligned difference applies as reference action minus the candidate
action transported to and from the candidate fiber. -/
theorem alignedOperatorDifferenceField_apply
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) (k : K) (v : Eref) :
    alignedOperatorDifferenceField alignment reference candidate k v =
      reference k v - (alignment k).symm (candidate k (alignment k v)) := by
  rfl

/-- `BG-BLOCH-THM-018`: a reference sewn field minus a sewing-compatible aligned candidate is a
sewn field on the reference fibers. -/
theorem isBlochOperatorField_alignedOperatorDifferenceField
    {referenceSewing : SewingData Γ K Eref}
    {candidateSewing : SewingData Γ K Ecand}
    {alignment : K → Eref ≃ₗᵢ[ℂ] Ecand}
    {reference : K → Eref →L[ℂ] Eref}
    {candidate : K → Ecand →L[ℂ] Ecand}
    (halignment : IsBlochAlignment referenceSewing candidateSewing alignment)
    (href : IsBlochOperatorField referenceSewing reference)
    (hcand : IsBlochOperatorField candidateSewing candidate) :
    IsBlochOperatorField referenceSewing
      (alignedOperatorDifferenceField alignment reference candidate) := by
  apply isBlochOperatorField_operatorFieldDifference href
  exact isBlochOperatorField_alignedOperatorField halignment hcand

/-- `BG-BLOCH-THM-019`: adding the aligned candidate field back to the aligned difference recovers
the reference field. -/
theorem alignedOperatorDifferenceField_add_alignedOperatorField
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) :
    alignedOperatorDifferenceField alignment reference candidate +
      alignedOperatorField alignment candidate = reference := by
  exact operatorFieldDifference_add_right _ _

/-- `BG-BLOCH-THM-020`: the aligned difference vanishes exactly when the reference equals the
pulled-back candidate field. -/
theorem alignedOperatorDifferenceField_eq_zero_iff
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) :
    alignedOperatorDifferenceField alignment reference candidate = 0 ↔
      reference = alignedOperatorField alignment candidate := by
  exact operatorFieldDifference_eq_zero_iff _ _

/-- `BG-BLOCH-THM-021`: pointwise subtraction preserves self-adjointness on a complete complex
inner-product space. -/
theorem operatorFieldDifference_selfAdjoint
    [CompleteSpace E]
    {reference candidate : K → E →L[ℂ] E}
    (href : ∀ k, IsSelfAdjoint (reference k))
    (hcand : ∀ k, IsSelfAdjoint (candidate k)) :
    ∀ k, IsSelfAdjoint (operatorFieldDifference reference candidate k) := by
  intro k
  exact (href k).sub (hcand k)

/-- `BG-BLOCH-THM-022`: pulling a pointwise self-adjoint candidate field back through a unitary
alignment preserves pointwise self-adjointness. -/
theorem alignedOperatorField_selfAdjoint
    [CompleteSpace Eref] [CompleteSpace Ecand]
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (candidate : K → Ecand →L[ℂ] Ecand)
    (hcand : ∀ k, IsSelfAdjoint (candidate k)) :
    ∀ k, IsSelfAdjoint (alignedOperatorField alignment candidate k) := by
  intro k
  simpa only [alignedOperatorField, LinearIsometryEquiv.coe_toContinuousLinearEquiv,
    LinearIsometryEquiv.coe_toLinearIsometry, LinearIsometry.coe_toContinuousLinearMap,
    ← (alignment k).adjoint_eq_symm, ContinuousLinearMap.comp_assoc] using
    (hcand k).adjoint_conj ((alignment k : Eref ≃ₗᵢ[ℂ] Ecand) : Eref →L[ℂ] Ecand)

/-- `BG-BLOCH-THM-023`: a pointwise self-adjoint reference minus a pointwise self-adjoint
unitarily pulled-back candidate is pointwise self-adjoint. -/
theorem alignedOperatorDifferenceField_selfAdjoint
    [CompleteSpace Eref] [CompleteSpace Ecand]
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand)
    (href : ∀ k, IsSelfAdjoint (reference k))
    (hcand : ∀ k, IsSelfAdjoint (candidate k)) :
    ∀ k, IsSelfAdjoint (alignedOperatorDifferenceField alignment reference candidate k) := by
  exact operatorFieldDifference_selfAdjoint href
    (alignedOperatorField_selfAdjoint alignment candidate hcand)

end ProjectKoios.BandGauge.Bloch

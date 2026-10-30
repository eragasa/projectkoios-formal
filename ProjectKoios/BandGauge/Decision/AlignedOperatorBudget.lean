/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Bloch.AlignedDifferenceBounds
public import ProjectKoios.BandGauge.Decision.FiniteCompatibility

/-!
# Finite aligned-operator budgets

This module turns the exact pointwise aligned-operator difference into a finite maximum
operator-norm loss and connects that loss to the generic finite compatibility schema. The
alignment carrier remains application supplied and may bundle additional common data; an explicit
projection supplies the pointwise unitary field used by the exact loss.

The stability results compare two reference/candidate pairs under one common alignment. They do
not compare different gauges, prove that an optimizer exists, authenticate runtime arrays, parse a
certificate, or establish spectral, continuum, physical, or scientific adequacy.
-/

@[expose] public section

open scoped ENNReal

namespace ProjectKoios.BandGauge.Decision

open Bloch

variable {Model Candidate Alignment Channel K Eref Ecand : Type*}
variable [Fintype K]
variable [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
variable [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand]

/-- `BG-DECISION-DEF-028`: finite maximum operator-norm loss of a reference field minus a
candidate field pulled back through one supplied pointwise unitary alignment. -/
noncomputable def finiteAlignedOperatorLoss
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) : ENNReal :=
  (‖alignedOperatorDifferenceField alignment reference candidate‖₊ : ENNReal)

/-- `BG-DECISION-DEF-029`: finite maximum perturbation radius for a pair of reference and
candidate operator fields. -/
noncomputable def finiteAlignedOperatorPerturbation
    (referenceLeft referenceRight : K → Eref →L[ℂ] Eref)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand) : ENNReal :=
  (‖referenceLeft - referenceRight‖₊ : ENNReal) +
    (‖candidateLeft - candidateRight‖₊ : ENNReal)

/-- `BG-DECISION-DEF-030`: exact finite aligned-operator data used to instantiate one generic
finite compatibility schema. The alignment carrier may contain more than the unitary field; the
`alignmentField` projection identifies the exact field used in the operator loss. -/
structure FiniteAlignedOperatorCompatibilityData
    (Model Candidate Alignment Channel K Eref Ecand : Type*)
    [Fintype K]
    [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
    [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand] where
  modelInventory : Finset Model
  candidateInventory : Model → Finset Candidate
  referenceField : Model → K → Eref →L[ℂ] Eref
  candidateField : Model → Candidate → K → Ecand →L[ℂ] Ecand
  alignmentFamily : Model → Candidate → Set Alignment
  alignmentField : Alignment → K → Eref ≃ₗᵢ[ℂ] Ecand
  spectralLoss : Model → Candidate → ENNReal
  spectralBudget : Model → ENNReal
  operatorBudget : Model → ENNReal
  channelInventory : Model → Finset Channel
  channelPasses : Model → Candidate → Alignment → Channel → Prop

namespace FiniteAlignedOperatorCompatibilityData

variable (data : FiniteAlignedOperatorCompatibilityData
  Model Candidate Alignment Channel K Eref Ecand)

/-- `BG-DECISION-DEF-031`: generic finite compatibility schema whose aligned-operator channel is
the exact finite maximum loss from `BG-DECISION-DEF-028`. -/
noncomputable def toFiniteCompatibilitySchema :
    FiniteCompatibilitySchema Model Candidate Alignment Channel where
  modelInventory := data.modelInventory
  candidateInventory := data.candidateInventory
  alignmentFamily := data.alignmentFamily
  spectralLoss := data.spectralLoss
  alignedOperatorLoss := fun model candidate alignment =>
    finiteAlignedOperatorLoss (data.alignmentField alignment)
      (data.referenceField model) (data.candidateField model candidate)
  spectralBudget := data.spectralBudget
  operatorBudget := data.operatorBudget
  channelInventory := data.channelInventory
  channelPasses := data.channelPasses

/-- `BG-DECISION-THM-039`: the concrete finite loss is the supremum of the pointwise
operator norms over the declared finite evaluation inventory. -/
theorem finiteAlignedOperatorLoss_eq_sup
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) :
    finiteAlignedOperatorLoss alignment reference candidate =
      ((Finset.univ.sup fun k : K =>
        ‖alignedOperatorDifferenceField alignment reference candidate k‖₊) : ENNReal) := by
  rw [finiteAlignedOperatorLoss, Pi.nnnorm_def]
  norm_cast

/-- `BG-DECISION-THM-040`: the concrete finite loss vanishes exactly when the reference field
is the candidate field pulled back through the supplied alignment. -/
theorem finiteAlignedOperatorLoss_eq_zero_iff
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) :
    finiteAlignedOperatorLoss alignment reference candidate = 0 ↔
      reference = alignedOperatorField alignment candidate := by
  rw [finiteAlignedOperatorLoss]
  simp only [ENNReal.coe_eq_zero, nnnorm_eq_zero]
  exact alignedOperatorDifferenceField_eq_zero_iff alignment reference candidate

/-- `BG-DECISION-THM-041`: unitary pullback preserves the exact finite maximum operator norm of
the whole candidate field. -/
theorem norm_alignedOperatorField_eq_finite
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (candidate : K → Ecand →L[ℂ] Ecand) :
    ‖alignedOperatorField alignment candidate‖ = ‖candidate‖ := by
  rw [Pi.norm_def, Pi.norm_def]
  congr 2
  funext k
  exact NNReal.eq (norm_alignedOperatorField_eq alignment candidate k)

/-- `BG-DECISION-THM-042`: the concrete finite aligned-operator loss is bounded by the finite
maximum norms of the reference and candidate fields. -/
theorem finiteAlignedOperatorLoss_le
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (reference : K → Eref →L[ℂ] Eref)
    (candidate : K → Ecand →L[ℂ] Ecand) :
    finiteAlignedOperatorLoss alignment reference candidate ≤
      (‖reference‖₊ : ENNReal) + (‖candidate‖₊ : ENNReal) := by
  rw [finiteAlignedOperatorLoss, ← ENNReal.coe_add]
  exact ENNReal.coe_le_coe.mpr <| by
    exact_mod_cast (norm_sub_le reference (alignedOperatorField alignment candidate)).trans_eq
      (congrArg (fun x : ℝ => ‖reference‖ + x)
        (norm_alignedOperatorField_eq_finite alignment candidate))

/-- `BG-DECISION-THM-043`: under one common alignment, the finite maximum norm of the change
between two aligned differences is bounded by the two input-field changes. -/
theorem norm_alignedOperatorDifferenceField_sub_le_finite
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (referenceLeft referenceRight : K → Eref →L[ℂ] Eref)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand) :
    ‖alignedOperatorDifferenceField alignment referenceLeft candidateLeft -
        alignedOperatorDifferenceField alignment referenceRight candidateRight‖ ≤
      ‖referenceLeft - referenceRight‖ + ‖candidateLeft - candidateRight‖ := by
  rw [Pi.norm_def, Pi.norm_def, Pi.norm_def]
  norm_cast
  apply Finset.sup_le
  intro k hk
  calc
    ‖(alignedOperatorDifferenceField alignment referenceLeft candidateLeft -
        alignedOperatorDifferenceField alignment referenceRight candidateRight) k‖₊ ≤
      ‖referenceLeft k - referenceRight k‖₊ +
        ‖candidateLeft k - candidateRight k‖₊ := by
      exact_mod_cast alignedOperatorDifferenceField_sub_norm_le alignment
        referenceLeft referenceRight candidateLeft candidateRight k
    _ ≤ (Finset.univ.sup fun k : K => ‖(referenceLeft - referenceRight) k‖₊) +
        (Finset.univ.sup fun k : K => ‖(candidateLeft - candidateRight) k‖₊) := by
      apply add_le_add
      · simpa only [Pi.sub_apply] using
          (Finset.le_sup (f := fun k : K => ‖(referenceLeft - referenceRight) k‖₊) hk)
      · simpa only [Pi.sub_apply] using
          (Finset.le_sup (f := fun k : K => ‖(candidateLeft - candidateRight) k‖₊) hk)

/-- `BG-DECISION-THM-044`: under one common alignment, the concrete finite loss is Lipschitz in
the pair of reference and candidate fields. -/
theorem finiteAlignedOperatorLoss_le_add_perturbation
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (referenceLeft referenceRight : K → Eref →L[ℂ] Eref)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand) :
    finiteAlignedOperatorLoss alignment referenceLeft candidateLeft ≤
      finiteAlignedOperatorLoss alignment referenceRight candidateRight +
        finiteAlignedOperatorPerturbation referenceLeft referenceRight
          candidateLeft candidateRight := by
  rw [finiteAlignedOperatorLoss, finiteAlignedOperatorLoss,
    finiteAlignedOperatorPerturbation, ← ENNReal.coe_add, ← ENNReal.coe_add]
  exact ENNReal.coe_le_coe.mpr <| by
    exact_mod_cast (show
      ‖alignedOperatorDifferenceField alignment referenceLeft candidateLeft‖ ≤
        ‖alignedOperatorDifferenceField alignment referenceRight candidateRight‖ +
          (‖referenceLeft - referenceRight‖ + ‖candidateLeft - candidateRight‖) from by
      calc
        ‖alignedOperatorDifferenceField alignment referenceLeft candidateLeft‖ ≤
            ‖alignedOperatorDifferenceField alignment referenceRight candidateRight‖ +
              ‖alignedOperatorDifferenceField alignment referenceLeft candidateLeft -
                alignedOperatorDifferenceField alignment referenceRight candidateRight‖ :=
          norm_le_norm_add_norm_sub' _ _
        _ ≤ ‖alignedOperatorDifferenceField alignment referenceRight candidateRight‖ +
            (‖referenceLeft - referenceRight‖ + ‖candidateLeft - candidateRight‖) :=
          add_le_add le_rfl
            (norm_alignedOperatorDifferenceField_sub_le_finite alignment
              referenceLeft referenceRight candidateLeft candidateRight))

/-- `BG-DECISION-THM-045`: a baseline loss plus its same-alignment perturbation radius below a
budget implies that the perturbed pair remains within that budget. -/
theorem finiteAlignedOperatorLoss_le_budget_of_stable
    (alignment : K → Eref ≃ₗᵢ[ℂ] Ecand)
    (referenceLeft referenceRight : K → Eref →L[ℂ] Eref)
    (candidateLeft candidateRight : K → Ecand →L[ℂ] Ecand)
    (budget : ENNReal)
    (hbudget : finiteAlignedOperatorLoss alignment referenceRight candidateRight +
      finiteAlignedOperatorPerturbation referenceLeft referenceRight
        candidateLeft candidateRight ≤ budget) :
    finiteAlignedOperatorLoss alignment referenceLeft candidateLeft ≤ budget := by
  exact (finiteAlignedOperatorLoss_le_add_perturbation alignment
    referenceLeft referenceRight candidateLeft candidateRight).trans hbudget

/-- `BG-DECISION-THM-046`: the schema adapter exposes exactly the concrete finite aligned-operator
loss, with no hidden optimizer or runtime conversion. -/
theorem toFiniteCompatibilitySchema_alignedOperatorLoss
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    data.toFiniteCompatibilitySchema.alignedOperatorLoss model candidate alignment =
      finiteAlignedOperatorLoss (data.alignmentField alignment)
        (data.referenceField model) (data.candidateField model candidate) := by
  rfl

/-- `BG-DECISION-THM-047`: family membership, the concrete operator budget, and all mandatory
channels construct one conformant operator witness for the adapted schema. -/
theorem conformantOperatorWitness_of_finiteAlignedOperatorLoss
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (hfamily : alignment ∈ data.alignmentFamily model candidate)
    (hbudget : finiteAlignedOperatorLoss (data.alignmentField alignment)
      (data.referenceField model) (data.candidateField model candidate) ≤
        data.operatorBudget model)
    (hchannels : ∀ channel ∈ data.channelInventory model,
      data.channelPasses model candidate alignment channel) :
    data.toFiniteCompatibilitySchema.ConformantOperatorWitness
      model candidate alignment := by
  exact ⟨hfamily, hbudget, hchannels⟩

/-- `BG-DECISION-THM-048`: a declared candidate with one concrete conformant alignment is
witness-accepted by the adapted compatibility schema. -/
theorem operatorWitnessAccepts_of_finiteAlignedOperatorLoss
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (hcandidate : candidate ∈ data.candidateInventory model)
    (hfamily : alignment ∈ data.alignmentFamily model candidate)
    (hbudget : finiteAlignedOperatorLoss (data.alignmentField alignment)
      (data.referenceField model) (data.candidateField model candidate) ≤
        data.operatorBudget model)
    (hchannels : ∀ channel ∈ data.channelInventory model,
      data.channelPasses model candidate alignment channel) :
    data.toFiniteCompatibilitySchema.OperatorWitnessAccepts model candidate := by
  exact ⟨hcandidate, alignment,
    data.conformantOperatorWitness_of_finiteAlignedOperatorLoss
      hfamily hbudget hchannels⟩

/-- `BG-DECISION-THM-049`: one concrete operator witness also establishes the central
alignment-infimum operator acceptance predicate. -/
theorem operatorAccepts_of_finiteAlignedOperatorLoss
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (hcandidate : candidate ∈ data.candidateInventory model)
    (hfamily : alignment ∈ data.alignmentFamily model candidate)
    (hbudget : finiteAlignedOperatorLoss (data.alignmentField alignment)
      (data.referenceField model) (data.candidateField model candidate) ≤
        data.operatorBudget model)
    (hchannels : ∀ channel ∈ data.channelInventory model,
      data.channelPasses model candidate alignment channel) :
    data.toFiniteCompatibilitySchema.OperatorAccepts model candidate := by
  exact data.toFiniteCompatibilitySchema.operatorAccepts_of_operatorWitnessAccepts
    (data.operatorWitnessAccepts_of_finiteAlignedOperatorLoss
      hcandidate hfamily hbudget hchannels)

/-- `BG-DECISION-THM-050`: one declared candidate satisfying the spectral budget and one common
concrete conformant alignment establishes witness compatibility for the adapted schema. -/
theorem witnessCompatible_of_finiteAlignedOperatorLoss
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (hcandidate : candidate ∈ data.candidateInventory model)
    (hspectral : data.spectralLoss model candidate ≤ data.spectralBudget model)
    (hfamily : alignment ∈ data.alignmentFamily model candidate)
    (hbudget : finiteAlignedOperatorLoss (data.alignmentField alignment)
      (data.referenceField model) (data.candidateField model candidate) ≤
        data.operatorBudget model)
    (hchannels : ∀ channel ∈ data.channelInventory model,
      data.channelPasses model candidate alignment channel) :
    data.toFiniteCompatibilitySchema.WitnessCompatible model := by
  exact ⟨candidate, ⟨hcandidate, hspectral⟩,
    data.operatorWitnessAccepts_of_finiteAlignedOperatorLoss
      hcandidate hfamily hbudget hchannels⟩

end FiniteAlignedOperatorCompatibilityData

end ProjectKoios.BandGauge.Decision

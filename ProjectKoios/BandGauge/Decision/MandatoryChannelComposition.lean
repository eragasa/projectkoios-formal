/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Decision.FourStageResidualBudgetSynthesis

/-!
# Compositional mandatory operator channels

Precise channel datasets can describe disjoint parts of one compatibility contract. This module
combines two such datasets with sum-tagged error channels and sum-tagged structural requirements.
The tags prevent identifier collisions, and joint acceptance is proved equivalent to acceptance of
both original datasets for one common model, candidate, and alignment.

The generic composition is lifted through the compatibility schema to alignment-channel
acceptance, conformant operator witnesses, operator-witness acceptance, and witness compatibility.
A narrow specialization extends the four-stage residual adapter with a consumer-supplied precise
channel dataset. Under explicit total headroom, its four-stage total channel remains derivable from
the three component channels, while every added error channel and structural requirement remains
mandatory at the same witness.

Composition does not establish that either input, or their combination, is complete for an external
study. Empty inventories remain vacuous. No runtime value, serialization, optimizer, source
artifact, enclosure, or certificate is authenticated.
-/

@[expose] public section

open scoped ENNReal

namespace ProjectKoios.BandGauge.Decision

variable {Model Candidate Alignment Channel I V : Type*}
variable {ErrorChannel₁ ErrorChannel₂ StructuralRequirement₁ StructuralRequirement₂ : Type*}

namespace FiniteMandatoryOperatorChannelData

/-- `BG-DECISION-DEF-051`: disjoint composition of two precise mandatory-channel datasets.
Error identifiers and structural identifiers are independently sum-tagged. -/
def combine
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂) :
    FiniteMandatoryOperatorChannelData Model Candidate Alignment
      (ErrorChannel₁ ⊕ ErrorChannel₂) (StructuralRequirement₁ ⊕ StructuralRequirement₂) where
  errorChannelInventory := fun model =>
    (left.errorChannelInventory model).disjSum (right.errorChannelInventory model)
  errorValue := fun model candidate alignment channel =>
    match channel with
    | .inl leftChannel => left.errorValue model candidate alignment leftChannel
    | .inr rightChannel => right.errorValue model candidate alignment rightChannel
  errorBudget := fun model channel =>
    match channel with
    | .inl leftChannel => left.errorBudget model leftChannel
    | .inr rightChannel => right.errorBudget model rightChannel
  structuralRequirementInventory := fun model =>
    (left.structuralRequirementInventory model).disjSum
      (right.structuralRequirementInventory model)
  structuralRequirementPasses := fun model candidate alignment requirement =>
    match requirement with
    | .inl leftRequirement =>
        left.structuralRequirementPasses model candidate alignment leftRequirement
    | .inr rightRequirement =>
        right.structuralRequirementPasses model candidate alignment rightRequirement

/-- `BG-DECISION-THM-073`: the combined error inventory is exactly the disjoint sum of the
two original error inventories. -/
theorem combine_errorChannelInventory
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) :
    (left.combine right).errorChannelInventory model =
      (left.errorChannelInventory model).disjSum (right.errorChannelInventory model) := by
  rfl

/-- `BG-DECISION-THM-074`: the combined structural inventory is exactly the disjoint sum of
the two original structural inventories. -/
theorem combine_structuralRequirementInventory
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) :
    (left.combine right).structuralRequirementInventory model =
      (left.structuralRequirementInventory model).disjSum
        (right.structuralRequirementInventory model) := by
  rfl

/-- `BG-DECISION-THM-075`: combined error-channel acceptance is equivalent to acceptance
of both original error-channel datasets for the same witness. -/
theorem combine_errorChannelsAccept_iff
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (left.combine right).ErrorChannelsAccept model candidate alignment ↔
      left.ErrorChannelsAccept model candidate alignment ∧
      right.ErrorChannelsAccept model candidate alignment := by
  simp [ErrorChannelsAccept, combine, Finset.mem_disjSum]

/-- `BG-DECISION-THM-076`: combined structural acceptance is equivalent to acceptance of
both original structural datasets for the same witness. -/
theorem combine_structuralRequirementsAccept_iff
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (left.combine right).StructuralRequirementsAccept model candidate alignment ↔
      left.StructuralRequirementsAccept model candidate alignment ∧
      right.StructuralRequirementsAccept model candidate alignment := by
  simp [StructuralRequirementsAccept, combine, Finset.mem_disjSum]

/-- `BG-DECISION-THM-077`: combined precise acceptance is equivalent to acceptance of both
original datasets at one common model, candidate, and alignment. -/
theorem combine_accepts_iff
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (left.combine right).Accepts model candidate alignment ↔
      left.Accepts model candidate alignment ∧ right.Accepts model candidate alignment := by
  rw [Accepts, combine_errorChannelsAccept_iff, combine_structuralRequirementsAccept_iff,
    Accepts, Accepts]
  tauto

end FiniteMandatoryOperatorChannelData

namespace FiniteCompatibilitySchema

/-- `BG-DECISION-THM-078`: adapting a schema with combined precise data makes generic
alignment-channel acceptance equivalent to acceptance of both original datasets. -/
theorem withCombinedMandatoryOperatorChannels_alignmentChannelsAccept_iff
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (schema.withMandatoryOperatorChannels (left.combine right)).AlignmentChannelsAccept
        model candidate alignment ↔
      left.Accepts model candidate alignment ∧ right.Accepts model candidate alignment := by
  rw [withMandatoryOperatorChannels_alignmentChannelsAccept_iff, left.combine_accepts_iff]

/-- `BG-DECISION-THM-079`: a conformant witness after channel composition is exactly an
original family alignment passing the original operator budget and both precise datasets. -/
theorem withCombinedMandatoryOperatorChannels_conformantOperatorWitness_iff
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (schema.withMandatoryOperatorChannels (left.combine right)).ConformantOperatorWitness
        model candidate alignment ↔
      alignment ∈ schema.alignmentFamily model candidate ∧
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
      left.Accepts model candidate alignment ∧ right.Accepts model candidate alignment := by
  change alignment ∈ schema.alignmentFamily model candidate ∧
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
      (schema.withMandatoryOperatorChannels (left.combine right)).AlignmentChannelsAccept
        model candidate alignment ↔ _
  rw [schema.withCombinedMandatoryOperatorChannels_alignmentChannelsAccept_iff]

/-- `BG-DECISION-THM-080`: operator-witness acceptance after channel composition is exactly
one declared candidate with one family alignment passing the operator budget and both datasets. -/
theorem withCombinedMandatoryOperatorChannels_operatorWitnessAccepts_iff
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) (candidate : Candidate) :
    (schema.withMandatoryOperatorChannels (left.combine right)).OperatorWitnessAccepts
        model candidate ↔
      candidate ∈ schema.candidateInventory model ∧
      ∃ alignment,
        alignment ∈ schema.alignmentFamily model candidate ∧
        schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
        left.Accepts model candidate alignment ∧ right.Accepts model candidate alignment := by
  change candidate ∈ schema.candidateInventory model ∧
      (∃ alignment,
        (schema.withMandatoryOperatorChannels (left.combine right)).ConformantOperatorWitness
          model candidate alignment) ↔ _
  simp only [schema.withCombinedMandatoryOperatorChannels_conformantOperatorWitness_iff]

/-- `BG-DECISION-THM-081`: witness compatibility after channel composition is exactly one
spectrally accepted candidate with one operator-budget alignment passing both datasets. -/
theorem withCombinedMandatoryOperatorChannels_witnessCompatible_iff
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (left : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₁ StructuralRequirement₁)
    (right : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel₂ StructuralRequirement₂)
    (model : Model) :
    (schema.withMandatoryOperatorChannels (left.combine right)).WitnessCompatible model ↔
      ∃ candidate,
        schema.SpectralAccepts model candidate ∧
        candidate ∈ schema.candidateInventory model ∧
        ∃ alignment,
          alignment ∈ schema.alignmentFamily model candidate ∧
          schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
          left.Accepts model candidate alignment ∧ right.Accepts model candidate alignment := by
  change (∃ candidate,
      schema.SpectralAccepts model candidate ∧
      (schema.withMandatoryOperatorChannels (left.combine right)).OperatorWitnessAccepts
        model candidate) ↔ _
  simp only [schema.withCombinedMandatoryOperatorChannels_operatorWitnessAccepts_iff]

end FiniteCompatibilitySchema

variable {ExtraErrorChannel ExtraStructuralRequirement : Type*}

/-- `BG-DECISION-DEF-052`: extend the narrow four-stage finite-maximum residual data with a
consumer-supplied precise error/structural dataset using disjoint tags. -/
noncomputable def extendedFourStageMaximumResidualChannelData
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (extra : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ExtraErrorChannel ExtraStructuralRequirement) :
    FiniteMandatoryOperatorChannelData Model Candidate Alignment
      (FourStageResidualErrorChannel ⊕ ExtraErrorChannel)
      (Empty ⊕ ExtraStructuralRequirement) :=
  (maximumFourStageResidualChannelData fields
    (fourStageResidualBudgetFunction budget)).combine extra

namespace FiniteCompatibilitySchema

variable (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)

/-- `BG-DECISION-DEF-053`: replace only a schema's generic channel fields with the
four-stage residual data composed with a consumer-supplied precise channel dataset. -/
noncomputable def withExtendedFourStageMaximumResidualChannels
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (extra : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ExtraErrorChannel ExtraStructuralRequirement) :
    FiniteCompatibilitySchema Model Candidate Alignment
      (MandatoryOperatorChannel
        (FourStageResidualErrorChannel ⊕ ExtraErrorChannel)
        (Empty ⊕ ExtraStructuralRequirement)) :=
  schema.withMandatoryOperatorChannels
    (extendedFourStageMaximumResidualChannelData fields budget extra)

end FiniteCompatibilitySchema

/-- `BG-DECISION-THM-082`: extended four-stage data accept exactly when the original
four-stage budget-record adapter and every supplied extra channel accept at the same witness. -/
theorem extendedFourStageMaximumResidualChannelData_accepts_iff
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (extra : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ExtraErrorChannel ExtraStructuralRequirement)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (extendedFourStageMaximumResidualChannelData fields budget extra).Accepts
        model candidate alignment ↔
      (maximumFourStageResidualChannelData fields
        (fourStageResidualBudgetFunction budget)).Accepts model candidate alignment ∧
      extra.Accepts model candidate alignment := by
  exact FiniteMandatoryOperatorChannelData.combine_accepts_iff _ _ _ _ _

/-- `BG-DECISION-THM-083`: under total headroom, extended four-stage acceptance is exactly
three-component residual passage together with every supplied extra error and structural channel. -/
theorem extendedFourStageMaximumResidualChannelData_accepts_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (extra : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ExtraErrorChannel ExtraStructuralRequirement)
    (model : Model) (candidate : Candidate) (alignment : Alignment)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (extendedFourStageMaximumResidualChannelData fields budget extra).Accepts
        model candidate alignment ↔
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation ∧
      extra.Accepts model candidate alignment := by
  rw [extendedFourStageMaximumResidualChannelData_accepts_iff,
    maximumFourStageResidualChannelData_budget_accepts_iff_components
      fields budget model candidate alignment hheadroom]
  tauto

namespace FiniteCompatibilitySchema

/-- `BG-DECISION-THM-084`: under total headroom, alignment-channel acceptance after the
extended adapter is exactly three-component residual passage plus every extra precise channel. -/
theorem withExtendedFourStageMaximumResidualChannels_alignmentChannelsAccept_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (extra : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ExtraErrorChannel ExtraStructuralRequirement)
    (model : Model) (candidate : Candidate) (alignment : Alignment)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (schema.withExtendedFourStageMaximumResidualChannels fields budget extra).AlignmentChannelsAccept
        model candidate alignment ↔
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation ∧
      extra.Accepts model candidate alignment := by
  rw [withExtendedFourStageMaximumResidualChannels,
    withMandatoryOperatorChannels_alignmentChannelsAccept_iff,
    extendedFourStageMaximumResidualChannelData_accepts_iff_components
      fields budget extra model candidate alignment hheadroom]

/-- `BG-DECISION-THM-085`: under total headroom, a conformant witness for the extended
adapter is exactly one original family alignment passing the original operator budget, the three
component residual budgets, and every extra precise channel. -/
theorem withExtendedFourStageMaximumResidualChannels_conformantOperatorWitness_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (extra : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ExtraErrorChannel ExtraStructuralRequirement)
    (model : Model) (candidate : Candidate) (alignment : Alignment)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (schema.withExtendedFourStageMaximumResidualChannels fields budget extra).ConformantOperatorWitness
        model candidate alignment ↔
      alignment ∈ schema.alignmentFamily model candidate ∧
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation ∧
      extra.Accepts model candidate alignment := by
  change alignment ∈ schema.alignmentFamily model candidate ∧
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
      (schema.withExtendedFourStageMaximumResidualChannels fields budget extra).AlignmentChannelsAccept
        model candidate alignment ↔ _
  rw [schema.withExtendedFourStageMaximumResidualChannels_alignmentChannelsAccept_iff_components
    fields budget extra model candidate alignment hheadroom]

/-- `BG-DECISION-THM-086`: under total headroom, witness compatibility for the extended
adapter is exactly one unchanged spectral candidate with one operator-budget alignment passing
the three component residual budgets and every extra precise channel. -/
theorem withExtendedFourStageMaximumResidualChannels_witnessCompatible_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (extra : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ExtraErrorChannel ExtraStructuralRequirement)
    (model : Model)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (schema.withExtendedFourStageMaximumResidualChannels fields budget extra).WitnessCompatible
        model ↔
      ∃ candidate,
        schema.SpectralAccepts model candidate ∧
        candidate ∈ schema.candidateInventory model ∧
        ∃ alignment,
          alignment ∈ schema.alignmentFamily model candidate ∧
          schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
          fourStageMaximumErrorValue .interpolation
              (fields model candidate alignment) ≤ (budget model).interpolation ∧
          fourStageMaximumErrorValue .conversion
              (fields model candidate alignment) ≤ (budget model).conversion ∧
          fourStageMaximumErrorValue .truncation
              (fields model candidate alignment) ≤ (budget model).truncation ∧
          extra.Accepts model candidate alignment := by
  change (∃ candidate,
      schema.SpectralAccepts model candidate ∧
      candidate ∈ schema.candidateInventory model ∧
      ∃ alignment,
        (schema.withExtendedFourStageMaximumResidualChannels fields budget extra).ConformantOperatorWitness
          model candidate alignment) ↔ _
  simp only [schema.withExtendedFourStageMaximumResidualChannels_conformantOperatorWitness_iff_components
    fields budget extra model _ _ hheadroom]

end FiniteCompatibilitySchema

end ProjectKoios.BandGauge.Decision

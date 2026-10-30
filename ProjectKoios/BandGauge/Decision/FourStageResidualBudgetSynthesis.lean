/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Decision.FourStageResidualChannels

/-!
# Four-stage residual budget synthesis and compatibility

This module packages exact upper budgets for interpolation, conversion, deliberate truncation,
and total finite-maximum residual channels. An explicit total-headroom premise says that the sum
of the three component budgets lies below the total budget. Under that premise, passage of the
three component channels implies passage of the total channel, so the total-channel check is
mathematically redundant for the same model, candidate, alignment, fields, and exact budgets.

A compatibility-schema adapter replaces only the generic channel fields with the narrow
four-stage residual data. The resulting theorems expose alignment-channel acceptance,
conformant operator witnesses, operator-witness acceptance, and witness compatibility without
changing the original model inventories, candidate inventories, alignment families, losses, or
central budgets.

Total headroom is an explicit sufficient condition, not an inferred runtime property. The module
does not supply structural requirements, claim that the four channels exhaust an external error
ledger, or authenticate any interpolation, conversion, truncation, optimizer, mesh, floating-point
value, source artifact, or runtime execution.
-/

@[expose] public section

open scoped ENNReal

namespace ProjectKoios.BandGauge.Decision

variable {Model Candidate Alignment Channel I V : Type*}

/-- `BG-DECISION-DEF-045`: exact upper budgets for the four named finite-maximum residual
channels. These fields do not assert that any value passes its budget. -/
structure FourStageResidualBudget where
  interpolation : ENNReal
  conversion : ENNReal
  truncation : ENNReal
  total : ENNReal

namespace FourStageResidualBudget

/-- `BG-DECISION-DEF-046`: sum of the interpolation, conversion, and deliberate-truncation
upper budgets. This is a budget sum, not an equality of scalar residual summaries. -/
def componentSum (budget : FourStageResidualBudget) : ENNReal :=
  budget.interpolation + budget.conversion + budget.truncation

/-- `BG-DECISION-DEF-047`: explicit total-channel headroom. The total upper budget is at
least the sum of the three component upper budgets. -/
def HasTotalHeadroom (budget : FourStageResidualBudget) : Prop :=
  budget.componentSum ≤ budget.total

/-- `BG-DECISION-DEF-048`: select the exact upper budget for one named residual channel. -/
def channelBudget (budget : FourStageResidualBudget) :
    FourStageResidualErrorChannel → ENNReal
  | .interpolation => budget.interpolation
  | .conversion => budget.conversion
  | .truncation => budget.truncation
  | .total => budget.total

end FourStageResidualBudget

/-- `BG-DECISION-DEF-049`: model-indexed channel-budget function supplied by exact
four-stage residual budget records. -/
def fourStageResidualBudgetFunction
    (budget : Model → FourStageResidualBudget) :
    Model → FourStageResidualErrorChannel → ENNReal :=
  fun model channel => (budget model).channelBudget channel

namespace FiniteCompatibilitySchema

variable (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)

/-- `BG-DECISION-DEF-050`: replace only the generic channel fields of a compatibility schema
with the narrow four-stage finite-maximum residual adapter. The structural inventory is empty. -/
noncomputable def withFourStageMaximumResidualChannels
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget) :
    FiniteCompatibilitySchema Model Candidate Alignment
      (MandatoryOperatorChannel FourStageResidualErrorChannel Empty) :=
  schema.withMandatoryOperatorChannels
    (maximumFourStageResidualChannelData fields
      (fourStageResidualBudgetFunction budget))

end FiniteCompatibilitySchema

/-- `BG-DECISION-THM-065`: component-channel passage plus explicit total headroom implies
total-channel passage for the same fields and exact budget record. -/
theorem fourStageMaximumErrorValue_total_le_budget_of_components
    [Fintype I] [NormedAddCommGroup V]
    (fields : Hilbert.FourStageResidualFields I V)
    (budget : FourStageResidualBudget)
    (hinterpolation : fourStageMaximumErrorValue .interpolation fields ≤ budget.interpolation)
    (hconversion : fourStageMaximumErrorValue .conversion fields ≤ budget.conversion)
    (htruncation : fourStageMaximumErrorValue .truncation fields ≤ budget.truncation)
    (hheadroom : budget.HasTotalHeadroom) :
    fourStageMaximumErrorValue .total fields ≤ budget.total := by
  calc
    fourStageMaximumErrorValue .total fields ≤
        fourStageMaximumErrorValue .interpolation fields +
          fourStageMaximumErrorValue .conversion fields +
            fourStageMaximumErrorValue .truncation fields :=
      fourStageMaximumErrorValue_total_le fields
    _ ≤ budget.interpolation + budget.conversion + budget.truncation :=
      add_le_add (add_le_add hinterpolation hconversion) htruncation
    _ = budget.componentSum := rfl
    _ ≤ budget.total := hheadroom

/-- `BG-DECISION-THM-066`: the budget-record specialization of the narrow adapter accepts
exactly when all four finite-maximum channel values pass their selected upper budgets. -/
theorem maximumFourStageResidualChannelData_budget_accepts_iff
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (maximumFourStageResidualChannelData fields
      (fourStageResidualBudgetFunction budget)).Accepts model candidate alignment ↔
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation ∧
      fourStageMaximumErrorValue .total
          (fields model candidate alignment) ≤ (budget model).total := by
  simpa [fourStageResidualBudgetFunction, FourStageResidualBudget.channelBudget] using
    (maximumFourStageResidualChannelData_accepts_iff fields
      (fourStageResidualBudgetFunction budget) model candidate alignment)

/-- `BG-DECISION-THM-067`: under explicit total headroom, the narrow adapter accepts iff
the three component channels pass. The total channel is redundant only under this premise. -/
theorem maximumFourStageResidualChannelData_budget_accepts_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (model : Model) (candidate : Candidate) (alignment : Alignment)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (maximumFourStageResidualChannelData fields
      (fourStageResidualBudgetFunction budget)).Accepts model candidate alignment ↔
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation := by
  rw [maximumFourStageResidualChannelData_budget_accepts_iff]
  constructor
  · exact fun h => ⟨h.1, h.2.1, h.2.2.1⟩
  · rintro ⟨hinterpolation, hconversion, htruncation⟩
    exact ⟨hinterpolation, hconversion, htruncation,
      fourStageMaximumErrorValue_total_le_budget_of_components
        (fields model candidate alignment) (budget model)
        hinterpolation hconversion htruncation hheadroom⟩

namespace FiniteCompatibilitySchema

/-- `BG-DECISION-THM-068`: after the four-stage adapter, generic alignment-channel
acceptance means exactly that all four residual values pass their exact budget-record fields. -/
theorem withFourStageMaximumResidualChannels_alignmentChannelsAccept_iff
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (schema.withFourStageMaximumResidualChannels fields budget).AlignmentChannelsAccept
        model candidate alignment ↔
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation ∧
      fourStageMaximumErrorValue .total
          (fields model candidate alignment) ≤ (budget model).total := by
  rw [withFourStageMaximumResidualChannels,
    withMandatoryOperatorChannels_alignmentChannelsAccept_iff,
    maximumFourStageResidualChannelData_budget_accepts_iff]

/-- `BG-DECISION-THM-069`: under total headroom, adapted alignment-channel acceptance is
equivalent to passage of the three component channels for the same alignment. -/
theorem withFourStageMaximumResidualChannels_alignmentChannelsAccept_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (model : Model) (candidate : Candidate) (alignment : Alignment)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (schema.withFourStageMaximumResidualChannels fields budget).AlignmentChannelsAccept
        model candidate alignment ↔
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation := by
  rw [withFourStageMaximumResidualChannels,
    withMandatoryOperatorChannels_alignmentChannelsAccept_iff,
    maximumFourStageResidualChannelData_budget_accepts_iff_components
      fields budget model candidate alignment hheadroom]

/-- `BG-DECISION-THM-070`: under total headroom, a conformant operator witness for the
adapted schema is exactly an alignment-family member that passes the central operator budget
and all three component residual budgets. -/
theorem withFourStageMaximumResidualChannels_conformantOperatorWitness_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (model : Model) (candidate : Candidate) (alignment : Alignment)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (schema.withFourStageMaximumResidualChannels fields budget).ConformantOperatorWitness
        model candidate alignment ↔
      alignment ∈ schema.alignmentFamily model candidate ∧
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ (budget model).interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ (budget model).conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ (budget model).truncation := by
  change alignment ∈ schema.alignmentFamily model candidate ∧
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
      (schema.withFourStageMaximumResidualChannels fields budget).AlignmentChannelsAccept
        model candidate alignment ↔ _
  rw [schema.withFourStageMaximumResidualChannels_alignmentChannelsAccept_iff_components
    fields budget model candidate alignment hheadroom]

/-- `BG-DECISION-THM-071`: under total headroom, adapted operator-witness acceptance means
that one declared candidate has one family alignment passing the central operator budget and all
three component residual budgets. -/
theorem withFourStageMaximumResidualChannels_operatorWitnessAccepts_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (model : Model) (candidate : Candidate)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (schema.withFourStageMaximumResidualChannels fields budget).OperatorWitnessAccepts
        model candidate ↔
      candidate ∈ schema.candidateInventory model ∧
      ∃ alignment,
        alignment ∈ schema.alignmentFamily model candidate ∧
        schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
        fourStageMaximumErrorValue .interpolation
            (fields model candidate alignment) ≤ (budget model).interpolation ∧
        fourStageMaximumErrorValue .conversion
            (fields model candidate alignment) ≤ (budget model).conversion ∧
        fourStageMaximumErrorValue .truncation
            (fields model candidate alignment) ≤ (budget model).truncation := by
  change candidate ∈ schema.candidateInventory model ∧
      (∃ alignment,
        (schema.withFourStageMaximumResidualChannels fields budget).ConformantOperatorWitness
          model candidate alignment) ↔ _
  simp only [schema.withFourStageMaximumResidualChannels_conformantOperatorWitness_iff_components
    fields budget model candidate _ hheadroom]

/-- `BG-DECISION-THM-072`: under model-wise total headroom, witness compatibility for the
adapted schema is exactly a common candidate that passes the unchanged spectral criterion and
has one alignment passing the unchanged operator budget plus all three component residual
budgets. -/
theorem withFourStageMaximumResidualChannels_witnessCompatible_iff_components
    [Fintype I] [NormedAddCommGroup V]
    (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualBudget)
    (model : Model)
    (hheadroom : (budget model).HasTotalHeadroom) :
    (schema.withFourStageMaximumResidualChannels fields budget).WitnessCompatible model ↔
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
              (fields model candidate alignment) ≤ (budget model).truncation := by
  change (∃ candidate,
      schema.SpectralAccepts model candidate ∧
      (schema.withFourStageMaximumResidualChannels fields budget).OperatorWitnessAccepts
        model candidate) ↔ _
  simp only [schema.withFourStageMaximumResidualChannels_operatorWitnessAccepts_iff_components
    fields budget model _ hheadroom]

end FiniteCompatibilitySchema

end ProjectKoios.BandGauge.Decision

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Decision.OperatorChannels
public import ProjectKoios.BandGauge.Hilbert.FourStageResidualChannels

/-!
# Four-stage residual error channels

This module gives the source-neutral four-stage residual ledger a precise finite error-channel
inventory. The named channels are interpolation, conversion, deliberate truncation, and total.
Their exact finite-maximum values instantiate the upper-bounded error branch of
`FiniteMandatoryOperatorChannelData`; the structural-requirement inventory is empty in this
narrow adapter.

The total residual field is the exact sum of the three component fields, while its scalar maximum
is only bounded by the sum of the three component maxima. The adapter does not claim that a
consumer's broader error ledger is exhausted by these four channels.
-/

@[expose] public section

open scoped ENNReal

namespace ProjectKoios.BandGauge.Decision

variable {Model Candidate Alignment I V : Type*}

/-- `BG-DECISION-DEF-041`: named source-neutral residual error channels for the four-stage
reference/interpolation/conversion/deliberate-truncation ledger. -/
inductive FourStageResidualErrorChannel where
  | interpolation
  | conversion
  | truncation
  | total
  deriving DecidableEq

instance : Fintype FourStageResidualErrorChannel where
  elems := {.interpolation, .conversion, .truncation, .total}
  complete channel := by cases channel <;> simp

/-- `BG-DECISION-DEF-042`: select the exact residual field represented by one named
four-stage error channel. -/
def fourStageResidualField [Sub V]
    (channel : FourStageResidualErrorChannel)
    (fields : Hilbert.FourStageResidualFields I V) : Hilbert.FiniteResidualField I V :=
  match channel with
  | .interpolation =>
      Hilbert.interpolationResidual fields.reference fields.interpolated
  | .conversion =>
      Hilbert.conversionResidual fields.interpolated fields.converted
  | .truncation =>
      Hilbert.truncationResidual fields.converted fields.truncated
  | .total =>
      Hilbert.totalResidual fields.reference fields.truncated

/-- `BG-DECISION-DEF-043`: exact finite-maximum norm value of one named four-stage residual
error channel, embedded into the extended nonnegative reals. -/
noncomputable def fourStageMaximumErrorValue [Fintype I] [NormedAddCommGroup V]
    (channel : FourStageResidualErrorChannel)
    (fields : Hilbert.FourStageResidualFields I V) : ENNReal :=
  (‖fourStageResidualField channel fields‖₊ : ENNReal)

/-- `BG-DECISION-DEF-044`: precise finite mandatory-channel data for the four named
finite-maximum residual errors. The structural-requirement inventory is empty; a consumer may
supply additional requirements in a broader adapter. -/
noncomputable def maximumFourStageResidualChannelData
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualErrorChannel → ENNReal) :
    FiniteMandatoryOperatorChannelData Model Candidate Alignment
      FourStageResidualErrorChannel Empty where
  errorChannelInventory := fun _ => Finset.univ
  errorValue := fun model candidate alignment channel =>
    fourStageMaximumErrorValue channel (fields model candidate alignment)
  errorBudget := budget
  structuralRequirementInventory := fun _ => ∅
  structuralRequirementPasses := fun _ _ _ requirement => nomatch requirement

/-- `BG-DECISION-THM-061`: the finite-maximum total residual error is bounded by the sum
of the interpolation, conversion, and deliberate-truncation channel values. -/
theorem fourStageMaximumErrorValue_total_le
    [Fintype I] [NormedAddCommGroup V]
    (fields : Hilbert.FourStageResidualFields I V) :
    fourStageMaximumErrorValue .total fields ≤
      fourStageMaximumErrorValue .interpolation fields +
        fourStageMaximumErrorValue .conversion fields +
          fourStageMaximumErrorValue .truncation fields := by
  rw [fourStageMaximumErrorValue, fourStageMaximumErrorValue,
    fourStageMaximumErrorValue, fourStageMaximumErrorValue,
    fourStageResidualField, fourStageResidualField,
    fourStageResidualField, fourStageResidualField,
    ← ENNReal.coe_add, ← ENNReal.coe_add]
  exact_mod_cast Hilbert.finiteMaximumNorm_totalResidual_le_three fields

/-- `BG-DECISION-THM-062`: the narrow four-stage adapter declares exactly all four named
error channels for every model class. -/
theorem maximumFourStageResidualChannelData_errorInventory
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualErrorChannel → ENNReal)
    (model : Model) :
    (maximumFourStageResidualChannelData fields budget).errorChannelInventory model =
      Finset.univ := by
  rfl

/-- `BG-DECISION-THM-063`: acceptance by the narrow four-stage adapter means exactly that
all four named finite-maximum residual values lie below their channel-specific budgets. -/
theorem maximumFourStageResidualChannelData_accepts_iff
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget : Model → FourStageResidualErrorChannel → ENNReal)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (maximumFourStageResidualChannelData fields budget).Accepts
        model candidate alignment ↔
      fourStageMaximumErrorValue .interpolation
          (fields model candidate alignment) ≤ budget model .interpolation ∧
      fourStageMaximumErrorValue .conversion
          (fields model candidate alignment) ≤ budget model .conversion ∧
      fourStageMaximumErrorValue .truncation
          (fields model candidate alignment) ≤ budget model .truncation ∧
      fourStageMaximumErrorValue .total
          (fields model candidate alignment) ≤ budget model .total := by
  rw [FiniteMandatoryOperatorChannelData.Accepts]
  constructor
  · rintro ⟨herrors, _⟩
    have h (channel : FourStageResidualErrorChannel) :
        fourStageMaximumErrorValue channel (fields model candidate alignment) ≤
          budget model channel := by
      exact herrors channel (by simp [maximumFourStageResidualChannelData])
    exact ⟨h .interpolation, h .conversion, h .truncation, h .total⟩
  · rintro ⟨hinterpolation, hconversion, htruncation, htotal⟩
    constructor
    · intro channel _
      change fourStageMaximumErrorValue channel (fields model candidate alignment) ≤
        budget model channel
      cases channel with
      | interpolation => exact hinterpolation
      | conversion => exact hconversion
      | truncation => exact htruncation
      | total => exact htotal
    · intro requirement hmem
      simp [maximumFourStageResidualChannelData] at hmem

/-- `BG-DECISION-THM-064`: relaxing every channel-specific upper budget preserves
four-stage residual-channel acceptance for the same model, candidate, and alignment. -/
theorem maximumFourStageResidualChannelData_accepts_mono_budget
    [Fintype I] [NormedAddCommGroup V]
    (fields : Model → Candidate → Alignment → Hilbert.FourStageResidualFields I V)
    (budget relaxedBudget : Model → FourStageResidualErrorChannel → ENNReal)
    (model : Model) (candidate : Candidate) (alignment : Alignment)
    (hbudget : ∀ channel, budget model channel ≤ relaxedBudget model channel)
    (haccepts : (maximumFourStageResidualChannelData fields budget).Accepts
      model candidate alignment) :
    (maximumFourStageResidualChannelData fields relaxedBudget).Accepts
      model candidate alignment := by
  rw [maximumFourStageResidualChannelData_accepts_iff] at haccepts ⊢
  exact ⟨haccepts.1.trans (hbudget .interpolation),
    haccepts.2.1.trans (hbudget .conversion),
    haccepts.2.2.1.trans (hbudget .truncation),
    haccepts.2.2.2.trans (hbudget .total)⟩

end ProjectKoios.BandGauge.Decision

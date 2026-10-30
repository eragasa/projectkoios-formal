/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Decision.OperatorChannels

/-!
# Finite alignment-family attainment

A nonempty finite alignment family has an exact aligned-operator loss minimizer. This module
uses that elementary finite-order fact to convert the generic compatibility schema's
infimum-based operator passage into a concrete budget-feasible alignment.

Finiteness alone does not establish the mandatory channel predicates. The final witness and
compatibility bridges therefore retain a separate hypothesis that every attaining alignment
passes all mandatory channels. No alignment is selected by a runtime optimizer, and no
floating-point or certificate boundary is introduced.
-/

@[expose] public section

open Set
open scoped ENNReal

namespace ProjectKoios.BandGauge.Decision

variable {Model Candidate Alignment Channel : Type*}

namespace FiniteCompatibilitySchema

variable (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)

/-- `BG-DECISION-DEF-032`: every exact aligned-operator loss minimizer in one declared
alignment family passes all mandatory channels. This is a channel-conformance hypothesis,
not a consequence of finiteness or minimization. -/
def AttainingAlignmentsAcceptChannels (model : Model) (candidate : Candidate) : Prop :=
  ∀ alignment, schema.AttainsAlignedOperatorLoss model candidate alignment →
    schema.AlignmentChannelsAccept model candidate alignment

/-- `BG-DECISION-THM-051`: a nonempty finite alignment family has an exact minimizer of
the aligned-operator loss. -/
theorem exists_attainsAlignedOperatorLoss_of_finite
    {model : Model} {candidate : Candidate}
    (hfinite : (schema.alignmentFamily model candidate).Finite)
    (hnonempty : (schema.alignmentFamily model candidate).Nonempty) :
    ∃ alignment, schema.AttainsAlignedOperatorLoss model candidate alignment := by
  obtain ⟨alignment, hmem, hmin⟩ :=
    Set.exists_min_image
      (schema.alignmentFamily model candidate)
      (schema.alignedOperatorLoss model candidate)
      hfinite hnonempty
  exact ⟨alignment, hmem, hmin⟩

/-- `BG-DECISION-THM-052`: on a nonempty finite alignment family, infimum-based operator
passage is equivalent to existence of a concrete budget-feasible alignment. Mandatory
channels are not inferred. -/
theorem alignedOperatorInfimumPasses_iff_exists_of_finite
    {model : Model} {candidate : Candidate}
    (hfinite : (schema.alignmentFamily model candidate).Finite)
    (hnonempty : (schema.alignmentFamily model candidate).Nonempty) :
    schema.AlignedOperatorInfimumPasses model candidate ↔
      ∃ alignment ∈ schema.alignmentFamily model candidate,
        schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model := by
  obtain ⟨alignment, hattains⟩ :=
    schema.exists_attainsAlignedOperatorLoss_of_finite hfinite hnonempty
  exact schema.alignedOperatorInfimumPasses_iff_exists_of_attains hattains

/-- `BG-DECISION-THM-053`: central operator acceptance with a finite alignment family
supplies a concrete budget-feasible alignment. The family nonemptiness used here remains an
explicit field of central operator acceptance. -/
theorem exists_budgetAlignment_of_operatorAccepts_of_finite
    {model : Model} {candidate : Candidate}
    (hfinite : (schema.alignmentFamily model candidate).Finite)
    (haccepts : schema.OperatorAccepts model candidate) :
    ∃ alignment ∈ schema.alignmentFamily model candidate,
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model := by
  exact (schema.alignedOperatorInfimumPasses_iff_exists_of_finite
    hfinite haccepts.2.1).1 haccepts.2.2

/-- `BG-DECISION-THM-054`: finite-family attainment converts central operator acceptance
to witness-based operator acceptance when exact minimizers separately satisfy every mandatory
channel. -/
theorem operatorWitnessAccepts_of_operatorAccepts_of_finite
    {model : Model} {candidate : Candidate}
    (hfinite : (schema.alignmentFamily model candidate).Finite)
    (hchannels : schema.AttainingAlignmentsAcceptChannels model candidate)
    (haccepts : schema.OperatorAccepts model candidate) :
    schema.OperatorWitnessAccepts model candidate := by
  obtain ⟨alignment, hattains⟩ :=
    schema.exists_attainsAlignedOperatorLoss_of_finite hfinite haccepts.2.1
  exact schema.operatorWitnessAccepts_of_operatorAccepts_of_attains
    haccepts hattains (hchannels alignment hattains)

/-- `BG-DECISION-THM-055`: central compatibility becomes witness compatibility when every
declared candidate has a finite alignment family and its exact minimizers satisfy all mandatory
channels. Only the common candidate supplied by central compatibility is used. -/
theorem witnessCompatible_of_compatible_of_finite
    {model : Model}
    (hfinite : ∀ candidate ∈ schema.candidateInventory model,
      (schema.alignmentFamily model candidate).Finite)
    (hchannels : ∀ candidate ∈ schema.candidateInventory model,
      schema.AttainingAlignmentsAcceptChannels model candidate)
    (hcompatible : schema.Compatible model) :
    schema.WitnessCompatible model := by
  obtain ⟨candidate, hspectral, hoperator⟩ := hcompatible
  exact ⟨candidate, hspectral,
    schema.operatorWitnessAccepts_of_operatorAccepts_of_finite
      (hfinite candidate hoperator.1)
      (hchannels candidate hoperator.1)
      hoperator⟩

/-- `BG-DECISION-THM-056`: under finite alignment families and explicit mandatory-channel
conformance of every exact minimizer, central and witness compatibility are equivalent. The
reverse implication is the generic witness-to-central theorem and does not need finiteness. -/
theorem compatible_iff_witnessCompatible_of_finite
    {model : Model}
    (hfinite : ∀ candidate ∈ schema.candidateInventory model,
      (schema.alignmentFamily model candidate).Finite)
    (hchannels : ∀ candidate ∈ schema.candidateInventory model,
      schema.AttainingAlignmentsAcceptChannels model candidate) :
    schema.Compatible model ↔ schema.WitnessCompatible model := by
  constructor
  · exact schema.witnessCompatible_of_compatible_of_finite hfinite hchannels
  · exact schema.compatible_of_witnessCompatible

end FiniteCompatibilitySchema

end ProjectKoios.BandGauge.Decision

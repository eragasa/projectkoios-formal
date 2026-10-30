/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Decision.FiniteCompatibility

/-!
# Precise mandatory operator channels

The generic compatibility schema permits an arbitrary mandatory channel predicate. This module
separates two meanings that must not be conflated:

- an error channel has an exact extended-nonnegative value and its own exact upper budget;
- a structural requirement is a nonnumeric proposition about the same model, candidate, and
  alignment.

Joint acceptance requires every declared error inequality and every declared structural
requirement to hold for one common candidate and one common alignment. A tagged adapter replaces
the generic channel fields of an existing compatibility schema without changing its model,
candidate, family, loss, or budget data.

The definitions do not choose a study-specific error decomposition, authenticate runtime values,
or assert that residual summaries add. Empty error or structural inventories are vacuous by
design and therefore must not be mistaken for external coverage.
-/

@[expose] public section

open scoped ENNReal

namespace ProjectKoios.BandGauge.Decision

variable {Model Candidate Alignment Channel ErrorChannel StructuralRequirement : Type*}

/-- `BG-DECISION-DEF-033`: tagged mandatory operator channel. The left branch is an exact
upper-bounded error channel; the right branch is a nonnumeric structural requirement. -/
abbrev MandatoryOperatorChannel (ErrorChannel StructuralRequirement : Type*) :=
  ErrorChannel ⊕ StructuralRequirement

/-- `BG-DECISION-DEF-034`: finite exact error-channel and structural-requirement data for
one compatibility query. Every error channel has its own value and upper budget. -/
structure FiniteMandatoryOperatorChannelData
    (Model Candidate Alignment ErrorChannel StructuralRequirement : Type*) where
  errorChannelInventory : Model → Finset ErrorChannel
  errorValue : Model → Candidate → Alignment → ErrorChannel → ENNReal
  errorBudget : Model → ErrorChannel → ENNReal
  structuralRequirementInventory : Model → Finset StructuralRequirement
  structuralRequirementPasses :
    Model → Candidate → Alignment → StructuralRequirement → Prop

namespace FiniteMandatoryOperatorChannelData

variable (data : FiniteMandatoryOperatorChannelData
  Model Candidate Alignment ErrorChannel StructuralRequirement)

/-- `BG-DECISION-DEF-035`: every declared error value for the same candidate and alignment
lies below its channel-specific upper budget. -/
def ErrorChannelsAccept (model : Model) (candidate : Candidate) (alignment : Alignment) : Prop :=
  ∀ channel ∈ data.errorChannelInventory model,
    data.errorValue model candidate alignment channel ≤ data.errorBudget model channel

/-- `BG-DECISION-DEF-036`: every declared nonnumeric structural requirement accepts the
same candidate and alignment. -/
def StructuralRequirementsAccept
    (model : Model) (candidate : Candidate) (alignment : Alignment) : Prop :=
  ∀ requirement ∈ data.structuralRequirementInventory model,
    data.structuralRequirementPasses model candidate alignment requirement

/-- `BG-DECISION-DEF-037`: joint mandatory-channel acceptance combines all exact error
inequalities and all structural requirements at one common candidate and alignment. -/
def Accepts (model : Model) (candidate : Candidate) (alignment : Alignment) : Prop :=
  data.ErrorChannelsAccept model candidate alignment ∧
    data.StructuralRequirementsAccept model candidate alignment

/-- `BG-DECISION-DEF-038`: tagged finite channel inventory used by the generic compatibility
schema. Error and structural identifiers remain in disjoint branches. -/
def channelInventory (model : Model) :
    Finset (MandatoryOperatorChannel ErrorChannel StructuralRequirement) :=
  (data.errorChannelInventory model).disjSum
    (data.structuralRequirementInventory model)

/-- `BG-DECISION-DEF-039`: tagged channel passage. Error channels mean exactly
`errorValue ≤ errorBudget`; structural requirements retain their supplied proposition. -/
def channelPasses (model : Model) (candidate : Candidate) (alignment : Alignment) :
    MandatoryOperatorChannel ErrorChannel StructuralRequirement → Prop
  | .inl channel =>
      data.errorValue model candidate alignment channel ≤ data.errorBudget model channel
  | .inr requirement =>
      data.structuralRequirementPasses model candidate alignment requirement

/-- `BG-DECISION-THM-057`: the tagged error branch means exactly its channel-specific upper
error inequality. -/
theorem channelPasses_error (model : Model) (candidate : Candidate)
    (alignment : Alignment) (channel : ErrorChannel) :
    data.channelPasses model candidate alignment (.inl channel) ↔
      data.errorValue model candidate alignment channel ≤ data.errorBudget model channel := by
  rfl

/-- `BG-DECISION-THM-058`: the tagged structural branch means exactly its supplied
nonnumeric requirement proposition. -/
theorem channelPasses_structural (model : Model) (candidate : Candidate)
    (alignment : Alignment) (requirement : StructuralRequirement) :
    data.channelPasses model candidate alignment (.inr requirement) ↔
      data.structuralRequirementPasses model candidate alignment requirement := by
  rfl

/-- `BG-DECISION-THM-059`: the tagged generic-channel universal predicate is equivalent to
all exact error inequalities together with all structural requirements. -/
theorem accepts_iff_tagged_channels
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    data.Accepts model candidate alignment ↔
      ∀ channel ∈ data.channelInventory model,
        data.channelPasses model candidate alignment channel := by
  simp [Accepts, ErrorChannelsAccept, StructuralRequirementsAccept,
    channelInventory, channelPasses, Finset.mem_disjSum]

end FiniteMandatoryOperatorChannelData

namespace FiniteCompatibilitySchema

variable (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)

/-- `BG-DECISION-DEF-040`: replace only the generic channel fields of a compatibility schema
with precisely tagged error channels and structural requirements. All other data are preserved. -/
def withMandatoryOperatorChannels
    (data : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel StructuralRequirement) :
    FiniteCompatibilitySchema Model Candidate Alignment
      (MandatoryOperatorChannel ErrorChannel StructuralRequirement) where
  modelInventory := schema.modelInventory
  candidateInventory := schema.candidateInventory
  alignmentFamily := schema.alignmentFamily
  spectralLoss := schema.spectralLoss
  alignedOperatorLoss := schema.alignedOperatorLoss
  spectralBudget := schema.spectralBudget
  operatorBudget := schema.operatorBudget
  channelInventory := data.channelInventory
  channelPasses := data.channelPasses

/-- `BG-DECISION-THM-060`: after the tagged adapter, generic alignment-channel acceptance
means exactly all error budgets and all structural requirements for the same candidate and
alignment. -/
theorem withMandatoryOperatorChannels_alignmentChannelsAccept_iff
    (data : FiniteMandatoryOperatorChannelData
      Model Candidate Alignment ErrorChannel StructuralRequirement)
    (model : Model) (candidate : Candidate) (alignment : Alignment) :
    (schema.withMandatoryOperatorChannels data).AlignmentChannelsAccept
        model candidate alignment ↔
      data.Accepts model candidate alignment := by
  exact (data.accepts_iff_tagged_channels model candidate alignment).symm

end FiniteCompatibilitySchema

end ProjectKoios.BandGauge.Decision

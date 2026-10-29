/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-29
-/
module

public import ProjectKoios.BandGauge.Decision.FiniteCutoff
public import ProjectKoios.BandGauge.Geometry.AdmissibleSets

/-!
# Finite spectral--operator compatibility schemas

This module formalizes compatibility inside a supplied finite model inventory. Each model
class has a finite candidate inventory, spectral and aligned-operator budgets, an explicit
alignment family, and a finite inventory of mandatory operator channels.

The central operator-admissible set uses the extended nonnegative infimum over alignments.
Its threshold boundary therefore does not manufacture an attaining alignment. A separate,
stronger witness-compatible predicate requires one common candidate and one alignment that
passes the operator budget and every mandatory channel. An application may use the alignment
carrier to bundle support, intermediate-field, sign-convention, and evaluation-inventory
data that must remain common. Explicit attainment and channel hypotheses bridge the two
notions when available.

First-compatible selection is relative only to the supplied finite ordered model inventory.
The module does not claim external inventory coverage, runtime verification, physical
applicability, or scientific adequacy.
-/

@[expose] public section

open Set
open scoped ENNReal

namespace ProjectKoios.BandGauge.Decision

variable {Model Candidate Alignment Channel : Type*}

/-- `BG-DECISION-DEF-012`: finite model and candidate inventories together with the
losses, budgets, alignment families, and mandatory channel predicates used by one
compatibility query. -/
structure FiniteCompatibilitySchema
    (Model Candidate Alignment Channel : Type*) where
  modelInventory : Finset Model
  candidateInventory : Model → Finset Candidate
  alignmentFamily : Model → Candidate → Set Alignment
  spectralLoss : Model → Candidate → ENNReal
  alignedOperatorLoss : Model → Candidate → Alignment → ENNReal
  spectralBudget : Model → ENNReal
  operatorBudget : Model → ENNReal
  channelInventory : Model → Finset Channel
  channelPasses : Model → Candidate → Alignment → Channel → Prop

namespace FiniteCompatibilitySchema

variable (schema : FiniteCompatibilitySchema Model Candidate Alignment Channel)

/-- `BG-DECISION-DEF-013`: every mandatory operator channel accepts the same candidate
and alignment witness. -/
def AlignmentChannelsAccept (model : Model) (candidate : Candidate)
    (alignment : Alignment) : Prop :=
  ∀ channel ∈ schema.channelInventory model,
    schema.channelPasses model candidate alignment channel

/-- `BG-DECISION-DEF-014`: a declared alignment attains the least aligned-operator loss
in its family. -/
def AttainsAlignedOperatorLoss (model : Model) (candidate : Candidate)
    (alignment : Alignment) : Prop :=
  alignment ∈ schema.alignmentFamily model candidate ∧
    ∀ other ∈ schema.alignmentFamily model candidate,
      schema.alignedOperatorLoss model candidate alignment ≤
        schema.alignedOperatorLoss model candidate other

/-- `BG-DECISION-DEF-015`: extended infimum of the aligned-operator loss over one
declared alignment family. An empty family has value `⊤`. -/
noncomputable def alignedOperatorLossInfimum (model : Model) (candidate : Candidate) : ENNReal :=
  ⨅ alignment, ⨅ (_ : alignment ∈ schema.alignmentFamily model candidate),
    schema.alignedOperatorLoss model candidate alignment

/-- `BG-DECISION-DEF-016`: the raw optimized aligned-operator loss is within budget. This
predicate alone does not supply an attaining alignment or establish the mandatory channel
predicates. -/
def AlignedOperatorInfimumPasses (model : Model) (candidate : Candidate) : Prop :=
  schema.alignedOperatorLossInfimum model candidate ≤ schema.operatorBudget model

/-- `BG-DECISION-DEF-017`: one alignment witness satisfies the operator budget and every
mandatory channel. -/
def ConformantOperatorWitness (model : Model) (candidate : Candidate)
    (alignment : Alignment) : Prop :=
  alignment ∈ schema.alignmentFamily model candidate ∧
    schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
    schema.AlignmentChannelsAccept model candidate alignment

/-- `BG-DECISION-DEF-018`: a declared candidate satisfies the spectral budget in one model
class. -/
def SpectralAccepts (model : Model) (candidate : Candidate) : Prop :=
  candidate ∈ schema.candidateInventory model ∧
    schema.spectralLoss model candidate ≤ schema.spectralBudget model

/-- `BG-DECISION-DEF-019`: a declared candidate has a nonempty alignment family and
passes the alignment-infimum operator budget. No attaining alignment is inferred. -/
def OperatorAccepts (model : Model) (candidate : Candidate) : Prop :=
  candidate ∈ schema.candidateInventory model ∧
    (schema.alignmentFamily model candidate).Nonempty ∧
    schema.AlignedOperatorInfimumPasses model candidate

/-- `BG-DECISION-DEF-020`: a declared candidate has one conformant operator witness. -/
def OperatorWitnessAccepts (model : Model) (candidate : Candidate) : Prop :=
  candidate ∈ schema.candidateInventory model ∧
    ∃ alignment, schema.ConformantOperatorWitness model candidate alignment

/-- `BG-DECISION-DEF-021`: spectrally admissible candidates in one model class. -/
def spectralAdmissibleCandidates (model : Model) : Set Candidate :=
  {candidate | schema.SpectralAccepts model candidate}

/-- `BG-DECISION-DEF-022`: alignment-infimum operator-admissible candidates in one model
class. -/
def operatorAdmissibleCandidates (model : Model) : Set Candidate :=
  {candidate | schema.OperatorAccepts model candidate}

/-- `BG-DECISION-DEF-023`: the model class is compatible when its spectral and
alignment-infimum operator admissible sets contain one common candidate. -/
def Compatible (model : Model) : Prop :=
  (schema.spectralAdmissibleCandidates model ∩
    schema.operatorAdmissibleCandidates model).Nonempty

/-- `BG-DECISION-DEF-024`: stronger compatibility with one common candidate and one
operator alignment that passes every mandatory channel. -/
def WitnessCompatible (model : Model) : Prop :=
  ∃ candidate, schema.SpectralAccepts model candidate ∧
    schema.OperatorWitnessAccepts model candidate

/-- `BG-DECISION-DEF-025`: metric separation interface between the central spectral and
alignment-infimum operator admissible sets. -/
noncomputable def compatibilityEDist [MetricSpace Candidate] (model : Model) : ENNReal :=
  Geometry.admissibleSetEDist
    (schema.spectralAdmissibleCandidates model)
    (schema.operatorAdmissibleCandidates model)

/-- `BG-DECISION-DEF-026`: explicit conformance data for transferring compatibility from
one model class to another. The injective candidate map, alignment-family nonemptiness,
and both infimum and witness acceptance branches are supplied; the word `nested` alone is
not enough. -/
structure ConformantModelEmbedding (smaller larger : Model) where
  candidateMap : Candidate → Candidate
  candidateMap_injective : Function.Injective candidateMap
  candidate_mem : ∀ {candidate}, candidate ∈ schema.candidateInventory smaller →
    candidateMap candidate ∈ schema.candidateInventory larger
  spectral_passes : ∀ {candidate}, candidate ∈ schema.candidateInventory smaller →
    schema.spectralLoss smaller candidate ≤ schema.spectralBudget smaller →
    schema.spectralLoss larger (candidateMap candidate) ≤ schema.spectralBudget larger
  alignment_family_nonempty : ∀ {candidate},
    candidate ∈ schema.candidateInventory smaller →
    (schema.alignmentFamily smaller candidate).Nonempty →
    (schema.alignmentFamily larger (candidateMap candidate)).Nonempty
  operator_infimum_passes : ∀ {candidate},
    candidate ∈ schema.candidateInventory smaller →
    schema.AlignedOperatorInfimumPasses smaller candidate →
    schema.AlignedOperatorInfimumPasses larger (candidateMap candidate)
  operator_witness : ∀ {candidate alignment},
    candidate ∈ schema.candidateInventory smaller →
    schema.ConformantOperatorWitness smaller candidate alignment →
    ∃ largerAlignment,
      schema.ConformantOperatorWitness larger (candidateMap candidate) largerAlignment

/-- `BG-DECISION-DEF-027`: first compatible member of the supplied finite ordered model
inventory. -/
def IsFirstCompatible [LT Model] (selected : Model) : Prop :=
  IsFirstPassing schema.modelInventory schema.Compatible selected

/-- `BG-DECISION-THM-017`: every family member supplies an upper bound on the
aligned-operator infimum. -/
theorem alignedOperatorLossInfimum_le_of_mem
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (hmem : alignment ∈ schema.alignmentFamily model candidate) :
    schema.alignedOperatorLossInfimum model candidate ≤
      schema.alignedOperatorLoss model candidate alignment := by
  exact iInf_le_of_le alignment <| iInf_le_of_le hmem le_rfl

/-- `BG-DECISION-THM-018`: an explicit minimizer identifies the infimum exactly. -/
theorem alignedOperatorLossInfimum_eq_of_attains
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (hattains : schema.AttainsAlignedOperatorLoss model candidate alignment) :
    schema.alignedOperatorLossInfimum model candidate =
      schema.alignedOperatorLoss model candidate alignment := by
  apply le_antisymm
  · exact schema.alignedOperatorLossInfimum_le_of_mem hattains.1
  · rw [alignedOperatorLossInfimum]
    refine le_iInf fun other => le_iInf fun hother => ?_
    exact hattains.2 other hother

/-- `BG-DECISION-THM-019`: a budget-feasible alignment implies passage of the raw
infimum criterion. -/
theorem alignedOperatorInfimumPasses_of_exists
    {model : Model} {candidate : Candidate}
    (h : ∃ alignment ∈ schema.alignmentFamily model candidate,
      schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model) :
    schema.AlignedOperatorInfimumPasses model candidate := by
  obtain ⟨alignment, hmem, hbudget⟩ := h
  exact (schema.alignedOperatorLossInfimum_le_of_mem hmem).trans hbudget

/-- `BG-DECISION-THM-020`: under explicit attainment, raw infimum passage is equivalent
to existence of a budget-feasible alignment. This theorem does not add mandatory channel
acceptance. -/
theorem alignedOperatorInfimumPasses_iff_exists_of_attains
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (hattains : schema.AttainsAlignedOperatorLoss model candidate alignment) :
    schema.AlignedOperatorInfimumPasses model candidate ↔
      ∃ witness ∈ schema.alignmentFamily model candidate,
        schema.alignedOperatorLoss model candidate witness ≤ schema.operatorBudget model := by
  constructor
  · intro hinf
    refine ⟨alignment, hattains.1, ?_⟩
    rw [← schema.alignedOperatorLossInfimum_eq_of_attains hattains]
    exact hinf
  · exact schema.alignedOperatorInfimumPasses_of_exists

/-- `BG-DECISION-THM-021`: a conformant operator witness implies the raw infimum budget
criterion. -/
theorem alignedOperatorInfimumPasses_of_operatorWitnessAccepts
    {model : Model} {candidate : Candidate}
    (haccepts : schema.OperatorWitnessAccepts model candidate) :
    schema.AlignedOperatorInfimumPasses model candidate := by
  obtain ⟨_, alignment, hmem, hbudget, _⟩ := haccepts
  exact schema.alignedOperatorInfimumPasses_of_exists ⟨alignment, hmem, hbudget⟩

/-- `BG-DECISION-THM-022`: witness-based operator acceptance implies central
alignment-infimum operator acceptance. -/
theorem operatorAccepts_of_operatorWitnessAccepts
    {model : Model} {candidate : Candidate}
    (haccepts : schema.OperatorWitnessAccepts model candidate) :
    schema.OperatorAccepts model candidate := by
  obtain ⟨hcandidate, alignment, halignment⟩ := haccepts
  exact ⟨hcandidate, ⟨alignment, halignment.1⟩,
    schema.alignedOperatorInfimumPasses_of_exists
      ⟨alignment, halignment.1, halignment.2.1⟩⟩

/-- `BG-DECISION-THM-023`: an attaining alignment that also passes every mandatory
channel converts central operator acceptance into witness-based operator acceptance. -/
theorem operatorWitnessAccepts_of_operatorAccepts_of_attains
    {model : Model} {candidate : Candidate} {alignment : Alignment}
    (haccepts : schema.OperatorAccepts model candidate)
    (hattains : schema.AttainsAlignedOperatorLoss model candidate alignment)
    (hchannels : schema.AlignmentChannelsAccept model candidate alignment) :
    schema.OperatorWitnessAccepts model candidate := by
  refine ⟨haccepts.1, alignment, hattains.1, ?_, hchannels⟩
  rw [← schema.alignedOperatorLossInfimum_eq_of_attains hattains]
  exact haccepts.2.2

/-- `BG-DECISION-THM-024`: central compatibility is exactly one declared candidate
satisfying the spectral budget and the aligned-operator infimum budget. -/
theorem compatible_iff_exists_common_candidate (model : Model) :
    schema.Compatible model ↔
      ∃ candidate ∈ schema.candidateInventory model,
        schema.spectralLoss model candidate ≤ schema.spectralBudget model ∧
        (schema.alignmentFamily model candidate).Nonempty ∧
        schema.AlignedOperatorInfimumPasses model candidate := by
  constructor
  · rintro ⟨candidate, ⟨hcandidate, hspectral⟩, ⟨_, hfamily, hoperator⟩⟩
    exact ⟨candidate, hcandidate, hspectral, hfamily, hoperator⟩
  · rintro ⟨candidate, hcandidate, hspectral, hfamily, hoperator⟩
    exact ⟨candidate, ⟨hcandidate, hspectral⟩,
      ⟨hcandidate, hfamily, hoperator⟩⟩

/-- `BG-DECISION-THM-025`: witness compatibility is exactly one declared candidate and
one alignment satisfying the spectral budget, operator budget, and every mandatory
operator channel. -/
theorem witnessCompatible_iff_exists_common_witness (model : Model) :
    schema.WitnessCompatible model ↔
      ∃ candidate ∈ schema.candidateInventory model,
        schema.spectralLoss model candidate ≤ schema.spectralBudget model ∧
        ∃ alignment,
          alignment ∈ schema.alignmentFamily model candidate ∧
          schema.alignedOperatorLoss model candidate alignment ≤ schema.operatorBudget model ∧
          schema.AlignmentChannelsAccept model candidate alignment := by
  constructor
  · rintro ⟨candidate, ⟨hcandidate, hspectral⟩,
      ⟨_, alignment, halignment, hoperator, hchannels⟩⟩
    exact ⟨candidate, hcandidate, hspectral, alignment, halignment, hoperator, hchannels⟩
  · rintro ⟨candidate, hcandidate, hspectral, alignment, halignment, hoperator, hchannels⟩
    exact ⟨candidate, ⟨hcandidate, hspectral⟩,
      ⟨hcandidate, alignment, halignment, hoperator, hchannels⟩⟩

/-- `BG-DECISION-THM-026`: a common conformant alignment witness establishes central
compatibility, but the converse is not asserted without attainment and channel hypotheses. -/
theorem compatible_of_witnessCompatible
    {model : Model} (hcompatible : schema.WitnessCompatible model) :
    schema.Compatible model := by
  obtain ⟨candidate, hspectral, hoperator⟩ := hcompatible
  exact ⟨candidate, hspectral,
    schema.operatorAccepts_of_operatorWitnessAccepts hoperator⟩

/-- `BG-DECISION-THM-027`: a compatible model class has zero metric separation between
its central admissible sets. -/
theorem compatibilityEDist_eq_zero_of_compatible [MetricSpace Candidate]
    {model : Model} (hcompatible : schema.Compatible model) :
    schema.compatibilityEDist model = 0 := by
  obtain ⟨candidate, hcandidate⟩ := hcompatible
  exact Geometry.admissibleSetEDist_eq_zero_of_mem_inter hcandidate

/-- `BG-DECISION-THM-028`: a positive certified lower bound on central set separation
excludes compatibility. -/
theorem not_compatible_of_pos_le_compatibilityEDist [MetricSpace Candidate]
    {model : Model} {lower : ENNReal}
    (hpos : 0 < lower) (hlower : lower ≤ schema.compatibilityEDist model) :
    ¬ schema.Compatible model := by
  intro hcompatible
  have hzero := schema.compatibilityEDist_eq_zero_of_compatible hcompatible
  have : lower ≤ 0 := by simpa [hzero] using hlower
  exact (not_lt_of_ge this) hpos

/-- `BG-DECISION-THM-029`: explicitly conformant model inclusion transfers central
compatibility forward through the supplied candidate map. -/
theorem compatible_of_conformantModelEmbedding
    {smaller larger : Model}
    (embedding : schema.ConformantModelEmbedding smaller larger)
    (hcompatible : schema.Compatible smaller) :
    schema.Compatible larger := by
  obtain ⟨candidate, hcandidatesmall, hspectral, hfamily, hoperator⟩ :=
    (schema.compatible_iff_exists_common_candidate smaller).1 hcompatible
  exact (schema.compatible_iff_exists_common_candidate larger).2
    ⟨embedding.candidateMap candidate,
      embedding.candidate_mem hcandidatesmall,
      embedding.spectral_passes hcandidatesmall hspectral,
      embedding.alignment_family_nonempty hcandidatesmall hfamily,
      embedding.operator_infimum_passes hcandidatesmall hoperator⟩

/-- `BG-DECISION-THM-030`: explicitly conformant model inclusion also transfers the
stronger common-witness compatibility predicate. -/
theorem witnessCompatible_of_conformantModelEmbedding
    {smaller larger : Model}
    (embedding : schema.ConformantModelEmbedding smaller larger)
    (hcompatible : schema.WitnessCompatible smaller) :
    schema.WitnessCompatible larger := by
  obtain ⟨candidate, hcandidatesmall, hspectral, alignment, halignment⟩ :=
    (schema.witnessCompatible_iff_exists_common_witness smaller).1 hcompatible
  obtain ⟨largerAlignment, hlargerAlignment⟩ :=
    embedding.operator_witness hcandidatesmall halignment
  exact (schema.witnessCompatible_iff_exists_common_witness larger).2
    ⟨embedding.candidateMap candidate,
      embedding.candidate_mem hcandidatesmall,
      embedding.spectral_passes hcandidatesmall hspectral,
      largerAlignment,
      hlargerAlignment⟩

/-- `BG-DECISION-THM-031`: a nonempty compatible subset of the finite ordered inventory
has a first compatible model class. -/
theorem exists_isFirstCompatible [LinearOrder Model]
    (hnonempty : ∃ model ∈ schema.modelInventory, schema.Compatible model) :
    ∃ selected, schema.IsFirstCompatible selected := by
  exact exists_isFirstPassing schema.modelInventory schema.Compatible hnonempty

/-- `BG-DECISION-THM-032`: the first compatible model class is unique inside the declared
finite inventory. -/
theorem isFirstCompatible_unique [LinearOrder Model]
    {left right : Model}
    (hleft : schema.IsFirstCompatible left)
    (hright : schema.IsFirstCompatible right) :
    left = right := by
  exact isFirstPassing_unique hleft hright

/-- `BG-DECISION-THM-033`: expanded first-compatible semantics: the selected class is
compatible and every strictly earlier declared class is incompatible. -/
theorem isFirstCompatible_iff [LinearOrder Model]
    {selected : Model} :
    schema.IsFirstCompatible selected ↔
      selected ∈ schema.modelInventory ∧
      schema.Compatible selected ∧
      ∀ earlier ∈ schema.modelInventory, earlier < selected → ¬ schema.Compatible earlier := by
  rfl

/-- `BG-DECISION-THM-034`: the central spectral-admissible set is finite because every
accepted candidate belongs to the declared finite candidate inventory. -/
theorem spectralAdmissibleCandidates_finite (model : Model) :
    (schema.spectralAdmissibleCandidates model).Finite := by
  refine (schema.candidateInventory model).finite_toSet.subset ?_
  intro candidate hcandidate
  exact hcandidate.1

/-- `BG-DECISION-THM-035`: the central operator-admissible set is finite because every
accepted candidate belongs to the same declared finite candidate inventory. -/
theorem operatorAdmissibleCandidates_finite (model : Model) :
    (schema.operatorAdmissibleCandidates model).Finite := by
  refine (schema.candidateInventory model).finite_toSet.subset ?_
  intro candidate hcandidate
  exact hcandidate.1

/-- `BG-DECISION-THM-036`: when both central admissible sets are nonempty, their
extended distance is attained by one declared spectral candidate and one declared
operator candidate. Finiteness of the supplied inventory provides compactness. -/
theorem exists_compatibilityEDist_eq_edist [MetricSpace Candidate]
    {model : Model}
    (hspectral : (schema.spectralAdmissibleCandidates model).Nonempty)
    (hoperator : (schema.operatorAdmissibleCandidates model).Nonempty) :
    ∃ spectralCandidate ∈ schema.spectralAdmissibleCandidates model,
      ∃ operatorCandidate ∈ schema.operatorAdmissibleCandidates model,
        schema.compatibilityEDist model = edist spectralCandidate operatorCandidate := by
  exact Geometry.exists_admissibleSetEDist_eq_edist_of_compact
    (schema.spectralAdmissibleCandidates_finite model).isCompact
    (schema.operatorAdmissibleCandidates_finite model).isCompact
    hspectral hoperator

/-- `BG-DECISION-THM-037`: for nonempty central admissible sets in the finite candidate
inventory, zero metric separation is equivalent to literal compatibility. -/
theorem compatibilityEDist_eq_zero_iff_compatible [MetricSpace Candidate]
    {model : Model}
    (hspectral : (schema.spectralAdmissibleCandidates model).Nonempty)
    (hoperator : (schema.operatorAdmissibleCandidates model).Nonempty) :
    schema.compatibilityEDist model = 0 ↔ schema.Compatible model := by
  simpa [compatibilityEDist, Compatible] using
    (Geometry.admissibleSetEDist_eq_zero_iff_inter_nonempty_of_compact
      (A := schema.spectralAdmissibleCandidates model)
      (B := schema.operatorAdmissibleCandidates model)
      (schema.spectralAdmissibleCandidates_finite model).isCompact
      (schema.operatorAdmissibleCandidates_finite model).isCompact
      hspectral hoperator)

/-- `BG-DECISION-THM-038`: for nonempty central admissible sets in the finite candidate
inventory, strictly positive metric separation is equivalent to incompatibility. -/
theorem compatibilityEDist_pos_iff_not_compatible [MetricSpace Candidate]
    {model : Model}
    (hspectral : (schema.spectralAdmissibleCandidates model).Nonempty)
    (hoperator : (schema.operatorAdmissibleCandidates model).Nonempty) :
    0 < schema.compatibilityEDist model ↔ ¬ schema.Compatible model := by
  rw [compatibilityEDist]
  rw [Geometry.admissibleSetEDist_pos_iff_disjoint_of_compact
    (schema.spectralAdmissibleCandidates_finite model).isCompact
    (schema.operatorAdmissibleCandidates_finite model).isCompact
    hspectral hoperator]
  constructor
  · intro hdisjoint hcompatible
    obtain ⟨candidate, hspectralCandidate, hoperatorCandidate⟩ := hcompatible
    exact (Set.disjoint_left.1 hdisjoint hspectralCandidate) hoperatorCandidate
  · intro hnot
    rw [Set.disjoint_left]
    intro candidate hspectralCandidate hoperatorCandidate
    exact hnot ⟨candidate, hspectralCandidate, hoperatorCandidate⟩

end FiniteCompatibilitySchema

end ProjectKoios.BandGauge.Decision

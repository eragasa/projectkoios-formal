/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-27
-/
module

public import ProjectKoios.BandGauge.Alignment.Family

/-!
# Strict separation of alignment families

This module supplies exact witnesses showing that identity-only, global-unitary, and complete
pointwise-unitary alignment families can be genuinely different. A nonidentity constant field
separates identity from global alignment. A two-point field taking two distinct unitary values
separates global from complete pointwise alignment.

Strict family inclusion also yields an explicit acceptance predicate that is feasible in the larger
family but not the smaller one. These are logical counterexamples to converse feasibility transfer,
not optimizer outputs, runtime evidence, or physical adequacy results.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Alignment

variable {K E Eref Ecand : Type*}
variable [NormedAddCommGroup E] [InnerProductSpace ℂ E]
variable [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
variable [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand]

/-- `BG-ALIGNMENT-DEF-016`: a pointwise alignment field taking one unitary at a selected point and
another unitary elsewhere. -/
def twoPointAlignmentField [DecidableEq K] (selected : K)
    (atSelected otherwise : Eref ≃ₗᵢ[ℂ] Ecand) : AlignmentField K Eref Ecand :=
  fun k => if k = selected then atSelected else otherwise

/-- `BG-ALIGNMENT-THM-020`: the two-point field takes its selected unitary at the selected
point. -/
theorem twoPointAlignmentField_selected [DecidableEq K] (selected : K)
    (atSelected otherwise : Eref ≃ₗᵢ[ℂ] Ecand) :
    twoPointAlignmentField selected atSelected otherwise selected = atSelected := by
  simp [twoPointAlignmentField]

/-- `BG-ALIGNMENT-THM-021`: away from the selected point, the two-point field takes its other
unitary. -/
theorem twoPointAlignmentField_other [DecidableEq K]
    {selected other : K} (hne : other ≠ selected)
    (atSelected otherwise : Eref ≃ₗᵢ[ℂ] Ecand) :
    twoPointAlignmentField selected atSelected otherwise other = otherwise := by
  simp [twoPointAlignmentField, hne]

/-- `BG-ALIGNMENT-THM-022`: two distinct values at two distinct points prevent a two-point field
from belonging to the global-unitary family. -/
theorem twoPointAlignmentField_not_mem_globalAlignmentFamily [DecidableEq K]
    {selected other : K} (hne : other ≠ selected)
    {atSelected otherwise : Eref ≃ₗᵢ[ℂ] Ecand} (hU : atSelected ≠ otherwise) :
    twoPointAlignmentField selected atSelected otherwise ∉
      globalAlignmentFamily := by
  rintro ⟨constant, heq⟩
  have hselected := congrFun heq selected
  have hother := congrFun heq other
  simp [twoPointAlignmentField] at hselected
  simp [twoPointAlignmentField, hne] at hother
  exact hU (hselected.trans hother.symm)

/-- `BG-ALIGNMENT-THM-023`: every two-point alignment field belongs to the complete pointwise
family. -/
theorem twoPointAlignmentField_mem_completeAlignmentFamily [DecidableEq K]
    (selected : K) (atSelected otherwise : Eref ≃ₗᵢ[ℂ] Ecand) :
    twoPointAlignmentField selected atSelected otherwise ∈ completeAlignmentFamily := by
  exact Set.mem_univ _

/-- `BG-ALIGNMENT-THM-024`: on a nonempty point domain, a nonidentity constant alignment is not a
member of the identity-only family. -/
theorem constantAlignmentField_not_mem_identityAlignmentFamily [Nonempty K]
    {U : E ≃ₗᵢ[ℂ] E} (hne : U ≠ LinearIsometryEquiv.refl ℂ E) :
    constantAlignmentField (K := K) U ∉ identityAlignmentFamily := by
  intro hmem
  rw [identityAlignmentFamily, singletonAlignmentFamily, Set.mem_singleton_iff] at hmem
  obtain ⟨k⟩ := ‹Nonempty K›
  have hpoint := congrFun hmem k
  exact hne hpoint

/-- `BG-ALIGNMENT-THM-025`: a supplied nonidentity unitary makes identity-only alignment a proper
subfamily of global-unitary alignment on a nonempty point domain. -/
theorem identityAlignmentFamily_ssubset_globalAlignmentFamily [Nonempty K]
    {U : E ≃ₗᵢ[ℂ] E} (hne : U ≠ LinearIsometryEquiv.refl ℂ E) :
    identityAlignmentFamily (K := K) (E := E) ⊂ globalAlignmentFamily := by
  rw [Set.ssubset_iff_exists]
  refine ⟨identityAlignmentFamily_subset_globalAlignmentFamily,
    constantAlignmentField U, ?_, ?_⟩
  · exact constantAlignmentField_mem_globalAlignmentFamily U
  · exact constantAlignmentField_not_mem_identityAlignmentFamily hne

/-- `BG-ALIGNMENT-THM-026`: two supplied distinct pointwise unitaries at two distinct points make
global-unitary alignment a proper subfamily of complete pointwise alignment. -/
theorem globalAlignmentFamily_ssubset_completeAlignmentFamily [DecidableEq K]
    {selected other : K} (hne : other ≠ selected)
    {atSelected otherwise : Eref ≃ₗᵢ[ℂ] Ecand} (hU : atSelected ≠ otherwise) :
    globalAlignmentFamily (K := K) (Eref := Eref) (Ecand := Ecand) ⊂
      completeAlignmentFamily := by
  rw [Set.ssubset_iff_exists]
  refine ⟨globalAlignmentFamily_subset_completeAlignmentFamily,
    twoPointAlignmentField selected atSelected otherwise, ?_, ?_⟩
  · exact Set.mem_univ _
  · exact twoPointAlignmentField_not_mem_globalAlignmentFamily hne hU

/-- `BG-ALIGNMENT-THM-027`: every strict family inclusion admits an exact acceptance predicate
that is feasible in the larger family and infeasible in the smaller family. -/
theorem exists_alignmentFeasible_larger_not_smaller_of_ssubset
    {smaller larger : AlignmentFamily K Eref Ecand} (hstrict : smaller ⊂ larger) :
    ∃ accepts : AlignmentField K Eref Ecand → Prop,
      AlignmentFeasible larger accepts ∧ ¬ AlignmentFeasible smaller accepts := by
  obtain ⟨alignment, hlarge, hsmall⟩ := Set.exists_of_ssubset hstrict
  refine ⟨fun candidate => candidate = alignment, ?_, ?_⟩
  · exact ⟨alignment, hlarge, rfl⟩
  · rintro ⟨candidate, hcand, rfl⟩
    exact hsmall hcand

/-- `BG-ALIGNMENT-THM-028`: under a supplied nonidentity unitary, some exact predicate is globally
feasible but not identity-family feasible. -/
theorem exists_globalFeasible_not_identityFeasible [Nonempty K]
    {U : E ≃ₗᵢ[ℂ] E} (hne : U ≠ LinearIsometryEquiv.refl ℂ E) :
    ∃ accepts : AlignmentField K E E → Prop,
      AlignmentFeasible globalAlignmentFamily accepts ∧
        ¬ AlignmentFeasible identityAlignmentFamily accepts := by
  exact exists_alignmentFeasible_larger_not_smaller_of_ssubset
    (identityAlignmentFamily_ssubset_globalAlignmentFamily hne)

/-- `BG-ALIGNMENT-THM-029`: under supplied distinct points and unitary values, some exact predicate
is complete-family feasible but not global-family feasible. -/
theorem exists_completeFeasible_not_globalFeasible [DecidableEq K]
    {selected other : K} (hne : other ≠ selected)
    {atSelected otherwise : Eref ≃ₗᵢ[ℂ] Ecand} (hU : atSelected ≠ otherwise) :
    ∃ accepts : AlignmentField K Eref Ecand → Prop,
      AlignmentFeasible completeAlignmentFamily accepts ∧
        ¬ AlignmentFeasible globalAlignmentFamily accepts := by
  exact exists_alignmentFeasible_larger_not_smaller_of_ssubset
    (globalAlignmentFamily_ssubset_completeAlignmentFamily hne hU)

end ProjectKoios.BandGauge.Alignment

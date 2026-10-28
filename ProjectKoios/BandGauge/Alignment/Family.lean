/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-27
-/
module

public import Mathlib.Analysis.InnerProductSpace.Basic

/-!
# Admissible alignment families

This module distinguishes singleton, identity, global-unitary, and complete pointwise-unitary
alignment families. Feasibility is explicitly relative to one supplied family, and it is monotone
only when a family inclusion is proved.

The families are exact decision spaces. The module does not choose an alignment, assert that a
feasible alignment exists, bind a runtime optimizer, or transfer a result from a larger family to
a smaller one.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Alignment

variable {K E Eref Ecand : Type*}
variable [NormedAddCommGroup E] [InnerProductSpace ℂ E]
variable [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
variable [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand]

/-- `BG-ALIGNMENT-DEF-007`: pointwise unitary alignment from reference to candidate fibers. -/
abbrev AlignmentField (K Eref Ecand : Type*)
    [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
    [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand] :=
  K → Eref ≃ₗᵢ[ℂ] Ecand

/-- `BG-ALIGNMENT-DEF-008`: a declared admissible set of pointwise unitary alignments. -/
abbrev AlignmentFamily (K Eref Ecand : Type*)
    [NormedAddCommGroup Eref] [InnerProductSpace ℂ Eref]
    [NormedAddCommGroup Ecand] [InnerProductSpace ℂ Ecand] :=
  Set (AlignmentField K Eref Ecand)

/-- `BG-ALIGNMENT-DEF-009`: the pointwise field induced by one common unitary. -/
def constantAlignmentField (alignment : Eref ≃ₗᵢ[ℂ] Ecand) :
    AlignmentField K Eref Ecand := fun _ => alignment

/-- `BG-ALIGNMENT-DEF-010`: the family containing exactly one declared alignment. -/
def singletonAlignmentFamily (alignment : AlignmentField K Eref Ecand) :
    AlignmentFamily K Eref Ecand := {alignment}

/-- `BG-ALIGNMENT-DEF-011`: all alignment fields induced by one unitary common to every point. -/
def globalAlignmentFamily : AlignmentFamily K Eref Ecand :=
  {alignment | ∃ U : Eref ≃ₗᵢ[ℂ] Ecand, alignment = constantAlignmentField U}

/-- `BG-ALIGNMENT-DEF-012`: all pointwise unitary alignment fields, with no cross-point
restriction. -/
def completeAlignmentFamily : AlignmentFamily K Eref Ecand := Set.univ

/-- `BG-ALIGNMENT-DEF-013`: existence of an accepted alignment inside one declared family. -/
def AlignmentFeasible (family : AlignmentFamily K Eref Ecand)
    (accepts : AlignmentField K Eref Ecand → Prop) : Prop :=
  ∃ alignment ∈ family, accepts alignment

/-- `BG-ALIGNMENT-DEF-014`: the constant identity alignment field on one fiber space. -/
def identityAlignmentField : AlignmentField K E E :=
  constantAlignmentField (LinearIsometryEquiv.refl ℂ E)

/-- `BG-ALIGNMENT-DEF-015`: the singleton family containing only the constant identity alignment. -/
def identityAlignmentFamily : AlignmentFamily K E E :=
  singletonAlignmentFamily identityAlignmentField

/-- `BG-ALIGNMENT-THM-011`: every constant alignment field belongs to the global-unitary
family. -/
theorem constantAlignmentField_mem_globalAlignmentFamily
    (U : Eref ≃ₗᵢ[ℂ] Ecand) :
    constantAlignmentField (K := K) U ∈ globalAlignmentFamily := by
  exact ⟨U, rfl⟩

/-- `BG-ALIGNMENT-THM-012`: the constant identity alignment belongs to the global-unitary
family. -/
theorem identityAlignmentField_mem_globalAlignmentFamily :
    identityAlignmentField (K := K) (E := E) ∈ globalAlignmentFamily := by
  exact ⟨LinearIsometryEquiv.refl ℂ E, rfl⟩

/-- `BG-ALIGNMENT-THM-013`: identity-only alignment is a subfamily of global-unitary
alignment. -/
theorem identityAlignmentFamily_subset_globalAlignmentFamily :
    identityAlignmentFamily (K := K) (E := E) ⊆ globalAlignmentFamily := by
  intro alignment halignment
  rw [identityAlignmentFamily, singletonAlignmentFamily] at halignment
  rw [Set.mem_singleton_iff] at halignment
  rw [halignment]
  exact identityAlignmentField_mem_globalAlignmentFamily

/-- `BG-ALIGNMENT-THM-014`: every global-unitary alignment is a member of the complete pointwise
family. -/
theorem globalAlignmentFamily_subset_completeAlignmentFamily :
    globalAlignmentFamily (K := K) (Eref := Eref) (Ecand := Ecand) ⊆
      completeAlignmentFamily := by
  intro alignment _
  exact Set.mem_univ alignment

/-- `BG-ALIGNMENT-THM-015`: feasibility is monotone from a smaller declared alignment family to a
larger one. The converse is not supplied. -/
theorem AlignmentFeasible.mono
    {smaller larger : AlignmentFamily K Eref Ecand}
    {accepts : AlignmentField K Eref Ecand → Prop}
    (hsubset : smaller ⊆ larger) :
    AlignmentFeasible smaller accepts → AlignmentFeasible larger accepts := by
  rintro ⟨alignment, hsmall, haccepts⟩
  exact ⟨alignment, hsubset hsmall, haccepts⟩

/-- `BG-ALIGNMENT-THM-016`: singleton-family feasibility is exactly acceptance of its sole
alignment. -/
theorem alignmentFeasible_singleton_iff
    (alignment : AlignmentField K Eref Ecand)
    (accepts : AlignmentField K Eref Ecand → Prop) :
    AlignmentFeasible (singletonAlignmentFamily alignment) accepts ↔
      accepts alignment := by
  constructor
  · rintro ⟨candidate, hcand, haccepts⟩
    have heq : candidate = alignment := by
      simpa [singletonAlignmentFamily] using hcand
    simpa [heq] using haccepts
  · intro haccepts
    exact ⟨alignment, Set.mem_singleton alignment, haccepts⟩

/-- `BG-ALIGNMENT-THM-017`: identity-family feasibility is exactly acceptance of the constant
identity alignment. -/
theorem alignmentFeasible_identity_iff
    (accepts : AlignmentField K E E → Prop) :
    AlignmentFeasible identityAlignmentFamily accepts ↔
      accepts identityAlignmentField := by
  exact alignmentFeasible_singleton_iff _ _

/-- `BG-ALIGNMENT-THM-018`: global-family feasibility is exactly acceptance of some constant
unitary alignment field. -/
theorem alignmentFeasible_global_iff
    (accepts : AlignmentField K Eref Ecand → Prop) :
    AlignmentFeasible globalAlignmentFamily accepts ↔
      ∃ U : Eref ≃ₗᵢ[ℂ] Ecand, accepts (constantAlignmentField U) := by
  constructor
  · rintro ⟨alignment, ⟨U, rfl⟩, haccepts⟩
    exact ⟨U, haccepts⟩
  · rintro ⟨U, haccepts⟩
    exact ⟨constantAlignmentField U, ⟨U, rfl⟩, haccepts⟩

/-- `BG-ALIGNMENT-THM-019`: complete-family feasibility is exactly acceptance of some arbitrary
pointwise unitary alignment field. -/
theorem alignmentFeasible_complete_iff
    (accepts : AlignmentField K Eref Ecand → Prop) :
    AlignmentFeasible completeAlignmentFamily accepts ↔
      ∃ alignment, accepts alignment := by
  simp [AlignmentFeasible, completeAlignmentFamily]

end ProjectKoios.BandGauge.Alignment

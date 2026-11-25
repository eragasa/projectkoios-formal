/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.Foundations.Variational
import Mathlib.Tactic.Linarith

/-!
# Nondegenerate Hohenberg--Kohn variational core

This module distinguishes the two ingredients of the first Hohenberg--Kohn argument:

1. the strict variational contradiction, proved in `Variational.lean`; and
2. the model-specific fact that one physical ground state cannot solve two scalar-potential
   problems unless the potentials differ by an additive constant.

The second ingredient is an explicit hypothesis here.  It is not derived without a concrete
Hamiltonian, particle-number sector, and hypotheses on multiplication operators.  Under that
hypothesis, equal densities of strict ground states determine the scalar external potential modulo
an additive constant.

The statement adapts [Hohenberg1964], Part I, section 1, equations (5)--(8).  It does not establish
the source's continuum assumptions, existence of ground states, representability, or the
degenerate-ground-state extensions developed later in the literature.

## References

* [Hohenberg1964] P. Hohenberg and W. Kohn, “Inhomogeneous Electron Gas,” *Physical Review*
  136, B864--B871 (1964), DOI: `10.1103/PhysRev.136.B864`; cited statement location: Part I,
  section 1, equations (5)--(8).
-/

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.Foundations

/--
`DFT-HK-DEF-001`: two scalar potentials differ by one spatially constant additive shift.
-/
def PotentialEquivalentModuloConstant {Position : Type*}
    (potential₁ potential₂ : Position → ℝ) : Prop :=
  ∃ shift : ℝ, ∀ position, potential₁ position = potential₂ position + shift

/-- `DFT-HK-LEM-001`: equality modulo a constant is reflexive. -/
@[refl] lemma PotentialEquivalentModuloConstant.refl {Position : Type*}
    (potential : Position → ℝ) :
    PotentialEquivalentModuloConstant potential potential := by
  refine ⟨0, ?_⟩
  intro position
  simp

/-- `DFT-HK-LEM-002`: equality modulo a constant is symmetric. -/
@[symm] lemma PotentialEquivalentModuloConstant.symm {Position : Type*}
    {potential₁ potential₂ : Position → ℝ}
    (hpotential : PotentialEquivalentModuloConstant potential₁ potential₂) :
    PotentialEquivalentModuloConstant potential₂ potential₁ := by
  obtain ⟨shift, hshift⟩ := hpotential
  refine ⟨-shift, ?_⟩
  intro position
  have := hshift position
  linarith

/-- `DFT-HK-LEM-003`: equality modulo a constant is transitive. -/
@[trans] lemma PotentialEquivalentModuloConstant.trans {Position : Type*}
    {potential₁ potential₂ potential₃ : Position → ℝ}
    (h₁₂ : PotentialEquivalentModuloConstant potential₁ potential₂)
    (h₂₃ : PotentialEquivalentModuloConstant potential₂ potential₃) :
    PotentialEquivalentModuloConstant potential₁ potential₃ := by
  obtain ⟨shift₁₂, hshift₁₂⟩ := h₁₂
  obtain ⟨shift₂₃, hshift₂₃⟩ := h₂₃
  refine ⟨shift₂₃ + shift₁₂, ?_⟩
  intro position
  have h₁ := hshift₁₂ position
  have h₂ := hshift₂₃ position
  linarith

/-- `DFT-HK-DEF-002`: the setoid of scalar potentials modulo additive constants. -/
def potentialModuloConstantSetoid (Position : Type*) : Setoid (Position → ℝ) where
  r := PotentialEquivalentModuloConstant
  iseqv := ⟨PotentialEquivalentModuloConstant.refl,
    PotentialEquivalentModuloConstant.symm, PotentialEquivalentModuloConstant.trans⟩

/--
`DFT-HK-DEF-003`: model-specific uniqueness of a scalar external potential from one shared ground
state, modulo an additive constant.

For a continuum electronic Hamiltonian this is the separate Schrödinger-equation step in the
Hohenberg--Kohn proof.  Keeping it explicit prevents the abstract variational interface from
silently claiming unique continuation or faithfulness of multiplication operators.
-/
def VariationalDensityModel.SharedGroundStateDeterminesPotentialModuloConstant
    {State Density Position : Type*}
    (model : VariationalDensityModel State Density (Position → ℝ)) : Prop :=
  ∀ potential₁ potential₂ state,
    model.IsGroundState potential₁ state →
    model.IsGroundState potential₂ state →
    PotentialEquivalentModuloConstant potential₁ potential₂

/--
`DFT-HK-THM-001`: equal densities of strict ground states determine the scalar potential modulo a
constant, provided a shared ground state determines the potential modulo a constant.

If the two strict ground states are distinct, `density_ne_of_strictGroundStates` gives the standard
variational contradiction.  If they are the same state, the explicit model-specific uniqueness
hypothesis supplies the additive-constant conclusion.  The split corresponds to the two steps in
[Hohenberg1964], Part I, section 1, immediately before and in equations (5)--(8).
-/
theorem VariationalDensityModel.potentialEquivalentModuloConstant_of_same_strictGroundStateDensity
    {State Density Position : Type*}
    {model : VariationalDensityModel State Density (Position → ℝ)}
    {potential₁ potential₂ : Position → ℝ} {state₁ state₂ : State}
    (hshared : model.SharedGroundStateDeterminesPotentialModuloConstant)
    (hstate₁ : model.IsStrictGroundState potential₁ state₁)
    (hstate₂ : model.IsStrictGroundState potential₂ state₂)
    (hdensity : model.density state₁ = model.density state₂) :
    PotentialEquivalentModuloConstant potential₁ potential₂ := by
  by_cases hstates : state₁ = state₂
  · subst state₂
    exact hshared potential₁ potential₂ state₁
      hstate₁.isGroundState hstate₂.isGroundState
  · exact False.elim ((model.density_ne_of_strictGroundStates hstate₁ hstate₂ hstates) hdensity)

end ProjectKoios.DensityFunctionalTheory.Foundations

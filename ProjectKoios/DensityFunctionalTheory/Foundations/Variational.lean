/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Abstract zero-temperature density variational models

This module isolates the variational algebra used by the first Hohenberg--Kohn argument.  A model
supplies a state-to-density map, an internal energy, and an external-potential energy depending only
on the density.  No continuum function space, Coulomb Hamiltonian, representability condition,
existence theorem, or Kohn--Sham approximation is asserted here.

The central result is the strict-ground-state contradiction: two distinct strict minimizers for two
external potentials cannot have the same density.  This is the exact inequality mechanism used in
[Hohenberg1964], Part I, section 1, equations (5)--(8).  The declaration is an adaptation to an
explicit abstract variational interface, not a formalization of their continuum electron-gas model.

## References

* [Hohenberg1964] P. Hohenberg and W. Kohn, “Inhomogeneous Electron Gas,” *Physical Review*
  136, B864--B871 (1964), DOI: `10.1103/PhysRev.136.B864`; cited statement location: Part I,
  section 1, equations (5)--(8).
-/

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.Foundations

/--
`DFT-VARIATIONAL-DEF-001`: abstract real-valued density variational data.

`State` is understood modulo any physically irrelevant state equivalence needed by a concrete
model, such as an overall wavefunction phase.  That quotient is deliberately not chosen here.
-/
structure VariationalDensityModel (State Density Potential : Type*) where
  /-- Density represented by a state. -/
  density : State → Density
  /-- Potential-independent internal energy of a state. -/
  internalEnergy : State → ℝ
  /-- Energy pairing between an external potential and a density. -/
  externalEnergy : Potential → Density → ℝ

variable {State Density Potential : Type*}

/-- `DFT-VARIATIONAL-DEF-002`: total energy in an external potential. -/
def VariationalDensityModel.totalEnergy
    (model : VariationalDensityModel State Density Potential)
    (potential : Potential) (state : State) : ℝ :=
  model.internalEnergy state + model.externalEnergy potential (model.density state)

/-- `DFT-VARIATIONAL-DEF-003`: a state minimizes total energy over the supplied state carrier. -/
def VariationalDensityModel.IsGroundState
    (model : VariationalDensityModel State Density Potential)
    (potential : Potential) (state : State) : Prop :=
  ∀ trial, model.totalEnergy potential state ≤ model.totalEnergy potential trial

/--
`DFT-VARIATIONAL-DEF-004`: a state has strictly smaller energy than every distinct supplied state.
-/
def VariationalDensityModel.IsStrictGroundState
    (model : VariationalDensityModel State Density Potential)
    (potential : Potential) (state : State) : Prop :=
  ∀ trial, trial ≠ state →
    model.totalEnergy potential state < model.totalEnergy potential trial

/-- `DFT-VARIATIONAL-LEM-001`: a strict ground state is a ground state. -/
lemma VariationalDensityModel.IsStrictGroundState.isGroundState
    {model : VariationalDensityModel State Density Potential}
    {potential : Potential} {state : State}
    (hstate : model.IsStrictGroundState potential state) :
    model.IsGroundState potential state := by
  intro trial
  by_cases htrial : trial = state
  · subst trial
    exact le_rfl
  · exact (hstate trial htrial).le

/--
`DFT-VARIATIONAL-THM-001`: distinct strict ground states for two external potentials have different
densities.

When equal densities are assumed, both external-energy terms cancel from the two strict
variational inequalities.  The remaining inequalities say simultaneously that each internal energy
is strictly smaller than the other.  This proof adapts [Hohenberg1964], Part I, section 1,
equations (5)--(8), while leaving its continuum-model hypotheses outside this declaration.
-/
theorem VariationalDensityModel.density_ne_of_strictGroundStates
    {model : VariationalDensityModel State Density Potential}
    {potential₁ potential₂ : Potential} {state₁ state₂ : State}
    (hstate₁ : model.IsStrictGroundState potential₁ state₁)
    (hstate₂ : model.IsStrictGroundState potential₂ state₂)
    (hstates : state₁ ≠ state₂) :
    model.density state₁ ≠ model.density state₂ := by
  intro hdensity
  have h₁ := hstate₁ state₂ hstates.symm
  have h₂ := hstate₂ state₁ hstates
  simp only [VariationalDensityModel.totalEnergy] at h₁ h₂
  rw [hdensity] at h₁ h₂
  linarith

end ProjectKoios.DensityFunctionalTheory.Foundations

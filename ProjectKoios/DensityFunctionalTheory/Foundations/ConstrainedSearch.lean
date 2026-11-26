/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.Foundations.Variational
public import Mathlib.Algebra.Order.Archimedean.Real.Basic
import Mathlib.Tactic.Linarith

/-!
# Abstract Levy--Lieb constrained search

This module defines the universal constrained-search energy as the real infimum of the internal
energies of states representing one fixed density. Its domain is the subtype of densities in the
image of the supplied state-to-density map. Because `ℝ` is conditionally complete, infimum
elimination also requires a lower bound; the ground-state hypotheses provide that bound.

The two principal results are the abstract outer variational lower bound and equality at a supplied
ground-state density.  They adapt [Levy1979], equation (5), Theorems I and II, equations (6)--(7),
and proofs (8)--(21).  The infimum formulation and explicit representable-density domain follow the
mathematical distinction emphasized in [Lieb1983], Section 3, equations (3.14)--(3.15).

The abstract model does not choose a continuum state space or Coulomb domain. In particular,
`constrainedSearchEnergy` is an infimum; attainment requires the separate
`IsConstrainedSearchMinimizer` hypothesis.

## References

* [Levy1979] M. Levy, “Universal Variational Functionals of Electron Densities, First-Order
  Density Matrices, and Natural Spin-Orbitals and Solution of the v-Representability Problem,”
  *Proceedings of the National Academy of Sciences USA* 76, 6062--6065 (1979), DOI:
  `10.1073/pnas.76.12.6062`; cited statement locations: equation (5), Theorems I and II,
  equations (6)--(7), with proofs in equations (8)--(21).
* [Lieb1983] E. H. Lieb, “Density Functionals for Coulomb Systems,” *International Journal of
  Quantum Chemistry* 24, 243--277 (1983), DOI: `10.1002/qua.560240302`; cited statement
  locations: Section 3, equations (3.14)--(3.15), and Theorem 3.3 for the separate continuum
  attainment result not proved here.
-/

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.Foundations

variable {State Density Potential : Type*}

/-- `DFT-CONSTRAINED-DEF-001`: a density is represented by at least one supplied state. -/
def VariationalDensityModel.IsRepresentable
    (model : VariationalDensityModel State Density Potential) (density : Density) : Prop :=
  ∃ state, model.density state = density

/-- `DFT-CONSTRAINED-DEF-002`: the subtype of densities represented by supplied states. -/
def VariationalDensityModel.RepresentableDensity
    (model : VariationalDensityModel State Density Potential) :=
  { density // model.IsRepresentable density }

/-- `DFT-CONSTRAINED-DEF-003`: internal energies of all states representing one density. -/
def VariationalDensityModel.internalEnergyFiber
    (model : VariationalDensityModel State Density Potential) (density : Density) : Set ℝ :=
  { energy | ∃ state, model.density state = density ∧ model.internalEnergy state = energy }

/--
`DFT-CONSTRAINED-DEF-004`: the constrained-search infimum at a representable density.

This is an abstract infimum-based adaptation of [Levy1979], equation (5), and [Lieb1983],
equation (3.14).  Levy writes a minimum; this definition deliberately makes no attainment claim.
Lemmas using its order-theoretic infimum property state or derive boundedness below explicitly.
-/
noncomputable def VariationalDensityModel.constrainedSearchEnergy
    (model : VariationalDensityModel State Density Potential)
    (density : model.RepresentableDensity) : ℝ :=
  sInf (model.internalEnergyFiber density.1)

/--
`DFT-CONSTRAINED-DEF-005`: outer density energy in one external potential.

The sum is the abstract quantity varied in [Levy1979], equations (6)--(7), and [Lieb1983],
equation (3.15); the external term remains a supplied model function here.
-/
noncomputable def VariationalDensityModel.densityTotalEnergy
    (model : VariationalDensityModel State Density Potential)
    (potential : Potential) (density : model.RepresentableDensity) : ℝ :=
  model.constrainedSearchEnergy density + model.externalEnergy potential density.1

/--
`DFT-CONSTRAINED-DEF-006`: a state attains the internal-energy minimum in one density fiber.

This predicate asserts attainment; `constrainedSearchEnergy` itself remains defined by an infimum.
-/
def VariationalDensityModel.IsConstrainedSearchMinimizer
    (model : VariationalDensityModel State Density Potential)
    (density : model.RepresentableDensity) (state : State) : Prop :=
  model.density state = density.1 ∧
    ∀ trial, model.density trial = density.1 →
      model.internalEnergy state ≤ model.internalEnergy trial

/-- `DFT-CONSTRAINED-DEF-007`: the representable density carried by a supplied state. -/
def VariationalDensityModel.representableDensityOfState
    (model : VariationalDensityModel State Density Potential) (state : State) :
    model.RepresentableDensity :=
  ⟨model.density state, ⟨state, rfl⟩⟩

/-- `DFT-CONSTRAINED-LEM-001`: a representable density has a nonempty energy fiber. -/
lemma VariationalDensityModel.internalEnergyFiber_nonempty
    {model : VariationalDensityModel State Density Potential}
    (density : model.RepresentableDensity) :
    (model.internalEnergyFiber density.1).Nonempty := by
  obtain ⟨state, hstate⟩ := density.2
  exact ⟨model.internalEnergy state, state, hstate, rfl⟩

/--
`DFT-CONSTRAINED-LEM-002`: every state in a bounded-below density fiber bounds its constrained-search
infimum from above.
-/
lemma VariationalDensityModel.constrainedSearchEnergy_le_internalEnergy
    {model : VariationalDensityModel State Density Potential}
    (density : model.RepresentableDensity)
    (hbdd : BddBelow (model.internalEnergyFiber density.1))
    {state : State} (hstate : model.density state = density.1) :
    model.constrainedSearchEnergy density ≤ model.internalEnergy state := by
  rw [VariationalDensityModel.constrainedSearchEnergy]
  exact csInf_le hbdd ⟨state, hstate, rfl⟩

/--
`DFT-CONSTRAINED-LEM-003`: a supplied ground state gives a lower bound on every representable
internal-energy fiber.
-/
lemma VariationalDensityModel.IsGroundState.internalEnergyFiber_bddBelow
    {model : VariationalDensityModel State Density Potential}
    {potential : Potential} {state : State}
    (hstate : model.IsGroundState potential state)
    (density : model.RepresentableDensity) :
    BddBelow (model.internalEnergyFiber density.1) := by
  refine ⟨model.totalEnergy potential state - model.externalEnergy potential density.1, ?_⟩
  intro energy henergy
  obtain ⟨trial, hdensity, rfl⟩ := henergy
  have htrial := hstate trial
  simp only [VariationalDensityModel.totalEnergy] at htrial ⊢
  rw [hdensity] at htrial
  linarith

/--
`DFT-CONSTRAINED-LEM-004`: a ground state minimizes internal energy among states with its density.
-/
lemma VariationalDensityModel.IsGroundState.isConstrainedSearchMinimizer
    {model : VariationalDensityModel State Density Potential}
    {potential : Potential} {state : State}
    (hstate : model.IsGroundState potential state) :
    model.IsConstrainedSearchMinimizer (model.representableDensityOfState state) state := by
  refine ⟨rfl, ?_⟩
  intro trial hdensity
  change model.density trial = model.density state at hdensity
  have htrial := hstate trial
  simp only [VariationalDensityModel.totalEnergy] at htrial
  rw [hdensity] at htrial
  linarith

/--
`DFT-CONSTRAINED-LEM-005`: an attained constrained-search minimizer has internal energy equal to the
fiber infimum.
-/
lemma VariationalDensityModel.constrainedSearchEnergy_eq_internalEnergy_of_minimizer
    {model : VariationalDensityModel State Density Potential}
    {density : model.RepresentableDensity} {state : State}
    (hstate : model.IsConstrainedSearchMinimizer density state) :
    model.constrainedSearchEnergy density = model.internalEnergy state := by
  rw [VariationalDensityModel.constrainedSearchEnergy]
  apply le_antisymm
  · apply csInf_le
    · refine ⟨model.internalEnergy state, ?_⟩
      intro energy henergy
      obtain ⟨trial, hdensity, rfl⟩ := henergy
      exact hstate.2 trial hdensity
    · exact ⟨state, hstate.1, rfl⟩
  · apply le_csInf (model.internalEnergyFiber_nonempty density)
    intro energy henergy
    obtain ⟨trial, hdensity, rfl⟩ := henergy
    exact hstate.2 trial hdensity

/--
`DFT-CONSTRAINED-THM-001`: the energy of a supplied ground state is a lower bound for the outer
density energy at every representable density.

This is the abstract constrained-search form of [Levy1979], Theorem I, equation (6).  The proof uses
the ordinary state variational inequality to bound every member of the fixed-density internal-energy
fiber, then takes its infimum.
-/
theorem VariationalDensityModel.IsGroundState.totalEnergy_le_densityTotalEnergy
    {model : VariationalDensityModel State Density Potential}
    {potential : Potential} {state : State}
    (hstate : model.IsGroundState potential state)
    (density : model.RepresentableDensity) :
    model.totalEnergy potential state ≤ model.densityTotalEnergy potential density := by
  have hlower :
      model.totalEnergy potential state - model.externalEnergy potential density.1 ≤
        model.constrainedSearchEnergy density := by
    rw [VariationalDensityModel.constrainedSearchEnergy]
    apply le_csInf (model.internalEnergyFiber_nonempty density)
    intro energy henergy
    obtain ⟨trial, hdensity, rfl⟩ := henergy
    have htrial := hstate trial
    simp only [VariationalDensityModel.totalEnergy] at htrial ⊢
    rw [hdensity] at htrial
    linarith
  simp only [VariationalDensityModel.densityTotalEnergy]
  linarith

/--
`DFT-CONSTRAINED-THM-002`: the outer density energy equals the ground-state energy at the supplied
ground-state density.

This is the abstract constrained-search form of [Levy1979], Theorem II, equation (7), and of the
variational identity in [Lieb1983], equation (3.15).  It proves no independent minimizer-existence
result: the supplied ground state itself witnesses the relevant density fiber.
-/
theorem VariationalDensityModel.IsGroundState.densityTotalEnergy_representableDensityOfState
    {model : VariationalDensityModel State Density Potential}
    {potential : Potential} {state : State}
    (hstate : model.IsGroundState potential state) :
    model.densityTotalEnergy potential (model.representableDensityOfState state) =
      model.totalEnergy potential state := by
  rw [VariationalDensityModel.densityTotalEnergy,
    model.constrainedSearchEnergy_eq_internalEnergy_of_minimizer
      hstate.isConstrainedSearchMinimizer]
  rfl

end ProjectKoios.DensityFunctionalTheory.Foundations

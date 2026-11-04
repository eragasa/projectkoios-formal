/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-06
-/
module

public import ProjectKoios.BandGauge.Alignment.UnitaryProcrustes

/-!
# Exact finite polar frame transport

This module turns supplied exact right-unitary Procrustes polar witnesses into neighbor, sequential,
and periodic-seam transport data. Every transport step acts on a column frame from the right,
preserves its ambient projector, and minimizes the corresponding exact squared Frobenius objective.
A known-gauge control recovers the target frame exactly and is unique under the identity positive
factor.

The module does not construct polar factors or singular-value decompositions from external arrays,
authenticate a momentum mesh or its ordering, choose a rank-deficient null-space completion, verify
runtime orthonormality, or prove stability of a computed transport. Periodic closure here is an exact
supplied seam witness, not evidence that an external transport loop closes.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate ComplexOrder Matrix Matrix.Norms.Frobenius

namespace ProjectKoios.BandGauge.Alignment

variable {Ambient Retained : Type*}
  [Fintype Ambient]
  [Fintype Retained] [DecidableEq Retained]

/-- `BG-ALIGNMENT-DEF-038`: an exact polar witness transporting one finite frame toward another. -/
abbrev NeighborPolarTransportWitness
    (source target : ComplexFrame Ambient Retained) :=
  RightUnitaryProcrustesPolarWitness source target

/-- `BG-ALIGNMENT-DEF-039`: the right-acting unitary selected by a supplied neighbor polar witness. -/
def polarTransportGauge
    {source target : ComplexFrame Ambient Retained}
    (witness : NeighborPolarTransportWitness source target) :
    Matrix.unitaryGroup Retained ℂ :=
  witness.minimizer

/-- `BG-ALIGNMENT-DEF-040`: transport a source frame by the supplied polar-minimizing right gauge. -/
def polarTransportFrame
    (source : ComplexFrame Ambient Retained)
    {target : ComplexFrame Ambient Retained}
    (witness : NeighborPolarTransportWitness source target) :
    ComplexFrame Ambient Retained :=
  rightUnitaryFrame source witness.minimizer

/-- `BG-ALIGNMENT-THM-072`: exact polar transport preserves frame orthonormality. -/
theorem polarTransportFrame_isOrthonormal
    (source target : ComplexFrame Ambient Retained)
    (witness : NeighborPolarTransportWitness source target)
    (hsource : IsOrthonormalFrame source) :
    IsOrthonormalFrame (polarTransportFrame source witness) := by
  exact rightUnitaryFrame_isOrthonormal source witness.minimizer hsource

/-- `BG-ALIGNMENT-THM-073`: exact polar transport preserves the ambient frame projector. -/
theorem frameProjector_polarTransportFrame
    (source target : ComplexFrame Ambient Retained)
    (witness : NeighborPolarTransportWitness source target) :
    frameProjector (polarTransportFrame source witness) = frameProjector source := by
  exact frameProjector_rightUnitaryFrame source witness.minimizer

/-- `BG-ALIGNMENT-THM-074`: the supplied polar transport gauge minimizes its neighbor objective. -/
theorem polarTransportGauge_objective_minimal
    (source target : ComplexFrame Ambient Retained)
    (witness : NeighborPolarTransportWitness source target)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    rightUnitaryProcrustesObjective source target witness.minimizer ≤
      rightUnitaryProcrustesObjective source target gauge := by
  exact witness.objective_minimal gauge

/-- `BG-ALIGNMENT-DEF-041`: exact polar witness for the control source `target * gauge`.
Its minimizer is the inverse gauge and its positive factor is the identity. -/
noncomputable def knownGaugeNeighborPolarWitness
    (target : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (htarget : IsOrthonormalFrame target) :
    NeighborPolarTransportWitness (rightUnitaryFrame target gauge) target where
  minimizer := gauge⁻¹
  positiveFactor := 1
  positiveSemidefinite := .one
  crossFactorization := by
    rw [rightUnitaryFrame, Matrix.conjTranspose_mul, Matrix.mul_assoc, htarget,
      Matrix.mul_one]
    simp [Matrix.star_eq_conjTranspose]

/-- `BG-ALIGNMENT-THM-075`: the known inverse polar transport exactly recovers the target frame. -/
theorem knownGauge_polarTransportFrame_eq
    (target : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (htarget : IsOrthonormalFrame target) :
    polarTransportFrame (rightUnitaryFrame target gauge)
        (knownGaugeNeighborPolarWitness target gauge htarget) = target := by
  simp only [polarTransportFrame, knownGaugeNeighborPolarWitness, rightUnitaryFrame]
  rw [Matrix.mul_assoc]
  simp

/-- `BG-ALIGNMENT-THM-076`: the exact known inverse is the unique minimizing gauge because the
control witness has positive-definite identity factor. -/
theorem knownGaugeNeighborPolarWitness_unique
    (target : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (htarget : IsOrthonormalFrame target)
    (competitor : Matrix.unitaryGroup Retained ℂ)
    (heq :
      rightUnitaryProcrustesObjective (rightUnitaryFrame target gauge) target competitor =
        rightUnitaryProcrustesObjective (rightUnitaryFrame target gauge) target
          (knownGaugeNeighborPolarWitness target gauge htarget).minimizer) :
    competitor = (knownGaugeNeighborPolarWitness target gauge htarget).minimizer := by
  apply RightUnitaryProcrustesPolarWitness.eq_minimizer_of_objective_eq
    (knownGaugeNeighborPolarWitness target gauge htarget) Matrix.PosDef.one competitor heq

/-- `BG-ALIGNMENT-DEF-042`: exact sequential transport over `steps + 1` ordered frames.
Each noninitial transported frame is obtained from the raw frame at that index by a supplied polar
witness targeting the previously transported frame. -/
structure FiniteSequentialPolarTransport {steps : ℕ}
    (frame : Fin (steps + 1) → ComplexFrame Ambient Retained) where
  transported : Fin (steps + 1) → ComplexFrame Ambient Retained
  initial : transported 0 = frame 0
  witness : ∀ i : Fin steps,
    NeighborPolarTransportWitness (frame i.succ) (transported i.castSucc)
  step : ∀ i : Fin steps,
    transported i.succ = polarTransportFrame (frame i.succ) (witness i)

/-- `BG-ALIGNMENT-THM-077`: sequential polar transport preserves orthonormality at every index. -/
theorem FiniteSequentialPolarTransport.isOrthonormal
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    (transport : FiniteSequentialPolarTransport frame)
    (hframe : ∀ k, IsOrthonormalFrame (frame k)) :
    ∀ k, IsOrthonormalFrame (transport.transported k) := by
  intro k
  refine Fin.cases ?_ (fun i => ?_) k
  · rw [transport.initial]
    exact hframe 0
  · rw [transport.step i]
    exact rightUnitaryFrame_isOrthonormal _ _ (hframe i.succ)

/-- `BG-ALIGNMENT-THM-078`: each noninitial transported frame has the raw frame's projector. -/
theorem FiniteSequentialPolarTransport.frameProjector_step
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    (transport : FiniteSequentialPolarTransport frame)
    (i : Fin steps) :
    frameProjector (transport.transported i.succ) = frameProjector (frame i.succ) := by
  rw [transport.step]
  exact frameProjector_rightUnitaryFrame _ _

/-- `BG-ALIGNMENT-THM-079`: every sequential step uses a pointwise objective minimizer. -/
theorem FiniteSequentialPolarTransport.step_objective_minimal
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    (transport : FiniteSequentialPolarTransport frame)
    (i : Fin steps)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    rightUnitaryProcrustesObjective (frame i.succ) (transport.transported i.castSucc)
        (transport.witness i).minimizer ≤
      rightUnitaryProcrustesObjective (frame i.succ) (transport.transported i.castSucc) gauge := by
  exact (transport.witness i).objective_minimal gauge

/-- `BG-ALIGNMENT-DEF-043`: supplied exact polar closure witness from the transported endpoint back
to the transported initial frame. -/
structure PeriodicPolarClosure
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    (transport : FiniteSequentialPolarTransport frame) where
  witness : NeighborPolarTransportWitness
    (transport.transported (Fin.last steps)) (transport.transported 0)

/-- `BG-ALIGNMENT-DEF-044`: the right-unitary seam-closure gauge. -/
def periodicClosureGauge
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    {transport : FiniteSequentialPolarTransport frame}
    (closure : PeriodicPolarClosure transport) : Matrix.unitaryGroup Retained ℂ :=
  closure.witness.minimizer

/-- `BG-ALIGNMENT-DEF-045`: the endpoint frame after applying the supplied periodic closure gauge. -/
def periodicClosureFrame
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    {transport : FiniteSequentialPolarTransport frame}
    (closure : PeriodicPolarClosure transport) : ComplexFrame Ambient Retained :=
  polarTransportFrame (transport.transported (Fin.last steps)) closure.witness

/-- `BG-ALIGNMENT-THM-080`: periodic seam closure preserves endpoint orthonormality. -/
theorem PeriodicPolarClosure.frame_isOrthonormal
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    {transport : FiniteSequentialPolarTransport frame}
    (closure : PeriodicPolarClosure transport)
    (hendpoint : IsOrthonormalFrame (transport.transported (Fin.last steps))) :
    IsOrthonormalFrame (periodicClosureFrame closure) := by
  exact polarTransportFrame_isOrthonormal _ _ closure.witness hendpoint

/-- `BG-ALIGNMENT-THM-081`: periodic seam closure preserves the transported endpoint projector. -/
theorem PeriodicPolarClosure.frameProjector_eq
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    {transport : FiniteSequentialPolarTransport frame}
    (closure : PeriodicPolarClosure transport) :
    frameProjector (periodicClosureFrame closure) =
      frameProjector (transport.transported (Fin.last steps)) := by
  exact frameProjector_polarTransportFrame _ _ closure.witness

/-- `BG-ALIGNMENT-THM-082`: the periodic closure gauge minimizes the exact endpoint-to-initial seam
objective. -/
theorem PeriodicPolarClosure.objective_minimal
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    {transport : FiniteSequentialPolarTransport frame}
    (closure : PeriodicPolarClosure transport)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    rightUnitaryProcrustesObjective
        (transport.transported (Fin.last steps)) (transport.transported 0)
        closure.witness.minimizer ≤
      rightUnitaryProcrustesObjective
        (transport.transported (Fin.last steps)) (transport.transported 0) gauge := by
  exact closure.witness.objective_minimal gauge

/-- `BG-ALIGNMENT-THM-099`: if the transported endpoint is exactly a right-unitary gauge of the
initial frame, then every supplied polar seam minimizer closes the frame exactly. -/
theorem PeriodicPolarClosure.frame_eq_initial_of_knownGauge
    {steps : ℕ}
    {frame : Fin (steps + 1) → ComplexFrame Ambient Retained}
    {transport : FiniteSequentialPolarTransport frame}
    (closure : PeriodicPolarClosure transport)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (hinitial : IsOrthonormalFrame (transport.transported 0))
    (hendpoint : transport.transported (Fin.last steps) =
      rightUnitaryFrame (transport.transported 0) gauge) :
    periodicClosureFrame closure = transport.transported 0 := by
  let seamGauge : Matrix.unitaryGroup Retained ℂ := closure.witness.minimizer
  let known := knownGaugeNeighborPolarWitness (transport.transported 0) gauge hinitial
  have hknownZero :
      rightUnitaryProcrustesObjective
          (rightUnitaryFrame (transport.transported 0) gauge) (transport.transported 0)
          known.minimizer = 0 := by
    rw [rightUnitaryProcrustesObjective,
      show rightUnitaryFrame (rightUnitaryFrame (transport.transported 0) gauge)
          known.minimizer = transport.transported 0 by
        exact knownGauge_polarTransportFrame_eq (transport.transported 0) gauge hinitial]
    simp [frobeniusPower]
  have hclosureNonneg :
      0 ≤ rightUnitaryProcrustesObjective
        (transport.transported (Fin.last steps)) (transport.transported 0)
        seamGauge := by
    rw [rightUnitaryProcrustesObjective, frobeniusPower_eq_sum]
    positivity
  have hclosureLe := closure.objective_minimal known.minimizer
  change rightUnitaryProcrustesObjective
      (transport.transported (Fin.last steps)) (transport.transported 0) seamGauge ≤
    rightUnitaryProcrustesObjective
      (transport.transported (Fin.last steps)) (transport.transported 0) known.minimizer at hclosureLe
  have hobjectiveEq :
      rightUnitaryProcrustesObjective
          (rightUnitaryFrame (transport.transported 0) gauge) (transport.transported 0)
          seamGauge =
        rightUnitaryProcrustesObjective
          (rightUnitaryFrame (transport.transported 0) gauge) (transport.transported 0)
          known.minimizer := by
    rw [hknownZero]
    rw [hendpoint] at hclosureNonneg hclosureLe
    nlinarith
  have hgauge : seamGauge = known.minimizer := by
    exact knownGaugeNeighborPolarWitness_unique (transport.transported 0) gauge hinitial
      seamGauge hobjectiveEq
  change rightUnitaryFrame (transport.transported (Fin.last steps)) seamGauge =
    transport.transported 0
  rw [hendpoint, hgauge]
  exact knownGauge_polarTransportFrame_eq (transport.transported 0) gauge hinitial

end ProjectKoios.BandGauge.Alignment

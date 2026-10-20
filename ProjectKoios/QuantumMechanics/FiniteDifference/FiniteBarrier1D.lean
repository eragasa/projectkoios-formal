/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDifference.ConstantPotential1D

/-!
# Symbolic finite barrier on the integer lattice

A finite barrier is represented by three symbolic constant regions on `ℤ`: a left lead, a barrier
of natural-number width, and a right lead.  The barrier transfer matrix is an exact power of the
one-site constant-region transfer matrix.  This module fixes no numerical parameters and retains no
calculation output.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-BARRIER-DEF-001`: piecewise-constant left/barrier/right lattice potential. -/
def finiteBarrierPotential
    (leftPotential barrierPotential rightPotential : ℂ) (width : ℕ) (n : ℤ) : ℂ :=
  if n < 0 then leftPotential
  else if n < Int.ofNat width then barrierPotential
  else rightPotential

/-- `QM-BARRIER-THM-001`: the declared potential equals the left-lead value left of the barrier. -/
theorem finiteBarrierPotential_eq_left
    (leftPotential barrierPotential rightPotential : ℂ) (width : ℕ) (n : ℤ)
    (hn : n < 0) :
    finiteBarrierPotential leftPotential barrierPotential rightPotential width n = leftPotential := by
  unfold finiteBarrierPotential
  rw [ite_eq_left hn]

/-- `QM-BARRIER-THM-002`: the declared potential equals the barrier value on its finite support. -/
theorem finiteBarrierPotential_eq_barrier
    (leftPotential barrierPotential rightPotential : ℂ) (width : ℕ) (n : ℤ)
    (hn0 : 0 ≤ n) (hnw : n < Int.ofNat width) :
    finiteBarrierPotential leftPotential barrierPotential rightPotential width n =
      barrierPotential := by
  unfold finiteBarrierPotential
  rw [ite_eq_right (not_lt.mpr hn0), ite_eq_left hnw]

/-- `QM-BARRIER-THM-003`: the declared potential equals the right-lead value after the barrier. -/
theorem finiteBarrierPotential_eq_right
    (leftPotential barrierPotential rightPotential : ℂ) (width : ℕ) (n : ℤ)
    (hnw : Int.ofNat width ≤ n) :
    finiteBarrierPotential leftPotential barrierPotential rightPotential width n = rightPotential := by
  have hn0 : 0 ≤ n := le_trans (Int.natCast_nonneg width) hnw
  unfold finiteBarrierPotential
  rw [ite_eq_right (not_lt.mpr hn0), ite_eq_right (not_lt.mpr hnw)]

/-- `QM-BARRIER-DEF-002`: exact lattice residual for the piecewise-constant finite barrier. -/
def finiteBarrierResidualAt
    (leftPotential barrierPotential rightPotential energy : ℂ)
    (width : ℕ) (ψ : ℤ → ℂ) (n : ℤ) : ℂ :=
  negativeSecondDifferenceAt ψ n +
    (finiteBarrierPotential leftPotential barrierPotential rightPotential width n - energy) * ψ n

/-- `QM-BARRIER-THM-004`: on the left lead, the barrier residual is the left constant residual. -/
theorem finiteBarrierResidualAt_eq_leftConstant
    (leftPotential barrierPotential rightPotential energy : ℂ)
    (width : ℕ) (ψ : ℤ → ℂ) (n : ℤ) (hn : n < 0) :
    finiteBarrierResidualAt leftPotential barrierPotential rightPotential energy width ψ n =
      constantPotentialResidualAt leftPotential energy ψ n := by
  simp [finiteBarrierResidualAt, constantPotentialResidualAt,
    finiteBarrierPotential_eq_left leftPotential barrierPotential rightPotential width n hn]

/-- `QM-BARRIER-THM-005`: inside the barrier, its residual is the barrier constant residual. -/
theorem finiteBarrierResidualAt_eq_barrierConstant
    (leftPotential barrierPotential rightPotential energy : ℂ)
    (width : ℕ) (ψ : ℤ → ℂ) (n : ℤ)
    (hn0 : 0 ≤ n) (hnw : n < Int.ofNat width) :
    finiteBarrierResidualAt leftPotential barrierPotential rightPotential energy width ψ n =
      constantPotentialResidualAt barrierPotential energy ψ n := by
  simp [finiteBarrierResidualAt, constantPotentialResidualAt,
    finiteBarrierPotential_eq_barrier leftPotential barrierPotential rightPotential width n hn0 hnw]

/-- `QM-BARRIER-THM-006`: on the right lead, the barrier residual is the right constant residual. -/
theorem finiteBarrierResidualAt_eq_rightConstant
    (leftPotential barrierPotential rightPotential energy : ℂ)
    (width : ℕ) (ψ : ℤ → ℂ) (n : ℤ) (hnw : Int.ofNat width ≤ n) :
    finiteBarrierResidualAt leftPotential barrierPotential rightPotential energy width ψ n =
      constantPotentialResidualAt rightPotential energy ψ n := by
  simp [finiteBarrierResidualAt, constantPotentialResidualAt,
    finiteBarrierPotential_eq_right leftPotential barrierPotential rightPotential width n hnw]

/-- `QM-BARRIER-DEF-003`: exact transfer product through the finite barrier region. -/
noncomputable def finiteBarrierTransferMatrix (barrierPotential energy : ℂ) (width : ℕ) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  (constantRegionTransferMatrix barrierPotential energy) ^ width

/-- `QM-BARRIER-THM-007`: every finite barrier transfer product has determinant one. -/
theorem det_finiteBarrierTransferMatrix
    (barrierPotential energy : ℂ) (width : ℕ) :
    Matrix.det (finiteBarrierTransferMatrix barrierPotential energy width) = 1 := by
  rw [finiteBarrierTransferMatrix, Matrix.det_pow,
    det_constantRegionTransferMatrix, one_pow]

/--
`QM-BARRIER-THM-008`: a global lattice state satisfying the exact recurrence on every barrier site
is propagated from the left interface to the right interface by the symbolic barrier transfer
product.
-/
theorem transferState_barrierWidth_eq_finiteBarrierTransferMatrix_mulVec
    (leftPotential barrierPotential rightPotential energy : ℂ)
    (width : ℕ) (ψ : ℤ → ℂ)
    (hres : ∀ m < width,
      finiteBarrierResidualAt leftPotential barrierPotential rightPotential energy width ψ
        (Int.ofNat m) = 0) :
    transferState ψ (Int.ofNat width) =
      Matrix.mulVec (finiteBarrierTransferMatrix barrierPotential energy width)
        (transferState ψ 0) := by
  apply transferState_natCast_eq_pow_mulVec
  intro m hm
  rw [← finiteBarrierResidualAt_eq_barrierConstant
    leftPotential barrierPotential rightPotential energy width ψ (Int.ofNat m)]
  · exact hres m hm
  · exact Int.natCast_nonneg m
  · exact Int.ofNat_lt.mpr hm

/-- `QM-BARRIER-THM-009`: symbolic reciprocal-character amplitudes solve the left-lead recurrence. -/
theorem finiteBarrierResidualAt_leftBidirectionalMode_eq_zero
    (leftPotential barrierPotential rightPotential energy forwardAmplitude backwardAmplitude z : ℂ)
    (width : ℕ) (hz : z ≠ 0)
    (hdisp : SatisfiesConstantRegionDispersion leftPotential energy z)
    (n : ℤ) (hn : n < 0) :
    finiteBarrierResidualAt leftPotential barrierPotential rightPotential energy width
        (bidirectionalExponentialMode forwardAmplitude backwardAmplitude z) n = 0 := by
  rw [finiteBarrierResidualAt_eq_leftConstant
    leftPotential barrierPotential rightPotential energy width _ n hn]
  exact constantPotentialResidualAt_bidirectionalExponentialMode_eq_zero
    leftPotential energy forwardAmplitude backwardAmplitude z hz hdisp n

/-- `QM-BARRIER-THM-010`: symbolic reciprocal-character amplitudes solve the barrier recurrence. -/
theorem finiteBarrierResidualAt_barrierBidirectionalMode_eq_zero
    (leftPotential barrierPotential rightPotential energy forwardAmplitude backwardAmplitude z : ℂ)
    (width : ℕ) (hz : z ≠ 0)
    (hdisp : SatisfiesConstantRegionDispersion barrierPotential energy z)
    (n : ℤ) (hn0 : 0 ≤ n) (hnw : n < Int.ofNat width) :
    finiteBarrierResidualAt leftPotential barrierPotential rightPotential energy width
        (bidirectionalExponentialMode forwardAmplitude backwardAmplitude z) n = 0 := by
  rw [finiteBarrierResidualAt_eq_barrierConstant
    leftPotential barrierPotential rightPotential energy width _ n hn0 hnw]
  exact constantPotentialResidualAt_bidirectionalExponentialMode_eq_zero
    barrierPotential energy forwardAmplitude backwardAmplitude z hz hdisp n

/-- `QM-BARRIER-THM-011`: symbolic reciprocal-character amplitudes solve the right-lead recurrence. -/
theorem finiteBarrierResidualAt_rightBidirectionalMode_eq_zero
    (leftPotential barrierPotential rightPotential energy forwardAmplitude backwardAmplitude z : ℂ)
    (width : ℕ) (hz : z ≠ 0)
    (hdisp : SatisfiesConstantRegionDispersion rightPotential energy z)
    (n : ℤ) (hnw : Int.ofNat width ≤ n) :
    finiteBarrierResidualAt leftPotential barrierPotential rightPotential energy width
        (bidirectionalExponentialMode forwardAmplitude backwardAmplitude z) n = 0 := by
  rw [finiteBarrierResidualAt_eq_rightConstant
    leftPotential barrierPotential rightPotential energy width _ n hnw]
  exact constantPotentialResidualAt_bidirectionalExponentialMode_eq_zero
    rightPotential energy forwardAmplitude backwardAmplitude z hz hdisp n

end ProjectKoios.QuantumMechanics.FiniteDifference

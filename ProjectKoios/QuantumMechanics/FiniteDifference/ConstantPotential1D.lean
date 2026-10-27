/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Data.Matrix.Reflection
public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.LinearCombination
public import ProjectKoios.QuantumMechanics.FiniteDifference.ExponentialMode1D

/-!
# Constant-potential lattice recurrence and transfer matrix

This module adds a constant onsite term to the source-neutral negative centered difference.  It
keeps the energy, potential, character root, and amplitudes symbolic.  No finite mesh, floating-
point evaluation, scattering convention, or retained calculation is selected.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-CONSTANT-REGION-DEF-001`: exact lattice Schrödinger residual at one site. -/
def constantPotentialResidualAt (potential energy : ℂ) (ψ : ℤ → ℂ) (n : ℤ) : ℂ :=
  negativeSecondDifferenceAt ψ n + (potential - energy) * ψ n

/--
`QM-CONSTANT-REGION-THM-001`: a lattice character has the exact constant-region residual
coefficient `2-z⁻¹-z+V-E`.
-/
theorem constantPotentialResidualAt_exponentialMode
    (potential energy z : ℂ) (hz : z ≠ 0) (n : ℤ) :
    constantPotentialResidualAt potential energy (exponentialMode z) n =
      (2 - z⁻¹ - z + potential - energy) * exponentialMode z n := by
  rw [constantPotentialResidualAt, negativeSecondDifferenceAt_exponentialMode z hz n]
  ring

/-- `QM-CONSTANT-REGION-DEF-002`: dispersion relation for a constant lattice region. -/
def SatisfiesConstantRegionDispersion (potential energy z : ℂ) : Prop :=
  z + z⁻¹ = 2 + potential - energy

/-- `QM-CONSTANT-REGION-THM-002`: the dispersion relation makes the character residual vanish. -/
theorem constantPotentialResidualAt_exponentialMode_eq_zero
    (potential energy z : ℂ) (hz : z ≠ 0)
    (hdisp : SatisfiesConstantRegionDispersion potential energy z) (n : ℤ) :
    constantPotentialResidualAt potential energy (exponentialMode z) n = 0 := by
  rw [constantPotentialResidualAt_exponentialMode potential energy z hz n]
  have hcoeff : 2 - z⁻¹ - z + potential - energy = 0 := by
    unfold SatisfiesConstantRegionDispersion at hdisp
    calc
      2 - z⁻¹ - z + potential - energy =
          -(z + z⁻¹ - (2 + potential - energy)) := by ring
      _ = 0 := by rw [hdisp]; ring
  rw [hcoeff]
  exact zero_mul _

/-- `QM-CONSTANT-REGION-THM-003`: the reciprocal root satisfies the same dispersion relation. -/
theorem satisfiesConstantRegionDispersion_inv
    (potential energy z : ℂ)
    (hdisp : SatisfiesConstantRegionDispersion potential energy z) :
    SatisfiesConstantRegionDispersion potential energy z⁻¹ := by
  unfold SatisfiesConstantRegionDispersion at hdisp ⊢
  simpa [add_comm] using hdisp

/-- `QM-CONSTANT-REGION-LEM-001`: the constant-region residual is additive in the mode. -/
lemma constantPotentialResidualAt_add
    (potential energy : ℂ) (ψ φ : ℤ → ℂ) (n : ℤ) :
    constantPotentialResidualAt potential energy (fun m => ψ m + φ m) n =
      constantPotentialResidualAt potential energy ψ n +
        constantPotentialResidualAt potential energy φ n := by
  simp [constantPotentialResidualAt, negativeSecondDifferenceAt]
  ring

/-- `QM-CONSTANT-REGION-LEM-002`: the constant-region residual respects complex scaling. -/
lemma constantPotentialResidualAt_mul
    (potential energy c : ℂ) (ψ : ℤ → ℂ) (n : ℤ) :
    constantPotentialResidualAt potential energy (fun m => c * ψ m) n =
      c * constantPotentialResidualAt potential energy ψ n := by
  simp [constantPotentialResidualAt, negativeSecondDifferenceAt]
  ring

/-- `QM-CONSTANT-REGION-DEF-003`: incoming/reflected superposition of reciprocal characters. -/
noncomputable def bidirectionalExponentialMode
    (forwardAmplitude backwardAmplitude z : ℂ) (n : ℤ) : ℂ :=
  forwardAmplitude * exponentialMode z n +
    backwardAmplitude * exponentialMode z⁻¹ n

/--
`QM-CONSTANT-REGION-THM-004`: every symbolic superposition of reciprocal nonzero character roots
solves the constant-region recurrence.
-/
theorem constantPotentialResidualAt_bidirectionalExponentialMode_eq_zero
    (potential energy forwardAmplitude backwardAmplitude z : ℂ) (hz : z ≠ 0)
    (hdisp : SatisfiesConstantRegionDispersion potential energy z) (n : ℤ) :
    constantPotentialResidualAt potential energy
        (bidirectionalExponentialMode forwardAmplitude backwardAmplitude z) n = 0 := by
  rw [show bidirectionalExponentialMode forwardAmplitude backwardAmplitude z =
      fun m => forwardAmplitude * exponentialMode z m +
        backwardAmplitude * exponentialMode z⁻¹ m by rfl]
  rw [constantPotentialResidualAt_add, constantPotentialResidualAt_mul,
    constantPotentialResidualAt_mul,
    constantPotentialResidualAt_exponentialMode_eq_zero potential energy z hz hdisp,
    constantPotentialResidualAt_exponentialMode_eq_zero potential energy z⁻¹ (inv_ne_zero hz)
      (satisfiesConstantRegionDispersion_inv potential energy z hdisp)]
  ring

/-- `QM-TRANSFER-DEF-001`: one-site transfer matrix for a constant lattice region. -/
noncomputable def constantRegionTransferMatrix (potential energy : ℂ) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  !![2 + potential - energy, -1;
     1, 0]

/-- `QM-TRANSFER-DEF-002`: two-coordinate recurrence state `(ψₙ, ψₙ₋₁)`. -/
def transferState (ψ : ℤ → ℂ) (n : ℤ) : Fin 2 → ℂ :=
  ![ψ n, ψ (n - 1)]

/-- `QM-TRANSFER-DEF-003`: character transfer-state eigenvector `(z,1)`. -/
def characterTransferVector (z : ℂ) : Fin 2 → ℂ :=
  ![z, 1]

/-- `QM-TRANSFER-THM-001`: explicit one-step action of the constant-region transfer matrix. -/
theorem constantRegionTransferMatrix_mulVec_transferState
    (potential energy : ℂ) (ψ : ℤ → ℂ) (n : ℤ) :
    Matrix.mulVec (constantRegionTransferMatrix potential energy) (transferState ψ n) =
      ![(2 + potential - energy) * ψ n - ψ (n - 1), ψ n] := by
  ext i
  fin_cases i
  · simp [constantRegionTransferMatrix, transferState]
    ring
  · simp [constantRegionTransferMatrix, transferState]

/--
`QM-TRANSFER-THM-002`: a zero local residual advances the transfer state by exactly one lattice
site.
-/
theorem transferState_add_one_eq_mulVec_of_residual_eq_zero
    (potential energy : ℂ) (ψ : ℤ → ℂ) (n : ℤ)
    (hres : constantPotentialResidualAt potential energy ψ n = 0) :
    transferState ψ (n + 1) =
      Matrix.mulVec (constantRegionTransferMatrix potential energy) (transferState ψ n) := by
  rw [constantRegionTransferMatrix_mulVec_transferState]
  unfold constantPotentialResidualAt negativeSecondDifferenceAt at hres
  unfold transferState
  ext i
  fin_cases i
  · change ψ (n + 1) = (2 + potential - energy) * ψ n - ψ (n - 1)
    have hnext : ψ (n + 1) = (2 + potential - energy) * ψ n - ψ (n - 1) := by
      linear_combination -hres
    exact hnext
  · simp

/-- `QM-TRANSFER-THM-003`: every one-site constant-region transfer matrix has determinant one. -/
theorem det_constantRegionTransferMatrix (potential energy : ℂ) :
    Matrix.det (constantRegionTransferMatrix potential energy) = 1 := by
  simp [constantRegionTransferMatrix, Matrix.det_fin_two]

/--
`QM-TRANSFER-THM-004`: the constant-region dispersion relation makes `(z,1)` a transfer-matrix
eigenvector with eigenvalue `z`.
-/
theorem constantRegionTransferMatrix_mulVec_characterTransferVector
    (potential energy z : ℂ) (hz : z ≠ 0)
    (hdisp : SatisfiesConstantRegionDispersion potential energy z) :
    Matrix.mulVec (constantRegionTransferMatrix potential energy) (characterTransferVector z) =
      z • characterTransferVector z := by
  unfold SatisfiesConstantRegionDispersion at hdisp
  ext i
  fin_cases i
  · norm_num [constantRegionTransferMatrix, characterTransferVector, Matrix.mulVec,
      dotProduct, smul_eq_mul]
    rw [← hdisp, add_mul, inv_mul_cancel₀ hz]
    ring
  · norm_num [constantRegionTransferMatrix, characterTransferVector, Matrix.mulVec,
      dotProduct, smul_eq_mul]

/--
`QM-TRANSFER-THM-005`: exact propagation through any finite number of sites satisfying one
constant-region recurrence.
-/
theorem transferState_natCast_eq_pow_mulVec
    (potential energy : ℂ) (ψ : ℤ → ℂ) (steps : ℕ)
    (hres : ∀ m < steps,
      constantPotentialResidualAt potential energy ψ (Int.ofNat m) = 0) :
    transferState ψ (Int.ofNat steps) =
      Matrix.mulVec ((constantRegionTransferMatrix potential energy) ^ steps)
        (transferState ψ 0) := by
  induction steps with
  | zero => simp [transferState]
  | succ steps ih =>
      have hprefix : ∀ m < steps,
          constantPotentialResidualAt potential energy ψ (Int.ofNat m) = 0 := by
        intro m hm
        exact hres m (Nat.lt_succ_of_lt hm)
      have hih := ih hprefix
      have hstep := transferState_add_one_eq_mulVec_of_residual_eq_zero
        potential energy ψ (Int.ofNat steps) (hres steps (Nat.lt_succ_self steps))
      rw [show Int.ofNat (Nat.succ steps) = Int.ofNat steps + 1 by norm_num]
      rw [hstep, hih, pow_succ', ← Matrix.mulVec_mulVec]

end ProjectKoios.QuantumMechanics.FiniteDifference

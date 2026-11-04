/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-28
-/
module

public import ProjectKoios.BandGauge.Alignment.FiniteFrame
public import Mathlib.Analysis.CStarAlgebra.Matrix

/-!
# Approximate finite-frame compression

This module separates two exact error mechanisms for finite orthonormal frames.  First, nearby
frames give nearby retained compressions.  Second, differing retained projectors give a separate
ambient projector-sandwich term.  The norm in this file is Mathlib's matrix `L2Operator` norm,
transported from continuous linear maps on finite Euclidean spaces.

`frameCompressionLeakage` is the residual between the ambient action and the action reconstructed
from compression. For an exact orthonormal frame, its vanishing is equivalent to preservation of
the represented frame range. It is a defined exact quantity, not an assertion that runtime leakage
is small.

These results require exact orthonormality and a nonempty retained coordinate type.  They do not
authenticate numerical frames, prove a matrix-Frobenius estimate, order eigenvalues, verify an
external eigensolver, or establish physical or scientific adequacy.
-/

@[expose] public section

open scoped ComplexConjugate Matrix Matrix.Norms.L2Operator

namespace ProjectKoios.BandGauge.Projection

open ProjectKoios.BandGauge.Alignment

variable {Ambient Retained : Type*}
  [Fintype Ambient] [DecidableEq Ambient]
  [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]

omit [DecidableEq Ambient] in
/-- `BG-PROJECTION-LEM-001`: an exact orthonormal frame has matrix `L2Operator` norm at most one. -/
lemma frame_l2OperatorNorm_le_one
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    ‖frame‖ ≤ 1 := by
  have hsquare : ‖frame‖ * ‖frame‖ = 1 := by
    rw [← Matrix.l2_opNorm_conjTranspose_mul_self, hframe, norm_one]
  nlinarith [norm_nonneg frame]

omit [DecidableEq Ambient] [Fintype Retained] [DecidableEq Retained] [Nonempty Retained] in
/-- `BG-PROJECTION-LEM-002`: exact two-frame decomposition of a compression difference. -/
lemma compression_difference_decomposition
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) :
    compressOperator candidate operator - compressOperator reference operator =
      (candidate - reference)ᴴ * operator * candidate +
        referenceᴴ * operator * (candidate - reference) := by
  rw [compressOperator, compressOperator, Matrix.conjTranspose_sub]
  simp only [Matrix.sub_mul, Matrix.mul_sub, Matrix.mul_assoc]
  abel

/-- `BG-PROJECTION-THM-009`: two exact orthonormal frames have retained compressions separated by
at most twice the ambient operator norm times their frame mismatch. -/
theorem compression_difference_l2OperatorNorm_le
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    ‖compressOperator candidate operator - compressOperator reference operator‖ ≤
      2 * ‖operator‖ * ‖candidate - reference‖ := by
  rw [compression_difference_decomposition]
  calc
    ‖(candidate - reference)ᴴ * operator * candidate +
        referenceᴴ * operator * (candidate - reference)‖
        ≤ ‖(candidate - reference)ᴴ * operator * candidate‖ +
          ‖referenceᴴ * operator * (candidate - reference)‖ := norm_add_le _ _
    _ ≤ (‖(candidate - reference)ᴴ‖ * ‖operator‖) * ‖candidate‖ +
          (‖referenceᴴ‖ * ‖operator‖) * ‖candidate - reference‖ := by
      apply add_le_add
      · exact (Matrix.l2_opNorm_mul _ _).trans <|
          mul_le_mul_of_nonneg_right (Matrix.l2_opNorm_mul _ _) (norm_nonneg _)
      · exact (Matrix.l2_opNorm_mul _ _).trans <|
          mul_le_mul_of_nonneg_right (Matrix.l2_opNorm_mul _ _) (norm_nonneg _)
    _ = (‖candidate - reference‖ * ‖operator‖) * ‖candidate‖ +
          (‖reference‖ * ‖operator‖) * ‖candidate - reference‖ := by
      rw [Matrix.l2_opNorm_conjTranspose, Matrix.l2_opNorm_conjTranspose]
    _ ≤ (‖candidate - reference‖ * ‖operator‖) * 1 +
          (1 * ‖operator‖) * ‖candidate - reference‖ := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_left (frame_l2OperatorNorm_le_one candidate hcandidate)
          (mul_nonneg (norm_nonneg _) (norm_nonneg _))
      · exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_right (frame_l2OperatorNorm_le_one reference hreference)
            (norm_nonneg _)) (norm_nonneg _)
    _ = 2 * ‖operator‖ * ‖candidate - reference‖ := by ring

/-- `BG-PROJECTION-THM-010`: the approximate compression bound in the repository's frozen
right-unitary convention `F ↦ F U`, `H ↦ Uᴴ H U`. -/
theorem compression_rightUnitaryFrame_l2OperatorNorm_le
    (candidate reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    ‖compressOperator candidate operator -
        (gauge : Matrix Retained Retained ℂ)ᴴ * compressOperator reference operator *
          (gauge : Matrix Retained Retained ℂ)‖ ≤
      2 * ‖operator‖ * ‖candidate - rightUnitaryFrame reference gauge‖ := by
  rw [← compressOperator_rightUnitaryFrame]
  exact compression_difference_l2OperatorNorm_le candidate
    (rightUnitaryFrame reference gauge) operator hcandidate
    (rightUnitaryFrame_isOrthonormal reference gauge hreference)

/-- `BG-PROJECTION-DEF-012`: residual between the ambient action on a supplied frame and the
reconstructed compressed action. For a non-orthonormal matrix this is not, by itself, an
invariant-range criterion. -/
noncomputable def frameCompressionLeakage
    (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) : Matrix Ambient Retained ℂ :=
  operator * frame - frame * compressOperator frame operator

omit [DecidableEq Ambient] [DecidableEq Retained] [Nonempty Retained] in
/-- `BG-PROJECTION-LEM-003`: the reproduction residual rewrites using the frame product `F Fᴴ`.
That product is a projector only under exact frame orthonormality. -/
lemma frameCompressionLeakage_eq_projector_residual
    (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) :
    frameCompressionLeakage frame operator =
      operator * frame - frameProjector frame * operator * frame := by
  simp only [frameCompressionLeakage, compressOperator, frameProjector, Matrix.mul_assoc]

omit [DecidableEq Ambient] [DecidableEq Retained] [Nonempty Retained] in
/-- `BG-PROJECTION-THM-011`: the compressed-action reproduction residual vanishes exactly when
the compressed retained action reproduces the ambient action on the supplied matrix frame. -/
theorem frameCompressionLeakage_eq_zero_iff
    (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) :
    frameCompressionLeakage frame operator = 0 ↔
      operator * frame = frame * compressOperator frame operator := by
  simp [frameCompressionLeakage, sub_eq_zero]

omit [DecidableEq Ambient] [Nonempty Retained] in
/-- `BG-PROJECTION-THM-013`: for an exact orthonormal frame, vanishing compression leakage is
equivalent to preservation of its represented range, expressed by a retained action matrix. -/
theorem frameCompressionLeakage_eq_zero_iff_exists_retained_action
    (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hframe : IsOrthonormalFrame frame) :
    frameCompressionLeakage frame operator = 0 ↔
      ∃ retainedAction : Matrix Retained Retained ℂ,
        operator * frame = frame * retainedAction := by
  constructor
  · intro hzero
    exact ⟨compressOperator frame operator,
      (frameCompressionLeakage_eq_zero_iff frame operator).mp hzero⟩
  · rintro ⟨retainedAction, haction⟩
    apply (frameCompressionLeakage_eq_zero_iff frame operator).mpr
    have hcompress : compressOperator frame operator = retainedAction := by
      rw [compressOperator, Matrix.mul_assoc, haction, ← Matrix.mul_assoc, hframe,
        Matrix.one_mul]
    rw [hcompress]
    exact haction

omit [DecidableEq Ambient] [DecidableEq Retained] [Nonempty Retained] in
/-- `BG-PROJECTION-LEM-004`: exact decomposition of the ambient projector-sandwich mismatch. -/
lemma projector_sandwich_difference_decomposition
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) :
    frameProjector candidate * operator * frameProjector candidate -
        frameProjector reference * operator * frameProjector reference =
      (frameProjector candidate - frameProjector reference) * operator *
          frameProjector candidate +
        frameProjector reference * operator *
          (frameProjector candidate - frameProjector reference) := by
  simp only [Matrix.sub_mul, Matrix.mul_sub, Matrix.mul_assoc]
  abel

/-- `BG-PROJECTION-LEM-005`: an exact orthonormal-frame projector has matrix `L2Operator` norm at
most one. -/
lemma frameProjector_l2OperatorNorm_le_one
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    ‖frameProjector frame‖ ≤ 1 := by
  rw [frameProjector]
  calc
    ‖frame * frameᴴ‖ ≤ ‖frame‖ * ‖frameᴴ‖ := Matrix.l2_opNorm_mul _ _
    _ = ‖frame‖ * ‖frame‖ := by rw [Matrix.l2_opNorm_conjTranspose]
    _ = 1 := by
      rw [← Matrix.l2_opNorm_conjTranspose_mul_self, hframe, norm_one]

/-- `BG-PROJECTION-THM-012`: when retained subspaces differ, their reconstructed ambient
operators have a separate bound controlled by the projector mismatch. -/
theorem projector_sandwich_difference_l2OperatorNorm_le
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    ‖frameProjector candidate * operator * frameProjector candidate -
        frameProjector reference * operator * frameProjector reference‖ ≤
      2 * ‖operator‖ * ‖frameProjector candidate - frameProjector reference‖ := by
  rw [projector_sandwich_difference_decomposition]
  calc
    ‖(frameProjector candidate - frameProjector reference) * operator *
          frameProjector candidate +
        frameProjector reference * operator *
          (frameProjector candidate - frameProjector reference)‖
        ≤ ‖(frameProjector candidate - frameProjector reference) * operator *
            frameProjector candidate‖ +
          ‖frameProjector reference * operator *
            (frameProjector candidate - frameProjector reference)‖ := norm_add_le _ _
    _ ≤ (‖frameProjector candidate - frameProjector reference‖ * ‖operator‖) *
          ‖frameProjector candidate‖ +
        (‖frameProjector reference‖ * ‖operator‖) *
          ‖frameProjector candidate - frameProjector reference‖ := by
      apply add_le_add
      · exact (Matrix.l2_opNorm_mul _ _).trans <|
          mul_le_mul_of_nonneg_right (Matrix.l2_opNorm_mul _ _) (norm_nonneg _)
      · exact (Matrix.l2_opNorm_mul _ _).trans <|
          mul_le_mul_of_nonneg_right (Matrix.l2_opNorm_mul _ _) (norm_nonneg _)
    _ ≤ (‖frameProjector candidate - frameProjector reference‖ * ‖operator‖) * 1 +
        (1 * ‖operator‖) *
          ‖frameProjector candidate - frameProjector reference‖ := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_left
          (frameProjector_l2OperatorNorm_le_one candidate hcandidate)
          (mul_nonneg (norm_nonneg _) (norm_nonneg _))
      · exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_right
            (frameProjector_l2OperatorNorm_le_one reference hreference) (norm_nonneg _))
          (norm_nonneg _)
    _ = 2 * ‖operator‖ *
        ‖frameProjector candidate - frameProjector reference‖ := by ring

end ProjectKoios.BandGauge.Projection

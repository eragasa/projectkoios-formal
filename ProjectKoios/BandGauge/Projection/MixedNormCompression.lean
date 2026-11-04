/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-28
-/
module

public import ProjectKoios.BandGauge.Projection.ApproximateCompression

/-!
# Mixed Frobenius/operator-norm compression bounds

This module gives explicit names to Mathlib's entrywise matrix Frobenius norm and Euclidean
operator norm, proves the two mixed multiplication inequalities, and applies them to finite-frame
compression.  The principal estimate is

`‖Cᴴ H C - Fᴴ H F‖_F ≤ 2 ‖H‖op ‖C-F‖_F`,

with the repository's right-unitary specialization.  Separate Frobenius bounds control ambient
projector sandwiches and the candidate reproduction residual when an orthonormal reference frame
has zero residual.

All quantities are exact finite-dimensional values.  No runtime matrix, orthonormality check,
floating-point norm, eigensolver, DFT, Wannier90 result, or scientific adequacy claim is bound here.
-/

@[expose] public section

open scoped ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Projection

/-- `BG-PROJECTION-DEF-013`: entrywise matrix Frobenius norm with an explicit instance boundary. -/
noncomputable def matrixFrobeniusNorm {m n : Type*} [Fintype m] [Fintype n]
    (A : Matrix m n ℂ) : ℝ :=
  @norm (Matrix m n ℂ) Matrix.frobeniusNormedAddCommGroup.toNorm A

/-- `BG-PROJECTION-DEF-014`: Euclidean matrix operator norm with an explicit instance boundary. -/
noncomputable def matrixL2OperatorNorm {m n : Type*} [Fintype m] [Fintype n] [DecidableEq n]
    (A : Matrix m n ℂ) : ℝ :=
  @norm (Matrix m n ℂ) Matrix.instL2OpNormedAddCommGroup.toNorm A

local notation "frob" => matrixFrobeniusNorm
local notation "opn" => matrixL2OperatorNorm

/-- `BG-PROJECTION-LEM-006`: squared Frobenius norm is the sum of squared Euclidean column norms. -/
lemma frob_sq_eq_sum_col {m n : Type*} [Fintype m] [Fintype n]
    (A : Matrix m n ℂ) :
    frob A ^ 2 = ∑ j : n, ‖(EuclideanSpace.equiv m ℂ).symm (A · j)‖ ^ 2 := by
  change ‖WithLp.toLp 2 (fun i => WithLp.toLp 2 (fun j => A i j))‖ ^ 2 = _
  rw [PiLp.norm_sq_eq_of_L2]
  simp_rw [PiLp.norm_sq_eq_of_L2]
  rw [Finset.sum_comm]
  congr with j

/-- `BG-PROJECTION-LEM-007`: the explicitly bound Frobenius norm is nonnegative. -/
lemma frob_nonneg {m n : Type*} [Fintype m] [Fintype n]
    (A : Matrix m n ℂ) : 0 ≤ frob A := by
  exact @norm_nonneg (Matrix m n ℂ)
    (Matrix.frobeniusNormedAddCommGroup (m := m) (n := n) (α := ℂ)).toNormedAddGroup.toSeminormedAddGroup A

/-- `BG-PROJECTION-LEM-008`: the explicitly bound Euclidean operator norm is nonnegative. -/
lemma opn_nonneg {m n : Type*} [Fintype m] [Fintype n] [DecidableEq n]
    (A : Matrix m n ℂ) : 0 ≤ opn A := by
  exact @norm_nonneg (Matrix m n ℂ)
    (Matrix.instL2OpNormedAddCommGroup (𝕜 := ℂ) (m := m) (n := n)).toNormedAddGroup.toSeminormedAddGroup A

private lemma column_l2OperatorNorm_le {m : Type*} [Fintype m]
    (x : EuclideanSpace ℂ m) :
    opn (fun i (_ : Fin 1) => x i) ≤ ‖x‖ := by
  let B : Matrix m (Fin 1) ℂ := fun i _ => x i
  change @norm (Matrix m (Fin 1) ℂ)
      Matrix.instL2OpNormedAddCommGroup.toNorm B ≤ ‖x‖
  rw [Matrix.l2_opNorm_def]
  apply ContinuousLinearMap.opNorm_le_bound
    ((Matrix.toEuclideanLin (𝕜 := ℂ) (m := m) (n := Fin 1)).trans
      LinearMap.toContinuousLinearMap B) (norm_nonneg x)
  intro z
  change ‖(EuclideanSpace.equiv m ℂ).symm (B *ᵥ z)‖ ≤ ‖x‖ * ‖z‖
  have hz : ‖z 0‖ ≤ ‖z‖ := PiLp.norm_apply_le z 0
  have heq : (EuclideanSpace.equiv m ℂ).symm (B *ᵥ z) = z 0 • x := by
    ext i
    simp [B, Matrix.mulVec, dotProduct, mul_comm]
  rw [heq, norm_smul]
  nlinarith [norm_nonneg x]

private lemma frob_column {m : Type*} [Fintype m] (x : EuclideanSpace ℂ m) :
    frob (fun i (_ : Fin 1) => x i) = ‖x‖ := by
  have hsquare := frob_sq_eq_sum_col (fun i (_ : Fin 1) => x i)
  simp only [Fin.sum_univ_one] at hsquare
  change frob (fun i (_ : Fin 1) => x i) ^ 2 = ‖x‖ ^ 2 at hsquare
  nlinarith [frob_nonneg (fun i (_ : Fin 1) => x i), norm_nonneg x]

/-- `BG-PROJECTION-LEM-009`: Frobenius norm is invariant under conjugate transpose. -/
lemma frob_conjTranspose {m n : Type*} [Fintype m] [Fintype n]
    (A : Matrix m n ℂ) : frob Aᴴ = frob A := by
  simp [matrixFrobeniusNorm]

/-- `BG-PROJECTION-LEM-010`: Euclidean operator norm is invariant under conjugate transpose. -/
lemma opn_conjTranspose {m n : Type*} [Fintype m] [Fintype n]
    [DecidableEq m] [DecidableEq n]
    (A : Matrix m n ℂ) : opn Aᴴ = opn A := by
  simpa [matrixL2OperatorNorm] using Matrix.l2_opNorm_conjTranspose A

/-- `BG-PROJECTION-THM-014`: left multiplication is bounded by operator norm times Frobenius norm. -/
theorem frob_mul_le_op_mul_frob {l m n : Type*}
    [Fintype l] [Fintype m] [Fintype n] [DecidableEq m]
    (A : Matrix l m ℂ) (B : Matrix m n ℂ) :
    frob (A * B) ≤ opn A * frob B := by
  rw [← sq_le_sq₀ (frob_nonneg _) (mul_nonneg (opn_nonneg _) (frob_nonneg _))]
  rw [frob_sq_eq_sum_col, mul_pow, frob_sq_eq_sum_col, Finset.mul_sum]
  apply Finset.sum_le_sum
  intro j hj
  calc
    ‖(EuclideanSpace.equiv l ℂ).symm ((A * B) · j)‖ ^ 2
        = ‖(EuclideanSpace.equiv l ℂ).symm (A *ᵥ (B · j))‖ ^ 2 := by
          rfl
    _ ≤ (opn A * ‖(EuclideanSpace.equiv m ℂ).symm (B · j)‖) ^ 2 := by
      apply sq_le_sq₀ (norm_nonneg _)
        (mul_nonneg (opn_nonneg A) (norm_nonneg _)) |>.mpr
      simpa [matrixL2OperatorNorm] using
        Matrix.l2_opNorm_mulVec A ((EuclideanSpace.equiv m ℂ).symm (B · j))
    _ = opn A ^ 2 * ‖(EuclideanSpace.equiv m ℂ).symm (B · j)‖ ^ 2 := by ring

/-- `BG-PROJECTION-LEM-011`: triangle inequality for the explicitly bound Frobenius norm. -/
lemma frob_add_le {m n : Type*} [Fintype m] [Fintype n]
    (A B : Matrix m n ℂ) : frob (A + B) ≤ frob A + frob B := by
  exact @norm_add_le (Matrix m n ℂ)
    (Matrix.frobeniusNormedAddCommGroup (m := m) (n := n) (α := ℂ)).toNormedAddGroup.toSeminormedAddGroup
    A B

/-- `BG-PROJECTION-LEM-012`: submultiplicativity for the explicitly bound operator norm. -/
lemma opn_mul_le {l m n : Type*}
    [Fintype l] [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]
    (A : Matrix l m ℂ) (B : Matrix m n ℂ) : opn (A * B) ≤ opn A * opn B := by
  simpa [matrixL2OperatorNorm] using Matrix.l2_opNorm_mul A B

/-- `BG-PROJECTION-THM-015`: right multiplication is bounded by Frobenius norm times operator norm. -/
theorem frob_mul_le_frob_mul_op {l m n : Type*}
    [Fintype l] [Fintype m] [Fintype n]
    [DecidableEq l] [DecidableEq m] [DecidableEq n]
    (A : Matrix l m ℂ) (B : Matrix m n ℂ) :
    frob (A * B) ≤ frob A * opn B := by
  calc
    frob (A * B) = frob (Bᴴ * Aᴴ) := by
      rw [← frob_conjTranspose (A * B), Matrix.conjTranspose_mul]
    _ ≤ opn Bᴴ * frob Aᴴ := frob_mul_le_op_mul_frob Bᴴ Aᴴ
    _ = frob A * opn B := by
      rw [opn_conjTranspose, frob_conjTranspose, mul_comm]

/-- `BG-PROJECTION-THM-020`: the Euclidean matrix operator norm is bounded by the entrywise
Frobenius norm.  Both norm-instance boundaries remain explicit. -/
theorem matrixL2OperatorNorm_le_matrixFrobeniusNorm
    {m n : Type*} [Fintype m] [Fintype n] [DecidableEq n]
    (A : Matrix m n ℂ) : opn A ≤ frob A := by
  classical
  let TA : EuclideanSpace ℂ n →L[ℂ] EuclideanSpace ℂ m :=
    (Matrix.toEuclideanLin (𝕜 := ℂ) (m := m) (n := n)).trans
      LinearMap.toContinuousLinearMap A
  change ‖TA‖ ≤ frob A
  apply ContinuousLinearMap.opNorm_le_bound TA (frob_nonneg A)
  intro x
  let X : Matrix n (Fin 1) ℂ := fun i _ => x i
  have hmul := frob_mul_le_frob_mul_op A X
  have hcol := column_l2OperatorNorm_le x
  have hmatrix : A * X = fun i (_ : Fin 1) => (TA x) i := by
    ext i j
    have hj : j = 0 := Subsingleton.elim _ _
    subst j
    rfl
  have hAX : frob (A * X) = ‖TA x‖ := by
    rw [hmatrix, frob_column]
  have hX : opn X ≤ ‖x‖ := by
    simpa [X] using hcol
  rw [hAX] at hmul
  exact hmul.trans (mul_le_mul_of_nonneg_left hX (frob_nonneg A))

open ProjectKoios.BandGauge.Alignment

/-- `BG-PROJECTION-LEM-013`: an exact orthonormal frame has explicit operator norm at most one. -/
lemma frame_opn_le_one {Ambient Retained : Type*}
    [Fintype Ambient] [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) : opn frame ≤ 1 := by
  simpa [matrixL2OperatorNorm] using frame_l2OperatorNorm_le_one frame hframe

/-- `BG-PROJECTION-THM-016`: the mixed Frobenius/operator-norm compression estimate. -/
theorem compression_difference_frob_le {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    frob (compressOperator candidate operator - compressOperator reference operator) ≤
      2 * opn operator * frob (candidate - reference) := by
  rw [compression_difference_decomposition]
  calc
    frob ((candidate - reference)ᴴ * operator * candidate +
        referenceᴴ * operator * (candidate - reference))
        ≤ frob ((candidate - reference)ᴴ * operator * candidate) +
          frob (referenceᴴ * operator * (candidate - reference)) := frob_add_le _ _
    _ ≤ (frob ((candidate - reference)ᴴ * operator) * opn candidate) +
          (opn (referenceᴴ * operator) * frob (candidate - reference)) := by
      exact add_le_add (frob_mul_le_frob_mul_op _ _)
        (frob_mul_le_op_mul_frob _ _)
    _ ≤ ((frob (candidate - reference)ᴴ * opn operator) * opn candidate) +
          ((opn referenceᴴ * opn operator) * frob (candidate - reference)) := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_right (frob_mul_le_frob_mul_op _ _)
          (opn_nonneg _)
      · exact mul_le_mul_of_nonneg_right (opn_mul_le _ _) (frob_nonneg _)
    _ = ((frob (candidate - reference) * opn operator) * opn candidate) +
          ((opn reference * opn operator) * frob (candidate - reference)) := by
      rw [frob_conjTranspose, opn_conjTranspose]
    _ ≤ ((frob (candidate - reference) * opn operator) * 1) +
          ((1 * opn operator) * frob (candidate - reference)) := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_left (frame_opn_le_one candidate hcandidate)
          (mul_nonneg (frob_nonneg _) (opn_nonneg _))
      · exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_right (frame_opn_le_one reference hreference)
            (opn_nonneg _)) (frob_nonneg _)
    _ = 2 * opn operator * frob (candidate - reference) := by ring

/-- `BG-PROJECTION-THM-017`: mixed compression bound in the frozen right-unitary convention. -/
theorem compression_rightUnitaryFrame_frob_le {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (candidate reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    frob (compressOperator candidate operator -
        (gauge : Matrix Retained Retained ℂ)ᴴ * compressOperator reference operator *
          (gauge : Matrix Retained Retained ℂ)) ≤
      2 * opn operator * frob (candidate - rightUnitaryFrame reference gauge) := by
  rw [← compressOperator_rightUnitaryFrame]
  exact compression_difference_frob_le candidate (rightUnitaryFrame reference gauge) operator
    hcandidate (rightUnitaryFrame_isOrthonormal reference gauge hreference)

/-- `BG-PROJECTION-LEM-014`: an orthonormal-frame projector has explicit operator norm at most one. -/
lemma frameProjector_opn_le_one {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) : opn (frameProjector frame) ≤ 1 := by
  simpa [matrixL2OperatorNorm] using frameProjector_l2OperatorNorm_le_one frame hframe

/-- `BG-PROJECTION-THM-018`: ambient projector-sandwich mismatch in mixed norms. -/
theorem projector_sandwich_difference_frob_le {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    frob (frameProjector candidate * operator * frameProjector candidate -
        frameProjector reference * operator * frameProjector reference) ≤
      2 * opn operator * frob (frameProjector candidate - frameProjector reference) := by
  rw [projector_sandwich_difference_decomposition]
  calc
    frob ((frameProjector candidate - frameProjector reference) * operator *
          frameProjector candidate + frameProjector reference * operator *
          (frameProjector candidate - frameProjector reference))
        ≤ frob ((frameProjector candidate - frameProjector reference) * operator *
            frameProjector candidate) + frob (frameProjector reference * operator *
            (frameProjector candidate - frameProjector reference)) := frob_add_le _ _
    _ ≤ (frob ((frameProjector candidate - frameProjector reference) * operator) *
          opn (frameProjector candidate)) +
        (opn (frameProjector reference * operator) *
          frob (frameProjector candidate - frameProjector reference)) := by
      exact add_le_add (frob_mul_le_frob_mul_op _ _)
        (frob_mul_le_op_mul_frob _ _)
    _ ≤ ((frob (frameProjector candidate - frameProjector reference) * opn operator) *
          opn (frameProjector candidate)) +
        ((opn (frameProjector reference) * opn operator) *
          frob (frameProjector candidate - frameProjector reference)) := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_right (frob_mul_le_frob_mul_op _ _)
          (opn_nonneg _)
      · exact mul_le_mul_of_nonneg_right (opn_mul_le _ _) (frob_nonneg _)
    _ ≤ ((frob (frameProjector candidate - frameProjector reference) * opn operator) * 1) +
        ((1 * opn operator) *
          frob (frameProjector candidate - frameProjector reference)) := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_left
          (frameProjector_opn_le_one candidate hcandidate)
          (mul_nonneg (frob_nonneg _) (opn_nonneg _))
      · exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_right
            (frameProjector_opn_le_one reference hreference) (opn_nonneg _))
          (frob_nonneg _)
    _ = 2 * opn operator *
        frob (frameProjector candidate - frameProjector reference) := by ring

/-- `BG-PROJECTION-LEM-015`: exact decomposition of two compressed-action reproduction residuals. -/
lemma leakage_difference_decomposition {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained]
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) :
    frameCompressionLeakage candidate operator - frameCompressionLeakage reference operator =
      operator * (candidate - reference) -
        (frameProjector candidate - frameProjector reference) * operator * candidate -
        frameProjector reference * operator * (candidate - reference) := by
  rw [frameCompressionLeakage_eq_projector_residual,
    frameCompressionLeakage_eq_projector_residual]
  simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_assoc]
  abel

/-- `BG-PROJECTION-LEM-016`: subtraction triangle inequality for the explicit Frobenius norm. -/
lemma frob_sub_le {m n : Type*} [Fintype m] [Fintype n]
    (A B : Matrix m n ℂ) : frob (A - B) ≤ frob A + frob B := by
  exact @norm_sub_le (Matrix m n ℂ)
    (Matrix.frobeniusNormedAddCommGroup (m := m) (n := n) (α := ℂ)).toNormedAddGroup.toSeminormedAddGroup
    A B

private lemma frameDifference_action_frob_le {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained]
    (difference : Matrix Ambient Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ) :
    frob (operator * difference) ≤ opn operator * frob difference :=
  frob_mul_le_op_mul_frob _ _

private lemma projectorDifference_action_frame_frob_le {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (projectorDifference operator : Matrix Ambient Ambient ℂ)
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    frob (projectorDifference * operator * frame) ≤
      opn operator * frob projectorDifference := by
  calc
    frob (projectorDifference * operator * frame)
        ≤ frob (projectorDifference * operator) * opn frame :=
          frob_mul_le_frob_mul_op _ _
    _ ≤ (frob projectorDifference * opn operator) * opn frame :=
      mul_le_mul_of_nonneg_right (frob_mul_le_frob_mul_op _ _) (opn_nonneg _)
    _ ≤ (frob projectorDifference * opn operator) * 1 :=
      mul_le_mul_of_nonneg_left (frame_opn_le_one frame hframe)
        (mul_nonneg (frob_nonneg _) (opn_nonneg _))
    _ = opn operator * frob projectorDifference := by ring

private lemma projector_action_frameDifference_frob_le {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (difference : Matrix Ambient Retained ℂ)
    (hframe : IsOrthonormalFrame frame) :
    frob (frameProjector frame * operator * difference) ≤
      opn operator * frob difference := by
  calc
    frob (frameProjector frame * operator * difference)
        ≤ opn (frameProjector frame * operator) * frob difference :=
          frob_mul_le_op_mul_frob _ _
    _ ≤ (opn (frameProjector frame) * opn operator) * frob difference :=
      mul_le_mul_of_nonneg_right (opn_mul_le _ _) (frob_nonneg _)
    _ ≤ (1 * opn operator) * frob difference :=
      mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_right (frameProjector_opn_le_one frame hframe)
          (opn_nonneg _)) (frob_nonneg _)
    _ = opn operator * frob difference := by ring

/-- `BG-PROJECTION-THM-019`: if an orthonormal reference frame has zero reproduction
residual, the candidate residual is bounded by frame and projector mismatch in mixed norms. -/
theorem leakage_frob_le_of_reference_zero {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference)
    (hzero : frameCompressionLeakage reference operator = 0) :
    frob (frameCompressionLeakage candidate operator) ≤
      2 * opn operator * frob (candidate - reference) +
        opn operator * frob (frameProjector candidate - frameProjector reference) := by
  rw [← sub_zero (frameCompressionLeakage candidate operator), ← hzero,
    leakage_difference_decomposition]
  calc
    frob (operator * (candidate - reference) -
        (frameProjector candidate - frameProjector reference) * operator * candidate -
        frameProjector reference * operator * (candidate - reference))
      ≤ frob (operator * (candidate - reference) -
          (frameProjector candidate - frameProjector reference) * operator * candidate) +
        frob (frameProjector reference * operator * (candidate - reference)) :=
          frob_sub_le _ _
    _ ≤ (frob (operator * (candidate - reference)) +
          frob ((frameProjector candidate - frameProjector reference) * operator * candidate)) +
        frob (frameProjector reference * operator * (candidate - reference)) := by
      exact add_le_add (frob_sub_le _ _) (le_refl _)
    _ ≤ (opn operator * frob (candidate - reference) +
          opn operator * frob (frameProjector candidate - frameProjector reference)) +
        opn operator * frob (candidate - reference) := by
      apply add_le_add
      · exact add_le_add (frameDifference_action_frob_le _ _)
          (projectorDifference_action_frame_frob_le _ _ _ hcandidate)
      · exact projector_action_frameDifference_frob_le reference operator _ hreference
    _ = 2 * opn operator * frob (candidate - reference) +
        opn operator * frob (frameProjector candidate - frameProjector reference) := by ring

end ProjectKoios.BandGauge.Projection

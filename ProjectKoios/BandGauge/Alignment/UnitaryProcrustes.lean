/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import Mathlib.Analysis.Matrix.PosDef
public import Mathlib.Analysis.Matrix.Normed
public import ProjectKoios.BandGauge.Alignment.FiniteFrame

/-!
# Exact complex-unitary right Procrustes algebra

This module formalizes the finite complex right-action problem

`minimize ‖candidate * gauge - reference‖_F²` subject to `gaugeᴴ * gauge = 1`.

The cross matrix is `candidateᴴ * reference`. An exact polar witness factors that matrix as
`minimizer * positiveFactor`, with a unitary minimizer and a positive-semidefinite factor. Such a
witness proves global minimality. If the positive factor is positive definite, the minimizer is
unique.

The witness is exact mathematical input. This module does not construct a witness from floating
point data, run or verify an SVD, define a numerical-rank tolerance, select a null-space completion,
authenticate an optimizer, parse a certificate, or bind runtime arrays. In particular,
rank-deficient witnesses still prove minimality but do not imply uniqueness.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate ComplexOrder Matrix Matrix.Norms.Frobenius

namespace ProjectKoios.BandGauge.Alignment

variable {Ambient Retained : Type*}
  [Fintype Ambient]
  [Fintype Retained] [DecidableEq Retained]

/-- `BG-ALIGNMENT-DEF-017`: exact squared Frobenius magnitude represented by
`re (trace (matrixᴴ * matrix))`. -/
noncomputable def frobeniusPower (matrix : Matrix Ambient Retained ℂ) : ℝ :=
  (Matrix.trace (matrixᴴ * matrix)).re

/-- `BG-ALIGNMENT-DEF-018`: real trace score for a candidate frame, reference frame, and
right-acting retained-space unitary. -/
noncomputable def rightUnitaryProcrustesScore
    (candidate reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ) : ℝ :=
  (Matrix.trace ((gauge : Matrix Retained Retained ℂ)ᴴ *
    (candidateᴴ * reference))).re

/-- `BG-ALIGNMENT-DEF-019`: exact squared Frobenius objective for the right action
`candidate * gauge - reference`. -/
noncomputable def rightUnitaryProcrustesObjective
    (candidate reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ) : ℝ :=
  frobeniusPower (rightUnitaryFrame candidate gauge - reference)

omit [DecidableEq Retained] in
/-- `BG-ALIGNMENT-THM-030`: Frobenius power is the entrywise sum of squared complex norms. -/
theorem frobeniusPower_eq_sum (matrix : Matrix Ambient Retained ℂ) :
    frobeniusPower matrix = ∑ i, ∑ j, ‖matrix i j‖ ^ 2 := by
  calc
    frobeniusPower matrix = ∑ j, ∑ i, ‖matrix i j‖ ^ 2 := by
      rw [frobeniusPower, Matrix.trace, Complex.re_sum]
      apply Finset.sum_congr rfl
      intro j _
      rw [Matrix.diag_apply, Matrix.mul_apply, Complex.re_sum]
      apply Finset.sum_congr rfl
      intro i _
      simp [Complex.sq_norm, Complex.normSq_apply]
    _ = ∑ i, ∑ j, ‖matrix i j‖ ^ 2 := Finset.sum_comm

omit [DecidableEq Retained] in
/-- `BG-ALIGNMENT-THM-031`: Frobenius power is the square of Mathlib's scoped Frobenius norm. -/
theorem frobeniusPower_eq_norm_sq (matrix : Matrix Ambient Retained ℂ) :
    frobeniusPower matrix = ‖matrix‖ ^ 2 := by
  rw [frobeniusPower_eq_sum, Matrix.frobenius_norm_def, ← Real.sqrt_eq_rpow]
  simp only [Real.rpow_two]
  exact (Real.sq_sqrt (Finset.sum_nonneg fun i _ =>
    Finset.sum_nonneg fun j _ => sq_nonneg ‖matrix i j‖)).symm

/-- `BG-ALIGNMENT-THM-032`: every entry of a finite unitary matrix has norm at most one. -/
theorem unitary_entry_norm_le_one (gauge : Matrix.unitaryGroup Retained ℂ)
    (i j : Retained) : ‖gauge i j‖ ≤ 1 := by
  have hunitary : (gauge : Matrix Retained Retained ℂ)ᴴ *
      (gauge : Matrix Retained Retained ℂ) = 1 :=
    Matrix.mem_unitaryGroup_iff'.mp gauge.property
  have hsumComplex : ∑ k, star (gauge k j) * gauge k j = (1 : ℂ) := by
    have hentry := congr_fun (congr_fun hunitary j) j
    simpa [Matrix.mul_apply] using hentry
  have hsumReal : ∑ k, ‖gauge k j‖ ^ 2 = (1 : ℝ) := by
    have hre := congrArg Complex.re hsumComplex
    rw [Complex.re_sum] at hre
    simpa [Complex.sq_norm, Complex.normSq_apply] using hre
  have hsquare : ‖gauge i j‖ ^ 2 ≤ (1 : ℝ) := by
    rw [← hsumReal]
    exact Finset.single_le_sum (fun k _ => sq_nonneg ‖gauge k j‖) (Finset.mem_univ i)
  nlinarith [norm_nonneg (gauge i j)]

/-- `BG-ALIGNMENT-THM-033`: every column of a finite unitary matrix has total squared norm one. -/
theorem unitary_column_power (gauge : Matrix.unitaryGroup Retained ℂ) (j : Retained) :
    ∑ i, ‖gauge i j‖ ^ 2 = (1 : ℝ) := by
  have hunitary : (gauge : Matrix Retained Retained ℂ)ᴴ *
      (gauge : Matrix Retained Retained ℂ) = 1 :=
    Matrix.mem_unitaryGroup_iff'.mp gauge.property
  have hsumComplex : ∑ i, star (gauge i j) * gauge i j = (1 : ℂ) := by
    have hentry := congr_fun (congr_fun hunitary j) j
    simpa [Matrix.mul_apply] using hentry
  have hre := congrArg Complex.re hsumComplex
  rw [Complex.re_sum] at hre
  simpa [Complex.sq_norm, Complex.normSq_apply] using hre

/-- `BG-ALIGNMENT-THM-034`: a finite unitary whose diagonal entries all have real part one is the
identity. -/
theorem unitary_eq_one_of_diag_re_one (gauge : Matrix.unitaryGroup Retained ℂ)
    (hdiag : ∀ i, (gauge i i).re = 1) : gauge = 1 := by
  apply Matrix.UnitaryGroup.ext
  intro i j
  by_cases hij : i = j
  · subst j
    apply Complex.ext
    · simpa using hdiag i
    · rw [Matrix.UnitaryGroup.one_apply, Matrix.one_apply_eq]
      change (gauge i i).im = 0
      have hnorm := unitary_entry_norm_le_one gauge i i
      have hnormsq : ‖gauge i i‖ ^ 2 ≤ (1 : ℝ) := by
        simpa using (sq_le_sq₀ (norm_nonneg (gauge i i)) zero_le_one).2 hnorm
      have hsq := Complex.sq_norm (gauge i i)
      rw [Complex.normSq_apply, hdiag i] at hsq
      nlinarith [sq_nonneg (gauge i i).im]
  · have hsum := unitary_column_power gauge j
    have hdiagNorm : ‖gauge j j‖ ^ 2 = (1 : ℝ) := by
      have hre := hdiag j
      have hnorm := unitary_entry_norm_le_one gauge j j
      have hnormsq : ‖gauge j j‖ ^ 2 ≤ (1 : ℝ) := by
        simpa using (sq_le_sq₀ (norm_nonneg (gauge j j)) zero_le_one).2 hnorm
      have hsq := Complex.sq_norm (gauge j j)
      rw [Complex.normSq_apply, hre] at hsq
      nlinarith [sq_nonneg (gauge j j).im]
    have herase : ∑ k ∈ Finset.univ.erase j, ‖gauge k j‖ ^ 2 = 0 := by
      have hsplit := Finset.sum_erase_add Finset.univ (fun k => ‖gauge k j‖ ^ 2)
        (Finset.mem_univ j)
      rw [hsum, hdiagNorm] at hsplit
      linarith
    have hterm : ‖gauge i j‖ ^ 2 = 0 :=
      (Finset.sum_eq_zero_iff_of_nonneg
        (fun k _ => sq_nonneg ‖gauge k j‖)).mp herase i
        (Finset.mem_erase.mpr ⟨hij, Finset.mem_univ i⟩)
    have hzero : gauge i j = 0 :=
      norm_eq_zero.mp (sq_eq_zero_iff.mp hterm)
    simpa [hij] using hzero

/-- `BG-ALIGNMENT-THM-035`: multiplying a nonnegative real diagonal matrix by a unitary cannot
increase the real trace beyond the sum of the diagonal. -/
theorem re_trace_unitary_mul_diagonal_le
    (gauge : Matrix.unitaryGroup Retained ℂ) (diagonalValue : Retained → ℝ)
    (hdiagonal : 0 ≤ diagonalValue) :
    (Matrix.trace ((gauge : Matrix Retained Retained ℂ) *
      Matrix.diagonal (fun i => (diagonalValue i : ℂ)))).re ≤
      ∑ i, diagonalValue i := by
  have htrace :
      Matrix.trace ((gauge : Matrix Retained Retained ℂ) *
        Matrix.diagonal (fun i => (diagonalValue i : ℂ))) =
        ∑ i, gauge i i * (diagonalValue i : ℂ) := by
    rw [Matrix.trace]
    apply Finset.sum_congr rfl
    intro i _
    rw [Matrix.diag_apply, Matrix.mul_apply, Finset.sum_eq_single i]
    · simp
    · intro j _ hji
      simp [hji]
    · simp
  rw [htrace, Complex.re_sum]
  simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero, sub_zero]
  apply Finset.sum_le_sum
  intro i _
  calc
    (gauge i i).re * diagonalValue i ≤ ‖gauge i i‖ * diagonalValue i :=
      mul_le_mul_of_nonneg_right (Complex.re_le_norm _) (hdiagonal i)
    _ ≤ 1 * diagonalValue i :=
      mul_le_mul_of_nonneg_right (unitary_entry_norm_le_one gauge i i) (hdiagonal i)
    _ = diagonalValue i := one_mul _

/-- `BG-ALIGNMENT-THM-036`: with strictly positive diagonal values, saturation of the unitary
real-trace bound forces the unitary to be the identity. -/
theorem re_trace_unitary_mul_diagonal_eq_sum_imp_eq_one
    (gauge : Matrix.unitaryGroup Retained ℂ) (diagonalValue : Retained → ℝ)
    (hdiagonal : ∀ i, 0 < diagonalValue i)
    (heq :
      (Matrix.trace ((gauge : Matrix Retained Retained ℂ) *
        Matrix.diagonal (fun i => (diagonalValue i : ℂ)))).re =
        ∑ i, diagonalValue i) : gauge = 1 := by
  have htrace :
      Matrix.trace ((gauge : Matrix Retained Retained ℂ) *
        Matrix.diagonal (fun i => (diagonalValue i : ℂ))) =
        ∑ i, gauge i i * (diagonalValue i : ℂ) := by
    rw [Matrix.trace]
    apply Finset.sum_congr rfl
    intro i _
    rw [Matrix.diag_apply, Matrix.mul_apply, Finset.sum_eq_single i]
    · simp
    · intro j _ hji
      simp [hji]
    · simp
  have hsum : ∑ i, (gauge i i).re * diagonalValue i = ∑ i, diagonalValue i := by
    rw [htrace, Complex.re_sum] at heq
    simpa [Complex.mul_re] using heq
  have hzero : ∑ i, (diagonalValue i - (gauge i i).re * diagonalValue i) = 0 := by
    rw [Finset.sum_sub_distrib, hsum, sub_self]
  have hnonnegative :
      ∀ i ∈ Finset.univ, 0 ≤ diagonalValue i - (gauge i i).re * diagonalValue i := by
    intro i _
    have hre : (gauge i i).re ≤ 1 :=
      (Complex.re_le_norm _).trans (unitary_entry_norm_le_one gauge i i)
    nlinarith [hdiagonal i]
  have hall := (Finset.sum_eq_zero_iff_of_nonneg hnonnegative).mp hzero
  have hterm : ∀ i, diagonalValue i - (gauge i i).re * diagonalValue i = 0 := by
    intro i
    exact hall i (Finset.mem_univ i)
  apply unitary_eq_one_of_diag_re_one gauge
  intro i
  nlinarith [hterm i, hdiagonal i]

/-- `BG-ALIGNMENT-THM-037`: for a positive-semidefinite complex matrix, left multiplication by a
unitary cannot increase the real trace. -/
theorem re_trace_unitary_mul_posSemidef_le_trace
    (gauge : Matrix.unitaryGroup Retained ℂ) (positive : Matrix Retained Retained ℂ)
    (hpositive : positive.PosSemidef) :
    (Matrix.trace ((gauge : Matrix Retained Retained ℂ) * positive)).re ≤
      (Matrix.trace positive).re := by
  let eigenvectorUnitary : Matrix.unitaryGroup Retained ℂ :=
    hpositive.isHermitian.eigenvectorUnitary
  let conjugatedGauge : Matrix.unitaryGroup Retained ℂ :=
    eigenvectorUnitary⁻¹ * gauge * eigenvectorUnitary
  let eigenvalue : Retained → ℝ := hpositive.isHermitian.eigenvalues
  have heigenvalue : 0 ≤ eigenvalue := fun i => hpositive.eigenvalues_nonneg i
  have hconjugatedGauge : (conjugatedGauge : Matrix Retained Retained ℂ) =
      (eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ *
        (gauge : Matrix Retained Retained ℂ) *
          (eigenvectorUnitary : Matrix Retained Retained ℂ) := by
    simp [conjugatedGauge, Matrix.star_eq_conjTranspose]
  have hleft :
      Matrix.trace ((gauge : Matrix Retained Retained ℂ) * positive) =
        Matrix.trace ((conjugatedGauge : Matrix Retained Retained ℂ) *
          Matrix.diagonal (fun i => (eigenvalue i : ℂ))) := by
    rw [hpositive.isHermitian.spectral_theorem, Unitary.conjStarAlgAut_apply]
    rw [hconjugatedGauge]
    change Matrix.trace
        ((gauge : Matrix Retained Retained ℂ) *
          ((eigenvectorUnitary : Matrix Retained Retained ℂ) *
            Matrix.diagonal (fun i => (eigenvalue i : ℂ)) *
              (eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ)) =
      Matrix.trace
        (((eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ *
          (gauge : Matrix Retained Retained ℂ) *
            (eigenvectorUnitary : Matrix Retained Retained ℂ)) *
              Matrix.diagonal (fun i => (eigenvalue i : ℂ)))
    simpa only [Matrix.mul_assoc] using
      (Matrix.trace_mul_cycle
        ((gauge : Matrix Retained Retained ℂ) *
          (eigenvectorUnitary : Matrix Retained Retained ℂ))
        (Matrix.diagonal (fun i => (eigenvalue i : ℂ)))
        (eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ)
  have hright : (Matrix.trace positive).re = ∑ i, eigenvalue i := by
    rw [hpositive.isHermitian.trace_eq_sum_eigenvalues, Complex.re_sum]
    simp [eigenvalue]
  rw [hleft, hright]
  exact re_trace_unitary_mul_diagonal_le conjugatedGauge eigenvalue heigenvalue

/-- `BG-ALIGNMENT-THM-038`: for a positive-definite complex matrix, saturation of the unitary
real-trace bound forces the unitary to be the identity. -/
theorem re_trace_unitary_mul_posDef_eq_trace_imp_eq_one
    (gauge : Matrix.unitaryGroup Retained ℂ) (positive : Matrix Retained Retained ℂ)
    (hpositive : positive.PosDef)
    (heq : (Matrix.trace ((gauge : Matrix Retained Retained ℂ) * positive)).re =
      (Matrix.trace positive).re) : gauge = 1 := by
  let eigenvectorUnitary : Matrix.unitaryGroup Retained ℂ :=
    hpositive.isHermitian.eigenvectorUnitary
  let conjugatedGauge : Matrix.unitaryGroup Retained ℂ :=
    eigenvectorUnitary⁻¹ * gauge * eigenvectorUnitary
  let eigenvalue : Retained → ℝ := hpositive.isHermitian.eigenvalues
  have heigenvalue : ∀ i, 0 < eigenvalue i := fun i => hpositive.eigenvalues_pos i
  have hconjugatedGauge : (conjugatedGauge : Matrix Retained Retained ℂ) =
      (eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ *
        (gauge : Matrix Retained Retained ℂ) *
          (eigenvectorUnitary : Matrix Retained Retained ℂ) := by
    simp [conjugatedGauge, Matrix.star_eq_conjTranspose]
  have hleft :
      Matrix.trace ((gauge : Matrix Retained Retained ℂ) * positive) =
        Matrix.trace ((conjugatedGauge : Matrix Retained Retained ℂ) *
          Matrix.diagonal (fun i => (eigenvalue i : ℂ))) := by
    rw [hpositive.isHermitian.spectral_theorem, Unitary.conjStarAlgAut_apply]
    rw [hconjugatedGauge]
    change Matrix.trace
        ((gauge : Matrix Retained Retained ℂ) *
          ((eigenvectorUnitary : Matrix Retained Retained ℂ) *
            Matrix.diagonal (fun i => (eigenvalue i : ℂ)) *
              (eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ)) =
      Matrix.trace
        (((eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ *
          (gauge : Matrix Retained Retained ℂ) *
            (eigenvectorUnitary : Matrix Retained Retained ℂ)) *
              Matrix.diagonal (fun i => (eigenvalue i : ℂ)))
    simpa only [Matrix.mul_assoc] using
      (Matrix.trace_mul_cycle
        ((gauge : Matrix Retained Retained ℂ) *
          (eigenvectorUnitary : Matrix Retained Retained ℂ))
        (Matrix.diagonal (fun i => (eigenvalue i : ℂ)))
        (eigenvectorUnitary : Matrix Retained Retained ℂ)ᴴ)
  have hright : (Matrix.trace positive).re = ∑ i, eigenvalue i := by
    rw [hpositive.isHermitian.trace_eq_sum_eigenvalues, Complex.re_sum]
    simp [eigenvalue]
  rw [hleft, hright] at heq
  have hconjugatedGaugeOne :=
    re_trace_unitary_mul_diagonal_eq_sum_imp_eq_one
      conjugatedGauge eigenvalue heigenvalue heq
  calc
    gauge = eigenvectorUnitary * conjugatedGauge * eigenvectorUnitary⁻¹ := by
      dsimp [conjugatedGauge]
      group
    _ = 1 := by rw [hconjugatedGaugeOne]; simp

omit [DecidableEq Retained] in
/-- `BG-ALIGNMENT-THM-039`: squared Frobenius magnitude expands by real trace polarization. -/
theorem frobeniusPower_sub (left right : Matrix Ambient Retained ℂ) :
    frobeniusPower (left - right) =
      frobeniusPower left + frobeniusPower right -
        2 * (Matrix.trace (leftᴴ * right)).re := by
  simp only [frobeniusPower, Matrix.conjTranspose_sub, Matrix.sub_mul, Matrix.mul_sub,
    Matrix.trace_sub, Complex.sub_re]
  have hcross : (rightᴴ * left).trace.re = (leftᴴ * right).trace.re := by
    have h : (leftᴴ * right)ᴴ = rightᴴ * left := by simp
    rw [← h, Matrix.trace_conjTranspose]
    simp
  rw [hcross]
  ring

/-- `BG-ALIGNMENT-THM-040`: right multiplication by a unitary preserves Frobenius power. -/
theorem frobeniusPower_rightUnitaryFrame
    (frame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    frobeniusPower (rightUnitaryFrame frame gauge) = frobeniusPower frame := by
  have hunitary : (gauge : Matrix Retained Retained ℂ) *
      (gauge : Matrix Retained Retained ℂ)ᴴ = 1 :=
    Matrix.mem_unitaryGroup_iff.mp gauge.property
  rw [rightUnitaryFrame, frobeniusPower, Matrix.conjTranspose_mul]
  calc
    ((gauge : Matrix Retained Retained ℂ)ᴴ * frameᴴ *
      (frame * (gauge : Matrix Retained Retained ℂ))).trace.re =
        (((gauge : Matrix Retained Retained ℂ) *
          (gauge : Matrix Retained Retained ℂ)ᴴ) *
            (frameᴴ * frame)).trace.re := by
          simpa only [Matrix.mul_assoc] using congrArg Complex.re
            (Matrix.trace_mul_cycle
              (gauge : Matrix Retained Retained ℂ)ᴴ
              (frameᴴ * frame)
              (gauge : Matrix Retained Retained ℂ))
    _ = frobeniusPower frame := by rw [hunitary, Matrix.one_mul]; rfl

/-- `BG-ALIGNMENT-THM-041`: the right-unitary Procrustes objective is a constant minus twice the
real trace score. -/
theorem rightUnitaryProcrustesObjective_expansion
    (candidate reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    rightUnitaryProcrustesObjective candidate reference gauge =
      frobeniusPower candidate + frobeniusPower reference -
        2 * rightUnitaryProcrustesScore candidate reference gauge := by
  rw [rightUnitaryProcrustesObjective, frobeniusPower_sub,
    frobeniusPower_rightUnitaryFrame]
  congr 2
  rw [rightUnitaryProcrustesScore, rightUnitaryFrame, Matrix.conjTranspose_mul]
  simp only [Matrix.mul_assoc]

/-- `BG-ALIGNMENT-DEF-020`: exact polar witness for the cross matrix
`candidateᴴ * reference`. The positive factor is exact mathematical data, not a runtime SVD
result. -/
structure RightUnitaryProcrustesPolarWitness
    (candidate reference : ComplexFrame Ambient Retained) where
  minimizer : Matrix.unitaryGroup Retained ℂ
  positiveFactor : Matrix Retained Retained ℂ
  positiveSemidefinite : positiveFactor.PosSemidef
  crossFactorization : candidateᴴ * reference =
    (minimizer : Matrix Retained Retained ℂ) * positiveFactor

/-- `BG-ALIGNMENT-THM-042`: the polar witness's minimizer attains trace score equal to the trace of
its positive factor. -/
theorem RightUnitaryProcrustesPolarWitness.score_eq_trace
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference) :
    rightUnitaryProcrustesScore candidate reference witness.minimizer =
      (Matrix.trace witness.positiveFactor).re := by
  have hunitary : (witness.minimizer : Matrix Retained Retained ℂ)ᴴ *
      (witness.minimizer : Matrix Retained Retained ℂ) = 1 :=
    Matrix.mem_unitaryGroup_iff'.mp witness.minimizer.property
  rw [rightUnitaryProcrustesScore, witness.crossFactorization,
    ← Matrix.mul_assoc, hunitary, Matrix.one_mul]

/-- `BG-ALIGNMENT-THM-043`: every competing unitary has trace score at most the polar witness's
score. -/
theorem RightUnitaryProcrustesPolarWitness.score_le
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    rightUnitaryProcrustesScore candidate reference gauge ≤
      rightUnitaryProcrustesScore candidate reference witness.minimizer := by
  let relativeGauge : Matrix.unitaryGroup Retained ℂ := gauge⁻¹ * witness.minimizer
  have hrelativeGauge : (relativeGauge : Matrix Retained Retained ℂ) =
      (gauge : Matrix Retained Retained ℂ)ᴴ *
        (witness.minimizer : Matrix Retained Retained ℂ) := by
    simp [relativeGauge, Matrix.star_eq_conjTranspose]
  rw [rightUnitaryProcrustesScore, witness.crossFactorization,
    ← Matrix.mul_assoc, ← hrelativeGauge, witness.score_eq_trace]
  exact re_trace_unitary_mul_posSemidef_le_trace
    relativeGauge witness.positiveFactor witness.positiveSemidefinite

/-- `BG-ALIGNMENT-THM-044`: an exact polar witness globally minimizes the complex-unitary right
Procrustes objective. -/
theorem RightUnitaryProcrustesPolarWitness.objective_minimal
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    rightUnitaryProcrustesObjective candidate reference witness.minimizer ≤
      rightUnitaryProcrustesObjective candidate reference gauge := by
  rw [rightUnitaryProcrustesObjective_expansion,
    rightUnitaryProcrustesObjective_expansion]
  linarith [witness.score_le gauge]

/-- `BG-ALIGNMENT-THM-045`: if the exact polar factor is positive definite, equality with the
minimum objective forces the competing unitary to equal the witness minimizer. -/
theorem RightUnitaryProcrustesPolarWitness.eq_minimizer_of_objective_eq
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (hpositive : witness.positiveFactor.PosDef)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (heq : rightUnitaryProcrustesObjective candidate reference gauge =
      rightUnitaryProcrustesObjective candidate reference witness.minimizer) :
    gauge = witness.minimizer := by
  have hscore : rightUnitaryProcrustesScore candidate reference gauge =
      rightUnitaryProcrustesScore candidate reference witness.minimizer := by
    rw [rightUnitaryProcrustesObjective_expansion,
      rightUnitaryProcrustesObjective_expansion] at heq
    linarith
  let relativeGauge : Matrix.unitaryGroup Retained ℂ := gauge⁻¹ * witness.minimizer
  have hrelativeGauge : (relativeGauge : Matrix Retained Retained ℂ) =
      (gauge : Matrix Retained Retained ℂ)ᴴ *
        (witness.minimizer : Matrix Retained Retained ℂ) := by
    simp [relativeGauge, Matrix.star_eq_conjTranspose]
  have htrace :
      (Matrix.trace ((relativeGauge : Matrix Retained Retained ℂ) *
        witness.positiveFactor)).re =
          (Matrix.trace witness.positiveFactor).re := by
    calc
      (Matrix.trace ((relativeGauge : Matrix Retained Retained ℂ) *
        witness.positiveFactor)).re =
          rightUnitaryProcrustesScore candidate reference gauge := by
            rw [rightUnitaryProcrustesScore, witness.crossFactorization,
              ← Matrix.mul_assoc, ← hrelativeGauge]
      _ = rightUnitaryProcrustesScore candidate reference witness.minimizer := hscore
      _ = (Matrix.trace witness.positiveFactor).re := witness.score_eq_trace
  have hrelativeGaugeOne := re_trace_unitary_mul_posDef_eq_trace_imp_eq_one
    relativeGauge witness.positiveFactor hpositive htrace
  symm
  calc
    witness.minimizer = gauge * relativeGauge := by
      dsimp [relativeGauge]
      group
    _ = gauge := by rw [hrelativeGaugeOne]; simp

end ProjectKoios.BandGauge.Alignment

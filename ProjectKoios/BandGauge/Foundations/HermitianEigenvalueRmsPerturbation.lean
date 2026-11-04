/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-04
-/
module

public import ProjectKoios.BandGauge.Foundations.HermitianEigenvaluePerturbation
public import Mathlib.Analysis.Convex.Birkhoff
public import Mathlib.Algebra.Order.Rearrangement
public import Mathlib.Analysis.InnerProductSpace.Trace

/-!
# Hermitian ordered-eigenvalue RMS perturbation

This module proves a finite-dimensional Hoffman--Wielandt inequality for the canonical decreasing,
multiplicity-retaining Hermitian eigenvalues.  The proof forms the squared-overlap matrix between
orthonormal eigenbases, proves that it is doubly stochastic, applies the Birkhoff--von Neumann
decomposition and the rearrangement inequality, and identifies the resulting Hilbert--Schmidt sum
with the entrywise Frobenius power of the matrix difference.

The primary exact estimate is

`∑ i, (λᵢ(A) - λᵢ(B))² ≤ ∑ i, ∑ j, ‖(A-B)ᵢⱼ‖²`.

The normalized RMS consequence divides both sides by the nonzero retained dimension.  It is
separate from the maximum-form Weyl estimate.  No runtime matrix entries, eigensolver ordering,
degeneracy handling, floating-point norm, DFT, Wannier90 result, or scientific applicability claim
is authenticated here.
-/

@[expose] public section

open scoped ComplexConjugate InnerProductSpace Matrix
open Finset Matrix Module LinearMap

namespace ProjectKoios.BandGauge.Foundations

/-- `BG-FOUNDATION-DEF-027`: squared overlaps between two orthonormal bases. -/
noncomputable def orthonormalOverlapSq {ι E : Type*} [Fintype ι]
    [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    (left right : OrthonormalBasis ι ℂ E) : Matrix ι ι ℝ :=
  fun i j => ‖⟪left i, right j⟫_ℂ‖ ^ 2

/-- `BG-FOUNDATION-LEM-017`: the squared-overlap matrix of two orthonormal bases is doubly
stochastic. -/
lemma orthonormalOverlapSq_mem_doublyStochastic
    {ι E : Type*} [Fintype ι] [DecidableEq ι]
    [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    (left right : OrthonormalBasis ι ℂ E) :
    orthonormalOverlapSq left right ∈ doublyStochastic ℝ ι := by
  rw [mem_doublyStochastic_iff_sum]
  refine ⟨fun i j => sq_nonneg _, ?_, ?_⟩
  · intro i
    change (∑ j, ‖⟪left i, right j⟫_ℂ‖ ^ 2) = 1
    rw [right.sum_sq_norm_inner_left]
    simp
  · intro j
    change (∑ i, ‖⟪left i, right j⟫_ℂ‖ ^ 2) = 1
    rw [left.sum_sq_norm_inner_right]
    simp

private lemma sum_comm3 {α β γ : Type*} [Fintype α] [Fintype β] [Fintype γ]
    (f : α → β → γ → ℝ) :
    (∑ i, ∑ j, ∑ k, f i j k) = ∑ k, ∑ i, ∑ j, f i j k := by
  calc
    (∑ i, ∑ j, ∑ k, f i j k) = ∑ i, ∑ k, ∑ j, f i j k := by
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_comm]
    _ = ∑ k, ∑ i, ∑ j, f i j k := by rw [Finset.sum_comm]

/-- `BG-FOUNDATION-LEM-018`: a doubly stochastic matrix cannot increase the bilinear pairing of
two decreasing real vectors beyond their same-order pairing. -/
lemma doublyStochastic_bilinear_le_sorted
    {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]
    (left right : ι → ℝ) (hleft : Antitone left) (hright : Antitone right)
    (D : Matrix ι ι ℝ) (hD : D ∈ doublyStochastic ℝ ι) :
    (∑ i, ∑ j, left i * right j * D i j) ≤ ∑ i, left i * right i := by
  obtain ⟨weight, hweightNonneg, hweightSum, hweightD⟩ :=
    exists_eq_sum_perm_of_mem_doublyStochastic hD
  have hentry (i j : ι) : D i j =
      ∑ permutation, weight permutation *
        (Equiv.Perm.permMatrix ℝ permutation) i j := by
    have hij := Matrix.ext_iff.mpr hweightD i j
    rw [Matrix.sum_apply] at hij
    simpa [Matrix.smul_apply, smul_eq_mul] using hij.symm
  calc
    (∑ i, ∑ j, left i * right j * D i j) =
        ∑ permutation, weight permutation * ∑ i, ∑ j,
          left i * right j *
            (Equiv.Perm.permMatrix ℝ permutation) i j := by
      simp_rw [hentry, Finset.mul_sum]
      rw [sum_comm3]
      simp only [mul_assoc, mul_left_comm]
    _ = ∑ permutation, weight permutation *
        ∑ i, left i * right (permutation i) := by
      apply Finset.sum_congr rfl
      intro permutation _
      congr 1
      apply Finset.sum_congr rfl
      intro i _
      simp [Equiv.toPEquiv_apply]
    _ ≤ ∑ permutation, weight permutation * ∑ i, left i * right i := by
      apply Finset.sum_le_sum
      intro permutation _
      exact mul_le_mul_of_nonneg_left
        ((hleft.monovary hright).sum_mul_comp_perm_le_sum_mul)
        (hweightNonneg permutation)
    _ = ∑ i, left i * right i := by
      rw [← Finset.sum_mul, hweightSum, one_mul]

/-- `BG-FOUNDATION-LEM-019`: same-order squared differences are no larger than the squared
differences averaged by any doubly stochastic matrix. -/
lemma paired_sqDiff_le_doublyStochastic
    {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]
    (left right : ι → ℝ) (hleft : Antitone left) (hright : Antitone right)
    (D : Matrix ι ι ℝ) (hD : D ∈ doublyStochastic ℝ ι) :
    (∑ i, (left i - right i) ^ 2) ≤
      ∑ i, ∑ j, (left i - right j) ^ 2 * D i j := by
  have hcross :
      (∑ i, ∑ j, left i * right j * D i j) ≤
        ∑ i, left i * right i :=
    doublyStochastic_bilinear_le_sorted left right hleft hright D hD
  have hleftSq :
      (∑ i, ∑ j, left i ^ 2 * D i j) = ∑ i, left i ^ 2 := by
    calc
      (∑ i, ∑ j, left i ^ 2 * D i j) =
          ∑ i, left i ^ 2 * ∑ j, D i j := by
        simp_rw [Finset.mul_sum]
      _ = ∑ i, left i ^ 2 := by
        apply Finset.sum_congr rfl
        intro i _
        rw [sum_row_of_mem_doublyStochastic hD i, mul_one]
  have hrightSq :
      (∑ i, ∑ j, right j ^ 2 * D i j) = ∑ j, right j ^ 2 := by
    rw [Finset.sum_comm]
    calc
      (∑ j, ∑ i, right j ^ 2 * D i j) =
          ∑ j, right j ^ 2 * ∑ i, D i j := by
        simp_rw [Finset.mul_sum]
      _ = ∑ j, right j ^ 2 := by
        apply Finset.sum_congr rfl
        intro j _
        rw [sum_col_of_mem_doublyStochastic hD j, mul_one]
  have htwo :
      (∑ i, 2 * left i * right i) = 2 * ∑ i, left i * right i := by
    rw [Finset.mul_sum]
    congr 1
    funext i
    ring
  calc
    (∑ i, (left i - right i) ^ 2) =
        (∑ i, left i ^ 2) + (∑ i, right i ^ 2) -
          2 * ∑ i, left i * right i := by
      simp_rw [sub_sq, Finset.sum_add_distrib, Finset.sum_sub_distrib]
      rw [htwo]
      ring
    _ ≤ (∑ i, left i ^ 2) + (∑ i, right i ^ 2) -
        2 * ∑ i, ∑ j, left i * right j * D i j := by
      linarith
    _ = ∑ i, ∑ j, (left i - right j) ^ 2 * D i j := by
      symm
      calc
        (∑ i, ∑ j, (left i - right j) ^ 2 * D i j) =
            (∑ i, ∑ j, left i ^ 2 * D i j) +
            (∑ i, ∑ j, right j ^ 2 * D i j) -
            2 * ∑ i, ∑ j, left i * right j * D i j := by
          have hpoint (i j : ι) :
              (left i - right j) ^ 2 * D i j =
                left i ^ 2 * D i j + right j ^ 2 * D i j -
                  (left i * right j * D i j) * 2 := by
            ring
          have hsumPoint :
              (∑ i, ∑ j, (left i - right j) ^ 2 * D i j) =
                ∑ i, ∑ j,
                  (left i ^ 2 * D i j + right j ^ 2 * D i j -
                    (left i * right j * D i j) * 2) := by
            apply Finset.sum_congr rfl
            intro i _
            apply Finset.sum_congr rfl
            intro j _
            exact hpoint i j
          rw [hsumPoint]
          have hinner (i : ι) :
              (∑ j, (left i ^ 2 * D i j + right j ^ 2 * D i j -
                (left i * right j * D i j) * 2)) =
                (∑ j, left i ^ 2 * D i j) +
                  (∑ j, right j ^ 2 * D i j) -
                    ∑ j, (left i * right j * D i j) * 2 := by
            rw [Finset.sum_sub_distrib, Finset.sum_add_distrib]
          simp_rw [hinner]
          rw [Finset.sum_sub_distrib, Finset.sum_add_distrib]
          have htwoD :
              (∑ i, ∑ j, (left i * right j * D i j) * 2) =
                2 * ∑ i, ∑ j, left i * right j * D i j := by
            calc
              (∑ i, ∑ j, (left i * right j * D i j) * 2) =
                  ∑ i, (∑ j, left i * right j * D i j) * 2 := by
                apply Finset.sum_congr rfl
                intro i _
                rw [Finset.sum_mul]
              _ = (∑ i, ∑ j, left i * right j * D i j) * 2 := by
                rw [Finset.sum_mul]
              _ = 2 * ∑ i, ∑ j, left i * right j * D i j := by
                ring
          rw [htwoD]
        _ = _ := by rw [hleftSq, hrightSq]

private lemma symmetric_sub_eigenbasis_norm_sq
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    [FiniteDimensional ℂ E]
    (T S : E →ₗ[ℂ] E) (hT : T.IsSymmetric) (hS : S.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) :
    (∑ j : Fin N, (hT.eigenvalues hN i - hS.eigenvalues hN j) ^ 2 *
      orthonormalOverlapSq (hT.eigenvectorBasis hN) (hS.eigenvectorBasis hN) i j) =
      ‖(T - S) (hT.eigenvectorBasis hN i)‖ ^ 2 := by
  rw [← (hS.eigenvectorBasis hN).sum_sq_norm_inner_right
    ((T - S) (hT.eigenvectorBasis hN i))]
  apply Finset.sum_congr rfl
  intro j _
  have hinner :
      ⟪hS.eigenvectorBasis hN j, (T - S) (hT.eigenvectorBasis hN i)⟫_ℂ =
        ((hT.eigenvalues hN i - hS.eigenvalues hN j : ℝ) : ℂ) *
          ⟪hS.eigenvectorBasis hN j, hT.eigenvectorBasis hN i⟫_ℂ := by
    rw [LinearMap.sub_apply, inner_sub_right, hT.apply_eigenvectorBasis]
    rw [← hS (hS.eigenvectorBasis hN j) (hT.eigenvectorBasis hN i),
      hS.apply_eigenvectorBasis]
    simp only [inner_smul_right, inner_smul_left]
    simp
    ring
  rw [hinner]
  change (hT.eigenvalues hN i - hS.eigenvalues hN j) ^ 2 *
      ‖⟪hT.eigenvectorBasis hN i, hS.eigenvectorBasis hN j⟫_ℂ‖ ^ 2 = _
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, mul_pow, sq_abs]
  rw [norm_inner_symm (𝕜 := ℂ)
    (hT.eigenvectorBasis hN i) (hS.eigenvectorBasis hN j)]

/-- `BG-FOUNDATION-THM-045`: the square-sum of same-order eigenvalue differences of finite-
dimensional symmetric complex linear maps is bounded by the Hilbert--Schmidt action sum on an
eigenbasis of the first map. -/
theorem symmetricEigenvalue_sqSum_le_basisAction
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    [FiniteDimensional ℂ E]
    (T S : E →ₗ[ℂ] E) (hT : T.IsSymmetric) (hS : S.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) :
    (∑ i : Fin N, (hT.eigenvalues hN i - hS.eigenvalues hN i) ^ 2) ≤
      ∑ i : Fin N, ‖(T - S) (hT.eigenvectorBasis hN i)‖ ^ 2 := by
  let D := orthonormalOverlapSq (hT.eigenvectorBasis hN) (hS.eigenvectorBasis hN)
  calc
    (∑ i : Fin N, (hT.eigenvalues hN i - hS.eigenvalues hN i) ^ 2) ≤
        ∑ i : Fin N, ∑ j : Fin N,
          (hT.eigenvalues hN i - hS.eigenvalues hN j) ^ 2 * D i j :=
      paired_sqDiff_le_doublyStochastic _ _
        (hT.eigenvalues_antitone hN) (hS.eigenvalues_antitone hN) D
        (orthonormalOverlapSq_mem_doublyStochastic _ _)
    _ = ∑ i : Fin N, ‖(T - S) (hT.eigenvectorBasis hN i)‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro i _
      exact symmetric_sub_eigenbasis_norm_sq T S hT hS N hN i

private lemma sum_norm_sq_apply_orthonormalBasis_eq_trace_re
    {ι E : Type*} [Fintype ι]
    [NormedAddCommGroup E] [InnerProductSpace ℂ E] [FiniteDimensional ℂ E]
    (D : E →ₗ[ℂ] E) (basis : OrthonormalBasis ι ℂ E) :
    (∑ i, ‖D (basis i)‖ ^ 2) =
      Complex.re ((LinearMap.trace ℂ E) (D.adjoint ∘ₗ D)) := by
  rw [LinearMap.trace_eq_sum_inner _ basis]
  change (∑ i, ‖D (basis i)‖ ^ 2) =
    Complex.reCLM (∑ i, ⟪basis i, (D.adjoint ∘ₗ D) (basis i)⟫_ℂ)
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [LinearMap.comp_apply, LinearMap.adjoint_inner_right,
    inner_self_eq_norm_sq_to_K]
  norm_cast

private lemma sum_norm_sq_apply_orthonormalBasis_eq
    {ι κ E : Type*} [Fintype ι] [Fintype κ]
    [NormedAddCommGroup E] [InnerProductSpace ℂ E] [FiniteDimensional ℂ E]
    (D : E →ₗ[ℂ] E) (left : OrthonormalBasis ι ℂ E)
    (right : OrthonormalBasis κ ℂ E) :
    (∑ i, ‖D (left i)‖ ^ 2) = ∑ j, ‖D (right j)‖ ^ 2 := by
  rw [sum_norm_sq_apply_orthonormalBasis_eq_trace_re,
    sum_norm_sq_apply_orthonormalBasis_eq_trace_re]

private lemma sum_norm_sq_toEuclideanLin_basisFun
    {n : Type*} [Fintype n] [DecidableEq n] (M : Matrix n n ℂ) :
    (∑ j : n, ‖Matrix.toEuclideanLin M (EuclideanSpace.basisFun n ℂ j)‖ ^ 2) =
      ∑ i : n, ∑ j : n, ‖M i j‖ ^ 2 := by
  change (∑ j : n, ‖(EuclideanSpace.equiv n ℂ).symm
    (M *ᵥ (EuclideanSpace.basisFun n ℂ j))‖ ^ 2) = _
  simp_rw [EuclideanSpace.basisFun_apply, PiLp.ofLp_single,
    Matrix.mulVec_single_one, PiLp.norm_sq_eq_of_L2]
  rw [Finset.sum_comm]
  rfl

/-- `BG-FOUNDATION-THM-046`: Hoffman--Wielandt square-sum inequality for canonical decreasing
Hermitian matrix eigenvalues, with algebraic multiplicity retained. -/
theorem orderedHermitianEigenvalue_sqSum_le_entrywiseFrobenius
    {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℂ} (hA : A.IsHermitian) (hB : B.IsHermitian) :
    (∑ i : Fin (Fintype.card n),
      (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2) ≤
      ∑ i : n, ∑ j : n, ‖(A - B) i j‖ ^ 2 := by
  let TA := Matrix.toEuclideanLin A
  let TB := Matrix.toEuclideanLin B
  let hTA := Matrix.isSymmetric_toEuclideanLin_iff.mpr hA
  let hTB := Matrix.isSymmetric_toEuclideanLin_iff.mpr hB
  have h := symmetricEigenvalue_sqSum_le_basisAction
    TA TB hTA hTB (Fintype.card n) finrank_euclideanSpace
  have hinv := sum_norm_sq_apply_orthonormalBasis_eq
    (TA - TB) (hTA.eigenvectorBasis finrank_euclideanSpace)
      (EuclideanSpace.basisFun n ℂ)
  have hlin : TA - TB = Matrix.toEuclideanLin (A - B) := by
    exact (map_sub (Matrix.toEuclideanLin (m := n) (n := n) (𝕜 := ℂ)) A B).symm
  rw [hinv, hlin, sum_norm_sq_toEuclideanLin_basisFun] at h
  simpa [orderedHermitianEigenvalues, Matrix.IsHermitian.eigenvalues₀,
    hTA, hTB, TA, TB] using h

/-- `BG-FOUNDATION-THM-047`: the squared ordered-eigenvalue RMS error is bounded by the average
entrywise Frobenius power of the Hermitian matrix difference. -/
theorem orderedEigenvalueRmsError_sq_le_entrywiseFrobeniusAverage
    {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    {A B : Matrix n n ℂ} (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueRmsError hA hB ^ 2 ≤
      (∑ i : n, ∑ j : n, ‖(A - B) i j‖ ^ 2) / Fintype.card n := by
  rw [orderedEigenvalueRmsError_sq]
  exact div_le_div_of_nonneg_right
    (orderedHermitianEigenvalue_sqSum_le_entrywiseFrobenius hA hB)
    (Nat.cast_nonneg _)

end ProjectKoios.BandGauge.Foundations

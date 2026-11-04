/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.BandGauge.Foundations.HermitianSpectralError
public import Mathlib.Analysis.CStarAlgebra.Matrix
public import Mathlib.Analysis.InnerProductSpace.Rayleigh
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Ordered Hermitian eigenvalue perturbation

This module proves the finite-dimensional maximum-form Weyl perturbation inequality.  The proof
constructs leading and trailing spans of Mathlib's decreasing orthonormal eigenvector basis.  Their
dimensions force a nonzero intersection, where the two Rayleigh-quotient bounds and the Euclidean
operator norm give the pointwise ordered-eigenvalue estimate.

For matrices, the resulting exact theorem is

`|λᵢ(A) - λᵢ(B)| ≤ ‖A - B‖op`,

and hence the maximum ordered-eigenvalue error has the same bound.  The ordered carrier retains
algebraic multiplicity.  This result is not a Hoffman--Wielandt inequality: it does not control the
sum of squared eigenvalue errors by a Frobenius norm.  It also does not authenticate runtime
matrix entries, eigensolver ordering, degeneracy handling, or scientific applicability.
-/

@[expose] public section

open scoped ComplexConjugate InnerProductSpace Matrix Matrix.Norms.L2Operator
open Module LinearMap Matrix

namespace ProjectKoios.BandGauge.Foundations

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
  [FiniteDimensional ℂ E]

/-- `BG-FOUNDATION-DEF-025`: span of the decreasing eigenvectors through index `i`. -/
noncomputable def leadingEigenvectorSubspace
    (T : E →ₗ[ℂ] E) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) : Submodule ℂ E :=
  Submodule.span ℂ ((hT.eigenvectorBasis hN : Fin N → E) '' Set.Iic i)

/-- `BG-FOUNDATION-DEF-026`: span of the decreasing eigenvectors from index `i` onward. -/
noncomputable def trailingEigenvectorSubspace
    (T : E →ₗ[ℂ] E) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) : Submodule ℂ E :=
  Submodule.span ℂ ((hT.eigenvectorBasis hN : Fin N → E) '' Set.Ici i)

/-- `BG-FOUNDATION-LEM-011`: the Hermitian quadratic form is the eigenvalue-weighted sum of
squared eigenbasis coordinates. -/
lemma symmetric_re_inner_eq_eigenvalue_sum
    (T : E →ₗ[ℂ] E) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (x : E) :
    Complex.re ⟪T x, x⟫_ℂ =
      ∑ j : Fin N, hT.eigenvalues hN j *
        ‖⟪hT.eigenvectorBasis hN j, x⟫_ℂ‖ ^ 2 := by
  rw [← (hT.eigenvectorBasis hN).sum_inner_mul_inner (T x) x]
  change Complex.reCLM (∑ j : Fin N,
    ⟪T x, hT.eigenvectorBasis hN j⟫_ℂ *
      ⟪hT.eigenvectorBasis hN j, x⟫_ℂ) = _
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro j _
  rw [hT x (hT.eigenvectorBasis hN j)]
  simp only [hT.apply_eigenvectorBasis, inner_smul_right]
  change Complex.re ((hT.eigenvalues hN j : ℂ) *
    ⟪x, hT.eigenvectorBasis hN j⟫_ℂ *
      ⟪hT.eigenvectorBasis hN j, x⟫_ℂ) = _
  rw [mul_assoc, Complex.mul_re]
  simp only [Complex.ofReal_re, Complex.ofReal_im, zero_mul, sub_zero]
  rw [← inner_conj_symm x (hT.eigenvectorBasis hN j), RCLike.conj_mul]
  congr 1
  norm_cast

/-- `BG-FOUNDATION-LEM-012`: on the leading eigenvector span, the quadratic form is bounded below
by the indexed eigenvalue times squared norm. -/
lemma leadingEigenvectorSubspace_re_inner_lower
    (T : E →ₗ[ℂ] E) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) (x : E)
    (hx : x ∈ leadingEigenvectorSubspace T hT N hN i) :
    hT.eigenvalues hN i * ‖x‖ ^ 2 ≤ Complex.re ⟪T x, x⟫_ℂ := by
  rw [symmetric_re_inner_eq_eigenvalue_sum T hT N hN x]
  rw [← (hT.eigenvectorBasis hN).sum_sq_norm_inner_right x, Finset.mul_sum]
  apply Finset.sum_le_sum
  intro j _
  by_cases hji : j ≤ i
  · exact mul_le_mul_of_nonneg_right (hT.eigenvalues_antitone hN hji) (sq_nonneg _)
  · have hsupp := (hT.eigenvectorBasis hN).toBasis.repr_support_subset_of_mem_span
      (Set.Iic i) hx
    have hzero : (hT.eigenvectorBasis hN).repr x j = 0 := by
      rw [← (hT.eigenvectorBasis hN).coe_toBasis_repr_apply x j]
      apply Finsupp.notMem_support_iff.mp
      intro hmem
      exact hji (hsupp hmem)
    rw [(hT.eigenvectorBasis hN).repr_apply_apply x j] at hzero
    simp [hzero]

/-- `BG-FOUNDATION-LEM-013`: on the trailing eigenvector span, the quadratic form is bounded above
by the indexed eigenvalue times squared norm. -/
lemma trailingEigenvectorSubspace_re_inner_upper
    (T : E →ₗ[ℂ] E) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) (x : E)
    (hx : x ∈ trailingEigenvectorSubspace T hT N hN i) :
    Complex.re ⟪T x, x⟫_ℂ ≤ hT.eigenvalues hN i * ‖x‖ ^ 2 := by
  rw [symmetric_re_inner_eq_eigenvalue_sum T hT N hN x]
  rw [← (hT.eigenvectorBasis hN).sum_sq_norm_inner_right x, Finset.mul_sum]
  apply Finset.sum_le_sum
  intro j _
  by_cases hij : i ≤ j
  · exact mul_le_mul_of_nonneg_right (hT.eigenvalues_antitone hN hij) (sq_nonneg _)
  · have hsupp := (hT.eigenvectorBasis hN).toBasis.repr_support_subset_of_mem_span
      (Set.Ici i) hx
    have hzero : (hT.eigenvectorBasis hN).repr x j = 0 := by
      rw [← (hT.eigenvectorBasis hN).coe_toBasis_repr_apply x j]
      apply Finsupp.notMem_support_iff.mp
      intro hmem
      exact hij (hsupp hmem)
    rw [(hT.eigenvectorBasis hN).repr_apply_apply x j] at hzero
    simp [hzero]

/-- `BG-FOUNDATION-LEM-014`: the leading span through `i` has dimension `i + 1`. -/
lemma leadingEigenvectorSubspace_finrank
    (T : E →ₗ[ℂ] E) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) :
    finrank ℂ (leadingEigenvectorSubspace T hT N hN i) = i.val + 1 := by
  let v : {j : Fin N // j ≤ i} → E := fun j => hT.eigenvectorBasis hN j
  have hv : LinearIndependent ℂ v :=
    (hT.eigenvectorBasis hN).toBasis.linearIndependent.comp _ Subtype.val_injective
  have hrange : Set.range v =
      (hT.eigenvectorBasis hN : Fin N → E) '' Set.Iic i := by
    ext x
    constructor
    · rintro ⟨j, rfl⟩
      exact ⟨j, j.property, rfl⟩
    · rintro ⟨j, hj, rfl⟩
      exact ⟨⟨j, hj⟩, rfl⟩
  rw [leadingEigenvectorSubspace, ← hrange, finrank_span_eq_card hv]
  calc
    Fintype.card {j : Fin N // j ≤ i} = Fintype.card (↥(Set.Iic i)) :=
      Fintype.card_congr (Equiv.refl _)
    _ = i.val + 1 := by rw [Fintype.card_Iic, Fin.card_Iic]

/-- `BG-FOUNDATION-LEM-015`: the trailing span from `i` has dimension `N - i`. -/
lemma trailingEigenvectorSubspace_finrank
    (T : E →ₗ[ℂ] E) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) :
    finrank ℂ (trailingEigenvectorSubspace T hT N hN i) = N - i.val := by
  let v : {j : Fin N // i ≤ j} → E := fun j => hT.eigenvectorBasis hN j
  have hv : LinearIndependent ℂ v :=
    (hT.eigenvectorBasis hN).toBasis.linearIndependent.comp _ Subtype.val_injective
  have hrange : Set.range v =
      (hT.eigenvectorBasis hN : Fin N → E) '' Set.Ici i := by
    ext x
    constructor
    · rintro ⟨j, rfl⟩
      exact ⟨j, j.property, rfl⟩
    · rintro ⟨j, hj, rfl⟩
      exact ⟨⟨j, hj⟩, rfl⟩
  rw [trailingEigenvectorSubspace, ← hrange, finrank_span_eq_card hv]
  calc
    Fintype.card {j : Fin N // i ≤ j} = Fintype.card (↥(Set.Ici i)) :=
      Fintype.card_congr (Equiv.refl _)
    _ = N - i.val := by rw [Fintype.card_Ici, Fin.card_Ici]

/-- `BG-FOUNDATION-LEM-016`: a leading span for one symmetric operator and the corresponding
trailing span for another contain a common nonzero vector. -/
lemma exists_nonzero_mem_leading_trailing
    (S T : E →ₗ[ℂ] E) (hS : S.IsSymmetric) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) :
    ∃ x : E, x ≠ 0 ∧ x ∈ leadingEigenvectorSubspace S hS N hN i ∧
      x ∈ trailingEigenvectorSubspace T hT N hN i := by
  let p := leadingEigenvectorSubspace S hS N hN i
  let q := trailingEigenvectorSubspace T hT N hN i
  have hp : finrank ℂ p = i.val + 1 := leadingEigenvectorSubspace_finrank S hS N hN i
  have hq : finrank ℂ q = N - i.val := trailingEigenvectorSubspace_finrank T hT N hN i
  have hsup : finrank ℂ (p ⊔ q : Submodule ℂ E) ≤ N := by
    rw [← hN]
    exact Submodule.finrank_le _
  have hsum := Submodule.finrank_sup_add_finrank_inf_eq p q
  have hinf : 1 ≤ finrank ℂ (p ⊓ q : Submodule ℂ E) := by
    omega
  have hne : (p ⊓ q : Submodule ℂ E) ≠ ⊥ := Submodule.one_le_finrank_iff.mp hinf
  obtain ⟨x, hx, hx0⟩ := (Submodule.ne_bot_iff (p ⊓ q)).mp hne
  exact ⟨x, hx0, hx.1, hx.2⟩

private lemma symmetricEigenvalue_le_add_operatorNorm
    (S T : E →ₗ[ℂ] E) (hS : S.IsSymmetric) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) :
    hS.eigenvalues hN i ≤ hT.eigenvalues hN i +
      ‖(S - T).toContinuousLinearMap‖ := by
  obtain ⟨x, hx0, hxS, hxT⟩ :=
    exists_nonzero_mem_leading_trailing S T hS hT N hN i
  have hxnorm : 0 < ‖x‖ ^ 2 := sq_pos_of_pos (norm_pos_iff.mpr hx0)
  have hSlow := leadingEigenvectorSubspace_re_inner_lower S hS N hN i x hxS
  have hTup := trailingEigenvectorSubspace_re_inner_upper T hT N hN i x hxT
  let D : E →L[ℂ] E := (S - T).toContinuousLinearMap
  have hDquot := D.rayleighQuotient_le_norm x
  have hDquot' : D.rayleighQuotient x ≤ ‖D‖ := (le_abs_self _).trans hDquot
  have hDup : D.reApplyInnerSelf x ≤ ‖D‖ * ‖x‖ ^ 2 := by
    rw [ContinuousLinearMap.rayleighQuotient, div_le_iff₀ hxnorm] at hDquot'
    exact hDquot'
  have hDapply : D.reApplyInnerSelf x = Complex.re ⟪(S - T) x, x⟫_ℂ := by
    rfl
  rw [hDapply] at hDup
  have hdecomp : Complex.re ⟪S x, x⟫_ℂ =
      Complex.re ⟪T x, x⟫_ℂ + Complex.re ⟪(S - T) x, x⟫_ℂ := by
    simp only [LinearMap.sub_apply, inner_sub_left, Complex.sub_re]
    ring
  have hmul : hS.eigenvalues hN i * ‖x‖ ^ 2 ≤
      (hT.eigenvalues hN i + ‖D‖) * ‖x‖ ^ 2 := by
    rw [hdecomp] at hSlow
    nlinarith
  exact le_of_mul_le_mul_right hmul hxnorm

/-- `BG-FOUNDATION-THM-042`: finite-dimensional Weyl perturbation bound for the decreasing
ordered eigenvalues of symmetric complex linear maps. -/
theorem symmetricEigenvalue_abs_sub_le_operatorNorm
    (S T : E →ₗ[ℂ] E) (hS : S.IsSymmetric) (hT : T.IsSymmetric)
    (N : ℕ) (hN : finrank ℂ E = N) (i : Fin N) :
    |hS.eigenvalues hN i - hT.eigenvalues hN i| ≤
      ‖(S - T).toContinuousLinearMap‖ := by
  rw [abs_le]
  constructor
  · have h := symmetricEigenvalue_le_add_operatorNorm T S hT hS N hN i
    rw [show (T - S).toContinuousLinearMap = -(S - T).toContinuousLinearMap by
      ext x
      simp] at h
    rw [norm_neg] at h
    linarith
  · have h := symmetricEigenvalue_le_add_operatorNorm S T hS hT N hN i
    exact sub_le_iff_le_add.mpr (by simpa [add_comm] using h)

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {A B : Matrix n n ℂ}

/-- `BG-FOUNDATION-THM-043`: pointwise Weyl bound for canonical decreasing Hermitian matrix
eigenvalues, with multiplicity retained. -/
theorem orderedHermitianEigenvalue_abs_sub_le_l2OperatorNorm
    (hA : A.IsHermitian) (hB : B.IsHermitian)
    (i : Fin (Fintype.card n)) :
    |orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i| ≤ ‖A - B‖ := by
  let hSA := Matrix.isSymmetric_toEuclideanLin_iff.mpr hA
  let hSB := Matrix.isSymmetric_toEuclideanLin_iff.mpr hB
  have h := symmetricEigenvalue_abs_sub_le_operatorNorm
    (Matrix.toEuclideanLin A) (Matrix.toEuclideanLin B) hSA hSB
    (Fintype.card n) finrank_euclideanSpace i
  have hAclm : (Matrix.toEuclideanLin A).toContinuousLinearMap =
      Matrix.toEuclideanCLM (n := n) (𝕜 := ℂ) A := by
    ext x
    rfl
  have hBclm : (Matrix.toEuclideanLin B).toContinuousLinearMap =
      Matrix.toEuclideanCLM (n := n) (𝕜 := ℂ) B := by
    ext x
    rfl
  rw [show (Matrix.toEuclideanLin A - Matrix.toEuclideanLin B).toContinuousLinearMap =
      (Matrix.toEuclideanLin A).toContinuousLinearMap -
        (Matrix.toEuclideanLin B).toContinuousLinearMap by rfl, hAclm, hBclm] at h
  simpa [orderedHermitianEigenvalues, Matrix.IsHermitian.eigenvalues₀, hSA, hSB,
    ← Matrix.l2_opNorm_toEuclideanCLM] using h

/-- `BG-FOUNDATION-THM-044`: maximum ordered Hermitian eigenvalue error is bounded by the
Euclidean matrix operator norm of the matrix difference. -/
theorem orderedEigenvalueMaxError_le_l2OperatorNorm [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueMaxError hA hB ≤ ‖A - B‖ := by
  unfold orderedEigenvalueMaxError
  apply Finset.sup'_le
  intro i _
  exact orderedHermitianEigenvalue_abs_sub_le_l2OperatorNorm hA hB i

end ProjectKoios.BandGauge.Foundations

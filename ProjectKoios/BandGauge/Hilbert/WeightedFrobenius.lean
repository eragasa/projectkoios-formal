module

public import Mathlib.Analysis.Complex.Norm
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.LinearAlgebra.Matrix.Trace
public import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Weighted Frobenius geometry

This module freezes the retained-rank-two weighted Frobenius convention used by the
source publication. The coefficient of coordinate `i` is
`weight i / (2 * energyRef ^ 2)`.

The layer is finite and matrix-valued. It does not use the bounded-operator norm and does
not claim a continuum or `L²` Bloch-section construction.
-/

open scoped BigOperators ComplexConjugate Matrix
open Finset

@[expose] public section

namespace ProjectKoios.BandGauge.Hilbert

/-- `BG-HILBERT-DEF-003`: a finite retained-rank-two complex matrix field. -/
abbrev RankTwoMatrixField (I : Type*) := I → Matrix (Fin 2) (Fin 2) ℂ

/-- The publication's coefficient for one retained coordinate. -/
noncomputable def rankTwoFrobeniusCoefficient (weight : ℝ) (energyRef : ℝ) : ℝ :=
  weight / (2 * energyRef ^ 2)

/-- `BG-HILBERT-DEF-006`: the constant identity field on the retained rank-two space. -/
def rankTwoIdentityMatrixField (I : Type*) : RankTwoMatrixField I :=
  fun _ => 1

/-- `BG-HILBERT-DEF-004`: the source-compatible weighted squared Frobenius residual,
including the per-retained-state factor `1 / 2` and energy normalization. -/
noncomputable def rankTwoWeightedFrobeniusSq {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X : RankTwoMatrixField I) : ℝ :=
  ∑ p : I × (Fin 2 × Fin 2),
    rankTwoFrobeniusCoefficient (weight p.1) energyRef *
      ‖(X p.1) p.2.1 p.2.2‖ ^ 2

/-- `BG-HILBERT-DEF-005`: the weighted real Frobenius correlation associated with the
same coordinate weights and energy normalization as the squared residual. -/
noncomputable def rankTwoWeightedFrobeniusCorrelation {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ)
    (X Y : RankTwoMatrixField I) : ℝ :=
  ∑ p : I × (Fin 2 × Fin 2),
    rankTwoFrobeniusCoefficient (weight p.1) energyRef *
      (conj ((X p.1) p.2.1 p.2.2) * (Y p.1) p.2.1 p.2.2).re

private noncomputable def weightedFrobeniusVector {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X : RankTwoMatrixField I) :
    EuclideanSpace ℂ (I × (Fin 2 × Fin 2)) :=
  WithLp.toLp 2 fun p =>
    (Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
      (X p.1) p.2.1 p.2.2

private theorem coefficient_nonneg {weight energyRef : ℝ}
    (hweight : 0 ≤ weight) (henergyRef : energyRef ≠ 0) :
    0 ≤ rankTwoFrobeniusCoefficient weight energyRef := by
  rw [rankTwoFrobeniusCoefficient]
  positivity

private theorem weightedFrobeniusVector_norm_sq {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X : RankTwoMatrixField I)
    (hweight : ∀ i, 0 ≤ weight i) (henergyRef : energyRef ≠ 0) :
    ‖weightedFrobeniusVector weight energyRef X‖ ^ 2 =
      rankTwoWeightedFrobeniusSq weight energyRef X := by
  rw [PiLp.norm_sq_eq_of_L2]
  simp only [weightedFrobeniusVector, WithLp.ofLp_toLp, norm_mul, Complex.norm_real,
    Real.norm_eq_abs, abs_of_nonneg (Real.sqrt_nonneg _), mul_pow]
  simp_rw [Real.sq_sqrt (coefficient_nonneg (hweight _) henergyRef)]
  rw [rankTwoWeightedFrobeniusSq]

private theorem weightedFrobeniusVector_inner_re {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X Y : RankTwoMatrixField I)
    (hweight : ∀ i, 0 ≤ weight i) (henergyRef : energyRef ≠ 0) :
    (inner ℂ (weightedFrobeniusVector weight energyRef X)
      (weightedFrobeniusVector weight energyRef Y)).re =
        rankTwoWeightedFrobeniusCorrelation weight energyRef X Y := by
  have hpoint (p : I × (Fin 2 × Fin 2)) :
      (inner ℂ
        ((Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
          (X p.1) p.2.1 p.2.2)
        ((Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
          (Y p.1) p.2.1 p.2.2)).re =
        rankTwoFrobeniusCoefficient (weight p.1) energyRef *
          (conj ((X p.1) p.2.1 p.2.2) * (Y p.1) p.2.1 p.2.2).re := by
    rw [RCLike.inner_apply', map_mul, Complex.conj_ofReal]
    have hs :
        (Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
          (Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) =
            (rankTwoFrobeniusCoefficient (weight p.1) energyRef : ℂ) := by
      rw [← Complex.ofReal_mul, Real.mul_self_sqrt
        (coefficient_nonneg (hweight _) henergyRef)]
    rw [show
      (Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
          conj ((X p.1) p.2.1 p.2.2) *
          ((Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
            (Y p.1) p.2.1 p.2.2) =
        ((Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
          (Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ)) *
            (conj ((X p.1) p.2.1 p.2.2) * (Y p.1) p.2.1 p.2.2) by ring]
    rw [hs]
    simp
  rw [PiLp.inner_apply, rankTwoWeightedFrobeniusCorrelation]
  simp only [weightedFrobeniusVector, WithLp.ofLp_toLp]
  change Complex.reCLM (∑ p : I × (Fin 2 × Fin 2), inner ℂ
      ((Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
        (X p.1) p.2.1 p.2.2)
      ((Real.sqrt (rankTwoFrobeniusCoefficient (weight p.1) energyRef) : ℂ) *
        (Y p.1) p.2.1 p.2.2)) = _
  rw [map_sum]
  exact Finset.sum_congr rfl fun p _ => hpoint p

/-- `BG-HILBERT-THM-005`: the source-compatible weighted squared Frobenius residual is
nonnegative for nonnegative weights and nonzero reference energy. -/
theorem rankTwoWeightedFrobeniusSq_nonneg {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X : RankTwoMatrixField I)
    (hweight : ∀ i, 0 ≤ weight i) (henergyRef : energyRef ≠ 0) :
    0 ≤ rankTwoWeightedFrobeniusSq weight energyRef X := by
  rw [← weightedFrobeniusVector_norm_sq weight energyRef X hweight henergyRef]
  positivity

/-- `BG-HILBERT-THM-006`: weighted Frobenius Cauchy--Schwarz in the normalization used by
the rank-two operator loss. -/
theorem abs_rankTwoWeightedFrobeniusCorrelation_le {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X Y : RankTwoMatrixField I)
    (hweight : ∀ i, 0 ≤ weight i) (henergyRef : energyRef ≠ 0) :
    |rankTwoWeightedFrobeniusCorrelation weight energyRef X Y| ≤
      Real.sqrt (rankTwoWeightedFrobeniusSq weight energyRef X) *
        Real.sqrt (rankTwoWeightedFrobeniusSq weight energyRef Y) := by
  let x := weightedFrobeniusVector weight energyRef X
  let y := weightedFrobeniusVector weight energyRef Y
  have hxSq : ‖x‖ ^ 2 = rankTwoWeightedFrobeniusSq weight energyRef X :=
    weightedFrobeniusVector_norm_sq weight energyRef X hweight henergyRef
  have hySq : ‖y‖ ^ 2 = rankTwoWeightedFrobeniusSq weight energyRef Y :=
    weightedFrobeniusVector_norm_sq weight energyRef Y hweight henergyRef
  have hcorr : (inner ℂ x y).re =
      rankTwoWeightedFrobeniusCorrelation weight energyRef X Y :=
    weightedFrobeniusVector_inner_re weight energyRef X Y hweight henergyRef
  calc
    |rankTwoWeightedFrobeniusCorrelation weight energyRef X Y| = |(inner ℂ x y).re| :=
      congrArg abs hcorr.symm
    _ ≤ ‖inner ℂ x y‖ := Complex.abs_re_le_norm _
    _ ≤ ‖x‖ * ‖y‖ := norm_inner_le_norm x y
    _ = Real.sqrt (rankTwoWeightedFrobeniusSq weight energyRef X) *
        Real.sqrt (rankTwoWeightedFrobeniusSq weight energyRef Y) := by
      rw [← hxSq, ← hySq, Real.sqrt_sq_eq_abs, Real.sqrt_sq_eq_abs]
      simp only [abs_norm]

private theorem frobeniusSq_eq_trace_re (A : Matrix (Fin 2) (Fin 2) ℂ) :
    (∑ m, ∑ n, ‖A m n‖ ^ 2) = (Matrix.trace (Aᴴ * A)).re := by
  simp [Matrix.trace, Matrix.mul_apply, Complex.sq_norm, Complex.normSq_apply]
  ring

private theorem frobeniusCorrelation_eq_trace_re
    (A B : Matrix (Fin 2) (Fin 2) ℂ) :
    (∑ m, ∑ n, (conj (A m n) * B m n).re) =
      (Matrix.trace (Aᴴ * B)).re := by
  simp [Matrix.trace, Matrix.mul_apply]
  ring

private theorem trace_conjugate_eq (U : Matrix.unitaryGroup (Fin 2) ℂ)
    (A : Matrix (Fin 2) (Fin 2) ℂ) :
    Matrix.trace ((U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * A *
      (U : Matrix (Fin 2) (Fin 2) ℂ)) = Matrix.trace A := by
  calc
    Matrix.trace ((U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * A *
        (U : Matrix (Fin 2) (Fin 2) ℂ)) =
        Matrix.trace ((U : Matrix (Fin 2) (Fin 2) ℂ) *
          (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * A) := by
      exact Matrix.trace_mul_cycle _ _ _
    _ = Matrix.trace A := by
      rw [show (U : Matrix (Fin 2) (Fin 2) ℂ) *
          (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ = 1 by
        exact Matrix.mem_unitaryGroup_iff.mp U.property]
      simp

private theorem frobeniusSq_unitary_conjugate
    (U : Matrix.unitaryGroup (Fin 2) ℂ) (A : Matrix (Fin 2) (Fin 2) ℂ) :
    (∑ m, ∑ n, ‖((U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * A *
      (U : Matrix (Fin 2) (Fin 2) ℂ)) m n‖ ^ 2) =
      ∑ m, ∑ n, ‖A m n‖ ^ 2 := by
  rw [frobeniusSq_eq_trace_re, frobeniusSq_eq_trace_re]
  have hunit : (U : Matrix (Fin 2) (Fin 2) ℂ) *
      (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ = 1 :=
    Matrix.mem_unitaryGroup_iff.mp U.property
  have hstar :
      (((U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * A *
          (U : Matrix (Fin 2) (Fin 2) ℂ))ᴴ *
          ((U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * A *
            (U : Matrix (Fin 2) (Fin 2) ℂ))) =
        (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * (Aᴴ * A) *
          (U : Matrix (Fin 2) (Fin 2) ℂ) := by
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul]
    simp only [Matrix.conjTranspose_conjTranspose]
    calc
      ((U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * (Aᴴ *
          (U : Matrix (Fin 2) (Fin 2) ℂ))) *
          ((U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * A *
            (U : Matrix (Fin 2) (Fin 2) ℂ)) =
        (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * Aᴴ *
          ((U : Matrix (Fin 2) (Fin 2) ℂ) *
            (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ) * A *
              (U : Matrix (Fin 2) (Fin 2) ℂ) := by noncomm_ring
      _ = (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * (Aᴴ * A) *
          (U : Matrix (Fin 2) (Fin 2) ℂ) := by rw [hunit]; simp; noncomm_ring
  rw [hstar, trace_conjugate_eq]

private theorem rankTwoWeightedFrobeniusSq_eq_sum {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X : RankTwoMatrixField I) :
    rankTwoWeightedFrobeniusSq weight energyRef X =
      ∑ i, rankTwoFrobeniusCoefficient (weight i) energyRef *
        ∑ m, ∑ n, ‖(X i) m n‖ ^ 2 := by
  rw [rankTwoWeightedFrobeniusSq, Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro i hi
  change (∑ y : Fin 2 × Fin 2,
      rankTwoFrobeniusCoefficient (weight i) energyRef *
        ‖(X i) y.1 y.2‖ ^ 2) = _
  rw [← Finset.mul_sum]
  congr 1
  rw [Fintype.sum_prod_type]

/-- `BG-HILBERT-THM-007`: pointwise unitary conjugation preserves the weighted
Frobenius power of a finite rank-two matrix field. -/
theorem rankTwoWeightedFrobeniusSq_unitary_conjugate {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X : RankTwoMatrixField I)
    (U : I → Matrix.unitaryGroup (Fin 2) ℂ) :
    rankTwoWeightedFrobeniusSq weight energyRef
        (fun i => (U i : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * X i *
          (U i : Matrix (Fin 2) (Fin 2) ℂ)) =
      rankTwoWeightedFrobeniusSq weight energyRef X := by
  rw [rankTwoWeightedFrobeniusSq_eq_sum, rankTwoWeightedFrobeniusSq_eq_sum]
  apply Finset.sum_congr rfl
  intro i hi
  rw [frobeniusSq_unitary_conjugate]

private theorem complex_norm_sq_linear_combination
    (a b : ℝ) (x y : ℂ) :
    ‖(a : ℂ) * x + (b : ℂ) * y‖ ^ 2 =
      a ^ 2 * ‖x‖ ^ 2 + 2 * a * b * (conj x * y).re + b ^ 2 * ‖y‖ ^ 2 := by
  rw [Complex.sq_norm, Complex.sq_norm, Complex.sq_norm]
  simp only [Complex.normSq_apply, Complex.add_re, Complex.mul_re, Complex.ofReal_re,
    Complex.ofReal_im, zero_mul, sub_zero, Complex.add_im, Complex.mul_im,
    Complex.conj_re, Complex.conj_im, neg_mul, sub_neg_eq_add]
  ring

/-- `BG-HILBERT-THM-008`: if two rank-two fields have the same weighted Frobenius power
`κ`, their weighted real correlation has magnitude at most `κ`. In the paper, the equal
powers are supplied by pointwise unitary conjugation of one parent splitting field. -/
theorem abs_rankTwoWeightedFrobeniusCorrelation_le_commonPower
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef κ : ℝ) (X Y : RankTwoMatrixField I)
    (hweight : ∀ i, 0 ≤ weight i) (henergyRef : energyRef ≠ 0)
    (hX : rankTwoWeightedFrobeniusSq weight energyRef X = κ)
    (hY : rankTwoWeightedFrobeniusSq weight energyRef Y = κ) :
    |rankTwoWeightedFrobeniusCorrelation weight energyRef X Y| ≤ κ := by
  have hκ : 0 ≤ κ := by
    rw [← hX]
    exact rankTwoWeightedFrobeniusSq_nonneg weight energyRef X hweight henergyRef
  calc
    |rankTwoWeightedFrobeniusCorrelation weight energyRef X Y| ≤
        Real.sqrt (rankTwoWeightedFrobeniusSq weight energyRef X) *
          Real.sqrt (rankTwoWeightedFrobeniusSq weight energyRef Y) :=
      abs_rankTwoWeightedFrobeniusCorrelation_le weight energyRef X Y hweight henergyRef
    _ = κ := by
      rw [hX, hY]
      exact Real.mul_self_sqrt hκ

/-- `BG-HILBERT-THM-009`: the source-normalized weighted Frobenius power obeys the
real polarization identity for a linear combination of two finite matrix fields. -/
theorem rankTwoWeightedFrobeniusSq_linear_combination
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef a b : ℝ) (X Y : RankTwoMatrixField I) :
    rankTwoWeightedFrobeniusSq weight energyRef
        (fun i => (a : ℂ) • X i + (b : ℂ) • Y i) =
      a ^ 2 * rankTwoWeightedFrobeniusSq weight energyRef X +
        2 * a * b * rankTwoWeightedFrobeniusCorrelation weight energyRef X Y +
          b ^ 2 * rankTwoWeightedFrobeniusSq weight energyRef Y := by
  rw [rankTwoWeightedFrobeniusSq, rankTwoWeightedFrobeniusSq,
    rankTwoWeightedFrobeniusCorrelation, rankTwoWeightedFrobeniusSq]
  rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum]
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p hp
  simp only [Matrix.add_apply, Matrix.smul_apply, smul_eq_mul]
  rw [complex_norm_sq_linear_combination]
  ring

/-- `BG-HILBERT-THM-010`: a pointwise traceless rank-two field has zero weighted
Frobenius correlation with the identity field. -/
theorem rankTwoWeightedFrobeniusCorrelation_identity_eq_zero
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (X : RankTwoMatrixField I)
    (htrace : ∀ i, Matrix.trace (X i) = 0) :
    rankTwoWeightedFrobeniusCorrelation weight energyRef
      (rankTwoIdentityMatrixField I) X = 0 := by
  rw [rankTwoWeightedFrobeniusCorrelation, Fintype.sum_prod_type]
  apply Finset.sum_eq_zero
  intro i hi
  change (∑ y : Fin 2 × Fin 2,
      rankTwoFrobeniusCoefficient (weight i) energyRef *
        (conj ((1 : Matrix (Fin 2) (Fin 2) ℂ) y.1 y.2) *
          (X i) y.1 y.2).re) = 0
  rw [← Finset.mul_sum]
  apply mul_eq_zero_of_right
  rw [Fintype.sum_prod_type]
  simpa [Matrix.trace, Fin.sum_univ_two] using congrArg Complex.re (htrace i)

end ProjectKoios.BandGauge.Hilbert

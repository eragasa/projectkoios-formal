/-
Copyright (c) 2026 Eugene Joseph M. Ragasa. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Algebra.Polynomial.Laurent
public import Mathlib.Basic.Complex.Basic
public import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Algebra.MonoidAlgebra.Degree
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Order
import Mathlib.Tactic.Ring

/-!
# Laurent-polynomial obstruction for a projected rank-two band

This module encodes the finite-support algebraic core of the two-band example in
Ragasa2026b. The parent matrix is Laurent-polynomial and squares to a scalar
radicand, while that radicand has no Laurent-polynomial square root under the
source nondegeneracy assumption `Δt ≠ 0`.

The final theorem here is the algebraic obstruction. The companion
`SpectralProjectionRange` module proves the function-to-Laurent uniqueness step,
projector identities, and complete finite-support counterexample.
-/

open AddMonoidAlgebra Finsupp
open scoped LaurentPolynomial Matrix Pointwise

noncomputable section

@[expose] public section

namespace ProjectKoios.BandGauge.Projection

/-- `BG-PROJECTION-DEF-001`: the Laurent polynomial
`Δ² + 2t² + t²(z + z⁻¹)` from the rank-two projection example. -/
def twoBandLaurentRadicand (gap hopping : ℝ) : LaurentPolynomial ℂ :=
  AddMonoidAlgebra.single 0 ((gap : ℂ) ^ 2 + 2 * (hopping : ℂ) ^ 2) +
    AddMonoidAlgebra.single 1 ((hopping : ℂ) ^ 2) +
    AddMonoidAlgebra.single (-1) ((hopping : ℂ) ^ 2)

/-- `BG-PROJECTION-DEF-002`: the nearest-neighbor Laurent-polynomial parent
matrix in the rank-two projection example. -/
def twoBandParentLaurentMatrix (gap hopping : ℝ) :
    Matrix (Fin 2) (Fin 2) (LaurentPolynomial ℂ) :=
  !![LaurentPolynomial.C (gap : ℂ),
      LaurentPolynomial.C (hopping : ℂ) * (1 + LaurentPolynomial.T (-1));
    LaurentPolynomial.C (hopping : ℂ) * (1 + LaurentPolynomial.T 1),
      -LaurentPolynomial.C (gap : ℂ)]

/-- `BG-PROJECTION-THM-001`: the square of the nearest-neighbor parent is the
scalar Laurent radicand. -/
theorem twoBandParentLaurentMatrix_sq (gap hopping : ℝ) :
    twoBandParentLaurentMatrix gap hopping *
        twoBandParentLaurentMatrix gap hopping =
      twoBandLaurentRadicand gap hopping •
        (1 : Matrix (Fin 2) (Fin 2) (LaurentPolynomial ℂ)) := by
  have hneg :
      (LaurentPolynomial.T (-1) : LaurentPolynomial ℂ) *
          LaurentPolynomial.T 1 = 1 := by
    rw [← LaurentPolynomial.T_add]
    norm_num [LaurentPolynomial.T_zero]
  have hpos :
      (LaurentPolynomial.T 1 : LaurentPolynomial ℂ) *
          LaurentPolynomial.T (-1) = 1 := by
    rw [← LaurentPolynomial.T_add]
    norm_num [LaurentPolynomial.T_zero]
  have htwo :
      LaurentPolynomial.C (hopping : ℂ) ^ 2 * LaurentPolynomial.C 2 =
        LaurentPolynomial.C (hopping : ℂ) ^ 2 +
          LaurentPolynomial.C (hopping : ℂ) ^ 2 := by
    simp only [pow_two]
    rw [← map_mul, ← map_mul, ← map_add]
    congr 1
    ring
  ext i j
  fin_cases i <;> fin_cases j
  all_goals
    simp [twoBandParentLaurentMatrix, twoBandLaurentRadicand,
      Matrix.mul_apply, Fin.sum_univ_two]
  all_goals ring_nf
  all_goals simp [mul_assoc, hneg, hpos, htwo]
  all_goals ring

private lemma coeff_square_at_support_max
    (f : LaurentPolynomial ℂ) (f_ne : f ≠ 0) :
    let coeff_ne : f.coeff ≠ 0 :=
      fun h => f_ne (AddMonoidAlgebra.coeff_eq_zero.mp h)
    let maximum :=
      f.coeff.support.max' (Finsupp.support_nonempty_iff.mpr coeff_ne)
    (f * f).coeff (maximum + maximum) =
      f.coeff maximum * f.coeff maximum := by
  classical
  have coeff_ne : f.coeff ≠ 0 :=
    fun h => f_ne (AddMonoidAlgebra.coeff_eq_zero.mp h)
  let support_nonempty : f.coeff.support.Nonempty :=
    Finsupp.support_nonempty_iff.mpr coeff_ne
  let maximum := f.coeff.support.max' support_nonempty
  have maximum_mem : maximum ∈ f.coeff.support :=
    Finset.max'_mem _ support_nonempty
  have le_maximum {exponent : ℤ}
      (exponent_mem : exponent ∈ f.coeff.support) : exponent ≤ maximum :=
    Finset.le_max' _ _ exponent_mem
  dsimp only
  simp_rw [AddMonoidAlgebra.coeff_mul, Finsupp.sum]
  rw [Finset.sum_eq_single maximum, Finset.sum_eq_single maximum,
    ite_eq_left rfl]
  · intro exponent exponent_mem exponent_ne
    rw [ite_eq_right]
    intro sum_eq
    have := le_maximum exponent_mem
    omega
  · exact fun maximum_not_mem => (maximum_not_mem maximum_mem).elim
  · intro exponent exponent_mem exponent_ne
    apply Finset.sum_eq_zero
    intro other other_mem
    rw [ite_eq_right]
    intro sum_eq
    have exponent_le := le_maximum exponent_mem
    have other_le := le_maximum other_mem
    omega
  · exact fun maximum_not_mem => (maximum_not_mem maximum_mem).elim

private lemma twoBandLaurentRadicand_coeff_one
    (gap hopping : ℝ) (hopping_ne : hopping ≠ 0) :
    (twoBandLaurentRadicand gap hopping).coeff 1 ≠ 0 := by
  simp only [twoBandLaurentRadicand, AddMonoidAlgebra.coeff_add,
    Finsupp.add_apply, AddMonoidAlgebra.coeff_single, Finsupp.single_apply]
  norm_num
  exact hopping_ne

private lemma twoBandLaurentRadicand_coeff_eq_zero_of_one_lt
    (gap hopping : ℝ) {exponent : ℤ} (one_lt_exponent : 1 < exponent) :
    (twoBandLaurentRadicand gap hopping).coeff exponent = 0 := by
  have exponent_ne_one : exponent ≠ 1 := ne_of_gt one_lt_exponent
  have exponent_ne_zero : exponent ≠ 0 := by omega
  have exponent_ne_neg_one : exponent ≠ -1 := by omega
  simp only [twoBandLaurentRadicand, AddMonoidAlgebra.coeff_add,
    Finsupp.add_apply, AddMonoidAlgebra.coeff_single, Finsupp.single_apply,
    ite_eq_right (Ne.symm exponent_ne_zero),
    ite_eq_right (Ne.symm exponent_ne_one),
    ite_eq_right (Ne.symm exponent_ne_neg_one), zero_add]

/-- `BG-PROJECTION-THM-002`: when `Δt ≠ 0`, no complex Laurent polynomial
squares to `Δ² + 2t² + t²(z + z⁻¹)`. This is the parity obstruction at the
largest support exponent used by the paper proof. -/
theorem twoBandLaurentRadicand_not_sq
    (gap hopping : ℝ) (gap_mul_hopping_ne : gap * hopping ≠ 0) :
    ¬ ∃ f : LaurentPolynomial ℂ,
      f ^ 2 = twoBandLaurentRadicand gap hopping := by
  have hopping_ne : hopping ≠ 0 := (mul_ne_zero_iff.mp gap_mul_hopping_ne).2
  rintro ⟨f, square_eq⟩
  have radicand_coeff_one_ne :=
    twoBandLaurentRadicand_coeff_one gap hopping hopping_ne
  have f_ne : f ≠ 0 := by
    intro f_eq
    subst f
    simp at square_eq
    rw [← square_eq] at radicand_coeff_one_ne
    simp at radicand_coeff_one_ne
  have f_coeff_ne : f.coeff ≠ 0 :=
    fun h => f_ne (AddMonoidAlgebra.coeff_eq_zero.mp h)
  let support_nonempty : f.coeff.support.Nonempty :=
    Finsupp.support_nonempty_iff.mpr f_coeff_ne
  let maximum := f.coeff.support.max' support_nonempty
  have maximum_mem : maximum ∈ f.coeff.support :=
    Finset.max'_mem _ support_nonempty
  have le_maximum {exponent : ℤ}
      (exponent_mem : exponent ∈ f.coeff.support) : exponent ≤ maximum :=
    Finset.le_max' _ _ exponent_mem
  have one_mem_square : (1 : ℤ) ∈ (f * f).coeff.support := by
    rw [Finsupp.mem_support_iff]
    rw [← pow_two, square_eq]
    exact radicand_coeff_one_ne
  have one_mem_support_add :
      (1 : ℤ) ∈ f.coeff.support + f.coeff.support :=
    AddMonoidAlgebra.support_coeff_mul_subset f f one_mem_square
  obtain ⟨left, left_mem, right, right_mem, left_add_right⟩ :=
    Finset.mem_add.mp one_mem_support_add
  have one_le_twice_maximum : (1 : ℤ) ≤ maximum + maximum := by
    have left_le := le_maximum left_mem
    have right_le := le_maximum right_mem
    omega
  have coeff_square_max_ne :
      (f * f).coeff (maximum + maximum) ≠ 0 := by
    rw [coeff_square_at_support_max f f_ne]
    exact mul_ne_zero (Finsupp.mem_support_iff.mp maximum_mem)
      (Finsupp.mem_support_iff.mp maximum_mem)
  have radicand_coeff_max_ne :
      (twoBandLaurentRadicand gap hopping).coeff
          (maximum + maximum) ≠ 0 := by
    rw [← square_eq, pow_two]
    exact coeff_square_max_ne
  have twice_maximum_le_one : maximum + maximum ≤ (1 : ℤ) := by
    by_contra not_le
    exact radicand_coeff_max_ne
      (twoBandLaurentRadicand_coeff_eq_zero_of_one_lt
        gap hopping (lt_of_not_ge not_le))
  omega

end ProjectKoios.BandGauge.Projection

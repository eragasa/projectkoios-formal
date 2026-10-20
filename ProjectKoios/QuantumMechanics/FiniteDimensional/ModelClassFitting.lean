/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.Data.Matrix.Basis
public import Mathlib.Tactic.Linarith

/-!
# Frobenius fitting to coordinate-supported matrix classes

The retained diagonal and tridiagonal fits are coordinate projections for squared Frobenius loss.
The results are source-neutral and exact.  They do not bind a runtime matrix or assign physical
meaning to the selected model class.
-/

@[expose] public section

open scoped BigOperators

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- `QM-MODEL-FIT-DEF-001`: exact squared entrywise Frobenius magnitude. -/
def finiteFrobeniusSq (A : Matrix ι ι ℝ) : ℝ :=
  ∑ i, ∑ j, (A i j) ^ 2

/-- `QM-MODEL-FIT-DEF-002`: coordinate projection onto a declared support predicate. -/
def coordinateMask (keep : ι → ι → Prop) [DecidableRel keep]
    (A : Matrix ι ι ℝ) : Matrix ι ι ℝ :=
  fun i j => if keep i j then A i j else 0

/-- `QM-MODEL-FIT-DEF-003`: a matrix is zero outside a declared coordinate support. -/
def IsSupportedOn (keep : ι → ι → Prop) (B : Matrix ι ι ℝ) : Prop :=
  ∀ i j, ¬keep i j → B i j = 0

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-MODEL-FIT-LEM-001`: the coordinate mask belongs to its declared support class. -/
lemma coordinateMask_isSupportedOn
    (keep : ι → ι → Prop) [DecidableRel keep]
    (A : Matrix ι ι ℝ) : IsSupportedOn keep (coordinateMask keep A) := by
  intro i j hij
  simp [coordinateMask, hij]

omit [DecidableEq ι] in
/--
`QM-MODEL-FIT-THM-001`: Pythagorean error decomposition for a coordinate-supported model class.
-/
theorem finiteFrobeniusSq_sub_eq_maskResidual_add
    (keep : ι → ι → Prop) [DecidableRel keep]
    (A B : Matrix ι ι ℝ) (hB : IsSupportedOn keep B) :
    finiteFrobeniusSq (A - B) =
      finiteFrobeniusSq (A - coordinateMask keep A) +
        finiteFrobeniusSq (coordinateMask keep A - B) := by
  simp only [finiteFrobeniusSq, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  by_cases hij : keep i j
  · simp [coordinateMask, hij]
  · have hBij : B i j = 0 := hB i j hij
    simp [coordinateMask, hij, hBij]

omit [DecidableEq ι] in
/-- `QM-MODEL-FIT-LEM-002`: squared finite Frobenius magnitude is nonnegative. -/
lemma finiteFrobeniusSq_nonneg (A : Matrix ι ι ℝ) : 0 ≤ finiteFrobeniusSq A := by
  exact Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => sq_nonneg _

omit [DecidableEq ι] in
/--
`QM-MODEL-FIT-THM-002`: the coordinate mask is a least-squared-Frobenius fit among matrices with
the declared support.
-/
theorem finiteFrobeniusSq_mask_le
    (keep : ι → ι → Prop) [DecidableRel keep]
    (A B : Matrix ι ι ℝ) (hB : IsSupportedOn keep B) :
    finiteFrobeniusSq (A - coordinateMask keep A) ≤ finiteFrobeniusSq (A - B) := by
  rw [finiteFrobeniusSq_sub_eq_maskResidual_add keep A B hB]
  exact le_add_of_nonneg_right (finiteFrobeniusSq_nonneg _)

/-- `QM-MODEL-FIT-DEF-004`: Frobenius-optimal diagonal coordinate fit. -/
def diagonalFit (A : Matrix ι ι ℝ) : Matrix ι ι ℝ :=
  coordinateMask (fun i j => i = j) A

/-- `QM-MODEL-FIT-THM-003`: retaining the diagonal minimizes loss among diagonal matrices. -/
theorem finiteFrobeniusSq_diagonalFit_le
    (A B : Matrix ι ι ℝ) (hB : ∀ i j, i ≠ j → B i j = 0) :
    finiteFrobeniusSq (A - diagonalFit A) ≤ finiteFrobeniusSq (A - B) := by
  exact finiteFrobeniusSq_mask_le (fun i j => i = j) A B hB

/-- `QM-MODEL-FIT-DEF-005`: symmetric one-band coordinate support on ordered finite indices. -/
def IsTridiagonalCoordinate {N : ℕ} (i j : Fin N) : Prop :=
  i = j ∨ i.val + 1 = j.val ∨ j.val + 1 = i.val

/-- `QM-MODEL-FIT-DEF-006`: coordinate projection onto the tridiagonal band. -/
noncomputable def tridiagonalFit {N : ℕ} (A : Matrix (Fin N) (Fin N) ℝ) :
    Matrix (Fin N) (Fin N) ℝ := by
  classical
  exact coordinateMask IsTridiagonalCoordinate A

/-- `QM-MODEL-FIT-THM-004`: retaining the tridiagonal band minimizes loss in that support class. -/
theorem finiteFrobeniusSq_tridiagonalFit_le {N : ℕ}
    (A B : Matrix (Fin N) (Fin N) ℝ)
    (hB : IsSupportedOn IsTridiagonalCoordinate B) :
    finiteFrobeniusSq (A - tridiagonalFit A) ≤ finiteFrobeniusSq (A - B) := by
  classical
  exact finiteFrobeniusSq_mask_le IsTridiagonalCoordinate A B hB

/-- `QM-MODEL-FIT-DEF-007`: arithmetic mean of a finite real family. -/
noncomputable def finiteMean [Nonempty ι] (f : ι → ℝ) : ℝ :=
  (∑ i, f i) / Fintype.card ι

omit [DecidableEq ι] in
/-- `QM-MODEL-FIT-LEM-003`: deviations from the finite arithmetic mean sum to zero. -/
lemma sum_sub_finiteMean_eq_zero [Nonempty ι] (f : ι → ℝ) :
    ∑ i, (f i - finiteMean f) = 0 := by
  have hcard : (Fintype.card ι : ℝ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  simp only [Finset.sum_sub_distrib, Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  rw [finiteMean]
  field_simp
  ring

/-- `QM-MODEL-FIT-DEF-008`: diagonal contribution to scalar-identity Frobenius loss. -/
def scalarDiagonalLossSq (A : Matrix ι ι ℝ) (c : ℝ) : ℝ :=
  ∑ i, (A i i - c) ^ 2

omit [DecidableEq ι] in
/--
`QM-MODEL-FIT-THM-005`: the mean diagonal value minimizes the scalar-identity diagonal loss.
Off-diagonal entries are independent of the scalar and therefore add the same fixed contribution to
every full Frobenius loss.
-/
theorem scalarDiagonalLossSq_finiteMean_le [Nonempty ι]
    (A : Matrix ι ι ℝ) (c : ℝ) :
    scalarDiagonalLossSq A (finiteMean fun i => A i i) ≤ scalarDiagonalLossSq A c := by
  let m := finiteMean fun i => A i i
  have hsum : ∑ i, (A i i - m) = 0 := sum_sub_finiteMean_eq_zero fun i => A i i
  have hcross :
      (∑ i, 2 * (A i i - m) * (m - c)) =
        2 * (m - c) * (∑ i, (A i i - m)) := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ring
  have hdecomp :
      scalarDiagonalLossSq A c =
        scalarDiagonalLossSq A m + Fintype.card ι * (m - c) ^ 2 := by
    simp only [scalarDiagonalLossSq]
    calc
      ∑ i, (A i i - c) ^ 2 =
          ∑ i, ((A i i - m) ^ 2 + 2 * (A i i - m) * (m - c) + (m - c) ^ 2) := by
            apply Finset.sum_congr rfl
            intro i _
            ring
      _ = (∑ i, (A i i - m) ^ 2) +
          (∑ i, 2 * (A i i - m) * (m - c)) + (∑ _ : ι, (m - c) ^ 2) := by
            rw [Finset.sum_add_distrib, Finset.sum_add_distrib]
      _ = (∑ i, (A i i - m) ^ 2) +
          2 * (m - c) * (∑ i, (A i i - m)) + Fintype.card ι * (m - c) ^ 2 := by
            rw [hcross]
            simp
      _ = (∑ i, (A i i - m) ^ 2) + Fintype.card ι * (m - c) ^ 2 := by
            rw [hsum]
            ring
  rw [hdecomp]
  exact le_add_of_nonneg_right (mul_nonneg (Nat.cast_nonneg _) (sq_nonneg _))

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-MODEL-FIT-THM-006`: the unrestricted coordinate fit is exact. -/
theorem coordinateMask_true_eq (A : Matrix ι ι ℝ) :
    coordinateMask (fun _ _ => True) A = A := by
  classical
  ext i j
  simp [coordinateMask]

end ProjectKoios.QuantumMechanics.FiniteDimensional

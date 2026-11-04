/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.Matrix.Spectrum
public import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Ordered Hermitian spectral-error carriers

This module fixes the ordered eigenvalue carrier used by later arbitrary-rank perturbation results.
For a Hermitian matrix on an arbitrary finite index type `n`, Mathlib's `eigenvalues₀` uses the
canonical ordered index `Fin (Fintype.card n)` and is antitone.  The reused-index function
`eigenvalues : n → ℝ` is intentionally not used as an ordered band carrier because an arbitrary
finite type has no canonical order.

The maximum and root-mean-square errors are separate exact definitions.  This module proves their
basic finite-dimensional relationship and their zero-error characterization through characteristic
polynomials.  Separate modules supply the Weyl and Hoffman--Wielandt perturbation bounds.  This
carrier module does not authenticate runtime eigensolver ordering, floating-point arrays,
degeneracy handling, meshes,
or scientific applicability.
-/

@[expose] public section

open scoped Matrix
open Matrix

namespace ProjectKoios.BandGauge.Foundations

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {A B : Matrix n n ℂ}

/-- `BG-FOUNDATION-DEF-022`: the decreasing, multiplicity-retaining real eigenvalue vector of an
exact Hermitian matrix, indexed canonically by `Fin (Fintype.card n)`. -/
noncomputable def orderedHermitianEigenvalues
    (hA : A.IsHermitian) : Fin (Fintype.card n) → ℝ :=
  hA.eigenvalues₀

/-- `BG-FOUNDATION-DEF-023`: maximum pointwise difference between two canonically ordered
Hermitian eigenvalue vectors. -/
noncomputable def orderedEigenvalueMaxError [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty fun i : Fin (Fintype.card n) =>
    |orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i|

/-- `BG-FOUNDATION-DEF-024`: root-mean-square pointwise difference between two canonically ordered
Hermitian eigenvalue vectors. -/
noncomputable def orderedEigenvalueRmsError [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) : ℝ :=
  Real.sqrt ((∑ i : Fin (Fintype.card n),
    (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2) /
      Fintype.card n)

/-- `BG-FOUNDATION-LEM-004`: the canonical ordered Hermitian eigenvalue vector is decreasing. -/
lemma orderedHermitianEigenvalues_antitone (hA : A.IsHermitian) :
    Antitone (orderedHermitianEigenvalues hA) :=
  hA.eigenvalues₀_antitone

/-- `BG-FOUNDATION-LEM-005`: every ordered eigenvalue difference is bounded by the maximum
ordered-eigenvalue error. -/
lemma orderedEigenvalue_abs_sub_le_maxError [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) (i : Fin (Fintype.card n)) :
    |orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i| ≤
      orderedEigenvalueMaxError hA hB := by
  exact Finset.le_sup'
    (fun j : Fin (Fintype.card n) =>
      |orderedHermitianEigenvalues hA j - orderedHermitianEigenvalues hB j|)
    (Finset.mem_univ i)

/-- `BG-FOUNDATION-LEM-006`: maximum ordered-eigenvalue error is nonnegative. -/
lemma orderedEigenvalueMaxError_nonneg [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    0 ≤ orderedEigenvalueMaxError hA hB := by
  exact (abs_nonneg
      (orderedHermitianEigenvalues hA ⟨0, Fintype.card_pos⟩ -
        orderedHermitianEigenvalues hB ⟨0, Fintype.card_pos⟩)).trans
    (orderedEigenvalue_abs_sub_le_maxError hA hB ⟨0, Fintype.card_pos⟩)

/-- `BG-FOUNDATION-LEM-007`: RMS ordered-eigenvalue error is nonnegative. -/
lemma orderedEigenvalueRmsError_nonneg [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    0 ≤ orderedEigenvalueRmsError hA hB :=
  Real.sqrt_nonneg _

/-- `BG-FOUNDATION-LEM-008`: the square of RMS ordered-eigenvalue error is the normalized sum of
squared ordered-eigenvalue differences. -/
lemma orderedEigenvalueRmsError_sq [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueRmsError hA hB ^ 2 =
      (∑ i : Fin (Fintype.card n),
        (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2) /
          Fintype.card n := by
  rw [orderedEigenvalueRmsError, Real.sq_sqrt]
  positivity

/-- `BG-FOUNDATION-LEM-009`: maximum ordered-eigenvalue error is symmetric. -/
lemma orderedEigenvalueMaxError_comm [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueMaxError hA hB = orderedEigenvalueMaxError hB hA := by
  unfold orderedEigenvalueMaxError
  congr 1
  funext i
  rw [abs_sub_comm]

/-- `BG-FOUNDATION-LEM-010`: RMS ordered-eigenvalue error is symmetric. -/
lemma orderedEigenvalueRmsError_comm [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueRmsError hA hB = orderedEigenvalueRmsError hB hA := by
  unfold orderedEigenvalueRmsError
  congr 2
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- `BG-FOUNDATION-THM-038`: RMS ordered-eigenvalue error is bounded by maximum
ordered-eigenvalue error.  These remain distinct quantities despite this comparison. -/
theorem orderedEigenvalueRmsError_le_maxError [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueRmsError hA hB ≤ orderedEigenvalueMaxError hA hB := by
  rw [← sq_le_sq₀ (orderedEigenvalueRmsError_nonneg hA hB)
    (orderedEigenvalueMaxError_nonneg hA hB), orderedEigenvalueRmsError_sq]
  have hpoint : ∀ i : Fin (Fintype.card n),
      (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2 ≤
        orderedEigenvalueMaxError hA hB ^ 2 := by
    intro i
    rw [← sq_abs]
    exact (sq_le_sq₀ (abs_nonneg _)
      (orderedEigenvalueMaxError_nonneg hA hB)).2
      (orderedEigenvalue_abs_sub_le_maxError hA hB i)
  have hsum :
      (∑ i : Fin (Fintype.card n),
        (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2) ≤
          Fintype.card n * orderedEigenvalueMaxError hA hB ^ 2 := by
    simpa using Finset.sum_le_card_nsmul Finset.univ
      (fun i : Fin (Fintype.card n) =>
        (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2)
      (orderedEigenvalueMaxError hA hB ^ 2)
      (fun i _ => hpoint i)
  rw [div_le_iff₀ (Nat.cast_pos.mpr Fintype.card_pos)]
  simpa [Nat.cast_ofNat, Nat.cast_mul, mul_comm] using hsum

/-- `BG-FOUNDATION-THM-039`: equality of the canonical ordered eigenvalue vectors, including
multiplicity, is equivalent to equality of characteristic polynomials. -/
theorem orderedHermitianEigenvalues_eq_iff_charpoly_eq
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedHermitianEigenvalues hA = orderedHermitianEigenvalues hB ↔
      A.charpoly = B.charpoly := by
  constructor
  · intro heq
    apply (hA.eigenvalues_eq_eigenvalues_iff hB).mp
    have heq₀ : hA.eigenvalues₀ = hB.eigenvalues₀ := by
      simpa [orderedHermitianEigenvalues] using heq
    unfold Matrix.IsHermitian.eigenvalues
    rw [heq₀]
  · intro hchar
    unfold orderedHermitianEigenvalues
    rw [← List.ofFn_inj, ← hA.sort_roots_charpoly_eq_eigenvalues₀,
      ← hB.sort_roots_charpoly_eq_eigenvalues₀, hchar]

/-- `BG-FOUNDATION-THM-040`: maximum ordered-eigenvalue error vanishes exactly when the two
Hermitian matrices have the same characteristic polynomial. -/
theorem orderedEigenvalueMaxError_eq_zero_iff_charpoly_eq [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueMaxError hA hB = 0 ↔ A.charpoly = B.charpoly := by
  rw [← orderedHermitianEigenvalues_eq_iff_charpoly_eq hA hB]
  constructor
  · intro hzero
    funext i
    have hle := orderedEigenvalue_abs_sub_le_maxError hA hB i
    rw [hzero] at hle
    exact sub_eq_zero.mp (abs_eq_zero.mp (le_antisymm hle (abs_nonneg _)))
  · intro heq
    unfold orderedEigenvalueMaxError
    simp [heq]

/-- `BG-FOUNDATION-THM-041`: RMS ordered-eigenvalue error vanishes exactly when the two Hermitian
matrices have the same characteristic polynomial. -/
theorem orderedEigenvalueRmsError_eq_zero_iff_charpoly_eq [Nonempty n]
    (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueRmsError hA hB = 0 ↔ A.charpoly = B.charpoly := by
  rw [← orderedHermitianEigenvalues_eq_iff_charpoly_eq hA hB]
  constructor
  · intro hzero
    have hsum :
        (∑ i : Fin (Fintype.card n),
          (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2) = 0 := by
      have hsquare := orderedEigenvalueRmsError_sq hA hB
      rw [hzero, zero_pow (by norm_num : (2 : ℕ) ≠ 0)] at hsquare
      have hdiv :
          (∑ i : Fin (Fintype.card n),
            (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2) /
              (Fintype.card n : ℝ) = 0 := hsquare.symm
      exact (div_eq_zero_iff.mp hdiv).resolve_right
        (Nat.cast_ne_zero.mpr (ne_of_gt Fintype.card_pos))
    funext i
    have hi :
        (orderedHermitianEigenvalues hA i - orderedHermitianEigenvalues hB i) ^ 2 = 0 := by
      rw [Finset.sum_eq_zero_iff_of_nonneg
        (fun j _ => sq_nonneg
          (orderedHermitianEigenvalues hA j - orderedHermitianEigenvalues hB j))] at hsum
      exact hsum i (Finset.mem_univ i)
    exact sub_eq_zero.mp (sq_eq_zero_iff.mp hi)
  · intro heq
    unfold orderedEigenvalueRmsError
    simp [heq]

end ProjectKoios.BandGauge.Foundations

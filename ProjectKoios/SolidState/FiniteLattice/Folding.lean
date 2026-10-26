/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.Fourier.FiniteAbelian.PontryaginDuality
public import Mathlib.LinearAlgebra.Matrix.Kronecker

/-!
# Exact finite block folding

This module gives a normalized finite-character folding matrix, its orbital-block lift, optional
unit-modulus row phases, and exact block diagonalization of a finite translation-invariant block
operator.  The one-dimensional cyclic-supercell case is obtained by taking `G = ZMod N`.

The normalization and character inventory are exact.  No floating-point Fourier matrix, retained
hopping array, twist value, momentum representative, numerical spectrum, or external artifact is
bound here.  A nontrivial boundary twist may be represented by `twistedBlockFoldingMatrix` after a
caller proves unit modulus of every declared row phase; the block-diagonalization theorem below is
for the untwisted translation-invariant operator.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate InnerProductSpace Kronecker Matrix
open Fintype (card)

namespace ProjectKoios.SolidState.FiniteLattice

variable {G ι : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
  [Fintype ι] [DecidableEq ι]

/-- `SS-FOLDING-DEF-001`: inverse square-root cardinality normalization. -/
noncomputable def foldingNormalization : ℂ :=
  (Real.sqrt (card G : ℝ))⁻¹

omit [DecidableEq G] in
private theorem card_real_pos : 0 < (card G : ℝ) := by
  exact_mod_cast Fintype.card_pos

omit [DecidableEq G] in
/-- `SS-FOLDING-THM-001`: normalization squared times the finite cardinality is one. -/
theorem foldingNormalization_conj_mul_card :
    conj (foldingNormalization (G := G)) * foldingNormalization (G := G) *
      (card G : ℂ) = 1 := by
  have hsq : (Real.sqrt (card G : ℝ)) ^ 2 = (card G : ℝ) :=
    Real.sq_sqrt (le_of_lt (card_real_pos (G := G)))
  simp [foldingNormalization]
  field_simp
  exact_mod_cast hsq.symm

omit [DecidableEq G] in
/-- `SS-FOLDING-THM-002`: unnormalized finite characters have cardinality-weighted orthogonality. -/
theorem sum_conj_character_mul_character (χ ψ : AddChar G ℂ) :
    ∑ n, conj (χ n) * ψ n = (card G : ℂ) * if χ = ψ then 1 else 0 := by
  have h := AddChar.wInner_cWeight_eq_boole χ ψ
  rw [RCLike.wInner_cWeight_eq_expect, Fintype.expect_eq_sum_div_card] at h
  simp only [RCLike.inner_apply'] at h
  rw [div_eq_iff] at h
  · simpa [mul_comm] using h
  · exact_mod_cast Fintype.card_ne_zero

/-- `SS-FOLDING-DEF-002`: normalized finite-character map from modes to cells. -/
noncomputable def cellFoldingMatrix : Matrix G (AddChar G ℂ) ℂ :=
  fun n χ => foldingNormalization (G := G) * χ n

omit [DecidableEq G] in
/-- `SS-FOLDING-THM-003`: the normalized cell folding matrix has orthonormal columns. -/
theorem cellFoldingMatrix_conjTranspose_mul :
    (cellFoldingMatrix (G := G))ᴴ * cellFoldingMatrix (G := G) = 1 := by
  ext χ ψ
  change (∑ n, conj (cellFoldingMatrix (G := G) n χ) *
    cellFoldingMatrix (G := G) n ψ) = if χ = ψ then 1 else 0
  simp only [cellFoldingMatrix]
  simp_rw [map_mul]
  have hreorder (n : G) :
      conj (foldingNormalization (G := G)) * conj (χ n) *
          (foldingNormalization (G := G) * ψ n) =
        (conj (foldingNormalization (G := G)) * foldingNormalization (G := G)) *
          (conj (χ n) * ψ n) := by
    ring
  simp_rw [hreorder, ← Finset.mul_sum]
  rw [sum_conj_character_mul_character]
  by_cases h : χ = ψ
  · subst ψ
    simp [foldingNormalization_conj_mul_card (G := G)]
  · simp [h]

/-- `SS-FOLDING-THM-012`: the normalized cell folding matrix also has orthonormal rows. -/
theorem cellFoldingMatrix_mul_conjTranspose :
    cellFoldingMatrix (G := G) * (cellFoldingMatrix (G := G))ᴴ = 1 := by
  ext n m
  change (∑ χ, cellFoldingMatrix (G := G) n χ *
    conj (cellFoldingMatrix (G := G) m χ)) = if n = m then 1 else 0
  simp only [cellFoldingMatrix, map_mul]
  have hreorder (χ : AddChar G ℂ) :
      (foldingNormalization (G := G) * χ n) *
          (conj (foldingNormalization (G := G)) * conj (χ m)) =
        (conj (foldingNormalization (G := G)) * foldingNormalization (G := G)) *
          χ (n - m) := by
    rw [← AddChar.map_neg_eq_conj]
    rw [show (foldingNormalization (G := G) * χ n) *
        (conj (foldingNormalization (G := G)) * χ (-m)) =
      (conj (foldingNormalization (G := G)) * foldingNormalization (G := G)) *
        (χ n * χ (-m)) by ring]
    rw [← AddChar.map_add_eq_mul]
    simp [sub_eq_add_neg]
  simp_rw [hreorder, ← Finset.mul_sum]
  rw [AddChar.sum_apply_eq_ite]
  by_cases h : n = m
  · subst m
    simp [foldingNormalization_conj_mul_card (G := G)]
  · have hsub : n - m ≠ 0 := sub_ne_zero.mpr h
    simp [h, hsub]

/-- `SS-FOLDING-DEF-003`: cell-major folding matrix with an unchanged orbital block. -/
noncomputable def blockFoldingMatrix :
    Matrix (G × ι) (AddChar G ℂ × ι) ℂ :=
  fun x y => cellFoldingMatrix (G := G) x.1 y.1 * if x.2 = y.2 then 1 else 0

omit [DecidableEq G] [Fintype ι] in
private theorem blockFoldingMatrix_conj_apply (n : G) (a : ι) (χ : AddChar G ℂ) (b : ι) :
    conj (blockFoldingMatrix (G := G) (ι := ι) (n, a) (χ, b)) =
      if a = b then conj (cellFoldingMatrix (G := G) n χ) else 0 := by
  by_cases h : a = b <;> simp [blockFoldingMatrix, h]

omit [DecidableEq G] [Fintype ι] in
/-- `SS-FOLDING-THM-004`: block folding is the cell transform Kronecker the orbital identity. -/
theorem blockFoldingMatrix_eq_kronecker :
    blockFoldingMatrix (G := G) (ι := ι) =
      (cellFoldingMatrix (G := G)) ⊗ₖ (1 : Matrix ι ι ℂ) := by
  ext x y
  simp [blockFoldingMatrix, Matrix.one_apply]

omit [DecidableEq G] in
/-- `SS-FOLDING-THM-005`: the block folding matrix has orthonormal columns. -/
theorem blockFoldingMatrix_conjTranspose_mul :
    (blockFoldingMatrix (G := G) (ι := ι))ᴴ * blockFoldingMatrix (G := G) (ι := ι) = 1 := by
  rw [blockFoldingMatrix_eq_kronecker, Matrix.conjTranspose_kronecker,
    ← Matrix.mul_kronecker_mul]
  rw [cellFoldingMatrix_conjTranspose_mul]
  simp

/-- `SS-FOLDING-THM-013`: the block folding matrix also has orthonormal rows. -/
theorem blockFoldingMatrix_mul_conjTranspose :
    blockFoldingMatrix (G := G) (ι := ι) *
      (blockFoldingMatrix (G := G) (ι := ι))ᴴ = 1 := by
  rw [blockFoldingMatrix_eq_kronecker, Matrix.conjTranspose_kronecker,
    ← Matrix.mul_kronecker_mul]
  rw [cellFoldingMatrix_mul_conjTranspose]
  simp

/-- `SS-FOLDING-DEF-004`: normalized cell folding with a caller-supplied row phase. -/
noncomputable def twistedCellFoldingMatrix (phase : G → ℂ) : Matrix G (AddChar G ℂ) ℂ :=
  fun n χ => phase n * cellFoldingMatrix (G := G) n χ

omit [DecidableEq G] in
/-- `SS-FOLDING-THM-006`: unit-modulus row phases preserve folding unitarity. -/
theorem twistedCellFoldingMatrix_conjTranspose_mul (phase : G → ℂ)
    (hphase : ∀ n, conj (phase n) * phase n = 1) :
    (twistedCellFoldingMatrix (G := G) phase)ᴴ *
      twistedCellFoldingMatrix (G := G) phase = 1 := by
  ext χ ψ
  change (∑ n, conj (twistedCellFoldingMatrix (G := G) phase n χ) *
    twistedCellFoldingMatrix (G := G) phase n ψ) = if χ = ψ then 1 else 0
  have hterm (n : G) :
      conj (twistedCellFoldingMatrix (G := G) phase n χ) *
          twistedCellFoldingMatrix (G := G) phase n ψ =
        conj (cellFoldingMatrix (G := G) n χ) * cellFoldingMatrix (G := G) n ψ := by
    simp only [twistedCellFoldingMatrix, map_mul]
    rw [show conj (phase n) * conj (cellFoldingMatrix (G := G) n χ) *
        (phase n * cellFoldingMatrix (G := G) n ψ) =
        (conj (phase n) * phase n) *
          (conj (cellFoldingMatrix (G := G) n χ) *
            cellFoldingMatrix (G := G) n ψ) by ring]
    rw [hphase]
    simp
  simp_rw [hterm]
  have h := congrFun (congrFun (cellFoldingMatrix_conjTranspose_mul (G := G)) χ) ψ
  change (∑ n, conj (cellFoldingMatrix (G := G) n χ) *
    cellFoldingMatrix (G := G) n ψ) = (if χ = ψ then 1 else 0) at h
  exact h

/-- `SS-FOLDING-THM-014`: unit-modulus row phases preserve cell-folding row orthonormality. -/
theorem twistedCellFoldingMatrix_mul_conjTranspose (phase : G → ℂ)
    (hphase : ∀ n, conj (phase n) * phase n = 1) :
    twistedCellFoldingMatrix (G := G) phase *
      (twistedCellFoldingMatrix (G := G) phase)ᴴ = 1 := by
  ext n m
  change (∑ χ, twistedCellFoldingMatrix (G := G) phase n χ *
    conj (twistedCellFoldingMatrix (G := G) phase m χ)) = if n = m then 1 else 0
  simp only [twistedCellFoldingMatrix, map_mul]
  have hreorder (χ : AddChar G ℂ) :
      (phase n * cellFoldingMatrix (G := G) n χ) *
          (conj (phase m) * conj (cellFoldingMatrix (G := G) m χ)) =
        (phase n * conj (phase m)) *
          (cellFoldingMatrix (G := G) n χ *
            conj (cellFoldingMatrix (G := G) m χ)) := by
    ring
  simp_rw [hreorder, ← Finset.mul_sum]
  have h := congrFun (congrFun (cellFoldingMatrix_mul_conjTranspose (G := G)) n) m
  change (∑ χ, cellFoldingMatrix (G := G) n χ *
    conj (cellFoldingMatrix (G := G) m χ)) = (if n = m then 1 else 0) at h
  rw [h]
  by_cases hnm : n = m
  · subst m
    simp only [ite_true, mul_one]
    rw [mul_comm]
    exact hphase n
  · simp [hnm]

/-- `SS-FOLDING-DEF-005`: orbital-block folding with caller-supplied row phases. -/
noncomputable def twistedBlockFoldingMatrix (phase : G → ℂ) :
    Matrix (G × ι) (AddChar G ℂ × ι) ℂ :=
  (twistedCellFoldingMatrix (G := G) phase) ⊗ₖ (1 : Matrix ι ι ℂ)

omit [DecidableEq G] in
/-- `SS-FOLDING-THM-007`: unit-modulus row phases preserve block-folding unitarity. -/
theorem twistedBlockFoldingMatrix_conjTranspose_mul (phase : G → ℂ)
    (hphase : ∀ n, conj (phase n) * phase n = 1) :
    (twistedBlockFoldingMatrix (G := G) (ι := ι) phase)ᴴ *
      twistedBlockFoldingMatrix (G := G) (ι := ι) phase = 1 := by
  rw [twistedBlockFoldingMatrix, Matrix.conjTranspose_kronecker,
    ← Matrix.mul_kronecker_mul]
  rw [twistedCellFoldingMatrix_conjTranspose_mul phase hphase]
  simp

/-- `SS-FOLDING-THM-015`: unit-modulus row phases preserve block-folding row orthonormality. -/
theorem twistedBlockFoldingMatrix_mul_conjTranspose (phase : G → ℂ)
    (hphase : ∀ n, conj (phase n) * phase n = 1) :
    twistedBlockFoldingMatrix (G := G) (ι := ι) phase *
      (twistedBlockFoldingMatrix (G := G) (ι := ι) phase)ᴴ = 1 := by
  rw [twistedBlockFoldingMatrix, Matrix.conjTranspose_kronecker,
    ← Matrix.mul_kronecker_mul]
  rw [twistedCellFoldingMatrix_mul_conjTranspose phase hphase]
  simp

/-- `SS-FOLDING-DEF-006`: finite translation by one declared group displacement. -/
noncomputable def cellShiftMatrix (r : G) : Matrix G G ℂ :=
  fun n m => if m - n = r then 1 else 0

/--
`SS-FOLDING-DEF-007`: translation-invariant cell-major block operator assembled from one block per
finite group displacement.
-/
noncomputable def blockHoppingSupercell (hopping : G → Matrix ι ι ℂ) :
    Matrix (G × ι) (G × ι) ℂ :=
  ∑ r, (cellShiftMatrix r) ⊗ₖ hopping r

omit [Fintype ι] [DecidableEq ι] in
/-- `SS-FOLDING-THM-008`: entrywise block-supercell assembly uses the relative displacement. -/
theorem blockHoppingSupercell_apply (hopping : G → Matrix ι ι ℂ)
    (n m : G) (a b : ι) :
    blockHoppingSupercell hopping (n, a) (m, b) = hopping (m - n) a b := by
  simp [blockHoppingSupercell, cellShiftMatrix, Matrix.sum_apply]

/-- `SS-FOLDING-DEF-008`: exact finite Bloch block for one character. -/
noncomputable def blochFiber (hopping : G → Matrix ι ι ℂ)
    (χ : AddChar G ℂ) : Matrix ι ι ℂ :=
  ∑ r, χ r • hopping r

/-- `SS-FOLDING-DEF-009`: block-diagonal inventory of all exact finite Bloch fibers. -/
noncomputable def foldedBlochBlockDiagonal (hopping : G → Matrix ι ι ℂ) :
    Matrix (AddChar G ℂ × ι) (AddChar G ℂ × ι) ℂ :=
  fun x y => if x.1 = y.1 then blochFiber hopping x.1 x.2 y.2 else 0

private noncomputable def scalarCirculant (hopping : G → ℂ) : Matrix G G ℂ :=
  fun n m => hopping (m - n)

private noncomputable def scalarBlochFiber (hopping : G → ℂ) (χ : AddChar G ℂ) : ℂ :=
  ∑ r, χ r * hopping r

private noncomputable def scalarBlochDiagonal (hopping : G → ℂ) :
    Matrix (AddChar G ℂ) (AddChar G ℂ) ℂ :=
  fun χ ψ => if χ = ψ then scalarBlochFiber hopping χ else 0

private def differenceCoordinatesEquiv : G × G ≃ G × G where
  toFun x := (x.1, x.1 + x.2)
  invFun x := (x.1, x.2 - x.1)
  left_inv x := by simp
  right_inv x := by simp

omit [DecidableEq G] in
private theorem scalarCirculant_diagonalization (hopping : G → ℂ) :
    (cellFoldingMatrix (G := G))ᴴ * scalarCirculant hopping *
      cellFoldingMatrix (G := G) = scalarBlochDiagonal hopping := by
  ext χ ψ
  simp only [Matrix.mul_apply, Matrix.conjTranspose_apply, scalarCirculant,
    scalarBlochDiagonal]
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  have hprod :
      (∑ x : G × G, conj (cellFoldingMatrix (G := G) x.1 χ) *
        hopping (x.2 - x.1) * cellFoldingMatrix (G := G) x.2 ψ) =
      ∑ n, ∑ m, conj (cellFoldingMatrix (G := G) n χ) *
        hopping (m - n) * cellFoldingMatrix (G := G) m ψ := by
    rw [Fintype.sum_prod_type]
  change (∑ n : G, ∑ m : G, conj (cellFoldingMatrix (G := G) n χ) *
    hopping (m - n) * cellFoldingMatrix (G := G) m ψ) = _
  rw [← hprod]
  rw [← (differenceCoordinatesEquiv (G := G)).sum_comp (fun x : G × G =>
    conj (cellFoldingMatrix (G := G) x.1 χ) * hopping (x.2 - x.1) *
      cellFoldingMatrix (G := G) x.2 ψ)]
  simp only [differenceCoordinatesEquiv, Equiv.coe_fn_mk, add_sub_cancel_left]
  simp only [cellFoldingMatrix, map_mul]
  have hreorder (n r : G) :
      (conj (foldingNormalization (G := G)) * conj (χ n)) * hopping r *
          (foldingNormalization (G := G) * ψ (n + r)) =
        (conj (foldingNormalization (G := G)) * foldingNormalization (G := G)) *
          (conj (χ n) * ψ n) * (ψ r * hopping r) := by
    rw [AddChar.map_add_eq_mul]
    ring
  simp_rw [hreorder]
  rw [Fintype.sum_prod_type]
  simp_rw [← Finset.mul_sum]
  rw [← Finset.sum_mul]
  rw [← Finset.mul_sum]
  rw [sum_conj_character_mul_character]
  by_cases heq : χ = ψ
  · subst ψ
    simp [scalarBlochFiber, foldingNormalization_conj_mul_card (G := G)]
  · simp [heq]

private theorem cellShiftMatrix_diagonalization (r : G) :
    (cellFoldingMatrix (G := G))ᴴ * cellShiftMatrix r * cellFoldingMatrix (G := G) =
      fun χ ψ => if χ = ψ then χ r else 0 := by
  have hc : scalarCirculant (fun s => if s = r then 1 else 0) = cellShiftMatrix r := by
    ext n m
    simp [scalarCirculant, cellShiftMatrix]
  rw [← hc, scalarCirculant_diagonalization]
  ext χ ψ
  by_cases heq : χ = ψ
  · subst ψ
    simp [scalarBlochDiagonal, scalarBlochFiber]
  · simp [scalarBlochDiagonal, heq]

/--
`SS-FOLDING-THM-009`: normalized finite block folding exactly diagonalizes a translation-invariant
block-hopping supercell into its complete finite Bloch-fiber inventory.
-/
theorem blockHoppingSupercell_diagonalization (hopping : G → Matrix ι ι ℂ) :
    (blockFoldingMatrix (G := G) (ι := ι))ᴴ * blockHoppingSupercell hopping *
      blockFoldingMatrix (G := G) (ι := ι) = foldedBlochBlockDiagonal hopping := by
  rw [blockFoldingMatrix_eq_kronecker]
  simp only [blockHoppingSupercell]
  rw [Matrix.conjTranspose_kronecker]
  simp_rw [Matrix.mul_sum, Matrix.sum_mul]
  simp_rw [← Matrix.mul_kronecker_mul]
  simp
  ext ⟨χ, a⟩ ⟨ψ, b⟩
  rw [Matrix.sum_apply]
  simp_rw [Matrix.kronecker_apply]
  by_cases heq : χ = ψ
  · subst ψ
    simp [cellShiftMatrix_diagonalization, foldedBlochBlockDiagonal, blochFiber]
    rw [Matrix.sum_apply]
    rfl
  · simp [cellShiftMatrix_diagonalization, foldedBlochBlockDiagonal, heq]

/-- `SS-FOLDING-THM-010`: cyclic `N`-cell block folding is unitary. -/
theorem cyclicBlockFoldingMatrix_conjTranspose_mul (N : ℕ) [NeZero N] :
    (blockFoldingMatrix (G := ZMod N) (ι := ι))ᴴ *
      blockFoldingMatrix (G := ZMod N) (ι := ι) = 1 :=
  blockFoldingMatrix_conjTranspose_mul

/-- `SS-FOLDING-THM-016`: cyclic `N`-cell block folding is unitary in the reverse product. -/
theorem cyclicBlockFoldingMatrix_mul_conjTranspose (N : ℕ) [NeZero N] :
    blockFoldingMatrix (G := ZMod N) (ι := ι) *
      (blockFoldingMatrix (G := ZMod N) (ι := ι))ᴴ = 1 :=
  blockFoldingMatrix_mul_conjTranspose

/-- `SS-FOLDING-THM-011`: the cyclic `N`-cell block supercell folds into Bloch fibers. -/
theorem cyclicBlockHoppingSupercell_diagonalization (N : ℕ) [NeZero N]
    (hopping : ZMod N → Matrix ι ι ℂ) :
    (blockFoldingMatrix (G := ZMod N) (ι := ι))ᴴ * blockHoppingSupercell hopping *
      blockFoldingMatrix (G := ZMod N) (ι := ι) = foldedBlochBlockDiagonal hopping :=
  blockHoppingSupercell_diagonalization hopping

end ProjectKoios.SolidState.FiniteLattice

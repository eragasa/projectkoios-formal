/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinEmbedding
public import ProjectKoios.SolidState.FiniteLattice.Folding

/-!
# Finite route commutativity

Exact source-neutral matrix identities for coordinate alignment, energy-reference correction,
defect subtraction, folding, and two-state spin lifting.  Coordinate change uses `Uᴴ A U`, so a
folding matrix maps a cell-space operator to folded coordinates.

These declarations do not decide representation compatibility, infer an alignment, validate a
runtime matrix, accept a numerical tolerance, or identify any retained calculation artifact.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Kronecker Matrix

namespace ProjectKoios.SolidState.FiniteLattice

variable {ι κ : Type*} [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]

/-- `SS-ROUTE-DEF-001`: conjugate-transpose coordinate pullback `Uᴴ A U`. -/
noncomputable def coordinateChange (U : Matrix ι κ ℂ) (A : Matrix ι ι ℂ) : Matrix κ κ ℂ :=
  Uᴴ * A * U

/-- `SS-ROUTE-DEF-002`: tensor a rectangular orbital coordinate map with the spin identity. -/
noncomputable def spinCoordinateLift (U : Matrix ι κ ℂ) :
    Matrix (ι × Fin 2) (κ × Fin 2) ℂ :=
  U ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)

omit [DecidableEq ι] [Fintype κ] [DecidableEq κ] in
/-- `SS-ROUTE-THM-001`: coordinate change preserves addition. -/
theorem coordinateChange_add (U : Matrix ι κ ℂ) (A B : Matrix ι ι ℂ) :
    coordinateChange U (A + B) = coordinateChange U A + coordinateChange U B := by
  simp [coordinateChange, Matrix.mul_add, Matrix.add_mul]

omit [DecidableEq ι] [Fintype κ] [DecidableEq κ] in
/-- `SS-ROUTE-THM-002`: coordinate change commutes with subtraction. -/
theorem coordinateChange_sub (U : Matrix ι κ ℂ) (A B : Matrix ι ι ℂ) :
    coordinateChange U (A - B) = coordinateChange U A - coordinateChange U B := by
  simp [coordinateChange, Matrix.mul_sub, Matrix.sub_mul]

omit [DecidableEq ι] [DecidableEq κ] in
/-- `SS-ROUTE-THM-003`: two successive coordinate changes compose in the declared order. -/
theorem coordinateChange_comp {υ : Type*} (U : Matrix ι κ ℂ) (V : Matrix κ υ ℂ)
    (A : Matrix ι ι ℂ) :
    coordinateChange V (coordinateChange U A) = coordinateChange (U * V) A := by
  simp only [coordinateChange, Matrix.conjTranspose_mul]
  simp only [← Matrix.mul_assoc]

omit [Fintype κ] in
/-- `SS-ROUTE-THM-004`: an isometric coordinate map preserves a scalar identity operator. -/
theorem coordinateChange_smul_one (U : Matrix ι κ ℂ) (c : ℂ)
    (hU : Uᴴ * U = 1) :
    coordinateChange U (c • (1 : Matrix ι ι ℂ)) = c • (1 : Matrix κ κ ℂ) := by
  simp [coordinateChange, Matrix.mul_smul, Matrix.smul_mul, hU]

omit [Fintype κ] in
/-- `SS-ROUTE-THM-005`: scalar energy-reference removal commutes with an isometric map. -/
theorem coordinateChange_sub_scalar (U : Matrix ι κ ℂ) (A : Matrix ι ι ℂ) (c : ℂ)
    (hU : Uᴴ * U = 1) :
    coordinateChange U (A - c • (1 : Matrix ι ι ℂ)) =
      coordinateChange U A - c • (1 : Matrix κ κ ℂ) := by
  rw [coordinateChange_sub, coordinateChange_smul_one U c hU]

omit [DecidableEq ι] [Fintype κ] [DecidableEq κ] in
/-- `SS-ROUTE-THM-006`: coordinate pullback preserves Hermiticity. -/
theorem coordinateChange_isHermitian (U : Matrix ι κ ℂ) (A : Matrix ι ι ℂ)
    (hA : A.IsHermitian) : (coordinateChange U A).IsHermitian := by
  unfold Matrix.IsHermitian at hA ⊢
  simp only [coordinateChange, Matrix.conjTranspose_mul, hA,
    Matrix.conjTranspose_conjTranspose]
  exact (Matrix.mul_assoc Uᴴ A U).symm

omit [DecidableEq ι] [Fintype κ] [DecidableEq κ] in
/-- `SS-ROUTE-THM-010`: rectangular orbital coordinate change commutes with the spin lift. -/
theorem coordinateChange_spinCoordinateLift
    (U : Matrix ι κ ℂ) (A : Matrix ι ι ℂ) :
    coordinateChange (spinCoordinateLift U)
        (ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift A) =
      ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift
        (coordinateChange U A) := by
  simp only [coordinateChange, spinCoordinateLift,
    ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift,
    Matrix.conjTranspose_kronecker, ← Matrix.mul_kronecker_mul]
  simp

omit [DecidableEq ι] in
/-- `SS-ROUTE-THM-007`: square orbital coordinate change commutes with the exact spin lift. -/
theorem coordinateChange_spinDegenerateLift (U A : Matrix ι ι ℂ) :
    coordinateChange
        (ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift U)
        (ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift A) =
      ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift
        (coordinateChange U A) := by
  simp only [coordinateChange,
    ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift_conjTranspose,
    ProjectKoios.QuantumMechanics.FiniteDimensional.spinDegenerateLift_mul]

omit [DecidableEq ι] in
/--
`SS-ROUTE-THM-008`: if the pristine operator folds to the declared fiber inventory, defect
subtraction commutes exactly with folding.
-/
theorem defectExtraction_folding_commutes (F Hd H0 Hfiber : Matrix ι ι ℂ)
    (hpristine : coordinateChange F H0 = Hfiber) :
    coordinateChange F (Hd - H0) = coordinateChange F Hd - Hfiber := by
  rw [coordinateChange_sub, hpristine]

/--
`SS-ROUTE-THM-009`: alignment, scalar energy correction, defect subtraction, and folding commute
when both coordinate maps are isometric.
-/
theorem alignedShiftedDefectExtraction_folding_commutes
    (F T Hd H0 : Matrix ι ι ℂ) (c : ℂ)
    (hF : Fᴴ * F = 1) (hT : Tᴴ * T = 1) :
    coordinateChange F (coordinateChange T (Hd - c • (1 : Matrix ι ι ℂ)) - H0) =
      coordinateChange (T * F) Hd - c • (1 : Matrix ι ι ℂ) - coordinateChange F H0 := by
  have hTF : (T * F)ᴴ * (T * F) = 1 := by
    rw [Matrix.conjTranspose_mul]
    calc
      Fᴴ * Tᴴ * (T * F) = Fᴴ * (Tᴴ * T) * F := by noncomm_ring
      _ = 1 := by simp [hT, hF]
  rw [coordinateChange_sub, coordinateChange_comp,
    coordinateChange_sub_scalar (T * F) Hd c hTF]

end ProjectKoios.SolidState.FiniteLattice

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import Mathlib.Data.ZMod.Basic
public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.NormNum

/-!
# Exact FCC--Bain coordinate bridge

This module encodes the two fixed integer matrices exposed by
`projectkoios.physkit.periodic.lattice.bain.bridge.FccBainCoordinateBridge3D`
at PhysKit commit `7157dcedd0d220673d443c1c025e35a6fd1ffa7a`.

The results concern exact matrices over `ℤ` and their induced maps over `ZMod n`.
They do not verify Python execution, signed-64-bit arithmetic, crystallographic source
fidelity beyond the cited constants, or physical applicability.
-/

@[expose] public section

namespace ProjectKoios.Crosswalks.PhysKit

open Matrix

/-- Three-component coordinate vectors over a scalar type. -/
abbrev Coordinate3 (R : Type*) := Fin 3 → R

/-- The exact source matrix in `n_F = U n_B`. -/
def bainToFccMatrix : Matrix (Fin 3) (Fin 3) ℤ :=
  !![(1 : ℤ), 1, 0;
     0, 0, 1;
     0, -1, 0]

/-- The exact source matrix declared as the inverse FCC-to-Bain coordinate map. -/
def fccToBainMatrix : Matrix (Fin 3) (Fin 3) ℤ :=
  !![(1 : ℤ), 0, 1;
     0, 0, -1;
     0, 1, 0]

/-- The Bain-to-FCC matrix reduced into the coefficient ring `ZMod n`. -/
def bainToFccMatrixMod (n : ℕ) : Matrix (Fin 3) (Fin 3) (ZMod n) :=
  bainToFccMatrix.map (Int.castRingHom (ZMod n))

/-- The FCC-to-Bain matrix reduced into the coefficient ring `ZMod n`. -/
def fccToBainMatrixMod (n : ℕ) : Matrix (Fin 3) (Fin 3) (ZMod n) :=
  fccToBainMatrix.map (Int.castRingHom (ZMod n))

/-- The column-coordinate map induced by `bainToFccMatrix` modulo `n`. -/
def bainToFccModMap (n : ℕ) (x : Coordinate3 (ZMod n)) : Coordinate3 (ZMod n) :=
  bainToFccMatrixMod n *ᵥ x

/-- The column-coordinate map induced by `fccToBainMatrix` modulo `n`. -/
def fccToBainModMap (n : ℕ) (x : Coordinate3 (ZMod n)) : Coordinate3 (ZMod n) :=
  fccToBainMatrixMod n *ᵥ x

/-- `PKF-PHYSKIT-THM-001`: the declared Bain-to-FCC matrix followed by the declared
FCC-to-Bain matrix is the identity over the integers. -/
theorem bainToFccMatrix_mul_fccToBainMatrix :
    bainToFccMatrix * fccToBainMatrix = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [bainToFccMatrix, fccToBainMatrix, Matrix.mul_apply, Fin.sum_univ_succ]

/-- `PKF-PHYSKIT-THM-002`: the declared FCC-to-Bain matrix followed by the declared
Bain-to-FCC matrix is the identity over the integers. -/
theorem fccToBainMatrix_mul_bainToFccMatrix :
    fccToBainMatrix * bainToFccMatrix = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [bainToFccMatrix, fccToBainMatrix, Matrix.mul_apply, Fin.sum_univ_succ]

/-- `PKF-PHYSKIT-THM-003`: the exact Bain-to-FCC integer matrix has determinant one. -/
theorem bainToFccMatrix_det : Matrix.det bainToFccMatrix = 1 := by
  norm_num [Matrix.det_fin_three, bainToFccMatrix]

/-- `PKF-PHYSKIT-THM-004`: for every positive modulus, the two declared maps are
mutual inverses over `ZMod n`. The result is algebraic and does not describe signed-64-bit
execution. -/
theorem bainToFccModMap_mutualInverse (n : ℕ) (_hn : 0 < n) :
    Function.LeftInverse (fccToBainModMap n) (bainToFccModMap n) ∧
      Function.RightInverse (fccToBainModMap n) (bainToFccModMap n) := by
  constructor
  · intro x
    rw [bainToFccModMap, fccToBainModMap, Matrix.mulVec_mulVec]
    unfold bainToFccMatrixMod fccToBainMatrixMod
    rw [← Matrix.map_mul, fccToBainMatrix_mul_bainToFccMatrix]
    simp
  · intro x
    rw [bainToFccModMap, fccToBainModMap, Matrix.mulVec_mulVec]
    unfold bainToFccMatrixMod fccToBainMatrixMod
    rw [← Matrix.map_mul, bainToFccMatrix_mul_fccToBainMatrix]
    simp

/-- `PKF-PHYSKIT-THM-005`: for every positive finite modulus, the exact Bain-to-FCC
coordinate map is bijective. -/
theorem bainToFccModMap_bijective (n : ℕ) (_hn : 0 < n) :
    Function.Bijective (bainToFccModMap n) := by
  constructor
  · exact (bainToFccModMap_mutualInverse n _hn).1.injective
  · exact (bainToFccModMap_mutualInverse n _hn).2.surjective

end ProjectKoios.Crosswalks.PhysKit

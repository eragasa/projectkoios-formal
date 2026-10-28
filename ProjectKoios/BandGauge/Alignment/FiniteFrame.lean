/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-27
-/
module

public import Mathlib.Analysis.Matrix.Normed
public import Mathlib.LinearAlgebra.Matrix.Hermitian
public import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Finite orthonormal-frame algebra

This module records exact finite-dimensional algebra for a rectangular complex frame. A frame maps
retained coordinates into an ambient space, its retained projector is `frame * frameᴴ`, and ambient
operators compress as `frameᴴ * operator * frame`.

Right multiplication by a square unitary changes retained coordinates without changing the ambient
projector or reconstructed compressed operator. These identities do not bind runtime arrays, verify
numerical orthonormality, select a gauge family, or establish physical adequacy.
-/

@[expose] public section

open scoped ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Alignment

variable {Ambient Retained : Type*}
  [Fintype Ambient] [DecidableEq Ambient]
  [Fintype Retained] [DecidableEq Retained]

/-- `BG-ALIGNMENT-DEF-001`: rectangular complex matrix representing a finite retained frame. -/
abbrev ComplexFrame (Ambient Retained : Type*) := Matrix Ambient Retained ℂ

/-- `BG-ALIGNMENT-DEF-002`: exact orthonormal-column condition for a finite complex frame. -/
def IsOrthonormalFrame (frame : ComplexFrame Ambient Retained) : Prop :=
  frameᴴ * frame = 1

/-- `BG-ALIGNMENT-DEF-003`: ambient-space projector represented by a finite frame. -/
def frameProjector (frame : ComplexFrame Ambient Retained) : Matrix Ambient Ambient ℂ :=
  frame * frameᴴ

/-- `BG-ALIGNMENT-DEF-004`: retained-coordinate change by right multiplication with a unitary. -/
def rightUnitaryFrame (frame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ) : ComplexFrame Ambient Retained :=
  frame * (gauge : Matrix Retained Retained ℂ)

/-- `BG-ALIGNMENT-DEF-005`: compression of an ambient operator into retained coordinates. -/
def compressOperator (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) : Matrix Retained Retained ℂ :=
  frameᴴ * operator * frame

/-- `BG-ALIGNMENT-DEF-006`: reconstruction of a compressed operator in the ambient space. -/
def reconstructCompressedOperator (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) : Matrix Ambient Ambient ℂ :=
  frame * compressOperator frame operator * frameᴴ

omit [Fintype Ambient] [DecidableEq Ambient] [DecidableEq Retained] in
/-- `BG-ALIGNMENT-THM-001`: every frame projector is Hermitian, without an orthonormality
premise. -/
theorem frameProjector_isHermitian (frame : ComplexFrame Ambient Retained) :
    (frameProjector frame).IsHermitian := by
  simp [frameProjector, Matrix.IsHermitian, Matrix.conjTranspose_mul]

omit [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-002`: an orthonormal frame defines an idempotent ambient projector. -/
theorem frameProjector_mul_self (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    frameProjector frame * frameProjector frame = frameProjector frame := by
  simp only [frameProjector, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc frameᴴ frame frameᴴ, hframe]
  simp

omit [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-003`: right multiplication by a retained-space unitary preserves exact
frame orthonormality. -/
theorem rightUnitaryFrame_isOrthonormal (frame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (hframe : IsOrthonormalFrame frame) :
    IsOrthonormalFrame (rightUnitaryFrame frame gauge) := by
  have hunit : (gauge : Matrix Retained Retained ℂ)ᴴ *
      (gauge : Matrix Retained Retained ℂ) = 1 := by
    simpa only [Matrix.star_eq_conjTranspose] using
      Matrix.mem_unitaryGroup_iff'.mp gauge.property
  rw [IsOrthonormalFrame, rightUnitaryFrame, Matrix.conjTranspose_mul]
  simp only [Matrix.mul_assoc]
  rw [← Matrix.mul_assoc frameᴴ frame (gauge : Matrix Retained Retained ℂ), hframe]
  simpa only [Matrix.one_mul] using hunit

omit [Fintype Ambient] [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-004`: a retained-space unitary coordinate change leaves the ambient
projector unchanged. -/
theorem frameProjector_rightUnitaryFrame (frame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    frameProjector (rightUnitaryFrame frame gauge) = frameProjector frame := by
  have hunit : (gauge : Matrix Retained Retained ℂ) *
      (gauge : Matrix Retained Retained ℂ)ᴴ = 1 :=
    Matrix.mem_unitaryGroup_iff.mp gauge.property
  rw [frameProjector, rightUnitaryFrame, Matrix.conjTranspose_mul]
  calc
    (frame * (gauge : Matrix Retained Retained ℂ)) *
        ((gauge : Matrix Retained Retained ℂ)ᴴ * frameᴴ) =
      frame * ((gauge : Matrix Retained Retained ℂ) *
        (gauge : Matrix Retained Retained ℂ)ᴴ) * frameᴴ := by
          simp only [Matrix.mul_assoc]
    _ = frame * frameᴴ := by rw [hunit]; simp
    _ = frameProjector frame := rfl

omit [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-005`: compression in right-unitarily changed frame coordinates is unitary
conjugation of the original compressed operator. -/
theorem compressOperator_rightUnitaryFrame (frame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ) :
    compressOperator (rightUnitaryFrame frame gauge) operator =
      (gauge : Matrix Retained Retained ℂ)ᴴ *
        compressOperator frame operator *
          (gauge : Matrix Retained Retained ℂ) := by
  simp only [compressOperator, rightUnitaryFrame, Matrix.conjTranspose_mul]
  simp only [Matrix.mul_assoc]

omit [DecidableEq Ambient] [Fintype Retained] [DecidableEq Retained] in
/-- `BG-ALIGNMENT-THM-006`: compression by any finite frame preserves Hermiticity. -/
theorem compressOperator_isHermitian (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hoperator : operator.IsHermitian) :
    (compressOperator frame operator).IsHermitian := by
  rw [Matrix.IsHermitian, compressOperator, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose, hoperator]
  simp only [Matrix.mul_assoc]

omit [DecidableEq Ambient] [DecidableEq Retained] in
/-- `BG-ALIGNMENT-THM-007`: reconstructing a compressed operator is exactly the ambient-projector
sandwich of that operator. -/
theorem reconstructCompressedOperator_eq_projector_sandwich
    (frame : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ) :
    reconstructCompressedOperator frame operator =
      frameProjector frame * operator * frameProjector frame := by
  simp only [reconstructCompressedOperator, compressOperator, frameProjector]
  simp only [Matrix.mul_assoc]

omit [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-008`: right-unitary frame changes leave the reconstructed compressed
ambient operator unchanged. -/
theorem reconstructCompressedOperator_rightUnitaryFrame
    (frame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ) :
    reconstructCompressedOperator (rightUnitaryFrame frame gauge) operator =
      reconstructCompressedOperator frame operator := by
  rw [reconstructCompressedOperator_eq_projector_sandwich,
    reconstructCompressedOperator_eq_projector_sandwich,
    frameProjector_rightUnitaryFrame]

omit [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-009`: the projector of an orthonormal frame fixes the frame columns. -/
theorem frameProjector_mul_frame (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    frameProjector frame * frame = frame := by
  rw [frameProjector]
  calc
    (frame * frameᴴ) * frame = frame * (frameᴴ * frame) := by
      simp only [Matrix.mul_assoc]
    _ = frame := by rw [hframe]; simp

omit [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-010`: compressing an orthonormal frame projector recovers the retained
identity. -/
theorem compressOperator_frameProjector (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    compressOperator frame (frameProjector frame) = 1 := by
  rw [compressOperator, frameProjector]
  calc
    frameᴴ * (frame * frameᴴ) * frame =
        (frameᴴ * frame) * (frameᴴ * frame) := by
          simp only [Matrix.mul_assoc]
    _ = 1 := by rw [hframe]; simp

end ProjectKoios.BandGauge.Alignment

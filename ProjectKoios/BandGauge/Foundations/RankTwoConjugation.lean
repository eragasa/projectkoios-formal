/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-31
-/
module

public import ProjectKoios.BandGauge.Foundations.RankTwoSpectralPerturbation

/-!
# Exact rank-two unitary-conjugation band invariance

This module proves that exact complex-unitary conjugation preserves the spectrum, trace, and
determinant of a complex `2 × 2` matrix. When both the source matrix and its conjugate are supplied
in the real scalar-plus-Pauli coordinates used by `rankTwoHermitianMatrix`, the scalar coordinate,
Pauli radius, and canonical lower and upper bands agree exactly. A pointwise field corollary then
applies to supplied finite index types, including finite momentum meshes.

The unitary and post-conjugation coordinate equality are exact supplied witnesses. The results do
not construct or authenticate a runtime gauge, floating-point frame, eigensolver, band ordering,
band tracker, momentum mesh, serialized artifact, numerical tolerance, physical model, or
scientific acceptance decision.
-/

open scoped BigOperators ComplexConjugate Matrix
open Matrix

@[expose] public section

namespace ProjectKoios.BandGauge.Foundations

/-- `BG-FOUNDATION-DEF-014`: the exact complex `2 × 2` matrix carrier used by the
conjugation results. -/
abbrev RankTwoMatrix := Matrix (Fin 2) (Fin 2) ℂ

/-- `BG-FOUNDATION-DEF-015`: the exact complex-unitary group on the rank-two carrier. -/
abbrev RankTwoUnitary := Matrix.unitaryGroup (Fin 2) ℂ

/-- `BG-FOUNDATION-DEF-016`: conjugation of a rank-two matrix by an exact supplied unitary. -/
def unitaryConjugateRankTwoMatrix (unitary : RankTwoUnitary)
    (matrix : RankTwoMatrix) : RankTwoMatrix :=
  (unitary : RankTwoMatrix)ᴴ * matrix * (unitary : RankTwoMatrix)

/-- `BG-FOUNDATION-THM-015`: exact unitary conjugation preserves the complex spectrum. -/
theorem spectrum_unitaryConjugateRankTwoMatrix
    (unitary : RankTwoUnitary) (matrix : RankTwoMatrix) :
    spectrum ℂ (unitaryConjugateRankTwoMatrix unitary matrix) = spectrum ℂ matrix := by
  exact Unitary.spectrum_star_left_conjugate

/-- `BG-FOUNDATION-THM-016`: exact unitary conjugation preserves trace. -/
theorem trace_unitaryConjugateRankTwoMatrix
    (unitary : RankTwoUnitary) (matrix : RankTwoMatrix) :
    Matrix.trace (unitaryConjugateRankTwoMatrix unitary matrix) = Matrix.trace matrix := by
  rw [unitaryConjugateRankTwoMatrix]
  calc
    Matrix.trace ((unitary : RankTwoMatrix)ᴴ * matrix * (unitary : RankTwoMatrix)) =
        Matrix.trace ((unitary : RankTwoMatrix) * (unitary : RankTwoMatrix)ᴴ * matrix) := by
      exact Matrix.trace_mul_cycle _ _ _
    _ = Matrix.trace matrix := by
      rw [show (unitary : RankTwoMatrix) * (unitary : RankTwoMatrix)ᴴ = 1 by
        exact Matrix.mem_unitaryGroup_iff.mp unitary.property]
      simp

/-- `BG-FOUNDATION-THM-017`: exact unitary conjugation preserves determinant. -/
theorem det_unitaryConjugateRankTwoMatrix
    (unitary : RankTwoUnitary) (matrix : RankTwoMatrix) :
    Matrix.det (unitaryConjugateRankTwoMatrix unitary matrix) = Matrix.det matrix := by
  rw [unitaryConjugateRankTwoMatrix, Matrix.det_mul, Matrix.det_mul]
  have hdet :
      Matrix.det ((unitary : RankTwoMatrix)ᴴ) * Matrix.det (unitary : RankTwoMatrix) = 1 := by
    rw [← Matrix.det_mul]
    rw [show (unitary : RankTwoMatrix)ᴴ * (unitary : RankTwoMatrix) = 1 by
      exact Unitary.coe_star_mul_self unitary]
    simp
  calc
    Matrix.det ((unitary : RankTwoMatrix)ᴴ) * Matrix.det matrix *
        Matrix.det (unitary : RankTwoMatrix) =
        Matrix.det matrix *
          (Matrix.det ((unitary : RankTwoMatrix)ᴴ) * Matrix.det (unitary : RankTwoMatrix)) := by
      ring
    _ = Matrix.det matrix := by rw [hdet, mul_one]

/-- `BG-FOUNDATION-THM-018`: the trace of a scalar-plus-Pauli matrix is twice its scalar
coordinate. -/
theorem trace_rankTwoHermitianMatrix (t x y z : ℝ) :
    Matrix.trace (rankTwoHermitianMatrix t x y z) = (2 * t : ℝ) := by
  simp [rankTwoHermitianMatrix, Matrix.trace, Fin.sum_univ_two]
  ring

/-- `BG-FOUNDATION-THM-019`: the determinant of a scalar-plus-Pauli matrix is the scalar
coordinate squared minus the Pauli radius squared. -/
theorem det_rankTwoHermitianMatrix (t x y z : ℝ) :
    Matrix.det (rankTwoHermitianMatrix t x y z) =
      ((t ^ 2 - (x ^ 2 + y ^ 2 + z ^ 2) : ℝ) : ℂ) := by
  simp [rankTwoHermitianMatrix, Matrix.det_fin_two]
  ring_nf
  rw [Complex.I_sq]
  ring

/-- `BG-FOUNDATION-THM-020`: exact unitary conjugation preserves the scalar coordinate of
supplied scalar-plus-Pauli witnesses. -/
theorem rankTwoScalar_eq_of_unitaryConjugation
    (t x y z T X Y Z : ℝ) (unitary : RankTwoUnitary)
    (hconjugate : rankTwoHermitianMatrix T X Y Z =
      unitaryConjugateRankTwoMatrix unitary (rankTwoHermitianMatrix t x y z)) :
    T = t := by
  have htrace := congrArg Matrix.trace hconjugate
  rw [trace_rankTwoHermitianMatrix T X Y Z,
    trace_unitaryConjugateRankTwoMatrix unitary (rankTwoHermitianMatrix t x y z),
    trace_rankTwoHermitianMatrix t x y z] at htrace
  have hreal := congrArg Complex.re htrace
  norm_num at hreal
  linarith

/-- `BG-FOUNDATION-THM-021`: exact unitary conjugation preserves the Pauli radius of
supplied scalar-plus-Pauli witnesses. -/
theorem rankTwoBandRadius_eq_of_unitaryConjugation
    (t x y z T X Y Z : ℝ) (unitary : RankTwoUnitary)
    (hconjugate : rankTwoHermitianMatrix T X Y Z =
      unitaryConjugateRankTwoMatrix unitary (rankTwoHermitianMatrix t x y z)) :
    rankTwoBandRadius X Y Z = rankTwoBandRadius x y z := by
  have hscalar := rankTwoScalar_eq_of_unitaryConjugation
    t x y z T X Y Z unitary hconjugate
  have hdet := congrArg Matrix.det hconjugate
  rw [det_rankTwoHermitianMatrix T X Y Z,
    det_unitaryConjugateRankTwoMatrix unitary (rankTwoHermitianMatrix t x y z),
    det_rankTwoHermitianMatrix t x y z] at hdet
  have hreal : T ^ 2 - (X ^ 2 + Y ^ 2 + Z ^ 2) =
      t ^ 2 - (x ^ 2 + y ^ 2 + z ^ 2) := by
    exact_mod_cast hdet
  have hradiusSq : X ^ 2 + Y ^ 2 + Z ^ 2 = x ^ 2 + y ^ 2 + z ^ 2 := by
    rw [hscalar] at hreal
    linarith
  simp only [rankTwoBandRadius]
  rw [hradiusSq]

/-- `BG-FOUNDATION-THM-022`: exact unitary conjugation preserves the canonical lower band
of supplied scalar-plus-Pauli witnesses. -/
theorem rankTwoLowerBand_eq_of_unitaryConjugation
    (t x y z T X Y Z : ℝ) (unitary : RankTwoUnitary)
    (hconjugate : rankTwoHermitianMatrix T X Y Z =
      unitaryConjugateRankTwoMatrix unitary (rankTwoHermitianMatrix t x y z)) :
    rankTwoLowerBand T X Y Z = rankTwoLowerBand t x y z := by
  simp only [rankTwoLowerBand]
  rw [rankTwoScalar_eq_of_unitaryConjugation t x y z T X Y Z unitary hconjugate,
    rankTwoBandRadius_eq_of_unitaryConjugation t x y z T X Y Z unitary hconjugate]

/-- `BG-FOUNDATION-THM-023`: exact unitary conjugation preserves the canonical upper band
of supplied scalar-plus-Pauli witnesses. -/
theorem rankTwoUpperBand_eq_of_unitaryConjugation
    (t x y z T X Y Z : ℝ) (unitary : RankTwoUnitary)
    (hconjugate : rankTwoHermitianMatrix T X Y Z =
      unitaryConjugateRankTwoMatrix unitary (rankTwoHermitianMatrix t x y z)) :
    rankTwoUpperBand T X Y Z = rankTwoUpperBand t x y z := by
  simp only [rankTwoUpperBand]
  rw [rankTwoScalar_eq_of_unitaryConjugation t x y z T X Y Z unitary hconjugate,
    rankTwoBandRadius_eq_of_unitaryConjugation t x y z T X Y Z unitary hconjugate]

/-- `BG-FOUNDATION-THM-024`: exact unitary conjugation preserves the ordered pair of
canonical rank-two bands. -/
theorem rankTwoBands_eq_of_unitaryConjugation
    (t x y z T X Y Z : ℝ) (unitary : RankTwoUnitary)
    (hconjugate : rankTwoHermitianMatrix T X Y Z =
      unitaryConjugateRankTwoMatrix unitary (rankTwoHermitianMatrix t x y z)) :
    rankTwoLowerBand T X Y Z = rankTwoLowerBand t x y z ∧
      rankTwoUpperBand T X Y Z = rankTwoUpperBand t x y z := by
  exact ⟨rankTwoLowerBand_eq_of_unitaryConjugation
      t x y z T X Y Z unitary hconjugate,
    rankTwoUpperBand_eq_of_unitaryConjugation
      t x y z T X Y Z unitary hconjugate⟩

/-- `BG-FOUNDATION-THM-025`: pointwise exact unitary conjugation preserves both canonical
band fields on a supplied finite index type, including a finite momentum mesh. -/
theorem rankTwoFiniteBandFields_eq_of_pointwiseUnitaryConjugation
    {Index : Type*} [Fintype Index]
    (t x y z T X Y Z : Index → ℝ) (unitary : Index → RankTwoUnitary)
    (hconjugate : ∀ index,
      rankTwoHermitianMatrix (T index) (X index) (Y index) (Z index) =
        unitaryConjugateRankTwoMatrix (unitary index)
          (rankTwoHermitianMatrix (t index) (x index) (y index) (z index))) :
    (fun index => rankTwoLowerBand (T index) (X index) (Y index) (Z index)) =
        (fun index => rankTwoLowerBand (t index) (x index) (y index) (z index)) ∧
      (fun index => rankTwoUpperBand (T index) (X index) (Y index) (Z index)) =
        (fun index => rankTwoUpperBand (t index) (x index) (y index) (z index)) := by
  constructor <;> funext index
  · exact rankTwoLowerBand_eq_of_unitaryConjugation
      (t index) (x index) (y index) (z index)
      (T index) (X index) (Y index) (Z index) (unitary index) (hconjugate index)
  · exact rankTwoUpperBand_eq_of_unitaryConjugation
      (t index) (x index) (y index) (z index)
      (T index) (X index) (Y index) (Z index) (unitary index) (hconjugate index)

end ProjectKoios.BandGauge.Foundations

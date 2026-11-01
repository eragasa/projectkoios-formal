/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-01
-/
module

public import ProjectKoios.BandGauge.Fourier.Gauge.TruncationCounterexample
public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.MatrixFrobenius
public import ProjectKoios.BandGauge.Foundations.RankTwoConjugation
public import Mathlib.LinearAlgebra.Matrix.Hermitian

/-!
# Product-mesh gauge–locality separation

This module lifts the exact two-point rank-two swap witness to finite binary product momentum
meshes `Dimension → ZMod 2`. A selected coordinate controls an identity-or-swap unitary gauge.
The constant first-coordinate projector and its pointwise conjugate have exactly equal ordered
rank-two bands at every momentum and have exact full Fourier reconstruction, while zero-mode
truncation does not commute with the varying gauge and the gauged field has strictly positive
omitted matrix-Frobenius power outside the zero mode. Explicit `Fin 2` and `Fin 3` corollaries
record the two- and three-dimensional cases.

All results concern exact finite groups and exact complex matrices. They do not authenticate a
runtime mesh, gauge, frame, eigensolver, Fourier array, quadrature rule, serialized artifact,
physical hopping range, finite-to-continuum limit, material model, or scientific conclusion.
-/

open scoped BigOperators ComplexConjugate Matrix
open Fintype (card)

@[expose] public section

namespace ProjectKoios.BandGauge.Fourier.Gauge

open ProjectKoios.BandGauge.Fourier.FiniteAbelian

/-- `BG-FOURIER-DEF-059`: binary finite product momentum mesh over a dimension index. -/
abbrev BinaryProductMomentum (Dimension : Type*) := Dimension → ZMod 2

/-- `BG-FOURIER-DEF-060`: identity-or-swap rank-two gauge controlled by one momentum coordinate. -/
noncomputable def coordinateSwapGauge {Dimension : Type*}
    (coordinate : Dimension) (momentum : BinaryProductMomentum Dimension) :
    Matrix.unitaryGroup (Fin 2) ℂ :=
  twoPointSwapGauge (momentum coordinate)

/-- `BG-FOURIER-DEF-061`: constant first-coordinate projector on a binary product mesh. -/
def productConstantProjectorField {Dimension : Type*}
    (_ : BinaryProductMomentum Dimension) : Matrix (Fin 2) (Fin 2) ℂ :=
  rankTwoFirstCoordinateProjector

/-- `BG-FOURIER-DEF-062`: the all-zero binary product momentum. -/
noncomputable def zeroProductMomentum {Dimension : Type*} :
    BinaryProductMomentum Dimension := 0

/-- `BG-FOURIER-DEF-063`: momentum equal to one at the selected coordinate and zero elsewhere. -/
noncomputable def selectedProductMomentum {Dimension : Type*} [DecidableEq Dimension]
    (coordinate : Dimension) : BinaryProductMomentum Dimension :=
  Function.update 0 coordinate 1

/-- `BG-FOURIER-THM-134`: the zero-mode coefficient of a constant finite-group field is its value. -/
theorem finiteFourierCoefficient_zero_constant
    {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [AddCommMonoid V] [Module ℂ V] (value : V) :
    finiteFourierCoefficient (fun _ : G => value) 0 = value := by
  rw [finiteFourierCoefficient]
  simp only [AddChar.zero_apply, map_one, one_smul, Finset.sum_const,
    Finset.card_univ]
  rw [← Nat.cast_smul_eq_nsmul ℂ]
  rw [smul_smul]
  have hcard : (card G : ℂ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  rw [inv_mul_cancel₀ hcard, one_smul]

-- try simpler formulation maybe nsmul conversion

/-- `BG-FOURIER-THM-135`: zero-mode truncation fixes every constant finite-group field. -/
theorem zeroModeFourierTruncation_constant
    {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [AddCommMonoid V] [Module ℂ V] (value : V) :
    zeroModeFourierTruncation (fun _ : G => value) = fun _ => value := by
  funext momentum
  rw [zeroModeFourierTruncation_eq_coefficient]
  exact finiteFourierCoefficient_zero_constant value

/-- `BG-FOURIER-THM-136`: zero-mode truncation fixes the constant product-mesh projector field. -/
theorem product_zero_truncation
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension] :
    zeroModeFourierTruncation
      (productConstantProjectorField (Dimension := Dimension)) =
        productConstantProjectorField := by
  exact zeroModeFourierTruncation_constant rankTwoFirstCoordinateProjector

/-- `BG-FOURIER-THM-137`: the coordinate swap gauge is the identity at zero momentum. -/
theorem coordinateSwapGauge_zero
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    coordinateSwapGauge coordinate (zeroProductMomentum (Dimension := Dimension)) = 1 := by
  simp [coordinateSwapGauge, zeroProductMomentum, twoPointSwapGauge]

/-- `BG-FOURIER-THM-138`: the coordinate swap gauge is the swap at the selected momentum. -/
theorem coordinateSwapGauge_selected
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    coordinateSwapGauge coordinate (selectedProductMomentum coordinate) =
      rankTwoSwapUnitary := by
  simp [coordinateSwapGauge, selectedProductMomentum, twoPointSwapGauge]

/-- `BG-FOURIER-THM-139`: the product-mesh gauged field is the first projector at zero. -/
theorem product_pointwise_at_zero
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
      (productConstantProjectorField (Dimension := Dimension))
      (zeroProductMomentum (Dimension := Dimension)) =
        rankTwoFirstCoordinateProjector := by
  simp [pointwiseUnitaryConjugation, coordinateSwapGauge_zero,
    productConstantProjectorField]

/-- `BG-FOURIER-THM-140`: the product-mesh gauged field is the second projector at the selected momentum. -/
theorem product_pointwise_at_selected
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
      (productConstantProjectorField (Dimension := Dimension))
      (selectedProductMomentum coordinate) =
        rankTwoSecondCoordinateProjector := by
  change fixedUnitaryConjugation
    (coordinateSwapGauge coordinate (selectedProductMomentum coordinate))
    rankTwoFirstCoordinateProjector = rankTwoSecondCoordinateProjector
  rw [coordinateSwapGauge_selected]
  exact rankTwoSwapConjugation_firstCoordinateProjector

/-- `BG-FOURIER-THM-141`: the first-coordinate rank-two projector is Hermitian. -/
theorem rankTwoFirstCoordinateProjector_isHermitian :
    rankTwoFirstCoordinateProjector.IsHermitian := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rankTwoFirstCoordinateProjector]

/-- `BG-FOURIER-THM-142`: the pointwise-gauged product-mesh field is Hermitian. -/
theorem product_pointwise_isHermitian
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) (momentum : BinaryProductMomentum Dimension) :
    (pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
      (productConstantProjectorField (Dimension := Dimension)) momentum).IsHermitian := by
  rw [Matrix.IsHermitian, pointwiseUnitaryConjugation,
    Matrix.conjTranspose_mul, Matrix.conjTranspose_mul]
  simp only [Matrix.conjTranspose_conjTranspose, productConstantProjectorField]
  change (coordinateSwapGauge coordinate momentum : Matrix (Fin 2) (Fin 2) ℂ)ᴴ *
      (rankTwoFirstCoordinateProjectorᴴ *
        (coordinateSwapGauge coordinate momentum : Matrix (Fin 2) (Fin 2) ℂ)) =
    ((coordinateSwapGauge coordinate momentum : Matrix (Fin 2) (Fin 2) ℂ)ᴴ *
      rankTwoFirstCoordinateProjector) *
        (coordinateSwapGauge coordinate momentum : Matrix (Fin 2) (Fin 2) ℂ)
  rw [rankTwoFirstCoordinateProjector_isHermitian]
  exact (Matrix.mul_assoc _ _ _).symm

/-- `BG-FOURIER-DEF-064`: Pauli `z` coordinate of the identity-or-swap gauged projector. -/
noncomputable def productGaugedZ
    {Dimension : Type*} [DecidableEq Dimension]
    (coordinate : Dimension) (momentum : BinaryProductMomentum Dimension) : ℝ :=
  if momentum coordinate = 0 then 1 / 2 else -(1 / 2)

/-- `BG-FOURIER-THM-143`: Pauli-coordinate form of the first-coordinate projector. -/
theorem rankTwoFirstCoordinateProjector_eq_rankTwoHermitianMatrix :
    rankTwoFirstCoordinateProjector =
      ProjectKoios.BandGauge.Foundations.rankTwoHermitianMatrix (1 / 2) 0 0 (1 / 2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [rankTwoFirstCoordinateProjector,
      ProjectKoios.BandGauge.Foundations.rankTwoHermitianMatrix]

/-- `BG-FOURIER-THM-144`: Pauli-coordinate form of the second-coordinate projector. -/
theorem rankTwoSecondCoordinateProjector_eq_rankTwoHermitianMatrix :
    rankTwoSecondCoordinateProjector =
      ProjectKoios.BandGauge.Foundations.rankTwoHermitianMatrix (1 / 2) 0 0 (-(1 / 2)) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [rankTwoSecondCoordinateProjector,
      ProjectKoios.BandGauge.Foundations.rankTwoHermitianMatrix]

/-- `BG-FOURIER-THM-145`: exact Pauli-coordinate representation of the gauged product field. -/
theorem product_gauged_eq_rankTwoHermitianMatrix
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) (momentum : BinaryProductMomentum Dimension) :
    pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
        (productConstantProjectorField (Dimension := Dimension)) momentum =
      ProjectKoios.BandGauge.Foundations.rankTwoHermitianMatrix
        (1 / 2) 0 0 (productGaugedZ coordinate momentum) := by
  change fixedUnitaryConjugation (coordinateSwapGauge coordinate momentum)
    rankTwoFirstCoordinateProjector = _
  by_cases hcoordinate : momentum coordinate = 0
  · rw [show coordinateSwapGauge coordinate momentum = 1 by
        simp [coordinateSwapGauge, twoPointSwapGauge, hcoordinate]]
    simpa [fixedUnitaryConjugation, productGaugedZ, hcoordinate] using
      rankTwoFirstCoordinateProjector_eq_rankTwoHermitianMatrix
  · rw [show coordinateSwapGauge coordinate momentum = rankTwoSwapUnitary by
        simp [coordinateSwapGauge, twoPointSwapGauge, hcoordinate]]
    rw [rankTwoSwapConjugation_firstCoordinateProjector]
    simpa [productGaugedZ, hcoordinate] using
      rankTwoSecondCoordinateProjector_eq_rankTwoHermitianMatrix

/-- `BG-FOURIER-THM-146`: the original and gauged product fields have equal ordered bands pointwise. -/
theorem product_pointwise_orderedBands_eq
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    (fun momentum : BinaryProductMomentum Dimension =>
      ProjectKoios.BandGauge.Foundations.rankTwoLowerBand
        (1 / 2) 0 0 (productGaugedZ coordinate momentum)) =
      (fun _ => ProjectKoios.BandGauge.Foundations.rankTwoLowerBand
        (1 / 2) 0 0 (1 / 2)) ∧
    (fun momentum : BinaryProductMomentum Dimension =>
      ProjectKoios.BandGauge.Foundations.rankTwoUpperBand
        (1 / 2) 0 0 (productGaugedZ coordinate momentum)) =
      (fun _ => ProjectKoios.BandGauge.Foundations.rankTwoUpperBand
        (1 / 2) 0 0 (1 / 2)) := by
  apply ProjectKoios.BandGauge.Foundations.rankTwoFiniteBandFields_eq_of_pointwiseUnitaryConjugation
    (fun _ => 1 / 2) (fun _ => 0) (fun _ => 0) (fun _ => 1 / 2)
    (fun _ => 1 / 2) (fun _ => 0) (fun _ => 0) (productGaugedZ coordinate)
    (coordinateSwapGauge coordinate)
  intro momentum
  rw [← product_gauged_eq_rankTwoHermitianMatrix,
    ← rankTwoFirstCoordinateProjector_eq_rankTwoHermitianMatrix]
  rfl

/-- `BG-FOURIER-THM-147`: the original and gauged product fields have equal complex spectra pointwise. -/
theorem product_pointwise_spectrum
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) (momentum : BinaryProductMomentum Dimension) :
    spectrum ℂ
        (pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
          (productConstantProjectorField (Dimension := Dimension)) momentum) =
      spectrum ℂ (productConstantProjectorField momentum) := by
  simpa [pointwiseUnitaryConjugation,
    ProjectKoios.BandGauge.Foundations.unitaryConjugateRankTwoMatrix] using
    ProjectKoios.BandGauge.Foundations.spectrum_unitaryConjugateRankTwoMatrix
      (coordinateSwapGauge coordinate momentum)
      (productConstantProjectorField momentum)

/-- `BG-FOURIER-THM-148`: a nonzero finite complex matrix field has positive Frobenius power. -/
theorem finiteMatrixFrobeniusPower_pos_of_ne_zero
    {G m n : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype m] [Fintype n]
    (field : G → Matrix m n ℂ) (hfield : field ≠ 0) :
    0 < finiteMatrixFrobeniusPower field := by
  rw [finiteMatrixFrobeniusPower]
  apply Finset.sum_pos'
  · intro momentum _
    positivity
  · rw [Function.ne_iff] at hfield
    obtain ⟨momentum, hmomentum⟩ := hfield
    have hentry : ∃ i j, field momentum i j ≠ 0 := by
      by_contra hnot
      push Not at hnot
      exact hmomentum (Matrix.ext hnot)
    obtain ⟨i, j, hij⟩ := hentry
    refine ⟨momentum, Finset.mem_univ _, ?_⟩
    apply Finset.sum_pos'
    · intro row _
      positivity
    · refine ⟨i, Finset.mem_univ _, ?_⟩
      apply Finset.sum_pos'
      · intro column _
        positivity
      · exact ⟨j, Finset.mem_univ _, sq_pos_of_ne_zero (norm_ne_zero_iff.mpr hij)⟩

/-- `BG-FOURIER-THM-149`: coordinate gauge conjugation and zero-mode truncation do not commute. -/
theorem coordinateSwapGauge_zeroModeFourierTruncation_ne
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
          (productConstantProjectorField (Dimension := Dimension))) ≠
      pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
        (zeroModeFourierTruncation productConstantProjectorField) := by
  intro h
  have hzero := congrFun h (zeroProductMomentum (Dimension := Dimension))
  have hone := congrFun h (selectedProductMomentum coordinate)
  rw [zeroModeFourierTruncation_eq_coefficient] at hzero hone
  rw [product_zero_truncation] at hzero hone
  rw [product_pointwise_at_zero] at hzero
  rw [product_pointwise_at_selected] at hone
  exact rankTwoCoordinateProjectors_ne (hzero.symm.trans hone)

/-- `BG-FOURIER-THM-150`: all Fourier modes exactly reconstruct the gauged product field. -/
theorem product_gauged_full_reconstruction
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    finiteFourierReconstruction
        (finiteFourierCoefficient
          (pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
            (productConstantProjectorField (Dimension := Dimension)))) =
      pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
        productConstantProjectorField := by
  funext momentum
  exact finiteFourierReconstruction_coefficients _ momentum

/-- `BG-FOURIER-THM-151`: the gauged product field has a nonzero zero-mode truncation residual. -/
theorem product_gauged_zeroMode_residual_ne_zero
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    finiteFourierTruncationResidual {0}
        (finiteFourierCoefficient
          (pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
            (productConstantProjectorField (Dimension := Dimension)))) ≠ 0 := by
  let field := pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
    (productConstantProjectorField (Dimension := Dimension))
  have htrunc : zeroModeFourierTruncation field ≠ field := by
    have hnoncommute := coordinateSwapGauge_zeroModeFourierTruncation_ne coordinate
    rw [product_zero_truncation] at hnoncommute
    exact hnoncommute
  intro hresidual
  apply htrunc
  funext momentum
  have hzero := congrFun hresidual momentum
  change finiteFourierReconstruction (finiteFourierCoefficient field) momentum -
    finiteFourierReconstruction
      (truncateCoefficients {0} (finiteFourierCoefficient field)) momentum = 0 at hzero
  rw [finiteFourierReconstruction_coefficients] at hzero
  exact (sub_eq_zero.mp hzero).symm

/-- `BG-FOURIER-THM-152`: the gauged zero-mode residual has positive Frobenius power. -/
theorem product_gauged_zeroMode_residual_frobeniusPower_pos
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    0 < finiteMatrixFrobeniusPower
      (finiteFourierTruncationResidual {0}
        (finiteFourierCoefficient
          (pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
            (productConstantProjectorField (Dimension := Dimension))))) := by
  exact finiteMatrixFrobeniusPower_pos_of_ne_zero _
    (product_gauged_zeroMode_residual_ne_zero coordinate)

/-- `BG-FOURIER-THM-153`: the gauged field has positive omitted zero-mode-complement power. -/
theorem product_gauged_omittedMatrixFrobeniusPower_pos
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (coordinate : Dimension) :
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (coordinateSwapGauge coordinate)
          (productConstantProjectorField (Dimension := Dimension)))) {0} := by
  have hpower := product_gauged_zeroMode_residual_frobeniusPower_pos coordinate
  rw [finiteMatrixFrobeniusTruncationResidual_parseval] at hpower
  have hcard : 0 < (card (BinaryProductMomentum Dimension) : ℝ) := by
    exact_mod_cast Fintype.card_pos
  nlinarith

/-- `BG-FOURIER-THM-154`: exact ordered-band equality for the two-dimensional binary product witness. -/
theorem finTwo_coordinateSwap_orderedBands_eq :
    (fun momentum : BinaryProductMomentum (Fin 2) =>
      ProjectKoios.BandGauge.Foundations.rankTwoLowerBand
        (1 / 2) 0 0 (productGaugedZ (0 : Fin 2) momentum)) =
      (fun _ => ProjectKoios.BandGauge.Foundations.rankTwoLowerBand
        (1 / 2) 0 0 (1 / 2)) ∧
    (fun momentum : BinaryProductMomentum (Fin 2) =>
      ProjectKoios.BandGauge.Foundations.rankTwoUpperBand
        (1 / 2) 0 0 (productGaugedZ (0 : Fin 2) momentum)) =
      (fun _ => ProjectKoios.BandGauge.Foundations.rankTwoUpperBand
        (1 / 2) 0 0 (1 / 2)) := by
  exact product_pointwise_orderedBands_eq (0 : Fin 2)

/-- `BG-FOURIER-THM-155`: zero-mode truncation noncommutation for the two-dimensional witness. -/
theorem finTwo_coordinateSwap_zeroModeTruncation_ne :
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (coordinateSwapGauge (0 : Fin 2))
          (productConstantProjectorField (Dimension := Fin 2))) ≠
      pointwiseUnitaryConjugation (coordinateSwapGauge (0 : Fin 2))
        (zeroModeFourierTruncation productConstantProjectorField) := by
  exact coordinateSwapGauge_zeroModeFourierTruncation_ne (0 : Fin 2)

/-- `BG-FOURIER-THM-156`: positive omitted Frobenius power for the two-dimensional witness. -/
theorem finTwo_coordinateSwap_omittedMatrixFrobeniusPower_pos :
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (coordinateSwapGauge (0 : Fin 2))
          (productConstantProjectorField (Dimension := Fin 2)))) {0} := by
  exact product_gauged_omittedMatrixFrobeniusPower_pos (0 : Fin 2)

/-- `BG-FOURIER-THM-157`: exact ordered-band equality for the three-dimensional binary product witness. -/
theorem finThree_coordinateSwap_orderedBands_eq :
    (fun momentum : BinaryProductMomentum (Fin 3) =>
      ProjectKoios.BandGauge.Foundations.rankTwoLowerBand
        (1 / 2) 0 0 (productGaugedZ (0 : Fin 3) momentum)) =
      (fun _ => ProjectKoios.BandGauge.Foundations.rankTwoLowerBand
        (1 / 2) 0 0 (1 / 2)) ∧
    (fun momentum : BinaryProductMomentum (Fin 3) =>
      ProjectKoios.BandGauge.Foundations.rankTwoUpperBand
        (1 / 2) 0 0 (productGaugedZ (0 : Fin 3) momentum)) =
      (fun _ => ProjectKoios.BandGauge.Foundations.rankTwoUpperBand
        (1 / 2) 0 0 (1 / 2)) := by
  exact product_pointwise_orderedBands_eq (0 : Fin 3)

/-- `BG-FOURIER-THM-158`: zero-mode truncation noncommutation for the three-dimensional witness. -/
theorem finThree_coordinateSwap_zeroModeTruncation_ne :
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (coordinateSwapGauge (0 : Fin 3))
          (productConstantProjectorField (Dimension := Fin 3))) ≠
      pointwiseUnitaryConjugation (coordinateSwapGauge (0 : Fin 3))
        (zeroModeFourierTruncation productConstantProjectorField) := by
  exact coordinateSwapGauge_zeroModeFourierTruncation_ne (0 : Fin 3)

/-- `BG-FOURIER-THM-159`: positive omitted Frobenius power for the three-dimensional witness. -/
theorem finThree_coordinateSwap_omittedMatrixFrobeniusPower_pos :
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (coordinateSwapGauge (0 : Fin 3))
          (productConstantProjectorField (Dimension := Fin 3)))) {0} := by
  exact product_gauged_omittedMatrixFrobeniusPower_pos (0 : Fin 3)

end ProjectKoios.BandGauge.Fourier.Gauge

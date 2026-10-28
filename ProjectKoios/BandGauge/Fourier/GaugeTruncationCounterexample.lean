/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-28
-/
module

public import ProjectKoios.BandGauge.Fourier.PointwiseGauge
public import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# A rank-two gauge–truncation counterexample

This module gives an explicit two-momentum, rank-two witness showing that pointwise unitary
conjugation need not commute with zero-mode Fourier truncation. The original matrix field is
constant. The gauge is the identity at momentum zero and the coordinate-swap unitary at momentum
one. Conjugation then converts a zero-mode-only field into one with a nonzero odd Fourier mode.

All statements concern the exact finite group `ZMod 2` and exact complex matrices. They do not
assert continuum locality, decay, smoothness, runtime-array correctness, or numerical evidence.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Fourier

/-- `BG-FOURIER-DEF-023`: the rank-two coordinate-swap matrix, packaged with its exact
unitarity proof. -/
noncomputable def rankTwoSwapUnitary : Matrix.unitaryGroup (Fin 2) ℂ :=
  ⟨!![0, 1; 1, 0], by
    rw [Matrix.mem_unitaryGroup_iff]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]⟩

/-- `BG-FOURIER-DEF-024`: the projector onto the first coordinate of the rank-two fiber. -/
def rankTwoFirstCoordinateProjector : Matrix (Fin 2) (Fin 2) ℂ :=
  !![1, 0; 0, 0]

/-- `BG-FOURIER-DEF-025`: the projector onto the second coordinate of the rank-two fiber. -/
def rankTwoSecondCoordinateProjector : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, 0; 0, 1]

/-- `BG-FOURIER-THM-055`: conjugation by the swap unitary exchanges the two coordinate
projectors. -/
theorem rankTwoSwapConjugation_firstCoordinateProjector :
    fixedUnitaryConjugation rankTwoSwapUnitary rankTwoFirstCoordinateProjector =
      rankTwoSecondCoordinateProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [fixedUnitaryConjugation, rankTwoSwapUnitary,
      rankTwoFirstCoordinateProjector, rankTwoSecondCoordinateProjector,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- `BG-FOURIER-DEF-026`: the two-point gauge that is the identity at zero and the swap unitary
at the other momentum. -/
noncomputable def twoPointSwapGauge (momentum : ZMod 2) :
    Matrix.unitaryGroup (Fin 2) ℂ :=
  if momentum = 0 then 1 else rankTwoSwapUnitary

/-- `BG-FOURIER-DEF-027`: the constant first-coordinate projector field on `ZMod 2`. -/
def twoPointConstantProjectorField (_ : ZMod 2) : Matrix (Fin 2) (Fin 2) ℂ :=
  rankTwoFirstCoordinateProjector

/-- `BG-FOURIER-DEF-028`: reconstruct a field after retaining only its trivial-character
Fourier coefficient. This is the exact finite zero-mode support truncation. -/
noncomputable def zeroModeFourierTruncation
    {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [AddCommMonoid V] [Module ℂ V]
    (field : G → V) (momentum : G) : V :=
  finiteFourierReconstruction
    (truncateCoefficients {0} (finiteFourierCoefficient field)) momentum

/-- `BG-FOURIER-THM-056`: zero-mode Fourier truncation is the constant field equal to the
trivial-character coefficient. -/
theorem zeroModeFourierTruncation_eq_coefficient
    {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [AddCommMonoid V] [Module ℂ V]
    (field : G → V) (momentum : G) :
    zeroModeFourierTruncation field momentum = finiteFourierCoefficient field 0 := by
  simp [zeroModeFourierTruncation, finiteFourierReconstruction,
    finiteReconstruction, finiteCharacterPhase, truncateCoefficients]

/-- `BG-FOURIER-THM-057`: retaining only the zero mode leaves the constant projector field
unchanged. -/
theorem zeroModeFourierTruncation_twoPointConstantProjectorField :
    zeroModeFourierTruncation twoPointConstantProjectorField =
      twoPointConstantProjectorField := by
  funext momentum
  rw [zeroModeFourierTruncation_eq_coefficient]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [finiteFourierCoefficient, twoPointConstantProjectorField,
      rankTwoFirstCoordinateProjector]

/-- `BG-FOURIER-THM-058`: at momentum zero, the pointwise-gauged field remains the first
coordinate projector. -/
theorem pointwiseSwapConjugation_at_zero :
    pointwiseUnitaryConjugation twoPointSwapGauge twoPointConstantProjectorField 0 =
      rankTwoFirstCoordinateProjector := by
  simp [pointwiseUnitaryConjugation, twoPointSwapGauge,
    twoPointConstantProjectorField, rankTwoFirstCoordinateProjector]

/-- `BG-FOURIER-THM-059`: at momentum one, the pointwise-gauged field is the second coordinate
projector. -/
theorem pointwiseSwapConjugation_at_one :
    pointwiseUnitaryConjugation twoPointSwapGauge twoPointConstantProjectorField 1 =
      rankTwoSecondCoordinateProjector := by
  change fixedUnitaryConjugation (twoPointSwapGauge 1)
    rankTwoFirstCoordinateProjector = rankTwoSecondCoordinateProjector
  rw [show twoPointSwapGauge 1 = rankTwoSwapUnitary by
    simp [twoPointSwapGauge]]
  exact rankTwoSwapConjugation_firstCoordinateProjector

/-- `BG-FOURIER-DEF-029`: the nontrivial standard additive character of `ZMod 2`. -/
noncomputable def twoPointOddMode : AddChar (ZMod 2) ℂ :=
  AddChar.zmodAddEquiv 1

/-- `BG-FOURIER-THM-060`: the nontrivial two-point character equals `-1` at momentum one. -/
theorem twoPointOddMode_one : twoPointOddMode 1 = -1 := by
  rw [twoPointOddMode, AddChar.zmodAddEquiv_apply]
  change (((AddChar.zmod 2 (1 : ZMod 2)) (1 : ZMod 2) : Circle) : ℂ) = -1
  have hcircle :
      (AddChar.zmod 2 (1 : ZMod 2)) (1 : ZMod 2) = Circle.exp Real.pi := by
    convert (AddChar.zmod_intCast 2 1 1) using 1
    · norm_num
    · congr 1
      norm_num
      ring
  have hc := congrArg (fun z : Circle => (z : ℂ)) hcircle
  rw [hc, Circle.coe_exp]
  exact Complex.exp_pi_mul_I

/-- `BG-FOURIER-DEF-030`: the exact odd coefficient produced by the pointwise swap gauge. -/
noncomputable def rankTwoOddFourierCoefficient : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(2 : ℂ)⁻¹, 0; 0, -(2 : ℂ)⁻¹]

/-- `BG-FOURIER-THM-061`: the original constant projector field has zero coefficient in the
nontrivial two-point Fourier mode. -/
theorem twoPointConstantProjectorField_odd_coefficient :
    finiteFourierCoefficient twoPointConstantProjectorField twoPointOddMode = 0 := by
  ext i j
  fin_cases i <;> fin_cases j
  all_goals
    simp only [finiteFourierCoefficient, Matrix.smul_apply, Matrix.zero_apply]
    rw [← (ZMod.finEquiv 2).sum_comp]
    simp [Fin.sum_univ_two, twoPointOddMode_one, twoPointConstantProjectorField,
      rankTwoFirstCoordinateProjector]

/-- `BG-FOURIER-THM-062`: after pointwise swap conjugation, the nontrivial two-point Fourier
coefficient is exactly `diag(1/2, -1/2)`. -/
theorem pointwiseSwapConjugation_odd_coefficient :
    finiteFourierCoefficient
        (pointwiseUnitaryConjugation twoPointSwapGauge twoPointConstantProjectorField)
        twoPointOddMode = rankTwoOddFourierCoefficient := by
  ext i j
  fin_cases i <;> fin_cases j
  all_goals
    simp only [finiteFourierCoefficient, Matrix.smul_apply]
    rw [← (ZMod.finEquiv 2).sum_comp]
    simp [Fin.sum_univ_two, pointwiseSwapConjugation_at_zero,
      pointwiseSwapConjugation_at_one, twoPointOddMode_one,
      rankTwoFirstCoordinateProjector, rankTwoSecondCoordinateProjector,
      rankTwoOddFourierCoefficient]

/-- `BG-FOURIER-THM-063`: the explicit odd coefficient is nonzero. -/
theorem rankTwoOddFourierCoefficient_ne_zero : rankTwoOddFourierCoefficient ≠ 0 := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [rankTwoOddFourierCoefficient] at h00

/-- `BG-FOURIER-THM-064`: pointwise swap conjugation creates a nonzero odd Fourier mode. -/
theorem pointwiseSwapConjugation_odd_coefficient_ne_zero :
    finiteFourierCoefficient
        (pointwiseUnitaryConjugation twoPointSwapGauge twoPointConstantProjectorField)
        twoPointOddMode ≠ 0 := by
  rw [pointwiseSwapConjugation_odd_coefficient]
  exact rankTwoOddFourierCoefficient_ne_zero

/-- `BG-FOURIER-THM-065`: the two coordinate projectors are distinct. -/
theorem rankTwoCoordinateProjectors_ne :
    rankTwoFirstCoordinateProjector ≠ rankTwoSecondCoordinateProjector := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [rankTwoFirstCoordinateProjector, rankTwoSecondCoordinateProjector] at h00

/-- `BG-FOURIER-THM-066`: zero-mode support truncation and the two-point, rank-two pointwise
gauge transformation do not commute. -/
theorem pointwiseSwapConjugation_zeroModeFourierTruncation_ne :
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation twoPointSwapGauge twoPointConstantProjectorField) ≠
      pointwiseUnitaryConjugation twoPointSwapGauge
        (zeroModeFourierTruncation twoPointConstantProjectorField) := by
  intro h
  have hzero := congrFun h 0
  have hone := congrFun h 1
  rw [zeroModeFourierTruncation_eq_coefficient] at hzero hone
  rw [zeroModeFourierTruncation_twoPointConstantProjectorField] at hzero hone
  rw [pointwiseSwapConjugation_at_zero] at hzero
  rw [pointwiseSwapConjugation_at_one] at hone
  exact rankTwoCoordinateProjectors_ne (hzero.symm.trans hone)

end ProjectKoios.BandGauge.Fourier

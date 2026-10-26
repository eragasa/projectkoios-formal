/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-26
-/
module

public import ProjectKoios.BandGauge.Fourier.MatrixFrobenius
public import Mathlib.LinearAlgebra.Matrix.Trace
public import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Fixed-unitary invariance and finite Fourier equivariance

This module proves arbitrary-finite-rank Frobenius invariance under the fixed coordinate change
`A ↦ Uᴴ A U`.  It also proves that one fixed unitary conjugation commutes with the declared finite
Fourier coefficient, reconstruction, support truncation, and truncation residual.

The same `U` is used at every momentum and mode.  No theorem here permits a momentum-dependent
unitary field to pass through the Fourier transform: such a field generally mixes Fourier modes and
requires additional hypotheses and a different statement.  The declarations do not bind a runtime
matrix, mesh, hopping inventory, quadrature, or physical gauge.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Fourier

variable {G ι : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
  [Fintype ι] [DecidableEq ι]

/-- `BG-FOURIER-DEF-016`: complex-linear conjugation by one fixed finite unitary matrix. -/
noncomputable def fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) :
    Matrix ι ι ℂ →ₗ[ℂ] Matrix ι ι ℂ where
  toFun A := (U : Matrix ι ι ℂ)ᴴ * A * (U : Matrix ι ι ℂ)
  map_add' A B := by
    simp [Matrix.mul_add, Matrix.add_mul]
  map_smul' c A := by
    simp

/-- `BG-FOURIER-DEF-017`: entrywise complex Frobenius inner product of two square matrices. -/
noncomputable def matrixFrobeniusInner (A B : Matrix ι ι ℂ) : ℂ :=
  ∑ i, ∑ j, conj (A i j) * B i j

/-- `BG-FOURIER-DEF-018`: a caller-weighted finite sum of matrix Frobenius powers. -/
noncomputable def weightedFiniteMatrixFrobeniusPower
    (weight : G → ℝ) (field : G → Matrix ι ι ℂ) : ℝ :=
  ∑ momentum, weight momentum * ∑ i, ∑ j, ‖field momentum i j‖ ^ 2

/-- `BG-FOURIER-DEF-019`: a caller-weighted finite real Frobenius correlation. -/
noncomputable def weightedFiniteMatrixFrobeniusCorrelation
    (weight : G → ℝ) (left right : G → Matrix ι ι ℂ) : ℝ :=
  ∑ momentum, weight momentum * (matrixFrobeniusInner (left momentum) (right momentum)).re

private theorem fixedUnitaryConjugation_apply
    (U : Matrix.unitaryGroup ι ℂ) (A : Matrix ι ι ℂ) :
    fixedUnitaryConjugation U A =
      (U : Matrix ι ι ℂ)ᴴ * A * (U : Matrix ι ι ℂ) := by
  rfl

/-- `BG-FOURIER-THM-033`: trace is invariant under conjugation by an arbitrary finite unitary. -/
theorem trace_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (A : Matrix ι ι ℂ) :
    Matrix.trace (fixedUnitaryConjugation U A) = Matrix.trace A := by
  rw [fixedUnitaryConjugation_apply]
  calc
    Matrix.trace ((U : Matrix ι ι ℂ)ᴴ * A * (U : Matrix ι ι ℂ)) =
        Matrix.trace ((U : Matrix ι ι ℂ) * (U : Matrix ι ι ℂ)ᴴ * A) := by
      exact Matrix.trace_mul_cycle _ _ _
    _ = Matrix.trace A := by
      rw [show (U : Matrix ι ι ℂ) * (U : Matrix ι ι ℂ)ᴴ = 1 by
        exact Matrix.mem_unitaryGroup_iff.mp U.property]
      simp

omit [DecidableEq ι] in
/-- `BG-FOURIER-THM-034`: the entrywise Frobenius inner product equals a matrix trace. -/
theorem matrixFrobeniusInner_eq_trace (A B : Matrix ι ι ℂ) :
    matrixFrobeniusInner A B = Matrix.trace (Aᴴ * B) := by
  rw [matrixFrobeniusInner, Matrix.trace]
  change (∑ i, ∑ j, conj (A i j) * B i j) =
    ∑ i, ((Aᴴ * B) i i)
  simp only [Matrix.mul_apply, Matrix.conjTranspose_apply]
  rw [Finset.sum_comm]
  simp only [starRingEnd_apply]

/-- `BG-FOURIER-THM-035`: fixed unitary conjugation preserves the complex Frobenius inner product. -/
theorem matrixFrobeniusInner_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (A B : Matrix ι ι ℂ) :
    matrixFrobeniusInner (fixedUnitaryConjugation U A)
        (fixedUnitaryConjugation U B) = matrixFrobeniusInner A B := by
  rw [matrixFrobeniusInner_eq_trace, matrixFrobeniusInner_eq_trace]
  have hunit : (U : Matrix ι ι ℂ) * (U : Matrix ι ι ℂ)ᴴ = 1 :=
    Matrix.mem_unitaryGroup_iff.mp U.property
  have hproduct :
      (fixedUnitaryConjugation U A)ᴴ * fixedUnitaryConjugation U B =
        fixedUnitaryConjugation U (Aᴴ * B) := by
    simp only [fixedUnitaryConjugation_apply, Matrix.conjTranspose_mul,
      Matrix.conjTranspose_conjTranspose]
    calc
      ((U : Matrix ι ι ℂ)ᴴ * (Aᴴ * (U : Matrix ι ι ℂ))) *
          ((U : Matrix ι ι ℂ)ᴴ * B * (U : Matrix ι ι ℂ)) =
        (U : Matrix ι ι ℂ)ᴴ * Aᴴ *
          ((U : Matrix ι ι ℂ) * (U : Matrix ι ι ℂ)ᴴ) * B *
            (U : Matrix ι ι ℂ) := by noncomm_ring
      _ = (U : Matrix ι ι ℂ)ᴴ * (Aᴴ * B) * (U : Matrix ι ι ℂ) := by
        rw [hunit]
        simp
        noncomm_ring
  rw [hproduct, trace_fixedUnitaryConjugation]

/-- `BG-FOURIER-THM-036`: fixed unitary conjugation preserves squared Frobenius magnitude. -/
theorem matrixFrobeniusPower_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (A : Matrix ι ι ℂ) :
    (∑ i, ∑ j, ‖fixedUnitaryConjugation U A i j‖ ^ 2) =
      ∑ i, ∑ j, ‖A i j‖ ^ 2 := by
  have h := congrArg Complex.re
    (matrixFrobeniusInner_fixedUnitaryConjugation U A A)
  simpa [matrixFrobeniusInner, map_sum, Complex.sq_norm,
    Complex.normSq_apply] using h

/-- `BG-FOURIER-THM-037`: fixed unitary conjugation preserves squared Frobenius differences. -/
theorem matrixFrobeniusDifferencePower_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (A B : Matrix ι ι ℂ) :
    (∑ i, ∑ j,
      ‖(fixedUnitaryConjugation U A - fixedUnitaryConjugation U B) i j‖ ^ 2) =
      ∑ i, ∑ j, ‖(A - B) i j‖ ^ 2 := by
  rw [← map_sub]
  exact matrixFrobeniusPower_fixedUnitaryConjugation U (A - B)

omit [AddCommGroup G] [DecidableEq G] in
/-- `BG-FOURIER-THM-038`: the existing unweighted finite matrix Frobenius power is invariant
under one fixed unitary conjugation. -/
theorem finiteMatrixFrobeniusPower_fixedUnitaryConjugation
    (field : G → Matrix ι ι ℂ) (U : Matrix.unitaryGroup ι ℂ) :
    finiteMatrixFrobeniusPower
        (fun momentum => fixedUnitaryConjugation U (field momentum)) =
      finiteMatrixFrobeniusPower field := by
  rw [finiteMatrixFrobeniusPower, finiteMatrixFrobeniusPower]
  apply Finset.sum_congr rfl
  intro momentum _
  rw [matrixFrobeniusPower_fixedUnitaryConjugation]

omit [AddCommGroup G] [DecidableEq G] in
/-- `BG-FOURIER-THM-039`: every caller-weighted finite Frobenius power is invariant under one
fixed unitary conjugation. -/
theorem weightedFiniteMatrixFrobeniusPower_fixedUnitaryConjugation
    (weight : G → ℝ) (field : G → Matrix ι ι ℂ)
    (U : Matrix.unitaryGroup ι ℂ) :
    weightedFiniteMatrixFrobeniusPower weight
        (fun momentum => fixedUnitaryConjugation U (field momentum)) =
      weightedFiniteMatrixFrobeniusPower weight field := by
  rw [weightedFiniteMatrixFrobeniusPower, weightedFiniteMatrixFrobeniusPower]
  apply Finset.sum_congr rfl
  intro momentum _
  rw [matrixFrobeniusPower_fixedUnitaryConjugation]

omit [AddCommGroup G] [DecidableEq G] in
/-- `BG-FOURIER-THM-040`: every caller-weighted finite real Frobenius correlation is invariant
under one fixed unitary conjugation. -/
theorem weightedFiniteMatrixFrobeniusCorrelation_fixedUnitaryConjugation
    (weight : G → ℝ) (left right : G → Matrix ι ι ℂ)
    (U : Matrix.unitaryGroup ι ℂ) :
    weightedFiniteMatrixFrobeniusCorrelation weight
        (fun momentum => fixedUnitaryConjugation U (left momentum))
        (fun momentum => fixedUnitaryConjugation U (right momentum)) =
      weightedFiniteMatrixFrobeniusCorrelation weight left right := by
  rw [weightedFiniteMatrixFrobeniusCorrelation,
    weightedFiniteMatrixFrobeniusCorrelation]
  apply Finset.sum_congr rfl
  intro momentum _
  rw [matrixFrobeniusInner_fixedUnitaryConjugation]

omit [AddCommGroup G] [DecidableEq G] in
/-- `BG-FOURIER-THM-041`: every caller-weighted finite sum of squared Frobenius differences is
invariant under one fixed unitary conjugation. -/
theorem weightedFiniteMatrixFrobeniusDifferencePower_fixedUnitaryConjugation
    (weight : G → ℝ) (left right : G → Matrix ι ι ℂ)
    (U : Matrix.unitaryGroup ι ℂ) :
    weightedFiniteMatrixFrobeniusPower weight
        (fun momentum => fixedUnitaryConjugation U (left momentum) -
          fixedUnitaryConjugation U (right momentum)) =
      weightedFiniteMatrixFrobeniusPower weight
        (fun momentum => left momentum - right momentum) := by
  have hfield :
      (fun momentum => fixedUnitaryConjugation U (left momentum) -
        fixedUnitaryConjugation U (right momentum)) =
      (fun momentum => fixedUnitaryConjugation U (left momentum - right momentum)) := by
    funext momentum
    exact (map_sub (fixedUnitaryConjugation U) (left momentum) (right momentum)).symm
  rw [hfield, weightedFiniteMatrixFrobeniusPower_fixedUnitaryConjugation]

omit [DecidableEq G] [Fintype ι] [DecidableEq ι] in
/-- `BG-FOURIER-THM-042`: every complex-linear map commutes with normalized finite Fourier
coefficient extraction. -/
theorem LinearMap.map_finiteFourierCoefficient
    {V W : Type*} [AddCommMonoid V] [Module ℂ V] [AddCommMonoid W] [Module ℂ W]
    (linearMap : V →ₗ[ℂ] W) (field : G → V) (mode : AddChar G ℂ) :
    linearMap (finiteFourierCoefficient field mode) =
      finiteFourierCoefficient (fun momentum => linearMap (field momentum)) mode := by
  simp [finiteFourierCoefficient]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-043`: one fixed unitary conjugation commutes with finite Fourier coefficient
extraction. -/
theorem finiteFourierCoefficient_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (field : G → Matrix ι ι ℂ)
    (mode : AddChar G ℂ) :
    finiteFourierCoefficient
        (fun momentum => fixedUnitaryConjugation U (field momentum)) mode =
      fixedUnitaryConjugation U (finiteFourierCoefficient field mode) := by
  exact (LinearMap.map_finiteFourierCoefficient
    (fixedUnitaryConjugation U) field mode).symm

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-044`: one fixed unitary conjugation commutes with finite Fourier
reconstruction. -/
theorem finiteFourierReconstruction_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ)
    (coefficients : AddChar G ℂ → Matrix ι ι ℂ) (momentum : G) :
    finiteFourierReconstruction
        (fun mode => fixedUnitaryConjugation U (coefficients mode)) momentum =
      fixedUnitaryConjugation U
        (finiteFourierReconstruction coefficients momentum) := by
  exact (LinearMap.map_finiteReconstruction (fixedUnitaryConjugation U)
    finiteCharacterPhase coefficients momentum).symm

omit [Fintype G] [DecidableEq G] in
/-- `BG-FOURIER-THM-045`: one fixed unitary conjugation commutes with exact coefficient support
truncation. -/
theorem truncateCoefficients_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix ι ι ℂ) :
    (fun mode => fixedUnitaryConjugation U
      (truncateCoefficients support coefficients mode)) =
      truncateCoefficients support
        (fun mode => fixedUnitaryConjugation U (coefficients mode)) := by
  exact LinearMap.map_truncateCoefficients (fixedUnitaryConjugation U) support coefficients

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-046`: one fixed unitary conjugation commutes with support-truncated finite
Fourier reconstruction. -/
theorem truncatedFiniteFourierReconstruction_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix ι ι ℂ) (momentum : G) :
    finiteFourierReconstruction
        (truncateCoefficients support
          (fun mode => fixedUnitaryConjugation U (coefficients mode))) momentum =
      fixedUnitaryConjugation U
        (finiteFourierReconstruction
          (truncateCoefficients support coefficients) momentum) := by
  rw [← truncateCoefficients_fixedUnitaryConjugation]
  exact finiteFourierReconstruction_fixedUnitaryConjugation U
    (truncateCoefficients support coefficients) momentum

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-047`: one fixed unitary conjugation commutes with the full-minus-truncated
finite Fourier residual. -/
theorem finiteFourierTruncationResidual_fixedUnitaryConjugation
    (U : Matrix.unitaryGroup ι ℂ) (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix ι ι ℂ) (momentum : G) :
    finiteFourierTruncationResidual support
        (fun mode => fixedUnitaryConjugation U (coefficients mode)) momentum =
      fixedUnitaryConjugation U
        (finiteFourierTruncationResidual support coefficients momentum) := by
  rw [finiteFourierTruncationResidual, finiteFourierTruncationResidual,
    finiteFourierReconstruction_fixedUnitaryConjugation,
    truncatedFiniteFourierReconstruction_fixedUnitaryConjugation]
  exact (map_sub (fixedUnitaryConjugation U) _ _).symm

end ProjectKoios.BandGauge.Fourier

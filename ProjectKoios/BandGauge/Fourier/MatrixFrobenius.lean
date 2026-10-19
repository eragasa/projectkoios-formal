/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-19
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteParseval
public import Mathlib.Analysis.Complex.Norm
public import Mathlib.Data.Matrix.Basic

/-!
# Finite matrix Frobenius Parseval

This module specializes the finite transform to complex matrix fields using the explicit entrywise
squared Frobenius sum.  It proves matrix Parseval and the exact equality between the reconstructed
full-minus-truncated Frobenius power and the omitted coefficient Frobenius power.

The power here is unweighted over the finite momentum inventory and unnormalized over matrix entries.
It is not the paper-specific weighted loss until an explicit normalization and weight bridge is
proved.  No bounded-operator norm, physical shell, external mesh, or continuum claim is made.
-/

@[expose] public section

open scoped BigOperators
open Fintype (card)

namespace ProjectKoios.BandGauge.Fourier

variable {G m n : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
  [Fintype m] [Fintype n]

/-- `BG-FOURIER-DEF-012`: unweighted entrywise squared Frobenius power of a finite matrix field. -/
noncomputable def finiteMatrixFrobeniusPower (field : G → Matrix m n ℂ) : ℝ :=
  ∑ momentum, ∑ i, ∑ j, ‖field momentum i j‖ ^ 2

omit [DecidableEq G] [Fintype m] [Fintype n] in
/-- `BG-FOURIER-THM-026`: matrix Fourier coefficients evaluate entrywise. -/
theorem finiteFourierCoefficient_apply
    (field : G → Matrix m n ℂ) (mode : AddChar G ℂ) (i : m) (j : n) :
    finiteFourierCoefficient field mode i j =
      finiteFourierCoefficient (fun momentum => field momentum i j) mode := by
  simp [finiteFourierCoefficient, Matrix.sum_apply, Matrix.smul_apply]

/-- `BG-FOURIER-THM-027`: finite Parseval for explicit matrix Frobenius power. -/
theorem finiteMatrixFrobeniusPower_parseval (field : G → Matrix m n ℂ) :
    finiteMatrixFrobeniusPower field = (card G : ℝ) *
      finiteMatrixFrobeniusPower (finiteFourierCoefficient field) := by
  have hentry (i : m) (j : n) :
      (∑ momentum, ‖field momentum i j‖ ^ 2) =
        (card G : ℝ) * ∑ mode : AddChar G ℂ,
          ‖finiteFourierCoefficient field mode i j‖ ^ 2 := by
    have h := finiteFourier_parseval (fun momentum => field momentum i j)
    rw [finiteFourierPower_eq_sum_norm_sq, finiteFourierPower_eq_sum_norm_sq] at h
    simpa [finiteFourierCoefficient_apply] using h
  rw [finiteMatrixFrobeniusPower, finiteMatrixFrobeniusPower]
  calc
    (∑ momentum, ∑ i, ∑ j, ‖field momentum i j‖ ^ 2) =
        ∑ i, ∑ j, ∑ momentum, ‖field momentum i j‖ ^ 2 := by
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.sum_comm]
    _ = ∑ i, ∑ j, (card G : ℝ) *
          ∑ mode : AddChar G ℂ, ‖finiteFourierCoefficient field mode i j‖ ^ 2 := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          rw [hentry]
    _ = (card G : ℝ) * ∑ i, ∑ j,
          ∑ mode : AddChar G ℂ, ‖finiteFourierCoefficient field mode i j‖ ^ 2 := by
          simp_rw [Finset.mul_sum]
    _ = (card G : ℝ) * ∑ mode : AddChar G ℂ, ∑ i, ∑ j,
          ‖finiteFourierCoefficient field mode i j‖ ^ 2 := by
          apply congrArg ((card G : ℝ) * ·)
          calc
            (∑ i, ∑ j, ∑ mode : AddChar G ℂ,
                ‖finiteFourierCoefficient field mode i j‖ ^ 2) =
                ∑ i, ∑ mode : AddChar G ℂ, ∑ j,
                  ‖finiteFourierCoefficient field mode i j‖ ^ 2 := by
                    apply Finset.sum_congr rfl
                    intro i _
                    rw [Finset.sum_comm]
            _ = ∑ mode : AddChar G ℂ, ∑ i, ∑ j,
                  ‖finiteFourierCoefficient field mode i j‖ ^ 2 := by
                    rw [Finset.sum_comm]

/-- `BG-FOURIER-DEF-013`: omitted entrywise squared Frobenius coefficient power. -/
noncomputable def omittedMatrixFrobeniusPower
    (coefficients : AddChar G ℂ → Matrix m n ℂ)
    (support : Finset (AddChar G ℂ)) : ℝ :=
  ∑ mode ∈ supportᶜ, ∑ i, ∑ j, ‖coefficients mode i j‖ ^ 2

/-- `BG-FOURIER-THM-028`: exact reconstructed matrix Frobenius residual-tail identity. -/
theorem finiteMatrixFrobeniusTruncationResidual_parseval
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix m n ℂ) :
    finiteMatrixFrobeniusPower (finiteFourierTruncationResidual support coefficients) =
      (card G : ℝ) * omittedMatrixFrobeniusPower coefficients support := by
  rw [finiteMatrixFrobeniusPower_parseval]
  apply congrArg ((card G : ℝ) * ·)
  rw [finiteMatrixFrobeniusPower, omittedMatrixFrobeniusPower]
  simp_rw [finiteFourierCoefficient_truncationResidual]
  let weight : AddChar G ℂ → ℝ := fun mode => ∑ i, ∑ j, ‖coefficients mode i j‖ ^ 2
  have hzero (mode : AddChar G ℂ) (hmode : mode ∈ support) :
      (∑ i, ∑ j,
        ‖(coefficients mode - truncateCoefficients support coefficients mode) i j‖ ^ 2) = 0 := by
    simp [truncateCoefficients, hmode]
  have heq (mode : AddChar G ℂ) (hmode : mode ∈ supportᶜ) :
      (∑ i, ∑ j,
        ‖(coefficients mode - truncateCoefficients support coefficients mode) i j‖ ^ 2) =
          weight mode := by
    have hnotmem : mode ∉ support := by simpa using hmode
    simp [truncateCoefficients, hnotmem, weight]
  calc
    (∑ mode, ∑ i, ∑ j,
        ‖(coefficients mode - truncateCoefficients support coefficients mode) i j‖ ^ 2) =
        ∑ mode ∈ supportᶜ, ∑ i, ∑ j,
          ‖(coefficients mode - truncateCoefficients support coefficients mode) i j‖ ^ 2 := by
            symm
            apply Finset.sum_subset (Finset.subset_univ supportᶜ)
            intro mode _ hmode
            have hmem : mode ∈ support := by simpa using hmode
            exact hzero mode hmem
    _ = ∑ mode ∈ supportᶜ, weight mode := by
          apply Finset.sum_congr rfl
          intro mode hmode
          exact heq mode hmode

end ProjectKoios.BandGauge.Fourier

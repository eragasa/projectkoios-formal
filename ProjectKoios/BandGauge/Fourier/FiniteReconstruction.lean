/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-19
-/
module

public import Mathlib.Analysis.Complex.Basic
public import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Exact finite reconstruction and support truncation

This module isolates the algebra shared by finite Fourier synthesis and finite hopping-support
truncation.  A caller supplies the phase kernel explicitly.  Consequently, none of the declarations
below silently chooses a sign, normalization, lattice, reciprocal pairing, or continuum convention.

The exact tail identity concerns a declared finite mode inventory.  It does not establish Fourier
inversion, Parseval, physical locality, continuum convergence, or completeness of an external mesh.
-/

@[expose] public section

open scoped BigOperators

namespace ProjectKoios.BandGauge.Fourier

variable {Momentum Mode V W : Type*}

/-- `BG-FOURIER-DEF-001`: coefficients indexed by a declared mode type. -/
abbrev CoefficientField (Mode V : Type*) := Mode → V

/-- `BG-FOURIER-DEF-002`: retain exactly the coefficients whose modes belong to `support`. -/
def truncateCoefficients [Zero V] [DecidableEq Mode]
    (support : Finset Mode) (coefficients : CoefficientField Mode V) :
    CoefficientField Mode V :=
  fun mode => if mode ∈ support then coefficients mode else 0

/-- `BG-FOURIER-DEF-003`: finite synthesis with a caller-supplied complex phase kernel. -/
def finiteReconstruction [Fintype Mode] [AddCommMonoid V] [Module ℂ V]
    (phase : Momentum → Mode → ℂ) (coefficients : CoefficientField Mode V)
    (momentum : Momentum) : V :=
  ∑ mode, phase momentum mode • coefficients mode

/-- `BG-FOURIER-DEF-004`: finite synthesis after exact support truncation. -/
def truncatedReconstruction [Fintype Mode] [DecidableEq Mode]
    [AddCommMonoid V] [Module ℂ V]
    (phase : Momentum → Mode → ℂ) (support : Finset Mode)
    (coefficients : CoefficientField Mode V) (momentum : Momentum) : V :=
  finiteReconstruction phase (truncateCoefficients support coefficients) momentum

/-- `BG-FOURIER-DEF-005`: total declared nonnegative-mode weight omitted by a support. -/
def omittedWeight [Fintype Mode] [DecidableEq Mode]
    (weight : Mode → ℝ) (support : Finset Mode) : ℝ :=
  ∑ mode ∈ supportᶜ, weight mode

/-- `BG-FOURIER-THM-001`: truncation preserves a coefficient on the declared support. -/
theorem truncateCoefficients_eq_of_mem [Zero V] [DecidableEq Mode]
    {support : Finset Mode} {coefficients : CoefficientField Mode V} {mode : Mode}
    (hmode : mode ∈ support) :
    truncateCoefficients support coefficients mode = coefficients mode := by
  simp [truncateCoefficients, hmode]

/-- `BG-FOURIER-THM-002`: truncation sets every coefficient outside the support to zero. -/
theorem truncateCoefficients_eq_zero_of_not_mem [Zero V] [DecidableEq Mode]
    {support : Finset Mode} {coefficients : CoefficientField Mode V} {mode : Mode}
    (hmode : mode ∉ support) :
    truncateCoefficients support coefficients mode = 0 := by
  simp [truncateCoefficients, hmode]

/-- `BG-FOURIER-THM-003`: truncated reconstruction is exactly the sum over the support. -/
theorem truncatedReconstruction_eq_sum [Fintype Mode] [DecidableEq Mode]
    [AddCommMonoid V] [Module ℂ V]
    {phase : Momentum → Mode → ℂ} {support : Finset Mode}
    {coefficients : CoefficientField Mode V} {momentum : Momentum} :
    truncatedReconstruction phase support coefficients momentum =
      ∑ mode ∈ support, phase momentum mode • coefficients mode := by
  simp [truncatedReconstruction, finiteReconstruction, truncateCoefficients]

/-- `BG-FOURIER-THM-004`: the full finite reconstruction splits into retained and omitted sums. -/
theorem finiteReconstruction_eq_truncated_add_omitted
    [Fintype Mode] [DecidableEq Mode]
    [AddCommMonoid V] [Module ℂ V]
    {phase : Momentum → Mode → ℂ} {support : Finset Mode}
    {coefficients : CoefficientField Mode V} {momentum : Momentum} :
    finiteReconstruction phase coefficients momentum =
      truncatedReconstruction phase support coefficients momentum +
        ∑ mode ∈ supportᶜ, phase momentum mode • coefficients mode := by
  rw [truncatedReconstruction_eq_sum]
  exact (Finset.sum_add_sum_compl support fun mode =>
    phase momentum mode • coefficients mode).symm

/-- `BG-FOURIER-THM-005`: exact full-minus-truncated finite reconstruction tail identity. -/
theorem finiteReconstruction_sub_truncatedReconstruction_eq_omitted
    [Fintype Mode] [DecidableEq Mode]
    [AddCommGroup V] [Module ℂ V]
    {phase : Momentum → Mode → ℂ} {support : Finset Mode}
    {coefficients : CoefficientField Mode V} {momentum : Momentum} :
    finiteReconstruction phase coefficients momentum -
      truncatedReconstruction phase support coefficients momentum =
        ∑ mode ∈ supportᶜ, phase momentum mode • coefficients mode := by
  rw [finiteReconstruction_eq_truncated_add_omitted]
  exact add_sub_cancel_left _ _

/-- `BG-FOURIER-THM-006`: every complex-linear map commutes with finite reconstruction. -/
theorem LinearMap.map_finiteReconstruction [Fintype Mode]
    [AddCommMonoid V] [Module ℂ V] [AddCommMonoid W] [Module ℂ W]
    (linearMap : V →ₗ[ℂ] W) (phase : Momentum → Mode → ℂ)
    (coefficients : CoefficientField Mode V) (momentum : Momentum) :
    linearMap (finiteReconstruction phase coefficients momentum) =
      finiteReconstruction phase (fun mode => linearMap (coefficients mode)) momentum := by
  simp [finiteReconstruction]

/-- `BG-FOURIER-THM-007`: every complex-linear map commutes with coefficient truncation. -/
theorem LinearMap.map_truncateCoefficients [DecidableEq Mode]
    [AddCommMonoid V] [Module ℂ V] [AddCommMonoid W] [Module ℂ W]
    (linearMap : V →ₗ[ℂ] W) (support : Finset Mode)
    (coefficients : CoefficientField Mode V) :
    (fun mode => linearMap (truncateCoefficients support coefficients mode)) =
      truncateCoefficients support (fun mode => linearMap (coefficients mode)) := by
  funext mode
  by_cases hmode : mode ∈ support <;> simp [truncateCoefficients, hmode]

/-- `BG-FOURIER-THM-008`: enlarging support cannot increase omitted nonnegative weight. -/
theorem omittedWeight_anti [Fintype Mode] [DecidableEq Mode]
    {weight : Mode → ℝ} (hweight : ∀ mode, 0 ≤ weight mode)
    {smaller larger : Finset Mode} (hsubset : smaller ⊆ larger) :
    omittedWeight weight larger ≤ omittedWeight weight smaller := by
  apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.compl_subset_compl.mpr hsubset)
  intro mode _ _
  exact hweight mode

end ProjectKoios.BandGauge.Fourier

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-02
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.Convolution

/-!
# Exact finite-abelian Fourier least squares

On a complete uniform finite-abelian inventory, support truncation of the normalized Fourier
coefficients is an exact equal-weight least-squares minimizer among coefficient fields supported on
the declared character support.  The proof is a coefficient-space Pythagorean identity transported
through finite Parseval.

The result concerns exact finite sums.  It does not authenticate a runtime mesh, NumPy least-squares
solve, design-matrix rank, binary64 coefficient, FFT convention, serialized array, threshold, or
scientific conclusion.
-/

@[expose] public section

open scoped BigOperators
open Fintype (card)

namespace ProjectKoios.BandGauge.Fourier.FiniteAbelian

variable {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

omit [Fintype G] [DecidableEq G] in
/-- `BG-FOURIER-FINITE-LEM-003`: exact coefficient truncation is supported on the declared
support. -/
lemma truncateCoefficients_supportedOn
    [Zero V]
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → V) :
    CoefficientSupportedOn support (truncateCoefficients support coefficients) := by
  intro mode hmode
  exact truncateCoefficients_eq_zero_of_not_mem hmode

omit [DecidableEq G] in
/-- `BG-FOURIER-FINITE-LEM-004`: coefficient error against any supported candidate splits exactly
into the omitted truncation error and the retained coefficient mismatch. -/
lemma finiteFourierPower_sub_supported_eq
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (support : Finset (AddChar G ℂ))
    (coefficients candidate : AddChar G ℂ → V)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteFourierPower (fun mode => coefficients mode - candidate mode) =
      finiteFourierPower
          (fun mode => coefficients mode - truncateCoefficients support coefficients mode) +
        finiteFourierPower
          (fun mode => truncateCoefficients support coefficients mode - candidate mode) := by
  simp only [finiteFourierPower_eq_sum_norm_sq, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro mode _
  by_cases hmode : mode ∈ support
  · simp [truncateCoefficients, hmode]
  · rw [hcandidate mode hmode]
    simp [truncateCoefficients, hmode]

/-- `BG-FOURIER-FINITE-THM-004`: momentum-space reconstruction error has the exact orthogonal
decomposition into truncation error plus `|G|` times retained coefficient mismatch. -/
theorem finiteFourierReconstruction_error_decomposition
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V)
    (support : Finset (AddChar G ℂ))
    (candidate : AddChar G ℂ → V)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteFourierPower
        (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) =
      finiteFourierPower
          (fun momentum => field momentum - finiteFourierReconstruction
            (truncateCoefficients support (finiteFourierCoefficient field)) momentum) +
        (card G : ℝ) * finiteFourierPower
          (fun mode =>
            truncateCoefficients support (finiteFourierCoefficient field) mode - candidate mode) := by
  rw [finiteFourier_parseval]
  have hcoeff :
      finiteFourierCoefficient
          (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) =
        fun mode => finiteFourierCoefficient field mode - candidate mode := by
    funext mode
    rw [finiteFourierCoefficient_sub, finiteFourierCoefficient_reconstruction]
  rw [hcoeff, finiteFourierPower_sub_supported_eq support
    (finiteFourierCoefficient field) candidate hcandidate, mul_add]
  have htruncation :
      finiteFourierPower
          (fun momentum => field momentum - finiteFourierReconstruction
            (truncateCoefficients support (finiteFourierCoefficient field)) momentum) =
        (card G : ℝ) * finiteFourierPower
          (fun mode => finiteFourierCoefficient field mode -
            truncateCoefficients support (finiteFourierCoefficient field) mode) := by
    rw [finiteFourier_parseval]
    have htruncatedCoeff :
        finiteFourierCoefficient
            (fun momentum => field momentum - finiteFourierReconstruction
              (truncateCoefficients support (finiteFourierCoefficient field)) momentum) =
          fun mode => finiteFourierCoefficient field mode -
            truncateCoefficients support (finiteFourierCoefficient field) mode := by
      funext mode
      rw [finiteFourierCoefficient_sub, finiteFourierCoefficient_reconstruction]
    rw [htruncatedCoeff]
  rw [htruncation]

/-- `BG-FOURIER-FINITE-THM-005`: Fourier truncation is an exact least-squares minimizer over the
supported coefficient class, and equality occurs exactly when the candidate coefficients equal the
truncation. -/
theorem finiteFourierTruncation_leastSquares
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V)
    (support : Finset (AddChar G ℂ))
    (candidate : AddChar G ℂ → V)
    (hcandidate : CoefficientSupportedOn support candidate) :
    finiteFourierPower
        (fun momentum => field momentum - finiteFourierReconstruction
          (truncateCoefficients support (finiteFourierCoefficient field)) momentum) ≤
      finiteFourierPower
        (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) ∧
    (finiteFourierPower
        (fun momentum => field momentum - finiteFourierReconstruction candidate momentum) =
      finiteFourierPower
        (fun momentum => field momentum - finiteFourierReconstruction
          (truncateCoefficients support (finiteFourierCoefficient field)) momentum) ↔
      candidate = truncateCoefficients support (finiteFourierCoefficient field)) := by
  have hdecomposition :=
    finiteFourierReconstruction_error_decomposition field support candidate hcandidate
  have hpowerNonneg :
      0 ≤ finiteFourierPower
        (fun mode => truncateCoefficients support (finiteFourierCoefficient field) mode -
          candidate mode) := by
    rw [finiteFourierPower_eq_sum_norm_sq]
    exact Finset.sum_nonneg fun mode _ => sq_nonneg ‖
      truncateCoefficients support (finiteFourierCoefficient field) mode - candidate mode‖
  have hcardNonneg : (0 : ℝ) ≤ card G := by exact_mod_cast Nat.zero_le (card G)
  constructor
  · rw [hdecomposition]
    exact le_add_of_nonneg_right (mul_nonneg hcardNonneg hpowerNonneg)
  · constructor
    · intro hequal
      have hmul :
          (card G : ℝ) * finiteFourierPower
            (fun mode => truncateCoefficients support (finiteFourierCoefficient field) mode -
              candidate mode) = 0 := by
        linarith
      have hcardNe : (card G : ℝ) ≠ 0 := by
        exact_mod_cast Fintype.card_ne_zero
      have hpower :
          finiteFourierPower
            (fun mode => truncateCoefficients support (finiteFourierCoefficient field) mode -
              candidate mode) = 0 :=
        (mul_eq_zero.mp hmul).resolve_left hcardNe
      rw [finiteFourierPower_eq_sum_norm_sq] at hpower
      funext mode
      have hterm :
          ‖truncateCoefficients support (finiteFourierCoefficient field) mode - candidate mode‖ ^ 2 =
            0 :=
        (Finset.sum_eq_zero_iff_of_nonneg
          (fun _ _ => sq_nonneg _)).mp hpower mode (Finset.mem_univ mode)
      have hnorm :
          ‖truncateCoefficients support (finiteFourierCoefficient field) mode - candidate mode‖ =
            0 := by
        nlinarith [norm_nonneg
          (truncateCoefficients support (finiteFourierCoefficient field) mode - candidate mode)]
      exact sub_eq_zero.mp (norm_eq_zero.mp hnorm) |>.symm
    · intro hequal
      subst candidate
      have hsupported := truncateCoefficients_supportedOn support (finiteFourierCoefficient field)
      rw [finiteFourierReconstruction_error_decomposition field support
        (truncateCoefficients support (finiteFourierCoefficient field)) hsupported]

end ProjectKoios.BandGauge.Fourier.FiniteAbelian

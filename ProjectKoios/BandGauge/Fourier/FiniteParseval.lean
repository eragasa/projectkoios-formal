/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-19
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteAbelianTransform
public import Mathlib.Analysis.InnerProductSpace.Basic

/-!
# Finite Parseval and exact truncation power

For the finite-abelian convention fixed in `FiniteAbelianTransform`, this module proves both
transform directions, the inner-product Parseval identity, and an exact equality between the power
of the full-minus-truncated reconstructed field and the omitted coefficient power.

The values may lie in any complex Hilbert space.  The results concern only the declared finite
abelian group and character inventory.  They do not identify a matrix norm, physical hopping range,
publication mesh, external inventory, or continuum Fourier transform.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate
open Fintype (card)
open RCLike

namespace ProjectKoios.BandGauge.Fourier

variable {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-011`: multiplying a normalized coefficient by `|G|` recovers its raw sum. -/
theorem card_smul_finiteFourierCoefficient [AddCommMonoid V] [Module ℂ V]
    (field : G → V) (mode : AddChar G ℂ) :
    (card G : ℂ) • finiteFourierCoefficient field mode =
      ∑ momentum, conj (mode momentum) • field momentum := by
  rw [finiteFourierCoefficient, smul_smul]
  have hcard : (card G : ℂ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  rw [mul_inv_cancel₀ hcard, one_smul]

/-- `BG-FOURIER-THM-012`: finite Fourier transform preserves the inner sum up to `|G|`. -/
theorem finiteFourier_inner_sum [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (left right : G → V) :
    (∑ momentum, inner ℂ (left momentum) (right momentum)) =
      (card G : ℂ) * (∑ mode : AddChar G ℂ,
        inner ℂ (finiteFourierCoefficient left mode) (finiteFourierCoefficient right mode)) := by
  calc
    ∑ momentum, inner ℂ (left momentum) (right momentum) =
        ∑ momentum, inner ℂ
          (finiteFourierReconstruction (finiteFourierCoefficient left) momentum)
          (right momentum) := by
            congr 1
            funext momentum
            rw [finiteFourierReconstruction_coefficients]
    _ = ∑ momentum, ∑ mode : AddChar G ℂ,
          inner ℂ (mode momentum • finiteFourierCoefficient left mode) (right momentum) := by
            simp [finiteFourierReconstruction, finiteReconstruction, finiteCharacterPhase,
              sum_inner]
    _ = ∑ mode : AddChar G ℂ, ∑ momentum,
          inner ℂ (mode momentum • finiteFourierCoefficient left mode) (right momentum) := by
            rw [Finset.sum_comm]
    _ = ∑ mode : AddChar G ℂ, ∑ momentum,
          conj (mode momentum) *
            inner ℂ (finiteFourierCoefficient left mode) (right momentum) := by
            simp_rw [inner_smul_left]
    _ = ∑ mode : AddChar G ℂ,
          inner ℂ (finiteFourierCoefficient left mode)
            (∑ momentum, conj (mode momentum) • right momentum) := by
            simp_rw [inner_sum, inner_smul_right]
    _ = ∑ mode : AddChar G ℂ,
          inner ℂ (finiteFourierCoefficient left mode)
            ((card G : ℂ) • finiteFourierCoefficient right mode) := by
            apply Finset.sum_congr rfl
            intro mode _
            rw [card_smul_finiteFourierCoefficient]
    _ = (card G : ℂ) * ∑ mode : AddChar G ℂ,
          inner ℂ (finiteFourierCoefficient left mode)
            (finiteFourierCoefficient right mode) := by
            simp_rw [inner_smul_right]
            rw [Finset.mul_sum]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-013`: normalized momentum-character orthogonality. -/
theorem finiteCharacterOrthogonality (left right : AddChar G ℂ) :
    (card G : ℂ)⁻¹ * ∑ momentum, conj (left momentum) * right momentum =
      if left = right then 1 else 0 := by
  have h := AddChar.wInner_cWeight_eq_boole left right
  rw [wInner_cWeight_eq_expect, Fintype.expect_eq_sum_div_card] at h
  simpa [RCLike.inner_apply, div_eq_mul_inv, mul_comm] using h

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-014`: coefficient extraction is a left inverse of reconstruction. -/
theorem finiteFourierCoefficient_reconstruction [AddCommMonoid V] [Module ℂ V]
    (coefficients : AddChar G ℂ → V) (mode : AddChar G ℂ) :
    finiteFourierCoefficient (finiteFourierReconstruction coefficients) mode =
      coefficients mode := by
  simp only [finiteFourierCoefficient, finiteFourierReconstruction, finiteReconstruction,
    finiteCharacterPhase]
  simp_rw [Finset.smul_sum, smul_smul]
  rw [Finset.sum_comm]
  simp_rw [← Finset.sum_smul]
  simp_rw [← Finset.mul_sum, finiteCharacterOrthogonality]
  simp

/-- `BG-FOURIER-DEF-009`: unnormalized total squared Hilbert norm of a finite field. -/
def finiteFourierPower [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V) : ℝ :=
  ∑ momentum, (inner ℂ (field momentum) (field momentum)).re

omit [AddCommGroup G] [DecidableEq G] in
/-- `BG-FOURIER-THM-015`: finite Fourier power is the sum of squared Hilbert norms. -/
theorem finiteFourierPower_eq_sum_norm_sq [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V) :
    finiteFourierPower field = ∑ momentum, ‖field momentum‖ ^ 2 := by
  unfold finiteFourierPower
  apply Finset.sum_congr rfl
  intro momentum _
  exact inner_self_eq_norm_sq (𝕜 := ℂ) (field momentum)

/-- `BG-FOURIER-THM-016`: finite Parseval identity for the selected normalization. -/
theorem finiteFourier_parseval [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (field : G → V) :
    finiteFourierPower field = (card G : ℝ) *
      finiteFourierPower (finiteFourierCoefficient field) := by
  have h := finiteFourier_inner_sum field field
  have hre := congrArg Complex.reCLM h
  simpa [finiteFourierPower, map_sum, Complex.reCLM_apply, Complex.mul_re,
    Complex.re_sum] using hre

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-017`: coefficient power splits into retained and omitted power. -/
theorem finiteFourierPower_eq_truncated_add_omitted
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (coefficients : AddChar G ℂ → V) (support : Finset (AddChar G ℂ)) :
    finiteFourierPower coefficients =
      finiteFourierPower (truncateCoefficients support coefficients) +
        omittedWeight (fun mode => ‖coefficients mode‖ ^ 2) support := by
  rw [finiteFourierPower_eq_sum_norm_sq, finiteFourierPower_eq_sum_norm_sq]
  have htrunc :
      (∑ mode, ‖truncateCoefficients support coefficients mode‖ ^ 2) =
        ∑ mode ∈ support, ‖coefficients mode‖ ^ 2 := by
    calc
      (∑ mode, ‖truncateCoefficients support coefficients mode‖ ^ 2) =
          ∑ mode ∈ support, ‖truncateCoefficients support coefficients mode‖ ^ 2 := by
            symm
            apply Finset.sum_subset (Finset.subset_univ support)
            intro mode _ hmode
            simp [truncateCoefficients, hmode]
      _ = ∑ mode ∈ support, ‖coefficients mode‖ ^ 2 := by
            apply Finset.sum_congr rfl
            intro mode hmode
            simp [truncateCoefficients, hmode]
  rw [htrunc]
  exact (Finset.sum_add_sum_compl support fun mode => ‖coefficients mode‖ ^ 2).symm

/-- `BG-FOURIER-DEF-010`: full reconstruction minus support-truncated reconstruction. -/
noncomputable def finiteFourierTruncationResidual [AddCommGroup V] [Module ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) (momentum : G) : V :=
  finiteFourierReconstruction coefficients momentum -
    finiteFourierReconstruction (truncateCoefficients support coefficients) momentum

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-018`: finite Fourier coefficient extraction preserves subtraction. -/
theorem finiteFourierCoefficient_sub [AddCommGroup V] [Module ℂ V]
    (left right : G → V) (mode : AddChar G ℂ) :
    finiteFourierCoefficient (fun momentum => left momentum - right momentum) mode =
      finiteFourierCoefficient left mode - finiteFourierCoefficient right mode := by
  simp [finiteFourierCoefficient, Finset.sum_sub_distrib, smul_sub]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-019`: the residual coefficient is original minus truncated coefficient. -/
theorem finiteFourierCoefficient_truncationResidual [AddCommGroup V] [Module ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V)
    (mode : AddChar G ℂ) :
    finiteFourierCoefficient (finiteFourierTruncationResidual support coefficients) mode =
      coefficients mode - truncateCoefficients support coefficients mode := by
  change finiteFourierCoefficient
    (fun momentum => finiteFourierReconstruction coefficients momentum -
      finiteFourierReconstruction (truncateCoefficients support coefficients) momentum) mode = _
  rw [finiteFourierCoefficient_sub, finiteFourierCoefficient_reconstruction,
    finiteFourierCoefficient_reconstruction]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-020`: coefficient-space residual power is exactly omitted power. -/
theorem finiteFourierPower_sub_truncate_eq_omitted
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) :
    finiteFourierPower
        (fun mode => coefficients mode - truncateCoefficients support coefficients mode) =
      omittedWeight (fun mode => ‖coefficients mode‖ ^ 2) support := by
  rw [finiteFourierPower_eq_sum_norm_sq]
  calc
    (∑ mode, ‖coefficients mode - truncateCoefficients support coefficients mode‖ ^ 2) =
        ∑ mode ∈ supportᶜ,
          ‖coefficients mode - truncateCoefficients support coefficients mode‖ ^ 2 := by
            symm
            apply Finset.sum_subset (Finset.subset_univ supportᶜ)
            intro mode _ hmode
            have hmem : mode ∈ support := by simpa using hmode
            simp [truncateCoefficients, hmem]
    _ = ∑ mode ∈ supportᶜ, ‖coefficients mode‖ ^ 2 := by
          apply Finset.sum_congr rfl
          intro mode hmode
          have hnotmem : mode ∉ support := by simpa using hmode
          simp [truncateCoefficients, hnotmem]

/-- `BG-FOURIER-THM-021`: exact reconstructed residual power equals `|G|` times omitted power. -/
theorem finiteFourierTruncationResidual_parseval
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) :
    finiteFourierPower (finiteFourierTruncationResidual support coefficients) =
      (card G : ℝ) * omittedWeight (fun mode => ‖coefficients mode‖ ^ 2) support := by
  rw [finiteFourier_parseval]
  have hcoeff :
      finiteFourierCoefficient (finiteFourierTruncationResidual support coefficients) =
        fun mode => coefficients mode - truncateCoefficients support coefficients mode := by
    funext mode
    exact finiteFourierCoefficient_truncationResidual support coefficients mode
  rw [hcoeff, finiteFourierPower_sub_truncate_eq_omitted]

end ProjectKoios.BandGauge.Fourier

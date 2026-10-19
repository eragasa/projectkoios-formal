/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-19
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteReconstruction
public import Mathlib.Analysis.Fourier.FiniteAbelian.PontryaginDuality

/-!
# Finite abelian Fourier inversion

This module fixes one explicit finite convention.  Momentum labels form a finite abelian group `G`,
Fourier modes are complex additive characters of `G`, the forward coefficient uses the conjugated
character and normalization `1 / |G|`, and reconstruction uses the unconjugated character with no
additional normalization.

The inversion theorem is exact for the declared finite group and any complex module.  It does not
identify a publication mesh, establish external inventory coverage, prove Parseval, or imply a
continuum Fourier theorem.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate
open Fintype (card)

namespace ProjectKoios.BandGauge.Fourier

variable {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- `BG-FOURIER-DEF-006`: positive-sign character phase used for finite reconstruction. -/
def finiteCharacterPhase (momentum : G) (mode : AddChar G ℂ) : ℂ :=
  mode momentum

/-- `BG-FOURIER-DEF-007`: normalized negative-sign finite Fourier coefficient. -/
noncomputable def finiteFourierCoefficient [AddCommMonoid V] [Module ℂ V]
    (field : G → V) (mode : AddChar G ℂ) : V :=
  (card G : ℂ)⁻¹ • ∑ momentum, conj (mode momentum) • field momentum

/-- `BG-FOURIER-DEF-008`: positive-sign finite character reconstruction. -/
noncomputable def finiteFourierReconstruction [AddCommMonoid V] [Module ℂ V]
    (coefficients : AddChar G ℂ → V) (momentum : G) : V :=
  finiteReconstruction finiteCharacterPhase coefficients momentum

/-- `BG-FOURIER-THM-009`: normalized finite-character kernel is the Kronecker delta. -/
theorem finiteCharacterKernel (momentum sample : G) :
    ((card G : ℂ)⁻¹ *
      ∑ mode : AddChar G ℂ, mode momentum * conj (mode sample)) =
        if momentum = sample then 1 else 0 := by
  have hterm (mode : AddChar G ℂ) :
      mode momentum * conj (mode sample) = mode (momentum - sample) := by
    rw [AddChar.map_sub_eq_div, div_eq_mul_inv, AddChar.inv_apply_eq_conj]
  simp_rw [hterm]
  rw [show (card G : ℂ)⁻¹ * ∑ mode : AddChar G ℂ, mode (momentum - sample) =
      𝔼 mode : AddChar G ℂ, mode (momentum - sample) by
    rw [Fintype.expect_eq_sum_div_card, AddChar.card_eq, div_eq_mul_inv, mul_comm]]
  rw [AddChar.expect_apply_eq_ite]
  simp [sub_eq_zero]

/-- `BG-FOURIER-THM-010`: exact inversion for the normalized finite Fourier coefficients. -/
theorem finiteFourierReconstruction_coefficients [AddCommMonoid V] [Module ℂ V]
    (field : G → V) (momentum : G) :
    finiteFourierReconstruction (finiteFourierCoefficient field) momentum = field momentum := by
  simp only [finiteFourierReconstruction, finiteReconstruction, finiteCharacterPhase,
    finiteFourierCoefficient]
  simp_rw [smul_smul, Finset.smul_sum]
  rw [Finset.sum_comm]
  simp_rw [smul_smul]
  simp_rw [← Finset.sum_smul]
  have hreorder (sample : G) (mode : AddChar G ℂ) :
      mode momentum * (card G : ℂ)⁻¹ * conj (mode sample) =
        (card G : ℂ)⁻¹ * (mode momentum * conj (mode sample)) := by
    ac_rfl
  simp_rw [hreorder, ← Finset.mul_sum, finiteCharacterKernel]
  simp

end ProjectKoios.BandGauge.Fourier

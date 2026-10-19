/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-19
-/
module

public import ProjectKoios.BandGauge.Fourier.MatrixFrobenius
public import ProjectKoios.BandGauge.Hilbert.WeightedFrobenius

/-!
# Rank-two weighted Fourier-loss bridge

This module connects the unweighted finite matrix Frobenius tail identity to the exact rank-two
coefficient `weight / (2 * energyRef ^ 2)` already used by the source-compatible Hilbert layer.
For a constant momentum weight, it proves the normalized residual-tail identity.  For the uniform
finite average `weight = 1 / |G|`, the transform cardinality cancels and leaves exactly
`1 / (2 * energyRef ^ 2)` times the omitted coefficient Frobenius power.

The constant/uniform weight hypothesis is explicit and essential.  No theorem here replaces a
nonuniform quadrature by a uniform one.  The finite group is not yet bound to a publication mesh,
the support is not yet bound to a physical shell, and no runtime artifact or evidence identifier is
accepted by these declarations.
-/

@[expose] public section

open scoped BigOperators
open Fintype (card)

namespace ProjectKoios.BandGauge.Fourier

open ProjectKoios.BandGauge.Hilbert

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

omit [AddCommGroup G] [DecidableEq G] in
/-- `BG-FOURIER-THM-029`: a constant rank-two weight factors from the exact weighted loss. -/
theorem rankTwoWeightedFrobeniusSq_const_eq_coefficient_mul_power
    (weight energyRef : ℝ) (field : G → Matrix (Fin 2) (Fin 2) ℂ) :
    rankTwoWeightedFrobeniusSq (fun _ : G => weight) energyRef field =
      rankTwoFrobeniusCoefficient weight energyRef * finiteMatrixFrobeniusPower field := by
  rw [rankTwoWeightedFrobeniusSq, finiteMatrixFrobeniusPower]
  rw [Fintype.sum_prod_type]
  simp_rw [Fintype.sum_prod_type]
  simp_rw [Finset.mul_sum]

/-- `BG-FOURIER-DEF-014`: paper-normalized omitted rank-two coefficient Frobenius power. -/
noncomputable def omittedRankTwoWeightedFrobeniusPower
    (weight energyRef : ℝ)
    (coefficients : AddChar G ℂ → Matrix (Fin 2) (Fin 2) ℂ)
    (support : Finset (AddChar G ℂ)) : ℝ :=
  rankTwoFrobeniusCoefficient weight energyRef *
    omittedMatrixFrobeniusPower coefficients support

/-- `BG-FOURIER-THM-030`: constant-weight rank-two residual equals `|G|` times normalized tail. -/
theorem rankTwoWeightedFrobeniusTruncationResidual_eq
    (weight energyRef : ℝ)
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix (Fin 2) (Fin 2) ℂ) :
    rankTwoWeightedFrobeniusSq (fun _ : G => weight) energyRef
        (finiteFourierTruncationResidual support coefficients) =
      (card G : ℝ) *
        omittedRankTwoWeightedFrobeniusPower weight energyRef coefficients support := by
  rw [rankTwoWeightedFrobeniusSq_const_eq_coefficient_mul_power,
    finiteMatrixFrobeniusTruncationResidual_parseval]
  rw [omittedRankTwoWeightedFrobeniusPower]
  ring

/-- `BG-FOURIER-DEF-015`: uniform finite-mesh averaging weight `1 / |G|`. -/
noncomputable def uniformFiniteWeight (G : Type*) [Fintype G] : ℝ :=
  (card G : ℝ)⁻¹

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-031`: the uniform finite weight is strictly positive. -/
theorem uniformFiniteWeight_pos : 0 < uniformFiniteWeight G := by
  rw [uniformFiniteWeight]
  exact inv_pos.mpr (by exact_mod_cast Fintype.card_pos)

/-- `BG-FOURIER-THM-032`: uniform averaging leaves the exact paper coefficient `1/(2E²)`. -/
theorem uniformRankTwoWeightedFrobeniusTruncationResidual_eq
    (energyRef : ℝ) (_henergyRef : 0 < energyRef)
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix (Fin 2) (Fin 2) ℂ) :
    rankTwoWeightedFrobeniusSq (fun _ : G => uniformFiniteWeight G) energyRef
        (finiteFourierTruncationResidual support coefficients) =
      (1 / (2 * energyRef ^ 2)) * omittedMatrixFrobeniusPower coefficients support := by
  rw [rankTwoWeightedFrobeniusTruncationResidual_eq,
    omittedRankTwoWeightedFrobeniusPower, rankTwoFrobeniusCoefficient, uniformFiniteWeight]
  have hcard : (card G : ℝ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  field_simp

end ProjectKoios.BandGauge.Fourier

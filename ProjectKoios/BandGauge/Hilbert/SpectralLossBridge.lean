module

public import ProjectKoios.BandGauge.Geometry.RankTwoLoss
public import ProjectKoios.BandGauge.Hilbert.WeightedFrobenius

/-!
# Rank-two spectral-residual loss bridge

This module formalizes the spectral-channel expansion in Supplementary Section S1.1 of
Ragasa2026A. A finite two-state centered splitting field has residual
`Eref * s + (λ - 1) * d`. Normalized weights and pointwise centering remove the cross
term and recover the existing reduced scalar spectral loss.
-/

open scoped BigOperators
open Finset

@[expose] public section

namespace ProjectKoios.BandGauge.Hilbert

/-- `BG-HILBERT-DEF-009`: a finite retained-rank-two real spectral splitting field. -/
abbrev RankTwoSpectralField (I : Type*) := I → Fin 2 → ℝ

/-- `BG-HILBERT-DEF-010`: source-normalized weighted power of a rank-two spectral field. -/
noncomputable def rankTwoWeightedSpectralPower {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (d : RankTwoSpectralField I) : ℝ :=
  ∑ p : I × Fin 2,
    rankTwoFrobeniusCoefficient (weight p.1) energyRef * (d p.1 p.2) ^ 2

/-- `BG-HILBERT-DEF-011`: unnormalized two-state spectral residual
`Eref * s + (λ - 1) * d`. -/
def rankTwoSpectralResidual {I : Type*} (energyRef shift scale : ℝ)
    (d : RankTwoSpectralField I) : RankTwoSpectralField I :=
  fun i a => energyRef * shift + (scale - 1) * d i a

/-- `BG-HILBERT-DEF-012`: source-normalized weighted squared spectral residual. -/
noncomputable def rankTwoSpectralFieldLossSq {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef shift scale : ℝ)
    (d : RankTwoSpectralField I) : ℝ :=
  rankTwoWeightedSpectralPower weight energyRef
    (rankTwoSpectralResidual energyRef shift scale d)

private noncomputable def rankTwoWeightedSpectralCorrelation
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ)
    (d e : RankTwoSpectralField I) : ℝ :=
  ∑ p : I × Fin 2,
    rankTwoFrobeniusCoefficient (weight p.1) energyRef * d p.1 p.2 * e p.1 p.2

private theorem rankTwoWeightedSpectralPower_linear_combination
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef a b : ℝ)
    (d e : RankTwoSpectralField I) :
    rankTwoWeightedSpectralPower weight energyRef
        (fun i n => a * d i n + b * e i n) =
      a ^ 2 * rankTwoWeightedSpectralPower weight energyRef d +
        2 * a * b * rankTwoWeightedSpectralCorrelation weight energyRef d e +
          b ^ 2 * rankTwoWeightedSpectralPower weight energyRef e := by
  rw [rankTwoWeightedSpectralPower, rankTwoWeightedSpectralPower,
    rankTwoWeightedSpectralCorrelation, rankTwoWeightedSpectralPower]
  rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum]
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p hp
  ring

private theorem spectralIdentity_power
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ)
    (hweightSum : ∑ i, weight i = 1) :
    rankTwoWeightedSpectralPower weight energyRef (fun _ _ => 1) =
      1 / energyRef ^ 2 := by
  rw [rankTwoWeightedSpectralPower, Fintype.sum_prod_type]
  simp only [one_pow]
  calc
    (∑ i, ∑ _ : Fin 2,
      rankTwoFrobeniusCoefficient (weight i) energyRef * 1) =
        ∑ i, weight i / energyRef ^ 2 := by
      apply Finset.sum_congr rfl
      intro i hi
      simp [rankTwoFrobeniusCoefficient]
      ring
    _ = 1 / energyRef ^ 2 := by rw [← Finset.sum_div, hweightSum]

private theorem spectralIdentity_correlation_zero
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ) (d : RankTwoSpectralField I)
    (hcentered : ∀ i, ∑ a, d i a = 0) :
    rankTwoWeightedSpectralCorrelation weight energyRef (fun _ _ => 1) d = 0 := by
  rw [rankTwoWeightedSpectralCorrelation, Fintype.sum_prod_type]
  apply Finset.sum_eq_zero
  intro i hi
  change (∑ a : Fin 2,
    rankTwoFrobeniusCoefficient (weight i) energyRef * 1 * d i a) = 0
  rw [mul_one, ← Finset.mul_sum, hcentered i, mul_zero]

/-- `BG-HILBERT-THM-014`: the centered two-state spectral residual expands exactly to
`s² + (λ - 1)² P(d)`. -/
theorem rankTwoSpectralFieldLossSq_eq_expansion
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef shift scale : ℝ)
    (d : RankTwoSpectralField I)
    (hweightSum : ∑ i, weight i = 1) (henergyRef : energyRef ≠ 0)
    (hcentered : ∀ i, ∑ a, d i a = 0) :
    rankTwoSpectralFieldLossSq weight energyRef shift scale d =
      shift ^ 2 + (scale - 1) ^ 2 *
        rankTwoWeightedSpectralPower weight energyRef d := by
  have hexpand := rankTwoWeightedSpectralPower_linear_combination
    weight energyRef (energyRef * shift) (scale - 1) (fun _ _ => 1) d
  rw [spectralIdentity_power weight energyRef hweightSum,
    spectralIdentity_correlation_zero weight energyRef d hcentered] at hexpand
  rw [rankTwoSpectralFieldLossSq]
  have hresidual : rankTwoSpectralResidual energyRef shift scale d =
      fun i n => (energyRef * shift) * 1 + (scale - 1) * d i n := by
    funext i n
    simp [rankTwoSpectralResidual]
  rw [hresidual, hexpand]
  field_simp
  ring

/-- `BG-HILBERT-THM-015`: when the centered splitting field has weighted power `κ`, its
matrix-derived spectral loss equals the existing reduced scalar spectral loss. -/
theorem rankTwoSpectralFieldLossSq_eq_rankTwoSpectralLossSq
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef κ : ℝ)
    (d : RankTwoSpectralField I)
    (hweightSum : ∑ i, weight i = 1) (henergyRef : energyRef ≠ 0)
    (hcentered : ∀ i, ∑ a, d i a = 0)
    (hpower : rankTwoWeightedSpectralPower weight energyRef d = κ)
    (p : ProjectKoios.BandGauge.Geometry.RankTwoParameter) :
    rankTwoSpectralFieldLossSq weight energyRef (p 0) (p 1) d =
      ProjectKoios.BandGauge.Geometry.rankTwoSpectralLossSq κ p := by
  rw [rankTwoSpectralFieldLossSq_eq_expansion weight energyRef (p 0) (p 1) d
    hweightSum henergyRef hcentered, hpower]
  rw [ProjectKoios.BandGauge.Geometry.rankTwoSpectralLossSq]
  ring

end ProjectKoios.BandGauge.Hilbert

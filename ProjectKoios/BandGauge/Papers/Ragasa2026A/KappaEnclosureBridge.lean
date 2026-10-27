/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.BandGauge.Certificates.RankTwoSeparationBox
public import ProjectKoios.BandGauge.Papers.Ragasa2026A.CertificateBridge

/-!
# Ragasa2026A joint kappa-correlation enclosure bridge

This module binds a checked rational `(κ, μmax)` enclosure to the canonical finite Paper A
fields. The actual real parent power remains an explicit theorem input and must be proved
to lie in the checked `κ` interval. No parser, retained runtime artifact, or physical
validation is supplied.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Papers.Ragasa2026A

open ProjectKoios.BandGauge

/-- `BG-RAGASA2026A-THM-035`: acceptance of a joint rational enclosure, together with
proved bounds on the actual field-derived parent power and optimized normalized
correlation, yields a positive-scale spectral pass and disjoint canonical pass sets in the
candidate rectangle. -/
theorem canonicalSpectralPass_and_operatorIncompatibility_of_checkedBox
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (c : Certificates.RankTwoSeparationBoxCertificate)
    (κ : ℝ)
    (hcheck : Certificates.checkRankTwoSeparationBoxCertificate c = true)
    (hκLower : (c.kappaLower : ℝ) ≤ κ)
    (hκUpper : κ ≤ (c.kappaUpper : ℝ))
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (hmuLower : (c.muLower : ℝ) ≤ maximumNormalizedOperatorCorrelation
      (canonicalRankTwoPauliDecomposition data) κ)
    (hmuUpper : maximumNormalizedOperatorCorrelation
      (canonicalRankTwoPauliDecomposition data) κ ≤ (c.muUpper : ℝ)) :
    c.spectralWitness ∈
        canonicalSpectralAdmissibleSetInRectangle data
          (Certificates.rankTwoParameterOfRat c.lowerShift c.lowerScale)
          (Certificates.rankTwoParameterOfRat c.upperShift c.upperScale)
          (c.spectralBudget : ℝ) ∧
      0 < c.spectralWitness 1 ∧
      Disjoint
        (canonicalSpectralAdmissibleSetInRectangle data
          (Certificates.rankTwoParameterOfRat c.lowerShift c.lowerScale)
          (Certificates.rankTwoParameterOfRat c.upperShift c.upperScale)
          (c.spectralBudget : ℝ))
        (canonicalOptimizedOperatorAdmissibleSetInRectangle data
          (Certificates.rankTwoParameterOfRat c.lowerShift c.lowerScale)
          (Certificates.rankTwoParameterOfRat c.upperShift c.upperScale)
          (c.operatorBudget : ℝ)) := by
  have hvalid :=
    Certificates.valid_of_checkRankTwoSeparationBoxCertificate_eq_true hcheck
  have hκLowerPos : 0 < (c.kappaLower : ℝ) := by
    exact_mod_cast hvalid.kappaLower_pos
  have hκ : 0 < κ := hκLowerPos.trans_le hκLower
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast hvalid.spectralBudget_nonneg
  have hob : 0 ≤ (c.operatorBudget : ℝ) := by
    exact_mod_cast hvalid.operatorBudget_nonneg
  let μ := maximumNormalizedOperatorCorrelation
    (canonicalRankTwoPauliDecomposition data) κ
  have hmuBound : |μ| ≤ 1 := by
    dsimp [μ]
    exact abs_maximumOperatorCorrelation_div_le_one
      (canonicalRankTwoPauliDecomposition data) κ hκ hpower
  have hmuLowerNonneg : 0 ≤ (c.muLower : ℝ) := by
    exact_mod_cast hvalid.muLower_nonneg
  have hmuUpperLeOne : (c.muUpper : ℝ) ≤ 1 := by
    exact_mod_cast hvalid.muUpper_le_one
  have hmuNonneg : 0 ≤ μ := hmuLowerNonneg.trans hmuLower
  have hmuSqLower : (c.muLower : ℝ) ^ 2 ≤ μ ^ 2 :=
    (sq_le_sq₀ hmuLowerNonneg hmuNonneg).2 hmuLower
  have hfactorLower : 0 ≤ 1 - (c.muLower : ℝ) ^ 2 := by
    have hmuLowerLeOne : (c.muLower : ℝ) ≤ 1 :=
      hmuLower.trans (hmuUpper.trans hmuUpperLeOne)
    nlinarith [sq_le_sq₀ hmuLowerNonneg zero_le_one |>.2 hmuLowerLeOne]
  have hradCert : (c.kappaUpper : ℝ) *
      (1 - (c.muLower : ℝ) ^ 2) ≤ (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast hvalid.operator_radicand_nonneg_at_upper_lower
  have hrad : κ * (1 - μ ^ 2) ≤ (c.operatorBudget : ℝ) ^ 2 := by
    have hfactorLe : 1 - μ ^ 2 ≤ 1 - (c.muLower : ℝ) ^ 2 := by
      linarith
    calc
      κ * (1 - μ ^ 2) ≤ κ * (1 - (c.muLower : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_left hfactorLe hκ.le
      _ ≤ (c.kappaUpper : ℝ) * (1 - (c.muLower : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_right hκUpper hfactorLower
      _ ≤ (c.operatorBudget : ℝ) ^ 2 := hradCert
  have hwitness := Certificates.boxSpectralWitness_mem_of_check_eq_true
    hcheck hκLower hκUpper
  have hwitnessCanonical : c.spectralWitness ∈
      canonicalSpectralAdmissibleSetInRectangle data
        (Certificates.rankTwoParameterOfRat c.lowerShift c.lowerScale)
        (Certificates.rankTwoParameterOfRat c.upperShift c.upperScale)
        (c.spectralBudget : ℝ) := by
    constructor
    · change canonicalSpectralLoss data c.spectralWitness ≤
        (c.spectralBudget : ℝ)
      rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data κ hpower
        c.spectralWitness]
      exact (Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hsb
        c.spectralWitness).2 hwitness.1.1
    · exact hwitness.1.2
  refine ⟨hwitnessCanonical, hwitness.2, ?_⟩
  have hfullDisjoint := Certificates.disjoint_fullEllipses_of_boxCheck_eq_true
    hcheck hκLower hκUpper hmuLower hmuUpper
  apply hfullDisjoint.mono
  · intro p hp
    have hpLoss := hp.1
    change canonicalSpectralLoss data p ≤ (c.spectralBudget : ℝ) at hpLoss
    rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data κ hpower p] at hpLoss
    exact (Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hsb p).1 hpLoss
  · intro p hp
    have hpLoss := hp.1
    change canonicalOptimizedOperatorLoss data p ≤
      (c.operatorBudget : ℝ) at hpLoss
    rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss data
      κ hκ hpower p] at hpLoss
    exact (Geometry.rankTwoAlignedOperatorLoss_le_iff_ellipse
      hκ.le hmuBound hob hrad p).1 hpLoss

end ProjectKoios.BandGauge.Papers.Ragasa2026A

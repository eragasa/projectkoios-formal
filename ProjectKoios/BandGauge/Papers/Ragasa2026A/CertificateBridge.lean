module

public import ProjectKoios.BandGauge.Certificates.RankTwoSeparationEnclosure
public import ProjectKoios.BandGauge.Papers.Ragasa2026A.OptimizedLossGeometry

/-!
# Ragasa2026A exact certificate bridge

This module connects accepted exact rational scalar certificates to the canonical finite
Paper A loss fields. One bridge uses exact equality with a rational `μ`; the second uses
proved rational lower and upper bounds and therefore supports algebraic centers such as
`1 / √2`. Parent-power and center binding hypotheses remain explicit. No concrete
publication data, runtime parser, or numerical eigensolver output is certified here.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Papers.Ragasa2026A

open ProjectKoios.BandGauge

/-- `BG-RAGASA2026A-THM-027`: after exact binding of its scalar `κ` and `μ` to the
canonical finite fields, an accepted rational certificate supplies a positive-scale
spectral pass in the candidate rectangle and proves that the canonical spectral and
optimized operator pass sets there are disjoint. -/
theorem canonicalSpectralPass_and_operatorIncompatibility_of_checkedCertificate
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (c : Certificates.RankTwoSeparationCertificate)
    (hcheck : Certificates.checkRankTwoSeparationCertificate c = true)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = (c.kappa : ℝ))
    (hmu : maximumNormalizedOperatorCorrelation
      (canonicalRankTwoPauliDecomposition data) (c.kappa : ℝ) = (c.mu : ℝ)) :
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
    Certificates.valid_of_checkRankTwoSeparationCertificate_eq_true hcheck
  have hκ : 0 < (c.kappa : ℝ) := by exact_mod_cast hvalid.kappa_pos
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast hvalid.spectralBudget_nonneg
  have hob : 0 ≤ (c.operatorBudget : ℝ) := by
    exact_mod_cast hvalid.operatorBudget_nonneg
  have hmuBound : |(c.mu : ℝ)| ≤ 1 := by
    exact_mod_cast hvalid.mu_abs_le_one
  have hrad : (c.kappa : ℝ) * (1 - (c.mu : ℝ) ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast hvalid.operator_radicand_nonneg
  have hwitness := Certificates.spectralWitness_mem_of_check_eq_true hcheck
  have hwitnessCanonical : c.spectralWitness ∈
      canonicalSpectralAdmissibleSetInRectangle data
        (Certificates.rankTwoParameterOfRat c.lowerShift c.lowerScale)
        (Certificates.rankTwoParameterOfRat c.upperShift c.upperScale)
        (c.spectralBudget : ℝ) := by
    constructor
    · change canonicalSpectralLoss data c.spectralWitness ≤
        (c.spectralBudget : ℝ)
      rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data
        (c.kappa : ℝ) hpower c.spectralWitness]
      exact (Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hsb
        c.spectralWitness).2 hwitness.1.1
    · exact hwitness.1.2
  refine ⟨hwitnessCanonical, hwitness.2, ?_⟩
  have hfullDisjoint := Certificates.disjoint_fullEllipses_of_check_eq_true hcheck
  apply hfullDisjoint.mono
  · intro p hp
    have hpLoss := hp.1
    change canonicalSpectralLoss data p ≤ (c.spectralBudget : ℝ) at hpLoss
    rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data
      (c.kappa : ℝ) hpower p] at hpLoss
    exact (Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hsb p).1 hpLoss
  · intro p hp
    have hpLoss := hp.1
    change canonicalOptimizedOperatorLoss data p ≤
      (c.operatorBudget : ℝ) at hpLoss
    rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss data
      (c.kappa : ℝ) hκ hpower p, hmu] at hpLoss
    exact (Geometry.rankTwoAlignedOperatorLoss_le_iff_ellipse
      hκ.le hmuBound hob hrad p).1 hpLoss

/-- `BG-RAGASA2026A-THM-028`: a checked rational enclosure certificate needs only
proved lower and upper bounds on the field-derived real `μmax`; exact equality with a
rational center is unnecessary. Acceptance again yields a positive-scale spectral pass
and disjoint canonical pass sets throughout the candidate rectangle. -/
theorem canonicalSpectralPass_and_operatorIncompatibility_of_checkedEnclosure
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (c : Certificates.RankTwoSeparationEnclosureCertificate)
    (hcheck : Certificates.checkRankTwoSeparationEnclosureCertificate c = true)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = (c.kappa : ℝ))
    (hmuLower : (c.muLower : ℝ) ≤ maximumNormalizedOperatorCorrelation
      (canonicalRankTwoPauliDecomposition data) (c.kappa : ℝ))
    (hmuUpper : maximumNormalizedOperatorCorrelation
      (canonicalRankTwoPauliDecomposition data) (c.kappa : ℝ) ≤ (c.muUpper : ℝ)) :
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
    Certificates.valid_of_checkRankTwoSeparationEnclosureCertificate_eq_true hcheck
  have hκ : 0 < (c.kappa : ℝ) := by exact_mod_cast hvalid.kappa_pos
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast hvalid.spectralBudget_nonneg
  have hob : 0 ≤ (c.operatorBudget : ℝ) := by
    exact_mod_cast hvalid.operatorBudget_nonneg
  let μ := maximumNormalizedOperatorCorrelation
    (canonicalRankTwoPauliDecomposition data) (c.kappa : ℝ)
  have hmuBound : |μ| ≤ 1 := by
    dsimp [μ]
    exact abs_maximumOperatorCorrelation_div_le_one
      (canonicalRankTwoPauliDecomposition data) (c.kappa : ℝ) hκ hpower
  have hmuLowerNonneg : 0 ≤ (c.muLower : ℝ) := by
    exact_mod_cast hvalid.muLower_nonneg
  have hmuNonneg : 0 ≤ μ := hmuLowerNonneg.trans hmuLower
  have hmuSqLower : (c.muLower : ℝ) ^ 2 ≤ μ ^ 2 :=
    (sq_le_sq₀ hmuLowerNonneg hmuNonneg).2 hmuLower
  have hradLower : (c.kappa : ℝ) * (1 - (c.muLower : ℝ) ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast hvalid.operator_radicand_nonneg_at_lower
  have hrad : (c.kappa : ℝ) * (1 - μ ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    nlinarith
  have hwitness :=
    Certificates.enclosureSpectralWitness_mem_of_check_eq_true hcheck
  have hwitnessCanonical : c.spectralWitness ∈
      canonicalSpectralAdmissibleSetInRectangle data
        (Certificates.rankTwoParameterOfRat c.lowerShift c.lowerScale)
        (Certificates.rankTwoParameterOfRat c.upperShift c.upperScale)
        (c.spectralBudget : ℝ) := by
    constructor
    · change canonicalSpectralLoss data c.spectralWitness ≤
        (c.spectralBudget : ℝ)
      rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data
        (c.kappa : ℝ) hpower c.spectralWitness]
      exact (Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hsb
        c.spectralWitness).2 hwitness.1.1
    · exact hwitness.1.2
  refine ⟨hwitnessCanonical, hwitness.2, ?_⟩
  have hfullDisjoint :=
    Certificates.disjoint_fullEllipses_of_enclosureCheck_eq_true
      hcheck hmuLower hmuUpper
  apply hfullDisjoint.mono
  · intro p hp
    have hpLoss := hp.1
    change canonicalSpectralLoss data p ≤ (c.spectralBudget : ℝ) at hpLoss
    rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data
      (c.kappa : ℝ) hpower p] at hpLoss
    exact (Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hsb p).1 hpLoss
  · intro p hp
    have hpLoss := hp.1
    change canonicalOptimizedOperatorLoss data p ≤
      (c.operatorBudget : ℝ) at hpLoss
    rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss data
      (c.kappa : ℝ) hκ hpower p] at hpLoss
    exact (Geometry.rankTwoAlignedOperatorLoss_le_iff_ellipse
      hκ.le hmuBound hob hrad p).1 hpLoss

end ProjectKoios.BandGauge.Papers.Ragasa2026A

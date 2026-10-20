/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.BandGauge.Certificates.RankTwoSeparationEnclosure

/-!
# Joint kappa-correlation enclosure certificates

This module extends the exact rank-two separation checker to an independently supplied
real curvature `κ` in a checked rational interval and a real correlation center `μ` in a
checked rational interval. Every witness, containment, radius, and separation conclusion
is uniform over the full declared rectangle in `(κ, μ)`.

The checker consumes exact rational bounds only. It is not a floating-point interval
engine, runtime parser, retained evidence package, or scientific-validation claim.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Certificates

open ProjectKoios.BandGauge

/-- `BG-CERT-DEF-017`: exact rational certificate data whose conclusions hold uniformly
for every `κ ∈ [kappaLower, kappaUpper]` and `μ ∈ [muLower, muUpper]`. -/
structure RankTwoSeparationBoxCertificate where
  kappaLower : ℚ
  kappaUpper : ℚ
  muLower : ℚ
  muUpper : ℚ
  spectralBudget : ℚ
  operatorBudget : ℚ
  operatorRadiusUpper : ℚ
  spectralLambdaRadiusUpper : ℚ
  operatorLambdaRadiusUpper : ℚ
  lowerShift : ℚ
  lowerScale : ℚ
  upperShift : ℚ
  upperScale : ℚ
  witnessShift : ℚ
  witnessScale : ℚ
  deriving DecidableEq, Repr

/-- `BG-CERT-DEF-018`: exact rational validity conditions for a joint `(κ, μ)` enclosure.
Lower `κ` controls maximal ellipse widths and minimum center separation; upper `κ`
controls the worst operator floor and the spectral witness. -/
structure RankTwoSeparationBoxCertificate.Valid
    (c : RankTwoSeparationBoxCertificate) : Prop where
  kappaLower_pos : 0 < c.kappaLower
  kappaLower_le_kappaUpper : c.kappaLower ≤ c.kappaUpper
  muLower_nonneg : 0 ≤ c.muLower
  muLower_le_muUpper : c.muLower ≤ c.muUpper
  muUpper_le_one : c.muUpper ≤ 1
  spectralBudget_nonneg : 0 ≤ c.spectralBudget
  operatorBudget_nonneg : 0 ≤ c.operatorBudget
  operatorRadiusUpper_nonneg : 0 ≤ c.operatorRadiusUpper
  spectralLambdaRadiusUpper_nonneg : 0 ≤ c.spectralLambdaRadiusUpper
  operatorLambdaRadiusUpper_nonneg : 0 ≤ c.operatorLambdaRadiusUpper
  operator_radicand_nonneg_at_upper_lower :
    c.kappaUpper * (1 - c.muLower ^ 2) ≤ c.operatorBudget ^ 2
  operator_radicand_at_lower_upper_le_radiusUpper_sq :
    c.operatorBudget ^ 2 - c.kappaLower * (1 - c.muUpper ^ 2) ≤
      c.operatorRadiusUpper ^ 2
  spectral_scale_radius_bound_at_lower :
    c.spectralBudget ^ 2 ≤
      c.kappaLower * c.spectralLambdaRadiusUpper ^ 2
  operator_scale_radius_bound_at_lower_upper :
    c.operatorBudget ^ 2 - c.kappaLower * (1 - c.muUpper ^ 2) ≤
      c.kappaLower * c.operatorLambdaRadiusUpper ^ 2
  lowerShift_le_spectral : c.lowerShift ≤ -c.spectralBudget
  spectral_le_upperShift : c.spectralBudget ≤ c.upperShift
  lowerShift_le_operator : c.lowerShift ≤ -c.operatorRadiusUpper
  operator_le_upperShift : c.operatorRadiusUpper ≤ c.upperShift
  lowerScale_le_spectral :
    c.lowerScale ≤ 1 - c.spectralLambdaRadiusUpper
  spectral_le_upperScale :
    1 + c.spectralLambdaRadiusUpper ≤ c.upperScale
  lowerScale_le_operator :
    c.lowerScale ≤ c.muLower - c.operatorLambdaRadiusUpper
  operator_le_upperScale :
    c.muUpper + c.operatorLambdaRadiusUpper ≤ c.upperScale
  witnessShift_mem :
    c.lowerShift ≤ c.witnessShift ∧ c.witnessShift ≤ c.upperShift
  witnessScale_mem :
    c.lowerScale ≤ c.witnessScale ∧ c.witnessScale ≤ c.upperScale
  lowerScale_pos : 0 < c.lowerScale
  witness_spectral_at_upper :
    c.witnessShift ^ 2 + c.kappaUpper * (c.witnessScale - 1) ^ 2 ≤
      c.spectralBudget ^ 2
  strict_separation_sq_at_lower_upper :
    (c.spectralBudget + c.operatorRadiusUpper) ^ 2 <
      c.kappaLower * (1 - c.muUpper) ^ 2

/-- `BG-CERT-DEF-019`: decidable conjunction form of joint-enclosure validity. -/
def rankTwoSeparationBoxCertificateConditions
    (c : RankTwoSeparationBoxCertificate) : Prop :=
  0 < c.kappaLower ∧
  c.kappaLower ≤ c.kappaUpper ∧
  0 ≤ c.muLower ∧
  c.muLower ≤ c.muUpper ∧
  c.muUpper ≤ 1 ∧
  0 ≤ c.spectralBudget ∧
  0 ≤ c.operatorBudget ∧
  0 ≤ c.operatorRadiusUpper ∧
  0 ≤ c.spectralLambdaRadiusUpper ∧
  0 ≤ c.operatorLambdaRadiusUpper ∧
  c.kappaUpper * (1 - c.muLower ^ 2) ≤ c.operatorBudget ^ 2 ∧
  c.operatorBudget ^ 2 - c.kappaLower * (1 - c.muUpper ^ 2) ≤
    c.operatorRadiusUpper ^ 2 ∧
  c.spectralBudget ^ 2 ≤
    c.kappaLower * c.spectralLambdaRadiusUpper ^ 2 ∧
  c.operatorBudget ^ 2 - c.kappaLower * (1 - c.muUpper ^ 2) ≤
    c.kappaLower * c.operatorLambdaRadiusUpper ^ 2 ∧
  c.lowerShift ≤ -c.spectralBudget ∧
  c.spectralBudget ≤ c.upperShift ∧
  c.lowerShift ≤ -c.operatorRadiusUpper ∧
  c.operatorRadiusUpper ≤ c.upperShift ∧
  c.lowerScale ≤ 1 - c.spectralLambdaRadiusUpper ∧
  1 + c.spectralLambdaRadiusUpper ≤ c.upperScale ∧
  c.lowerScale ≤ c.muLower - c.operatorLambdaRadiusUpper ∧
  c.muUpper + c.operatorLambdaRadiusUpper ≤ c.upperScale ∧
  (c.lowerShift ≤ c.witnessShift ∧ c.witnessShift ≤ c.upperShift) ∧
  (c.lowerScale ≤ c.witnessScale ∧ c.witnessScale ≤ c.upperScale) ∧
  0 < c.lowerScale ∧
  c.witnessShift ^ 2 + c.kappaUpper * (c.witnessScale - 1) ^ 2 ≤
    c.spectralBudget ^ 2 ∧
  (c.spectralBudget + c.operatorRadiusUpper) ^ 2 <
    c.kappaLower * (1 - c.muUpper) ^ 2

instance (c : RankTwoSeparationBoxCertificate) :
    Decidable (rankTwoSeparationBoxCertificateConditions c) := by
  unfold rankTwoSeparationBoxCertificateConditions
  infer_instance

/-- `BG-CERT-DEF-020`: executable exact rational joint-enclosure checker. -/
def checkRankTwoSeparationBoxCertificate
    (c : RankTwoSeparationBoxCertificate) : Bool :=
  decide (rankTwoSeparationBoxCertificateConditions c)

/-- `BG-CERT-DEF-021`: candidate rectangle encoded by a joint-enclosure certificate. -/
noncomputable def RankTwoSeparationBoxCertificate.candidateRectangle
    (c : RankTwoSeparationBoxCertificate) : Set Geometry.RankTwoParameter :=
  Geometry.rankTwoCandidateRectangle
    (rankTwoParameterOfRat c.lowerShift c.lowerScale)
    (rankTwoParameterOfRat c.upperShift c.upperScale)

/-- `BG-CERT-DEF-022`: spectral witness encoded by a joint-enclosure certificate. -/
noncomputable def RankTwoSeparationBoxCertificate.spectralWitness
    (c : RankTwoSeparationBoxCertificate) : Geometry.RankTwoParameter :=
  rankTwoParameterOfRat c.witnessShift c.witnessScale

/-- `BG-CERT-THM-013`: successful Boolean checking recovers every exact rational
joint-enclosure condition. -/
theorem valid_of_checkRankTwoSeparationBoxCertificate_eq_true
    {c : RankTwoSeparationBoxCertificate}
    (hcheck : checkRankTwoSeparationBoxCertificate c = true) : c.Valid := by
  have hconditions : rankTwoSeparationBoxCertificateConditions c :=
    of_decide_eq_true hcheck
  rcases hconditions with ⟨hκl, hκlu, hμl, hμlu, hμu, hsb, hob, hru,
    hslr, holr, hradl, hradu, hsr, hor, hls, hsu, hlo, hou, hlls, hsul,
    hllo, houl, hws, hwl, hLowerScale, hwitness, hsep⟩
  exact ⟨hκl, hκlu, hμl, hμlu, hμu, hsb, hob, hru, hslr, holr,
    hradl, hradu, hsr, hor, hls, hsu, hlo, hou, hlls, hsul, hllo, houl,
    hws, hwl, hLowerScale, hwitness, hsep⟩

/-- `BG-CERT-THM-014`: for every real `κ` in the checked interval, acceptance supplies
one exact positive-scale spectral witness in the full spectral ellipse and rectangle. -/
theorem boxSpectralWitness_mem_of_check_eq_true
    {c : RankTwoSeparationBoxCertificate} {κ : ℝ}
    (hcheck : checkRankTwoSeparationBoxCertificate c = true)
    (hκLower : (c.kappaLower : ℝ) ≤ κ)
    (hκUpper : κ ≤ (c.kappaUpper : ℝ)) :
    c.spectralWitness ∈
        Geometry.rankTwoFullSpectralEllipse κ (c.spectralBudget : ℝ) ∩
          c.candidateRectangle ∧
      0 < c.spectralWitness 1 := by
  have h := valid_of_checkRankTwoSeparationBoxCertificate_eq_true hcheck
  have hκLowerPos : 0 < (c.kappaLower : ℝ) := by
    exact_mod_cast h.kappaLower_pos
  have hκNonneg : 0 ≤ κ := hκLowerPos.le.trans hκLower
  have hκUpperReal : κ ≤ (c.kappaUpper : ℝ) := hκUpper
  have hqNonneg : 0 ≤ ((c.witnessScale : ℝ) - 1) ^ 2 := sq_nonneg _
  have hwitnessUpper :
      (c.witnessShift : ℝ) ^ 2 + (c.kappaUpper : ℝ) *
          ((c.witnessScale : ℝ) - 1) ^ 2 ≤ (c.spectralBudget : ℝ) ^ 2 := by
    exact_mod_cast h.witness_spectral_at_upper
  have hwitness :
      (c.witnessShift : ℝ) ^ 2 + κ * ((c.witnessScale : ℝ) - 1) ^ 2 ≤
        (c.spectralBudget : ℝ) ^ 2 := by
    have hmul : κ * ((c.witnessScale : ℝ) - 1) ^ 2 ≤
        (c.kappaUpper : ℝ) * ((c.witnessScale : ℝ) - 1) ^ 2 :=
      mul_le_mul_of_nonneg_right hκUpperReal hqNonneg
    linarith
  have hrect : c.spectralWitness ∈ c.candidateRectangle := by
    rw [RankTwoSeparationBoxCertificate.candidateRectangle,
      Geometry.rankTwoCandidateRectangle]
    constructor
    · intro i
      fin_cases i <;>
        simp [RankTwoSeparationBoxCertificate.spectralWitness,
          rankTwoParameterOfRat]
      · exact_mod_cast h.witnessShift_mem.1
      · exact_mod_cast h.witnessScale_mem.1
    · intro i
      fin_cases i <;>
        simp [RankTwoSeparationBoxCertificate.spectralWitness,
          rankTwoParameterOfRat]
      · exact_mod_cast h.witnessShift_mem.2
      · exact_mod_cast h.witnessScale_mem.2
  constructor
  · exact ⟨by simpa [RankTwoSeparationBoxCertificate.spectralWitness,
      rankTwoParameterOfRat, Geometry.rankTwoFullSpectralEllipse] using hwitness, hrect⟩
  · simp [RankTwoSeparationBoxCertificate.spectralWitness,
      rankTwoParameterOfRat]
    have hwitnessPos : 0 < c.witnessScale :=
      lt_of_lt_of_le h.lowerScale_pos h.witnessScale_mem.1
    exact_mod_cast hwitnessPos


/-- `BG-CERT-THM-015`: for every real `(κ, μ)` in the checked box, both full ellipses
lie in the encoded candidate rectangle. -/
theorem fullEllipses_subset_boxCandidateRectangle_of_check_eq_true
    {c : RankTwoSeparationBoxCertificate} {κ μ : ℝ}
    (hcheck : checkRankTwoSeparationBoxCertificate c = true)
    (hκLower : (c.kappaLower : ℝ) ≤ κ)
    (hκUpper : κ ≤ (c.kappaUpper : ℝ))
    (hμLower : (c.muLower : ℝ) ≤ μ)
    (hμUpper : μ ≤ (c.muUpper : ℝ)) :
    Geometry.rankTwoFullSpectralEllipse κ (c.spectralBudget : ℝ) ⊆
        c.candidateRectangle ∧
      Geometry.rankTwoFullOperatorEllipse κ μ
        (Geometry.rankTwoOperatorRadius κ μ (c.operatorBudget : ℝ)) ⊆
          c.candidateRectangle := by
  have h := valid_of_checkRankTwoSeparationBoxCertificate_eq_true hcheck
  have hκLowerPos : 0 < (c.kappaLower : ℝ) := by
    exact_mod_cast h.kappaLower_pos
  have hκPos : 0 < κ := hκLowerPos.trans_le hκLower
  have hμLowerNonneg : 0 ≤ (c.muLower : ℝ) := by
    exact_mod_cast h.muLower_nonneg
  have hμUpperLeOne : (c.muUpper : ℝ) ≤ 1 := by
    exact_mod_cast h.muUpper_le_one
  have hμNonneg : 0 ≤ μ := hμLowerNonneg.trans hμLower
  have hμLeOne : μ ≤ 1 := hμUpper.trans hμUpperLeOne
  have hμSqLower : (c.muLower : ℝ) ^ 2 ≤ μ ^ 2 :=
    (sq_le_sq₀ hμLowerNonneg hμNonneg).2 hμLower
  have hμSqUpper : μ ^ 2 ≤ (c.muUpper : ℝ) ^ 2 :=
    (sq_le_sq₀ hμNonneg (hμNonneg.trans hμUpper)).2 hμUpper
  have hfactorActual : 0 ≤ 1 - μ ^ 2 := by
    nlinarith [sq_le_sq₀ hμNonneg zero_le_one |>.2 hμLeOne]
  have hfactorLower : 0 ≤ 1 - (c.muLower : ℝ) ^ 2 := by
    have hmuLowerLeOne : (c.muLower : ℝ) ≤ 1 :=
      hμLower.trans (hμUpper.trans hμUpperLeOne)
    nlinarith [sq_le_sq₀ hμLowerNonneg zero_le_one |>.2 hmuLowerLeOne]
  have hfactorUpper : 0 ≤ 1 - (c.muUpper : ℝ) ^ 2 := by
    have hmuUpperNonneg : 0 ≤ (c.muUpper : ℝ) :=
      hμLowerNonneg.trans (by exact_mod_cast h.muLower_le_muUpper)
    nlinarith [sq_le_sq₀ hmuUpperNonneg zero_le_one |>.2 hμUpperLeOne]
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast h.spectralBudget_nonneg
  have hru : 0 ≤ (c.operatorRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorRadiusUpper_nonneg
  have hslr : 0 ≤ (c.spectralLambdaRadiusUpper : ℝ) := by
    exact_mod_cast h.spectralLambdaRadiusUpper_nonneg
  have holr : 0 ≤ (c.operatorLambdaRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorLambdaRadiusUpper_nonneg
  have hradCert : (c.kappaUpper : ℝ) *
      (1 - (c.muLower : ℝ) ^ 2) ≤ (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_nonneg_at_upper_lower
  have hrad : κ * (1 - μ ^ 2) ≤ (c.operatorBudget : ℝ) ^ 2 := by
    have hfactorLe : 1 - μ ^ 2 ≤ 1 - (c.muLower : ℝ) ^ 2 := by
      linarith
    calc
      κ * (1 - μ ^ 2) ≤ κ * (1 - (c.muLower : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_left hfactorLe hκPos.le
      _ ≤ (c.kappaUpper : ℝ) * (1 - (c.muLower : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_right hκUpper hfactorLower
      _ ≤ (c.operatorBudget : ℝ) ^ 2 := hradCert
  have hradUpperCert : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_at_lower_upper_le_radiusUpper_sq
  have hproductLower : (c.kappaLower : ℝ) *
      (1 - (c.muUpper : ℝ) ^ 2) ≤ κ * (1 - μ ^ 2) := by
    have hfactorLe : 1 - (c.muUpper : ℝ) ^ 2 ≤ 1 - μ ^ 2 := by
      linarith
    calc
      (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
          κ * (1 - (c.muUpper : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_right hκLower hfactorUpper
      _ ≤ κ * (1 - μ ^ 2) :=
        mul_le_mul_of_nonneg_left hfactorLe hκPos.le
  have hradru : (c.operatorBudget : ℝ) ^ 2 - κ * (1 - μ ^ 2) ≤
      (c.operatorRadiusUpper : ℝ) ^ 2 := by
    linarith
  have hsr : (c.spectralBudget : ℝ) ^ 2 ≤
      (c.kappaLower : ℝ) * (c.spectralLambdaRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.spectral_scale_radius_bound_at_lower
  have horLower : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
        (c.kappaLower : ℝ) * (c.operatorLambdaRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_scale_radius_bound_at_lower_upper
  constructor
  · intro p hp
    change (p 0) ^ 2 + κ * (p 1 - 1) ^ 2 ≤
      (c.spectralBudget : ℝ) ^ 2 at hp
    have hpShiftSq : (p 0) ^ 2 ≤ (c.spectralBudget : ℝ) ^ 2 := by
      nlinarith [mul_nonneg hκPos.le (sq_nonneg (p 1 - 1))]
    have hpShift : |p 0| ≤ (c.spectralBudget : ℝ) :=
      (sq_le_sq₀ (abs_nonneg _) hsb).1 (by simpa [sq_abs] using hpShiftSq)
    have hpScaleWeighted : κ * (p 1 - 1) ^ 2 ≤
        (c.spectralBudget : ℝ) ^ 2 := by
      nlinarith [sq_nonneg (p 0)]
    have hκRadius : (c.kappaLower : ℝ) *
        (c.spectralLambdaRadiusUpper : ℝ) ^ 2 ≤
          κ * (c.spectralLambdaRadiusUpper : ℝ) ^ 2 :=
      mul_le_mul_of_nonneg_right hκLower (sq_nonneg _)
    have hpScaleWeightedUpper : κ * (p 1 - 1) ^ 2 ≤
        κ * (c.spectralLambdaRadiusUpper : ℝ) ^ 2 :=
      hpScaleWeighted.trans (hsr.trans hκRadius)
    have hpScaleSq : (p 1 - 1) ^ 2 ≤
        (c.spectralLambdaRadiusUpper : ℝ) ^ 2 :=
      le_of_mul_le_mul_left hpScaleWeightedUpper hκPos
    have hpScale : |p 1 - 1| ≤ (c.spectralLambdaRadiusUpper : ℝ) :=
      (sq_le_sq₀ (abs_nonneg _) hslr).1 (by simpa [sq_abs] using hpScaleSq)
    rw [RankTwoSeparationBoxCertificate.candidateRectangle,
      Geometry.rankTwoCandidateRectangle]
    constructor
    · intro i
      fin_cases i
      · simp [rankTwoParameterOfRat]
        have hl : (c.lowerShift : ℝ) ≤ -(c.spectralBudget : ℝ) := by
          exact_mod_cast h.lowerShift_le_spectral
        exact hl.trans (neg_le_of_abs_le hpShift)
      · simp [rankTwoParameterOfRat]
        have hl : (c.lowerScale : ℝ) ≤
            1 - (c.spectralLambdaRadiusUpper : ℝ) := by
          exact_mod_cast h.lowerScale_le_spectral
        have hpLower : 1 - (c.spectralLambdaRadiusUpper : ℝ) ≤ p 1 := by
          linarith [(abs_le.1 hpScale).1]
        exact hl.trans hpLower
    · intro i
      fin_cases i
      · simp [rankTwoParameterOfRat]
        have hu : (c.spectralBudget : ℝ) ≤ (c.upperShift : ℝ) := by
          exact_mod_cast h.spectral_le_upperShift
        exact (le_of_abs_le hpShift).trans hu
      · simp [rankTwoParameterOfRat]
        have hu : 1 + (c.spectralLambdaRadiusUpper : ℝ) ≤
            (c.upperScale : ℝ) := by
          exact_mod_cast h.spectral_le_upperScale
        have hpUpper : p 1 ≤ 1 + (c.spectralLambdaRadiusUpper : ℝ) := by
          linarith [(abs_le.1 hpScale).2]
        exact hpUpper.trans hu
  · intro p hp
    let radius := Geometry.rankTwoOperatorRadius κ μ (c.operatorBudget : ℝ)
    change (p 0) ^ 2 + κ * (p 1 - μ) ^ 2 ≤ radius ^ 2 at hp
    have hradius_nonneg : 0 ≤ radius := Real.sqrt_nonneg _
    have hradiusSq : radius ^ 2 =
        (c.operatorBudget : ℝ) ^ 2 - κ * (1 - μ ^ 2) :=
      Geometry.rankTwoOperatorRadius_sq hrad
    have hradius_le : radius ≤ (c.operatorRadiusUpper : ℝ) := by
      dsimp [radius, Geometry.rankTwoOperatorRadius]
      exact (Real.sqrt_le_left hru).2 hradru
    have hpShiftSq : (p 0) ^ 2 ≤ radius ^ 2 := by
      nlinarith [mul_nonneg hκPos.le (sq_nonneg (p 1 - μ))]
    have hpShiftRadius : |p 0| ≤ radius :=
      (sq_le_sq₀ (abs_nonneg _) hradius_nonneg).1
        (by simpa [sq_abs] using hpShiftSq)
    have hpShift : |p 0| ≤ (c.operatorRadiusUpper : ℝ) :=
      hpShiftRadius.trans hradius_le
    have hpScaleWeighted : κ * (p 1 - μ) ^ 2 ≤ radius ^ 2 := by
      nlinarith [sq_nonneg (p 0)]
    have hκRadius : (c.kappaLower : ℝ) *
        (c.operatorLambdaRadiusUpper : ℝ) ^ 2 ≤
          κ * (c.operatorLambdaRadiusUpper : ℝ) ^ 2 :=
      mul_le_mul_of_nonneg_right hκLower (sq_nonneg _)
    have hpScaleWeightedUpper : κ * (p 1 - μ) ^ 2 ≤
        κ * (c.operatorLambdaRadiusUpper : ℝ) ^ 2 := by
      rw [hradiusSq] at hpScaleWeighted
      exact hpScaleWeighted.trans ((sub_le_sub_left hproductLower _).trans
        (horLower.trans hκRadius))
    have hpScaleSq : (p 1 - μ) ^ 2 ≤
        (c.operatorLambdaRadiusUpper : ℝ) ^ 2 :=
      le_of_mul_le_mul_left hpScaleWeightedUpper hκPos
    have hpScale : |p 1 - μ| ≤ (c.operatorLambdaRadiusUpper : ℝ) :=
      (sq_le_sq₀ (abs_nonneg _) holr).1 (by simpa [sq_abs] using hpScaleSq)
    rw [RankTwoSeparationBoxCertificate.candidateRectangle,
      Geometry.rankTwoCandidateRectangle]
    constructor
    · intro i
      fin_cases i
      · simp [rankTwoParameterOfRat]
        have hl : (c.lowerShift : ℝ) ≤ -(c.operatorRadiusUpper : ℝ) := by
          exact_mod_cast h.lowerShift_le_operator
        exact hl.trans (neg_le_of_abs_le hpShift)
      · simp [rankTwoParameterOfRat]
        have hl : (c.lowerScale : ℝ) ≤
            (c.muLower : ℝ) - (c.operatorLambdaRadiusUpper : ℝ) := by
          exact_mod_cast h.lowerScale_le_operator
        have hpLower : (c.muLower : ℝ) -
            (c.operatorLambdaRadiusUpper : ℝ) ≤ p 1 := by
          linarith [(abs_le.1 hpScale).1]
        exact hl.trans hpLower
    · intro i
      fin_cases i
      · simp [rankTwoParameterOfRat]
        have hu : (c.operatorRadiusUpper : ℝ) ≤ (c.upperShift : ℝ) := by
          exact_mod_cast h.operator_le_upperShift
        exact (le_of_abs_le hpShift).trans hu
      · simp [rankTwoParameterOfRat]
        have hu : (c.muUpper : ℝ) +
            (c.operatorLambdaRadiusUpper : ℝ) ≤ (c.upperScale : ℝ) := by
          exact_mod_cast h.operator_le_upperScale
        have hpUpper : p 1 ≤ (c.muUpper : ℝ) +
            (c.operatorLambdaRadiusUpper : ℝ) := by
          linarith [(abs_le.1 hpScale).2]
        exact hpUpper.trans hu


/-- `BG-CERT-THM-016`: for every real `(κ, μ)` in the checked box, the exact full
spectral and operator ellipses are strictly separated. -/
theorem disjoint_fullEllipses_of_boxCheck_eq_true
    {c : RankTwoSeparationBoxCertificate} {κ μ : ℝ}
    (hcheck : checkRankTwoSeparationBoxCertificate c = true)
    (hκLower : (c.kappaLower : ℝ) ≤ κ)
    (hκUpper : κ ≤ (c.kappaUpper : ℝ))
    (hμLower : (c.muLower : ℝ) ≤ μ)
    (hμUpper : μ ≤ (c.muUpper : ℝ)) :
    Disjoint
      (Geometry.rankTwoFullSpectralEllipse κ (c.spectralBudget : ℝ))
      (Geometry.rankTwoFullOperatorEllipse κ μ
        (Geometry.rankTwoOperatorRadius κ μ (c.operatorBudget : ℝ))) := by
  have h := valid_of_checkRankTwoSeparationBoxCertificate_eq_true hcheck
  have hκLowerPos : 0 < (c.kappaLower : ℝ) := by
    exact_mod_cast h.kappaLower_pos
  have hκPos : 0 < κ := hκLowerPos.trans_le hκLower
  have hμLowerNonneg : 0 ≤ (c.muLower : ℝ) := by
    exact_mod_cast h.muLower_nonneg
  have hμUpperLeOne : (c.muUpper : ℝ) ≤ 1 := by
    exact_mod_cast h.muUpper_le_one
  have hμNonneg : 0 ≤ μ := hμLowerNonneg.trans hμLower
  have hμLeOne : μ ≤ 1 := hμUpper.trans hμUpperLeOne
  have hμSqLower : (c.muLower : ℝ) ^ 2 ≤ μ ^ 2 :=
    (sq_le_sq₀ hμLowerNonneg hμNonneg).2 hμLower
  have hμSqUpper : μ ^ 2 ≤ (c.muUpper : ℝ) ^ 2 :=
    (sq_le_sq₀ hμNonneg (hμNonneg.trans hμUpper)).2 hμUpper
  have hfactorLower : 0 ≤ 1 - (c.muLower : ℝ) ^ 2 := by
    have hmuLowerLeOne : (c.muLower : ℝ) ≤ 1 :=
      hμLower.trans (hμUpper.trans hμUpperLeOne)
    nlinarith [sq_le_sq₀ hμLowerNonneg zero_le_one |>.2 hmuLowerLeOne]
  have hfactorUpper : 0 ≤ 1 - (c.muUpper : ℝ) ^ 2 := by
    have hmuUpperNonneg : 0 ≤ (c.muUpper : ℝ) :=
      hμLowerNonneg.trans (by exact_mod_cast h.muLower_le_muUpper)
    nlinarith [sq_le_sq₀ hmuUpperNonneg zero_le_one |>.2 hμUpperLeOne]
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast h.spectralBudget_nonneg
  have hru : 0 ≤ (c.operatorRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorRadiusUpper_nonneg
  have hradCert : (c.kappaUpper : ℝ) *
      (1 - (c.muLower : ℝ) ^ 2) ≤ (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_nonneg_at_upper_lower
  have hrad : κ * (1 - μ ^ 2) ≤ (c.operatorBudget : ℝ) ^ 2 := by
    have hfactorLe : 1 - μ ^ 2 ≤ 1 - (c.muLower : ℝ) ^ 2 := by
      linarith
    calc
      κ * (1 - μ ^ 2) ≤ κ * (1 - (c.muLower : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_left hfactorLe hκPos.le
      _ ≤ (c.kappaUpper : ℝ) * (1 - (c.muLower : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_right hκUpper hfactorLower
      _ ≤ (c.operatorBudget : ℝ) ^ 2 := hradCert
  have hproductLower : (c.kappaLower : ℝ) *
      (1 - (c.muUpper : ℝ) ^ 2) ≤ κ * (1 - μ ^ 2) := by
    have hfactorLe : 1 - (c.muUpper : ℝ) ^ 2 ≤ 1 - μ ^ 2 := by
      linarith
    calc
      (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
          κ * (1 - (c.muUpper : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_right hκLower hfactorUpper
      _ ≤ κ * (1 - μ ^ 2) :=
        mul_le_mul_of_nonneg_left hfactorLe hκPos.le
  have hradUpperCert : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_at_lower_upper_le_radiusUpper_sq
  have hradru : (c.operatorBudget : ℝ) ^ 2 - κ * (1 - μ ^ 2) ≤
      (c.operatorRadiusUpper : ℝ) ^ 2 := by
    linarith
  have hsepSq : ((c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ)) ^ 2 <
        (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ)) ^ 2 := by
    exact_mod_cast h.strict_separation_sq_at_lower_upper
  let radius := Geometry.rankTwoOperatorRadius κ μ (c.operatorBudget : ℝ)
  have hradius_nonneg : 0 ≤ radius := Real.sqrt_nonneg _
  have hradius_le : radius ≤ (c.operatorRadiusUpper : ℝ) := by
    dsimp [radius, Geometry.rankTwoOperatorRadius]
    exact (Real.sqrt_le_left hru).2 hradru
  have hgapUpperNonneg : 0 ≤ 1 - (c.muUpper : ℝ) := by linarith
  have htargetUpperSq :
      (Real.sqrt (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ))) ^ 2 =
        (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ)) ^ 2 := by
    rw [mul_pow, Real.sq_sqrt hκLowerPos.le]
  have hsum_nonneg : 0 ≤ (c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ) := add_nonneg hsb hru
  have htargetUpper_nonneg : 0 ≤ Real.sqrt (c.kappaLower : ℝ) *
      (1 - (c.muUpper : ℝ)) :=
    mul_nonneg (Real.sqrt_nonneg _) hgapUpperNonneg
  have hstrictUpper : (c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ) <
        Real.sqrt (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ)) :=
    (sq_lt_sq₀ hsum_nonneg htargetUpper_nonneg).1 (by
      rw [htargetUpperSq]
      exact hsepSq)
  have hsqrtLower : Real.sqrt (c.kappaLower : ℝ) ≤ Real.sqrt κ :=
    Real.sqrt_le_sqrt hκLower
  have hgap : 1 - (c.muUpper : ℝ) ≤ |1 - μ| := by
    rw [abs_of_nonneg (by linarith)]
    linarith
  have hbenchmark : Real.sqrt (c.kappaLower : ℝ) *
      (1 - (c.muUpper : ℝ)) ≤ Real.sqrt κ * |1 - μ| := by
    calc
      Real.sqrt (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ)) ≤
          Real.sqrt κ * (1 - (c.muUpper : ℝ)) :=
        mul_le_mul_of_nonneg_right hsqrtLower hgapUpperNonneg
      _ ≤ Real.sqrt κ * |1 - μ| :=
        mul_le_mul_of_nonneg_left hgap (Real.sqrt_nonneg _)
  have hstrictActual : (c.spectralBudget : ℝ) + radius <
      Real.sqrt κ * |1 - μ| := by
    calc
      (c.spectralBudget : ℝ) + radius ≤
          (c.spectralBudget : ℝ) + (c.operatorRadiusUpper : ℝ) :=
        add_le_add (le_refl _) hradius_le
      _ < Real.sqrt (c.kappaLower : ℝ) * (1 - (c.muUpper : ℝ)) :=
        hstrictUpper
      _ ≤ Real.sqrt κ * |1 - μ| := hbenchmark
  exact Geometry.disjoint_rankTwoFullEllipses_of_add_lt_sqrt_mul_abs_centerSeparation
    hκPos hsb hradius_nonneg hstrictActual

end ProjectKoios.BandGauge.Certificates

module

public import ProjectKoios.BandGauge.Certificates.RankTwoSeparation

/-!
# Rational-enclosure certificates for rank-two separation

This module extends the exact rational checker to an arbitrary real correlation center
known to lie in a checked rational interval. All worst-case radius, containment, and
separation tests remain exact rational comparisons. This permits algebraic centers without
trusting floating-point approximations.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Certificates

open ProjectKoios.BandGauge

/-- `BG-CERT-DEF-008`: exact rational certificate data whose conclusions hold uniformly
for every real center in `[muLower, muUpper]`. -/
structure RankTwoSeparationEnclosureCertificate where
  kappa : ℚ
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

/-- `BG-CERT-DEF-009`: exact rational validity conditions for an interval-center
certificate. Lower-center bounds prove a real operator radius; upper-center bounds control
its maximum radius and minimum separation from the spectral center. -/
structure RankTwoSeparationEnclosureCertificate.Valid
    (c : RankTwoSeparationEnclosureCertificate) : Prop where
  kappa_pos : 0 < c.kappa
  muLower_nonneg : 0 ≤ c.muLower
  muLower_le_muUpper : c.muLower ≤ c.muUpper
  muUpper_le_one : c.muUpper ≤ 1
  spectralBudget_nonneg : 0 ≤ c.spectralBudget
  operatorBudget_nonneg : 0 ≤ c.operatorBudget
  operatorRadiusUpper_nonneg : 0 ≤ c.operatorRadiusUpper
  spectralLambdaRadiusUpper_nonneg : 0 ≤ c.spectralLambdaRadiusUpper
  operatorLambdaRadiusUpper_nonneg : 0 ≤ c.operatorLambdaRadiusUpper
  operator_radicand_nonneg_at_lower :
    c.kappa * (1 - c.muLower ^ 2) ≤ c.operatorBudget ^ 2
  operator_radicand_at_upper_le_radiusUpper_sq :
    c.operatorBudget ^ 2 - c.kappa * (1 - c.muUpper ^ 2) ≤
      c.operatorRadiusUpper ^ 2
  spectral_scale_radius_bound :
    c.spectralBudget ^ 2 ≤ c.kappa * c.spectralLambdaRadiusUpper ^ 2
  operator_scale_radius_bound_at_upper :
    c.operatorBudget ^ 2 - c.kappa * (1 - c.muUpper ^ 2) ≤
      c.kappa * c.operatorLambdaRadiusUpper ^ 2
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
  witness_spectral :
    c.witnessShift ^ 2 + c.kappa * (c.witnessScale - 1) ^ 2 ≤
      c.spectralBudget ^ 2
  strict_separation_sq_at_upper :
    (c.spectralBudget + c.operatorRadiusUpper) ^ 2 <
      c.kappa * (1 - c.muUpper) ^ 2

/-- `BG-CERT-DEF-010`: decidable conjunction form of enclosure-certificate validity. -/
def rankTwoSeparationEnclosureCertificateConditions
    (c : RankTwoSeparationEnclosureCertificate) : Prop :=
  0 < c.kappa ∧
  0 ≤ c.muLower ∧
  c.muLower ≤ c.muUpper ∧
  c.muUpper ≤ 1 ∧
  0 ≤ c.spectralBudget ∧
  0 ≤ c.operatorBudget ∧
  0 ≤ c.operatorRadiusUpper ∧
  0 ≤ c.spectralLambdaRadiusUpper ∧
  0 ≤ c.operatorLambdaRadiusUpper ∧
  c.kappa * (1 - c.muLower ^ 2) ≤ c.operatorBudget ^ 2 ∧
  c.operatorBudget ^ 2 - c.kappa * (1 - c.muUpper ^ 2) ≤
    c.operatorRadiusUpper ^ 2 ∧
  c.spectralBudget ^ 2 ≤ c.kappa * c.spectralLambdaRadiusUpper ^ 2 ∧
  c.operatorBudget ^ 2 - c.kappa * (1 - c.muUpper ^ 2) ≤
    c.kappa * c.operatorLambdaRadiusUpper ^ 2 ∧
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
  c.witnessShift ^ 2 + c.kappa * (c.witnessScale - 1) ^ 2 ≤
    c.spectralBudget ^ 2 ∧
  (c.spectralBudget + c.operatorRadiusUpper) ^ 2 <
    c.kappa * (1 - c.muUpper) ^ 2

instance (c : RankTwoSeparationEnclosureCertificate) :
    Decidable (rankTwoSeparationEnclosureCertificateConditions c) := by
  unfold rankTwoSeparationEnclosureCertificateConditions
  infer_instance

/-- `BG-CERT-DEF-011`: executable exact rational enclosure-certificate checker. -/
def checkRankTwoSeparationEnclosureCertificate
    (c : RankTwoSeparationEnclosureCertificate) : Bool :=
  decide (rankTwoSeparationEnclosureCertificateConditions c)

/-- `BG-CERT-DEF-012`: candidate rectangle encoded by an enclosure certificate. -/
noncomputable def RankTwoSeparationEnclosureCertificate.candidateRectangle
    (c : RankTwoSeparationEnclosureCertificate) : Set Geometry.RankTwoParameter :=
  Geometry.rankTwoCandidateRectangle
    (rankTwoParameterOfRat c.lowerShift c.lowerScale)
    (rankTwoParameterOfRat c.upperShift c.upperScale)

/-- `BG-CERT-DEF-013`: spectral witness encoded by an enclosure certificate. -/
noncomputable def RankTwoSeparationEnclosureCertificate.spectralWitness
    (c : RankTwoSeparationEnclosureCertificate) : Geometry.RankTwoParameter :=
  rankTwoParameterOfRat c.witnessShift c.witnessScale

/-- `BG-CERT-THM-005`: successful Boolean checking recovers all exact rational enclosure
conditions. -/
theorem valid_of_checkRankTwoSeparationEnclosureCertificate_eq_true
    {c : RankTwoSeparationEnclosureCertificate}
    (hcheck : checkRankTwoSeparationEnclosureCertificate c = true) : c.Valid := by
  have hconditions : rankTwoSeparationEnclosureCertificateConditions c :=
    of_decide_eq_true hcheck
  rcases hconditions with ⟨hκ, hμl, hμlu, hμu, hsb, hob, hru, hslr, holr,
    hradl, hradu, hsr, hor, hls, hsu, hlo, hou, hlls, hsul, hllo, houl,
    hws, hwl, hLowerScale, hwitness, hsep⟩
  exact ⟨hκ, hμl, hμlu, hμu, hsb, hob, hru, hslr, holr, hradl, hradu,
    hsr, hor, hls, hsu, hlo, hou, hlls, hsul, hllo, houl, hws, hwl,
    hLowerScale, hwitness, hsep⟩

/-- `BG-CERT-THM-006`: acceptance supplies an exact positive-scale spectral witness in
both the full spectral ellipse and candidate rectangle. -/
theorem enclosureSpectralWitness_mem_of_check_eq_true
    {c : RankTwoSeparationEnclosureCertificate}
    (hcheck : checkRankTwoSeparationEnclosureCertificate c = true) :
    c.spectralWitness ∈
        Geometry.rankTwoFullSpectralEllipse (c.kappa : ℝ) (c.spectralBudget : ℝ) ∩
          c.candidateRectangle ∧
      0 < c.spectralWitness 1 := by
  have h := valid_of_checkRankTwoSeparationEnclosureCertificate_eq_true hcheck
  have hwitness :
      (c.witnessShift : ℝ) ^ 2 + (c.kappa : ℝ) *
          ((c.witnessScale : ℝ) - 1) ^ 2 ≤ (c.spectralBudget : ℝ) ^ 2 := by
    exact_mod_cast h.witness_spectral
  have hrect : c.spectralWitness ∈ c.candidateRectangle := by
    rw [RankTwoSeparationEnclosureCertificate.candidateRectangle,
      Geometry.rankTwoCandidateRectangle]
    constructor
    · intro i
      fin_cases i <;>
        simp [RankTwoSeparationEnclosureCertificate.spectralWitness,
          rankTwoParameterOfRat]
      · exact_mod_cast h.witnessShift_mem.1
      · exact_mod_cast h.witnessScale_mem.1
    · intro i
      fin_cases i <;>
        simp [RankTwoSeparationEnclosureCertificate.spectralWitness,
          rankTwoParameterOfRat]
      · exact_mod_cast h.witnessShift_mem.2
      · exact_mod_cast h.witnessScale_mem.2
  constructor
  · exact ⟨by simpa [RankTwoSeparationEnclosureCertificate.spectralWitness,
      rankTwoParameterOfRat, Geometry.rankTwoFullSpectralEllipse] using hwitness, hrect⟩
  · simp [RankTwoSeparationEnclosureCertificate.spectralWitness,
      rankTwoParameterOfRat]
    have hwitnessPos : 0 < c.witnessScale :=
      lt_of_lt_of_le h.lowerScale_pos h.witnessScale_mem.1
    exact_mod_cast hwitnessPos

/-- `BG-CERT-THM-007`: for every real center inside the checked rational interval, both
full ellipses lie in the encoded candidate rectangle. -/
theorem fullEllipses_subset_enclosureCandidateRectangle_of_check_eq_true
    {c : RankTwoSeparationEnclosureCertificate} {μ : ℝ}
    (hcheck : checkRankTwoSeparationEnclosureCertificate c = true)
    (hμLower : (c.muLower : ℝ) ≤ μ) (hμUpper : μ ≤ (c.muUpper : ℝ)) :
    Geometry.rankTwoFullSpectralEllipse (c.kappa : ℝ) (c.spectralBudget : ℝ) ⊆
        c.candidateRectangle ∧
      Geometry.rankTwoFullOperatorEllipse (c.kappa : ℝ) μ
        (Geometry.rankTwoOperatorRadius (c.kappa : ℝ) μ
          (c.operatorBudget : ℝ)) ⊆ c.candidateRectangle := by
  have h := valid_of_checkRankTwoSeparationEnclosureCertificate_eq_true hcheck
  have hκ : 0 < (c.kappa : ℝ) := by exact_mod_cast h.kappa_pos
  have hμLowerNonneg : 0 ≤ (c.muLower : ℝ) := by
    exact_mod_cast h.muLower_nonneg
  have hμUpperLeOne : (c.muUpper : ℝ) ≤ 1 := by
    exact_mod_cast h.muUpper_le_one
  have hμNonneg : 0 ≤ μ := hμLowerNonneg.trans hμLower
  have hμSqLower : (c.muLower : ℝ) ^ 2 ≤ μ ^ 2 :=
    (sq_le_sq₀ hμLowerNonneg hμNonneg).2 hμLower
  have hμSqUpper : μ ^ 2 ≤ (c.muUpper : ℝ) ^ 2 :=
    (sq_le_sq₀ hμNonneg (hμNonneg.trans hμUpper)).2 hμUpper
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast h.spectralBudget_nonneg
  have hru : 0 ≤ (c.operatorRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorRadiusUpper_nonneg
  have hslr : 0 ≤ (c.spectralLambdaRadiusUpper : ℝ) := by
    exact_mod_cast h.spectralLambdaRadiusUpper_nonneg
  have holr : 0 ≤ (c.operatorLambdaRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorLambdaRadiusUpper_nonneg
  have hradLower : (c.kappa : ℝ) * (1 - (c.muLower : ℝ) ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_nonneg_at_lower
  have hrad : (c.kappa : ℝ) * (1 - μ ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    nlinarith
  have hradUpper : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_at_upper_le_radiusUpper_sq
  have hradru : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - μ ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    nlinarith
  have hsr : (c.spectralBudget : ℝ) ^ 2 ≤
      (c.kappa : ℝ) * (c.spectralLambdaRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.spectral_scale_radius_bound
  have horUpper : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
        (c.kappa : ℝ) * (c.operatorLambdaRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_scale_radius_bound_at_upper
  have hor : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - μ ^ 2) ≤
        (c.kappa : ℝ) * (c.operatorLambdaRadiusUpper : ℝ) ^ 2 := by
    nlinarith
  constructor
  · intro p hp
    change (p 0) ^ 2 + (c.kappa : ℝ) * (p 1 - 1) ^ 2 ≤
      (c.spectralBudget : ℝ) ^ 2 at hp
    have hpShiftSq : (p 0) ^ 2 ≤ (c.spectralBudget : ℝ) ^ 2 := by
      nlinarith [mul_nonneg hκ.le (sq_nonneg (p 1 - 1))]
    have hpShift : |p 0| ≤ (c.spectralBudget : ℝ) :=
      (sq_le_sq₀ (abs_nonneg _) hsb).1 (by simpa [sq_abs] using hpShiftSq)
    have hpScaleWeighted :
        (c.kappa : ℝ) * (p 1 - 1) ^ 2 ≤ (c.spectralBudget : ℝ) ^ 2 := by
      nlinarith [sq_nonneg (p 0)]
    have hpScaleSq : (p 1 - 1) ^ 2 ≤
        (c.spectralLambdaRadiusUpper : ℝ) ^ 2 := by
      nlinarith
    have hpScale : |p 1 - 1| ≤ (c.spectralLambdaRadiusUpper : ℝ) :=
      (sq_le_sq₀ (abs_nonneg _) hslr).1 (by simpa [sq_abs] using hpScaleSq)
    rw [RankTwoSeparationEnclosureCertificate.candidateRectangle,
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
    let radius := Geometry.rankTwoOperatorRadius
      (c.kappa : ℝ) μ (c.operatorBudget : ℝ)
    change (p 0) ^ 2 + (c.kappa : ℝ) * (p 1 - μ) ^ 2 ≤ radius ^ 2 at hp
    have hradius_nonneg : 0 ≤ radius := Real.sqrt_nonneg _
    have hradiusSq : radius ^ 2 =
        (c.operatorBudget : ℝ) ^ 2 - (c.kappa : ℝ) * (1 - μ ^ 2) :=
      Geometry.rankTwoOperatorRadius_sq hrad
    have hradius_le : radius ≤ (c.operatorRadiusUpper : ℝ) := by
      dsimp [radius, Geometry.rankTwoOperatorRadius]
      exact (Real.sqrt_le_left hru).2 hradru
    have hpShiftSq : (p 0) ^ 2 ≤ radius ^ 2 := by
      nlinarith [mul_nonneg hκ.le (sq_nonneg (p 1 - μ))]
    have hpShiftRadius : |p 0| ≤ radius :=
      (sq_le_sq₀ (abs_nonneg _) hradius_nonneg).1
        (by simpa [sq_abs] using hpShiftSq)
    have hpShift : |p 0| ≤ (c.operatorRadiusUpper : ℝ) :=
      hpShiftRadius.trans hradius_le
    have hpScaleWeighted : (c.kappa : ℝ) * (p 1 - μ) ^ 2 ≤ radius ^ 2 := by
      nlinarith [sq_nonneg (p 0)]
    have hpScaleSq : (p 1 - μ) ^ 2 ≤
        (c.operatorLambdaRadiusUpper : ℝ) ^ 2 := by
      rw [hradiusSq] at hpScaleWeighted
      nlinarith
    have hpScale : |p 1 - μ| ≤ (c.operatorLambdaRadiusUpper : ℝ) :=
      (sq_le_sq₀ (abs_nonneg _) holr).1 (by simpa [sq_abs] using hpScaleSq)
    rw [RankTwoSeparationEnclosureCertificate.candidateRectangle,
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

/-- `BG-CERT-THM-008`: for every real center in the checked rational interval, the exact
full spectral and operator ellipses are strictly separated. -/
theorem disjoint_fullEllipses_of_enclosureCheck_eq_true
    {c : RankTwoSeparationEnclosureCertificate} {μ : ℝ}
    (hcheck : checkRankTwoSeparationEnclosureCertificate c = true)
    (hμLower : (c.muLower : ℝ) ≤ μ) (hμUpper : μ ≤ (c.muUpper : ℝ)) :
    Disjoint
      (Geometry.rankTwoFullSpectralEllipse (c.kappa : ℝ)
        (c.spectralBudget : ℝ))
      (Geometry.rankTwoFullOperatorEllipse (c.kappa : ℝ) μ
        (Geometry.rankTwoOperatorRadius (c.kappa : ℝ) μ
          (c.operatorBudget : ℝ))) := by
  have h := valid_of_checkRankTwoSeparationEnclosureCertificate_eq_true hcheck
  have hκ : 0 < (c.kappa : ℝ) := by exact_mod_cast h.kappa_pos
  have hμLowerNonneg : 0 ≤ (c.muLower : ℝ) := by
    exact_mod_cast h.muLower_nonneg
  have hμUpperLeOne : (c.muUpper : ℝ) ≤ 1 := by
    exact_mod_cast h.muUpper_le_one
  have hμNonneg : 0 ≤ μ := hμLowerNonneg.trans hμLower
  have hμSqLower : (c.muLower : ℝ) ^ 2 ≤ μ ^ 2 :=
    (sq_le_sq₀ hμLowerNonneg hμNonneg).2 hμLower
  have hμSqUpper : μ ^ 2 ≤ (c.muUpper : ℝ) ^ 2 :=
    (sq_le_sq₀ hμNonneg (hμNonneg.trans hμUpper)).2 hμUpper
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast h.spectralBudget_nonneg
  have hru : 0 ≤ (c.operatorRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorRadiusUpper_nonneg
  have hradLower : (c.kappa : ℝ) * (1 - (c.muLower : ℝ) ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_nonneg_at_lower
  have hrad : (c.kappa : ℝ) * (1 - μ ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    nlinarith
  have hradUpper : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - (c.muUpper : ℝ) ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_at_upper_le_radiusUpper_sq
  have hradru : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - μ ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    nlinarith
  have hsepSq : ((c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ)) ^ 2 <
        (c.kappa : ℝ) * (1 - (c.muUpper : ℝ)) ^ 2 := by
    exact_mod_cast h.strict_separation_sq_at_upper
  let radius := Geometry.rankTwoOperatorRadius
    (c.kappa : ℝ) μ (c.operatorBudget : ℝ)
  have hradius_nonneg : 0 ≤ radius := Real.sqrt_nonneg _
  have hradius_le : radius ≤ (c.operatorRadiusUpper : ℝ) := by
    dsimp [radius, Geometry.rankTwoOperatorRadius]
    exact (Real.sqrt_le_left hru).2 hradru
  have hgapUpperNonneg : 0 ≤ 1 - (c.muUpper : ℝ) := by linarith
  have htargetUpperSq :
      (Real.sqrt (c.kappa : ℝ) * (1 - (c.muUpper : ℝ))) ^ 2 =
        (c.kappa : ℝ) * (1 - (c.muUpper : ℝ)) ^ 2 := by
    rw [mul_pow, Real.sq_sqrt hκ.le]
  have hsum_nonneg : 0 ≤ (c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ) := add_nonneg hsb hru
  have htargetUpper_nonneg : 0 ≤ Real.sqrt (c.kappa : ℝ) *
      (1 - (c.muUpper : ℝ)) :=
    mul_nonneg (Real.sqrt_nonneg _) hgapUpperNonneg
  have hstrictUpper : (c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ) <
        Real.sqrt (c.kappa : ℝ) * (1 - (c.muUpper : ℝ)) :=
    (sq_lt_sq₀ hsum_nonneg htargetUpper_nonneg).1 (by
      rw [htargetUpperSq]
      exact hsepSq)
  have hgap : 1 - (c.muUpper : ℝ) ≤ |1 - μ| := by
    rw [abs_of_nonneg (by linarith)]
    linarith
  have hstrictActual : (c.spectralBudget : ℝ) + radius <
      Real.sqrt (c.kappa : ℝ) * |1 - μ| := by
    calc
      (c.spectralBudget : ℝ) + radius ≤
          (c.spectralBudget : ℝ) + (c.operatorRadiusUpper : ℝ) :=
        add_le_add (le_refl _) hradius_le
      _ < Real.sqrt (c.kappa : ℝ) * (1 - (c.muUpper : ℝ)) := hstrictUpper
      _ ≤ Real.sqrt (c.kappa : ℝ) * |1 - μ| :=
        mul_le_mul_of_nonneg_left hgap (Real.sqrt_nonneg _)
  exact Geometry.disjoint_rankTwoFullEllipses_of_add_lt_sqrt_mul_abs_centerSeparation
    hκ hsb hradius_nonneg hstrictActual

/-- `BG-CERT-THM-009`: exact rational enclosure of the Paper A algebraic center
`1 / √2`; no floating-point approximation is used. -/
theorem sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths :
    (7 : ℝ) / 10 < 1 / Real.sqrt 2 ∧
      1 / Real.sqrt 2 < (71 : ℝ) / 100 := by
  have hsqrtPos : 0 < Real.sqrt (2 : ℝ) := Real.sqrt_pos.2 (by norm_num)
  have hsqrtSq : Real.sqrt (2 : ℝ) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  constructor
  · rw [div_lt_div_iff₀ (by norm_num : (0 : ℝ) < 10) hsqrtPos]
    apply (sq_lt_sq₀ (mul_nonneg (by norm_num) hsqrtPos.le) (by norm_num)).1
    rw [mul_pow, hsqrtSq]
    norm_num
  · rw [div_lt_div_iff₀ hsqrtPos (by norm_num : (0 : ℝ) < 100)]
    apply (sq_lt_sq₀ (by norm_num) (mul_nonneg (by norm_num) hsqrtPos.le)).1
    simp only [mul_pow]
    rw [hsqrtSq]
    norm_num

end ProjectKoios.BandGauge.Certificates

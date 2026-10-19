module

public import ProjectKoios.BandGauge.Geometry.RankTwoLoss

/-!
# Exact rational certificates for rank-two separation

This module defines a narrow, decidable rational certificate for the scalar rank-two
ellipse geometry. Acceptance proves exact real inequalities after rational coercion and
requires a strictly positive lower scale for the whole candidate rectangle. It does not
bind the scalars to publication matrices, parse runtime output, or validate a
scientific model.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Certificates

open ProjectKoios.BandGauge

/-- `BG-CERT-DEF-001`: exact rational data sufficient to certify one spectral witness,
full-ellipse containment in a rectangle, and strict spectral/operator separation. -/
structure RankTwoSeparationCertificate where
  kappa : ℚ
  mu : ℚ
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

/-- `BG-CERT-DEF-002`: the decidable exact rational predicate checked by the certificate
boundary. Its radius bounds avoid trusting floating-point square roots. -/
structure RankTwoSeparationCertificate.Valid
    (c : RankTwoSeparationCertificate) : Prop where
  kappa_pos : 0 < c.kappa
  mu_abs_le_one : |c.mu| ≤ 1
  spectralBudget_nonneg : 0 ≤ c.spectralBudget
  operatorBudget_nonneg : 0 ≤ c.operatorBudget
  operatorRadiusUpper_nonneg : 0 ≤ c.operatorRadiusUpper
  spectralLambdaRadiusUpper_nonneg : 0 ≤ c.spectralLambdaRadiusUpper
  operatorLambdaRadiusUpper_nonneg : 0 ≤ c.operatorLambdaRadiusUpper
  operator_radicand_nonneg :
    c.kappa * (1 - c.mu ^ 2) ≤ c.operatorBudget ^ 2
  operator_radicand_le_radiusUpper_sq :
    c.operatorBudget ^ 2 - c.kappa * (1 - c.mu ^ 2) ≤
      c.operatorRadiusUpper ^ 2
  spectral_scale_radius_bound :
    c.spectralBudget ^ 2 ≤ c.kappa * c.spectralLambdaRadiusUpper ^ 2
  operator_scale_radius_bound :
    c.operatorBudget ^ 2 - c.kappa * (1 - c.mu ^ 2) ≤
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
    c.lowerScale ≤ c.mu - c.operatorLambdaRadiusUpper
  operator_le_upperScale :
    c.mu + c.operatorLambdaRadiusUpper ≤ c.upperScale
  witnessShift_mem :
    c.lowerShift ≤ c.witnessShift ∧ c.witnessShift ≤ c.upperShift
  witnessScale_mem :
    c.lowerScale ≤ c.witnessScale ∧ c.witnessScale ≤ c.upperScale
  lowerScale_pos : 0 < c.lowerScale
  witness_spectral :
    c.witnessShift ^ 2 + c.kappa * (c.witnessScale - 1) ^ 2 ≤
      c.spectralBudget ^ 2
  strict_separation_sq :
    (c.spectralBudget + c.operatorRadiusUpper) ^ 2 <
      c.kappa * (1 - c.mu) ^ 2

/-- `BG-CERT-DEF-003`: conjunction form used by the executable checker. -/
def rankTwoSeparationCertificateConditions
    (c : RankTwoSeparationCertificate) : Prop :=
  0 < c.kappa ∧
  |c.mu| ≤ 1 ∧
  0 ≤ c.spectralBudget ∧
  0 ≤ c.operatorBudget ∧
  0 ≤ c.operatorRadiusUpper ∧
  0 ≤ c.spectralLambdaRadiusUpper ∧
  0 ≤ c.operatorLambdaRadiusUpper ∧
  c.kappa * (1 - c.mu ^ 2) ≤ c.operatorBudget ^ 2 ∧
  c.operatorBudget ^ 2 - c.kappa * (1 - c.mu ^ 2) ≤
    c.operatorRadiusUpper ^ 2 ∧
  c.spectralBudget ^ 2 ≤ c.kappa * c.spectralLambdaRadiusUpper ^ 2 ∧
  c.operatorBudget ^ 2 - c.kappa * (1 - c.mu ^ 2) ≤
    c.kappa * c.operatorLambdaRadiusUpper ^ 2 ∧
  c.lowerShift ≤ -c.spectralBudget ∧
  c.spectralBudget ≤ c.upperShift ∧
  c.lowerShift ≤ -c.operatorRadiusUpper ∧
  c.operatorRadiusUpper ≤ c.upperShift ∧
  c.lowerScale ≤ 1 - c.spectralLambdaRadiusUpper ∧
  1 + c.spectralLambdaRadiusUpper ≤ c.upperScale ∧
  c.lowerScale ≤ c.mu - c.operatorLambdaRadiusUpper ∧
  c.mu + c.operatorLambdaRadiusUpper ≤ c.upperScale ∧
  (c.lowerShift ≤ c.witnessShift ∧ c.witnessShift ≤ c.upperShift) ∧
  (c.lowerScale ≤ c.witnessScale ∧ c.witnessScale ≤ c.upperScale) ∧
  0 < c.lowerScale ∧
  c.witnessShift ^ 2 + c.kappa * (c.witnessScale - 1) ^ 2 ≤
    c.spectralBudget ^ 2 ∧
  (c.spectralBudget + c.operatorRadiusUpper) ^ 2 <
    c.kappa * (1 - c.mu) ^ 2

instance (c : RankTwoSeparationCertificate) :
    Decidable (rankTwoSeparationCertificateConditions c) := by
  unfold rankTwoSeparationCertificateConditions
  infer_instance

/-- `BG-CERT-DEF-004`: executable exact certificate check. -/
def checkRankTwoSeparationCertificate (c : RankTwoSeparationCertificate) : Bool :=
  decide (rankTwoSeparationCertificateConditions c)

/-- `BG-CERT-THM-001`: successful Boolean checking recovers the exact rational validity
predicate. -/
theorem valid_of_checkRankTwoSeparationCertificate_eq_true
    {c : RankTwoSeparationCertificate}
    (hcheck : checkRankTwoSeparationCertificate c = true) : c.Valid := by
  have hconditions : rankTwoSeparationCertificateConditions c :=
    of_decide_eq_true hcheck
  rcases hconditions with ⟨hκ, hμ, hsb, hob, hru, hslr, holr, hrad, hradru,
    hsr, hor, hls, hsu, hlo, hou, hlls, hsul, hllo, houl, hws, hwl,
    hLowerScale, hwitness, hsep⟩
  exact ⟨hκ, hμ, hsb, hob, hru, hslr, holr, hrad, hradru, hsr, hor,
    hls, hsu, hlo, hou, hlls, hsul, hllo, houl, hws, hwl, hLowerScale,
    hwitness, hsep⟩

/-- `BG-CERT-DEF-005`: a rational coordinate pair embedded in the real Euclidean
rank-two parameter plane. -/
noncomputable def rankTwoParameterOfRat (shift scale : ℚ) :
    Geometry.RankTwoParameter :=
  WithLp.toLp 2 ![(shift : ℝ), (scale : ℝ)]

/-- `BG-CERT-DEF-006`: the exact real candidate rectangle encoded by a certificate. -/
noncomputable def RankTwoSeparationCertificate.candidateRectangle
    (c : RankTwoSeparationCertificate) : Set Geometry.RankTwoParameter :=
  Geometry.rankTwoCandidateRectangle
    (rankTwoParameterOfRat c.lowerShift c.lowerScale)
    (rankTwoParameterOfRat c.upperShift c.upperScale)

/-- `BG-CERT-DEF-007`: the exact real spectral witness encoded by a certificate. -/
noncomputable def RankTwoSeparationCertificate.spectralWitness
    (c : RankTwoSeparationCertificate) : Geometry.RankTwoParameter :=
  rankTwoParameterOfRat c.witnessShift c.witnessScale

/-- `BG-CERT-THM-002`: an accepted certificate supplies an exact positive-scale spectral
witness inside both the full spectral ellipse and the declared candidate rectangle. -/
theorem spectralWitness_mem_of_check_eq_true
    {c : RankTwoSeparationCertificate}
    (hcheck : checkRankTwoSeparationCertificate c = true) :
    c.spectralWitness ∈
        Geometry.rankTwoFullSpectralEllipse (c.kappa : ℝ) (c.spectralBudget : ℝ) ∩
          c.candidateRectangle ∧
      0 < c.spectralWitness 1 := by
  have h := valid_of_checkRankTwoSeparationCertificate_eq_true hcheck
  have hwitness :
      (c.witnessShift : ℝ) ^ 2 + (c.kappa : ℝ) *
          ((c.witnessScale : ℝ) - 1) ^ 2 ≤ (c.spectralBudget : ℝ) ^ 2 := by
    exact_mod_cast h.witness_spectral
  have hrect : c.spectralWitness ∈ c.candidateRectangle := by
    rw [RankTwoSeparationCertificate.candidateRectangle,
      Geometry.rankTwoCandidateRectangle]
    constructor
    · intro i
      fin_cases i <;>
        simp [RankTwoSeparationCertificate.spectralWitness, rankTwoParameterOfRat]
      · exact_mod_cast h.witnessShift_mem.1
      · exact_mod_cast h.witnessScale_mem.1
    · intro i
      fin_cases i <;>
        simp [RankTwoSeparationCertificate.spectralWitness, rankTwoParameterOfRat]
      · exact_mod_cast h.witnessShift_mem.2
      · exact_mod_cast h.witnessScale_mem.2
  constructor
  · exact ⟨by simpa [RankTwoSeparationCertificate.spectralWitness,
      rankTwoParameterOfRat, Geometry.rankTwoFullSpectralEllipse] using hwitness, hrect⟩
  · simp [RankTwoSeparationCertificate.spectralWitness, rankTwoParameterOfRat]
    have hwitnessPos : 0 < c.witnessScale :=
      lt_of_lt_of_le h.lowerScale_pos h.witnessScale_mem.1
    exact_mod_cast hwitnessPos

/-- `BG-CERT-THM-003`: an accepted certificate proves exact containment of both full
ellipses in its declared candidate rectangle. -/
theorem fullEllipses_subset_candidateRectangle_of_check_eq_true
    {c : RankTwoSeparationCertificate}
    (hcheck : checkRankTwoSeparationCertificate c = true) :
    Geometry.rankTwoFullSpectralEllipse (c.kappa : ℝ) (c.spectralBudget : ℝ) ⊆
        c.candidateRectangle ∧
      Geometry.rankTwoFullOperatorEllipse (c.kappa : ℝ) (c.mu : ℝ)
        (Geometry.rankTwoOperatorRadius (c.kappa : ℝ) (c.mu : ℝ)
          (c.operatorBudget : ℝ)) ⊆ c.candidateRectangle := by
  have h := valid_of_checkRankTwoSeparationCertificate_eq_true hcheck
  have hκ : 0 < (c.kappa : ℝ) := by exact_mod_cast h.kappa_pos
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast h.spectralBudget_nonneg
  have hru : 0 ≤ (c.operatorRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorRadiusUpper_nonneg
  have hslr : 0 ≤ (c.spectralLambdaRadiusUpper : ℝ) := by
    exact_mod_cast h.spectralLambdaRadiusUpper_nonneg
  have holr : 0 ≤ (c.operatorLambdaRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorLambdaRadiusUpper_nonneg
  have hrad : (c.kappa : ℝ) * (1 - (c.mu : ℝ) ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_nonneg
  have hradru : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - (c.mu : ℝ) ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_le_radiusUpper_sq
  have hsr : (c.spectralBudget : ℝ) ^ 2 ≤
      (c.kappa : ℝ) * (c.spectralLambdaRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.spectral_scale_radius_bound
  have hor : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - (c.mu : ℝ) ^ 2) ≤
        (c.kappa : ℝ) * (c.operatorLambdaRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_scale_radius_bound
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
    rw [RankTwoSeparationCertificate.candidateRectangle,
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
      (c.kappa : ℝ) (c.mu : ℝ) (c.operatorBudget : ℝ)
    change (p 0) ^ 2 + (c.kappa : ℝ) * (p 1 - (c.mu : ℝ)) ^ 2 ≤
      radius ^ 2 at hp
    have hradius_nonneg : 0 ≤ radius := Real.sqrt_nonneg _
    have hradiusSq : radius ^ 2 =
        (c.operatorBudget : ℝ) ^ 2 -
          (c.kappa : ℝ) * (1 - (c.mu : ℝ) ^ 2) :=
      Geometry.rankTwoOperatorRadius_sq hrad
    have hradius_le : radius ≤ (c.operatorRadiusUpper : ℝ) := by
      dsimp [radius, Geometry.rankTwoOperatorRadius]
      exact (Real.sqrt_le_left hru).2 hradru
    have hpShiftSq : (p 0) ^ 2 ≤ radius ^ 2 := by
      nlinarith [mul_nonneg hκ.le (sq_nonneg (p 1 - (c.mu : ℝ)))]
    have hpShiftRadius : |p 0| ≤ radius :=
      (sq_le_sq₀ (abs_nonneg _) hradius_nonneg).1
        (by simpa [sq_abs] using hpShiftSq)
    have hpShift : |p 0| ≤ (c.operatorRadiusUpper : ℝ) :=
      hpShiftRadius.trans hradius_le
    have hpScaleWeighted : (c.kappa : ℝ) *
        (p 1 - (c.mu : ℝ)) ^ 2 ≤ radius ^ 2 := by
      nlinarith [sq_nonneg (p 0)]
    have hpScaleSq : (p 1 - (c.mu : ℝ)) ^ 2 ≤
        (c.operatorLambdaRadiusUpper : ℝ) ^ 2 := by
      rw [hradiusSq] at hpScaleWeighted
      nlinarith
    have hpScale : |p 1 - (c.mu : ℝ)| ≤
        (c.operatorLambdaRadiusUpper : ℝ) :=
      (sq_le_sq₀ (abs_nonneg _) holr).1 (by simpa [sq_abs] using hpScaleSq)
    rw [RankTwoSeparationCertificate.candidateRectangle,
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
            (c.mu : ℝ) - (c.operatorLambdaRadiusUpper : ℝ) := by
          exact_mod_cast h.lowerScale_le_operator
        have hpLower : (c.mu : ℝ) -
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
        have hu : (c.mu : ℝ) + (c.operatorLambdaRadiusUpper : ℝ) ≤
            (c.upperScale : ℝ) := by
          exact_mod_cast h.operator_le_upperScale
        have hpUpper : p 1 ≤
            (c.mu : ℝ) + (c.operatorLambdaRadiusUpper : ℝ) := by
          linarith [(abs_le.1 hpScale).2]
        exact hpUpper.trans hu

/-- `BG-CERT-THM-004`: the squared rational separation check proves strict separation
and hence disjointness of the two exact full real ellipses. -/
theorem disjoint_fullEllipses_of_check_eq_true
    {c : RankTwoSeparationCertificate}
    (hcheck : checkRankTwoSeparationCertificate c = true) :
    Disjoint
      (Geometry.rankTwoFullSpectralEllipse (c.kappa : ℝ)
        (c.spectralBudget : ℝ))
      (Geometry.rankTwoFullOperatorEllipse (c.kappa : ℝ) (c.mu : ℝ)
        (Geometry.rankTwoOperatorRadius (c.kappa : ℝ) (c.mu : ℝ)
          (c.operatorBudget : ℝ))) := by
  have h := valid_of_checkRankTwoSeparationCertificate_eq_true hcheck
  have hκ : 0 < (c.kappa : ℝ) := by exact_mod_cast h.kappa_pos
  have hsb : 0 ≤ (c.spectralBudget : ℝ) := by
    exact_mod_cast h.spectralBudget_nonneg
  have hru : 0 ≤ (c.operatorRadiusUpper : ℝ) := by
    exact_mod_cast h.operatorRadiusUpper_nonneg
  have hrad : (c.kappa : ℝ) * (1 - (c.mu : ℝ) ^ 2) ≤
      (c.operatorBudget : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_nonneg
  have hradru : (c.operatorBudget : ℝ) ^ 2 -
      (c.kappa : ℝ) * (1 - (c.mu : ℝ) ^ 2) ≤
        (c.operatorRadiusUpper : ℝ) ^ 2 := by
    exact_mod_cast h.operator_radicand_le_radiusUpper_sq
  have hsepSq : ((c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ)) ^ 2 <
        (c.kappa : ℝ) * (1 - (c.mu : ℝ)) ^ 2 := by
    exact_mod_cast h.strict_separation_sq
  let radius := Geometry.rankTwoOperatorRadius
    (c.kappa : ℝ) (c.mu : ℝ) (c.operatorBudget : ℝ)
  have hradius_nonneg : 0 ≤ radius := Real.sqrt_nonneg _
  have hradius_le : radius ≤ (c.operatorRadiusUpper : ℝ) := by
    dsimp [radius, Geometry.rankTwoOperatorRadius]
    exact (Real.sqrt_le_left hru).2 hradru
  have htargetSq :
      (Real.sqrt (c.kappa : ℝ) * |1 - (c.mu : ℝ)|) ^ 2 =
        (c.kappa : ℝ) * (1 - (c.mu : ℝ)) ^ 2 := by
    rw [mul_pow, Real.sq_sqrt hκ.le, sq_abs]
  have hsum_nonneg : 0 ≤ (c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ) := add_nonneg hsb hru
  have htarget_nonneg : 0 ≤ Real.sqrt (c.kappa : ℝ) * |1 - (c.mu : ℝ)| :=
    mul_nonneg (Real.sqrt_nonneg _) (abs_nonneg _)
  have hstrictUpper : (c.spectralBudget : ℝ) +
      (c.operatorRadiusUpper : ℝ) <
        Real.sqrt (c.kappa : ℝ) * |1 - (c.mu : ℝ)| :=
    (sq_lt_sq₀ hsum_nonneg htarget_nonneg).1 (by
      rw [htargetSq]
      exact hsepSq)
  apply Geometry.disjoint_rankTwoFullEllipses_of_add_lt_sqrt_mul_abs_centerSeparation
    hκ hsb hradius_nonneg
  have hsum_le : (c.spectralBudget : ℝ) + radius ≤
      (c.spectralBudget : ℝ) + (c.operatorRadiusUpper : ℝ) :=
    add_le_add (le_refl _) hradius_le
  exact lt_of_le_of_lt hsum_le hstrictUpper

end ProjectKoios.BandGauge.Certificates

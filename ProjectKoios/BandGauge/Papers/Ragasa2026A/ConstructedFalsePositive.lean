/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-19
-/
module

public import ProjectKoios.BandGauge.Papers.Ragasa2026A.CertificateBridge

open scoped BigOperators ComplexConjugate Matrix
open Finset

/-!
# Ragasa2026A constructed equal-weight false positive

This module binds the exact two-observation construction in Ragasa2026A v3,
`manuscript.tex:851-889`, to the canonical rank-two fields and exact enclosure checker.
The two observations have a-priori uniform weight `1/2`, normalized reference energy one,
parent splitting matrix `σ_z`, and comparison rotations `R(0)` and `R(π/4)`.

The checked conclusion is an exact analytic counterexample: the spectral loss vanishes at
`(s, λ) = (0, 1)` while the declared spectral and optimized-operator pass sets are
disjoint in the source rectangle for budgets `0.05` and `0.72`. The source's exact
positive Euclidean separation and separation-resolution corollary are also proved. These
results are not a calculated outcome for the four-state parent, a runtime-parser result,
material validation, or a continuum claim.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Papers.Ragasa2026A

open ProjectKoios.BandGauge

private lemma rankTwoMatrixOfOperator_toEuclideanLin
    (A : Matrix (Fin 2) (Fin 2) ℂ) :
    Bloch.rankTwoMatrixOfOperator A.toEuclideanLin.toContinuousLinearMap = A := by
  ext i j
  simp [Bloch.rankTwoMatrixOfOperator, Matrix.toEuclideanLin,
    EuclideanSpace.inner_eq_star_dotProduct, Matrix.toLin'_apply]

/-- `BG-RAGASA2026A-DEF-022`: the exact normalized two-observation field contract from
the source's constructed false positive. The construction uses two distinct finite sample
indices with equal weights, constant centered parent `σ_z`, and comparison rotations
`R(0)` and `R(π/4)`. -/
noncomputable def constructedFalsePositiveData :
    RankTwoFieldContract Unit (Fin 2) (Fin 2) where
  periodic := {
    sewing := {
      transport := fun _ _ => LinearIsometryEquiv.refl ℂ Bloch.RetainedFiber
      transport_one := by intros; rfl
      transport_mul := by intros; rfl }
    hamiltonian := fun _ =>
      (Foundations.rankTwoPauliMatrix 0 0 1).toEuclideanLin.toContinuousLinearMap
    hamiltonian_covariant := by
      intro g k v
      rfl
    hamiltonian_hermitian := by
      intro k
      rw [rankTwoMatrixOfOperator_toEuclideanLin]
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp [Foundations.rankTwoPauliMatrix]
    samplePoint := fun i => i
    weight := fun _ => 1 / 2
    weight_nonneg := by intro; norm_num
    weight_sum_one := by norm_num
    energyRef := 1
    energyRef_pos := by norm_num }
  weight_pos := by intro; norm_num
  comparisonAlignment := fun i =>
    if i = 0 then Foundations.rankTwoRealRotation 0
    else Foundations.rankTwoRealRotation (Real.pi / 4)

private lemma constructedFalsePositiveSampledCenteredField (i : Fin 2) :
    Bloch.sampledCenteredField constructedFalsePositiveData.periodic i =
      Foundations.rankTwoPauliMatrix 0 0 1 := by
  rw [Bloch.sampledCenteredField, Bloch.centeredBlochMatrix]
  simp only [constructedFalsePositiveData]
  rw [rankTwoMatrixOfOperator_toEuclideanLin]
  simp [Foundations.rankTwoPauliMatrix, Matrix.trace, Fin.sum_univ_two]

private noncomputable def constructedFalsePositivePauli :
    RankTwoPauliDecomposition constructedFalsePositiveData where
  parentX := fun _ => 0
  parentY := fun _ => 0
  parentZ := fun _ => 1
  comparisonX := fun i => if i = 0 then 0 else -1
  comparisonY := fun _ => 0
  comparisonZ := fun i => if i = 0 then 1 else 0
  parent_eq := by
    intro i
    exact constructedFalsePositiveSampledCenteredField i
  comparison_eq := by
    intro i
    fin_cases i
    · simp only [comparisonSplittingField, Bloch.unitaryConjugateRankTwoField]
      rw [constructedFalsePositiveSampledCenteredField]
      simp [constructedFalsePositiveData]
      simpa using
        Foundations.rankTwoRealRotation_conjTranspose_mul_pauli_mul 0 0 0 1
    · simp only [comparisonSplittingField, Bloch.unitaryConjugateRankTwoField]
      rw [constructedFalsePositiveSampledCenteredField]
      simp [constructedFalsePositiveData]
      rw [Foundations.rankTwoRealRotation_conjTranspose_mul_pauli_mul]
      rw [show 2 * (Real.pi / 4) = Real.pi / 2 by ring]
      simp

private lemma constructedFalsePositivePower :
    Hilbert.rankTwoWeightedFrobeniusSq
      constructedFalsePositiveData.periodic.weight constructedFalsePositiveData.periodic.energyRef
      (Bloch.sampledCenteredField constructedFalsePositiveData.periodic) = 1 := by
  have hfield : Bloch.sampledCenteredField constructedFalsePositiveData.periodic =
      fun _ => Foundations.rankTwoPauliMatrix 0 0 1 := by
    funext i
    exact constructedFalsePositiveSampledCenteredField i
  rw [hfield, Hilbert.rankTwoWeightedFrobeniusSq]
  simp only [Fintype.sum_prod_type]
  norm_num [constructedFalsePositiveData, Hilbert.rankTwoFrobeniusCoefficient,
    Foundations.rankTwoPauliMatrix, Fin.sum_univ_two]

/-- `BG-RAGASA2026A-THM-029`: the two source observations have exact a-priori uniform
weight `1/2`, and their normalized centered-parent Frobenius power is exactly one. -/
theorem constructedFalsePositive_uniformWeight_and_power :
    (∀ i, constructedFalsePositiveData.periodic.weight i = (1 : ℝ) / 2) ∧
      Hilbert.rankTwoWeightedFrobeniusSq
        constructedFalsePositiveData.periodic.weight
        constructedFalsePositiveData.periodic.energyRef
        (Bloch.sampledCenteredField constructedFalsePositiveData.periodic) = 1 := by
  constructor
  · intro i
    rfl
  · exact constructedFalsePositivePower

private lemma canonicalParentX (i : Fin 2) :
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData).parentX i = 0 := by
  change Foundations.rankTwoPauliX
    (Bloch.sampledCenteredField constructedFalsePositiveData.periodic i) = 0
  rw [constructedFalsePositiveSampledCenteredField]
  simp [Foundations.rankTwoPauliX, Foundations.rankTwoPauliMatrix]

private lemma canonicalParentY (i : Fin 2) :
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData).parentY i = 0 := by
  change Foundations.rankTwoPauliY
    (Bloch.sampledCenteredField constructedFalsePositiveData.periodic i) = 0
  rw [constructedFalsePositiveSampledCenteredField]
  simp [Foundations.rankTwoPauliY, Foundations.rankTwoPauliMatrix]

private lemma canonicalParentZ (i : Fin 2) :
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData).parentZ i = 1 := by
  change Foundations.rankTwoPauliZ
    (Bloch.sampledCenteredField constructedFalsePositiveData.periodic i) = 1
  rw [constructedFalsePositiveSampledCenteredField]
  simp [Foundations.rankTwoPauliZ, Foundations.rankTwoPauliMatrix]

private lemma canonicalComparisonX (i : Fin 2) :
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData).comparisonX i =
      if i = 0 then 0 else -1 := by
  change Foundations.rankTwoPauliX (comparisonSplittingField constructedFalsePositiveData i) = _
  rw [constructedFalsePositivePauli.comparison_eq i]
  simp [constructedFalsePositivePauli, Foundations.rankTwoPauliX,
    Foundations.rankTwoPauliMatrix]

private lemma canonicalComparisonY (i : Fin 2) :
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData).comparisonY i = 0 := by
  change Foundations.rankTwoPauliY (comparisonSplittingField constructedFalsePositiveData i) = 0
  rw [constructedFalsePositivePauli.comparison_eq i]
  simp [constructedFalsePositivePauli, Foundations.rankTwoPauliY,
    Foundations.rankTwoPauliMatrix]

private lemma canonicalComparisonZ (i : Fin 2) :
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData).comparisonZ i =
      if i = 0 then 1 else 0 := by
  change Foundations.rankTwoPauliZ (comparisonSplittingField constructedFalsePositiveData i) = _
  rw [constructedFalsePositivePauli.comparison_eq i]
  simp [constructedFalsePositivePauli, Foundations.rankTwoPauliZ,
    Foundations.rankTwoPauliMatrix]

private lemma constructedFalsePositiveCanonicalB0 : correlationHarmonicB0
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData) = 0 := by
  simp [correlationHarmonicB0, canonicalParentY, canonicalComparisonY]

private lemma constructedFalsePositiveCanonicalC : correlationHarmonicC
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData) = 1 / 2 := by
  rw [correlationHarmonicC, Fin.sum_univ_two]
  rw [canonicalParentX, canonicalParentZ, canonicalComparisonX,
    canonicalComparisonZ, canonicalParentX, canonicalParentZ,
    canonicalComparisonX, canonicalComparisonZ]
  norm_num [constructedFalsePositiveData]

private lemma constructedFalsePositiveCanonicalD : correlationHarmonicD
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData) = 1 / 2 := by
  rw [correlationHarmonicD, Fin.sum_univ_two]
  rw [canonicalParentX, canonicalParentZ, canonicalComparisonX,
    canonicalComparisonZ, canonicalParentX, canonicalParentZ,
    canonicalComparisonX, canonicalComparisonZ]
  norm_num [constructedFalsePositiveData]

/-- `BG-RAGASA2026A-THM-030`: the exact continuously maximized normalized correlation
of the constructed equal-weight field is `1 / √2`. -/
theorem constructedFalsePositive_maximumNormalizedCorrelation : maximumNormalizedOperatorCorrelation
    (canonicalRankTwoPauliDecomposition constructedFalsePositiveData) 1 =
      1 / Real.sqrt 2 := by
  rw [maximumNormalizedOperatorCorrelation, maximumOperatorCorrelation,
    constructedFalsePositiveCanonicalB0, constructedFalsePositiveCanonicalC,
    constructedFalsePositiveCanonicalD]
  simp only [Foundations.secondHarmonicMaximum]
  have hsqrtTwoPos : 0 < Real.sqrt (2 : ℝ) := Real.sqrt_pos.2 (by norm_num)
  have hsqrtTwoSq : Real.sqrt (2 : ℝ) ^ 2 = 2 :=
    Real.sq_sqrt (by norm_num)
  have hhalfNonneg : 0 ≤ (1 / 2 : ℝ) := by norm_num
  have hsqrtHalfSq : Real.sqrt (1 / 2 : ℝ) ^ 2 = 1 / 2 :=
    Real.sq_sqrt hhalfNonneg
  have hinvNonneg : 0 ≤ 1 / Real.sqrt (2 : ℝ) := by positivity
  have hinvSq : (1 / Real.sqrt (2 : ℝ)) ^ 2 = 1 / 2 := by
    field_simp [hsqrtTwoPos.ne']
    nlinarith [hsqrtTwoSq]
  have heq : Real.sqrt (1 / 2 : ℝ) = 1 / Real.sqrt 2 := by
    nlinarith [Real.sqrt_nonneg (1 / 2 : ℝ)]
  convert heq using 1
  all_goals norm_num

/-- `BG-RAGASA2026A-DEF-023`: a conservative exact rational enclosure certificate for
the source rectangle `[-0.20,0.20] × [0.50,1.10]`, budgets `0.05` and `0.72`, witness
`(0,1)`, and algebraic center `1 / √2`. -/
def constructedFalsePositiveCertificate :
    Certificates.RankTwoSeparationEnclosureCertificate where
  kappa := 1
  muLower := 7 / 10
  muUpper := 71 / 100
  spectralBudget := 1 / 20
  operatorBudget := 18 / 25
  operatorRadiusUpper := 3 / 20
  spectralLambdaRadiusUpper := 1 / 20
  operatorLambdaRadiusUpper := 3 / 20
  lowerShift := -1 / 5
  lowerScale := 1 / 2
  upperShift := 1 / 5
  upperScale := 11 / 10
  witnessShift := 0
  witnessScale := 1

/-- `BG-RAGASA2026A-THM-031`: the concrete source certificate passes the executable
exact rational enclosure checker. -/
theorem constructedFalsePositiveCertificate_accepts : Certificates.checkRankTwoSeparationEnclosureCertificate
    constructedFalsePositiveCertificate = true := by
  norm_num [Certificates.checkRankTwoSeparationEnclosureCertificate,
    Certificates.rankTwoSeparationEnclosureCertificateConditions,
    constructedFalsePositiveCertificate]

/-- `BG-RAGASA2026A-THM-032`: for the exact source-bound two-observation construction,
the witness `(0,1)` has zero canonical spectral loss and belongs to the spectral pass set,
while the spectral and optimized-operator pass sets are disjoint in the declared source
rectangle. This is the analytic constructed counterexample, not a numerical four-state
result. -/
theorem constructedFalsePositive_exactSpectralPass_and_operatorIncompatibility :
    canonicalSpectralLoss constructedFalsePositiveData
        constructedFalsePositiveCertificate.spectralWitness = 0 ∧
      constructedFalsePositiveCertificate.spectralWitness ∈
        canonicalSpectralAdmissibleSetInRectangle constructedFalsePositiveData
          (Certificates.rankTwoParameterOfRat
            constructedFalsePositiveCertificate.lowerShift
            constructedFalsePositiveCertificate.lowerScale)
          (Certificates.rankTwoParameterOfRat
            constructedFalsePositiveCertificate.upperShift
            constructedFalsePositiveCertificate.upperScale)
          (constructedFalsePositiveCertificate.spectralBudget : ℝ) ∧
      0 < constructedFalsePositiveCertificate.spectralWitness 1 ∧
      Disjoint
        (canonicalSpectralAdmissibleSetInRectangle constructedFalsePositiveData
          (Certificates.rankTwoParameterOfRat
            constructedFalsePositiveCertificate.lowerShift
            constructedFalsePositiveCertificate.lowerScale)
          (Certificates.rankTwoParameterOfRat
            constructedFalsePositiveCertificate.upperShift
            constructedFalsePositiveCertificate.upperScale)
          (constructedFalsePositiveCertificate.spectralBudget : ℝ))
        (canonicalOptimizedOperatorAdmissibleSetInRectangle constructedFalsePositiveData
          (Certificates.rankTwoParameterOfRat
            constructedFalsePositiveCertificate.lowerShift
            constructedFalsePositiveCertificate.lowerScale)
          (Certificates.rankTwoParameterOfRat
            constructedFalsePositiveCertificate.upperShift
            constructedFalsePositiveCertificate.upperScale)
          (constructedFalsePositiveCertificate.operatorBudget : ℝ)) := by
  have hmuLower :
      (constructedFalsePositiveCertificate.muLower : ℝ) ≤
        maximumNormalizedOperatorCorrelation
          (canonicalRankTwoPauliDecomposition constructedFalsePositiveData)
          (constructedFalsePositiveCertificate.kappa : ℝ) := by
    norm_num [constructedFalsePositiveCertificate]
    rw [constructedFalsePositive_maximumNormalizedCorrelation]
    exact Certificates.sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths.1.le
  have hmuUpper :
      maximumNormalizedOperatorCorrelation
          (canonicalRankTwoPauliDecomposition constructedFalsePositiveData)
          (constructedFalsePositiveCertificate.kappa : ℝ) ≤
        (constructedFalsePositiveCertificate.muUpper : ℝ) := by
    norm_num [constructedFalsePositiveCertificate]
    rw [constructedFalsePositive_maximumNormalizedCorrelation]
    exact Certificates.sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths.2.le
  have hpowerCert : Hilbert.rankTwoWeightedFrobeniusSq
      constructedFalsePositiveData.periodic.weight constructedFalsePositiveData.periodic.energyRef
      (Bloch.sampledCenteredField constructedFalsePositiveData.periodic) =
        (constructedFalsePositiveCertificate.kappa : ℝ) := by
    simpa [constructedFalsePositiveCertificate] using constructedFalsePositive_uniformWeight_and_power.2
  have hbridge :=
    canonicalSpectralPass_and_operatorIncompatibility_of_checkedEnclosure
      constructedFalsePositiveData constructedFalsePositiveCertificate
      constructedFalsePositiveCertificate_accepts hpowerCert hmuLower hmuUpper
  refine ⟨?_, hbridge⟩
  rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss constructedFalsePositiveData 1
    constructedFalsePositive_uniformWeight_and_power.2]
  simp [constructedFalsePositiveCertificate,
    Certificates.RankTwoSeparationEnclosureCertificate.spectralWitness,
    Certificates.rankTwoParameterOfRat, Geometry.rankTwoSpectralLoss,
    Geometry.rankTwoSpectralLossSq]

/-- `BG-RAGASA2026A-DEF-024`: the source's exact full-ellipse separation distance for
the constructed false positive. -/
noncomputable def constructedFalsePositiveSeparationDistance : ℝ :=
  1 - 1 / Real.sqrt 2 - 1 / 20 -
    Real.sqrt ((18 / 25 : ℝ) ^ 2 - 1 / 2)

private lemma constructedFalsePositive_invSqrtTwo_sq :
    (1 / Real.sqrt (2 : ℝ)) ^ 2 = 1 / 2 := by
  have hsqrtTwoPos : 0 < Real.sqrt (2 : ℝ) := Real.sqrt_pos.2 (by norm_num)
  have hsqrtTwoSq : Real.sqrt (2 : ℝ) ^ 2 = 2 :=
    Real.sq_sqrt (by norm_num)
  field_simp [hsqrtTwoPos.ne']
  nlinarith [hsqrtTwoSq]

private lemma constructedFalsePositive_operatorRadius_le_threeTwentieths :
    Real.sqrt ((18 / 25 : ℝ) ^ 2 - 1 / 2) ≤ 3 / 20 := by
  have hrad : 0 ≤ (18 / 25 : ℝ) ^ 2 - 1 / 2 := by norm_num
  apply (sq_le_sq₀ (Real.sqrt_nonneg _)
    (by norm_num : (0 : ℝ) ≤ 3 / 20)).1
  rw [Real.sq_sqrt hrad]
  norm_num

/-- `BG-RAGASA2026A-THM-033`: the source's closed-form separation is strictly positive
and is exactly the Euclidean admissible-set distance between the rectangle-restricted
canonical spectral and optimized-operator pass sets. -/
theorem constructedFalsePositive_exactSeparationDistance :
    0 < constructedFalsePositiveSeparationDistance ∧
      (let lower := Certificates.rankTwoParameterOfRat
        constructedFalsePositiveCertificate.lowerShift
        constructedFalsePositiveCertificate.lowerScale
      let upper := Certificates.rankTwoParameterOfRat
        constructedFalsePositiveCertificate.upperShift
        constructedFalsePositiveCertificate.upperScale
      let spectralSet := canonicalSpectralAdmissibleSetInRectangle
        constructedFalsePositiveData lower upper
        (constructedFalsePositiveCertificate.spectralBudget : ℝ)
      let operatorSet := canonicalOptimizedOperatorAdmissibleSetInRectangle
        constructedFalsePositiveData lower upper
        (constructedFalsePositiveCertificate.operatorBudget : ℝ)
      ∃ (hSpectral : spectralSet.Nonempty) (hOperator : operatorSet.Nonempty),
        Geometry.admissibleSetDist spectralSet operatorSet hSpectral hOperator =
          constructedFalsePositiveSeparationDistance) := by
  constructor
  · rw [constructedFalsePositiveSeparationDistance]
    linarith [Certificates.sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths.2,
      constructedFalsePositive_operatorRadius_le_threeTwentieths]
  · simp only [constructedFalsePositiveCertificate]
    let lower := Certificates.rankTwoParameterOfRat
      constructedFalsePositiveCertificate.lowerShift
      constructedFalsePositiveCertificate.lowerScale
    let upper := Certificates.rankTwoParameterOfRat
      constructedFalsePositiveCertificate.upperShift
      constructedFalsePositiveCertificate.upperScale
    let μ : ℝ := 1 / Real.sqrt 2
    have hμEq : maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition constructedFalsePositiveData) 1 = μ := by
      exact constructedFalsePositive_maximumNormalizedCorrelation
    have hμLower :
        (constructedFalsePositiveCertificate.muLower : ℝ) ≤ μ := by
      norm_num [constructedFalsePositiveCertificate]
      exact Certificates.sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths.1.le
    have hμUpper : μ ≤
        (constructedFalsePositiveCertificate.muUpper : ℝ) := by
      norm_num [constructedFalsePositiveCertificate]
      exact Certificates.sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths.2.le
    have hμPos : 0 < μ := by
      dsimp [μ]
      positivity
    have hμLeOne : μ ≤ 1 := by
      dsimp [μ]
      linarith [Certificates.sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths.2]
    have hμAbs : |μ| ≤ 1 := by
      rw [abs_of_pos hμPos]
      exact hμLeOne
    have hradicand : 1 * (1 - μ ^ 2) ≤ (18 / 25 : ℝ) ^ 2 := by
      rw [constructedFalsePositive_invSqrtTwo_sq]
      norm_num
    have hcontain :=
      Certificates.fullEllipses_subset_enclosureCandidateRectangle_of_check_eq_true
        constructedFalsePositiveCertificate_accepts hμLower hμUpper
    have hSpectralContained :
        Geometry.rankTwoFullSpectralEllipse 1 (1 / 20) ⊆
          Geometry.rankTwoCandidateRectangle lower upper := by
      simpa [lower, upper, constructedFalsePositiveCertificate,
        Certificates.RankTwoSeparationEnclosureCertificate.candidateRectangle] using
        hcontain.1
    have hOperatorContained :
        Geometry.rankTwoFullOperatorEllipse 1 μ
            (Geometry.rankTwoOperatorRadius 1 μ (18 / 25)) ⊆
          Geometry.rankTwoCandidateRectangle lower upper := by
      simpa [lower, upper, constructedFalsePositiveCertificate,
        Certificates.RankTwoSeparationEnclosureCertificate.candidateRectangle] using
        hcontain.2
    have hSpectralNonempty :
        (canonicalSpectralAdmissibleSetInRectangle constructedFalsePositiveData
          lower upper (1 / 20)).Nonempty := by
      refine ⟨constructedFalsePositiveCertificate.spectralWitness, ?_⟩
      simpa [lower, upper, constructedFalsePositiveCertificate] using
        constructedFalsePositive_exactSpectralPass_and_operatorIncompatibility.2.1
    let p : Geometry.RankTwoParameter := EuclideanSpace.single (1 : Fin 2) μ
    have hpFull : p ∈ Geometry.rankTwoFullOperatorEllipse 1 μ
        (Geometry.rankTwoOperatorRadius 1 μ (18 / 25)) := by
      simpa [Geometry.rankTwoFullOperatorEllipse, p] using
        sq_nonneg (Geometry.rankTwoOperatorRadius 1 μ (18 / 25))
    have hpLoss : canonicalOptimizedOperatorLoss constructedFalsePositiveData p ≤
        (18 / 25 : ℝ) := by
      rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss
        constructedFalsePositiveData 1 (by norm_num)
        constructedFalsePositive_uniformWeight_and_power.2 p]
      rw [hμEq]
      exact (Geometry.rankTwoAlignedOperatorLoss_le_iff_ellipse
        (by norm_num) hμAbs (by norm_num) hradicand p).2 hpFull
    have hOperatorNonempty :
        (canonicalOptimizedOperatorAdmissibleSetInRectangle
          constructedFalsePositiveData lower upper (18 / 25)).Nonempty := by
      exact ⟨p, hpLoss, hOperatorContained hpFull⟩
    have hSpectralNonempty' :
        (canonicalSpectralAdmissibleSetInRectangle constructedFalsePositiveData
          (Certificates.rankTwoParameterOfRat (-1 / 5) (1 / 2))
          (Certificates.rankTwoParameterOfRat (1 / 5) (11 / 10))
          ((1 / 20 : ℚ) : ℝ)).Nonempty := by
      convert hSpectralNonempty using 1
      all_goals norm_num [lower, upper, constructedFalsePositiveCertificate]
    have hOperatorNonempty' :
        (canonicalOptimizedOperatorAdmissibleSetInRectangle
          constructedFalsePositiveData
          (Certificates.rankTwoParameterOfRat (-1 / 5) (1 / 2))
          (Certificates.rankTwoParameterOfRat (1 / 5) (11 / 10))
          ((18 / 25 : ℚ) : ℝ)).Nonempty := by
      convert hOperatorNonempty using 1
      all_goals norm_num [lower, upper, constructedFalsePositiveCertificate]
    refine ⟨hSpectralNonempty', hOperatorNonempty', ?_⟩
    have hdist := canonicalLossAdmissibleSetsInRectangle_admissibleSetDist_eq
      constructedFalsePositiveData lower upper 1 (1 / 20) (18 / 25)
      (by norm_num) constructedFalsePositive_uniformWeight_and_power.2
      (by norm_num) (by norm_num) (by simpa [hμEq] using hradicand)
      hSpectralContained (by simpa [hμEq] using hOperatorContained)
      hSpectralNonempty hOperatorNonempty
    have hdist' : Geometry.admissibleSetDist
        (canonicalSpectralAdmissibleSetInRectangle constructedFalsePositiveData
          (Certificates.rankTwoParameterOfRat (-1 / 5) (1 / 2))
          (Certificates.rankTwoParameterOfRat (1 / 5) (11 / 10))
          ((1 / 20 : ℚ) : ℝ))
        (canonicalOptimizedOperatorAdmissibleSetInRectangle
          constructedFalsePositiveData
          (Certificates.rankTwoParameterOfRat (-1 / 5) (1 / 2))
          (Certificates.rankTwoParameterOfRat (1 / 5) (11 / 10))
          ((18 / 25 : ℚ) : ℝ))
        hSpectralNonempty' hOperatorNonempty' =
          Geometry.rankTwoFullEllipseDistance 1
            (maximumNormalizedOperatorCorrelation
              (canonicalRankTwoPauliDecomposition constructedFalsePositiveData) 1)
            (1 / 20) (Geometry.rankTwoOperatorRadius 1
              (maximumNormalizedOperatorCorrelation
                (canonicalRankTwoPauliDecomposition constructedFalsePositiveData) 1)
              (18 / 25)) := by
      convert hdist using 1
      all_goals norm_num [lower, upper, constructedFalsePositiveCertificate]
    rw [hdist', hμEq]
    rw [Geometry.rankTwoFullEllipseDistance, Geometry.rankTwoOperatorRadius]
    have hsepPos : 0 < constructedFalsePositiveSeparationDistance := by
      rw [constructedFalsePositiveSeparationDistance]
      linarith [
        Certificates.sevenTenths_lt_inv_sqrtTwo_lt_seventyOneHundredths.2,
        constructedFalsePositive_operatorRadius_le_threeTwentieths]
    have hμSubNonneg : 0 ≤ 1 - μ := sub_nonneg.2 hμLeOne
    rw [abs_of_nonneg hμSubNonneg, Real.sqrt_one, div_one]
    rw [show 1 * (1 - μ ^ 2) = 1 / 2 by
      rw [constructedFalsePositive_invSqrtTwo_sq]
      norm_num]
    rw [max_eq_right]
    · rw [constructedFalsePositiveSeparationDistance]
      dsimp [μ]
      ring
    · have hsepNonneg := hsepPos.le
      rw [constructedFalsePositiveSeparationDistance] at hsepNonneg
      linarith

/-- `BG-RAGASA2026A-THM-034`: every declared separation resolution strictly below the
exact constructed distance is certified below the actual rectangle-restricted
admissible-set distance. -/
theorem constructedFalsePositive_separationResolutionCertified
    (rhoSep : ℝ)
    (hresolution : rhoSep < constructedFalsePositiveSeparationDistance) :
    let lower := Certificates.rankTwoParameterOfRat
      constructedFalsePositiveCertificate.lowerShift
      constructedFalsePositiveCertificate.lowerScale
    let upper := Certificates.rankTwoParameterOfRat
      constructedFalsePositiveCertificate.upperShift
      constructedFalsePositiveCertificate.upperScale
    let spectralSet := canonicalSpectralAdmissibleSetInRectangle
      constructedFalsePositiveData lower upper
      (constructedFalsePositiveCertificate.spectralBudget : ℝ)
    let operatorSet := canonicalOptimizedOperatorAdmissibleSetInRectangle
      constructedFalsePositiveData lower upper
      (constructedFalsePositiveCertificate.operatorBudget : ℝ)
    ∃ (hSpectral : spectralSet.Nonempty) (hOperator : operatorSet.Nonempty),
      rhoSep < Geometry.admissibleSetDist spectralSet operatorSet
        hSpectral hOperator := by
  rcases constructedFalsePositive_exactSeparationDistance.2 with
    ⟨hSpectral, hOperator, hdist⟩
  exact ⟨hSpectral, hOperator, by rwa [hdist]⟩

end ProjectKoios.BandGauge.Papers.Ragasa2026A

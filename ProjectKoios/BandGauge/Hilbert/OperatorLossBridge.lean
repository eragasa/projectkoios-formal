module

public import ProjectKoios.BandGauge.Geometry.RankTwoLoss
public import ProjectKoios.BandGauge.Hilbert.WeightedFrobenius

/-!
# Rank-two matrix-residual loss bridge

This module connects the source-normalized finite weighted Frobenius layer to the reduced
rank-two scalar operator-loss polynomial. It formalizes the operator-channel expansion in
Supplementary Section S1.1 of Ragasa2026A.

The bridge assumes pointwise traceless splitting fields, normalized coordinate weights,
and a nonzero reference energy. Identification of these abstract finite fields with
external scientific data remains outside the theorem.
-/

open scoped BigOperators Matrix
open Finset

@[expose] public section

namespace ProjectKoios.BandGauge.Hilbert

/-- `BG-HILBERT-DEF-007`: the unnormalized retained-rank-two matrix residual
`Eref * s * I + λ * D - B`. -/
def rankTwoOperatorResidual {I : Type*} (energyRef shift scale : ℝ)
    (D B : RankTwoMatrixField I) : RankTwoMatrixField I :=
  fun i => ((energyRef * shift : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) +
    (scale : ℂ) • D i + (-1 : ℂ) • B i

/-- `BG-HILBERT-DEF-008`: the source-normalized weighted squared Frobenius loss of the
retained-rank-two operator residual. -/
noncomputable def rankTwoOperatorMatrixLossSq {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef shift scale : ℝ)
    (D B : RankTwoMatrixField I) : ℝ :=
  rankTwoWeightedFrobeniusSq weight energyRef
    (rankTwoOperatorResidual energyRef shift scale D B)

private theorem identity_weightedFrobeniusSq
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef : ℝ)
    (hweightSum : ∑ i, weight i = 1) :
    rankTwoWeightedFrobeniusSq weight energyRef
      (rankTwoIdentityMatrixField I) = 1 / energyRef ^ 2 := by
  rw [rankTwoWeightedFrobeniusSq, Fintype.sum_prod_type]
  calc
    (∑ i, ∑ y : Fin 2 × Fin 2,
        rankTwoFrobeniusCoefficient (weight (i, y).1) energyRef *
          ‖(rankTwoIdentityMatrixField I (i, y).1) y.1 y.2‖ ^ 2) =
        ∑ i, weight i / energyRef ^ 2 := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [Fintype.sum_prod_type]
      simp [rankTwoIdentityMatrixField, rankTwoFrobeniusCoefficient,
        Matrix.one_apply, Fin.sum_univ_two]
      ring
    _ = 1 / energyRef ^ 2 := by
      rw [← Finset.sum_div, hweightSum]

private theorem residualTail_trace_zero {I : Type*}
    (scale : ℝ) (D B : RankTwoMatrixField I)
    (htraceD : ∀ i, Matrix.trace (D i) = 0)
    (htraceB : ∀ i, Matrix.trace (B i) = 0) :
    ∀ i, Matrix.trace ((scale : ℂ) • D i + (-1 : ℂ) • B i) = 0 := by
  intro i
  rw [Matrix.trace_add, Matrix.trace_smul, Matrix.trace_smul, htraceD i, htraceB i]
  simp

/-- `BG-HILBERT-THM-011`: expansion of the source's weighted rank-two matrix residual
into shift, splitting-power, and real-correlation terms. -/
theorem rankTwoOperatorMatrixLossSq_eq_expansion
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef shift scale : ℝ)
    (D B : RankTwoMatrixField I)
    (hweightSum : ∑ i, weight i = 1) (henergyRef : energyRef ≠ 0)
    (htraceD : ∀ i, Matrix.trace (D i) = 0)
    (htraceB : ∀ i, Matrix.trace (B i) = 0) :
    rankTwoOperatorMatrixLossSq weight energyRef shift scale D B =
      shift ^ 2 +
        scale ^ 2 * rankTwoWeightedFrobeniusSq weight energyRef D -
        2 * scale * rankTwoWeightedFrobeniusCorrelation weight energyRef D B +
        rankTwoWeightedFrobeniusSq weight energyRef B := by
  let tail : RankTwoMatrixField I :=
    fun i => (scale : ℂ) • D i + (-1 : ℂ) • B i
  have htailTrace : ∀ i, Matrix.trace (tail i) = 0 :=
    residualTail_trace_zero scale D B htraceD htraceB
  have hidentityTail :
      rankTwoWeightedFrobeniusCorrelation weight energyRef
        (rankTwoIdentityMatrixField I) tail = 0 :=
    rankTwoWeightedFrobeniusCorrelation_identity_eq_zero
      weight energyRef tail htailTrace
  have htailPower :
      rankTwoWeightedFrobeniusSq weight energyRef tail =
        scale ^ 2 * rankTwoWeightedFrobeniusSq weight energyRef D -
          2 * scale * rankTwoWeightedFrobeniusCorrelation weight energyRef D B +
            rankTwoWeightedFrobeniusSq weight energyRef B := by
    convert rankTwoWeightedFrobeniusSq_linear_combination
      weight energyRef scale (-1) D B using 1 <;> simp [tail] ; ring
  have houter := rankTwoWeightedFrobeniusSq_linear_combination
    weight energyRef (energyRef * shift) 1
    (rankTwoIdentityMatrixField I) tail
  rw [identity_weightedFrobeniusSq weight energyRef hweightSum,
    hidentityTail, htailPower] at houter
  rw [rankTwoOperatorMatrixLossSq]
  have hresidual : rankTwoOperatorResidual energyRef shift scale D B =
      fun i => ((energyRef * shift : ℝ) : ℂ) •
        (rankTwoIdentityMatrixField I i) + (1 : ℂ) • tail i := by
    funext i
    simp [rankTwoOperatorResidual, rankTwoIdentityMatrixField, tail]
    abel
  have houter' :
      rankTwoWeightedFrobeniusSq weight energyRef
        (fun i => ((energyRef * shift : ℝ) : ℂ) •
          (rankTwoIdentityMatrixField I i) + (1 : ℂ) • tail i) =
        (energyRef * shift) ^ 2 * (1 / energyRef ^ 2) +
          2 * (energyRef * shift) * 1 * 0 + 1 ^ 2 *
            (scale ^ 2 * rankTwoWeightedFrobeniusSq weight energyRef D -
              2 * scale * rankTwoWeightedFrobeniusCorrelation weight energyRef D B +
                rankTwoWeightedFrobeniusSq weight energyRef B) := by
    simpa using houter
  rw [hresidual, houter']
  field_simp
  ring

/-- `BG-HILBERT-THM-012`: if both splitting fields have common weighted power `κ` and
correlation `b`, the matrix residual is the scalar quadratic
`s² + κ λ² - 2 b λ + κ`. -/
theorem rankTwoOperatorMatrixLossSq_eq_quadratic
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef shift scale κ b : ℝ)
    (D B : RankTwoMatrixField I)
    (hweightSum : ∑ i, weight i = 1) (henergyRef : energyRef ≠ 0)
    (htraceD : ∀ i, Matrix.trace (D i) = 0)
    (htraceB : ∀ i, Matrix.trace (B i) = 0)
    (hpowerD : rankTwoWeightedFrobeniusSq weight energyRef D = κ)
    (hpowerB : rankTwoWeightedFrobeniusSq weight energyRef B = κ)
    (hcorrelation : rankTwoWeightedFrobeniusCorrelation weight energyRef D B = b) :
    rankTwoOperatorMatrixLossSq weight energyRef shift scale D B =
      shift ^ 2 + κ * scale ^ 2 - 2 * b * scale + κ := by
  rw [rankTwoOperatorMatrixLossSq_eq_expansion weight energyRef shift scale D B
    hweightSum henergyRef htraceD htraceB, hpowerD, hpowerB, hcorrelation]
  ring

/-- `BG-HILBERT-THM-013`: the source matrix loss equals the existing reduced scalar
aligned-operator loss after normalizing the correlation by a positive common power. -/
theorem rankTwoOperatorMatrixLossSq_eq_rankTwoAlignedOperatorLossSq
    {I : Type*} [Fintype I]
    (weight : I → ℝ) (energyRef κ b : ℝ)
    (D B : RankTwoMatrixField I)
    (hweightSum : ∑ i, weight i = 1) (henergyRef : energyRef ≠ 0)
    (hκ : 0 < κ)
    (htraceD : ∀ i, Matrix.trace (D i) = 0)
    (htraceB : ∀ i, Matrix.trace (B i) = 0)
    (hpowerD : rankTwoWeightedFrobeniusSq weight energyRef D = κ)
    (hpowerB : rankTwoWeightedFrobeniusSq weight energyRef B = κ)
    (hcorrelation : rankTwoWeightedFrobeniusCorrelation weight energyRef D B = b)
    (p : ProjectKoios.BandGauge.Geometry.RankTwoParameter) :
    rankTwoOperatorMatrixLossSq weight energyRef (p 0) (p 1) D B =
      ProjectKoios.BandGauge.Geometry.rankTwoAlignedOperatorLossSq κ
        (ProjectKoios.BandGauge.Geometry.rankTwoNormalizedCorrelation κ b) p := by
  rw [rankTwoOperatorMatrixLossSq_eq_quadratic weight energyRef (p 0) (p 1) κ b D B
    hweightSum henergyRef htraceD htraceB hpowerD hpowerB hcorrelation]
  rw [ProjectKoios.BandGauge.Geometry.rankTwoAlignedOperatorLossSq,
    ProjectKoios.BandGauge.Geometry.rankTwoNormalizedCorrelation]
  field_simp
  ring

end ProjectKoios.BandGauge.Hilbert

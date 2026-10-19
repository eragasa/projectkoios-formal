module

public import ProjectKoios.BandGauge.Papers.Ragasa2026A.RankTwoFields
public import ProjectKoios.BandGauge.Foundations.HarmonicOptimization
public import ProjectKoios.BandGauge.Foundations.RankTwoPauli

/-!
# Ragasa2026A correlation harmonic

This module derives the exact second-harmonic dependence of the paper-specific operator
correlation from exact Pauli coordinates, including a canonical extraction from the Hermitian traceless
fields, and proves its continuous maximum.
It does not bind floating-point data, implement an eigensolver, or construct Bloch data
from a periodic potential.
-/

open scoped BigOperators ComplexConjugate Matrix
open Finset

@[expose] public section

namespace ProjectKoios.BandGauge.Papers.Ragasa2026A

open ProjectKoios.BandGauge

/-- `BG-RAGASA2026A-DEF-007`: exact real Pauli-coordinate witnesses for the sampled
centered parent `D_i` and momentum-dependently aligned comparison `B_i`. -/
structure RankTwoPauliDecomposition
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) where
  parentX : I → ℝ
  parentY : I → ℝ
  parentZ : I → ℝ
  comparisonX : I → ℝ
  comparisonY : I → ℝ
  comparisonZ : I → ℝ
  parent_eq : ∀ i,
    Bloch.sampledCenteredField data.periodic i =
      Foundations.rankTwoPauliMatrix (parentX i) (parentY i) (parentZ i)
  comparison_eq : ∀ i,
    comparisonSplittingField data i =
      Foundations.rankTwoPauliMatrix (comparisonX i) (comparisonY i) (comparisonZ i)

/-- `BG-RAGASA2026A-DEF-014`: the canonical exact Pauli decomposition extracted from
the entries of the sampled centered parent and comparison fields. Hermiticity and trace
centering make this construction automatic; no external Pauli-coordinate witness is
required. -/
noncomputable def canonicalRankTwoPauliDecomposition
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) : RankTwoPauliDecomposition data where
  parentX := fun i => Foundations.rankTwoPauliX
    (Bloch.sampledCenteredField data.periodic i)
  parentY := fun i => Foundations.rankTwoPauliY
    (Bloch.sampledCenteredField data.periodic i)
  parentZ := fun i => Foundations.rankTwoPauliZ
    (Bloch.sampledCenteredField data.periodic i)
  comparisonX := fun i => Foundations.rankTwoPauliX
    (comparisonSplittingField data i)
  comparisonY := fun i => Foundations.rankTwoPauliY
    (comparisonSplittingField data i)
  comparisonZ := fun i => Foundations.rankTwoPauliZ
    (comparisonSplittingField data i)
  parent_eq := fun i =>
    Foundations.eq_rankTwoPauliMatrix_of_conjTranspose_eq_self_of_trace_eq_zero
      (Bloch.sampledCenteredField data.periodic i)
      (Bloch.sampledCenteredField_conjTranspose_eq_self data.periodic i)
      (Bloch.trace_sampledCenteredField_eq_zero data.periodic i)
  comparison_eq := fun i =>
    Foundations.eq_rankTwoPauliMatrix_of_conjTranspose_eq_self_of_trace_eq_zero
      (comparisonSplittingField data i)
      (Bloch.unitaryConjugateRankTwoField_conjTranspose_eq_self
        (Bloch.sampledCenteredField data.periodic) data.comparisonAlignment
        (Bloch.sampledCenteredField_conjTranspose_eq_self data.periodic) i)
      (Bloch.trace_unitaryConjugateRankTwoField_eq_zero
        (Bloch.sampledCenteredField data.periodic) data.comparisonAlignment
        (Bloch.trace_sampledCenteredField_eq_zero data.periodic) i)

/-- `BG-RAGASA2026A-DEF-008`: the rotation-independent `y`-component correlation. -/
noncomputable def correlationHarmonicB0
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) : ℝ :=
  ∑ i, data.periodic.weight i / data.periodic.energyRef ^ 2 *
    (pauli.parentY i * pauli.comparisonY i)

/-- `BG-RAGASA2026A-DEF-009`: the cosine coefficient of the exact correlation harmonic. -/
noncomputable def correlationHarmonicC
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) : ℝ :=
  ∑ i, data.periodic.weight i / data.periodic.energyRef ^ 2 *
    (pauli.parentX i * pauli.comparisonX i +
      pauli.parentZ i * pauli.comparisonZ i)

/-- `BG-RAGASA2026A-DEF-010`: the sine coefficient of the exact correlation harmonic. -/
noncomputable def correlationHarmonicD
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) : ℝ :=
  ∑ i, data.periodic.weight i / data.periodic.energyRef ^ 2 *
    (pauli.parentX i * pauli.comparisonZ i -
      pauli.parentZ i * pauli.comparisonX i)

/-- `BG-RAGASA2026A-DEF-011`: the exact continuous maximum of `b_φ`. -/
noncomputable def maximumOperatorCorrelation
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) : ℝ :=
  Foundations.secondHarmonicMaximum
    (correlationHarmonicB0 pauli) (correlationHarmonicC pauli)
    (correlationHarmonicD pauli)

/-- `BG-RAGASA2026A-DEF-012`: one exact maximizing angle reduced to the paper's
half-open interval `[-π/2, π/2)`. This deterministic representative is defined even in
the degenerate case, without claiming uniqueness or requiring it to be reported. -/
noncomputable def maximizingOperatorCorrelationAngle
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) : ℝ :=
  Foundations.canonicalSecondHarmonicMaximizingAngle
    (correlationHarmonicC pauli) (correlationHarmonicD pauli)

/-- `BG-RAGASA2026A-DEF-013`: the source's continuously maximized normalized correlation
`μmax = bmax / κ`. -/
noncomputable def maximumNormalizedOperatorCorrelation
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) (κ : ℝ) : ℝ :=
  maximumOperatorCorrelation pauli / κ

private theorem candidateSplittingField_eq_pauli
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) (φ : ℝ) (i : I) :
    candidateSplittingField data φ i =
      Foundations.rankTwoPauliMatrix
        (pauli.parentX i * Real.cos (2 * φ) -
          pauli.parentZ i * Real.sin (2 * φ))
        (pauli.parentY i)
        (pauli.parentX i * Real.sin (2 * φ) +
          pauli.parentZ i * Real.cos (2 * φ)) := by
  rw [candidateSplittingField, Bloch.unitaryConjugateRankTwoField, pauli.parent_eq i]
  exact Foundations.rankTwoRealRotation_conjTranspose_mul_pauli_mul
    φ (pauli.parentX i) (pauli.parentY i) (pauli.parentZ i)

private theorem candidateComparison_entryCorrelation
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) (φ : ℝ) (i : I) :
    (∑ m : Fin 2, ∑ n : Fin 2,
      (conj (candidateSplittingField data φ i m n) *
        comparisonSplittingField data i m n).re) =
      2 * (pauli.parentY i * pauli.comparisonY i +
        (pauli.parentX i * pauli.comparisonX i +
          pauli.parentZ i * pauli.comparisonZ i) * Real.cos (2 * φ) +
        (pauli.parentX i * pauli.comparisonZ i -
          pauli.parentZ i * pauli.comparisonX i) * Real.sin (2 * φ)) := by
  rw [candidateSplittingField_eq_pauli pauli φ i, pauli.comparison_eq i,
    Foundations.rankTwoPauliMatrix_frobeniusCorrelation]
  ring

/-- `BG-RAGASA2026A-THM-008`: the paper-specific operator correlation is exactly a
second harmonic in the global real-rotation angle. -/
theorem operatorCorrelation_eq_secondHarmonic
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) (φ : ℝ) :
    operatorCorrelation data φ =
      Foundations.secondHarmonicValue
        (correlationHarmonicB0 pauli) (correlationHarmonicC pauli)
        (correlationHarmonicD pauli) φ := by
  rw [operatorCorrelation, Hilbert.rankTwoWeightedFrobeniusCorrelation,
    Fintype.sum_prod_type]
  simp_rw [Fintype.sum_prod_type, ← Finset.mul_sum]
  simp_rw [candidateComparison_entryCorrelation pauli φ]
  rw [Foundations.secondHarmonicValue, correlationHarmonicB0,
    correlationHarmonicC, correlationHarmonicD]
  simp_rw [Hilbert.rankTwoFrobeniusCoefficient]
  have href : data.periodic.energyRef ≠ 0 := data.periodic.energyRef_pos.ne'
  field_simp
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib,
    ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro i hi
  ring

/-- `BG-RAGASA2026A-THM-009`: every global rotation has correlation at most the exact
continuous maximum. -/
theorem operatorCorrelation_le_maximum
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) (φ : ℝ) :
    operatorCorrelation data φ ≤ maximumOperatorCorrelation pauli := by
  rw [operatorCorrelation_eq_secondHarmonic pauli φ, maximumOperatorCorrelation]
  exact Foundations.secondHarmonicValue_le_maximum _ _ _ _

/-- `BG-RAGASA2026A-THM-010`: the canonical maximizing angle belongs to the paper's
half-open reporting interval. -/
theorem maximizingOperatorCorrelationAngle_mem
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) :
    maximizingOperatorCorrelationAngle pauli ∈
      Set.Ico (-Real.pi / 2) (Real.pi / 2) := by
  exact Foundations.canonicalSecondHarmonicMaximizingAngle_mem _ _

/-- `BG-RAGASA2026A-THM-011`: the exact canonical complex-argument angle attains the
continuous maximum correlation. -/
theorem operatorCorrelation_maximizingAngle
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) :
    operatorCorrelation data (maximizingOperatorCorrelationAngle pauli) =
      maximumOperatorCorrelation pauli := by
  rw [operatorCorrelation_eq_secondHarmonic, maximizingOperatorCorrelationAngle,
    maximumOperatorCorrelation]
  exact Foundations.secondHarmonicValue_canonicalMaximizingAngle _ _ _

/-- `BG-RAGASA2026A-THM-012`: the declared value is the greatest member of the range of
the exact global-angle correlation. -/
theorem maximumOperatorCorrelation_isGreatest
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) :
    IsGreatest (Set.range (operatorCorrelation data))
      (maximumOperatorCorrelation pauli) := by
  constructor
  · exact ⟨maximizingOperatorCorrelationAngle pauli,
      operatorCorrelation_maximizingAngle pauli⟩
  · rintro _ ⟨φ, rfl⟩
    exact operatorCorrelation_le_maximum pauli φ

/-- `BG-RAGASA2026A-THM-013`: if the centered parent has positive common power `κ`, the
continuously maximized normalized correlation still has magnitude at most one. -/
theorem abs_maximumOperatorCorrelation_div_le_one
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) (κ : ℝ) (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ) :
    |maximumOperatorCorrelation pauli / κ| ≤ 1 := by
  rw [← operatorCorrelation_maximizingAngle pauli]
  rw [abs_div, abs_of_pos hκ]
  exact (div_le_one hκ).2
    (abs_operatorCorrelation_le_commonPower data
      (maximizingOperatorCorrelationAngle pauli) κ hpower)

/-- `BG-RAGASA2026A-THM-014`: at the canonical maximizing angle, the ordinary normalized
correlation is exactly the source's `μmax`. -/
theorem normalizedOperatorCorrelation_maximizingAngle
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (pauli : RankTwoPauliDecomposition data) (κ : ℝ) :
    Geometry.rankTwoNormalizedCorrelation κ
        (operatorCorrelation data (maximizingOperatorCorrelationAngle pauli)) =
      maximumNormalizedOperatorCorrelation pauli κ := by
  rw [Geometry.rankTwoNormalizedCorrelation,
    maximumNormalizedOperatorCorrelation,
    operatorCorrelation_maximizingAngle pauli]

/-- `BG-RAGASA2026A-THM-015`: the exact finite matrix loss at the continuously maximizing
angle equals the reduced aligned-operator loss centered at `μmax`. -/
theorem operatorMatrixLossSq_maximizingAngle_eq_alignedOperatorLossSq
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (pauli : RankTwoPauliDecomposition data) (κ : ℝ) (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (p : Geometry.RankTwoParameter) :
    Hilbert.rankTwoOperatorMatrixLossSq
        data.periodic.weight data.periodic.energyRef (p 0) (p 1)
        (candidateSplittingField data (maximizingOperatorCorrelationAngle pauli))
        (comparisonSplittingField data) =
      Geometry.rankTwoAlignedOperatorLossSq κ
        (maximumNormalizedOperatorCorrelation pauli κ) p := by
  rw [operatorMatrixLossSq_eq_alignedOperatorLossSq data
    (maximizingOperatorCorrelationAngle pauli) κ hκ hpower p,
    normalizedOperatorCorrelation_maximizingAngle pauli κ]

/-- `BG-RAGASA2026A-THM-016`: the paper-specific correlation harmonic follows directly
from the field contract through the canonical exact Pauli decomposition. -/
theorem operatorCorrelation_eq_canonicalSecondHarmonic
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (φ : ℝ) :
    operatorCorrelation data φ =
      Foundations.secondHarmonicValue
        (correlationHarmonicB0 (canonicalRankTwoPauliDecomposition data))
        (correlationHarmonicC (canonicalRankTwoPauliDecomposition data))
        (correlationHarmonicD (canonicalRankTwoPauliDecomposition data)) φ := by
  exact operatorCorrelation_eq_secondHarmonic
    (canonicalRankTwoPauliDecomposition data) φ

/-- `BG-RAGASA2026A-THM-017`: after canonical Pauli extraction, the exact finite matrix
loss at the continuously maximizing angle equals the reduced loss centered at `μmax`. -/
theorem operatorMatrixLossSq_canonicalMaximizingAngle_eq_alignedOperatorLossSq
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (κ : ℝ) (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (p : Geometry.RankTwoParameter) :
    Hilbert.rankTwoOperatorMatrixLossSq
        data.periodic.weight data.periodic.energyRef (p 0) (p 1)
        (candidateSplittingField data
          (maximizingOperatorCorrelationAngle
            (canonicalRankTwoPauliDecomposition data)))
        (comparisonSplittingField data) =
      Geometry.rankTwoAlignedOperatorLossSq κ
        (maximumNormalizedOperatorCorrelation
          (canonicalRankTwoPauliDecomposition data) κ) p := by
  exact operatorMatrixLossSq_maximizingAngle_eq_alignedOperatorLossSq data
    (canonicalRankTwoPauliDecomposition data) κ hκ hpower p

end ProjectKoios.BandGauge.Papers.Ragasa2026A

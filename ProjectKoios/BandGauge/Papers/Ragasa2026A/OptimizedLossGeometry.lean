module

public import ProjectKoios.BandGauge.Papers.Ragasa2026A.CorrelationHarmonic

/-!
# Ragasa2026A optimized loss geometry

This module specializes the reusable rank-two ellipse geometry to the canonical spectral
field and the continuously correlation-maximizing operator field. All results remain
conditional on the abstract finite field contract, a declared common power, thresholds,
and—where relevant—full-ellipse containment in the candidate rectangle. Here
"optimized" means evaluated at the correlation-maximizing angle. No pointwise minimization
over angles is asserted on the unrestricted real `λ` line; the publication's positive
candidate domain remains a separate instantiation condition.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Papers.Ragasa2026A

open ProjectKoios.BandGauge

/-- `BG-RAGASA2026A-DEF-016`: the nonnegative real spectral loss of the canonical exact
Hermitian spectral field. -/
noncomputable def canonicalSpectralLoss
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (p : Geometry.RankTwoParameter) : ℝ :=
  Real.sqrt (Hilbert.rankTwoSpectralFieldLossSq
    data.periodic.weight data.periodic.energyRef (p 0) (p 1)
    (spectralSplittingField (canonicalRankTwoSpectralDecomposition data)))

/-- `BG-RAGASA2026A-DEF-017`: the nonnegative real matrix loss at the canonical
continuously correlation-maximizing angle. -/
noncomputable def canonicalOptimizedOperatorLoss
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (p : Geometry.RankTwoParameter) : ℝ :=
  Real.sqrt (Hilbert.rankTwoOperatorMatrixLossSq
    data.periodic.weight data.periodic.energyRef (p 0) (p 1)
    (candidateSplittingField data
      (maximizingOperatorCorrelationAngle
        (canonicalRankTwoPauliDecomposition data)))
    (comparisonSplittingField data))

/-- `BG-RAGASA2026A-DEF-018`: the canonical spectral-loss sublevel set. -/
def canonicalSpectralAdmissibleSet
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (spectralBudget : ℝ) :
    Set Geometry.RankTwoParameter :=
  Geometry.spectralAdmissibleSet (canonicalSpectralLoss data) spectralBudget

/-- `BG-RAGASA2026A-DEF-019`: the continuously optimized operator-loss sublevel set. -/
def canonicalOptimizedOperatorAdmissibleSet
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (operatorBudget : ℝ) :
    Set Geometry.RankTwoParameter :=
  Geometry.alignedOperatorAdmissibleSet
    (canonicalOptimizedOperatorLoss data) operatorBudget

/-- `BG-RAGASA2026A-DEF-020`: the canonical spectral-loss admissible set restricted to
the declared candidate rectangle. -/
def canonicalSpectralAdmissibleSetInRectangle
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (lower upper : Geometry.RankTwoParameter) (spectralBudget : ℝ) :
    Set Geometry.RankTwoParameter :=
  canonicalSpectralAdmissibleSet data spectralBudget ∩
    Geometry.rankTwoCandidateRectangle lower upper

/-- `BG-RAGASA2026A-DEF-021`: the optimized operator-loss admissible set restricted to
the declared candidate rectangle. -/
def canonicalOptimizedOperatorAdmissibleSetInRectangle
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (lower upper : Geometry.RankTwoParameter) (operatorBudget : ℝ) :
    Set Geometry.RankTwoParameter :=
  canonicalOptimizedOperatorAdmissibleSet data operatorBudget ∩
    Geometry.rankTwoCandidateRectangle lower upper

/-- `BG-RAGASA2026A-THM-021`: the canonical finite spectral-field real loss is exactly the
reduced scalar spectral loss when the sampled parent has power `κ`. -/
theorem canonicalSpectralLoss_eq_rankTwoSpectralLoss
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (κ : ℝ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (p : Geometry.RankTwoParameter) :
    canonicalSpectralLoss data p = Geometry.rankTwoSpectralLoss κ p := by
  rw [canonicalSpectralLoss, Geometry.rankTwoSpectralLoss,
    canonicalSpectralFieldLossSq_eq_spectralLossSq data κ hpower p]

/-- `BG-RAGASA2026A-THM-022`: the canonical continuously optimized finite matrix real
loss is exactly the reduced aligned-operator loss centered at `μmax`. -/
theorem canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (κ : ℝ) (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (p : Geometry.RankTwoParameter) :
    canonicalOptimizedOperatorLoss data p =
      Geometry.rankTwoAlignedOperatorLoss κ
        (maximumNormalizedOperatorCorrelation
          (canonicalRankTwoPauliDecomposition data) κ) p := by
  rw [canonicalOptimizedOperatorLoss, Geometry.rankTwoAlignedOperatorLoss,
    operatorMatrixLossSq_canonicalMaximizingAngle_eq_alignedOperatorLossSq
      data κ hκ hpower p]

/-- `BG-RAGASA2026A-THM-023`: the canonical spectral and continuously optimized operator
admissible sets intersect exactly under the existing full-ellipse compatibility bound. -/
theorem canonicalLossAdmissibleSets_inter_nonempty_iff
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (κ spectralBudget operatorBudget : ℝ)
    (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorBudget : 0 ≤ operatorBudget)
    (hRadicand : κ * (1 -
      maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ ^ 2) ≤ operatorBudget ^ 2) :
    (canonicalSpectralAdmissibleSet data spectralBudget ∩
      canonicalOptimizedOperatorAdmissibleSet data operatorBudget).Nonempty ↔
      Real.sqrt κ * |1 - maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ| ≤
        spectralBudget + Geometry.rankTwoOperatorRadius κ
          (maximumNormalizedOperatorCorrelation
            (canonicalRankTwoPauliDecomposition data) κ) operatorBudget := by
  let pauli := canonicalRankTwoPauliDecomposition data
  let μ := maximumNormalizedOperatorCorrelation pauli κ
  have hμ : |μ| ≤ 1 := by
    dsimp [μ, maximumNormalizedOperatorCorrelation]
    exact abs_maximumOperatorCorrelation_div_le_one pauli κ hκ hpower
  have hSpectralSet : canonicalSpectralAdmissibleSet data spectralBudget =
      Geometry.spectralAdmissibleSet
        (Geometry.rankTwoSpectralLoss κ) spectralBudget := by
    ext p
    change canonicalSpectralLoss data p ≤ spectralBudget ↔
      Geometry.rankTwoSpectralLoss κ p ≤ spectralBudget
    rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data κ hpower p]
  have hOperatorSet : canonicalOptimizedOperatorAdmissibleSet data operatorBudget =
      Geometry.alignedOperatorAdmissibleSet
        (Geometry.rankTwoAlignedOperatorLoss κ μ) operatorBudget := by
    ext p
    change canonicalOptimizedOperatorLoss data p ≤ operatorBudget ↔
      Geometry.rankTwoAlignedOperatorLoss κ μ p ≤ operatorBudget
    rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss
      data κ hκ hpower p]
  rw [hSpectralSet, hOperatorSet]
  exact Geometry.rankTwoLossAdmissibleSets_inter_nonempty_iff
    hκ hμ hSpectralBudget hOperatorBudget hRadicand

/-- `BG-RAGASA2026A-THM-024`: the exact distance between the canonical spectral and
continuously optimized operator admissible sets is the existing closed-form ellipse
distance. -/
theorem canonicalLossAdmissibleSetDist_eq
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (κ spectralBudget operatorBudget : ℝ)
    (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorBudget : 0 ≤ operatorBudget)
    (hRadicand : κ * (1 -
      maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ ^ 2) ≤ operatorBudget ^ 2)
    (hSpectralNonempty :
      (canonicalSpectralAdmissibleSet data spectralBudget).Nonempty)
    (hOperatorNonempty :
      (canonicalOptimizedOperatorAdmissibleSet data operatorBudget).Nonempty) :
    Geometry.admissibleSetDist
      (canonicalSpectralAdmissibleSet data spectralBudget)
      (canonicalOptimizedOperatorAdmissibleSet data operatorBudget)
      hSpectralNonempty hOperatorNonempty =
        Geometry.rankTwoFullEllipseDistance κ
          (maximumNormalizedOperatorCorrelation
            (canonicalRankTwoPauliDecomposition data) κ)
          spectralBudget
          (Geometry.rankTwoOperatorRadius κ
            (maximumNormalizedOperatorCorrelation
              (canonicalRankTwoPauliDecomposition data) κ) operatorBudget) := by
  let pauli := canonicalRankTwoPauliDecomposition data
  let μ := maximumNormalizedOperatorCorrelation pauli κ
  have hμ : |μ| ≤ 1 := by
    dsimp [μ, maximumNormalizedOperatorCorrelation]
    exact abs_maximumOperatorCorrelation_div_le_one pauli κ hκ hpower
  have hSpectralSet : canonicalSpectralAdmissibleSet data spectralBudget =
      Geometry.spectralAdmissibleSet
        (Geometry.rankTwoSpectralLoss κ) spectralBudget := by
    ext p
    change canonicalSpectralLoss data p ≤ spectralBudget ↔
      Geometry.rankTwoSpectralLoss κ p ≤ spectralBudget
    rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data κ hpower p]
  have hOperatorSet : canonicalOptimizedOperatorAdmissibleSet data operatorBudget =
      Geometry.alignedOperatorAdmissibleSet
        (Geometry.rankTwoAlignedOperatorLoss κ μ) operatorBudget := by
    ext p
    change canonicalOptimizedOperatorLoss data p ≤ operatorBudget ↔
      Geometry.rankTwoAlignedOperatorLoss κ μ p ≤ operatorBudget
    rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss
      data κ hκ hpower p]
  have hSpectralNonempty' :
      (Geometry.spectralAdmissibleSet
        (Geometry.rankTwoSpectralLoss κ) spectralBudget).Nonempty :=
    hSpectralSet ▸ hSpectralNonempty
  have hOperatorNonempty' :
      (Geometry.alignedOperatorAdmissibleSet
        (Geometry.rankTwoAlignedOperatorLoss κ μ) operatorBudget).Nonempty :=
    hOperatorSet ▸ hOperatorNonempty
  simpa only [hSpectralSet, hOperatorSet] using
    Geometry.rankTwoLossAdmissibleSetDist_eq hκ hμ hSpectralBudget
      hOperatorBudget hRadicand hSpectralNonempty' hOperatorNonempty'

/-- `BG-RAGASA2026A-THM-025`: under explicit full-ellipse containment, restriction of the
canonical loss sets to the candidate rectangle preserves the exact intersection
criterion. -/
theorem canonicalLossAdmissibleSetsInRectangle_inter_nonempty_iff
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (lower upper : Geometry.RankTwoParameter)
    (κ spectralBudget operatorBudget : ℝ) (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorBudget : 0 ≤ operatorBudget)
    (hRadicand : κ * (1 -
      maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ ^ 2) ≤ operatorBudget ^ 2)
    (hSpectralContained : Geometry.rankTwoFullSpectralEllipse κ spectralBudget ⊆
      Geometry.rankTwoCandidateRectangle lower upper)
    (hOperatorContained : Geometry.rankTwoFullOperatorEllipse κ
      (maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ)
      (Geometry.rankTwoOperatorRadius κ
        (maximumNormalizedOperatorCorrelation
          (canonicalRankTwoPauliDecomposition data) κ) operatorBudget) ⊆
      Geometry.rankTwoCandidateRectangle lower upper) :
    (canonicalSpectralAdmissibleSetInRectangle data lower upper spectralBudget ∩
      canonicalOptimizedOperatorAdmissibleSetInRectangle
        data lower upper operatorBudget).Nonempty ↔
      Real.sqrt κ * |1 - maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ| ≤
        spectralBudget + Geometry.rankTwoOperatorRadius κ
          (maximumNormalizedOperatorCorrelation
            (canonicalRankTwoPauliDecomposition data) κ) operatorBudget := by
  let pauli := canonicalRankTwoPauliDecomposition data
  let μ := maximumNormalizedOperatorCorrelation pauli κ
  have hμ : |μ| ≤ 1 := by
    dsimp [μ, maximumNormalizedOperatorCorrelation]
    exact abs_maximumOperatorCorrelation_div_le_one pauli κ hκ hpower
  have hSpectralSet :
      canonicalSpectralAdmissibleSetInRectangle data lower upper spectralBudget =
        Geometry.rankTwoSpectralEllipseInRectangle
          lower upper κ spectralBudget := by
    ext p
    simp only [canonicalSpectralAdmissibleSetInRectangle,
      canonicalSpectralAdmissibleSet, Geometry.spectralAdmissibleSet,
      Geometry.rankTwoSpectralEllipseInRectangle,
      Geometry.rankTwoFullSpectralEllipse, Set.mem_inter_iff,
      Set.mem_ofPred_eq]
    rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data κ hpower p,
      Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hSpectralBudget p]
  have hOperatorSet :
      canonicalOptimizedOperatorAdmissibleSetInRectangle
          data lower upper operatorBudget =
        Geometry.rankTwoOperatorEllipseInRectangle lower upper κ μ
          (Geometry.rankTwoOperatorRadius κ μ operatorBudget) := by
    ext p
    simp only [canonicalOptimizedOperatorAdmissibleSetInRectangle,
      canonicalOptimizedOperatorAdmissibleSet,
      Geometry.alignedOperatorAdmissibleSet,
      Geometry.rankTwoOperatorEllipseInRectangle,
      Geometry.rankTwoFullOperatorEllipse, Set.mem_inter_iff,
      Set.mem_ofPred_eq]
    rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss
        data κ hκ hpower p,
      Geometry.rankTwoAlignedOperatorLoss_le_iff_ellipse
        hκ.le hμ hOperatorBudget hRadicand p]
  rw [hSpectralSet, hOperatorSet]
  exact Geometry.rankTwoEllipsesInRectangle_inter_nonempty_iff
    hκ hSpectralBudget (Real.sqrt_nonneg _)
    hSpectralContained hOperatorContained

/-- `BG-RAGASA2026A-THM-026`: under explicit full-ellipse containment, candidate-rectangle
restriction preserves the exact distance formula for the canonical loss sets. -/
theorem canonicalLossAdmissibleSetsInRectangle_admissibleSetDist_eq
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I)
    (lower upper : Geometry.RankTwoParameter)
    (κ spectralBudget operatorBudget : ℝ) (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorBudget : 0 ≤ operatorBudget)
    (hRadicand : κ * (1 -
      maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ ^ 2) ≤ operatorBudget ^ 2)
    (hSpectralContained : Geometry.rankTwoFullSpectralEllipse κ spectralBudget ⊆
      Geometry.rankTwoCandidateRectangle lower upper)
    (hOperatorContained : Geometry.rankTwoFullOperatorEllipse κ
      (maximumNormalizedOperatorCorrelation
        (canonicalRankTwoPauliDecomposition data) κ)
      (Geometry.rankTwoOperatorRadius κ
        (maximumNormalizedOperatorCorrelation
          (canonicalRankTwoPauliDecomposition data) κ) operatorBudget) ⊆
      Geometry.rankTwoCandidateRectangle lower upper)
    (hSpectralNonempty :
      (canonicalSpectralAdmissibleSetInRectangle
        data lower upper spectralBudget).Nonempty)
    (hOperatorNonempty :
      (canonicalOptimizedOperatorAdmissibleSetInRectangle
        data lower upper operatorBudget).Nonempty) :
    Geometry.admissibleSetDist
      (canonicalSpectralAdmissibleSetInRectangle
        data lower upper spectralBudget)
      (canonicalOptimizedOperatorAdmissibleSetInRectangle
        data lower upper operatorBudget)
      hSpectralNonempty hOperatorNonempty =
        Geometry.rankTwoFullEllipseDistance κ
          (maximumNormalizedOperatorCorrelation
            (canonicalRankTwoPauliDecomposition data) κ)
          spectralBudget
          (Geometry.rankTwoOperatorRadius κ
            (maximumNormalizedOperatorCorrelation
              (canonicalRankTwoPauliDecomposition data) κ) operatorBudget) := by
  let pauli := canonicalRankTwoPauliDecomposition data
  let μ := maximumNormalizedOperatorCorrelation pauli κ
  have hμ : |μ| ≤ 1 := by
    dsimp [μ, maximumNormalizedOperatorCorrelation]
    exact abs_maximumOperatorCorrelation_div_le_one pauli κ hκ hpower
  have hSpectralSet :
      canonicalSpectralAdmissibleSetInRectangle data lower upper spectralBudget =
        Geometry.rankTwoSpectralEllipseInRectangle
          lower upper κ spectralBudget := by
    ext p
    simp only [canonicalSpectralAdmissibleSetInRectangle,
      canonicalSpectralAdmissibleSet, Geometry.spectralAdmissibleSet,
      Geometry.rankTwoSpectralEllipseInRectangle,
      Geometry.rankTwoFullSpectralEllipse, Set.mem_inter_iff,
      Set.mem_ofPred_eq]
    rw [canonicalSpectralLoss_eq_rankTwoSpectralLoss data κ hpower p,
      Geometry.rankTwoSpectralLoss_le_iff_ellipse hκ.le hSpectralBudget p]
  have hOperatorSet :
      canonicalOptimizedOperatorAdmissibleSetInRectangle
          data lower upper operatorBudget =
        Geometry.rankTwoOperatorEllipseInRectangle lower upper κ μ
          (Geometry.rankTwoOperatorRadius κ μ operatorBudget) := by
    ext p
    simp only [canonicalOptimizedOperatorAdmissibleSetInRectangle,
      canonicalOptimizedOperatorAdmissibleSet,
      Geometry.alignedOperatorAdmissibleSet,
      Geometry.rankTwoOperatorEllipseInRectangle,
      Geometry.rankTwoFullOperatorEllipse, Set.mem_inter_iff,
      Set.mem_ofPred_eq]
    rw [canonicalOptimizedOperatorLoss_eq_rankTwoAlignedOperatorLoss
        data κ hκ hpower p,
      Geometry.rankTwoAlignedOperatorLoss_le_iff_ellipse
        hκ.le hμ hOperatorBudget hRadicand p]
  have hSpectralNonempty' :
      (Geometry.rankTwoSpectralEllipseInRectangle
        lower upper κ spectralBudget).Nonempty :=
    hSpectralSet ▸ hSpectralNonempty
  have hOperatorNonempty' :
      (Geometry.rankTwoOperatorEllipseInRectangle lower upper κ μ
        (Geometry.rankTwoOperatorRadius κ μ operatorBudget)).Nonempty :=
    hOperatorSet ▸ hOperatorNonempty
  dsimp [μ, pauli] at hOperatorSet hOperatorNonempty'
  simpa only [hSpectralSet, hOperatorSet,
    Geometry.rankTwoOperatorRadius] using
    Geometry.rankTwoEllipsesInRectangle_admissibleSetDist_eq
      hκ hSpectralBudget (Real.sqrt_nonneg _)
      hSpectralContained hOperatorContained
      hSpectralNonempty' hOperatorNonempty'

end ProjectKoios.BandGauge.Papers.Ragasa2026A

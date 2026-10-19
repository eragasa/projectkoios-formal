module

public import ProjectKoios.BandGauge.Bloch.PeriodicRankTwo
public import ProjectKoios.BandGauge.Foundations.RankTwoRotation
public import ProjectKoios.BandGauge.Hilbert.OperatorLossBridge
public import ProjectKoios.BandGauge.Hilbert.SpectralLossBridge
public import Mathlib.Analysis.Matrix.Spectrum

/-!
# Ragasa2026A rank-two aligned fields

This thin module names the paper-specific fields `D_{i,φ}` and `B_i` using the declared
global real rotation and a supplied momentum-dependent comparison alignment. It proves
conditional algebraic consequences only. It does not construct Bloch data from a
periodic potential or validate publication data numerically.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Papers.Ragasa2026A

open ProjectKoios.BandGauge

/-- `BG-RAGASA2026A-DEF-001`: the abstract finite sampled parent and the paper's supplied
momentum-dependent comparison alignment. The global candidate alignment is fixed below
to the source's real rotation family. -/
structure RankTwoFieldContract
    (Γ K I : Type*) [Group Γ] [MulAction Γ K] [Fintype I] where
  periodic : Bloch.PeriodicRankTwoBlochSampleData Γ K I
  weight_pos : ∀ i, 0 < periodic.weight i
  comparisonAlignment : I → Matrix.unitaryGroup (Fin 2) ℂ

/-- `BG-RAGASA2026A-DEF-002`: the paper's globally rotated candidate splitting field
`D_{i,φ} = R(φ)† D(q_i) R(φ)`. -/
noncomputable def candidateSplittingField
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (φ : ℝ) :
    Hilbert.RankTwoMatrixField I :=
  Bloch.unitaryConjugateRankTwoField
    (Bloch.sampledCenteredField data.periodic)
    (fun _ => Foundations.rankTwoRealRotation φ)

/-- `BG-RAGASA2026A-DEF-003`: the paper's momentum-dependently aligned comparison field
`B_i = U(q_i)† D(q_i) U(q_i)`. -/
noncomputable def comparisonSplittingField
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) :
    Hilbert.RankTwoMatrixField I :=
  Bloch.unitaryConjugateRankTwoField
    (Bloch.sampledCenteredField data.periodic) data.comparisonAlignment

/-- `BG-RAGASA2026A-DEF-004`: the source-normalized real Frobenius correlation `b_φ`
between the globally rotated candidate and comparison fields. -/
noncomputable def operatorCorrelation
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (φ : ℝ) : ℝ :=
  Hilbert.rankTwoWeightedFrobeniusCorrelation
    data.periodic.weight data.periodic.energyRef
    (candidateSplittingField data φ) (comparisonSplittingField data)

/-- `BG-RAGASA2026A-THM-001`: both paper-specific aligned splitting fields are pointwise
traceless. -/
theorem alignedSplittingFields_traceless
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (φ : ℝ) :
    (∀ i, Matrix.trace (candidateSplittingField data φ i) = 0) ∧
      ∀ i, Matrix.trace (comparisonSplittingField data i) = 0 := by
  constructor
  · intro i
    exact Bloch.trace_unitaryConjugateRankTwoField_eq_zero
      (Bloch.sampledCenteredField data.periodic)
      (fun _ => Foundations.rankTwoRealRotation φ)
      (Bloch.trace_sampledCenteredField_eq_zero data.periodic) i
  · intro i
    exact Bloch.trace_unitaryConjugateRankTwoField_eq_zero
      (Bloch.sampledCenteredField data.periodic) data.comparisonAlignment
      (Bloch.trace_sampledCenteredField_eq_zero data.periodic) i

/-- `BG-RAGASA2026A-THM-002`: if the sampled centered parent has power `κ`, then
`D_{i,φ}` and `B_i` have that same weighted Frobenius power. -/
theorem alignedSplittingFields_commonPower
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (φ κ : ℝ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ) :
    Hilbert.rankTwoWeightedFrobeniusSq
        data.periodic.weight data.periodic.energyRef
        (candidateSplittingField data φ) = κ ∧
      Hilbert.rankTwoWeightedFrobeniusSq
        data.periodic.weight data.periodic.energyRef
        (comparisonSplittingField data) = κ := by
  exact Bloch.unitaryConjugateSampledFields_commonPower data.periodic
    (fun _ => Foundations.rankTwoRealRotation φ) data.comparisonAlignment κ hpower

/-- `BG-RAGASA2026A-THM-003`: the exact paper-specific aligned-field correlation obeys
`|b_φ| ≤ κ` when the sampled centered parent has weighted power `κ`. -/
theorem abs_operatorCorrelation_le_commonPower
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (φ κ : ℝ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ) :
    |operatorCorrelation data φ| ≤ κ := by
  exact Bloch.abs_unitaryConjugateSampledFields_correlation_le_commonPower
    data.periodic (fun _ => Foundations.rankTwoRealRotation φ)
    data.comparisonAlignment κ hpower

/-- `BG-RAGASA2026A-THM-004`: under the explicit sampled-parent power hypothesis, the
paper-specific matrix residual loss equals the existing reduced scalar aligned-operator
loss with normalized correlation `b_φ / κ`. -/
theorem operatorMatrixLossSq_eq_alignedOperatorLossSq
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (φ κ : ℝ)
    (hκ : 0 < κ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (p : Geometry.RankTwoParameter) :
    Hilbert.rankTwoOperatorMatrixLossSq
        data.periodic.weight data.periodic.energyRef (p 0) (p 1)
        (candidateSplittingField data φ) (comparisonSplittingField data) =
      Geometry.rankTwoAlignedOperatorLossSq κ
        (Geometry.rankTwoNormalizedCorrelation κ (operatorCorrelation data φ)) p := by
  obtain ⟨htraceD, htraceB⟩ := alignedSplittingFields_traceless data φ
  obtain ⟨hpowerD, hpowerB⟩ :=
    alignedSplittingFields_commonPower data φ κ hpower
  exact Hilbert.rankTwoOperatorMatrixLossSq_eq_rankTwoAlignedOperatorLossSq
    data.periodic.weight data.periodic.energyRef κ (operatorCorrelation data φ)
    (candidateSplittingField data φ) (comparisonSplittingField data)
    data.periodic.weight_sum_one data.periodic.energyRef_pos.ne' hκ
    htraceD htraceB hpowerD hpowerB rfl p

/-- `BG-RAGASA2026A-DEF-005`: an exact finite unitary diagonalization witness for the
sampled centered parent matrices. Supplying this witness is distinct from trusting an
external floating-point eigensolver. -/
structure RankTwoSpectralDecomposition
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) where
  eigenvalue : I → Fin 2 → ℝ
  diagonalizer : I → Matrix.unitaryGroup (Fin 2) ℂ
  diagonalizes : ∀ i,
    Bloch.unitaryConjugateRankTwoField
        (Bloch.sampledCenteredField data.periodic) diagonalizer i =
      Matrix.diagonal (fun n => (eigenvalue i n : ℂ))

/-- `BG-RAGASA2026A-DEF-015`: the canonical noncomputable exact spectral decomposition
provided by the finite-dimensional Hermitian spectral theorem. This is an exact existence
construction, not a floating-point eigensolver or numerical certificate. -/
noncomputable def canonicalRankTwoSpectralDecomposition
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) : RankTwoSpectralDecomposition data := by
  let hHermitian : ∀ i, Matrix.IsHermitian
      (Bloch.sampledCenteredField data.periodic i) :=
    Bloch.sampledCenteredField_conjTranspose_eq_self data.periodic
  exact {
    eigenvalue := fun i => (hHermitian i).eigenvalues
    diagonalizer := fun i => (hHermitian i).eigenvectorUnitary
    diagonalizes := fun i => by
      calc
        Bloch.unitaryConjugateRankTwoField
            (Bloch.sampledCenteredField data.periodic)
            (fun j => (hHermitian j).eigenvectorUnitary) i =
          Matrix.diagonal
            (Complex.ofReal ∘ (hHermitian i).eigenvalues) := by
              simpa [Bloch.unitaryConjugateRankTwoField,
                Matrix.star_eq_conjTranspose] using
                (Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary
                  (hHermitian i))
        _ = Matrix.diagonal (fun n => ((hHermitian i).eigenvalues n : ℂ)) := by
          rfl
  }

/-- `BG-RAGASA2026A-DEF-006`: the real two-state spectral splitting field extracted from
an exact finite diagonalization witness. -/
def spectralSplittingField
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (decomposition : RankTwoSpectralDecomposition data) :
    Hilbert.RankTwoSpectralField I :=
  decomposition.eigenvalue

/-- `BG-RAGASA2026A-THM-005`: exact diagonalization of the trace-centered parent makes
the two real spectral deviations sum to zero at every construction coordinate. -/
theorem spectralSplittingField_centered
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (decomposition : RankTwoSpectralDecomposition data) (i : I) :
    ∑ n, spectralSplittingField decomposition i n = 0 := by
  have htrace : Matrix.trace
      (Bloch.unitaryConjugateRankTwoField
        (Bloch.sampledCenteredField data.periodic)
        decomposition.diagonalizer i) = 0 :=
    Bloch.trace_unitaryConjugateRankTwoField_eq_zero
      (Bloch.sampledCenteredField data.periodic) decomposition.diagonalizer
      (Bloch.trace_sampledCenteredField_eq_zero data.periodic) i
  rw [decomposition.diagonalizes i] at htrace
  simpa [spectralSplittingField, Matrix.trace, Fin.sum_univ_two] using
    congrArg Complex.re htrace

/-- `BG-RAGASA2026A-THM-006`: exact unitary diagonalization identifies the weighted
spectral power with the weighted Frobenius power of the sampled centered parent. -/
theorem spectralSplittingField_power_eq_parent
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (decomposition : RankTwoSpectralDecomposition data) :
    Hilbert.rankTwoWeightedSpectralPower
        data.periodic.weight data.periodic.energyRef
        (spectralSplittingField decomposition) =
      Hilbert.rankTwoWeightedFrobeniusSq
        data.periodic.weight data.periodic.energyRef
        (Bloch.sampledCenteredField data.periodic) := by
  have hfield :
      Bloch.unitaryConjugateRankTwoField
          (Bloch.sampledCenteredField data.periodic)
          decomposition.diagonalizer =
        fun i => Matrix.diagonal
          (fun n => (spectralSplittingField decomposition i n : ℂ)) := by
    funext i
    exact decomposition.diagonalizes i
  calc
    Hilbert.rankTwoWeightedSpectralPower
        data.periodic.weight data.periodic.energyRef
        (spectralSplittingField decomposition) =
      Hilbert.rankTwoWeightedFrobeniusSq
        data.periodic.weight data.periodic.energyRef
        (fun i => Matrix.diagonal
          (fun n => (spectralSplittingField decomposition i n : ℂ))) := by
      rw [Hilbert.rankTwoWeightedSpectralPower,
        Hilbert.rankTwoWeightedFrobeniusSq, Fintype.sum_prod_type,
        Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro i hi
      rw [Fintype.sum_prod_type]
      simp [Matrix.diagonal_apply, Fin.sum_univ_two]
    _ = Hilbert.rankTwoWeightedFrobeniusSq
        data.periodic.weight data.periodic.energyRef
        (Bloch.unitaryConjugateRankTwoField
          (Bloch.sampledCenteredField data.periodic)
          decomposition.diagonalizer) := by rw [hfield]
    _ = Hilbert.rankTwoWeightedFrobeniusSq
        data.periodic.weight data.periodic.energyRef
        (Bloch.sampledCenteredField data.periodic) :=
      Bloch.sampledCenteredField_power_unitaryConjugate
        data.periodic decomposition.diagonalizer

/-- `BG-RAGASA2026A-THM-007`: an exact diagonalization witness and parent power `κ`
identify the source finite spectral residual loss with the reduced scalar spectral loss. -/
theorem spectralFieldLossSq_eq_spectralLossSq
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    {data : RankTwoFieldContract Γ K I}
    (decomposition : RankTwoSpectralDecomposition data) (κ : ℝ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (p : Geometry.RankTwoParameter) :
    Hilbert.rankTwoSpectralFieldLossSq
        data.periodic.weight data.periodic.energyRef (p 0) (p 1)
        (spectralSplittingField decomposition) =
      Geometry.rankTwoSpectralLossSq κ p := by
  apply Hilbert.rankTwoSpectralFieldLossSq_eq_rankTwoSpectralLossSq
    data.periodic.weight data.periodic.energyRef κ
    (spectralSplittingField decomposition)
    data.periodic.weight_sum_one data.periodic.energyRef_pos.ne'
    (spectralSplittingField_centered decomposition)
  rw [spectralSplittingField_power_eq_parent decomposition, hpower]

/-- `BG-RAGASA2026A-THM-018`: the canonical Hermitian spectral decomposition yields a
pointwise centered real two-state spectral field without a supplied diagonalization
witness. -/
theorem canonicalSpectralSplittingField_centered
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (i : I) :
    ∑ n, spectralSplittingField
      (canonicalRankTwoSpectralDecomposition data) i n = 0 := by
  exact spectralSplittingField_centered
    (canonicalRankTwoSpectralDecomposition data) i

/-- `BG-RAGASA2026A-THM-019`: the canonical real spectral field has exactly the weighted
Frobenius power of the sampled centered parent. -/
theorem canonicalSpectralSplittingField_power_eq_parent
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) :
    Hilbert.rankTwoWeightedSpectralPower
        data.periodic.weight data.periodic.energyRef
        (spectralSplittingField (canonicalRankTwoSpectralDecomposition data)) =
      Hilbert.rankTwoWeightedFrobeniusSq
        data.periodic.weight data.periodic.energyRef
        (Bloch.sampledCenteredField data.periodic) := by
  exact spectralSplittingField_power_eq_parent
    (canonicalRankTwoSpectralDecomposition data)

/-- `BG-RAGASA2026A-THM-020`: the canonical exact spectral field identifies the source
finite spectral residual loss with the reduced scalar spectral loss. -/
theorem canonicalSpectralFieldLossSq_eq_spectralLossSq
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : RankTwoFieldContract Γ K I) (κ : ℝ)
    (hpower : Hilbert.rankTwoWeightedFrobeniusSq
      data.periodic.weight data.periodic.energyRef
      (Bloch.sampledCenteredField data.periodic) = κ)
    (p : Geometry.RankTwoParameter) :
    Hilbert.rankTwoSpectralFieldLossSq
        data.periodic.weight data.periodic.energyRef (p 0) (p 1)
        (spectralSplittingField (canonicalRankTwoSpectralDecomposition data)) =
      Geometry.rankTwoSpectralLossSq κ p := by
  exact spectralFieldLossSq_eq_spectralLossSq
    (canonicalRankTwoSpectralDecomposition data) κ hpower p

end ProjectKoios.BandGauge.Papers.Ragasa2026A

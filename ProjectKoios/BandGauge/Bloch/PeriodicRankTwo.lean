module

public import ProjectKoios.BandGauge.Bloch.Sewing
public import ProjectKoios.BandGauge.Hilbert.WeightedFrobenius

/-!
# Finite samples of an abstract periodic rank-two Bloch family

This module defines a narrow interface between pointwise Bloch sewing and the finite
rank-two matrix fields used by the loss formalization. It does not prove the
Bloch--Floquet theorem or construct these data from a periodic potential. Such an
analytic construction is a separate future bridge.
-/

open scoped BigOperators ComplexConjugate Matrix
open Finset

@[expose] public section

namespace ProjectKoios.BandGauge.Bloch

/-- `BG-BLOCH-DEF-006`: the standard complex retained rank-two fiber. -/
abbrev RetainedFiber := EuclideanSpace ℂ (Fin 2)

/-- `BG-BLOCH-DEF-007`: the matrix of a continuous linear operator on the standard
retained rank-two fiber. The entry convention is `⟪e_m, A e_n⟫`. -/
noncomputable def rankTwoMatrixOfOperator
    (A : RetainedFiber →L[ℂ] RetainedFiber) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun m n => inner ℂ (EuclideanSpace.single m 1) (A (EuclideanSpace.single n 1))

/-- `BG-BLOCH-DEF-008`: an abstract periodic rank-two Bloch Hamiltonian together with a
finite weighted construction sample. This is an interface to, not a proof of, a
Bloch--Floquet construction from a periodic potential. -/
structure PeriodicRankTwoBlochSampleData
    (Γ K I : Type*) [Group Γ] [MulAction Γ K] [Fintype I] where
  sewing : SewingData Γ K RetainedFiber
  hamiltonian : K → RetainedFiber →L[ℂ] RetainedFiber
  hamiltonian_covariant : IsBlochOperatorField sewing hamiltonian
  hamiltonian_hermitian : ∀ k,
    (rankTwoMatrixOfOperator (hamiltonian k))ᴴ =
      rankTwoMatrixOfOperator (hamiltonian k)
  samplePoint : I → K
  weight : I → ℝ
  weight_nonneg : ∀ i, 0 ≤ weight i
  weight_sum_one : ∑ i, weight i = 1
  energyRef : ℝ
  energyRef_pos : 0 < energyRef

/-- `BG-BLOCH-DEF-009`: the trace-centered retained Bloch Hamiltonian matrix. -/
noncomputable def centeredBlochMatrix
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I) (k : K) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  let H := rankTwoMatrixOfOperator (data.hamiltonian k)
  H - (Matrix.trace H / 2) • (1 : Matrix (Fin 2) (Fin 2) ℂ)

/-- `BG-BLOCH-DEF-010`: the centered rank-two matrix field at the declared finite
construction coordinates. -/
noncomputable def sampledCenteredField
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I) :
    ProjectKoios.BandGauge.Hilbert.RankTwoMatrixField I :=
  fun i => centeredBlochMatrix data (data.samplePoint i)

/-- `BG-BLOCH-DEF-011`: pointwise unitary conjugation of a retained rank-two matrix
field, with the source orientation `U† D U`. -/
def unitaryConjugateRankTwoField
    {I : Type*} (D : ProjectKoios.BandGauge.Hilbert.RankTwoMatrixField I)
    (U : I → Matrix.unitaryGroup (Fin 2) ℂ) :
    ProjectKoios.BandGauge.Hilbert.RankTwoMatrixField I :=
  fun i => (U i : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * D i *
    (U i : Matrix (Fin 2) (Fin 2) ℂ)

/-- `BG-BLOCH-THM-009`: trace centering preserves Hermiticity of every retained
rank-two Bloch Hamiltonian matrix. -/
theorem centeredBlochMatrix_conjTranspose_eq_self
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I) (k : K) :
    (centeredBlochMatrix data k)ᴴ = centeredBlochMatrix data k := by
  let H := rankTwoMatrixOfOperator (data.hamiltonian k)
  have hH : Hᴴ = H := data.hamiltonian_hermitian k
  have htrace : conj (Matrix.trace H) = Matrix.trace H := by
    calc
      conj (Matrix.trace H) = Matrix.trace Hᴴ := by
        exact (Matrix.trace_conjTranspose H).symm
      _ = Matrix.trace H := by rw [hH]
  rw [centeredBlochMatrix]
  change (H - (Matrix.trace H / 2) • (1 : Matrix (Fin 2) (Fin 2) ℂ))ᴴ =
    H - (Matrix.trace H / 2) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
  rw [Matrix.conjTranspose_sub, hH]
  ext i j
  simp [htrace]

/-- `BG-BLOCH-THM-010`: the sampled centered field is pointwise Hermitian. -/
theorem sampledCenteredField_conjTranspose_eq_self
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I) (i : I) :
    (sampledCenteredField data i)ᴴ = sampledCenteredField data i := by
  exact centeredBlochMatrix_conjTranspose_eq_self data (data.samplePoint i)

/-- `BG-BLOCH-THM-011`: pointwise unitary conjugation preserves Hermiticity. -/
theorem unitaryConjugateRankTwoField_conjTranspose_eq_self
    {I : Type*} (D : ProjectKoios.BandGauge.Hilbert.RankTwoMatrixField I)
    (U : I → Matrix.unitaryGroup (Fin 2) ℂ) (hD : ∀ i, (D i)ᴴ = D i) (i : I) :
    (unitaryConjugateRankTwoField D U i)ᴴ =
      unitaryConjugateRankTwoField D U i := by
  simp [unitaryConjugateRankTwoField, Matrix.conjTranspose_mul, hD i, mul_assoc]

/-- `BG-BLOCH-THM-003`: trace centering makes every retained Bloch Hamiltonian matrix
traceless. -/
theorem trace_centeredBlochMatrix_eq_zero
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I) (k : K) :
    Matrix.trace (centeredBlochMatrix data k) = 0 := by
  rw [centeredBlochMatrix]
  simp [Matrix.trace, Fin.sum_univ_two]
  ring

/-- `BG-BLOCH-THM-004`: the sampled centered matrix field is pointwise traceless. -/
theorem trace_sampledCenteredField_eq_zero
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I) (i : I) :
    Matrix.trace (sampledCenteredField data i) = 0 := by
  exact trace_centeredBlochMatrix_eq_zero data (data.samplePoint i)

/-- `BG-BLOCH-THM-005`: unitary conjugation preserves pointwise tracelessness. -/
theorem trace_unitaryConjugateRankTwoField_eq_zero
    {I : Type*}
    (D : ProjectKoios.BandGauge.Hilbert.RankTwoMatrixField I)
    (U : I → Matrix.unitaryGroup (Fin 2) ℂ)
    (htrace : ∀ i, Matrix.trace (D i) = 0) (i : I) :
    Matrix.trace (unitaryConjugateRankTwoField D U i) = 0 := by
  rw [unitaryConjugateRankTwoField]
  calc
    Matrix.trace ((U i : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * D i *
        (U i : Matrix (Fin 2) (Fin 2) ℂ)) =
        Matrix.trace ((U i : Matrix (Fin 2) (Fin 2) ℂ) *
          (U i : Matrix (Fin 2) (Fin 2) ℂ)ᴴ * D i) := by
      exact Matrix.trace_mul_cycle _ _ _
    _ = Matrix.trace (D i) := by
      rw [show (U i : Matrix (Fin 2) (Fin 2) ℂ) *
          (U i : Matrix (Fin 2) (Fin 2) ℂ)ᴴ = 1 by
        exact Matrix.mem_unitaryGroup_iff.mp (U i).property]
      simp
    _ = 0 := htrace i

/-- `BG-BLOCH-THM-006`: pointwise unitary conjugation of the sampled centered field
preserves its source-normalized weighted Frobenius power. -/
theorem sampledCenteredField_power_unitaryConjugate
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I)
    (U : I → Matrix.unitaryGroup (Fin 2) ℂ) :
    ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusSq
        data.weight data.energyRef
        (unitaryConjugateRankTwoField (sampledCenteredField data) U) =
      ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusSq
        data.weight data.energyRef (sampledCenteredField data) := by
  exact ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusSq_unitary_conjugate
    data.weight data.energyRef (sampledCenteredField data) U

/-- `BG-BLOCH-THM-007`: two supplied unitary alignment fields applied to one sampled
centered parent field have the same declared weighted power. -/
theorem unitaryConjugateSampledFields_commonPower
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I)
    (U V : I → Matrix.unitaryGroup (Fin 2) ℂ) (κ : ℝ)
    (hpower : ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusSq
      data.weight data.energyRef (sampledCenteredField data) = κ) :
    ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusSq
        data.weight data.energyRef
        (unitaryConjugateRankTwoField (sampledCenteredField data) U) = κ ∧
      ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusSq
        data.weight data.energyRef
        (unitaryConjugateRankTwoField (sampledCenteredField data) V) = κ := by
  constructor
  · rw [sampledCenteredField_power_unitaryConjugate data U, hpower]
  · rw [sampledCenteredField_power_unitaryConjugate data V, hpower]

/-- `BG-BLOCH-THM-008`: two unitary alignment fields of one sampled centered periodic
rank-two parent have weighted correlation magnitude at most their common power `κ`. -/
theorem abs_unitaryConjugateSampledFields_correlation_le_commonPower
    {Γ K I : Type*} [Group Γ] [MulAction Γ K] [Fintype I]
    (data : PeriodicRankTwoBlochSampleData Γ K I)
    (U V : I → Matrix.unitaryGroup (Fin 2) ℂ) (κ : ℝ)
    (hpower : ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusSq
      data.weight data.energyRef (sampledCenteredField data) = κ) :
    |ProjectKoios.BandGauge.Hilbert.rankTwoWeightedFrobeniusCorrelation
      data.weight data.energyRef
      (unitaryConjugateRankTwoField (sampledCenteredField data) U)
      (unitaryConjugateRankTwoField (sampledCenteredField data) V)| ≤ κ := by
  obtain ⟨hU, hV⟩ :=
    unitaryConjugateSampledFields_commonPower data U V κ hpower
  exact ProjectKoios.BandGauge.Hilbert.abs_rankTwoWeightedFrobeniusCorrelation_le_commonPower
    data.weight data.energyRef κ
    (unitaryConjugateRankTwoField (sampledCenteredField data) U)
    (unitaryConjugateRankTwoField (sampledCenteredField data) V)
    data.weight_nonneg data.energyRef_pos.ne' hU hV

end ProjectKoios.BandGauge.Bloch

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-04
-/
module

public import ProjectKoios.BandGauge.Fourier.Gauge.FiniteRankLocalitySeparation
public import ProjectKoios.BandGauge.Fourier.Support.MetricShell

/-!
# Character-gauge locality separation on arbitrary finite meshes

This module gives an exact character-gauge witness on every nontrivial finite abelian momentum
carrier.  On two distinguished retained coordinates the gauge is the rational unitary mixer

`[[3/5, -(4/5) * conj χ(k)], [(4/5) * χ(k), 3/5]]`,

and it is the identity on an arbitrary finite complementary carrier.  Conjugating a constant block
operator with distinct first two diagonal entries preserves its pointwise complex spectrum while
creating the exact Fourier coefficient `(12/25) * (right - left)` at the selected character.
Consequently every support that retains zero but omits that character has zero omitted Frobenius
power before the gauge and strictly positive omitted power after it.

The result is finite and exact.  It does not identify runtime FFT ordering, serialized arrays,
reciprocal bases, physical distance, Wannier90 output, DFT execution, disentanglement, ordered
eigenvalues, finite-to-continuum limits, or scientific adequacy.  The retained carrier
`Fin 2 ⊕ Extra` has dimension `2 + card Extra`; “finite rank” here refers to retained-space
dimension, not algebraic matrix rank or nonsingularity.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Fourier.Gauge

open ProjectKoios.BandGauge.Alignment
open ProjectKoios.BandGauge.Fourier.FiniteAbelian
open ProjectKoios.BandGauge.Fourier.Support

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-LEM-011`: every nontrivial finite abelian group admits a nonzero complex
additive character. -/
lemma exists_nonzero_complexAddChar [Nontrivial G] :
    ∃ character : AddChar G ℂ, character ≠ 0 := by
  obtain ⟨momentum, hmomentum⟩ := exists_ne (0 : G)
  obtain ⟨character, hcharacter⟩ :=
    (AddChar.exists_apply_ne_zero (α := G) (a := momentum)).2 hmomentum
  refine ⟨character, ?_⟩
  intro hzero
  apply hcharacter
  rw [hzero]
  simp

/-- `BG-FOURIER-GAUGE-DEF-008`: exact rational two-coordinate character mixer before it is
packaged with its unitary proof. -/
noncomputable def rankTwoCharacterMixerMatrix
    (character : AddChar G ℂ) (momentum : G) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(3 : ℂ) / 5, -((4 : ℂ) / 5) * conj (character momentum);
     ((4 : ℂ) / 5) * character momentum, (3 : ℂ) / 5]

omit [DecidableEq G] in
private lemma rankTwoCharacterMixerMatrix_unitary
    (character : AddChar G ℂ) (momentum : G) :
    rankTwoCharacterMixerMatrix character momentum ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  rw [Matrix.mem_unitaryGroup_iff]
  have hcharacter : character momentum ≠ 0 := by
    intro hzero
    have hnorm := AddChar.norm_apply character momentum
    rw [hzero, norm_zero] at hnorm
    norm_num at hnorm
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rankTwoCharacterMixerMatrix, Matrix.mul_apply, Fin.sum_univ_two]
  all_goals simp only [map_ofNat]
  all_goals try rw [← AddChar.inv_apply_eq_conj]
  all_goals field_simp [hcharacter]
  all_goals ring

/-- `BG-FOURIER-GAUGE-DEF-009`: exact character-dependent unitary mixer on two retained
coordinates, extended by the identity on an arbitrary finite complementary carrier. -/
noncomputable def finiteRankCharacterMixer
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (momentum : G) :
    Matrix.unitaryGroup (Fin 2 ⊕ Extra) ℂ :=
  ⟨Matrix.fromBlocks (rankTwoCharacterMixerMatrix character momentum) 0 0 1, by
    rw [Matrix.mem_unitaryGroup_iff, Matrix.star_eq_conjTranspose]
    rw [Matrix.fromBlocks_conjTranspose, Matrix.fromBlocks_multiply]
    have hunitary := rankTwoCharacterMixerMatrix_unitary character momentum
    rw [Matrix.mem_unitaryGroup_iff, Matrix.star_eq_conjTranspose] at hunitary
    simp [hunitary, ← Matrix.fromBlocks_one]⟩

/-- `BG-FOURIER-GAUGE-DEF-010`: diagonal operator on the two distinguished retained
coordinates. -/
def rankTwoDiagonalOperator (left right : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![left, 0; 0, right]

/-- `BG-FOURIER-GAUGE-DEF-011`: constant block operator with two distinguished diagonal entries
and an arbitrary finite complementary block. -/
def finiteRankCharacterParentOperator
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ) :
    Matrix (Fin 2 ⊕ Extra) (Fin 2 ⊕ Extra) ℂ :=
  Matrix.fromBlocks (rankTwoDiagonalOperator left right) 0 0 remainder

/-- `BG-FOURIER-GAUGE-DEF-012`: constant arbitrary-finite-rank parent field on a supplied finite
abelian momentum carrier. -/
def finiteRankCharacterConstantParentField
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ) (_ : G) :
    Matrix (Fin 2 ⊕ Extra) (Fin 2 ⊕ Extra) ℂ :=
  finiteRankCharacterParentOperator left right remainder

/-- `BG-FOURIER-GAUGE-DEF-013`: pointwise character-gauged finite-rank parent field. -/
noncomputable def finiteRankCharacterGaugedParentField
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (left right : ℂ) (remainder : Matrix Extra Extra ℂ) :
    G → Matrix (Fin 2 ⊕ Extra) (Fin 2 ⊕ Extra) ℂ :=
  pointwiseUnitaryConjugation (fun momentum => finiteRankCharacterMixer character momentum)
    (finiteRankCharacterConstantParentField left right remainder)

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-LEM-012`: a single nonzero matrix entry in an omitted coefficient forces
strictly positive omitted entrywise Frobenius power. -/
lemma omittedMatrixFrobeniusPower_pos_of_entry
    {m n : Type*} [Fintype m] [Fintype n]
    {coefficients : AddChar G ℂ → Matrix m n ℂ}
    {support : Finset (AddChar G ℂ)} {mode : AddChar G ℂ} {row : m} {column : n}
    (hmode : mode ∈ supportᶜ) (hentry : coefficients mode row column ≠ 0) :
    0 < omittedMatrixFrobeniusPower coefficients support := by
  rw [omittedMatrixFrobeniusPower]
  apply Finset.sum_pos'
  · intro mode' hmode'
    apply Finset.sum_nonneg
    intro row' hrow'
    apply Finset.sum_nonneg
    intro column' hcolumn'
    positivity
  · refine ⟨mode, hmode, ?_⟩
    apply Finset.sum_pos'
    · intro row' hrow'
      apply Finset.sum_nonneg
      intro column' hcolumn'
      positivity
    · refine ⟨row, Finset.mem_univ row, ?_⟩
      apply Finset.sum_pos'
      · intro column' hcolumn'
        positivity
      · refine ⟨column, Finset.mem_univ column, ?_⟩
        exact sq_pos_of_ne_zero (norm_ne_zero_iff.mpr hentry)

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-LEM-013`: the lower-left distinguished matrix entry of the gauged parent is
exactly a scalar multiple of the selected character. -/
lemma finiteRankCharacterGaugedParentField_entry
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (momentum : G) :
    finiteRankCharacterGaugedParentField character left right remainder momentum
        (Sum.inl 1) (Sum.inl 0) =
      ((12 : ℂ) / 25) * (right - left) * character momentum := by
  simp [finiteRankCharacterGaugedParentField, pointwiseUnitaryConjugation,
    finiteRankCharacterMixer, finiteRankCharacterConstantParentField,
    finiteRankCharacterParentOperator, Matrix.fromBlocks_conjTranspose,
    Matrix.fromBlocks_multiply, rankTwoCharacterMixerMatrix, rankTwoDiagonalOperator,
    Matrix.mul_apply, Fin.sum_univ_two]
  simp only [map_ofNat]
  ring

omit [DecidableEq G] in
private theorem finiteFourierCoefficient_constant
    {V : Type*} [AddCommMonoid V] [Module ℂ V]
    (value : V) (mode : AddChar G ℂ) :
    finiteFourierCoefficient (fun _ : G => value) mode =
      if mode = 0 then value else 0 := by
  rw [finiteFourierCoefficient]
  simp_rw [← Finset.sum_smul]
  rw [smul_smul]
  have h := finiteCharacterOrthogonality mode 0
  simp only [AddChar.zero_apply, mul_one] at h
  rw [h]
  split_ifs <;> simp

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-THM-015`: the selected character coefficient has the exact distinguished
entry `(12/25) * (right - left)`. -/
theorem finiteFourierCoefficient_finiteRankCharacterGaugedParentField_entry
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (left right : ℂ) (remainder : Matrix Extra Extra ℂ) :
    finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField character left right remainder) character
        (Sum.inl 1) (Sum.inl 0) =
      ((12 : ℂ) / 25) * (right - left) := by
  rw [finiteFourierCoefficient_apply]
  have hfield :
      (fun momentum =>
        finiteRankCharacterGaugedParentField character left right remainder momentum
          (Sum.inl 1) (Sum.inl 0)) =
      characterPhaseMultiply character
        (fun _ : G => ((12 : ℂ) / 25) * (right - left)) := by
    funext momentum
    rw [finiteRankCharacterGaugedParentField_entry]
    simp [characterPhaseMultiply, smul_eq_mul, mul_comm]
  rw [hfield, finiteFourierCoefficient_characterPhaseMultiply]
  rw [sub_self, finiteFourierCoefficient_constant]
  simp

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-THM-016`: omitting the selected character gives the gauged field strictly
positive omitted Frobenius power whenever the two distinguished parent entries differ. -/
theorem finiteRankCharacterGaugedParentField_omittedMatrixFrobeniusPower_pos
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (support : Finset (AddChar G ℂ)) (hcharacter : character ∉ support)
    (hdistinct : left ≠ right) :
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField character left right remainder)) support := by
  apply omittedMatrixFrobeniusPower_pos_of_entry (mode := character)
      (row := Sum.inl (1 : Fin 2)) (column := Sum.inl (0 : Fin 2))
  · simpa using hcharacter
  · rw [finiteFourierCoefficient_finiteRankCharacterGaugedParentField_entry]
    exact mul_ne_zero (by norm_num) (sub_ne_zero.mpr hdistinct.symm)

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-THM-017`: every support containing zero captures the full constant parent,
so its omitted Frobenius coefficient power is exactly zero. -/
theorem finiteRankCharacterConstantParentField_omittedMatrixFrobeniusPower_eq_zero
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (support : Finset (AddChar G ℂ)) (hzero : (0 : AddChar G ℂ) ∈ support) :
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField (G := G) left right remainder)) support = 0 := by
  rw [omittedMatrixFrobeniusPower]
  apply Finset.sum_eq_zero
  intro mode hmode
  have hnotmem : mode ∉ support := by simpa using hmode
  have hne : mode ≠ 0 := by
    intro hmodezero
    apply hnotmem
    simpa [hmodezero] using hzero
  have hcoeff :
      finiteFourierCoefficient
        (finiteRankCharacterConstantParentField (G := G) left right remainder) mode = 0 := by
    change finiteFourierCoefficient
      (fun _ : G => finiteRankCharacterParentOperator left right remainder) mode = 0
    rw [finiteFourierCoefficient_constant]
    simp [hne]
  rw [hcoeff]
  simp

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-THM-018`: the character mixer preserves the exact complex spectrum of the
finite-rank parent at every momentum. -/
theorem finiteRankCharacterGaugedParentField_spectrum_eq
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (momentum : G) :
    spectrum ℂ
      (finiteRankCharacterGaugedParentField character left right remainder momentum) =
    spectrum ℂ (finiteRankCharacterParentOperator left right remainder) := by
  simpa [finiteRankCharacterGaugedParentField, pointwiseUnitaryConjugation,
    finiteRankCharacterConstantParentField, rightGaugeConjugate] using
      spectrum_rightGaugeConjugate_unitary
        (finiteRankCharacterMixer character momentum)
        (finiteRankCharacterParentOperator left right remainder)

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-THM-019`: a selected omitted character gives one common exact witness of
pointwise spectrum equality and strict support-dependent locality separation on an arbitrary finite
abelian mesh. -/
theorem finiteRankCharacterGaugeLocalitySeparation
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (support : Finset (AddChar G ℂ)) (hzero : (0 : AddChar G ℂ) ∈ support)
    (hcharacter : character ∉ support) (hdistinct : left ≠ right) :
    (∀ momentum : G,
      spectrum ℂ
        (finiteRankCharacterGaugedParentField character left right remainder momentum) =
      spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField (G := G) left right remainder)) support = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField character left right remainder)) support := by
  exact ⟨finiteRankCharacterGaugedParentField_spectrum_eq character left right remainder,
    finiteRankCharacterConstantParentField_omittedMatrixFrobeniusPower_eq_zero
      left right remainder support hzero,
    finiteRankCharacterGaugedParentField_omittedMatrixFrobeniusPower_pos
      character left right remainder support hcharacter hdistinct⟩

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-THM-020`: on every nontrivial finite abelian mesh there exists a nonzero
character producing spectrum-preserving, strictly positive power outside the zero-mode support. -/
theorem exists_finiteRankCharacterGauge_zeroModeLocalitySeparation
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra] [Nontrivial G]
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ) (hdistinct : left ≠ right) :
    ∃ character : AddChar G ℂ,
      character ≠ 0 ∧
      (∀ momentum : G,
        spectrum ℂ
          (finiteRankCharacterGaugedParentField character left right remainder momentum) =
        spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
      omittedMatrixFrobeniusPower
        (finiteFourierCoefficient
          (finiteRankCharacterConstantParentField (G := G) left right remainder)) {0} = 0 ∧
      0 < omittedMatrixFrobeniusPower
        (finiteFourierCoefficient
          (finiteRankCharacterGaugedParentField character left right remainder)) {0} := by
  obtain ⟨character, hcharacter⟩ := exists_nonzero_complexAddChar (G := G)
  refine ⟨character, hcharacter, ?_⟩
  exact finiteRankCharacterGaugeLocalitySeparation character left right remainder {0}
    (by simp) (by simpa) hdistinct

omit [DecidableEq G] in
/-- `BG-FOURIER-GAUGE-THM-021`: the same separation holds for a complete finite radius shell when
zero lies inside the cutoff and the selected character lies strictly outside it. -/
theorem finiteRankCharacterGauge_metricShellLocalitySeparation
    {Extra : Type*} [Fintype Extra] [DecidableEq Extra]
    (character : AddChar G ℂ) (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (radius : AddChar G ℂ → NNReal) (cutoff : NNReal)
    (hzero : radius 0 ≤ cutoff) (hcharacter : cutoff < radius character)
    (hdistinct : left ≠ right) :
    (∀ momentum : G,
      spectrum ℂ
        (finiteRankCharacterGaugedParentField character left right remainder momentum) =
      spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField (G := G) left right remainder))
        (metricShell Finset.univ radius cutoff) = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField character left right remainder))
        (metricShell Finset.univ radius cutoff) := by
  apply finiteRankCharacterGaugeLocalitySeparation character left right remainder
  · rw [mem_metricShell]
    exact ⟨Finset.mem_univ _, hzero⟩
  · rw [mem_metricShell]
    simp only [Finset.mem_univ, true_and]
    exact not_le_of_gt hcharacter
  · exact hdistinct

end ProjectKoios.BandGauge.Fourier.Gauge

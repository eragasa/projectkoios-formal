/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-02
-/
module

public import ProjectKoios.BandGauge.Alignment.ExactGaugeConstruction
public import ProjectKoios.BandGauge.Fourier.Gauge.TruncationCounterexample
public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.MatrixFrobenius
public import ProjectKoios.BandGauge.Foundations.FiniteRankAnalyticParent
public import Mathlib.LinearAlgebra.Matrix.Swap

/-!
# Finite-rank gauge–locality separation

This module first generalizes the two-coordinate swap witness from rank two to an arbitrary finite
retained carrier. It then proves the operator-level statement: every finite-dimensional operator
changed by a supplied unitary gives a two-point gauge witness with pointwise-equal complex spectrum,
zero-mode truncation noncommutation, and positive omitted Fourier power. The exact diagonal
`Fin N` analytic parent for every `N ≥ 2` and admissible `parentScale ∈ [0, 1]` supplies a concrete
N-band instance because its first two retained energies are strictly ordered.

All statements concern exact finite groups and exact complex matrices. The analytic-parent instance
fixes one exact structure-factor value. The results do not assert matrix rank, ordered eigenvalue
equality, multiplicity bookkeeping, continuum locality or decay, finite-to-continuum control,
runtime-array correctness, eigensolver behavior, or scientific adequacy.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Fourier.Gauge

open ProjectKoios.BandGauge.Alignment
open ProjectKoios.BandGauge.Fourier.FiniteAbelian

variable {Retained : Type*} [Fintype Retained] [DecidableEq Retained]

/-- `BG-FOURIER-GAUGE-DEF-001`: the coordinate-swap permutation matrix, packaged with its exact
unitarity proof on an arbitrary finite retained carrier. -/
noncomputable def finiteRankSwapUnitary (left right : Retained) :
    Matrix.unitaryGroup Retained ℂ :=
  ⟨Matrix.swap ℂ left right, by
    rw [Matrix.mem_unitaryGroup_iff']
    change (Matrix.swap ℂ left right)ᴴ * Matrix.swap ℂ left right = 1
    rw [Matrix.conjTranspose_swap, Matrix.swap_mul_self]⟩

/-- `BG-FOURIER-GAUGE-DEF-002`: the rank-one coordinate projector associated with a retained
coordinate. -/
def finiteRankCoordinateProjector (coordinate : Retained) : Matrix Retained Retained ℂ :=
  fun row column => if row = coordinate ∧ column = coordinate then 1 else 0

private lemma swap_mul_apply
    (left right : Retained) (matrix : Matrix Retained Retained ℂ) (row column : Retained) :
    (Matrix.swap ℂ left right * matrix) row column =
      matrix (Equiv.swap left right row) column := by
  simp [Matrix.swap, PEquiv.toMatrix_toPEquiv_mul]

private lemma mul_swap_apply
    (left right : Retained) (matrix : Matrix Retained Retained ℂ) (row column : Retained) :
    (matrix * Matrix.swap ℂ left right) row column =
      matrix row (Equiv.swap left right column) := by
  simp [Matrix.swap, PEquiv.mul_toMatrix_toPEquiv]

/-- `BG-FOURIER-GAUGE-LEM-005`: conjugation by the arbitrary-finite-rank swap unitary exchanges
the selected coordinate projectors. -/
lemma finiteRankSwapConjugation_coordinateProjector (left right : Retained) :
    fixedUnitaryConjugation (finiteRankSwapUnitary left right)
        (finiteRankCoordinateProjector left) =
      finiteRankCoordinateProjector right := by
  change (Matrix.swap ℂ left right)ᴴ * finiteRankCoordinateProjector left *
      Matrix.swap ℂ left right = finiteRankCoordinateProjector right
  rw [Matrix.conjTranspose_swap]
  ext row column
  rw [mul_swap_apply, swap_mul_apply]
  have hrow : Equiv.swap left right row = left ↔ row = right := by
    rw [Equiv.swap_apply_eq_iff, Equiv.swap_apply_left]
  have hcolumn : Equiv.swap left right column = left ↔ column = right := by
    rw [Equiv.swap_apply_eq_iff, Equiv.swap_apply_left]
  simp [finiteRankCoordinateProjector, hrow, hcolumn]

omit [Fintype Retained] in
/-- `BG-FOURIER-GAUGE-LEM-006`: projectors onto distinct retained coordinates are distinct. -/
lemma finiteRankCoordinateProjector_ne
    {left right : Retained} (hdistinct : left ≠ right) :
    finiteRankCoordinateProjector left ≠ finiteRankCoordinateProjector right := by
  intro h
  have hleft := congrFun (congrFun h left) left
  simp [finiteRankCoordinateProjector, hdistinct] at hleft

/-- `BG-FOURIER-GAUGE-DEF-003`: the two-point finite-rank gauge equal to the identity at zero and
the selected coordinate swap at the other momentum. -/
noncomputable def twoPointFiniteRankSwapGauge (left right : Retained) (momentum : ZMod 2) :
    Matrix.unitaryGroup Retained ℂ :=
  if momentum = 0 then 1 else finiteRankSwapUnitary left right

/-- `BG-FOURIER-GAUGE-DEF-004`: the constant selected-coordinate projector field on `ZMod 2`. -/
def twoPointFiniteRankConstantProjectorField (coordinate : Retained) (_ : ZMod 2) :
    Matrix Retained Retained ℂ :=
  finiteRankCoordinateProjector coordinate

/-- `BG-FOURIER-GAUGE-LEM-007`: at momentum zero the finite-rank swap-gauged field remains the
left coordinate projector. -/
lemma twoPointFiniteRankSwapConjugation_at_zero (left right : Retained) :
    pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
        (twoPointFiniteRankConstantProjectorField left) 0 =
      finiteRankCoordinateProjector left := by
  simp [pointwiseUnitaryConjugation, twoPointFiniteRankSwapGauge,
    twoPointFiniteRankConstantProjectorField]

/-- `BG-FOURIER-GAUGE-LEM-008`: at momentum one the finite-rank swap-gauged field is the right
coordinate projector. -/
lemma twoPointFiniteRankSwapConjugation_at_one (left right : Retained) :
    pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
        (twoPointFiniteRankConstantProjectorField left) 1 =
      finiteRankCoordinateProjector right := by
  change fixedUnitaryConjugation (twoPointFiniteRankSwapGauge left right 1)
      (finiteRankCoordinateProjector left) = finiteRankCoordinateProjector right
  rw [show twoPointFiniteRankSwapGauge left right 1 = finiteRankSwapUnitary left right by
    simp [twoPointFiniteRankSwapGauge]]
  exact finiteRankSwapConjugation_coordinateProjector left right

/-- `BG-FOURIER-GAUGE-THM-005`: the finite-rank pointwise swap gauge preserves the exact complex
spectrum at every momentum. -/
theorem twoPointFiniteRankSwapConjugation_spectrum_eq
    (left right : Retained) (momentum : ZMod 2) :
    spectrum ℂ
        (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
          (twoPointFiniteRankConstantProjectorField left) momentum) =
      spectrum ℂ (finiteRankCoordinateProjector left) := by
  change spectrum ℂ
      (rightGaugeConjugate
        (twoPointFiniteRankSwapGauge left right momentum : Matrix Retained Retained ℂ)
        (finiteRankCoordinateProjector left)) =
    spectrum ℂ (finiteRankCoordinateProjector left)
  exact spectrum_rightGaugeConjugate_unitary
    (twoPointFiniteRankSwapGauge left right momentum) (finiteRankCoordinateProjector left)

private theorem finiteFourierCoefficient_zero_constant
    {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [AddCommMonoid V] [Module ℂ V] (value : V) :
    finiteFourierCoefficient (fun _ : G => value) 0 = value := by
  rw [finiteFourierCoefficient]
  simp only [AddChar.zero_apply, map_one, one_smul, Finset.sum_const,
    Finset.card_univ]
  rw [← Nat.cast_smul_eq_nsmul ℂ, smul_smul]
  have hcard : (Fintype.card G : ℂ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  rw [inv_mul_cancel₀ hcard, one_smul]

private theorem zeroModeFourierTruncation_constant
    {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [AddCommMonoid V] [Module ℂ V] (value : V) :
    zeroModeFourierTruncation (fun _ : G => value) = fun _ => value := by
  funext momentum
  rw [zeroModeFourierTruncation_eq_coefficient]
  exact finiteFourierCoefficient_zero_constant value

/-- `BG-FOURIER-GAUGE-THM-006`: for distinct retained coordinates, zero-mode truncation does not
commute with the two-point finite-rank swap gauge. -/
theorem twoPointFiniteRankSwapConjugation_zeroModeFourierTruncation_ne
    {left right : Retained} (hdistinct : left ≠ right) :
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
          (twoPointFiniteRankConstantProjectorField left)) ≠
      pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
        (zeroModeFourierTruncation (twoPointFiniteRankConstantProjectorField left)) := by
  intro h
  have hzero := congrFun h 0
  have hone := congrFun h 1
  rw [zeroModeFourierTruncation_eq_coefficient] at hzero hone
  have hconstant :
      zeroModeFourierTruncation (twoPointFiniteRankConstantProjectorField left) =
        twoPointFiniteRankConstantProjectorField left := by
    change zeroModeFourierTruncation
        (fun _ : ZMod 2 => finiteRankCoordinateProjector left) =
      fun _ : ZMod 2 => finiteRankCoordinateProjector left
    exact zeroModeFourierTruncation_constant (finiteRankCoordinateProjector left)
  rw [hconstant] at hzero hone
  rw [twoPointFiniteRankSwapConjugation_at_zero] at hzero
  rw [twoPointFiniteRankSwapConjugation_at_one] at hone
  exact finiteRankCoordinateProjector_ne hdistinct (hzero.symm.trans hone)

private theorem finiteMatrixFrobeniusPower_pos_of_ne_zero
    {G m n : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype m] [Fintype n]
    (field : G → Matrix m n ℂ) (hfield : field ≠ 0) :
    0 < finiteMatrixFrobeniusPower field := by
  rw [finiteMatrixFrobeniusPower]
  apply Finset.sum_pos'
  · intro momentum _
    positivity
  · rw [Function.ne_iff] at hfield
    obtain ⟨momentum, hmomentum⟩ := hfield
    have hentry : ∃ row column, field momentum row column ≠ 0 := by
      by_contra hnot
      push Not at hnot
      exact hmomentum (Matrix.ext fun row column => hnot row column)
    obtain ⟨row, column, hentry⟩ := hentry
    refine ⟨momentum, Finset.mem_univ momentum, ?_⟩
    apply Finset.sum_pos'
    · intro row' _
      positivity
    · refine ⟨row, Finset.mem_univ row, ?_⟩
      apply Finset.sum_pos'
      · intro column' _
        positivity
      · exact ⟨column, Finset.mem_univ column, sq_pos_of_pos (norm_pos_iff.mpr hentry)⟩

private theorem twoPointFiniteRankSwap_zeroMode_residual_ne_zero
    {left right : Retained} (hdistinct : left ≠ right) :
    finiteFourierTruncationResidual {0}
        (finiteFourierCoefficient
          (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
            (twoPointFiniteRankConstantProjectorField left))) ≠ 0 := by
  let field := pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
    (twoPointFiniteRankConstantProjectorField left)
  have htrunc : zeroModeFourierTruncation field ≠ field := by
    have hnoncommute :=
      twoPointFiniteRankSwapConjugation_zeroModeFourierTruncation_ne hdistinct
    have hconstant :
        zeroModeFourierTruncation (twoPointFiniteRankConstantProjectorField left) =
          twoPointFiniteRankConstantProjectorField left := by
      change zeroModeFourierTruncation
          (fun _ : ZMod 2 => finiteRankCoordinateProjector left) =
        fun _ : ZMod 2 => finiteRankCoordinateProjector left
      exact zeroModeFourierTruncation_constant (finiteRankCoordinateProjector left)
    rw [hconstant] at hnoncommute
    exact hnoncommute
  intro hresidual
  apply htrunc
  funext momentum
  have hzero := congrFun hresidual momentum
  change finiteFourierReconstruction (finiteFourierCoefficient field) momentum -
    finiteFourierReconstruction
      (truncateCoefficients {0} (finiteFourierCoefficient field)) momentum = 0 at hzero
  rw [finiteFourierReconstruction_coefficients] at hzero
  exact (sub_eq_zero.mp hzero).symm

/-- `BG-FOURIER-GAUGE-THM-007`: for distinct retained coordinates, the finite-rank swap-gauged
field has strictly positive Fourier power outside the zero mode. -/
theorem twoPointFiniteRankSwapConjugation_omittedMatrixFrobeniusPower_pos
    {left right : Retained} (hdistinct : left ≠ right) :
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
          (twoPointFiniteRankConstantProjectorField left))) {0} := by
  have hpower : 0 < finiteMatrixFrobeniusPower
      (finiteFourierTruncationResidual {0}
        (finiteFourierCoefficient
          (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
            (twoPointFiniteRankConstantProjectorField left)))) :=
    finiteMatrixFrobeniusPower_pos_of_ne_zero _
      (twoPointFiniteRankSwap_zeroMode_residual_ne_zero hdistinct)
  rw [finiteMatrixFrobeniusTruncationResidual_parseval] at hpower
  have hcard : 0 < (Fintype.card (ZMod 2) : ℝ) := by
    exact_mod_cast Fintype.card_pos
  nlinarith

/-- `BG-FOURIER-GAUGE-THM-008`: on every arbitrary finite retained carrier with two distinct
coordinates, one common exact witness has pointwise-equal complex spectrum, fails zero-mode
truncation commutation, and has positive omitted Fourier power. -/
theorem finiteRankGaugeLocalitySeparation
    {left right : Retained} (hdistinct : left ≠ right) :
    (∀ momentum : ZMod 2,
      spectrum ℂ
          (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
            (twoPointFiniteRankConstantProjectorField left) momentum) =
        spectrum ℂ (finiteRankCoordinateProjector left)) ∧
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
          (twoPointFiniteRankConstantProjectorField left)) ≠
      pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
        (zeroModeFourierTruncation (twoPointFiniteRankConstantProjectorField left)) ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (twoPointFiniteRankSwapGauge left right)
          (twoPointFiniteRankConstantProjectorField left))) {0} := by
  exact ⟨twoPointFiniteRankSwapConjugation_spectrum_eq left right,
    twoPointFiniteRankSwapConjugation_zeroModeFourierTruncation_ne hdistinct,
    twoPointFiniteRankSwapConjugation_omittedMatrixFrobeniusPower_pos hdistinct⟩

/-- `BG-FOURIER-GAUGE-THM-009`: the separation witness exists canonically on `Fin (rank + 2)`,
so the construction applies at every retained rank at least two. -/
theorem finRankGaugeLocalitySeparation (rank : ℕ) :
    (∀ momentum : ZMod 2,
      spectrum ℂ
          (pointwiseUnitaryConjugation
            (twoPointFiniteRankSwapGauge (0 : Fin (rank + 2)) (1 : Fin (rank + 2)))
            (twoPointFiniteRankConstantProjectorField (0 : Fin (rank + 2))) momentum) =
        spectrum ℂ (finiteRankCoordinateProjector (0 : Fin (rank + 2)))) ∧
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation
          (twoPointFiniteRankSwapGauge (0 : Fin (rank + 2)) (1 : Fin (rank + 2)))
          (twoPointFiniteRankConstantProjectorField (0 : Fin (rank + 2)))) ≠
      pointwiseUnitaryConjugation
        (twoPointFiniteRankSwapGauge (0 : Fin (rank + 2)) (1 : Fin (rank + 2)))
        (zeroModeFourierTruncation
          (twoPointFiniteRankConstantProjectorField (0 : Fin (rank + 2)))) ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation
          (twoPointFiniteRankSwapGauge (0 : Fin (rank + 2)) (1 : Fin (rank + 2)))
          (twoPointFiniteRankConstantProjectorField (0 : Fin (rank + 2))))) {0} := by
  exact finiteRankGaugeLocalitySeparation
    (Fin.zero_ne_one : (0 : Fin (rank + 2)) ≠ 1)

/-- `BG-FOURIER-GAUGE-DEF-005`: a generic two-point unitary gauge, equal to the identity at
zero and to the supplied unitary at the other momentum. -/
noncomputable def twoPointFiniteRankUnitaryGauge
    (unitary : Matrix.unitaryGroup Retained ℂ) (momentum : ZMod 2) :
    Matrix.unitaryGroup Retained ℂ :=
  if momentum = 0 then 1 else unitary

/-- `BG-FOURIER-GAUGE-DEF-006`: a constant arbitrary finite-dimensional operator field on
`ZMod 2`. -/
def twoPointFiniteRankConstantOperatorField
    (operator : Matrix Retained Retained ℂ) (_ : ZMod 2) : Matrix Retained Retained ℂ :=
  operator

private lemma twoPointFiniteRankUnitaryConjugation_at_zero
    (unitary : Matrix.unitaryGroup Retained ℂ) (operator : Matrix Retained Retained ℂ) :
    pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
        (twoPointFiniteRankConstantOperatorField operator) 0 = operator := by
  simp [pointwiseUnitaryConjugation, twoPointFiniteRankUnitaryGauge,
    twoPointFiniteRankConstantOperatorField]

private lemma twoPointFiniteRankUnitaryConjugation_at_one
    (unitary : Matrix.unitaryGroup Retained ℂ) (operator : Matrix Retained Retained ℂ) :
    pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
        (twoPointFiniteRankConstantOperatorField operator) 1 =
      fixedUnitaryConjugation unitary operator := by
  change fixedUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary 1) operator =
    fixedUnitaryConjugation unitary operator
  rw [show twoPointFiniteRankUnitaryGauge unitary 1 = unitary by
    simp [twoPointFiniteRankUnitaryGauge]]

/-- `BG-FOURIER-GAUGE-THM-010`: a generic two-point finite-dimensional unitary gauge preserves
the exact complex spectrum of every supplied operator at both momenta. -/
theorem twoPointFiniteRankUnitaryConjugation_spectrum_eq
    (unitary : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Retained Retained ℂ) (momentum : ZMod 2) :
    spectrum ℂ
        (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
          (twoPointFiniteRankConstantOperatorField operator) momentum) =
      spectrum ℂ operator := by
  change spectrum ℂ
      (rightGaugeConjugate
        (twoPointFiniteRankUnitaryGauge unitary momentum : Matrix Retained Retained ℂ)
        operator) = spectrum ℂ operator
  exact spectrum_rightGaugeConjugate_unitary
    (twoPointFiniteRankUnitaryGauge unitary momentum) operator

/-- `BG-FOURIER-GAUGE-THM-011`: whenever a finite-dimensional operator is not invariant under a
supplied unitary, the corresponding two-point gauge does not commute with zero-mode Fourier
truncation. -/
theorem twoPointFiniteRankUnitaryConjugation_zeroModeFourierTruncation_ne
    {unitary : Matrix.unitaryGroup Retained ℂ} {operator : Matrix Retained Retained ℂ}
    (hchanges : operator ≠ fixedUnitaryConjugation unitary operator) :
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
          (twoPointFiniteRankConstantOperatorField operator)) ≠
      pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
        (zeroModeFourierTruncation (twoPointFiniteRankConstantOperatorField operator)) := by
  intro h
  have hzero := congrFun h 0
  have hone := congrFun h 1
  rw [zeroModeFourierTruncation_eq_coefficient] at hzero hone
  have hconstant :
      zeroModeFourierTruncation (twoPointFiniteRankConstantOperatorField operator) =
        twoPointFiniteRankConstantOperatorField operator := by
    change zeroModeFourierTruncation (fun _ : ZMod 2 => operator) = fun _ : ZMod 2 => operator
    exact zeroModeFourierTruncation_constant operator
  rw [hconstant] at hzero hone
  rw [twoPointFiniteRankUnitaryConjugation_at_zero] at hzero
  rw [twoPointFiniteRankUnitaryConjugation_at_one] at hone
  exact hchanges (hzero.symm.trans hone)

private theorem twoPointFiniteRankUnitary_zeroMode_residual_ne_zero
    {unitary : Matrix.unitaryGroup Retained ℂ} {operator : Matrix Retained Retained ℂ}
    (hchanges : operator ≠ fixedUnitaryConjugation unitary operator) :
    finiteFourierTruncationResidual {0}
        (finiteFourierCoefficient
          (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
            (twoPointFiniteRankConstantOperatorField operator))) ≠ 0 := by
  let field := pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
    (twoPointFiniteRankConstantOperatorField operator)
  have htrunc : zeroModeFourierTruncation field ≠ field := by
    have hnoncommute :=
      twoPointFiniteRankUnitaryConjugation_zeroModeFourierTruncation_ne hchanges
    have hconstant :
        zeroModeFourierTruncation (twoPointFiniteRankConstantOperatorField operator) =
          twoPointFiniteRankConstantOperatorField operator := by
      change zeroModeFourierTruncation (fun _ : ZMod 2 => operator) = fun _ : ZMod 2 => operator
      exact zeroModeFourierTruncation_constant operator
    rw [hconstant] at hnoncommute
    exact hnoncommute
  intro hresidual
  apply htrunc
  funext momentum
  have hzero := congrFun hresidual momentum
  change finiteFourierReconstruction (finiteFourierCoefficient field) momentum -
    finiteFourierReconstruction
      (truncateCoefficients {0} (finiteFourierCoefficient field)) momentum = 0 at hzero
  rw [finiteFourierReconstruction_coefficients] at hzero
  exact (sub_eq_zero.mp hzero).symm

/-- `BG-FOURIER-GAUGE-THM-012`: if the supplied unitary changes the finite-dimensional operator,
the gauged two-point field has strictly positive Fourier power outside the zero mode. -/
theorem twoPointFiniteRankUnitaryConjugation_omittedMatrixFrobeniusPower_pos
    {unitary : Matrix.unitaryGroup Retained ℂ} {operator : Matrix Retained Retained ℂ}
    (hchanges : operator ≠ fixedUnitaryConjugation unitary operator) :
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
          (twoPointFiniteRankConstantOperatorField operator))) {0} := by
  have hpower : 0 < finiteMatrixFrobeniusPower
      (finiteFourierTruncationResidual {0}
        (finiteFourierCoefficient
          (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
            (twoPointFiniteRankConstantOperatorField operator)))) :=
    finiteMatrixFrobeniusPower_pos_of_ne_zero _
      (twoPointFiniteRankUnitary_zeroMode_residual_ne_zero hchanges)
  rw [finiteMatrixFrobeniusTruncationResidual_parseval] at hpower
  have hcard : 0 < (Fintype.card (ZMod 2) : ℝ) := by
    exact_mod_cast Fintype.card_pos
  nlinarith

/-- `BG-FOURIER-GAUGE-THM-013`: every finite-dimensional operator changed by a supplied unitary
provides one common exact witness of pointwise spectral equality, zero-mode truncation
noncommutation, and positive omitted Fourier power. -/
theorem twoPointFiniteRankUnitaryGaugeLocalitySeparation
    {unitary : Matrix.unitaryGroup Retained ℂ} {operator : Matrix Retained Retained ℂ}
    (hchanges : operator ≠ fixedUnitaryConjugation unitary operator) :
    (∀ momentum : ZMod 2,
      spectrum ℂ
          (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
            (twoPointFiniteRankConstantOperatorField operator) momentum) =
        spectrum ℂ operator) ∧
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
          (twoPointFiniteRankConstantOperatorField operator)) ≠
      pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
        (zeroModeFourierTruncation (twoPointFiniteRankConstantOperatorField operator)) ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
          (twoPointFiniteRankConstantOperatorField operator))) {0} := by
  exact ⟨twoPointFiniteRankUnitaryConjugation_spectrum_eq unitary operator,
    twoPointFiniteRankUnitaryConjugation_zeroModeFourierTruncation_ne hchanges,
    twoPointFiniteRankUnitaryConjugation_omittedMatrixFrobeniusPower_pos hchanges⟩

/-- `BG-FOURIER-GAUGE-LEM-009`: conjugating an arbitrary diagonal operator by a coordinate swap
permutes its diagonal entries by the same swap. -/
lemma finiteRankSwapConjugation_diagonal (left right : Retained) (diagonal : Retained → ℂ) :
    fixedUnitaryConjugation (finiteRankSwapUnitary left right) (Matrix.diagonal diagonal) =
      Matrix.diagonal (fun coordinate => diagonal (Equiv.swap left right coordinate)) := by
  change (Matrix.swap ℂ left right)ᴴ * Matrix.diagonal diagonal * Matrix.swap ℂ left right = _
  rw [Matrix.conjTranspose_swap]
  ext row column
  rw [mul_swap_apply, swap_mul_apply]
  by_cases h : row = column
  · subst column
    simp
  · have hswap : Equiv.swap left right row ≠ Equiv.swap left right column := by
      exact fun heq => h ((Equiv.swap left right).injective heq)
    simp [h, hswap]

open ProjectKoios.BandGauge.Foundations

/-- `BG-FOURIER-GAUGE-DEF-007`: the exact diagonal retained-sector operator of the finite-rank
analytic parent at one fixed structure-factor value. -/
noncomputable def finiteRankAnalyticParentMatrix
    {Bond : Type*} [Fintype Bond] [Nonempty Bond]
    (rank : ℕ) (parentScale : ℝ) (phase : Bond → ℝ) : Matrix (Fin rank) (Fin rank) ℂ :=
  Matrix.diagonal fun index =>
    (finiteRankRetainedEnergy
      (finiteRankOrbitalCoordinate rank index) parentScale (finiteRankStructureFactor phase) : ℂ)

/-- `BG-FOURIER-GAUGE-LEM-010`: at every retained rank `N ≥ 2`, the first-coordinate swap
changes the exact diagonal analytic-parent operator because its first two energies are strictly
ordered. -/
lemma finiteRankAnalyticParentMatrix_ne_swapConjugation
    {Bond : Type*} [Fintype Bond] [Nonempty Bond]
    {rank : ℕ} (hrank : 2 ≤ rank)
    {parentScale : ℝ} (hscale : parentScale ∈ Set.Icc 0 1) (phase : Bond → ℝ) :
    let left : Fin rank := ⟨0, by omega⟩
    let right : Fin rank := ⟨1, by omega⟩
    finiteRankAnalyticParentMatrix rank parentScale phase ≠
      fixedUnitaryConjugation (finiteRankSwapUnitary left right)
        (finiteRankAnalyticParentMatrix rank parentScale phase) := by
  dsimp only
  have hlt := finiteRankStructureFactor_adjacent_strictMono
    (rank := rank) (index := 0) (parentScale := parentScale)
    hrank (by omega) hscale phase
  have hcomplex :
      (finiteRankRetainedEnergy
          (finiteRankOrbitalCoordinate rank 0) parentScale
          (finiteRankStructureFactor phase) : ℂ) ≠
        (finiteRankRetainedEnergy
          (finiteRankOrbitalCoordinate rank 1) parentScale
          (finiteRankStructureFactor phase) : ℂ) := by
    exact_mod_cast ne_of_lt hlt
  intro heq
  simp only [finiteRankAnalyticParentMatrix] at heq
  rw [finiteRankSwapConjugation_diagonal] at heq
  have hentry := congrFun (congrFun heq (⟨0, by omega⟩ : Fin rank))
    (⟨0, by omega⟩ : Fin rank)
  exact hcomplex (by
    simpa [finiteRankAnalyticParentMatrix, Matrix.diagonal_apply] using hentry)

/-- `BG-FOURIER-GAUGE-THM-014`: every exact `N`-band analytic parent with `N ≥ 2` and
`parentScale ∈ [0, 1]` supplies a finite-rank instance: swapping its first two strictly ordered bands
preserves the pointwise complex spectrum while forcing zero-mode truncation noncommutation and
positive omitted Fourier power. -/
theorem finiteRankAnalyticParentGaugeLocalitySeparation
    {Bond : Type*} [Fintype Bond] [Nonempty Bond]
    {rank : ℕ} (hrank : 2 ≤ rank)
    {parentScale : ℝ} (hscale : parentScale ∈ Set.Icc 0 1) (phase : Bond → ℝ) :
    let left : Fin rank := ⟨0, by omega⟩
    let right : Fin rank := ⟨1, by omega⟩
    let unitary := finiteRankSwapUnitary left right
    let operator := finiteRankAnalyticParentMatrix rank parentScale phase
    (∀ momentum : ZMod 2,
      spectrum ℂ
          (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
            (twoPointFiniteRankConstantOperatorField operator) momentum) =
        spectrum ℂ operator) ∧
    zeroModeFourierTruncation
        (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
          (twoPointFiniteRankConstantOperatorField operator)) ≠
      pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
        (zeroModeFourierTruncation (twoPointFiniteRankConstantOperatorField operator)) ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (pointwiseUnitaryConjugation (twoPointFiniteRankUnitaryGauge unitary)
          (twoPointFiniteRankConstantOperatorField operator))) {0} := by
  dsimp only
  exact twoPointFiniteRankUnitaryGaugeLocalitySeparation
    (finiteRankAnalyticParentMatrix_ne_swapConjugation hrank hscale phase)

end ProjectKoios.BandGauge.Fourier.Gauge

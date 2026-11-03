/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-04
-/
module

public import ProjectKoios.BandGauge.Fourier.Gauge.CharacterLocalitySeparation
public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.LatticeLeastSquares

/-!
# Character-gauge separation on finite periodic lattice meshes

This module specializes the arbitrary finite-abelian character-gauge theorem to the source-neutral
product mesh

`FinitePeriodicLatticeMesh lattice = (dimension : Dimension) → ZMod (lattice.period dimension)`.

The module first accepts an exact caller-supplied character and then constructs a canonical
unit-frequency character from any selected product-mesh coordinate of period at least two.  Radius
and cutoff remain exact caller-supplied data.  These theorems do not authenticate a runtime mesh,
FFT ordering, reciprocal basis, shell classifier, gauge array, DFT calculation, Wannier90
calculation, or `ksdft2effmass` artifact.
-/

@[expose] public section

open scoped Matrix

namespace ProjectKoios.BandGauge.Fourier.Gauge

open ProjectKoios.BandGauge.Fourier.FiniteAbelian
open ProjectKoios.BandGauge.Fourier.Support

/-- `BG-FOURIER-GAUGE-DEF-014`: coordinate character of a finite periodic product mesh at a
supplied quotient frequency.  This is an exact finite-group construction and does not select a
runtime FFT axis or array ordering. -/
noncomputable def finitePeriodicCoordinateCharacter
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (frequency : ZMod (lattice.period coordinate)) :
    AddChar (FinitePeriodicLatticeMesh lattice) ℂ :=
  (AddChar.zmodAddEquiv frequency).compAddMonoidHom
    (Pi.evalAddMonoidHom (fun dimension => ZMod (lattice.period dimension)) coordinate)

/-- `BG-FOURIER-GAUGE-LEM-014`: evaluation of the coordinate character is evaluation of the
one-dimensional quotient character on the selected coordinate. -/
@[simp]
lemma finitePeriodicCoordinateCharacter_apply
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (frequency : ZMod (lattice.period coordinate))
    (momentum : FinitePeriodicLatticeMesh lattice) :
    finitePeriodicCoordinateCharacter lattice coordinate frequency momentum =
      AddChar.zmodAddEquiv frequency (momentum coordinate) := by
  rfl

/-- `BG-FOURIER-GAUGE-LEM-015`: the unit-frequency coordinate character is nonzero whenever the
selected quotient coordinate has at least two points. -/
lemma finitePeriodicCoordinateCharacter_one_ne_zero
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (hperiod : 1 < lattice.period coordinate) :
    finitePeriodicCoordinateCharacter lattice coordinate 1 ≠ 0 := by
  let projection : FinitePeriodicLatticeMesh lattice →+ ZMod (lattice.period coordinate) :=
    Pi.evalAddMonoidHom (fun dimension => ZMod (lattice.period dimension)) coordinate
  have hprojection : Function.Surjective projection := by
    intro value
    refine ⟨Pi.single coordinate value, ?_⟩
    simp [projection]
  have hfrequency : (1 : ZMod (lattice.period coordinate)) ≠ 0 := by
    intro hone
    exact (Nat.ne_of_gt hperiod) (ZMod.one_eq_zero_iff.mp hone)
  have hbase : AddChar.zmodAddEquiv (1 : ZMod (lattice.period coordinate)) ≠ 0 := by
    simpa only [AddEquiv.map_zero] using AddChar.zmodAddEquiv.injective.ne hfrequency
  have hcompZero :
      (0 : AddChar (ZMod (lattice.period coordinate)) ℂ).compAddMonoidHom projection = 0 := by
    ext momentum
    simp
  intro hzero
  have hcomp :=
    (AddChar.compAddMonoidHom_injective_left projection hprojection).ne hbase
  apply hcomp
  exact (show
    (AddChar.zmodAddEquiv (1 : ZMod (lattice.period coordinate))).compAddMonoidHom
        projection = 0 by
      simpa [finitePeriodicCoordinateCharacter, projection] using hzero).trans hcompZero.symm

/-- `BG-FOURIER-GAUGE-THM-022`: the arbitrary-mesh character-gauge separation theorem specialized
to a finite periodic product lattice and an exact selected omitted character. -/
theorem finitePeriodicLatticeCharacterGaugeLocalitySeparation
    {Dimension Extra : Type*}
    [Fintype Dimension] [DecidableEq Dimension]
    [Fintype Extra] [DecidableEq Extra]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (character : AddChar (FinitePeriodicLatticeMesh lattice) ℂ)
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (hzero : (0 : AddChar (FinitePeriodicLatticeMesh lattice) ℂ) ∈ support)
    (hcharacter : character ∉ support) (hdistinct : left ≠ right) :
    (∀ momentum : FinitePeriodicLatticeMesh lattice,
      spectrum ℂ
        (finiteRankCharacterGaugedParentField character left right remainder momentum) =
      spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField
          (G := FinitePeriodicLatticeMesh lattice) left right remainder)) support = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField character left right remainder)) support := by
  exact finiteRankCharacterGaugeLocalitySeparation character left right remainder support
    hzero hcharacter hdistinct

/-- `BG-FOURIER-GAUGE-THM-023`: finite periodic product-lattice specialization for a complete
caller-supplied radius shell whose cutoff retains zero and omits the selected character. -/
theorem finitePeriodicLatticeCharacterGauge_metricShellLocalitySeparation
    {Dimension Extra : Type*}
    [Fintype Dimension] [DecidableEq Dimension]
    [Fintype Extra] [DecidableEq Extra]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (character : AddChar (FinitePeriodicLatticeMesh lattice) ℂ)
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (radius : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → NNReal) (cutoff : NNReal)
    (hzero : radius 0 ≤ cutoff) (hcharacter : cutoff < radius character)
    (hdistinct : left ≠ right) :
    (∀ momentum : FinitePeriodicLatticeMesh lattice,
      spectrum ℂ
        (finiteRankCharacterGaugedParentField character left right remainder momentum) =
      spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField
          (G := FinitePeriodicLatticeMesh lattice) left right remainder))
        (metricShell Finset.univ radius cutoff) = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField character left right remainder))
        (metricShell Finset.univ radius cutoff) := by
  exact finiteRankCharacterGauge_metricShellLocalitySeparation
    character left right remainder radius cutoff hzero hcharacter hdistinct

/-- `BG-FOURIER-GAUGE-THM-024`: the exact selected coefficient generated by the unit-frequency
coordinate character on a finite periodic product mesh. -/
theorem finiteFourierCoefficient_finitePeriodicCoordinateCharacterGaugedParentField_entry
    {Dimension Extra : Type*}
    [Fintype Dimension] [DecidableEq Dimension]
    [Fintype Extra] [DecidableEq Extra]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (left right : ℂ) (remainder : Matrix Extra Extra ℂ) :
    finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1) left right remainder)
        (finitePeriodicCoordinateCharacter lattice coordinate 1)
        (Sum.inl 1) (Sum.inl 0) =
      ((12 : ℂ) / 25) * (right - left) := by
  exact finiteFourierCoefficient_finiteRankCharacterGaugedParentField_entry
    (finitePeriodicCoordinateCharacter lattice coordinate 1) left right remainder

/-- `BG-FOURIER-GAUGE-THM-025`: a coordinate with at least two quotient points supplies a canonical
nonzero character.  Any common support retaining zero and omitting that character gives pointwise
spectral equality, zero parent omitted power, and positive gauged omitted power. -/
theorem finitePeriodicCoordinateCharacterGaugeLocalitySeparation
    {Dimension Extra : Type*}
    [Fintype Dimension] [DecidableEq Dimension]
    [Fintype Extra] [DecidableEq Extra]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (hperiod : 1 < lattice.period coordinate)
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (support : Finset (AddChar (FinitePeriodicLatticeMesh lattice) ℂ))
    (hzero : (0 : AddChar (FinitePeriodicLatticeMesh lattice) ℂ) ∈ support)
    (hcharacter : finitePeriodicCoordinateCharacter lattice coordinate 1 ∉ support)
    (hdistinct : left ≠ right) :
    finitePeriodicCoordinateCharacter lattice coordinate 1 ≠ 0 ∧
    (∀ momentum : FinitePeriodicLatticeMesh lattice,
      spectrum ℂ
        (finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1)
          left right remainder momentum) =
      spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField
          (G := FinitePeriodicLatticeMesh lattice) left right remainder)) support = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1)
          left right remainder)) support := by
  refine ⟨finitePeriodicCoordinateCharacter_one_ne_zero lattice coordinate hperiod, ?_⟩
  exact finitePeriodicLatticeCharacterGaugeLocalitySeparation lattice
    (finitePeriodicCoordinateCharacter lattice coordinate 1) left right remainder support
    hzero hcharacter hdistinct

/-- `BG-FOURIER-GAUGE-THM-026`: every finite periodic product mesh with a coordinate of period at
least two has a canonical unit-frequency character witness for zero-mode locality separation. -/
theorem finitePeriodicCoordinateCharacterGauge_zeroModeLocalitySeparation
    {Dimension Extra : Type*}
    [Fintype Dimension] [DecidableEq Dimension]
    [Fintype Extra] [DecidableEq Extra]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (hperiod : 1 < lattice.period coordinate)
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ) (hdistinct : left ≠ right) :
    finitePeriodicCoordinateCharacter lattice coordinate 1 ≠ 0 ∧
    (∀ momentum : FinitePeriodicLatticeMesh lattice,
      spectrum ℂ
        (finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1)
          left right remainder momentum) =
      spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField
          (G := FinitePeriodicLatticeMesh lattice) left right remainder)) {0} = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1)
          left right remainder)) {0} := by
  have hcharacter := finitePeriodicCoordinateCharacter_one_ne_zero lattice coordinate hperiod
  exact finitePeriodicCoordinateCharacterGaugeLocalitySeparation lattice coordinate hperiod
    left right remainder {0} (by simp) (by simpa using hcharacter) hdistinct

/-- `BG-FOURIER-GAUGE-THM-027`: canonical coordinate-character separation for a complete supplied
radius shell that retains zero and strictly omits the selected unit-frequency character. -/
theorem finitePeriodicCoordinateCharacterGauge_metricShellLocalitySeparation
    {Dimension Extra : Type*}
    [Fintype Dimension] [DecidableEq Dimension]
    [Fintype Extra] [DecidableEq Extra]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (hperiod : 1 < lattice.period coordinate)
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (radius : AddChar (FinitePeriodicLatticeMesh lattice) ℂ → NNReal) (cutoff : NNReal)
    (hzero : radius 0 ≤ cutoff)
    (hcharacter : cutoff < radius (finitePeriodicCoordinateCharacter lattice coordinate 1))
    (hdistinct : left ≠ right) :
    finitePeriodicCoordinateCharacter lattice coordinate 1 ≠ 0 ∧
    (∀ momentum : FinitePeriodicLatticeMesh lattice,
      spectrum ℂ
        (finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1)
          left right remainder momentum) =
      spectrum ℂ (finiteRankCharacterParentOperator left right remainder)) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterConstantParentField
          (G := FinitePeriodicLatticeMesh lattice) left right remainder))
        (metricShell Finset.univ radius cutoff) = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1)
          left right remainder))
        (metricShell Finset.univ radius cutoff) := by
  refine ⟨finitePeriodicCoordinateCharacter_one_ne_zero lattice coordinate hperiod, ?_⟩
  exact finitePeriodicLatticeCharacterGauge_metricShellLocalitySeparation lattice
    (finitePeriodicCoordinateCharacter lattice coordinate 1) left right remainder radius cutoff
    hzero hcharacter hdistinct

end ProjectKoios.BandGauge.Fourier.Gauge

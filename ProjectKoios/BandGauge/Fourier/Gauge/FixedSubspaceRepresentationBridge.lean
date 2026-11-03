/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-04
-/
module

public import ProjectKoios.BandGauge.Fourier.Gauge.LatticeCharacterLocalitySeparation

/-!
# Fixed-subspace representation bridge

This module connects the exact finite-frame right action to character-gauge Fourier locality.  A
reference frame represents an ambient operator by compression.  Multiplying that same frame on the
right by the exact character mixer gives the gauge-conjugated represented operator, preserves frame
orthonormality and pointwise complex spectra, and can change zero-mode Fourier locality.

The main theorem is conditional on an exact binding between the reference compression and the
constant finite-rank parent.  It can describe a fixed-retained-subspace representation change only
after a consumer authenticates that binding.  It does not certify DFT or Wannier90 execution,
disentanglement, projector selection, runtime arrays, FFT ordering, or scientific adequacy.
-/

@[expose] public section

open scoped Matrix

namespace ProjectKoios.BandGauge.Fourier.Gauge

open ProjectKoios.BandGauge.Alignment
open ProjectKoios.BandGauge.Fourier.FiniteAbelian

/-- `BG-FOURIER-GAUGE-DEF-015`: apply the exact character mixer on the right of every reference
frame while retaining the same ambient and retained carriers. -/
noncomputable def finiteRankCharacterGaugedFrameField
    {G Ambient Extra : Type*}
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Extra] [DecidableEq Extra]
    (referenceFrame : G → ComplexFrame Ambient (Fin 2 ⊕ Extra))
    (character : AddChar G ℂ) :
    G → ComplexFrame Ambient (Fin 2 ⊕ Extra) :=
  fun momentum =>
    rightUnitaryFrame (referenceFrame momentum)
      (finiteRankCharacterMixer (Extra := Extra) character momentum)

/-- `BG-FOURIER-GAUGE-LEM-016`: the pointwise character right action preserves every orthonormal
reference frame. -/
lemma finiteRankCharacterGaugedFrameField_isOrthonormal
    {G Ambient Extra : Type*}
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Extra] [DecidableEq Extra]
    (referenceFrame : G → ComplexFrame Ambient (Fin 2 ⊕ Extra))
    (character : AddChar G ℂ)
    (hframe : ∀ momentum, IsOrthonormalFrame (referenceFrame momentum)) :
    ∀ momentum, IsOrthonormalFrame
      (finiteRankCharacterGaugedFrameField referenceFrame character momentum) := by
  intro momentum
  exact rightUnitaryFrame_isOrthonormal
    (referenceFrame momentum) (finiteRankCharacterMixer (Extra := Extra) character momentum)
    (hframe momentum)

/-- `BG-FOURIER-GAUGE-LEM-017`: the character right action preserves the ambient projector
pointwise, so the reference and gauged frames represent exactly the same retained subspace. -/
lemma finiteRankCharacterGaugedFrameField_frameProjector
    {G Ambient Extra : Type*}
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Extra] [DecidableEq Extra]
    (referenceFrame : G → ComplexFrame Ambient (Fin 2 ⊕ Extra))
    (character : AddChar G ℂ) :
    ∀ momentum,
      frameProjector
          (finiteRankCharacterGaugedFrameField referenceFrame character momentum) =
        frameProjector (referenceFrame momentum) := by
  intro momentum
  exact frameProjector_rightUnitaryFrame
    (referenceFrame momentum) (finiteRankCharacterMixer (Extra := Extra) character momentum)

/-- `BG-FOURIER-GAUGE-LEM-018`: compression through the character-gauged frame is exactly the
named right-gauge conjugation of compression through the reference frame. -/
lemma compressOperator_finiteRankCharacterGaugedFrameField
    {G Ambient Extra : Type*}
    [AddCommGroup G] [Fintype G] [DecidableEq G]
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Extra] [DecidableEq Extra]
    (referenceFrame : G → ComplexFrame Ambient (Fin 2 ⊕ Extra))
    (ambientOperator : G → Matrix Ambient Ambient ℂ)
    (character : AddChar G ℂ) (momentum : G) :
    compressOperator
        (finiteRankCharacterGaugedFrameField referenceFrame character momentum)
        (ambientOperator momentum) =
      rightGaugeConjugate
        (finiteRankCharacterMixer (Extra := Extra) character momentum :
          Matrix (Fin 2 ⊕ Extra) (Fin 2 ⊕ Extra) ℂ)
        (compressOperator (referenceFrame momentum) (ambientOperator momentum)) := by
  exact compressOperator_rightUnitaryFrame_eq_rightGaugeConjugate
    (referenceFrame momentum) (finiteRankCharacterMixer (Extra := Extra) character momentum)
    (ambientOperator momentum)

/-- `BG-FOURIER-GAUGE-THM-028`: conditional fixed-retained-subspace representation bridge.
If a reference frame compresses an ambient operator field exactly to the constant finite-rank
parent, the canonical coordinate-character right action preserves orthonormality and pointwise
complex spectra while changing zero-mode omitted Frobenius power from zero to strictly positive. -/
theorem finitePeriodicCoordinateCharacter_fixedSubspaceRepresentationBridge
    {Dimension Ambient Extra : Type*}
    [Fintype Dimension] [DecidableEq Dimension]
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Extra] [DecidableEq Extra]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coordinate : Dimension) (hperiod : 1 < lattice.period coordinate)
    (ambientOperator : FinitePeriodicLatticeMesh lattice → Matrix Ambient Ambient ℂ)
    (referenceFrame :
      FinitePeriodicLatticeMesh lattice → ComplexFrame Ambient (Fin 2 ⊕ Extra))
    (left right : ℂ) (remainder : Matrix Extra Extra ℂ)
    (hframe : ∀ momentum, IsOrthonormalFrame (referenceFrame momentum))
    (hbinding : ∀ momentum,
      compressOperator (referenceFrame momentum) (ambientOperator momentum) =
        finiteRankCharacterParentOperator left right remainder)
    (hdistinct : left ≠ right) :
    finitePeriodicCoordinateCharacter lattice coordinate 1 ≠ 0 ∧
    (∀ momentum, IsOrthonormalFrame
      (finiteRankCharacterGaugedFrameField referenceFrame
        (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum)) ∧
    (∀ momentum,
      frameProjector
          (finiteRankCharacterGaugedFrameField referenceFrame
            (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum) =
        frameProjector (referenceFrame momentum)) ∧
    (∀ momentum,
      compressOperator
          (finiteRankCharacterGaugedFrameField referenceFrame
            (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum)
          (ambientOperator momentum) =
        rightGaugeConjugate
          (finiteRankCharacterMixer (Extra := Extra)
            (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum :
              Matrix (Fin 2 ⊕ Extra) (Fin 2 ⊕ Extra) ℂ)
          (compressOperator (referenceFrame momentum) (ambientOperator momentum))) ∧
    (∀ momentum,
      compressOperator
          (finiteRankCharacterGaugedFrameField referenceFrame
            (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum)
          (ambientOperator momentum) =
        finiteRankCharacterGaugedParentField
          (finitePeriodicCoordinateCharacter lattice coordinate 1)
          left right remainder momentum) ∧
    (∀ momentum,
      spectrum ℂ
          (compressOperator
            (finiteRankCharacterGaugedFrameField referenceFrame
              (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum)
            (ambientOperator momentum)) =
        spectrum ℂ
          (compressOperator (referenceFrame momentum) (ambientOperator momentum))) ∧
    finiteFourierCoefficient
        (fun momentum =>
          compressOperator
            (finiteRankCharacterGaugedFrameField referenceFrame
              (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum)
            (ambientOperator momentum))
        (finitePeriodicCoordinateCharacter lattice coordinate 1)
        (Sum.inl 1) (Sum.inl 0) =
      ((12 : ℂ) / 25) * (right - left) ∧
    omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (fun momentum =>
          compressOperator (referenceFrame momentum) (ambientOperator momentum))) {0} = 0 ∧
    0 < omittedMatrixFrobeniusPower
      (finiteFourierCoefficient
        (fun momentum =>
          compressOperator
            (finiteRankCharacterGaugedFrameField referenceFrame
              (finitePeriodicCoordinateCharacter lattice coordinate 1) momentum)
            (ambientOperator momentum))) {0} := by
  let character := finitePeriodicCoordinateCharacter lattice coordinate 1
  have hseparation :=
    finitePeriodicCoordinateCharacterGauge_zeroModeLocalitySeparation
      lattice coordinate hperiod left right remainder hdistinct
  have hreference :
      (fun momentum => compressOperator (referenceFrame momentum) (ambientOperator momentum)) =
        finiteRankCharacterConstantParentField left right remainder := by
    funext momentum
    simpa [finiteRankCharacterConstantParentField] using hbinding momentum
  have hgauged :
      (fun momentum =>
        compressOperator
          (finiteRankCharacterGaugedFrameField referenceFrame character momentum)
          (ambientOperator momentum)) =
        finiteRankCharacterGaugedParentField character left right remainder := by
    funext momentum
    rw [compressOperator_finiteRankCharacterGaugedFrameField]
    rw [hbinding momentum]
    rfl
  refine ⟨hseparation.1, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact finiteRankCharacterGaugedFrameField_isOrthonormal
      referenceFrame character hframe
  · exact finiteRankCharacterGaugedFrameField_frameProjector referenceFrame character
  · intro momentum
    exact compressOperator_finiteRankCharacterGaugedFrameField
      referenceFrame ambientOperator character momentum
  · intro momentum
    exact congrFun hgauged momentum
  · intro momentum
    rw [congrFun hgauged momentum, hbinding momentum]
    exact hseparation.2.1 momentum
  · rw [hgauged]
    exact finiteFourierCoefficient_finitePeriodicCoordinateCharacterGaugedParentField_entry
      lattice coordinate left right remainder
  · rw [hreference]
    exact hseparation.2.2.1
  · rw [hgauged]
    exact hseparation.2.2.2

end ProjectKoios.BandGauge.Fourier.Gauge

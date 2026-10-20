/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.LinearAlgebra.Matrix.Nondegenerate
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
public import ProjectKoios.QuantumMechanics.FiniteDifference.FiniteBarrier1D

/-!
# Symbolic interface matching for a finite lattice barrier

This module expresses left/right character amplitudes as two-coordinate interface states and states
exact matching through the finite barrier transfer product.  It does not choose a radiation
condition except in the explicitly named left-incident specialization, and it does not evaluate or
interpret transmission or reflection probabilities.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-BARRIER-MATCHING-DEF-001`: forward/backward coefficient vector in a lead. -/
def leadAmplitudeVector (forwardAmplitude backwardAmplitude : ℂ) : Fin 2 → ℂ :=
  ![forwardAmplitude, backwardAmplitude]

/--
`QM-BARRIER-MATCHING-DEF-002`: map from forward/backward character amplitudes to the interface
state `(ψ₀,ψ₋₁)`.
-/
noncomputable def leadInterfaceMatrix (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![1, 1;
     z⁻¹, z]

/-- `QM-BARRIER-MATCHING-THM-001`: explicit character-interface matrix action. -/
theorem leadInterfaceMatrix_mulVec_leadAmplitudeVector
    (z forwardAmplitude backwardAmplitude : ℂ) :
    Matrix.mulVec (leadInterfaceMatrix z)
        (leadAmplitudeVector forwardAmplitude backwardAmplitude) =
      ![forwardAmplitude + backwardAmplitude,
        z⁻¹ * forwardAmplitude + z * backwardAmplitude] := by
  ext i
  fin_cases i
  · simp [leadInterfaceMatrix, leadAmplitudeVector]
  · simp [leadInterfaceMatrix, leadAmplitudeVector]
    ring

/--
`QM-BARRIER-MATCHING-DEF-003`: reciprocal-character superposition translated so that `origin` is
its interface coordinate zero.
-/
noncomputable def shiftedBidirectionalExponentialMode
    (origin : ℤ) (forwardAmplitude backwardAmplitude z : ℂ) (n : ℤ) : ℂ :=
  forwardAmplitude * exponentialMode z (n - origin) +
    backwardAmplitude * exponentialMode z⁻¹ (n - origin)

/--
`QM-BARRIER-MATCHING-THM-002`: the transfer state of a shifted character superposition at its
origin is exactly its interface matrix applied to its amplitude vector.
-/
theorem transferState_shiftedBidirectionalExponentialMode_origin
    (origin : ℤ) (forwardAmplitude backwardAmplitude z : ℂ) :
    transferState
        (shiftedBidirectionalExponentialMode origin forwardAmplitude backwardAmplitude z) origin =
      Matrix.mulVec (leadInterfaceMatrix z)
        (leadAmplitudeVector forwardAmplitude backwardAmplitude) := by
  rw [leadInterfaceMatrix_mulVec_leadAmplitudeVector]
  ext i
  fin_cases i
  · simp [transferState, shiftedBidirectionalExponentialMode, exponentialMode]
  · simp [transferState, shiftedBidirectionalExponentialMode, exponentialMode]
    ring

/-- `QM-BARRIER-MATCHING-THM-003`: determinant of the character-interface matrix. -/
theorem det_leadInterfaceMatrix (z : ℂ) :
    Matrix.det (leadInterfaceMatrix z) = z - z⁻¹ := by
  simp [leadInterfaceMatrix, Matrix.det_fin_two]

/--
`QM-BARRIER-MATCHING-THM-004`: the interface representation is nonsingular exactly away from a
coincident reciprocal-root pair.
-/
theorem det_leadInterfaceMatrix_ne_zero_iff (z : ℂ) :
    Matrix.det (leadInterfaceMatrix z) ≠ 0 ↔ z ≠ z⁻¹ := by
  rw [det_leadInterfaceMatrix]
  exact sub_ne_zero

/--
`QM-BARRIER-MATCHING-DEF-004`: exact equality between the right interface state and propagation of
the left interface state through the finite barrier.
-/
def SatisfiesFiniteBarrierAmplitudeMatching
    (leftRoot rightRoot barrierPotential energy : ℂ) (width : ℕ)
    (leftForward leftBackward rightForward rightBackward : ℂ) : Prop :=
  Matrix.mulVec (leadInterfaceMatrix rightRoot)
      (leadAmplitudeVector rightForward rightBackward) =
    Matrix.mulVec (finiteBarrierTransferMatrix barrierPotential energy width)
      (Matrix.mulVec (leadInterfaceMatrix leftRoot)
        (leadAmplitudeVector leftForward leftBackward))

/--
`QM-BARRIER-MATCHING-THM-005`: amplitude matching is exactly matching of the shifted lattice-mode
transfer states at the two interfaces.
-/
theorem satisfiesFiniteBarrierAmplitudeMatching_iff_transferState
    (leftRoot rightRoot barrierPotential energy : ℂ) (width : ℕ)
    (leftForward leftBackward rightForward rightBackward : ℂ) :
    SatisfiesFiniteBarrierAmplitudeMatching leftRoot rightRoot barrierPotential energy width
        leftForward leftBackward rightForward rightBackward ↔
      transferState
          (shiftedBidirectionalExponentialMode (Int.ofNat width)
            rightForward rightBackward rightRoot)
          (Int.ofNat width) =
        Matrix.mulVec (finiteBarrierTransferMatrix barrierPotential energy width)
          (transferState
            (shiftedBidirectionalExponentialMode 0 leftForward leftBackward leftRoot) 0) := by
  rw [transferState_shiftedBidirectionalExponentialMode_origin,
    transferState_shiftedBidirectionalExponentialMode_origin]
  rfl

/--
`QM-BARRIER-MATCHING-DEF-005`: left-incident specialization with no backward character in the right
lead.  This is an algebraic convention only; no flux or probability interpretation is attached.
-/
def SatisfiesLeftIncidentFiniteBarrierMatching
    (leftRoot rightRoot barrierPotential energy : ℂ) (width : ℕ)
    (incident reflected transmitted : ℂ) : Prop :=
  SatisfiesFiniteBarrierAmplitudeMatching leftRoot rightRoot barrierPotential energy width
    incident reflected transmitted 0

/--
`QM-BARRIER-MATCHING-THM-006`: a zero-width region with the same lead root matches unchanged
forward amplitude and zero reflected amplitude.
-/
theorem satisfiesLeftIncidentFiniteBarrierMatching_zero_width
    (root barrierPotential energy incident : ℂ) :
    SatisfiesLeftIncidentFiniteBarrierMatching root root barrierPotential energy 0
      incident 0 incident := by
  simp [SatisfiesLeftIncidentFiniteBarrierMatching,
    SatisfiesFiniteBarrierAmplitudeMatching, finiteBarrierTransferMatrix]

/--
`QM-BARRIER-MATCHING-THM-007`: away from coincident reciprocal roots, the right forward/backward
amplitudes matching a fixed left interface state are unique.
-/
theorem finiteBarrierAmplitudeMatching_right_unique
    (leftRoot rightRoot barrierPotential energy : ℂ) (width : ℕ)
    (leftForward leftBackward rightForward₁ rightBackward₁ rightForward₂ rightBackward₂ : ℂ)
    (hright : rightRoot ≠ rightRoot⁻¹)
    (h₁ : SatisfiesFiniteBarrierAmplitudeMatching leftRoot rightRoot barrierPotential energy width
      leftForward leftBackward rightForward₁ rightBackward₁)
    (h₂ : SatisfiesFiniteBarrierAmplitudeMatching leftRoot rightRoot barrierPotential energy width
      leftForward leftBackward rightForward₂ rightBackward₂) :
    rightForward₁ = rightForward₂ ∧ rightBackward₁ = rightBackward₂ := by
  have hdet : Matrix.det (leadInterfaceMatrix rightRoot) ≠ 0 :=
    (det_leadInterfaceMatrix_ne_zero_iff rightRoot).2 hright
  have hamp : leadAmplitudeVector rightForward₁ rightBackward₁ =
      leadAmplitudeVector rightForward₂ rightBackward₂ := by
    apply Matrix.mulVec_injective_of_det_ne_zero hdet
    exact h₁.trans h₂.symm
  constructor
  · have h := congrFun hamp 0
    simpa [leadAmplitudeVector] using h
  · have h := congrFun hamp 1
    simpa [leadAmplitudeVector] using h

/--
`QM-BARRIER-MATCHING-THM-008`: away from coincident reciprocal roots, every propagated left
interface state has a right forward/backward amplitude representation.
-/
theorem exists_finiteBarrierAmplitudeMatching_right
    (leftRoot rightRoot barrierPotential energy : ℂ) (width : ℕ)
    (leftForward leftBackward : ℂ) (hright : rightRoot ≠ rightRoot⁻¹) :
    ∃ rightForward rightBackward,
      SatisfiesFiniteBarrierAmplitudeMatching leftRoot rightRoot barrierPotential energy width
        leftForward leftBackward rightForward rightBackward := by
  have hdet : Matrix.det (leadInterfaceMatrix rightRoot) ≠ 0 :=
    (det_leadInterfaceMatrix_ne_zero_iff rightRoot).2 hright
  have hinj : Function.Injective (leadInterfaceMatrix rightRoot).mulVec :=
    Matrix.mulVec_injective_of_det_ne_zero hdet
  have hunit : IsUnit (leadInterfaceMatrix rightRoot) :=
    Matrix.mulVec_injective_iff_isUnit.mp hinj
  have hsurj : Function.Surjective (leadInterfaceMatrix rightRoot).mulVec :=
    Matrix.mulVec_surjective_iff_isUnit.mpr hunit
  obtain ⟨rightAmplitudes, hrightAmplitudes⟩ := hsurj
    (Matrix.mulVec (finiteBarrierTransferMatrix barrierPotential energy width)
      (Matrix.mulVec (leadInterfaceMatrix leftRoot)
        (leadAmplitudeVector leftForward leftBackward)))
  refine ⟨rightAmplitudes 0, rightAmplitudes 1, ?_⟩
  unfold SatisfiesFiniteBarrierAmplitudeMatching
  rw [show leadAmplitudeVector (rightAmplitudes 0) (rightAmplitudes 1) = rightAmplitudes by
    funext i
    fin_cases i <;> simp [leadAmplitudeVector]]
  exact hrightAmplitudes

end ProjectKoios.QuantumMechanics.FiniteDifference

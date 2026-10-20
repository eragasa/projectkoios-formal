/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteLadder
public import ProjectKoios.QuantumMechanics.HarmonicOscillator.HermiteEigenfunction
public import Mathlib.Tactic.Module

/-!
# Truncation distortion of reduced harmonic-oscillator Hamiltonians

The central distinction in this module is between:

* direct compression of a composed full-space operator; and
* composing operators only after each factor has been compressed.

Compression is linear but not multiplicative.  The exact difference is an omitted-space leakage
term.  For the retained harmonic-oscillator ladder matrices, that general obstruction becomes an
explicit highest-state defect.  Reconstructing the Hamiltonian from the truncated ladder products
distorts the highest retained Hermite level, whereas the directly defined diagonal Hermite-energy
matrix remains the undistorted reference.

These theorems are exact finite algebra.  They do not identify a runtime array with a Lean matrix,
prove `L²` orthonormality of the Hermite functions, or bound spatial discretization and floating-point
errors.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

variable {Full Retained : Type*} [Fintype Full] [Fintype Retained]

/-- `QHO-TRUNCATION-DEF-001`: compression of a full-space matrix through an injection `J`. -/
def operatorCompression
    (J : Matrix Full Retained ℝ) (A : Matrix Full Full ℝ) : Matrix Retained Retained ℝ :=
  J.transpose * A * J

/-- `QHO-TRUNCATION-DEF-002`: full-space range matrix `J Jᵀ`. -/
def retainedSpaceProjection
    (J : Matrix Full Retained ℝ) : Matrix Full Full ℝ :=
  J * J.transpose

omit [Fintype Full] in
/-- `QHO-TRUNCATION-LEM-001`: the range matrix `J Jᵀ` is symmetric. -/
lemma retainedSpaceProjection_isSymm (J : Matrix Full Retained ℝ) :
    (retainedSpaceProjection J).IsSymm := by
  rw [Matrix.IsSymm]
  simp [retainedSpaceProjection, Matrix.transpose_mul]

/-- `QHO-TRUNCATION-LEM-002`: an isometric injection gives an idempotent range projection. -/
lemma retainedSpaceProjection_mul_self
    [DecidableEq Retained]
    (J : Matrix Full Retained ℝ) (hJ : J.transpose * J = 1) :
    retainedSpaceProjection J * retainedSpaceProjection J = retainedSpaceProjection J := by
  unfold retainedSpaceProjection
  calc
    (J * J.transpose) * (J * J.transpose) =
        J * (J.transpose * J) * J.transpose := by
          simp only [Matrix.mul_assoc]
    _ = J * J.transpose := by rw [hJ]; simp

/--
`QHO-TRUNCATION-THM-001`: exact multiplication defect for operator compression.

The right side is the full-space transition through the omitted complement `I - J Jᵀ`.  No norm
estimate, positivity claim, or numerical identification is included.
-/
theorem operatorCompression_mul_sub_mul_operatorCompression
    [DecidableEq Full]
    (J : Matrix Full Retained ℝ) (A B : Matrix Full Full ℝ) :
    operatorCompression J (A * B) - operatorCompression J A * operatorCompression J B =
      J.transpose * A * (1 - retainedSpaceProjection J) * B * J := by
  unfold operatorCompression retainedSpaceProjection
  simp only [Matrix.mul_assoc, Matrix.mul_sub, Matrix.sub_mul, Matrix.one_mul]

/-- `QHO-TRUNCATION-DEF-003`: projector onto the highest retained number-state coordinate. -/
def highestRetainedStateProjector (K : ℕ) : Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ :=
  Matrix.single (Fin.last K) (Fin.last K) 1

/--
`QHO-TRUNCATION-DEF-004`: Hamiltonian reconstructed from products of already-truncated ladder
matrices.
-/
noncomputable def reconstructedTruncatedLadderHamiltonian (K : ℕ) (energyScale : ℝ) :
    Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ :=
  (energyScale / 2) •
    (retainedAnnihilationMatrix K * retainedCreationMatrix K +
      retainedCreationMatrix K * retainedAnnihilationMatrix K)

/--
`QHO-TRUNCATION-LEM-003`: the direct diagonal retained Hamiltonian is
`energyScale * (N + I/2)`.
-/
lemma retainedHarmonicOscillatorHamiltonian_eq_number_add_half
    (K : ℕ) (energyScale : ℝ) :
    retainedHarmonicOscillatorHamiltonian K energyScale =
      energyScale •
        (retainedNumberMatrix K +
          (1 / 2 : ℝ) • (1 : Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ)) := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [retainedHarmonicOscillatorHamiltonian, retainedNumberStateEnergy,
      retainedNumberMatrix]
  · simp [retainedHarmonicOscillatorHamiltonian, retainedNumberMatrix, hij]

/--
`QHO-TRUNCATION-THM-002`: exact highest-state distortion produced by reconstructing the Hamiltonian
from truncated ladder products.

For retained dimension `K + 1`, the defect coefficient is
`energyScale * (K + 1) / 2`.
-/
theorem reconstructedTruncatedLadderHamiltonian_eq_reference_sub_boundary
    (K : ℕ) (energyScale : ℝ) :
    reconstructedTruncatedLadderHamiltonian K energyScale =
      retainedHarmonicOscillatorHamiltonian K energyScale -
        (energyScale * (K + 1) / 2) • highestRetainedStateProjector K := by
  have hcommutator := retainedLadderCommutator_eq_identity_sub_boundary K
  unfold retainedLadderCommutator at hcommutator
  have hproduct :
      retainedAnnihilationMatrix K * retainedCreationMatrix K =
        (1 - (K + 1 : ℝ) • highestRetainedStateProjector K) +
          retainedCreationMatrix K * retainedAnnihilationMatrix K :=
    sub_eq_iff_eq_add.mp hcommutator
  rw [reconstructedTruncatedLadderHamiltonian, hproduct,
    retainedCreation_mul_annihilation_eq_number,
    retainedHarmonicOscillatorHamiltonian_eq_number_add_half]
  unfold highestRetainedStateProjector
  module

/-- `QHO-TRUNCATION-LEM-004`: the exact distortion at the highest retained coordinate. -/
lemma reconstructedTruncatedLadderHamiltonian_sub_reference_apply_last
    (K : ℕ) (energyScale : ℝ) :
    (reconstructedTruncatedLadderHamiltonian K energyScale -
      retainedHarmonicOscillatorHamiltonian K energyScale)
        (Fin.last K) (Fin.last K) =
      -(energyScale * (K + 1) / 2) := by
  rw [reconstructedTruncatedLadderHamiltonian_eq_reference_sub_boundary]
  simp [highestRetainedStateProjector]

/--
`QHO-TRUNCATION-THM-003`: for nonzero energy scale, the reconstructed truncated-product
Hamiltonian is not the direct Hermite-energy reference matrix.
-/
theorem reconstructedTruncatedLadderHamiltonian_ne_reference
    (K : ℕ) {energyScale : ℝ} (hscale : energyScale ≠ 0) :
    reconstructedTruncatedLadderHamiltonian K energyScale ≠
      retainedHarmonicOscillatorHamiltonian K energyScale := by
  intro h
  have hzero :
      (reconstructedTruncatedLadderHamiltonian K energyScale -
        retainedHarmonicOscillatorHamiltonian K energyScale)
          (Fin.last K) (Fin.last K) = 0 := by
    rw [h]
    simp
  rw [reconstructedTruncatedLadderHamiltonian_sub_reference_apply_last] at hzero
  have hdim : (K + 1 : ℝ) ≠ 0 := by positivity
  have htwo : (2 : ℝ) ≠ 0 := by norm_num
  exact (div_ne_zero (mul_ne_zero hscale hdim) htwo) (neg_eq_zero.mp hzero)

/--
`QHO-TRUNCATION-LEM-005`: at unit energy scale, the direct retained matrix uses exactly the
Hermite eigenvalue proved in `QHO-HERMITE-THM-002`.
-/
lemma retainedHarmonicOscillatorHamiltonian_one_apply_self
    (K : ℕ) (n : Fin (K + 1)) :
    retainedHarmonicOscillatorHamiltonian K 1 n n = (n.val : ℝ) + 1 / 2 := by
  simp [retainedHarmonicOscillatorHamiltonian, retainedNumberStateEnergy]

end ProjectKoios.QuantumMechanics.HarmonicOscillator

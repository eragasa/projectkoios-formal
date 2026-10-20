/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.Data.Matrix.Basis
public import Mathlib.LinearAlgebra.Matrix.ConjTranspose
public import Mathlib.LinearAlgebra.Matrix.Symmetric

/-!
# Retained harmonic-oscillator ladder matrices

This module formalizes the exact real matrices represented by the finite QHO ladder implementation.
The index type `Fin (K + 1)` makes the retained dimension positive.  The annihilation matrix has
entries `sqrt (n + 1)` from `|n+1⟩` to `|n⟩`; creation is its transpose.  Their finite commutator has
the required highest-state defect.

The exact retained number operator and Hamiltonian are defined diagonally, matching the source
implementation's deliberate avoidance of floating-point square-root multiplication when producing
reported energies.  These are finite matrix facts, not a proof of the real-line oscillator spectrum.
-/

@[expose] public section

open scoped BigOperators

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

/-- `QHO-LADDER-DEF-001`: retained annihilation matrix on `|0⟩, …, |K⟩`. -/
noncomputable def retainedAnnihilationMatrix (K : ℕ) :
    Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ :=
  ∑ n : Fin K, Real.sqrt (n.val + 1 : ℕ) •
    Matrix.single n.castSucc n.succ 1

/-- `QHO-LADDER-DEF-002`: retained creation matrix, defined as the transpose of annihilation. -/
noncomputable def retainedCreationMatrix (K : ℕ) :
    Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ :=
  (retainedAnnihilationMatrix K).transpose

/-- `QHO-LADDER-DEF-003`: exact retained number operator, formed directly from integer labels. -/
def retainedNumberMatrix (K : ℕ) : Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ :=
  Matrix.diagonal fun n => (n.val : ℝ)

/-- `QHO-LADDER-DEF-004`: finite ladder commutator `a a† - a† a`. -/
noncomputable def retainedLadderCommutator (K : ℕ) :
    Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ :=
  retainedAnnihilationMatrix K * retainedCreationMatrix K -
    retainedCreationMatrix K * retainedAnnihilationMatrix K

/-- `QHO-LADDER-DEF-005`: exact retained energy `scale * (n + 1/2)`. -/
noncomputable def retainedNumberStateEnergy (energyScale : ℝ) {K : ℕ} (n : Fin (K + 1)) : ℝ :=
  energyScale * ((n.val : ℝ) + 1 / 2)

/-- `QHO-LADDER-DEF-006`: exact retained QHO Hamiltonian in number-state order. -/
noncomputable def retainedHarmonicOscillatorHamiltonian (K : ℕ) (energyScale : ℝ) :
    Matrix (Fin (K + 1)) (Fin (K + 1)) ℝ :=
  Matrix.diagonal (retainedNumberStateEnergy energyScale)

/-- `QHO-LADDER-LEM-001`: creation is exactly the transpose of annihilation. -/
lemma retainedCreationMatrix_eq_transpose (K : ℕ) :
    retainedCreationMatrix K = (retainedAnnihilationMatrix K).transpose := rfl

/-- `QHO-LADDER-LEM-002`: exact finite formula for `a a†`. -/
lemma retainedAnnihilation_mul_creation (K : ℕ) :
    retainedAnnihilationMatrix K * retainedCreationMatrix K =
      ∑ n : Fin K, (n.val + 1 : ℝ) •
        Matrix.single n.castSucc n.castSucc 1 := by
  classical
  rw [retainedCreationMatrix, retainedAnnihilationMatrix]
  simp only [Matrix.transpose_sum, Matrix.transpose_smul, Matrix.transpose_single,
    Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro n _
  rw [Matrix.smul_mul, Finset.mul_sum]
  rw [Finset.sum_eq_single n]
  · simp only [Matrix.mul_smul, Matrix.single_mul_single_same, smul_smul, mul_one]
    rw [Real.mul_self_sqrt (Nat.cast_nonneg _)]
    simp
  · intro m _ hmn
    have hsucc : n.succ ≠ m.succ := fun h => hmn (Fin.succ_inj.mp h.symm)
    rw [Matrix.mul_smul, Matrix.single_mul_single_of_ne 1 _ _ _ hsucc]
    simp
  · intro hn
    simp at hn

/-- `QHO-LADDER-LEM-003`: exact finite formula for `a† a`. -/
lemma retainedCreation_mul_annihilation_sum (K : ℕ) :
    retainedCreationMatrix K * retainedAnnihilationMatrix K =
      ∑ n : Fin K, (n.val + 1 : ℝ) • Matrix.single n.succ n.succ 1 := by
  classical
  rw [retainedCreationMatrix, retainedAnnihilationMatrix]
  simp only [Matrix.transpose_sum, Matrix.transpose_smul, Matrix.transpose_single,
    Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro n _
  rw [Matrix.smul_mul, Finset.mul_sum]
  rw [Finset.sum_eq_single n]
  · simp only [Matrix.mul_smul, Matrix.single_mul_single_same, smul_smul, mul_one]
    rw [Real.mul_self_sqrt (Nat.cast_nonneg _)]
    simp
  · intro m _ hmn
    have hcast : n.castSucc ≠ m.castSucc := fun h => hmn (Fin.castSucc_inj.mp h.symm)
    rw [Matrix.mul_smul, Matrix.single_mul_single_of_ne 1 _ _ _ hcast]
    simp
  · intro hn
    simp at hn

/-- `QHO-LADDER-LEM-004`: the shifted diagonal sum is the direct number matrix. -/
lemma sum_succ_single_eq_retainedNumberMatrix (K : ℕ) :
    (∑ n : Fin K, (n.val + 1 : ℝ) • Matrix.single n.succ n.succ 1) =
      retainedNumberMatrix K := by
  classical
  ext i j
  refine Fin.cases ?_ (fun p => ?_) i
  · by_cases hj : j = 0
    · subst j
      simp [Matrix.sum_apply, retainedNumberMatrix]
    · simp [Matrix.sum_apply, Matrix.diagonal_apply, retainedNumberMatrix]
  · by_cases hj : j = p.succ
    · subst j
      simp [Matrix.sum_apply, Matrix.single_apply, retainedNumberMatrix]
    · have hne : p.succ ≠ j := Ne.symm hj
      simp only [Matrix.sum_apply, Matrix.smul_apply, Matrix.single_apply, smul_eq_mul,
        mul_ite, mul_one, mul_zero, retainedNumberMatrix, Matrix.diagonal_apply, ite_false, hne]
      apply Finset.sum_eq_zero
      intro c _
      by_cases hcp : c = p
      · subst c
        simp [hne]
      · simp [hcp]

/-- `QHO-LADDER-LEM-005`: exact finite formula for the `a a†` diagonal. -/
lemma sum_castSucc_single_eq_boundaryDiagonal (K : ℕ) :
    (∑ n : Fin K, (n.val + 1 : ℝ) • Matrix.single n.castSucc n.castSucc 1) =
      Matrix.diagonal (fun i : Fin (K + 1) =>
        if i = Fin.last K then 0 else (i.val + 1 : ℝ)) := by
  classical
  ext i j
  refine Fin.lastCases ?_ (fun p => ?_) i
  · by_cases hj : j = Fin.last K
    · subst j
      simp [Matrix.sum_apply]
    · simp [Matrix.sum_apply, Matrix.diagonal_apply]
  · by_cases hj : j = p.castSucc
    · subst j
      simp [Matrix.sum_apply, Matrix.single_apply, Fin.castSucc_ne_last]
    · have hne : p.castSucc ≠ j := Ne.symm hj
      simp only [Matrix.sum_apply, Matrix.smul_apply, Matrix.single_apply, smul_eq_mul,
        mul_ite, mul_one, mul_zero, Matrix.diagonal_apply, ite_false, hne]
      apply Finset.sum_eq_zero
      intro c _
      by_cases hcp : c = p
      · subst c
        simp [hne]
      · simp [hcp]

/-- `QHO-LADDER-LEM-006`: `a† a` equals the exact direct number matrix. -/
lemma retainedCreation_mul_annihilation_eq_number (K : ℕ) :
    retainedCreationMatrix K * retainedAnnihilationMatrix K = retainedNumberMatrix K := by
  rw [retainedCreation_mul_annihilation_sum, sum_succ_single_eq_retainedNumberMatrix]

/--
`QHO-LADDER-THM-001`: the finite canonical commutator is the identity minus the retained-dimension
multiple of the highest-state projector.
-/
theorem retainedLadderCommutator_eq_identity_sub_boundary (K : ℕ) :
    retainedLadderCommutator K =
      1 - (K + 1 : ℝ) • Matrix.single (Fin.last K) (Fin.last K) 1 := by
  rw [retainedLadderCommutator, retainedAnnihilation_mul_creation,
    retainedCreation_mul_annihilation_sum, sum_castSucc_single_eq_boundaryDiagonal,
    sum_succ_single_eq_retainedNumberMatrix]
  ext i j
  simp only [retainedNumberMatrix]
  by_cases hij : i = j
  · subst j
    refine Fin.lastCases ?_ (fun p => ?_) i
    · simp
    · have hlast : Fin.last K ≠ p.castSucc := Ne.symm (Fin.castSucc_ne_last p)
      simp [hlast]
  · have hji : j ≠ i := Ne.symm hij
    by_cases hi : Fin.last K = i
    · subst i
      simp [hij]
    · simp [hij, hi]

/-- `QHO-LADDER-LEM-007`: the retained Hamiltonian has the declared diagonal energy. -/
lemma retainedHarmonicOscillatorHamiltonian_apply_self
    (K : ℕ) (energyScale : ℝ) (n : Fin (K + 1)) :
    retainedHarmonicOscillatorHamiltonian K energyScale n n =
      retainedNumberStateEnergy energyScale n := by
  simp [retainedHarmonicOscillatorHamiltonian]

/-- `QHO-LADDER-LEM-008`: the exact retained number-state Hamiltonian is symmetric. -/
lemma retainedHarmonicOscillatorHamiltonian_isSymm (K : ℕ) (energyScale : ℝ) :
    (retainedHarmonicOscillatorHamiltonian K energyScale).IsSymm := by
  exact Matrix.isSymm_diagonal _

end ProjectKoios.QuantumMechanics.HarmonicOscillator

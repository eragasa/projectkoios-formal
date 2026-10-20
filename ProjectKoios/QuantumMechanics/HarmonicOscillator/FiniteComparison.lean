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
# Finite harmonic-oscillator comparison algebra

This module formalizes the exact finite-dimensional algebra used by the controlled QHO comparison:
a sampled-state matrix `S`, a supplied right orthonormalization factor `R`, the injection `J = S R`,
the pullback `Jᵀ H J`, and the diagonal/off-diagonal squared Frobenius decomposition.

The module does not construct `R` by floating-point eigendecomposition and does not claim that a
runtime matrix is positive definite.  Instead, the exact normalization identity
`Rᵀ (Sᵀ S) R = I` is an explicit hypothesis.  Numerical evidence must establish that premise at a
separate checked-certificate boundary.
-/

@[expose] public section

open scoped BigOperators

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

variable {Grid Retained : Type*}
  [Fintype Grid] [Fintype Retained] [DecidableEq Retained]

/-- `QHO-COMPARISON-DEF-001`: sampled-state Gram matrix `Sᵀ S`. -/
def sampledGramMatrix (S : Matrix Grid Retained ℝ) : Matrix Retained Retained ℝ :=
  S.transpose * S

/-- `QHO-COMPARISON-DEF-002`: exact finite injection `J = S R`. -/
def orthonormalizedInjection
    (S : Matrix Grid Retained ℝ) (R : Matrix Retained Retained ℝ) :
    Matrix Grid Retained ℝ :=
  S * R

omit [DecidableEq Retained] in
/-- `QHO-COMPARISON-LEM-001`: the injection Gram matrix factors through the sampled Gram matrix. -/
lemma transpose_orthonormalizedInjection_mul_orthonormalizedInjection
    (S : Matrix Grid Retained ℝ) (R : Matrix Retained Retained ℝ) :
    (orthonormalizedInjection S R).transpose * orthonormalizedInjection S R =
      R.transpose * sampledGramMatrix S * R := by
  simp only [orthonormalizedInjection, sampledGramMatrix, Matrix.transpose_mul]
  simp only [Matrix.mul_assoc]

/-- `QHO-COMPARISON-THM-001`: an exact Gram-normalizing factor makes `J` an isometry. -/
theorem orthonormalizedInjection_isometry
    (S : Matrix Grid Retained ℝ) (R : Matrix Retained Retained ℝ)
    (hR : R.transpose * sampledGramMatrix S * R = 1) :
    (orthonormalizedInjection S R).transpose * orthonormalizedInjection S R = 1 := by
  rw [transpose_orthonormalizedInjection_mul_orthonormalizedInjection, hR]

/-- `QHO-COMPARISON-DEF-003`: finite common-coordinate pullback `Jᵀ H J`. -/
def pulledBackHamiltonian
    (J : Matrix Grid Retained ℝ) (H : Matrix Grid Grid ℝ) : Matrix Retained Retained ℝ :=
  J.transpose * H * J

omit [Fintype Retained] [DecidableEq Retained] in
/-- `QHO-COMPARISON-LEM-002`: a real symmetric Hamiltonian has a symmetric pullback. -/
lemma pulledBackHamiltonian_isSymm
    (J : Matrix Grid Retained ℝ) (H : Matrix Grid Grid ℝ) (hH : H.IsSymm) :
    (pulledBackHamiltonian J H).IsSymm := by
  rw [Matrix.IsSymm] at hH ⊢
  simp only [pulledBackHamiltonian, Matrix.transpose_mul, Matrix.transpose_transpose]
  rw [hH]
  simp only [Matrix.mul_assoc]

/-- `QHO-COMPARISON-DEF-004`: diagonal part of a finite square matrix. -/
def diagonalPart (A : Matrix Retained Retained ℝ) : Matrix Retained Retained ℝ :=
  Matrix.diagonal A.diag

/-- `QHO-COMPARISON-DEF-005`: off-diagonal residual after removing the diagonal part. -/
def offDiagonalPart (A : Matrix Retained Retained ℝ) : Matrix Retained Retained ℝ :=
  A - diagonalPart A

/-- `QHO-COMPARISON-DEF-006`: exact squared entrywise Frobenius magnitude. -/
def finiteMatrixFrobeniusSq (A : Matrix Retained Retained ℝ) : ℝ :=
  ∑ i, ∑ j, (A i j) ^ 2

omit [Fintype Retained] in
/-- `QHO-COMPARISON-LEM-003`: diagonal and off-diagonal parts reconstruct the matrix. -/
lemma diagonalPart_add_offDiagonalPart (A : Matrix Retained Retained ℝ) :
    diagonalPart A + offDiagonalPart A = A := by
  simp [offDiagonalPart]

omit [Fintype Retained] in
/-- `QHO-COMPARISON-LEM-004`: the off-diagonal part vanishes on the diagonal. -/
lemma offDiagonalPart_apply_self (A : Matrix Retained Retained ℝ) (i : Retained) :
    offDiagonalPart A i i = 0 := by
  simp [offDiagonalPart, diagonalPart]

omit [Fintype Retained] in
/-- `QHO-COMPARISON-LEM-005`: the diagonal part vanishes away from the diagonal. -/
lemma diagonalPart_apply_of_ne (A : Matrix Retained Retained ℝ) {i j : Retained} (hij : i ≠ j) :
    diagonalPart A i j = 0 := by
  simp [diagonalPart, hij]

/--
`QHO-COMPARISON-THM-002`: exact squared Frobenius decomposition into diagonal and off-diagonal
parts.  This is the exact algebraic identity behind `D_F² = D_diag² + D_off²`; square roots and
binary64 tolerances are deliberately outside this theorem.
-/
theorem finiteMatrixFrobeniusSq_eq_diagonal_add_offDiagonal
    (A : Matrix Retained Retained ℝ) :
    finiteMatrixFrobeniusSq A =
      finiteMatrixFrobeniusSq (diagonalPart A) +
        finiteMatrixFrobeniusSq (offDiagonalPart A) := by
  rw [finiteMatrixFrobeniusSq, finiteMatrixFrobeniusSq,
    finiteMatrixFrobeniusSq, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro i _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro j _
  by_cases hij : i = j
  · subst j
    simp [diagonalPart, offDiagonalPart]
  · simp [diagonalPart, offDiagonalPart, hij]

end ProjectKoios.QuantumMechanics.HarmonicOscillator

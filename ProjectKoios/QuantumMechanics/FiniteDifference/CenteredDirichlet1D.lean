/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.Data.Matrix.Basis
public import Mathlib.LinearAlgebra.Matrix.Symmetric

/-!
# Centered one-dimensional Dirichlet finite differences

Source-neutral exact matrix definitions for the finite interior-coordinate stencil.  No consistency,
continuum convergence, or floating-point claim is made.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-FD-DEF-001`: symmetric nearest-neighbor relation on ordered finite indices. -/
def IsNearestNeighbor {N : ℕ} (i j : Fin N) : Prop :=
  i.val + 1 = j.val ∨ j.val + 1 = i.val

/-- `QM-FD-LEM-001`: nearest-neighbor adjacency is symmetric. -/
lemma isNearestNeighbor_comm {N : ℕ} (i j : Fin N) :
    IsNearestNeighbor i j ↔ IsNearestNeighbor j i := by
  simp only [IsNearestNeighbor]
  tauto

/--
`QM-FD-DEF-002`: centered second-difference matrix on `N` interior Dirichlet coordinates.
-/
noncomputable def centeredDirichletLaplacian1D (N : ℕ) (h : ℝ) :
    Matrix (Fin N) (Fin N) ℝ := by
  classical
  exact fun i j =>
    if i = j then -2 / h ^ 2
    else if IsNearestNeighbor i j then 1 / h ^ 2
    else 0

/-- `QM-FD-THM-001`: the centered interior-coordinate stencil is symmetric. -/
theorem centeredDirichletLaplacian1D_isSymm (N : ℕ) (h : ℝ) :
    (centeredDirichletLaplacian1D N h).IsSymm := by
  classical
  rw [Matrix.IsSymm]
  ext i j
  by_cases hij : i = j
  · subst j
    simp [centeredDirichletLaplacian1D]
  · have hji : j ≠ i := Ne.symm hij
    simp [centeredDirichletLaplacian1D, hij, hji, isNearestNeighbor_comm]

/-- `QM-FD-THM-002`: a nonzero-spacing stencil is the inverse-square scaling of unit spacing. -/
theorem centeredDirichletLaplacian1D_eq_inv_sq_smul_unit
    (N : ℕ) (h : ℝ) (hh : h ≠ 0) :
    centeredDirichletLaplacian1D N h =
      (1 / h ^ 2) • centeredDirichletLaplacian1D N 1 := by
  ext i j
  rw [Matrix.smul_apply]
  unfold centeredDirichletLaplacian1D
  simp only [smul_eq_mul, one_pow, div_one]
  split_ifs <;> field_simp
  all_goals ring

end ProjectKoios.QuantumMechanics.FiniteDifference

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDifference.DirichletMatrixMode1D
public import Mathlib.Data.Matrix.Basis

/-!
# PIAB1D finite-difference Hamiltonian and boundary realization

This module fixes the concrete one-dimensional owner.  It formalizes the exact finite Dirichlet
matrix and a separately declared cyclic corner closure.  The closure difference is not identified
with a representation-independent continuum potential.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.Piab1d

open ProjectKoios.QuantumMechanics.FiniteDifference

/-- `PIAB1D-FD-DEF-001`: scaled centered Dirichlet kinetic matrix. -/
noncomputable def dirichletHamiltonian (N : ℕ) (h kineticScale : ℝ) :
    Matrix (Fin N) (Fin N) ℝ :=
  kineticScale • centeredDirichletLaplacian1D N h

/-- `PIAB1D-FD-THM-001`: the finite PIAB1D Dirichlet Hamiltonian is symmetric. -/
theorem dirichletHamiltonian_isSymm (N : ℕ) (h kineticScale : ℝ) :
    (dirichletHamiltonian N h kineticScale).IsSymm := by
  exact (centeredDirichletLaplacian1D_isSymm N h).smul kineticScale

/--
`PIAB1D-FD-THM-002`: complexifying the declared PIAB1D Hamiltonian gives the corresponding
inverse-square-scaled negative-difference matrix, with the sign inherited from `kineticScale`.
-/
theorem map_dirichletHamiltonian_eq_smul_negativeDirichletDifferenceMatrix
    (N : ℕ) (h kineticScale : ℝ) (hh : h ≠ 0) :
    (dirichletHamiltonian N h kineticScale).map Complex.ofReal =
      (-((kineticScale / h ^ 2 : ℝ) : ℂ)) • negativeDirichletDifferenceMatrix N := by
  rw [dirichletHamiltonian, centeredDirichletLaplacian1D_eq_inv_sq_smul_unit N h hh,
    negativeDirichletDifferenceMatrix_eq_neg_map_centeredDirichletLaplacian1D]
  ext i j
  simp only [Matrix.map_apply, Matrix.smul_apply, Matrix.neg_apply, smul_eq_mul]
  norm_cast
  ring

/--
`PIAB1D-BOUNDARY-DEF-001`: symmetric coupling between the first and last coordinates.  The index
size `N + 2` makes the two coordinates distinct without an extra nonemptiness premise.
-/
def cyclicCornerCoupling (N : ℕ) (coupling : ℝ) :
    Matrix (Fin (N + 2)) (Fin (N + 2)) ℝ :=
  Matrix.single 0 (Fin.last (N + 1)) coupling +
    Matrix.single (Fin.last (N + 1)) 0 coupling

/-- `PIAB1D-BOUNDARY-LEM-001`: the declared corner coupling is symmetric. -/
theorem cyclicCornerCoupling_isSymm (N : ℕ) (coupling : ℝ) :
    (cyclicCornerCoupling N coupling).IsSymm := by
  rw [Matrix.IsSymm]
  simp [cyclicCornerCoupling, Matrix.transpose_add, Matrix.transpose_single, add_comm]

/-- `PIAB1D-BOUNDARY-DEF-002`: cyclic closure of a supplied Dirichlet realization. -/
def cyclicClosure (N : ℕ) (H : Matrix (Fin (N + 2)) (Fin (N + 2)) ℝ)
    (coupling : ℝ) : Matrix (Fin (N + 2)) (Fin (N + 2)) ℝ :=
  H + cyclicCornerCoupling N coupling

/-- `PIAB1D-BOUNDARY-THM-001`: Dirichlet minus cyclic closure is exactly the corner term. -/
theorem dirichlet_sub_cyclicClosure
    (N : ℕ) (H : Matrix (Fin (N + 2)) (Fin (N + 2)) ℝ) (coupling : ℝ) :
    H - cyclicClosure N H coupling = -cyclicCornerCoupling N coupling := by
  simp [cyclicClosure]

/--
`PIAB1D-BOUNDARY-THM-002`: away from both declared corner coordinates, the boundary coupling
vanishes exactly.
-/
theorem cyclicCornerCoupling_apply_eq_zero
    (N : ℕ) (coupling : ℝ) (i j : Fin (N + 2))
    (h₁ : ¬(i = 0 ∧ j = Fin.last (N + 1)))
    (h₂ : ¬(i = Fin.last (N + 1) ∧ j = 0)) :
    cyclicCornerCoupling N coupling i j = 0 := by
  have hlast0 : Fin.last (N + 1) ≠ (0 : Fin (N + 2)) := by
    intro h
    have hval := congrArg Fin.val h
    simp at hval
  simp only [cyclicCornerCoupling, Matrix.add_apply, Matrix.single_apply]
  by_cases hi0 : i = 0
  · subst i
    have hjlast : j ≠ Fin.last (N + 1) := by
      intro h
      exact h₁ ⟨rfl, h⟩
    simp [Ne.symm hjlast, hlast0]
  · by_cases hilast : i = Fin.last (N + 1)
    · subst i
      have hj0 : j ≠ 0 := by
        intro h
        exact h₂ ⟨rfl, h⟩
      simp [Ne.symm hj0, Ne.symm hlast0]
    · simp [Ne.symm hi0, Ne.symm hilast]

end ProjectKoios.QuantumMechanics.Piab1d

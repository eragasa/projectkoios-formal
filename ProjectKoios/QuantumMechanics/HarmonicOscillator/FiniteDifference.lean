/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.Data.Matrix.Basis
public import Mathlib.LinearAlgebra.Matrix.Symmetric

/-!
# Finite one-dimensional QHO difference Hamiltonian

This module formalizes only the exact matrix symmetry of the centered three-point stencil, a sampled
diagonal potential, and their finite Hamiltonian sum.  It does not prove consistency order,
convergence to a differential operator, boundary-error control, or correspondence with a runtime
floating-point matrix.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

/-- `QHO-FINITE-DIFFERENCE-DEF-001`: symmetric nearest-neighbor predicate on ordered indices. -/
def IsNearestNeighbor {N : ℕ} (i j : Fin N) : Prop :=
  i.val + 1 = j.val ∨ j.val + 1 = i.val

/-- `QHO-FINITE-DIFFERENCE-LEM-001`: nearest-neighbor adjacency is symmetric. -/
lemma isNearestNeighbor_comm {N : ℕ} (i j : Fin N) :
    IsNearestNeighbor i j ↔ IsNearestNeighbor j i := by
  simp only [IsNearestNeighbor]
  tauto

/--
`QHO-FINITE-DIFFERENCE-DEF-002`: centered second-difference matrix with diagonal `-2 / h²` and
nearest-neighbor entries `1 / h²`.
-/
noncomputable def centralDifferenceLaplacian (N : ℕ) (h : ℝ) : Matrix (Fin N) (Fin N) ℝ := by
  classical
  exact fun i j =>
    if i = j then -2 / h ^ 2
    else if IsNearestNeighbor i j then 1 / h ^ 2
    else 0

/-- `QHO-FINITE-DIFFERENCE-LEM-002`: the centered second-difference matrix is symmetric. -/
lemma centralDifferenceLaplacian_isSymm (N : ℕ) (h : ℝ) :
    (centralDifferenceLaplacian N h).IsSymm := by
  classical
  rw [Matrix.IsSymm]
  ext i j
  by_cases hij : i = j
  · subst j
    simp [centralDifferenceLaplacian]
  · have hji : j ≠ i := Ne.symm hij
    simp [centralDifferenceLaplacian, hij, hji, isNearestNeighbor_comm]

/-- `QHO-FINITE-DIFFERENCE-DEF-003`: sampled potential as a diagonal matrix. -/
def sampledPotentialMatrix {N : ℕ} (potential : Fin N → ℝ) : Matrix (Fin N) (Fin N) ℝ :=
  Matrix.diagonal potential

/-- `QHO-FINITE-DIFFERENCE-LEM-003`: every real sampled diagonal potential is symmetric. -/
lemma sampledPotentialMatrix_isSymm {N : ℕ} (potential : Fin N → ℝ) :
    (sampledPotentialMatrix potential).IsSymm := by
  exact Matrix.isSymm_diagonal _

/--
`QHO-FINITE-DIFFERENCE-DEF-004`: scaled centered kinetic stencil plus a sampled diagonal potential.
The scalar `kineticScale` is kept explicit so dimensionalization and sign conventions remain at the
source-binding boundary.
-/
noncomputable def finiteDifferenceHamiltonian
    (N : ℕ) (h kineticScale : ℝ) (potential : Fin N → ℝ) : Matrix (Fin N) (Fin N) ℝ :=
  kineticScale • centralDifferenceLaplacian N h + sampledPotentialMatrix potential

/-- `QHO-FINITE-DIFFERENCE-LEM-004`: the finite-difference Hamiltonian is symmetric. -/
lemma finiteDifferenceHamiltonian_isSymm
    (N : ℕ) (h kineticScale : ℝ) (potential : Fin N → ℝ) :
    (finiteDifferenceHamiltonian N h kineticScale potential).IsSymm := by
  exact (centralDifferenceLaplacian_isSymm N h).smul kineticScale |>.add
    (sampledPotentialMatrix_isSymm potential)

end ProjectKoios.QuantumMechanics.HarmonicOscillator

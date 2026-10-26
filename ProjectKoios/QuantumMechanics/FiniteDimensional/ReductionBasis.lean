/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Basic.Real.Basic
public import Mathlib.Data.Matrix.Mul
public import Mathlib.LinearAlgebra.Matrix.Symmetric

/-!
# Finite reduction-basis algebra

Exact source-neutral identities for a rectangular reduction basis.  The symbol `Φ` denotes the
map from reduced coordinates into the full finite space.  The retained projector is `Φ * Φᵀ`;
the letter `Q` is therefore left available for the complementary projector `I - P`.

These results do not identify runtime arrays with Lean matrices, verify numerical orthogonality,
or attach physical meaning to a selected subspace.
-/

@[expose] public section

open scoped Matrix

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι κ : Type*} [Fintype ι] [Fintype κ]

/-- `QM-REDUCTION-DEF-001`: retained projector on the full finite space. -/
def reductionProjector (Φ : Matrix ι κ ℝ) : Matrix ι ι ℝ :=
  Φ * Φ.transpose

/-- `QM-REDUCTION-DEF-002`: full Hamiltonian represented in reduced coordinates. -/
def reducedHamiltonian (Φ : Matrix ι κ ℝ) (H : Matrix ι ι ℝ) : Matrix κ κ ℝ :=
  Φ.transpose * H * Φ

/-- `QM-REDUCTION-DEF-003`: reduced Hamiltonian mapped back into the full finite space. -/
def embeddedReducedHamiltonian (Φ : Matrix ι κ ℝ) (H : Matrix ι ι ℝ) : Matrix ι ι ℝ :=
  Φ * reducedHamiltonian Φ H * Φ.transpose

/-- `QM-REDUCTION-THM-001`: pullback after embedding is the identity on reduced coefficients. -/
theorem reductionBasis_transpose_mulVec_mulVec_eq [DecidableEq κ]
    (Φ : Matrix ι κ ℝ) (hΦ : Φ.transpose * Φ = 1) (x : κ → ℝ) :
    Φ.transpose *ᵥ (Φ *ᵥ x) = x := by
  rw [Matrix.mulVec_mulVec, hΦ]
  exact Matrix.one_mulVec x

/-- `QM-REDUCTION-THM-002`: an orthonormal-column basis defines an idempotent projector. -/
theorem reductionProjector_mul_self [DecidableEq κ]
    (Φ : Matrix ι κ ℝ) (hΦ : Φ.transpose * Φ = 1) :
    reductionProjector Φ * reductionProjector Φ = reductionProjector Φ := by
  simp only [reductionProjector]
  rw [Matrix.mul_assoc Φ Φ.transpose (Φ * Φ.transpose)]
  rw [← Matrix.mul_assoc Φ.transpose Φ Φ.transpose, hΦ]
  simp

omit [Fintype ι] in
/-- `QM-REDUCTION-THM-003`: the retained projector is symmetric. -/
theorem reductionProjector_isSymm (Φ : Matrix ι κ ℝ) :
    (reductionProjector Φ).IsSymm := by
  simp [reductionProjector, Matrix.IsSymm, Matrix.transpose_mul]

/--
`QM-REDUCTION-THM-004`: embedding the reduced Hamiltonian is exactly the retained-projector
sandwich of the full Hamiltonian.
-/
theorem embeddedReducedHamiltonian_eq_projector_sandwich
    (Φ : Matrix ι κ ℝ) (H : Matrix ι ι ℝ) :
    embeddedReducedHamiltonian Φ H = reductionProjector Φ * H * reductionProjector Φ := by
  simp only [embeddedReducedHamiltonian, reducedHamiltonian, reductionProjector]
  simp only [Matrix.mul_assoc]

omit [Fintype κ] in
/-- `QM-REDUCTION-THM-005`: reducing a symmetric Hamiltonian preserves symmetry. -/
theorem reducedHamiltonian_isSymm
    (Φ : Matrix ι κ ℝ) (H : Matrix ι ι ℝ) (hH : H.IsSymm) :
    (reducedHamiltonian Φ H).IsSymm := by
  simp [reducedHamiltonian, Matrix.IsSymm, Matrix.transpose_mul, hH.eq, Matrix.mul_assoc]

/-- `QM-REDUCTION-THM-006`: embedding a symmetric reduced Hamiltonian preserves symmetry. -/
theorem embeddedReducedHamiltonian_isSymm
    (Φ : Matrix ι κ ℝ) (H : Matrix ι ι ℝ) (hH : H.IsSymm) :
    (embeddedReducedHamiltonian Φ H).IsSymm := by
  simp [embeddedReducedHamiltonian, Matrix.IsSymm, Matrix.transpose_mul,
    (reducedHamiltonian_isSymm Φ H hH).eq, Matrix.mul_assoc]

end ProjectKoios.QuantumMechanics.FiniteDimensional

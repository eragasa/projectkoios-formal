/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinPauliDecomposition
public import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Global spin-frame rotations

Exact finite-dimensional algebra for a spatially independent two-component spin rotation.  A spin
frame is an element of Mathlib's special unitary group `SU(2)`, represented by
`Matrix.specialUnitaryGroup (Fin 2) ℂ`.  Its orbital-space lift is

`I_orbital ⊗ₖ U`,

and this module fixes the **active** convention

`M ↦ (I_orbital ⊗ₖ U) M (I_orbital ⊗ₖ U)ᴴ`.

This action order matches the spinor transformation `Φ(r) ↦ U Φ(r)` described by Eich and Gross,
*Physical Review Letters* 111, 156401 (2013), arXiv:1212.3658v2, in the paragraph immediately
preceding their equation (9).  The citation fixes convention context only: the declarations below
are source-neutral matrix algebra and do not bind a density-functional field or functional.  The
inspected source identity and byte hash are recorded in `docs/audit/source-audit.md`.

The active action is deliberately distinguished from the passive coordinate change
`M ↦ (I ⊗ₖ U)ᴴ M (I ⊗ₖ U)`.  The module proves the lifted group laws, exact unitarity, preservation
of Hermiticity, invariance of spin-independent lifts, and cancellation by the inverse rotation.
It does not yet construct the corresponding `SO(3)` rotation, prove Pauli-vector covariance,
define collinearity in some frame, introduce position dependence, or model spin--orbit coupling.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Kronecker Matrix

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

/-- `QM-SPIN-FRAME-DEF-001`: an exact global two-component spin frame in `SU(2)`. -/
abbrev SpinFrame := Matrix.specialUnitaryGroup (Fin 2) ℂ

variable {ι : Type*} [DecidableEq ι]

/--
`QM-SPIN-FRAME-DEF-002`: lift a global spin frame to orbital-major spinful coordinates as
`I_orbital ⊗ₖ U`.
-/
noncomputable def spinFrameLift (U : SpinFrame) :
    Matrix (ι × Fin 2) (ι × Fin 2) ℂ :=
  (1 : Matrix ι ι ℂ) ⊗ₖ (U : Matrix (Fin 2) (Fin 2) ℂ)

/-- `QM-SPIN-FRAME-LEM-001`: the identity spin frame lifts to the spinful identity. -/
@[simp] lemma spinFrameLift_one :
    spinFrameLift (ι := ι) (1 : SpinFrame) = 1 := by
  ext ⟨i, s⟩ ⟨j, t⟩
  by_cases hij : i = j <;> by_cases hst : s = t <;>
    simp [spinFrameLift, Matrix.one_apply, hij, hst]

/-- `QM-SPIN-FRAME-LEM-002`: conjugate transpose of a lift is the lift of the inverse frame. -/
@[simp] lemma spinFrameLift_conjTranspose (U : SpinFrame) :
    (spinFrameLift (ι := ι) U)ᴴ = spinFrameLift (star U) := by
  rw [spinFrameLift, Matrix.conjTranspose_kronecker]
  simp [spinFrameLift, Matrix.star_eq_conjTranspose]

variable [Fintype ι]

/--
`QM-SPIN-FRAME-DEF-003`: active global spin rotation
`M ↦ (I_orbital ⊗ₖ U) M (I_orbital ⊗ₖ U)ᴴ`.
-/
noncomputable def spinFrameRotate (U : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    Matrix (ι × Fin 2) (ι × Fin 2) ℂ :=
  spinFrameLift U * M * (spinFrameLift U)ᴴ

/-- `QM-SPIN-FRAME-LEM-003`: lifting respects multiplication of global spin frames. -/
@[simp] lemma spinFrameLift_mul (U V : SpinFrame) :
    spinFrameLift (ι := ι) (U * V) = spinFrameLift U * spinFrameLift V := by
  simpa [spinFrameLift] using
    (Matrix.mul_kronecker_mul
      (1 : Matrix ι ι ℂ) (1 : Matrix ι ι ℂ)
      (U : Matrix (Fin 2) (Fin 2) ℂ) (V : Matrix (Fin 2) (Fin 2) ℂ))

/-- `QM-SPIN-FRAME-THM-001`: every lifted `SU(2)` spin frame is exactly unitary. -/
theorem spinFrameLift_mem_unitaryGroup (U : SpinFrame) :
    spinFrameLift (ι := ι) U ∈ Matrix.unitaryGroup (ι × Fin 2) ℂ := by
  rw [Matrix.mem_unitaryGroup_iff']
  change (spinFrameLift U)ᴴ * spinFrameLift U = 1
  rw [spinFrameLift_conjTranspose, ← spinFrameLift_mul (ι := ι) (star U) U]
  simp [Matrix.star_eq_inv]

/-- `QM-SPIN-FRAME-LEM-004`: the identity frame acts trivially. -/
@[simp] lemma spinFrameRotate_one
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinFrameRotate (1 : SpinFrame) M = M := by
  simp [spinFrameRotate]

/--
`QM-SPIN-FRAME-LEM-005`: active spin rotations compose in group multiplication order.

The equation reads `rotate (U V) = rotate U ∘ rotate V`; this order is part of the declared active
convention and must not be silently reused for a passive coordinate action.
-/
@[simp] lemma spinFrameRotate_mul (U V : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinFrameRotate (U * V) M = spinFrameRotate U (spinFrameRotate V M) := by
  simp [spinFrameRotate, Matrix.conjTranspose_mul, Matrix.mul_assoc]

/-- `QM-SPIN-FRAME-THM-002`: an active global spin rotation preserves Hermiticity. -/
theorem spinFrameRotate_isHermitian (U : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    (spinFrameRotate U M).IsHermitian := by
  unfold Matrix.IsHermitian spinFrameRotate
  -- Conjugate transpose reverses the three factors; Hermiticity of `M` restores the same product.
  simp [Matrix.conjTranspose_mul, hM.eq, Matrix.mul_assoc]

/--
`QM-SPIN-FRAME-THM-003`: active spin rotation leaves every spin-independent orbital lift fixed.
-/
@[simp] theorem spinFrameRotate_spinDegenerateLift (U : SpinFrame)
    (A : Matrix ι ι ℂ) :
    spinFrameRotate U (spinDegenerateLift A) = spinDegenerateLift A := by
  -- The first Kronecker multiplication gives `(I ⊗ U)(A ⊗ I) = A ⊗ U`.
  have hleft :
      spinFrameLift (ι := ι) U * spinDegenerateLift A =
        A ⊗ₖ (U : Matrix (Fin 2) (Fin 2) ℂ) := by
    simpa [spinFrameLift, spinDegenerateLift] using
      (Matrix.mul_kronecker_mul
        (1 : Matrix ι ι ℂ) A
        (U : Matrix (Fin 2) (Fin 2) ℂ)
        (1 : Matrix (Fin 2) (Fin 2) ℂ)).symm
  have hU :
      (U : Matrix (Fin 2) (Fin 2) ℂ) *
          (U : Matrix (Fin 2) (Fin 2) ℂ)ᴴ = 1 :=
    U.property.1.2
  rw [spinFrameRotate, hleft, spinFrameLift_conjTranspose]
  change
    (A ⊗ₖ (U : Matrix (Fin 2) (Fin 2) ℂ)) *
        ((1 : Matrix ι ι ℂ) ⊗ₖ star (U : Matrix (Fin 2) (Fin 2) ℂ)) =
      spinDegenerateLift A
  -- The remaining spin factor is `U Uᴴ = I`, so only the orbital operator remains.
  rw [← Matrix.mul_kronecker_mul]
  simp [spinDegenerateLift, Matrix.star_eq_conjTranspose, hU]

/-- `QM-SPIN-FRAME-THM-004`: rotation by the inverse frame exactly undoes the rotation. -/
@[simp] theorem spinFrameRotate_inv_rotate (U : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinFrameRotate U⁻¹ (spinFrameRotate U M) = M := by
  rw [← spinFrameRotate_mul, inv_mul_cancel, spinFrameRotate_one]

end ProjectKoios.QuantumMechanics.FiniteDimensional

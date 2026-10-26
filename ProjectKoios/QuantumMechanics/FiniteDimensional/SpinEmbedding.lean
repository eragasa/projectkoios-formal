/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.Matrix.Normed
public import Mathlib.LinearAlgebra.Matrix.Hermitian
public import Mathlib.LinearAlgebra.Matrix.Kronecker

/-!
# Finite spin-space embeddings

Exact source-neutral algebra for adjoining a two-state spin coordinate to a finite orbital space.
The spinful index is the product `ι × Fin 2`, so `spinDegenerateLift A = A ⊗ₖ I₂` uses
orbital-major product coordinates.  Explicit injection matrices select either spin coordinate, and
`spinPullback` sandwiches a spinful operator between their conjugate transpose and injection.

The results establish exact block recovery, vanishing cross-spin blocks, preservation of
Hermiticity and multiplication, trace doubling, injectivity, and squared Frobenius-norm doubling.
They do not bind authored or runtime matrices, floating-point arrays, serialized evidence, Pauli
residuals, time-reversal models, eigenspectra, or physical spin adequacy.
-/

@[expose] public section

open scoped BigOperators Kronecker Matrix Matrix.Norms.Frobenius

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- `QM-SPIN-DEF-001`: tensor a finite orbital operator with the two-state spin identity. -/
noncomputable def spinDegenerateLift (A : Matrix ι ι ℂ) :
    Matrix (ι × Fin 2) (ι × Fin 2) ℂ :=
  A ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-THM-001`: the spin-degenerate lift is entrywise diagonal in spin. -/
@[simp] theorem spinDegenerateLift_apply (A : Matrix ι ι ℂ) (i j : ι) (s t : Fin 2) :
    spinDegenerateLift A (i, s) (j, t) = if s = t then A i j else 0 := by
  simp [spinDegenerateLift, Matrix.one_apply]

/-- `QM-SPIN-DEF-002`: inject an orbital vector into one selected spin coordinate. -/
noncomputable def spinInjection (s : Fin 2) : Matrix (ι × Fin 2) ι ℂ :=
  fun is j => if is = (j, s) then 1 else 0

omit [Fintype ι] in
/-- `QM-SPIN-THM-002`: entrywise form of a selected-spin injection matrix. -/
@[simp] theorem spinInjection_apply (s : Fin 2) (i j : ι) (t : Fin 2) :
    spinInjection s (i, t) j = if i = j ∧ t = s then 1 else 0 := by
  simp only [spinInjection, Prod.mk.injEq]

/-- `QM-SPIN-DEF-003`: pull back a spinful operator between two selected spin coordinates. -/
noncomputable def spinPullback (s t : Fin 2)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Matrix ι ι ℂ :=
  (spinInjection s)ᴴ * M * spinInjection t

/-- `QM-SPIN-THM-003`: the injection sandwich selects the corresponding spin block entrywise. -/
@[simp] theorem spinPullback_apply (s t : Fin 2)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (i j : ι) :
    spinPullback s t M i j = M (i, s) (j, t) := by
  simp [spinPullback, Matrix.mul_apply, spinInjection]

/-- `QM-SPIN-THM-004`: selected-spin injections are mutually orthogonal isometries. -/
@[simp] theorem spinInjection_conjTranspose_mul (s t : Fin 2) :
    (spinInjection (ι := ι) s)ᴴ * spinInjection (ι := ι) t = if s = t then 1 else 0 := by
  ext i j
  by_cases hs : s = t <;> by_cases hij : i = j
  all_goals simp [Matrix.mul_apply, spinInjection, Matrix.one_apply, hs, hij, eq_comm] at *

/--
`QM-SPIN-THM-005`: every selected-spin block of `A ⊗ I₂` is `A` on the diagonal and zero off it.
-/
@[simp] theorem spinPullback_spinDegenerateLift (s t : Fin 2) (A : Matrix ι ι ℂ) :
    spinPullback s t (spinDegenerateLift A) = if s = t then A else 0 := by
  ext i j
  by_cases h : s = t
  · subst t
    simp
  · simp [h]

/-- `QM-SPIN-THM-006`: either diagonal spin pullback recovers the original orbital operator. -/
@[simp] theorem spinPullback_spinDegenerateLift_same (s : Fin 2) (A : Matrix ι ι ℂ) :
    spinPullback s s (spinDegenerateLift A) = A := by
  simp

/-- `QM-SPIN-THM-007`: cross-spin pullback of a spin-degenerate lift vanishes. -/
theorem spinPullback_spinDegenerateLift_cross (s t : Fin 2) (hst : s ≠ t)
    (A : Matrix ι ι ℂ) : spinPullback s t (spinDegenerateLift A) = 0 := by
  simp [hst]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-THM-008`: spin-degenerate lifting commutes with conjugate transpose. -/
@[simp] theorem spinDegenerateLift_conjTranspose (A : Matrix ι ι ℂ) :
    (spinDegenerateLift A)ᴴ = spinDegenerateLift Aᴴ := by
  simp [spinDegenerateLift, Matrix.conjTranspose_kronecker]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-THM-009`: spin-degenerate lifting preserves Hermiticity. -/
theorem spinDegenerateLift_isHermitian (A : Matrix ι ι ℂ) (hA : A.IsHermitian) :
    (spinDegenerateLift A).IsHermitian := by
  unfold Matrix.IsHermitian at hA ⊢
  simp [hA]

omit [DecidableEq ι] in
/-- `QM-SPIN-THM-010`: spin-degenerate lifting preserves matrix multiplication. -/
@[simp] theorem spinDegenerateLift_mul (A B : Matrix ι ι ℂ) :
    spinDegenerateLift (A * B) = spinDegenerateLift A * spinDegenerateLift B := by
  simpa [spinDegenerateLift] using
    (Matrix.mul_kronecker_mul A B
      (1 : Matrix (Fin 2) (Fin 2) ℂ) (1 : Matrix (Fin 2) (Fin 2) ℂ))

omit [DecidableEq ι] in
/-- `QM-SPIN-THM-011`: adjoining a two-state spin identity doubles the trace. -/
@[simp] theorem spinDegenerateLift_trace (A : Matrix ι ι ℂ) :
    Matrix.trace (spinDegenerateLift A) = 2 * Matrix.trace A := by
  rw [spinDegenerateLift, Matrix.trace_kronecker]
  simp
  ring

/-- `QM-SPIN-THM-012`: spin-degenerate lifting is injective. -/
theorem spinDegenerateLift_injective :
    Function.Injective
      (spinDegenerateLift : Matrix ι ι ℂ → Matrix (ι × Fin 2) (ι × Fin 2) ℂ) := by
  intro A B h
  have hpullback := congrArg (spinPullback (ι := ι) 0 0) h
  simpa using hpullback

/-- `QM-SPIN-THM-013`: the squared Mathlib Frobenius norm is the entrywise squared-norm sum. -/
theorem frobenius_norm_sq_eq_sum (A : Matrix ι ι ℂ) :
    ‖A‖ ^ 2 = ∑ i, ∑ j, ‖A i j‖ ^ 2 := by
  rw [Matrix.frobenius_norm_def]
  simp_rw [Real.rpow_two]
  rw [← Real.sqrt_eq_rpow, Real.sq_sqrt]
  exact Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => sq_nonneg _

/-- `QM-SPIN-THM-014`: `A ⊗ I₂` has twice the squared Frobenius norm of `A`. -/
theorem spinDegenerateLift_frobenius_norm_sq (A : Matrix ι ι ℂ) :
    ‖spinDegenerateLift A‖ ^ 2 = 2 * ‖A‖ ^ 2 := by
  rw [frobenius_norm_sq_eq_sum, frobenius_norm_sq_eq_sum]
  simp_rw [Fintype.sum_prod_type]
  simp [spinDegenerateLift, Matrix.one_apply, Fin.sum_univ_two, Finset.sum_add_distrib]
  ring

end ProjectKoios.QuantumMechanics.FiniteDimensional

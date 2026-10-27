/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinEmbedding

/-!
# Spin-independent projection

Exact source-neutral algebra for the spin-independent part of a finite spinful complex matrix.  The
partial spin trace sums the two diagonal spin blocks.  Dividing it by two gives the orbital matrix
whose degenerate lift is the spin-independent projection

`M ↦ ((Tr_spin M) / 2) ⊗ₖ I₂`.

The results prove recovery of exactly spin-degenerate matrices, idempotence, a fixed-point
characterization, trace and Hermiticity preservation, Frobenius orthogonality, a Pythagorean
identity, and unique least-distance approximation among spin-degenerate lifts.  They do not
establish a calculation's floating-point projection, runtime minimizer, time-reversal
implementation, eigenspectra, or physical applicability.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Kronecker Matrix Matrix.Norms.Frobenius

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- `QM-SPIN-PROJECTION-DEF-001`: sum the two diagonal spin blocks. -/
noncomputable def spinPartialTrace
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Matrix ι ι ℂ :=
  fun i j => ∑ s : Fin 2, M (i, s) (j, s)

/-- `QM-SPIN-PROJECTION-DEF-002`: average the two diagonal spin blocks. -/
noncomputable def spinIndependentPart
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Matrix ι ι ℂ :=
  (2 : ℂ)⁻¹ • spinPartialTrace M

/-- `QM-SPIN-PROJECTION-DEF-003`: lift the averaged diagonal spin block back to spin space. -/
noncomputable def spinIndependentProjection
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Matrix (ι × Fin 2) (ι × Fin 2) ℂ :=
  spinDegenerateLift (spinIndependentPart M)

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-001`: partial spin trace of `A ⊗ I₂` is `2A`. -/
@[simp] theorem spinPartialTrace_spinDegenerateLift (A : Matrix ι ι ℂ) :
    spinPartialTrace (spinDegenerateLift A) = 2 • A := by
  ext i j
  simp [spinPartialTrace]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-002`: averaging the partial spin trace recovers the orbital matrix. -/
@[simp] theorem spinIndependentPart_spinDegenerateLift (A : Matrix ι ι ℂ) :
    spinIndependentPart (spinDegenerateLift A) = A := by
  rw [spinIndependentPart, spinPartialTrace_spinDegenerateLift]
  ext i j
  rw [Matrix.smul_apply, Matrix.smul_apply]
  simp only [smul_eq_mul]
  ring_nf

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-003`: projection fixes every exactly spin-degenerate lift. -/
@[simp] theorem spinIndependentProjection_spinDegenerateLift (A : Matrix ι ι ℂ) :
    spinIndependentProjection (spinDegenerateLift A) = spinDegenerateLift A := by
  simp [spinIndependentProjection]

/-- `QM-SPIN-PROJECTION-THM-004`: partial spin trace is the sum of diagonal pullbacks. -/
theorem spinPartialTrace_eq_pullback_add (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinPartialTrace M = spinPullback 0 0 M + spinPullback 1 1 M := by
  ext i j
  simp [spinPartialTrace, Fin.sum_univ_two]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-005`: spin-independent projection is idempotent. -/
@[simp] theorem spinIndependentProjection_idempotent
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinIndependentProjection (spinIndependentProjection M) = spinIndependentProjection M := by
  simp [spinIndependentProjection]

omit [Fintype ι] [DecidableEq ι] in
/--
`QM-SPIN-PROJECTION-THM-006`: the projection fixes exactly the spin-degenerate lifts.
-/
theorem spinIndependentProjection_eq_self_iff
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinIndependentProjection M = M ↔ ∃ A : Matrix ι ι ℂ, M = spinDegenerateLift A := by
  constructor
  · intro h
    exact ⟨spinIndependentPart M, by simpa [spinIndependentProjection] using h.symm⟩
  · rintro ⟨A, rfl⟩
    simp

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-007`: entrywise formula for the spin-independent projection. -/
@[simp] theorem spinIndependentProjection_apply
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (i j : ι) (s t : Fin 2) :
    spinIndependentProjection M (i, s) (j, t) =
      if s = t then (M (i, 0) (j, 0) + M (i, 1) (j, 1)) / 2 else 0 := by
  simp [spinIndependentProjection, spinIndependentPart, spinPartialTrace, Fin.sum_univ_two]
  ring_nf

omit [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-008`: partial spin trace preserves total trace. -/
theorem spinPartialTrace_trace (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    Matrix.trace (spinPartialTrace M) = Matrix.trace M := by
  simp only [Matrix.trace, Matrix.diag_apply, spinPartialTrace]
  rw [Fintype.sum_prod_type]

omit [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-009`: spin-independent projection preserves total trace. -/
theorem spinIndependentProjection_trace (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    Matrix.trace (spinIndependentProjection M) = Matrix.trace M := by
  rw [spinIndependentProjection, spinDegenerateLift_trace]
  rw [spinIndependentPart, Matrix.trace_smul, spinPartialTrace_trace]
  ring_nf

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-010`: partial spin trace preserves Hermiticity. -/
theorem spinPartialTrace_isHermitian
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    (spinPartialTrace M).IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  simp only [spinPartialTrace]
  rw [star_sum]
  apply Finset.sum_congr rfl
  intro s _
  exact hM.apply (i, s) (j, s)

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-011`: the averaged partial spin trace preserves Hermiticity. -/
theorem spinIndependentPart_isHermitian
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    (spinIndependentPart M).IsHermitian := by
  apply (spinPartialTrace_isHermitian M hM).smul
  rw [isSelfAdjoint_iff]
  norm_num

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-012`: spin-independent projection preserves Hermiticity. -/
theorem spinIndependentProjection_isHermitian
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    (spinIndependentProjection M).IsHermitian := by
  exact spinDegenerateLift_isHermitian _ (spinIndependentPart_isHermitian M hM)

/--
`QM-SPIN-PROJECTION-DEF-004`: complex Frobenius pairing of two finite matrices.
-/
noncomputable def complexMatrixFrobeniusInner {ρ κ : Type*} [Fintype ρ] [Fintype κ]
    (A B : Matrix ρ κ ℂ) : ℂ :=
  ∑ i, ∑ j, conj (A i j) * B i j

private noncomputable def matrixFrobeniusVector {ρ κ : Type*}
    (A : Matrix ρ κ ℂ) : EuclideanSpace ℂ (ρ × κ) :=
  WithLp.toLp 2 fun p => A p.1 p.2

private theorem matrixFrobeniusVector_norm_sq {ρ κ : Type*} [Fintype ρ] [Fintype κ]
    (A : Matrix ρ κ ℂ) : ‖matrixFrobeniusVector A‖ ^ 2 = ‖A‖ ^ 2 := by
  rw [PiLp.norm_sq_eq_of_L2, Matrix.frobenius_norm_def]
  simp only [matrixFrobeniusVector, WithLp.ofLp_toLp]
  simp_rw [Real.rpow_two]
  rw [← Real.sqrt_eq_rpow, Real.sq_sqrt]
  · rw [Fintype.sum_prod_type]
  · exact Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => sq_nonneg _

private theorem matrixFrobeniusVector_add {ρ κ : Type*}
    (A B : Matrix ρ κ ℂ) :
    matrixFrobeniusVector (A + B) = matrixFrobeniusVector A + matrixFrobeniusVector B := by
  ext p
  rfl

private theorem matrixFrobeniusVector_inner {ρ κ : Type*} [Fintype ρ] [Fintype κ]
    (A B : Matrix ρ κ ℂ) :
    inner ℂ (matrixFrobeniusVector A) (matrixFrobeniusVector B) =
      complexMatrixFrobeniusInner A B := by
  rw [PiLp.inner_apply]
  simp only [matrixFrobeniusVector, WithLp.ofLp_toLp, complexMatrixFrobeniusInner,
    RCLike.inner_apply']
  rw [Fintype.sum_prod_type]

/--
`QM-SPIN-PROJECTION-THM-013`: the real part of Frobenius self-pairing is the squared
Mathlib Frobenius norm.
-/
theorem complexMatrixFrobeniusInner_self_re (A : Matrix ι ι ℂ) :
    (complexMatrixFrobeniusInner A A).re = ‖A‖ ^ 2 := by
  rw [frobenius_norm_sq_eq_sum]
  simp [complexMatrixFrobeniusInner, ← Complex.normSq_eq_conj_mul_self, Complex.sq_norm]

omit [DecidableEq ι] in
/--
`QM-SPIN-PROJECTION-THM-014`: pairing against a degenerate lift is pairing of the partial
spin trace against its orbital matrix.
-/
theorem complexMatrixFrobeniusInner_spinDegenerateLift
    (X : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (A : Matrix ι ι ℂ) :
    complexMatrixFrobeniusInner X (spinDegenerateLift A) =
      ∑ i, ∑ j, conj (spinPartialTrace X i j) * A i j := by
  simp only [complexMatrixFrobeniusInner]
  simp_rw [Fintype.sum_prod_type]
  simp [spinDegenerateLift_apply, spinPartialTrace, Fin.sum_univ_two,
    Finset.sum_add_distrib, add_mul]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PROJECTION-THM-015`: the projection residual has zero partial spin trace. -/
theorem spinPartialTrace_sub_projection
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinPartialTrace (M - spinIndependentProjection M) = 0 := by
  ext i j
  simp [spinPartialTrace, spinIndependentProjection_apply, Fin.sum_univ_two]
  ring_nf

omit [DecidableEq ι] in
/--
`QM-SPIN-PROJECTION-THM-016`: the projection residual is Frobenius-orthogonal to every
spin-degenerate lift.
-/
theorem spinIndependentProjection_residual_frobenius_orthogonal
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (A : Matrix ι ι ℂ) :
    complexMatrixFrobeniusInner (M - spinIndependentProjection M) (spinDegenerateLift A) = 0 := by
  rw [complexMatrixFrobeniusInner_spinDegenerateLift, spinPartialTrace_sub_projection]
  simp

/--
`QM-SPIN-PROJECTION-THM-017`: exact Frobenius Pythagorean identity relative to any
spin-degenerate candidate.
-/
theorem spinIndependentProjection_pythagorean
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (A : Matrix ι ι ℂ) :
    ‖M - spinDegenerateLift A‖ ^ 2 =
      ‖M - spinIndependentProjection M‖ ^ 2 +
        ‖spinIndependentProjection M - spinDegenerateLift A‖ ^ 2 := by
  let R := M - spinIndependentProjection M
  let D := spinIndependentProjection M - spinDegenerateLift A
  have hsum : M - spinDegenerateLift A = R + D := by
    simp [R, D]
  have hD : D = spinDegenerateLift (spinIndependentPart M - A) := by
    ext ⟨i, s⟩ ⟨j, t⟩
    simp [D, spinIndependentProjection]
    split <;> ring
  have horth : inner ℂ (matrixFrobeniusVector R) (matrixFrobeniusVector D) = 0 := by
    rw [matrixFrobeniusVector_inner, hD]
    exact spinIndependentProjection_residual_frobenius_orthogonal M _
  have hpyth := norm_add_sq_eq_norm_sq_add_norm_sq_of_inner_eq_zero
    (matrixFrobeniusVector R) (matrixFrobeniusVector D) horth
  simp only [← pow_two] at hpyth
  rw [← matrixFrobeniusVector_add, matrixFrobeniusVector_norm_sq,
    matrixFrobeniusVector_norm_sq, matrixFrobeniusVector_norm_sq] at hpyth
  rw [← hsum] at hpyth
  simpa only [R, D] using hpyth

/--
`QM-SPIN-PROJECTION-THM-018`: the half-partial-spin-trace projection minimizes Frobenius
distance over all spin-degenerate lifts.
-/
theorem spinIndependentProjection_frobenius_minimal
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (A : Matrix ι ι ℂ) :
    ‖M - spinIndependentProjection M‖ ≤ ‖M - spinDegenerateLift A‖ := by
  have h := spinIndependentProjection_pythagorean M A
  nlinarith [sq_nonneg ‖spinIndependentProjection M - spinDegenerateLift A‖,
    norm_nonneg (M - spinIndependentProjection M), norm_nonneg (M - spinDegenerateLift A)]

/--
`QM-SPIN-PROJECTION-THM-019`: equality in the Frobenius minimum uniquely determines the
orbital representative.
-/
theorem spinIndependentPart_eq_of_frobenius_eq
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (A : Matrix ι ι ℂ)
    (h : ‖M - spinDegenerateLift A‖ = ‖M - spinIndependentProjection M‖) :
    A = spinIndependentPart M := by
  have hp := spinIndependentProjection_pythagorean M A
  rw [h] at hp
  have hnormSq : ‖spinIndependentProjection M - spinDegenerateLift A‖ ^ 2 = 0 := by
    nlinarith
  have hnorm : ‖spinIndependentProjection M - spinDegenerateLift A‖ = 0 := by
    nlinarith [norm_nonneg (spinIndependentProjection M - spinDegenerateLift A)]
  have hmatrix : spinIndependentProjection M = spinDegenerateLift A := by
    exact sub_eq_zero.mp (norm_eq_zero.mp hnorm)
  apply spinDegenerateLift_injective
  simpa [spinIndependentProjection] using hmatrix.symm

end ProjectKoios.QuantumMechanics.FiniteDimensional

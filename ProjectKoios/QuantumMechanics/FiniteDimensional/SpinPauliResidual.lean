/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinIndependentProjection

/-!
# Pauli spin residual algebra

Exact source-neutral algebra for finite orbital matrices coupled to the standard two-state Pauli
matrices.  For orbital matrices `Bx`, `By`, and `Bz`, `spinPauliTerm` represents

`Bx ⊗ₖ σx + By ⊗ₖ σy + Bz ⊗ₖ σz`.

The results give its four spin blocks, zero partial spin trace, preservation of the scalar orbital
part under spin-independent projection, Hermiticity under explicit Hermitian coefficient
hypotheses, and the exact squared Frobenius residual

`2 * (‖Bx‖² + ‖By‖² + ‖Bz‖²)`.

No authored matrices, floating-point arrays, time-reversal model, numerical spectrum, or physical
spin interpretation is certified here.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Kronecker Matrix Matrix.Norms.Frobenius

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- `QM-SPIN-PAULI-DEF-001`: standard Pauli `x` matrix. -/
def spinPauliX : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, 1; 1, 0]

/-- `QM-SPIN-PAULI-DEF-002`: standard Pauli `y` matrix. -/
def spinPauliY : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, -Complex.I; Complex.I, 0]

/-- `QM-SPIN-PAULI-DEF-003`: standard Pauli `z` matrix. -/
def spinPauliZ : Matrix (Fin 2) (Fin 2) ℂ :=
  !![1, 0; 0, -1]

/-- `QM-SPIN-PAULI-DEF-004`: orbital matrices coupled to the three Pauli spin channels. -/
noncomputable def spinPauliTerm (Bx By Bz : Matrix ι ι ℂ) :
    Matrix (ι × Fin 2) (ι × Fin 2) ℂ :=
  Bx ⊗ₖ spinPauliX + By ⊗ₖ spinPauliY + Bz ⊗ₖ spinPauliZ

/-- `QM-SPIN-PAULI-DEF-005`: the collinear Pauli-`z` channel. -/
noncomputable def spinCollinearTerm (Z : Matrix ι ι ℂ) :
    Matrix (ι × Fin 2) (ι × Fin 2) ℂ :=
  Z ⊗ₖ spinPauliZ

/-- `QM-SPIN-PAULI-THM-001`: `σx` is Hermitian. -/
theorem spinPauliX_isHermitian : spinPauliX.IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  fin_cases i <;> fin_cases j <;> simp [spinPauliX]

/-- `QM-SPIN-PAULI-THM-002`: `σy` is Hermitian. -/
theorem spinPauliY_isHermitian : spinPauliY.IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  fin_cases i <;> fin_cases j <;> simp [spinPauliY]

/-- `QM-SPIN-PAULI-THM-003`: `σz` is Hermitian. -/
theorem spinPauliZ_isHermitian : spinPauliZ.IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  fin_cases i <;> fin_cases j <;> simp [spinPauliZ]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-004`: upper-left spin block of a Pauli term. -/
@[simp] theorem spinPauliTerm_apply_00 (Bx By Bz : Matrix ι ι ℂ) (i j : ι) :
    spinPauliTerm Bx By Bz (i, 0) (j, 0) = Bz i j := by
  simp [spinPauliTerm, spinPauliX, spinPauliY, spinPauliZ]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-005`: upper-right spin block of a Pauli term. -/
@[simp] theorem spinPauliTerm_apply_01 (Bx By Bz : Matrix ι ι ℂ) (i j : ι) :
    spinPauliTerm Bx By Bz (i, 0) (j, 1) = Bx i j - Complex.I * By i j := by
  simp [spinPauliTerm, spinPauliX, spinPauliY, spinPauliZ]
  ring

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-006`: lower-left spin block of a Pauli term. -/
@[simp] theorem spinPauliTerm_apply_10 (Bx By Bz : Matrix ι ι ℂ) (i j : ι) :
    spinPauliTerm Bx By Bz (i, 1) (j, 0) = Bx i j + Complex.I * By i j := by
  simp [spinPauliTerm, spinPauliX, spinPauliY, spinPauliZ]
  ring

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-007`: lower-right spin block of a Pauli term. -/
@[simp] theorem spinPauliTerm_apply_11 (Bx By Bz : Matrix ι ι ℂ) (i j : ι) :
    spinPauliTerm Bx By Bz (i, 1) (j, 1) = -Bz i j := by
  simp [spinPauliTerm, spinPauliX, spinPauliY, spinPauliZ]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-008`: every Pauli term has zero partial spin trace. -/
@[simp] theorem spinPartialTrace_spinPauliTerm (Bx By Bz : Matrix ι ι ℂ) :
    spinPartialTrace (spinPauliTerm Bx By Bz) = 0 := by
  ext i j
  simp [spinPartialTrace, Fin.sum_univ_two]

omit [Fintype ι] [DecidableEq ι] in
/--
`QM-SPIN-PAULI-THM-009`: the half-partial-spin-trace orbital part ignores Pauli channels.
-/
@[simp] theorem spinIndependentPart_lift_add_spinPauliTerm
    (A Bx By Bz : Matrix ι ι ℂ) :
    spinIndependentPart (spinDegenerateLift A + spinPauliTerm Bx By Bz) = A := by
  ext i j
  simp [spinIndependentPart, spinPartialTrace, Fin.sum_univ_two]
  ring_nf

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-010`: projection removes all Pauli channels from a scalar lift. -/
@[simp] theorem spinIndependentProjection_lift_add_spinPauliTerm
    (A Bx By Bz : Matrix ι ι ℂ) :
    spinIndependentProjection (spinDegenerateLift A + spinPauliTerm Bx By Bz) =
      spinDegenerateLift A := by
  simp [spinIndependentProjection]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-011`: Hermitian orbital coefficients give a Hermitian Pauli term. -/
theorem spinPauliTerm_isHermitian
    (Bx By Bz : Matrix ι ι ℂ) (hx : Bx.IsHermitian) (hy : By.IsHermitian)
    (hz : Bz.IsHermitian) : (spinPauliTerm Bx By Bz).IsHermitian := by
  unfold Matrix.IsHermitian at hx hy hz ⊢
  simp [spinPauliTerm, Matrix.conjTranspose_kronecker, hx, hy, hz,
    spinPauliX_isHermitian.eq, spinPauliY_isHermitian.eq, spinPauliZ_isHermitian.eq]

/--
`QM-SPIN-PAULI-THM-012`: squared Frobenius norm of a Pauli term is twice the sum of the
three squared orbital Frobenius norms.
-/
theorem spinPauliTerm_frobenius_norm_sq (Bx By Bz : Matrix ι ι ℂ) :
    ‖spinPauliTerm Bx By Bz‖ ^ 2 =
      2 * (‖Bx‖ ^ 2 + ‖By‖ ^ 2 + ‖Bz‖ ^ 2) := by
  rw [frobenius_norm_sq_eq_sum, frobenius_norm_sq_eq_sum,
    frobenius_norm_sq_eq_sum, frobenius_norm_sq_eq_sum]
  simp_rw [Fintype.sum_prod_type]
  have hentry (i j : ι) :
      (∑ s : Fin 2, ∑ t : Fin 2, ‖spinPauliTerm Bx By Bz (i, s) (j, t)‖ ^ 2) =
        2 * (‖Bx i j‖ ^ 2 + ‖By i j‖ ^ 2 + ‖Bz i j‖ ^ 2) := by
    simp [spinPauliTerm, spinPauliX, spinPauliY, spinPauliZ, Fin.sum_univ_two,
      Complex.sq_norm, Complex.normSq_apply]
    ring
  calc
    (∑ i, ∑ s, ∑ j, ∑ t, ‖spinPauliTerm Bx By Bz (i, s) (j, t)‖ ^ 2) =
        ∑ i, ∑ j, ∑ s, ∑ t, ‖spinPauliTerm Bx By Bz (i, s) (j, t)‖ ^ 2 := by
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.sum_comm]
    _ = ∑ i, ∑ j, 2 * (‖Bx i j‖ ^ 2 + ‖By i j‖ ^ 2 + ‖Bz i j‖ ^ 2) := by
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro j _
      exact hentry i j
    _ = 2 * ((∑ i, ∑ j, ‖Bx i j‖ ^ 2) + (∑ i, ∑ j, ‖By i j‖ ^ 2) +
        (∑ i, ∑ j, ‖Bz i j‖ ^ 2)) := by
      simp_rw [mul_add, Finset.sum_add_distrib]
      have hscale (B : Matrix ι ι ℂ) :
          (∑ i, ∑ j, 2 * ‖B i j‖ ^ 2) = 2 * (∑ i, ∑ j, ‖B i j‖ ^ 2) := by
        symm
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro i _
        rw [Finset.mul_sum]
      rw [hscale Bx, hscale By, hscale Bz]

/--
`QM-SPIN-PAULI-THM-013`: exact squared residual after projecting a scalar lift plus three
Pauli channels.
-/
theorem lift_add_spinPauliTerm_residual_norm_sq
    (A Bx By Bz : Matrix ι ι ℂ) :
    ‖(spinDegenerateLift A + spinPauliTerm Bx By Bz) -
      spinIndependentProjection (spinDegenerateLift A + spinPauliTerm Bx By Bz)‖ ^ 2 =
        2 * (‖Bx‖ ^ 2 + ‖By‖ ^ 2 + ‖Bz‖ ^ 2) := by
  rw [spinIndependentProjection_lift_add_spinPauliTerm]
  have h : (spinDegenerateLift A + spinPauliTerm Bx By Bz) - spinDegenerateLift A =
      spinPauliTerm Bx By Bz := by
    abel
  rw [h, spinPauliTerm_frobenius_norm_sq]

omit [Fintype ι] [DecidableEq ι] in
/-- `QM-SPIN-PAULI-THM-014`: the collinear channel is the Pauli term with only `Bz`. -/
theorem spinCollinearTerm_eq_spinPauliTerm (Z : Matrix ι ι ℂ) :
    spinCollinearTerm Z = spinPauliTerm 0 0 Z := by
  simp [spinCollinearTerm, spinPauliTerm]

/-- `QM-SPIN-PAULI-THM-015`: exact squared residual for a scalar lift plus collinear channel. -/
theorem lift_add_spinCollinearTerm_residual_norm_sq (A Z : Matrix ι ι ℂ) :
    ‖(spinDegenerateLift A + spinCollinearTerm Z) -
      spinIndependentProjection (spinDegenerateLift A + spinCollinearTerm Z)‖ ^ 2 =
        2 * ‖Z‖ ^ 2 := by
  rw [spinCollinearTerm_eq_spinPauliTerm, lift_add_spinPauliTerm_residual_norm_sq]
  simp

/--
`QM-SPIN-PAULI-THM-016`: exact Frobenius residual norm for the general three-channel Pauli
construction.
-/
theorem lift_add_spinPauliTerm_residual_norm (A Bx By Bz : Matrix ι ι ℂ) :
    ‖(spinDegenerateLift A + spinPauliTerm Bx By Bz) -
      spinIndependentProjection (spinDegenerateLift A + spinPauliTerm Bx By Bz)‖ =
        Real.sqrt (2 * (‖Bx‖ ^ 2 + ‖By‖ ^ 2 + ‖Bz‖ ^ 2)) := by
  have hsq := lift_add_spinPauliTerm_residual_norm_sq A Bx By Bz
  have hnonneg : 0 ≤ 2 * (‖Bx‖ ^ 2 + ‖By‖ ^ 2 + ‖Bz‖ ^ 2) := by positivity
  have hsqrt := Real.sq_sqrt hnonneg
  nlinarith [norm_nonneg ((spinDegenerateLift A + spinPauliTerm Bx By Bz) -
    spinIndependentProjection (spinDegenerateLift A + spinPauliTerm Bx By Bz)),
    Real.sqrt_nonneg (2 * (‖Bx‖ ^ 2 + ‖By‖ ^ 2 + ‖Bz‖ ^ 2))]

/--
`QM-SPIN-PAULI-THM-017`: exact collinear Frobenius residual norm is `√2 ‖Z‖`.
-/
theorem lift_add_spinCollinearTerm_residual_norm (A Z : Matrix ι ι ℂ) :
    ‖(spinDegenerateLift A + spinCollinearTerm Z) -
      spinIndependentProjection (spinDegenerateLift A + spinCollinearTerm Z)‖ =
        Real.sqrt 2 * ‖Z‖ := by
  have hsq := lift_add_spinCollinearTerm_residual_norm_sq A Z
  have hsqrt := Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)
  have hrhs : (Real.sqrt 2 * ‖Z‖) ^ 2 = 2 * ‖Z‖ ^ 2 := by
    rw [mul_pow, hsqrt]
  have hrhsnonneg : 0 ≤ Real.sqrt 2 * ‖Z‖ :=
    mul_nonneg (Real.sqrt_nonneg 2) (norm_nonneg Z)
  nlinarith [norm_nonneg ((spinDegenerateLift A + spinCollinearTerm Z) -
    spinIndependentProjection (spinDegenerateLift A + spinCollinearTerm Z)),
    Real.sqrt_nonneg 2, norm_nonneg Z]

end ProjectKoios.QuantumMechanics.FiniteDimensional

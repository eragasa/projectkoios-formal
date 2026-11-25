/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinPauliVector

/-!
# Pauli decomposition and fixed-axis collinearity

Exact source-neutral algebra for decomposing an arbitrary finite spinful complex matrix into its
spin-independent orbital part and three Pauli-channel orbital coefficients.  The fixed spin axis is
the standard `Fin 2` basis used throughout the finite-dimensional spin modules.

The principal reconstruction result is

`M = A₀ ⊗ₖ I₂ + Bx ⊗ₖ σx + By ⊗ₖ σy + Bz ⊗ₖ σz`,

where the four orbital matrices are recovered from the four selected-spin blocks of `M`.
Fixed-axis collinearity means that both cross-spin blocks vanish; equivalently, the `x` and `y`
Pauli coefficients vanish, the matrix is exactly a scalar lift plus a Pauli-`z` term, or the
matrix commutes with the lifted fixed-axis observable `I ⊗ₖ σz`.

These results do not identify the matrices with a density-functional Hamiltonian or density,
select a physical spin frame, establish collinearity in some rotated frame, introduce spin-orbit
coupling, or bind runtime arrays and numerical tolerances.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Kronecker Matrix

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- `QM-SPIN-DECOMPOSITION-DEF-001`: orbital coefficient of the Pauli-`x` channel. -/
noncomputable def spinPauliXPart
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Matrix ι ι ℂ :=
  (2 : ℂ)⁻¹ • (spinPullback 0 1 M + spinPullback 1 0 M)

/-- `QM-SPIN-DECOMPOSITION-DEF-002`: orbital coefficient of the Pauli-`y` channel. -/
noncomputable def spinPauliYPart
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Matrix ι ι ℂ :=
  (-Complex.I / 2) • (spinPullback 1 0 M - spinPullback 0 1 M)

/-- `QM-SPIN-DECOMPOSITION-DEF-003`: orbital coefficient of the Pauli-`z` channel. -/
noncomputable def spinPauliZPart
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Matrix ι ι ℂ :=
  (2 : ℂ)⁻¹ • (spinPullback 0 0 M - spinPullback 1 1 M)

/--
`QM-SPIN-DECOMPOSITION-DEF-004`: collinearity in the fixed standard spin basis means that both
cross-spin blocks vanish.
-/
def IsSpinCollinearZ (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Prop :=
  spinPullback 0 1 M = 0 ∧ spinPullback 1 0 M = 0

/-- `QM-SPIN-DECOMPOSITION-DEF-005`: the three recovered Pauli coefficients as one vector. -/
noncomputable def spinPauliPartVector
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Fin 3 → Matrix ι ι ℂ :=
  spinPauliCoefficientVector (spinPauliXPart M) (spinPauliYPart M) (spinPauliZPart M)

/-- `QM-SPIN-DECOMPOSITION-LEM-001`: recovered `x` coefficient of a scalar-plus-Pauli matrix. -/
@[simp] lemma spinPauliXPart_lift_add_spinPauliTerm
    (A Bx By Bz : Matrix ι ι ℂ) :
    spinPauliXPart (spinDegenerateLift A + spinPauliTerm Bx By Bz) = Bx := by
  ext i j
  simp [spinPauliXPart]
  ring_nf

/-- `QM-SPIN-DECOMPOSITION-LEM-002`: recovered `y` coefficient of a scalar-plus-Pauli matrix. -/
@[simp] lemma spinPauliYPart_lift_add_spinPauliTerm
    (A Bx By Bz : Matrix ι ι ℂ) :
    spinPauliYPart (spinDegenerateLift A + spinPauliTerm Bx By Bz) = By := by
  ext i j
  simp [spinPauliYPart]
  ring_nf
  simp [Complex.I_sq]

/-- `QM-SPIN-DECOMPOSITION-LEM-003`: recovered `z` coefficient of a scalar-plus-Pauli matrix. -/
@[simp] lemma spinPauliZPart_lift_add_spinPauliTerm
    (A Bx By Bz : Matrix ι ι ℂ) :
    spinPauliZPart (spinDegenerateLift A + spinPauliTerm Bx By Bz) = Bz := by
  ext i j
  simp [spinPauliZPart]
  ring_nf

/-- `QM-SPIN-DECOMPOSITION-LEM-004`: conjugate transpose reverses a selected spin pullback. -/
lemma spinPullback_conjTranspose (s t : Fin 2)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    (spinPullback s t M)ᴴ = spinPullback t s Mᴴ := by
  simp [spinPullback, Matrix.conjTranspose_mul, Matrix.mul_assoc]

/-- `QM-SPIN-DECOMPOSITION-LEM-005`: a Hermitian spinful matrix has Hermitian `x` coefficient. -/
lemma spinPauliXPart_isHermitian
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    (spinPauliXPart M).IsHermitian := by
  unfold Matrix.IsHermitian spinPauliXPart
  simp [spinPullback_conjTranspose, hM.eq, add_comm]

/-- `QM-SPIN-DECOMPOSITION-LEM-006`: a Hermitian spinful matrix has Hermitian `y` coefficient. -/
lemma spinPauliYPart_isHermitian
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    (spinPauliYPart M).IsHermitian := by
  unfold Matrix.IsHermitian spinPauliYPart
  simp [spinPullback_conjTranspose, hM.eq]
  module

/-- `QM-SPIN-DECOMPOSITION-LEM-007`: a Hermitian spinful matrix has Hermitian `z` coefficient. -/
lemma spinPauliZPart_isHermitian
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    (spinPauliZPart M).IsHermitian := by
  unfold Matrix.IsHermitian spinPauliZPart
  simp [spinPullback_conjTranspose, hM.eq]

/--
`QM-SPIN-DECOMPOSITION-THM-001`: every finite spinful complex matrix has its exact canonical
scalar-plus-Pauli reconstruction in the fixed standard spin basis.
-/
theorem spinPauliDecomposition
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    M = spinDegenerateLift (spinIndependentPart M) +
      spinPauliTerm (spinPauliXPart M) (spinPauliYPart M) (spinPauliZPart M) := by
  ext ⟨i, s⟩ ⟨j, t⟩
  fin_cases s <;> fin_cases t
  all_goals
    simp [spinIndependentPart, spinPartialTrace, spinPauliXPart, spinPauliYPart,
      spinPauliZPart, Fin.sum_univ_two]
  all_goals ring_nf
  all_goals simp [Complex.I_sq]
  all_goals ring

/--
`QM-SPIN-DECOMPOSITION-THM-002`: vector form of the canonical scalar-plus-Pauli reconstruction.
-/
theorem spinPauliVectorDecomposition
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    M = spinDegenerateLift (spinIndependentPart M) + spinPauliDot (spinPauliPartVector M) := by
  calc
    M = spinDegenerateLift (spinIndependentPart M) +
        spinPauliTerm (spinPauliXPart M) (spinPauliYPart M) (spinPauliZPart M) :=
      spinPauliDecomposition M
    _ = spinDegenerateLift (spinIndependentPart M) + spinPauliDot (spinPauliPartVector M) := by
      rw [spinPauliPartVector, spinPauliDot_coefficientVector]

/--
`QM-SPIN-DECOMPOSITION-THM-003`: fixed-axis collinearity is equivalent to vanishing transverse
Pauli coefficients.
-/
theorem isSpinCollinearZ_iff_pauliXY_eq_zero
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsSpinCollinearZ M ↔ spinPauliXPart M = 0 ∧ spinPauliYPart M = 0 := by
  constructor
  · rintro ⟨h01, h10⟩
    simp [spinPauliXPart, spinPauliYPart, h01, h10]
  · rintro ⟨hx, hy⟩
    constructor
    · ext i j
      have hxij := congrFun (congrFun hx i) j
      have hyij := congrFun (congrFun hy i) j
      simp [spinPauliXPart] at hxij
      simp [spinPauliYPart] at hyij
      simp
      linear_combination (1 / 2 : ℂ) * hxij - (1 / 2 : ℂ) * hyij
    · ext i j
      have hxij := congrFun (congrFun hx i) j
      have hyij := congrFun (congrFun hy i) j
      simp [spinPauliXPart] at hxij
      simp [spinPauliYPart] at hyij
      simp
      linear_combination (1 / 2 : ℂ) * hxij + (1 / 2 : ℂ) * hyij

/--
`QM-SPIN-DECOMPOSITION-THM-004`: fixed-axis collinearity is exactly representability as a
spin-independent lift plus a Pauli-`z` channel.
-/
theorem isSpinCollinearZ_iff_exists_lift_add_spinCollinearTerm
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsSpinCollinearZ M ↔
      ∃ A Z : Matrix ι ι ℂ, M = spinDegenerateLift A + spinCollinearTerm Z := by
  constructor
  · intro hM
    rw [isSpinCollinearZ_iff_pauliXY_eq_zero] at hM
    refine ⟨spinIndependentPart M, spinPauliZPart M, ?_⟩
    calc
      M = spinDegenerateLift (spinIndependentPart M) +
          spinPauliTerm (spinPauliXPart M) (spinPauliYPart M) (spinPauliZPart M) :=
        spinPauliDecomposition M
      _ = spinDegenerateLift (spinIndependentPart M) +
          spinCollinearTerm (spinPauliZPart M) := by
        rw [hM.1, hM.2, ← spinCollinearTerm_eq_spinPauliTerm]
  · rintro ⟨A, Z, rfl⟩
    constructor <;> ext i j <;> simp [spinCollinearTerm, spinPauliZ]

/--
`QM-SPIN-DECOMPOSITION-THM-005`: all three recovered Pauli coefficients of a Hermitian spinful
matrix are Hermitian.
-/
theorem spinPauliPartVector_isHermitian
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) (hM : M.IsHermitian) :
    ∀ a, (spinPauliPartVector M a).IsHermitian := by
  intro a
  fin_cases a
  · exact spinPauliXPart_isHermitian M hM
  · exact spinPauliYPart_isHermitian M hM
  · exact spinPauliZPart_isHermitian M hM

/--
`QM-SPIN-DECOMPOSITION-THM-006`: fixed-`z` collinearity is equivalent to commuting with the
lifted fixed-axis Pauli observable `I ⊗ₖ σz`.

The statement is purely basis-relative finite matrix algebra.  It does not assert that one common
axis works for a spatial density field, nor that a physical Hamiltonian conserves spin once
spin--orbit coupling is present.
-/
theorem isSpinCollinearZ_iff_commute_spinCollinearTerm_one
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsSpinCollinearZ M ↔
      Commute M (spinCollinearTerm (1 : Matrix ι ι ℂ)) := by
  constructor
  · rintro ⟨h01, h10⟩
    rw [commute_iff_eq]

    -- The collinearity hypothesis says precisely that the two cross-spin entries vanish.
    have h01_apply (i j : ι) : M (i, 0) (j, 1) = 0 := by
      simpa using congrFun (congrFun h01 i) j
    have h10_apply (i j : ι) : M (i, 1) (j, 0) = 0 := by
      simpa using congrFun (congrFun h10 i) j

    -- On the diagonal spin blocks, left and right multiplication by `I ⊗ₖ σz` agree.
    -- On the cross blocks, the two signs differ, but both blocks are zero by hypothesis.
    ext ⟨i, s⟩ ⟨j, t⟩
    fin_cases s <;> fin_cases t <;>
      simp [spinCollinearTerm, spinPauliZ, Matrix.mul_apply, Fintype.sum_prod_type,
        Fin.sum_univ_two, Matrix.one_apply, h01_apply, h10_apply]
  · rw [commute_iff_eq]
    intro hCommute
    constructor
    · ext i j
      -- The `(0,1)` block equation is `-M₀₁ = M₀₁`, hence `M₀₁ = 0` over `ℂ`.
      have hij := congrFun (congrFun hCommute (i, 0)) (j, 1)
      simp [spinCollinearTerm, spinPauliZ, Matrix.mul_apply, Fintype.sum_prod_type,
        Fin.sum_univ_two, Matrix.one_apply] at hij
      simp
      linear_combination (-1 / 2 : ℂ) * hij
    · ext i j
      -- The `(1,0)` block equation is `M₁₀ = -M₁₀`, hence `M₁₀ = 0`.
      have hij := congrFun (congrFun hCommute (i, 1)) (j, 0)
      simp [spinCollinearTerm, spinPauliZ, Matrix.mul_apply, Fintype.sum_prod_type,
        Fin.sum_univ_two, Matrix.one_apply] at hij
      simp
      linear_combination (1 / 2 : ℂ) * hij

end ProjectKoios.QuantumMechanics.FiniteDimensional

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinPauliResidual

/-!
# Pauli-vector algebra

Exact source-neutral finite-matrix algebra for the standard ordered Pauli vector
`(σx, σy, σz)`.  Besides the coordinate family itself, this module provides an orbital-matrix
coefficient vector and its Kronecker contraction with the Pauli vector.  It also records the core
Hermiticity, square, anticommutator, commutator, and trace-orthogonality identities.

The coordinate order is fixed as `x = 0`, `y = 1`, and `z = 2`.  No physical spin frame, units,
angular-momentum normalization, density-functional meaning, or spin-orbit coupling is inferred.
-/

@[expose] public section

open scoped BigOperators Kronecker Matrix

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

/-- `QM-SPIN-VECTOR-DEF-001`: the ordered Pauli vector `(σx, σy, σz)`. -/
def spinPauliVector : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ :=
  ![spinPauliX, spinPauliY, spinPauliZ]

/-- `QM-SPIN-VECTOR-DEF-002`: package three orbital coefficient matrices as an ordered vector. -/
def spinPauliCoefficientVector {ι : Type*}
    (Bx By Bz : Matrix ι ι ℂ) : Fin 3 → Matrix ι ι ℂ :=
  ![Bx, By, Bz]

/--
`QM-SPIN-VECTOR-DEF-003`: Kronecker contraction of an orbital coefficient vector with the Pauli
vector.
-/
noncomputable def spinPauliDot {ι : Type*} [Fintype ι]
    (B : Fin 3 → Matrix ι ι ℂ) : Matrix (ι × Fin 2) (ι × Fin 2) ℂ :=
  ∑ a, B a ⊗ₖ spinPauliVector a

/-- `QM-SPIN-VECTOR-DEF-004`: the three-dimensional Levi--Civita symbol in `x,y,z` order. -/
def spinLeviCivita : Fin 3 → Fin 3 → Fin 3 → ℤ :=
  ![
    ![![0, 0, 0], ![0, 0, 1], ![0, -1, 0]],
    ![![0, 0, -1], ![0, 0, 0], ![1, 0, 0]],
    ![![0, 1, 0], ![-1, 0, 0], ![0, 0, 0]]
  ]

/-- `QM-SPIN-VECTOR-LEM-001`: coordinate zero of the Pauli vector is `σx`. -/
@[simp] lemma spinPauliVector_zero : spinPauliVector 0 = spinPauliX := by
  rfl

/-- `QM-SPIN-VECTOR-LEM-002`: coordinate one of the Pauli vector is `σy`. -/
@[simp] lemma spinPauliVector_one : spinPauliVector 1 = spinPauliY := by
  rfl

/-- `QM-SPIN-VECTOR-LEM-003`: coordinate two of the Pauli vector is `σz`. -/
@[simp] lemma spinPauliVector_two : spinPauliVector 2 = spinPauliZ := by
  rfl

/--
`QM-SPIN-VECTOR-THM-001`: the vector contraction recovers the existing explicit three-channel
Pauli term.
-/
theorem spinPauliDot_coefficientVector {ι : Type*} [Fintype ι]
    (Bx By Bz : Matrix ι ι ℂ) :
    spinPauliDot (spinPauliCoefficientVector Bx By Bz) = spinPauliTerm Bx By Bz := by
  simp [spinPauliDot, spinPauliCoefficientVector, spinPauliVector, Fin.sum_univ_three,
    spinPauliTerm]

/-- `QM-SPIN-VECTOR-THM-002`: every coordinate of the Pauli vector is Hermitian. -/
theorem spinPauliVector_isHermitian (a : Fin 3) : (spinPauliVector a).IsHermitian := by
  fin_cases a
  · exact spinPauliX_isHermitian
  · exact spinPauliY_isHermitian
  · exact spinPauliZ_isHermitian

/-- `QM-SPIN-VECTOR-LEM-004`: every Pauli coordinate squares to the spin identity. -/
@[simp] lemma spinPauliVector_mul_self (a : Fin 3) :
    spinPauliVector a * spinPauliVector a = 1 := by
  fin_cases a <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [spinPauliVector, spinPauliX, spinPauliY, spinPauliZ, Matrix.mul_apply,
      Fin.sum_univ_two, Complex.I_mul_I]

/--
`QM-SPIN-VECTOR-THM-003`: Pauli anticommutators equal twice the identity on equal coordinates and
vanish on distinct coordinates.
-/
theorem spinPauliVector_anticommutator (a b : Fin 3) :
    spinPauliVector a * spinPauliVector b + spinPauliVector b * spinPauliVector a =
      if a = b then 2 • (1 : Matrix (Fin 2) (Fin 2) ℂ) else 0 := by
  fin_cases a <;> fin_cases b <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [spinPauliVector, spinPauliX, spinPauliY, spinPauliZ, Complex.I_mul_I] <;> ring

/-- `QM-SPIN-VECTOR-LEM-005`: `[σx, σy] = 2i σz`. -/
lemma spinPauliX_commutator_spinPauliY :
    spinPauliX * spinPauliY - spinPauliY * spinPauliX =
      (2 * Complex.I) • spinPauliZ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [spinPauliX, spinPauliY, spinPauliZ] <;> ring

/-- `QM-SPIN-VECTOR-LEM-006`: `[σy, σz] = 2i σx`. -/
lemma spinPauliY_commutator_spinPauliZ :
    spinPauliY * spinPauliZ - spinPauliZ * spinPauliY =
      (2 * Complex.I) • spinPauliX := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [spinPauliX, spinPauliY, spinPauliZ] <;> ring

/-- `QM-SPIN-VECTOR-LEM-007`: `[σz, σx] = 2i σy`. -/
lemma spinPauliZ_commutator_spinPauliX :
    spinPauliZ * spinPauliX - spinPauliX * spinPauliZ =
      (2 * Complex.I) • spinPauliY := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [spinPauliX, spinPauliY, spinPauliZ]
  all_goals ring_nf
  all_goals simp [Complex.I_sq]

/--
`QM-SPIN-VECTOR-THM-004`: Pauli commutators are the Levi--Civita contraction
`2i εᵢⱼₖ σₖ`.
-/
theorem spinPauliVector_commutator (a b : Fin 3) :
    spinPauliVector a * spinPauliVector b - spinPauliVector b * spinPauliVector a =
      (2 * Complex.I) •
        ∑ k, (spinLeviCivita a b k : ℂ) • spinPauliVector k := by
  fin_cases a <;> fin_cases b <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [spinPauliVector, spinLeviCivita, spinPauliX, spinPauliY, spinPauliZ,
      Fin.sum_univ_three]
  all_goals ring_nf
  all_goals simp [Complex.I_sq]

/-- `QM-SPIN-VECTOR-LEM-008`: every Pauli coordinate is traceless. -/
@[simp] lemma trace_spinPauliVector (a : Fin 3) : Matrix.trace (spinPauliVector a) = 0 := by
  fin_cases a <;> simp [spinPauliVector, spinPauliX, spinPauliY, spinPauliZ, Matrix.trace,
    Fin.sum_univ_two]

/--
`QM-SPIN-VECTOR-THM-005`: Pauli coordinates are trace-orthogonal, with squared trace norm two.
-/
theorem trace_spinPauliVector_mul (a b : Fin 3) :
    Matrix.trace (spinPauliVector a * spinPauliVector b) = if a = b then 2 else 0 := by
  fin_cases a <;> fin_cases b <;>
    simp [spinPauliVector, spinPauliX, spinPauliY, spinPauliZ,
      Matrix.trace, Fin.sum_univ_two, Complex.I_mul_I] <;> ring

/-- `QM-SPIN-VECTOR-THM-006`: every Pauli coordinate is a unitary matrix. -/
theorem spinPauliVector_mem_unitaryGroup (a : Fin 3) :
    spinPauliVector a ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  rw [Matrix.mem_unitaryGroup_iff']
  change (spinPauliVector a)ᴴ * spinPauliVector a = 1
  rw [(spinPauliVector_isHermitian a).eq, spinPauliVector_mul_self]

/--
`QM-SPIN-VECTOR-THM-007`: Pauli multiplication is the Kronecker-delta identity plus the
Levi--Civita contraction `i εᵢⱼₖ σₖ`.
-/
theorem spinPauliVector_mul (a b : Fin 3) :
    spinPauliVector a * spinPauliVector b =
      (if a = b then (1 : Matrix (Fin 2) (Fin 2) ℂ) else 0) +
        Complex.I • ∑ k, (spinLeviCivita a b k : ℂ) • spinPauliVector k := by
  fin_cases a <;> fin_cases b <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [spinPauliVector, spinLeviCivita, spinPauliX, spinPauliY, spinPauliZ,
      Fin.sum_univ_three]

end ProjectKoios.QuantumMechanics.FiniteDimensional

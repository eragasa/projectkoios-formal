/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-27
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinPauliVector
public import PhyslibAlpha.QuantumMechanics.AngularMomentum.SpinHalf
public import PhyslibAlpha.QuantumMechanics.AngularMomentum.SpinOrbit

/-!
# Finite spin-half and spin-orbit bindings

This module crosswalks Project Koios's source-neutral Pauli matrices to Physlib's Pauli matrices and
then adopts PhyslibAlpha's finite-dimensional angular-momentum and spin-orbit APIs. It identifies
the standard spin-half representation matrices with one half of the Project Koios Pauli matrices
and exposes the adopted `L · S` operator, its coupled-state eigenvalue, the spin-half doublet, and
Landé's interval rule.

PhyslibAlpha's representation-theoretic convention in this layer is dimensionless `ℏ = 1`.
Accordingly, these declarations do not identify the finite algebraic operator with the continuum
orbital operator from `Continuum.lean`, attach a dimensional coupling constant, define a
position-dependent SOC Hamiltonian, bind a DFT effective potential, or establish physical
applicability.
-/

@[expose] public section

noncomputable section

open scoped TensorProduct

namespace ProjectKoios.QuantumMechanics.AngularMomentum

open ProjectKoios.QuantumMechanics.FiniteDimensional
open PhyslibAlpha.Sl2
open PhyslibAlpha.Sl2.AngularMomentumRepresentation

/-- `QM-SPIN-BINDING-LEM-001`: the Project Koios ordered Pauli vector is exactly Physlib's ordered
spatial Pauli-matrix family. -/
lemma spinPauliVector_eq_physlibPauliMatrix (a : Fin 3) :
    spinPauliVector a = PauliMatrix.pauliMatrix (Sum.inr a) := by
  fin_cases a <;> rfl

/-- `QM-SPIN-BINDING-LEM-002`: the standard spin-half `Jx` matrix is one half of the Project Koios
`σx` matrix. -/
lemma standardSpinHalf_Jx_matrix :
    LinearMap.toMatrix' (standard 1).Jx = (1 / 2 : ℂ) • spinPauliX := by
  rw [toMatrix'_standard_one_Jx]
  rfl

/-- `QM-SPIN-BINDING-LEM-003`: the standard spin-half `Jy` matrix is one half of the Project Koios
`σy` matrix. -/
lemma standardSpinHalf_Jy_matrix :
    LinearMap.toMatrix' (standard 1).Jy = (1 / 2 : ℂ) • spinPauliY := by
  rw [toMatrix'_standard_one_Jy]
  rfl

/-- `QM-SPIN-BINDING-LEM-004`: the standard spin-half `Jz` matrix is one half of the Project Koios
`σz` matrix. -/
lemma standardSpinHalf_Jz_matrix :
    LinearMap.toMatrix' (standard 1).Jz = (1 / 2 : ℂ) • spinPauliZ := by
  rw [toMatrix'_standard_one_Jz]
  rfl

/-- `QM-SOC-DEF-001`: PhyslibAlpha's dimensionless finite spin-orbit operator `L · S` on the tensor
product of the standard spin-`m/2` and spin-`n/2` representations. -/
noncomputable def standardSpinOrbitOperator (m n : ℕ) :=
  dot (standard m) (standard n)

/-- `QM-SOC-DEF-002`: the adopted spin-orbit eigenvalue for the `k`-th coupled lowering string. -/
def spinOrbitEigenvalue (m n k : ℕ) : ℂ :=
  spinOrbitValue m n k

/-- `QM-SOC-LEM-001`: every vector in the admitted coupled lowering string is an eigenvector of the
standard finite spin-orbit operator. -/
lemma standardSpinOrbitOperator_coupled_stringVec {m n k : ℕ}
    (hmn : 0 < m + n) (hkm : k ≤ m) (hkn : k ≤ n) (l : ℕ) :
    standardSpinOrbitOperator m n (stringVec m n k l) =
      spinOrbitEigenvalue m n k • stringVec m n k l := by
  exact dot_coupled_stringVec hmn hkm hkn l

/-- `QM-SOC-LEM-002`: for spin one half, the upper coupled string has `L · S` eigenvalue `l/2`,
where the orbital representation has `l = m/2`. -/
lemma standardSpinOrbitOperator_doublet_upper {m : ℕ} (l' : ℕ) :
    standardSpinOrbitOperator m 1 (stringVec m 1 0 l') =
      ((m : ℂ) / 4) • stringVec m 1 0 l' := by
  exact dot_coupled_stringVec_doublet_upper l'

/-- `QM-SOC-LEM-003`: for `m ≥ 1` and spin one half, the lower coupled string has `L · S`
eigenvalue `-(l+1)/2`, where `l = m/2`. -/
lemma standardSpinOrbitOperator_doublet_lower {m : ℕ} (hm : 1 ≤ m) (l' : ℕ) :
    standardSpinOrbitOperator m 1 (stringVec m 1 1 l') =
      (-((m : ℂ) + 2) / 4) • stringVec m 1 1 l' := by
  exact dot_coupled_stringVec_doublet_lower hm l'

/-- `QM-SOC-LEM-004`: the dimensionless spin-half doublet splitting is `(2l+1)/2`, with
`l = m/2`. -/
lemma spinOrbitEigenvalue_doublet_sub {m : ℕ} (hm : 1 ≤ m) :
    spinOrbitEigenvalue m 1 0 - spinOrbitEigenvalue m 1 1 = ((m : ℂ) + 1) / 2 := by
  exact spinOrbitValue_doublet_sub hm

/-- `QM-SOC-LEM-005`: neighbouring coupled multiplet levels satisfy Landé's interval rule in the
adopted dimensionless convention. -/
lemma spinOrbitEigenvalue_sub_succ {m n k : ℕ}
    (hkm : k + 1 ≤ m) (hkn : k + 1 ≤ n) :
    spinOrbitEigenvalue m n k - spinOrbitEigenvalue m n (k + 1) =
      ((m + n - 2 * k : ℕ) : ℂ) / 2 := by
  exact spinOrbitValue_sub_succ hkm hkn

end ProjectKoios.QuantumMechanics.AngularMomentum

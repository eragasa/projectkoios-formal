/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.LinearAlgebra.Matrix.ToLin
public import ProjectKoios.QuantumMechanics.FiniteDifference.CenteredDirichlet1D
public import ProjectKoios.QuantumMechanics.FiniteDifference.ExponentialMode1D

/-!
# Finite Dirichlet matrix realization of lattice modes

This module bridges the integer-lattice centered recurrence to an exact finite `Matrix.mulVec`
equation.  Boundary values are supplied by zero extension, independently of any floating-point
array representation.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-DIRICHLET-MATRIX-DEF-001`: left neighbor with a zero Dirichlet ghost value. -/
def leftDirichletValue {N : ℕ} (v : Fin N → ℂ) (i : Fin N) : ℂ :=
  if h : 0 < i.val then v ⟨i.val - 1, by omega⟩ else 0

/-- `QM-DIRICHLET-MATRIX-DEF-002`: right neighbor with a zero Dirichlet ghost value. -/
def rightDirichletValue {N : ℕ} (v : Fin N → ℂ) (i : Fin N) : ℂ :=
  if h : i.val + 1 < N then v ⟨i.val + 1, h⟩ else 0

/-- `QM-DIRICHLET-MATRIX-DEF-003`: unscaled negative centered difference on interior coordinates. -/
def negativeDirichletDifference {N : ℕ} (v : Fin N → ℂ) (i : Fin N) : ℂ :=
  2 * v i - leftDirichletValue v i - rightDirichletValue v i

/-- `QM-DIRICHLET-MATRIX-DEF-004`: complex-linear finite Dirichlet difference operator. -/
noncomputable def negativeDirichletDifferenceLinearMap (N : ℕ) :
    (Fin N → ℂ) →ₗ[ℂ] (Fin N → ℂ) where
  toFun v := negativeDirichletDifference v
  map_add' v w := by
    funext i
    simp only [negativeDirichletDifference, Pi.add_apply]
    unfold leftDirichletValue rightDirichletValue
    split_ifs <;> simp <;> ring
  map_smul' c v := by
    funext i
    simp only [negativeDirichletDifference, Pi.smul_apply, smul_eq_mul]
    unfold leftDirichletValue rightDirichletValue
    split_ifs <;> simp <;> ring

/-- `QM-DIRICHLET-MATRIX-DEF-005`: exact matrix of the finite Dirichlet difference operator. -/
noncomputable def negativeDirichletDifferenceMatrix (N : ℕ) : Matrix (Fin N) (Fin N) ℂ :=
  LinearMap.toMatrix' (negativeDirichletDifferenceLinearMap N)

/-- `QM-DIRICHLET-MATRIX-THM-001`: the matrix acts exactly as the declared finite operator. -/
theorem negativeDirichletDifferenceMatrix_mulVec (N : ℕ) (v : Fin N → ℂ) :
    Matrix.mulVec (negativeDirichletDifferenceMatrix N) v = negativeDirichletDifference v := by
  exact LinearMap.toMatrix'_mulVec (negativeDirichletDifferenceLinearMap N) v

/-- `QM-DIRICHLET-MATRIX-DEF-006`: restriction of an antisymmetric lattice mode to the interior. -/
noncomputable def finiteAntisymmetricExponentialMode (N : ℕ) (z : ℂ) : Fin N → ℂ :=
  fun i => antisymmetricExponentialMode z (Int.ofNat (i.val + 1))

/-- `QM-DIRICHLET-MATRIX-LEM-001`: the zero left ghost agrees with the endpoint mode value. -/
lemma leftDirichletValue_finiteAntisymmetricExponentialMode
    (N : ℕ) (z : ℂ) (i : Fin N) :
    leftDirichletValue (finiteAntisymmetricExponentialMode N z) i =
      antisymmetricExponentialMode z (Int.ofNat i.val) := by
  unfold leftDirichletValue finiteAntisymmetricExponentialMode
  split_ifs with h
  · change antisymmetricExponentialMode z (Int.ofNat (i.val - 1 + 1)) = _
    rw [show i.val - 1 + 1 = i.val by omega]
  · rw [show i.val = 0 by omega]
    simpa using (antisymmetricExponentialMode_zero z).symm

/-- `QM-DIRICHLET-MATRIX-LEM-002`: the zero right ghost agrees with a vanishing endpoint mode. -/
lemma rightDirichletValue_finiteAntisymmetricExponentialMode
    (N : ℕ) (z : ℂ)
    (hright : antisymmetricExponentialMode z (Int.ofNat (N + 1)) = 0)
    (i : Fin N) :
    rightDirichletValue (finiteAntisymmetricExponentialMode N z) i =
      antisymmetricExponentialMode z (Int.ofNat (i.val + 2)) := by
  unfold rightDirichletValue finiteAntisymmetricExponentialMode
  split_ifs with h
  · congr 1
  · rw [show i.val + 2 = N + 1 by omega]
    exact hright.symm

/--
`QM-DIRICHLET-MATRIX-THM-002`: an antisymmetric exponential satisfying the right boundary
condition is an exact eigenvector of the finite Dirichlet difference matrix.
-/
theorem negativeDirichletDifferenceMatrix_mulVec_finiteAntisymmetricExponentialMode
    (N : ℕ) (z : ℂ) (hz : z ≠ 0)
    (hright : antisymmetricExponentialMode z (Int.ofNat (N + 1)) = 0) :
    Matrix.mulVec (negativeDirichletDifferenceMatrix N) (finiteAntisymmetricExponentialMode N z) =
      (2 - z⁻¹ - z) • finiteAntisymmetricExponentialMode N z := by
  rw [negativeDirichletDifferenceMatrix_mulVec]
  funext i
  rw [Pi.smul_apply, smul_eq_mul]
  unfold negativeDirichletDifference
  rw [leftDirichletValue_finiteAntisymmetricExponentialMode,
    rightDirichletValue_finiteAntisymmetricExponentialMode N z hright]
  have hrec := negativeSecondDifferenceAt_antisymmetricExponentialMode
    z hz (Int.ofNat (i.val + 1))
  unfold negativeSecondDifferenceAt at hrec
  norm_num at hrec ⊢
  convert hrec using 1 <;> congr 2

/-- `QM-DIRICHLET-MATRIX-DEF-007`: finite sine-normalized exponential mode. -/
noncomputable def finiteNormalizedAntisymmetricExponentialMode (N : ℕ) (z : ℂ) : Fin N → ℂ :=
  fun i => normalizedAntisymmetricExponentialMode z (Int.ofNat (i.val + 1))

/--
`QM-DIRICHLET-MATRIX-THM-003`: sine normalization preserves the exact finite matrix eigenpair.
-/
theorem negativeDirichletDifferenceMatrix_mulVec_finiteNormalizedAntisymmetricExponentialMode
    (N : ℕ) (z : ℂ) (hz : z ≠ 0)
    (hright : antisymmetricExponentialMode z (Int.ofNat (N + 1)) = 0) :
    Matrix.mulVec (negativeDirichletDifferenceMatrix N)
        (finiteNormalizedAntisymmetricExponentialMode N z) =
      (2 - z⁻¹ - z) • finiteNormalizedAntisymmetricExponentialMode N z := by
  have h := negativeDirichletDifferenceMatrix_mulVec_finiteAntisymmetricExponentialMode
    N z hz hright
  have hv : finiteNormalizedAntisymmetricExponentialMode N z =
      (1 / (2 * Complex.I)) • finiteAntisymmetricExponentialMode N z := by
    funext i
    simp [finiteNormalizedAntisymmetricExponentialMode,
      normalizedAntisymmetricExponentialMode, finiteAntisymmetricExponentialMode, div_eq_mul_inv]
    ring
  rw [hv, Matrix.mulVec_smul, h]
  simp only [smul_smul]
  congr 1
  ring

/--
`QM-DIRICHLET-MATRIX-THM-004`: the exact complex difference matrix is the negative complexification
of the unit-spacing real centered Dirichlet stencil.
-/
theorem negativeDirichletDifferenceMatrix_eq_neg_map_centeredDirichletLaplacian1D
    (N : ℕ) :
    negativeDirichletDifferenceMatrix N =
      - (centeredDirichletLaplacian1D N 1).map Complex.ofReal := by
  ext i j
  rw [show negativeDirichletDifferenceMatrix N i j =
      negativeDirichletDifference (Pi.single j 1) i by rfl]
  unfold negativeDirichletDifference leftDirichletValue rightDirichletValue
  simp only [Matrix.neg_apply, Matrix.map_apply, centeredDirichletLaplacian1D,
    one_pow, div_one]
  split_ifs <;> simp_all [Pi.single_apply, IsNearestNeighbor, Fin.ext_iff] <;>
    (try split_ifs) <;> (try simp_all) <;> omega

end ProjectKoios.QuantumMechanics.FiniteDifference

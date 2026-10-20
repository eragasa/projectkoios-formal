/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Data.Matrix.Basis
public import Mathlib.LinearAlgebra.Matrix.Hermitian
public import Mathlib.LinearAlgebra.Matrix.ToLin
public import Mathlib.Tactic.FieldSimp
public import ProjectKoios.QuantumMechanics.FiniteDifference.DirichletMatrixMode1D

/-!
# Twisted and periodic one-dimensional finite differences

This module realizes the negative centered difference on a finite cycle with scalar twist `τ`.
The coordinate size is `N + 2`, so the first and last coordinates are always distinct.  A lattice
character `zⁿ` descends to the twisted cycle when `z ^ (N + 2) = τ`.  Ordinary periodic boundary
conditions are the specialization `τ = 1`.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-TWISTED-DEF-001`: left neighbor with inverse-twist wrapping at the first coordinate. -/
noncomputable def leftTwistedValue {N : ℕ} (τ : ℂ) (v : Fin (N + 2) → ℂ)
    (i : Fin (N + 2)) : ℂ :=
  if h : 0 < i.val then v ⟨i.val - 1, by omega⟩
  else τ⁻¹ * v (Fin.last (N + 1))

/-- `QM-TWISTED-DEF-002`: right neighbor with twist wrapping at the last coordinate. -/
def rightTwistedValue {N : ℕ} (τ : ℂ) (v : Fin (N + 2) → ℂ) (i : Fin (N + 2)) : ℂ :=
  if h : i.val + 1 < N + 2 then v ⟨i.val + 1, h⟩
  else τ * v 0

/-- `QM-TWISTED-DEF-003`: unscaled negative centered difference with scalar twist `τ`. -/
noncomputable def negativeTwistedDifference {N : ℕ} (τ : ℂ) (v : Fin (N + 2) → ℂ)
    (i : Fin (N + 2)) : ℂ :=
  2 * v i - leftTwistedValue τ v i - rightTwistedValue τ v i

/-- `QM-TWISTED-DEF-004`: complex-linear twisted finite-difference operator. -/
noncomputable def negativeTwistedDifferenceLinearMap (N : ℕ) (τ : ℂ) :
    (Fin (N + 2) → ℂ) →ₗ[ℂ] (Fin (N + 2) → ℂ) where
  toFun v := negativeTwistedDifference τ v
  map_add' v w := by
    funext i
    simp only [negativeTwistedDifference, Pi.add_apply]
    unfold leftTwistedValue rightTwistedValue
    split_ifs <;> simp <;> ring
  map_smul' c v := by
    funext i
    simp only [negativeTwistedDifference, Pi.smul_apply, smul_eq_mul]
    unfold leftTwistedValue rightTwistedValue
    split_ifs <;> simp <;> ring

/-- `QM-TWISTED-DEF-005`: exact matrix of the twisted finite-difference operator. -/
noncomputable def negativeTwistedDifferenceMatrix (N : ℕ) (τ : ℂ) :
    Matrix (Fin (N + 2)) (Fin (N + 2)) ℂ :=
  LinearMap.toMatrix' (negativeTwistedDifferenceLinearMap N τ)

/-- `QM-TWISTED-THM-001`: the matrix acts exactly as the declared twisted operator. -/
theorem negativeTwistedDifferenceMatrix_mulVec
    (N : ℕ) (τ : ℂ) (v : Fin (N + 2) → ℂ) :
    Matrix.mulVec (negativeTwistedDifferenceMatrix N τ) v = negativeTwistedDifference τ v := by
  exact LinearMap.toMatrix'_mulVec (negativeTwistedDifferenceLinearMap N τ) v

/-- `QM-TWISTED-DEF-006`: the two matrix entries added by scalar-twisted closure. -/
noncomputable def twistedCornerCorrection (N : ℕ) (τ : ℂ) :
    Matrix (Fin (N + 2)) (Fin (N + 2)) ℂ :=
  Matrix.single 0 (Fin.last (N + 1)) (-τ⁻¹) +
    Matrix.single (Fin.last (N + 1)) 0 (-τ)

/--
`QM-TWISTED-THM-002`: twisted closure of the Dirichlet difference changes exactly the two corner
entries.
-/
theorem negativeTwistedDifferenceMatrix_eq_dirichlet_add_corner
    (N : ℕ) (τ : ℂ) :
    negativeTwistedDifferenceMatrix N τ =
      negativeDirichletDifferenceMatrix (N + 2) + twistedCornerCorrection N τ := by
  ext i j
  rw [show negativeTwistedDifferenceMatrix N τ i j =
      negativeTwistedDifference τ (Pi.single j 1) i by rfl]
  rw [Matrix.add_apply]
  rw [show negativeDirichletDifferenceMatrix (N + 2) i j =
      negativeDirichletDifference (Pi.single j 1) i by rfl]
  have hlast0 : Fin.last (N + 1) ≠ (0 : Fin (N + 2)) := by
    intro h
    have hval := congrArg Fin.val h
    simp at hval
  by_cases hi0 : i = 0
  · subst i
    simp [negativeTwistedDifference, negativeDirichletDifference, leftTwistedValue,
      rightTwistedValue, leftDirichletValue, rightDirichletValue, twistedCornerCorrection,
      Pi.single_apply, Matrix.single_apply, hlast0]
    split_ifs <;> ring
  · by_cases hilast : i = Fin.last (N + 1)
    · subst i
      simp [negativeTwistedDifference, negativeDirichletDifference, leftTwistedValue,
        rightTwistedValue, leftDirichletValue, rightDirichletValue, twistedCornerCorrection,
        Pi.single_apply, Matrix.single_apply]
      split_ifs <;> ring
    · have hpos : 0 < i.val := by
        have : i.val ≠ 0 := by
          intro h
          exact hi0 (Fin.ext h)
        omega
      have hright : i.val + 1 < N + 2 := by
        have hne : i.val ≠ N + 1 := by
          intro h
          exact hilast (Fin.ext h)
        omega
      simp [negativeTwistedDifference, negativeDirichletDifference, leftTwistedValue,
        rightTwistedValue, leftDirichletValue, rightDirichletValue, twistedCornerCorrection,
        Pi.single_apply, Ne.symm hi0, Ne.symm hilast, hpos, hright]

/-- `QM-DIRICHLET-MATRIX-THM-005`: the complex Dirichlet difference matrix is Hermitian. -/
theorem negativeDirichletDifferenceMatrix_isHermitian (N : ℕ) :
    (negativeDirichletDifferenceMatrix N).IsHermitian := by
  rw [negativeDirichletDifferenceMatrix_eq_neg_map_centeredDirichletLaplacian1D]
  apply Matrix.IsHermitian.neg
  apply Matrix.IsHermitian.ext
  intro i j
  simp only [Matrix.map_apply]
  rw [(centeredDirichletLaplacian1D_isSymm N 1).apply]
  simp

/-- `QM-TWISTED-THM-003`: a unitary-phase corner correction is Hermitian. -/
theorem twistedCornerCorrection_isHermitian
    (N : ℕ) (τ : ℂ) (hconj : starRingEnd ℂ τ = τ⁻¹) :
    (twistedCornerCorrection N τ).IsHermitian := by
  unfold Matrix.IsHermitian twistedCornerCorrection
  simp [hconj, add_comm]

/-- `QM-TWISTED-THM-004`: a unitary-phase twisted difference matrix is Hermitian. -/
theorem negativeTwistedDifferenceMatrix_isHermitian
    (N : ℕ) (τ : ℂ) (hconj : starRingEnd ℂ τ = τ⁻¹) :
    (negativeTwistedDifferenceMatrix N τ).IsHermitian := by
  rw [negativeTwistedDifferenceMatrix_eq_dirichlet_add_corner]
  exact (negativeDirichletDifferenceMatrix_isHermitian (N + 2)).add
    (twistedCornerCorrection_isHermitian N τ hconj)

/-- `QM-TWISTED-DEF-007`: restriction of a lattice character to the finite cycle coordinates. -/
noncomputable def finiteExponentialMode (N : ℕ) (z : ℂ) : Fin (N + 2) → ℂ :=
  fun i => exponentialMode z (Int.ofNat i.val)

/-- `QM-TWISTED-LEM-001`: twisted left wrapping agrees with the preceding lattice coordinate. -/
lemma leftTwistedValue_finiteExponentialMode
    (N : ℕ) (τ z : ℂ) (hz : z ≠ 0) (htwist : z ^ (N + 2) = τ)
    (i : Fin (N + 2)) :
    leftTwistedValue τ (finiteExponentialMode N z) i =
      exponentialMode z (Int.ofNat i.val - 1) := by
  unfold leftTwistedValue finiteExponentialMode
  split_ifs with h
  · change exponentialMode z (Int.ofNat (i.val - 1)) = _
    have hc : Int.ofNat (i.val - 1) = Int.ofNat i.val - 1 :=
      Int.ofNat_sub (by omega)
    rw [hc]
  · have hiVal : i.val = 0 := by omega
    have hi : i = ⟨0, by omega⟩ := Fin.ext hiVal
    rw [hi]
    change τ⁻¹ * exponentialMode z (Int.ofNat (N + 1)) = exponentialMode z (-1)
    simp only [exponentialMode, zpow_neg_one]
    rw [← htwist]
    field_simp
    calc
      z ^ N * z * z = (z ^ N * z) * z := by ring
      _ = z ^ (N + 1) * z := by rw [pow_succ]
      _ = z ^ ((N + 1) + 1) := (pow_succ z (N + 1)).symm
      _ = z ^ (N + 2) := by congr 1

/-- `QM-TWISTED-LEM-002`: twisted right wrapping agrees with the succeeding lattice coordinate. -/
lemma rightTwistedValue_finiteExponentialMode
    (N : ℕ) (τ z : ℂ) (htwist : z ^ (N + 2) = τ)
    (i : Fin (N + 2)) :
    rightTwistedValue τ (finiteExponentialMode N z) i =
      exponentialMode z (Int.ofNat i.val + 1) := by
  unfold rightTwistedValue finiteExponentialMode
  split_ifs with h
  · change exponentialMode z (Int.ofNat (i.val + 1)) = _
    have hc : Int.ofNat i.val + 1 = Int.ofNat (i.val + 1) := by norm_cast
    rw [hc]
  · have hiVal : i.val = N + 1 := by omega
    have hi : i = Fin.last (N + 1) := Fin.ext hiVal
    subst i
    change τ * exponentialMode z 0 = exponentialMode z (Int.ofNat (N + 1) + 1)
    have hc : Int.ofNat (N + 1) + 1 = Int.ofNat (N + 2) := by norm_cast
    rw [hc]
    simp only [exponentialMode, zpow_zero, mul_one]
    exact htwist.symm

/--
`QM-TWISTED-THM-005`: a compatible lattice character is an exact eigenvector of the twisted
finite-difference matrix.
-/
theorem negativeTwistedDifferenceMatrix_mulVec_finiteExponentialMode
    (N : ℕ) (τ z : ℂ) (hz : z ≠ 0) (htwist : z ^ (N + 2) = τ) :
    Matrix.mulVec (negativeTwistedDifferenceMatrix N τ) (finiteExponentialMode N z) =
      (2 - z⁻¹ - z) • finiteExponentialMode N z := by
  rw [negativeTwistedDifferenceMatrix_mulVec]
  funext i
  rw [Pi.smul_apply, smul_eq_mul]
  unfold negativeTwistedDifference
  rw [leftTwistedValue_finiteExponentialMode N τ z hz htwist,
    rightTwistedValue_finiteExponentialMode N τ z htwist]
  have hrec := negativeSecondDifferenceAt_exponentialMode z hz (Int.ofNat i.val)
  unfold negativeSecondDifferenceAt at hrec
  exact hrec

/-- `QM-TWISTED-DEF-008`: scalar unit-circle twist associated with a real angle. -/
noncomputable def twistBoundaryPhase (θ : ℝ) : ℂ :=
  Complex.exp ((θ : ℂ) * Complex.I)

/-- `QM-TWISTED-DEF-009`: canonical mode phase compatible with a twist angle. -/
noncomputable def canonicalTwistedModePhase (N k : ℕ) (θ : ℝ) : ℂ :=
  Complex.exp (((((2 : ℝ) * Real.pi * k + θ) / (N.succ.succ : ℕ) : ℝ) : ℂ) *
    Complex.I)

/-- `QM-TWISTED-THM-006`: the canonical twisted mode phase is nonzero. -/
theorem canonicalTwistedModePhase_ne_zero (N k : ℕ) (θ : ℝ) :
    canonicalTwistedModePhase N k θ ≠ 0 := by
  simp [canonicalTwistedModePhase]

/-- `QM-TWISTED-THM-007`: the canonical mode phase has exactly the declared scalar twist. -/
theorem canonicalTwistedModePhase_pow_eq_twistBoundaryPhase (N k : ℕ) (θ : ℝ) :
    canonicalTwistedModePhase N k θ ^ (N + 2) = twistBoundaryPhase θ := by
  rw [canonicalTwistedModePhase, ← Complex.exp_nat_mul]
  rw [show ((N + 2 : ℕ) : ℂ) *
      (((((2 : ℝ) * Real.pi * k + θ) / (N.succ.succ : ℕ) : ℝ) : ℂ) * Complex.I) =
      ((θ : ℂ) * Complex.I) + (k : ℕ) * (2 * Real.pi * Complex.I) by
        have hreal : ((N + 2 : ℕ) : ℝ) *
            (((2 : ℝ) * Real.pi * k + θ) / (N.succ.succ : ℕ)) =
            (2 : ℝ) * Real.pi * k + θ := by
          field_simp
        calc
          ((N + 2 : ℕ) : ℂ) *
              (((((2 : ℝ) * Real.pi * k + θ) / (N.succ.succ : ℕ) : ℝ) : ℂ) *
                Complex.I) =
              ((((N + 2 : ℕ) : ℝ) *
                (((2 : ℝ) * Real.pi * k + θ) / (N.succ.succ : ℕ)) : ℝ) : ℂ) *
                Complex.I := by push_cast; ring
          _ = (((2 : ℝ) * Real.pi * k + θ : ℝ) : ℂ) * Complex.I := by rw [hreal]
          _ = ((θ : ℂ) * Complex.I) + (k : ℕ) * (2 * Real.pi * Complex.I) := by
            push_cast
            ring]
  rw [Complex.exp_add, Complex.exp_nat_mul_two_pi_mul_I]
  simp [twistBoundaryPhase]

/-- `QM-TWISTED-THM-008`: a real twist angle supplies a unitary scalar boundary phase. -/
theorem conj_twistBoundaryPhase (θ : ℝ) :
    starRingEnd ℂ (twistBoundaryPhase θ) = (twistBoundaryPhase θ)⁻¹ := by
  rw [twistBoundaryPhase, ← Complex.exp_conj, map_mul, Complex.conj_I]
  simp only [Complex.conj_ofReal]
  rw [← Complex.exp_neg]
  congr 1
  ring

/-- `QM-TWISTED-THM-009`: every real-angle twisted difference matrix is Hermitian. -/
theorem negativeTwistedDifferenceMatrix_twistBoundaryPhase_isHermitian
    (N : ℕ) (θ : ℝ) :
    (negativeTwistedDifferenceMatrix N (twistBoundaryPhase θ)).IsHermitian :=
  negativeTwistedDifferenceMatrix_isHermitian N (twistBoundaryPhase θ)
    (conj_twistBoundaryPhase θ)

/-- `QM-TWISTED-THM-010`: every canonical twisted phase gives an exact finite matrix mode. -/
theorem negativeTwistedDifferenceMatrix_mulVec_canonicalMode
    (N k : ℕ) (θ : ℝ) :
    Matrix.mulVec (negativeTwistedDifferenceMatrix N (twistBoundaryPhase θ))
        (finiteExponentialMode N (canonicalTwistedModePhase N k θ)) =
      (2 - (canonicalTwistedModePhase N k θ)⁻¹ - canonicalTwistedModePhase N k θ) •
        finiteExponentialMode N (canonicalTwistedModePhase N k θ) := by
  exact negativeTwistedDifferenceMatrix_mulVec_finiteExponentialMode
    N (twistBoundaryPhase θ) (canonicalTwistedModePhase N k θ)
      (canonicalTwistedModePhase_ne_zero N k θ)
      (canonicalTwistedModePhase_pow_eq_twistBoundaryPhase N k θ)

/-- `QM-TWISTED-DEF-010`: real angle of the canonical twisted mode phase. -/
noncomputable def canonicalTwistedModeAngle (N k : ℕ) (θ : ℝ) : ℝ :=
  ((2 : ℝ) * Real.pi * k + θ) / (N.succ.succ : ℕ)

/-- `QM-TWISTED-THM-011`: the canonical twisted eigenvalue has the exact cosine form. -/
theorem canonicalTwistedModePhase_eigenvalue_eq_cosine (N k : ℕ) (θ : ℝ) :
    2 - (canonicalTwistedModePhase N k θ)⁻¹ - canonicalTwistedModePhase N k θ =
      ((2 - 2 * Real.cos (canonicalTwistedModeAngle N k θ) : ℝ) : ℂ) := by
  have hphase : canonicalTwistedModePhase N k θ =
      Complex.exp ((canonicalTwistedModeAngle N k θ : ℂ) * Complex.I) := by
    simp [canonicalTwistedModePhase, canonicalTwistedModeAngle]
  rw [hphase, ← Complex.exp_neg]
  have hcos := Complex.two_cos (canonicalTwistedModeAngle N k θ : ℂ)
  rw [← Complex.ofReal_cos] at hcos
  rw [show Complex.exp (-((canonicalTwistedModeAngle N k θ : ℂ) * Complex.I)) =
      Complex.exp (-(canonicalTwistedModeAngle N k θ : ℂ) * Complex.I) by ring_nf]
  have hcast : ((2 - 2 * Real.cos (canonicalTwistedModeAngle N k θ) : ℝ) : ℂ) =
      (2 : ℂ) - 2 * (Real.cos (canonicalTwistedModeAngle N k θ) : ℂ) := by norm_num
  rw [hcast]
  calc
    2 - Complex.exp (-(canonicalTwistedModeAngle N k θ : ℂ) * Complex.I) -
        Complex.exp ((canonicalTwistedModeAngle N k θ : ℂ) * Complex.I) =
      2 - (Complex.exp ((canonicalTwistedModeAngle N k θ : ℂ) * Complex.I) +
        Complex.exp (-(canonicalTwistedModeAngle N k θ : ℂ) * Complex.I)) := by ring_nf
    _ = 2 - 2 * (Real.cos (canonicalTwistedModeAngle N k θ) : ℂ) := by rw [← hcos]

/-- `QM-TWISTED-THM-012`: the canonical twisted mode has the exact cosine eigenvalue. -/
theorem negativeTwistedDifferenceMatrix_mulVec_canonicalMode_cosine
    (N k : ℕ) (θ : ℝ) :
    Matrix.mulVec (negativeTwistedDifferenceMatrix N (twistBoundaryPhase θ))
        (finiteExponentialMode N (canonicalTwistedModePhase N k θ)) =
      ((2 - 2 * Real.cos (canonicalTwistedModeAngle N k θ) : ℝ) : ℂ) •
        finiteExponentialMode N (canonicalTwistedModePhase N k θ) := by
  rw [← canonicalTwistedModePhase_eigenvalue_eq_cosine]
  exact negativeTwistedDifferenceMatrix_mulVec_canonicalMode N k θ

/-- `QM-PERIODIC-DEF-001`: ordinary periodic negative centered difference. -/
noncomputable def negativePeriodicDifference {N : ℕ} (v : Fin (N + 2) → ℂ) :
    Fin (N + 2) → ℂ :=
  negativeTwistedDifference 1 v

/-- `QM-PERIODIC-DEF-002`: exact matrix of the periodic finite-difference operator. -/
noncomputable def negativePeriodicDifferenceMatrix (N : ℕ) :
    Matrix (Fin (N + 2)) (Fin (N + 2)) ℂ :=
  negativeTwistedDifferenceMatrix N 1

/-- `QM-PERIODIC-THM-001`: periodic boundary conditions are twist-one boundary conditions. -/
theorem negativePeriodicDifference_eq_negativeTwistedDifference_one
    (N : ℕ) (v : Fin (N + 2) → ℂ) :
    negativePeriodicDifference v = negativeTwistedDifference 1 v := rfl

/-- `QM-PERIODIC-THM-002`: the periodic matrix acts exactly as the periodic operator. -/
theorem negativePeriodicDifferenceMatrix_mulVec
    (N : ℕ) (v : Fin (N + 2) → ℂ) :
    Matrix.mulVec (negativePeriodicDifferenceMatrix N) v = negativePeriodicDifference v := by
  exact negativeTwistedDifferenceMatrix_mulVec N 1 v

/-- `QM-PERIODIC-DEF-003`: the ordinary periodic two-corner correction. -/
noncomputable def periodicCornerCorrection (N : ℕ) :
    Matrix (Fin (N + 2)) (Fin (N + 2)) ℂ :=
  twistedCornerCorrection N 1

/-- `QM-PERIODIC-THM-003`: periodic closure changes exactly the two Dirichlet corner entries. -/
theorem negativePeriodicDifferenceMatrix_eq_dirichlet_add_corner (N : ℕ) :
    negativePeriodicDifferenceMatrix N =
      negativeDirichletDifferenceMatrix (N + 2) + periodicCornerCorrection N := by
  exact negativeTwistedDifferenceMatrix_eq_dirichlet_add_corner N 1

/-- `QM-PERIODIC-THM-004`: the periodic difference matrix is Hermitian. -/
theorem negativePeriodicDifferenceMatrix_isHermitian (N : ℕ) :
    (negativePeriodicDifferenceMatrix N).IsHermitian := by
  apply negativeTwistedDifferenceMatrix_isHermitian
  simp

/-- `QM-PERIODIC-THM-005`: a root-of-unity character is an exact periodic matrix eigenvector. -/
theorem negativePeriodicDifferenceMatrix_mulVec_finiteExponentialMode
    (N : ℕ) (z : ℂ) (hz : z ≠ 0) (hperiod : z ^ (N + 2) = 1) :
    Matrix.mulVec (negativePeriodicDifferenceMatrix N) (finiteExponentialMode N z) =
      (2 - z⁻¹ - z) • finiteExponentialMode N z := by
  exact negativeTwistedDifferenceMatrix_mulVec_finiteExponentialMode N 1 z hz hperiod

/-- `QM-PERIODIC-DEF-004`: canonical periodic mode phase. -/
noncomputable def canonicalPeriodicModePhase (N k : ℕ) : ℂ :=
  canonicalTwistedModePhase N k 0

/-- `QM-PERIODIC-THM-006`: a canonical periodic phase is a root of unity of the cycle length. -/
theorem canonicalPeriodicModePhase_pow_eq_one (N k : ℕ) :
    canonicalPeriodicModePhase N k ^ (N + 2) = 1 := by
  simpa [canonicalPeriodicModePhase, twistBoundaryPhase] using
    canonicalTwistedModePhase_pow_eq_twistBoundaryPhase N k 0

/-- `QM-PERIODIC-THM-007`: every canonical periodic phase gives an exact finite matrix mode. -/
theorem negativePeriodicDifferenceMatrix_mulVec_canonicalMode
    (N k : ℕ) :
    Matrix.mulVec (negativePeriodicDifferenceMatrix N)
        (finiteExponentialMode N (canonicalPeriodicModePhase N k)) =
      (2 - (canonicalPeriodicModePhase N k)⁻¹ - canonicalPeriodicModePhase N k) •
        finiteExponentialMode N (canonicalPeriodicModePhase N k) := by
  exact negativePeriodicDifferenceMatrix_mulVec_finiteExponentialMode
    N (canonicalPeriodicModePhase N k)
      (canonicalTwistedModePhase_ne_zero N k 0)
      (canonicalPeriodicModePhase_pow_eq_one N k)

/-- `QM-PERIODIC-DEF-005`: real angle of the canonical periodic mode phase. -/
noncomputable def canonicalPeriodicModeAngle (N k : ℕ) : ℝ :=
  canonicalTwistedModeAngle N k 0

/-- `QM-PERIODIC-THM-008`: the canonical periodic eigenvalue has the exact cosine form. -/
theorem canonicalPeriodicModePhase_eigenvalue_eq_cosine (N k : ℕ) :
    2 - (canonicalPeriodicModePhase N k)⁻¹ - canonicalPeriodicModePhase N k =
      ((2 - 2 * Real.cos (canonicalPeriodicModeAngle N k) : ℝ) : ℂ) := by
  exact canonicalTwistedModePhase_eigenvalue_eq_cosine N k 0

/-- `QM-PERIODIC-THM-009`: the canonical periodic mode has the exact cosine eigenvalue. -/
theorem negativePeriodicDifferenceMatrix_mulVec_canonicalMode_cosine
    (N k : ℕ) :
    Matrix.mulVec (negativePeriodicDifferenceMatrix N)
        (finiteExponentialMode N (canonicalPeriodicModePhase N k)) =
      ((2 - 2 * Real.cos (canonicalPeriodicModeAngle N k) : ℝ) : ℂ) •
        finiteExponentialMode N (canonicalPeriodicModePhase N k) := by
  rw [← canonicalPeriodicModePhase_eigenvalue_eq_cosine]
  exact negativePeriodicDifferenceMatrix_mulVec_canonicalMode N k

/-- `QM-PERIODIC-DEF-006`: antisymmetric combination of two reciprocal PBC characters. -/
noncomputable def finitePeriodicAntisymmetricMode (N : ℕ) (z : ℂ) : Fin (N + 2) → ℂ :=
  finiteExponentialMode N z - finiteExponentialMode N z⁻¹

/--
`QM-PERIODIC-THM-010`: a reciprocal pair of root-of-unity characters gives an exact
antisymmetric PBC matrix eigenmode.
-/
theorem negativePeriodicDifferenceMatrix_mulVec_finitePeriodicAntisymmetricMode
    (N : ℕ) (z : ℂ) (hz : z ≠ 0) (hperiod : z ^ (N + 2) = 1) :
    Matrix.mulVec (negativePeriodicDifferenceMatrix N)
        (finitePeriodicAntisymmetricMode N z) =
      (2 - z⁻¹ - z) • finitePeriodicAntisymmetricMode N z := by
  have hzinv : z⁻¹ ≠ 0 := inv_ne_zero hz
  have hinvperiod : z⁻¹ ^ (N + 2) = 1 := by
    rw [inv_pow, hperiod, inv_one]
  have hforward := negativePeriodicDifferenceMatrix_mulVec_finiteExponentialMode
    N z hz hperiod
  have hbackward := negativePeriodicDifferenceMatrix_mulVec_finiteExponentialMode
    N z⁻¹ hzinv hinvperiod
  rw [finitePeriodicAntisymmetricMode, Matrix.mulVec_sub, hforward, hbackward]
  funext i
  simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul, inv_inv]
  ring

end ProjectKoios.QuantumMechanics.FiniteDifference

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
public import ProjectKoios.QuantumMechanics.FiniteDifference.OddExtension1D
public import ProjectKoios.QuantumMechanics.Piab1d.FiniteDifference

/-!
# PIAB1D exponential modes

Dirichlet modes are the antisymmetric combination of two counter-propagating translation
characters.  This formulation preserves the complex-exponential representation needed for later
Bloch work.  It proves the exact local finite-difference equation and endpoint conditions; the
finite-matrix `mulVec` bridge. Runtime and binary64 bindings remain separate obligations.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.Piab1d

open ProjectKoios.QuantumMechanics.FiniteDifference

/--
`PIAB1D-SPECTRUM-DEF-001`: endpoint quantization condition for an antisymmetric exponential mode.
-/
def SatisfiesDirichletPhaseCondition (z : ℂ) (endpoint : ℤ) : Prop :=
  z ^ endpoint = z ^ (-endpoint)

/-- `PIAB1D-SPECTRUM-DEF-002`: complex Dirichlet mode from counter-propagating exponentials. -/
noncomputable def dirichletExponentialMode (z : ℂ) (n : ℤ) : ℂ :=
  antisymmetricExponentialMode z n

/-- `PIAB1D-SPECTRUM-THM-001`: every declared Dirichlet exponential mode vanishes at the origin. -/
theorem dirichletExponentialMode_zero (z : ℂ) :
    dirichletExponentialMode z 0 = 0 := by
  exact antisymmetricExponentialMode_zero z

/--
`PIAB1D-SPECTRUM-THM-002`: the phase-quantization condition gives the right Dirichlet endpoint.
-/
theorem dirichletExponentialMode_endpoint_eq_zero
    (z : ℂ) (endpoint : ℤ) (hphase : SatisfiesDirichletPhaseCondition z endpoint) :
    dirichletExponentialMode z endpoint = 0 := by
  exact antisymmetricExponentialMode_eq_zero_of_forward_eq_backward z endpoint hphase

/--
`PIAB1D-SPECTRUM-THM-003`: the antisymmetric Dirichlet mode satisfies the exact local centered
finite-difference eigen-equation.
-/
theorem negativeSecondDifferenceAt_dirichletExponentialMode
    (z : ℂ) (hz : z ≠ 0) (n : ℤ) :
    negativeSecondDifferenceAt (dirichletExponentialMode z) n =
      (2 - z⁻¹ - z) * dirichletExponentialMode z n := by
  exact negativeSecondDifferenceAt_antisymmetricExponentialMode z hz n

/--
`PIAB1D-SPECTRUM-THM-004`: the two PIAB1D boundary values and local eigen-equation are available
from one nonzero phase satisfying the declared endpoint condition.
-/
theorem dirichletExponentialMode_specification
    (z : ℂ) (hz : z ≠ 0) (endpoint : ℤ)
    (hphase : SatisfiesDirichletPhaseCondition z endpoint) :
    dirichletExponentialMode z 0 = 0 ∧
      dirichletExponentialMode z endpoint = 0 ∧
      ∀ n, negativeSecondDifferenceAt (dirichletExponentialMode z) n =
        (2 - z⁻¹ - z) * dirichletExponentialMode z n := by
  exact ⟨dirichletExponentialMode_zero z,
    dirichletExponentialMode_endpoint_eq_zero z endpoint hphase,
    negativeSecondDifferenceAt_dirichletExponentialMode z hz⟩

/-- `PIAB1D-SPECTRUM-DEF-003`: the exact finite interior-coordinate PIAB1D mode vector. -/
noncomputable def dirichletExponentialModeVector (N : ℕ) (z : ℂ) : Fin N → ℂ :=
  finiteAntisymmetricExponentialMode N z

/--
`PIAB1D-SPECTRUM-THM-005`: a phase satisfying the right endpoint condition gives an exact
finite-matrix eigenpair for the unscaled negative Dirichlet difference matrix.
-/
theorem negativeDirichletDifferenceMatrix_mulVec_dirichletExponentialModeVector
    (N : ℕ) (z : ℂ) (hz : z ≠ 0)
    (hphase : SatisfiesDirichletPhaseCondition z (Int.ofNat (N + 1))) :
    Matrix.mulVec (negativeDirichletDifferenceMatrix N) (dirichletExponentialModeVector N z) =
      (2 - z⁻¹ - z) • dirichletExponentialModeVector N z := by
  apply negativeDirichletDifferenceMatrix_mulVec_finiteAntisymmetricExponentialMode N z hz
  exact antisymmetricExponentialMode_eq_zero_of_forward_eq_backward
    z (Int.ofNat (N + 1)) hphase

/-- `PIAB1D-SPECTRUM-DEF-004`: sine-normalized finite PIAB1D mode vector. -/
noncomputable def normalizedDirichletExponentialModeVector (N : ℕ) (z : ℂ) : Fin N → ℂ :=
  finiteNormalizedAntisymmetricExponentialMode N z

/-- `PIAB1D-SPECTRUM-DEF-005`: real coordinates of the sine-normalized finite mode. -/
noncomputable def realDirichletExponentialModeVector (N : ℕ) (z : ℂ) : Fin N → ℝ :=
  fun i => realAntisymmetricExponentialMode z (Int.ofNat (i.val + 1))

/--
`PIAB1D-SPECTRUM-THM-006`: conjugation-invariant phase data make the normalized finite mode the
complex embedding of an explicitly real vector.
-/
theorem ofReal_realDirichletExponentialModeVector
    (N : ℕ) (z : ℂ) (hconj : starRingEnd ℂ z = z⁻¹) :
    (fun i => (realDirichletExponentialModeVector N z i : ℂ)) =
      normalizedDirichletExponentialModeVector N z := by
  funext i
  exact ofReal_realAntisymmetricExponentialMode z (Int.ofNat (i.val + 1)) hconj

/--
`PIAB1D-SPECTRUM-THM-007`: the real-representable, sine-normalized PIAB1D mode satisfies the exact
finite complex-matrix eigen-equation.
-/
theorem negativeDirichletDifferenceMatrix_mulVec_normalizedDirichletExponentialModeVector
    (N : ℕ) (z : ℂ) (hz : z ≠ 0)
    (hphase : SatisfiesDirichletPhaseCondition z (Int.ofNat (N + 1))) :
    Matrix.mulVec (negativeDirichletDifferenceMatrix N)
        (normalizedDirichletExponentialModeVector N z) =
      (2 - z⁻¹ - z) • normalizedDirichletExponentialModeVector N z := by
  apply negativeDirichletDifferenceMatrix_mulVec_finiteNormalizedAntisymmetricExponentialMode
    N z hz
  exact antisymmetricExponentialMode_eq_zero_of_forward_eq_backward
    z (Int.ofNat (N + 1)) hphase

/--
`PIAB1D-SPECTRUM-DEF-006`: canonical phase for mode index `k` on `N` interior coordinates.
-/
noncomputable def dirichletPhase (N k : ℕ) : ℂ :=
  Complex.exp (((k : ℝ) * Real.pi / (N + 1) : ℂ) * Complex.I)

/-- `PIAB1D-SPECTRUM-THM-008`: the canonical Dirichlet phase is nonzero. -/
theorem dirichletPhase_ne_zero (N k : ℕ) : dirichletPhase N k ≠ 0 := by
  simp [dirichletPhase]

/-- `PIAB1D-SPECTRUM-THM-009`: the canonical phase is a `2(N+1)`-st root of unity. -/
theorem dirichletPhase_pow_two_mul_succ_eq_one (N k : ℕ) :
    dirichletPhase N k ^ (2 * (N + 1)) = 1 := by
  rw [dirichletPhase, ← Complex.exp_nat_mul]
  rw [show ((2 * (N + 1) : ℕ) : ℂ) *
      (((k : ℝ) * Real.pi / (N + 1) : ℂ) * Complex.I) =
      (k : ℕ) * (2 * Real.pi * Complex.I) by
        push_cast
        field_simp]
  exact Complex.exp_nat_mul_two_pi_mul_I k

/-- `PIAB1D-SPECTRUM-THM-010`: the canonical phase satisfies the right endpoint condition. -/
theorem dirichletPhase_satisfiesDirichletPhaseCondition (N k : ℕ) :
    SatisfiesDirichletPhaseCondition (dirichletPhase N k) (Int.ofNat (N + 1)) := by
  change dirichletPhase N k ^ ((N + 1 : ℕ) : ℤ) =
    dirichletPhase N k ^ (-((N + 1 : ℕ) : ℤ))
  rw [zpow_natCast, zpow_neg, zpow_natCast]
  apply eq_inv_of_mul_eq_one_left
  rw [← pow_two, ← pow_mul]
  simpa [Nat.mul_comm] using dirichletPhase_pow_two_mul_succ_eq_one N k

/-- `PIAB1D-SPECTRUM-THM-011`: conjugation inverts the canonical unit-circle phase. -/
theorem conj_dirichletPhase (N k : ℕ) :
    starRingEnd ℂ (dirichletPhase N k) = (dirichletPhase N k)⁻¹ := by
  rw [dirichletPhase, ← Complex.exp_conj, map_mul, Complex.conj_I]
  simp only [map_mul, map_div₀, map_add, map_one, map_natCast, Complex.conj_ofReal]
  rw [← Complex.exp_neg]
  congr 1
  ring_nf

/--
`PIAB1D-SPECTRUM-THM-012`: every canonical phase supplies an exact finite normalized matrix
mode equation. This statement does not assert that every natural `k` gives a nonzero or distinct
mode.
-/
theorem negativeDirichletDifferenceMatrix_mulVec_canonicalMode
    (N k : ℕ) :
    Matrix.mulVec (negativeDirichletDifferenceMatrix N)
        (normalizedDirichletExponentialModeVector N (dirichletPhase N k)) =
      (2 - (dirichletPhase N k)⁻¹ - dirichletPhase N k) •
        normalizedDirichletExponentialModeVector N (dirichletPhase N k) := by
  exact negativeDirichletDifferenceMatrix_mulVec_normalizedDirichletExponentialModeVector
    N (dirichletPhase N k) (dirichletPhase_ne_zero N k)
      (dirichletPhase_satisfiesDirichletPhaseCondition N k)

/--
`PIAB1D-SPECTRUM-THM-013`: the canonical normalized finite mode is the complex embedding of its
real-coordinate vector.
-/
theorem ofReal_realDirichletExponentialModeVector_dirichletPhase (N k : ℕ) :
    (fun i => (realDirichletExponentialModeVector N (dirichletPhase N k) i : ℂ)) =
      normalizedDirichletExponentialModeVector N (dirichletPhase N k) := by
  exact ofReal_realDirichletExponentialModeVector N (dirichletPhase N k)
    (conj_dirichletPhase N k)

/-- `PIAB1D-SPECTRUM-DEF-007`: canonical real phase angle for mode index `k`. -/
noncomputable def dirichletPhaseAngle (N k : ℕ) : ℝ :=
  (k : ℝ) * Real.pi / (N + 1)

/-- `PIAB1D-SPECTRUM-THM-014`: the exponential eigenvalue has the standard real cosine form. -/
theorem dirichletPhase_eigenvalue_eq_cosine (N k : ℕ) :
    2 - (dirichletPhase N k)⁻¹ - dirichletPhase N k =
      ((2 - 2 * Real.cos (dirichletPhaseAngle N k) : ℝ) : ℂ) := by
  have hphase : dirichletPhase N k =
      Complex.exp ((dirichletPhaseAngle N k : ℂ) * Complex.I) := by
    simp [dirichletPhase, dirichletPhaseAngle]
  rw [hphase, ← Complex.exp_neg]
  have hcos := Complex.two_cos (dirichletPhaseAngle N k : ℂ)
  rw [← Complex.ofReal_cos] at hcos
  rw [show Complex.exp (-((dirichletPhaseAngle N k : ℂ) * Complex.I)) =
      Complex.exp (-(dirichletPhaseAngle N k : ℂ) * Complex.I) by ring_nf]
  have hcast : ((2 - 2 * Real.cos (dirichletPhaseAngle N k) : ℝ) : ℂ) =
      (2 : ℂ) - 2 * (Real.cos (dirichletPhaseAngle N k) : ℂ) := by norm_num
  rw [hcast]
  calc
    2 - Complex.exp (-(dirichletPhaseAngle N k : ℂ) * Complex.I) -
        Complex.exp ((dirichletPhaseAngle N k : ℂ) * Complex.I) =
      2 - (Complex.exp ((dirichletPhaseAngle N k : ℂ) * Complex.I) +
        Complex.exp (-(dirichletPhaseAngle N k : ℂ) * Complex.I)) := by ring_nf
    _ = 2 - 2 * (Real.cos (dirichletPhaseAngle N k) : ℂ) := by rw [← hcos]

/--
`PIAB1D-SPECTRUM-THM-015`: the canonical normalized PIAB1D mode has the explicit discrete
Dirichlet cosine eigenvalue.
-/
theorem negativeDirichletDifferenceMatrix_mulVec_canonicalMode_cosine
    (N k : ℕ) :
    Matrix.mulVec (negativeDirichletDifferenceMatrix N)
        (normalizedDirichletExponentialModeVector N (dirichletPhase N k)) =
      ((2 - 2 * Real.cos (dirichletPhaseAngle N k) : ℝ) : ℂ) •
        normalizedDirichletExponentialModeVector N (dirichletPhase N k) := by
  rw [← dirichletPhase_eigenvalue_eq_cosine]
  exact negativeDirichletDifferenceMatrix_mulVec_canonicalMode N k

/--
`PIAB1D-SPECTRUM-THM-016`: the canonical mode is an exact eigenvector of the complexification of
the declared scaled PIAB1D Dirichlet Hamiltonian.
-/
theorem map_dirichletHamiltonian_mulVec_canonicalMode_cosine
    (N k : ℕ) (h kineticScale : ℝ) (hh : h ≠ 0) :
    Matrix.mulVec ((dirichletHamiltonian N h kineticScale).map Complex.ofReal)
        (normalizedDirichletExponentialModeVector N (dirichletPhase N k)) =
      ((-kineticScale / h ^ 2 *
        (2 - 2 * Real.cos (dirichletPhaseAngle N k)) : ℝ) : ℂ) •
        normalizedDirichletExponentialModeVector N (dirichletPhase N k) := by
  rw [map_dirichletHamiltonian_eq_smul_negativeDirichletDifferenceMatrix N h kineticScale hh,
    Matrix.smul_mulVec, negativeDirichletDifferenceMatrix_mulVec_canonicalMode_cosine]
  simp only [smul_smul]
  congr 1
  norm_cast
  ring

/--
`PIAB1D-SPECTRUM-THM-017`: the canonical Dirichlet phase is a root of unity for the doubled
periodic cycle of length `2(N+1)`.
-/
theorem dirichletPhase_pow_doubledCycleLength_eq_one (N k : ℕ) :
    dirichletPhase N k ^ (2 * N + 2) = 1 := by
  rw [show 2 * N + 2 = 2 * (N + 1) by omega]
  exact dirichletPhase_pow_two_mul_succ_eq_one N k

/--
`PIAB1D-SPECTRUM-THM-018`: the finite Dirichlet exponential mode is exactly the first-interior-half
restriction of the antisymmetric reciprocal-character mode on the doubled periodic cycle.
-/
theorem dirichletExponentialModeVector_eq_restrict_finitePeriodicAntisymmetricMode
    (N : ℕ) (z : ℂ) :
    dirichletExponentialModeVector N z =
      restrictDoubledCycleInterior (finitePeriodicAntisymmetricMode (2 * N) z) := by
  funext i
  simp [dirichletExponentialModeVector, finiteAntisymmetricExponentialMode,
    antisymmetricExponentialMode, restrictDoubledCycleInterior, finitePeriodicAntisymmetricMode,
    finiteExponentialMode, doubledCycleInteriorCoordinate, exponentialMode]

/--
`PIAB1D-SPECTRUM-THM-019`: the doubled-cycle antisymmetric mode built from the canonical
Dirichlet phase is an exact PBC matrix eigenmode before interior restriction.
-/
theorem negativePeriodicDifferenceMatrix_mulVec_doubledDirichletMode
    (N k : ℕ) :
    Matrix.mulVec (negativePeriodicDifferenceMatrix (2 * N))
        (finitePeriodicAntisymmetricMode (2 * N) (dirichletPhase N k)) =
      (2 - (dirichletPhase N k)⁻¹ - dirichletPhase N k) •
        finitePeriodicAntisymmetricMode (2 * N) (dirichletPhase N k) := by
  apply negativePeriodicDifferenceMatrix_mulVec_finitePeriodicAntisymmetricMode
  · exact dirichletPhase_ne_zero N k
  · exact dirichletPhase_pow_doubledCycleLength_eq_one N k

end ProjectKoios.QuantumMechanics.Piab1d

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Basic.Complex.Basic
public import Mathlib.Tactic.Ring

/-!
# Complex exponential lattice modes

A nonzero complex phase `z` defines the translation eigenmode `n ↦ zⁿ` on the integer lattice.
This is the reusable algebraic foundation for cyclic finite differences, antisymmetric Dirichlet
modes, and later one-dimensional Bloch translation characters.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDifference

/-- `QM-EXPONENTIAL-DEF-001`: integer-lattice geometric mode `zⁿ`. -/
noncomputable def exponentialMode (z : ℂ) (n : ℤ) : ℂ := z ^ n

/-- `QM-EXPONENTIAL-DEF-002`: centered negative second difference on the integer lattice. -/
def negativeSecondDifferenceAt (ψ : ℤ → ℂ) (n : ℤ) : ℂ :=
  2 * ψ n - ψ (n - 1) - ψ (n + 1)

/-- `QM-EXPONENTIAL-THM-001`: geometric modes transform by a character under translation. -/
theorem exponentialMode_add
    (z : ℂ) (hz : z ≠ 0) (n a : ℤ) :
    exponentialMode z (n + a) = exponentialMode z n * exponentialMode z a := by
  exact zpow_add₀ hz n a

/-- `QM-EXPONENTIAL-THM-002`: exact finite-difference eigen-equation for a geometric mode. -/
theorem negativeSecondDifferenceAt_exponentialMode
    (z : ℂ) (hz : z ≠ 0) (n : ℤ) :
    negativeSecondDifferenceAt (exponentialMode z) n =
      (2 - z⁻¹ - z) * exponentialMode z n := by
  unfold negativeSecondDifferenceAt exponentialMode
  rw [zpow_sub_one₀ hz, zpow_add_one₀ hz]
  ring

/-- `QM-EXPONENTIAL-THM-003`: a root-of-unity condition makes the mode periodic. -/
theorem exponentialMode_add_period
    (z : ℂ) (hz : z ≠ 0) (period n : ℤ) (hperiod : z ^ period = 1) :
    exponentialMode z (n + period) = exponentialMode z n := by
  rw [exponentialMode_add z hz n period]
  unfold exponentialMode
  rw [hperiod, mul_one]

/-- `QM-EXPONENTIAL-DEF-003`: antisymmetric combination used for Dirichlet modes. -/
noncomputable def antisymmetricExponentialMode (z : ℂ) (n : ℤ) : ℂ :=
  exponentialMode z n - exponentialMode z (-n)

/-- `QM-EXPONENTIAL-LEM-001`: centered difference is linear under subtraction. -/
lemma negativeSecondDifferenceAt_sub (ψ φ : ℤ → ℂ) (n : ℤ) :
    negativeSecondDifferenceAt (fun m => ψ m - φ m) n =
      negativeSecondDifferenceAt ψ n - negativeSecondDifferenceAt φ n := by
  simp [negativeSecondDifferenceAt]
  ring

/--
`QM-EXPONENTIAL-THM-004`: the antisymmetric combination has the same centered-difference
eigenvalue as its two counter-propagating exponential components.
-/
theorem negativeSecondDifferenceAt_antisymmetricExponentialMode
    (z : ℂ) (hz : z ≠ 0) (n : ℤ) :
    negativeSecondDifferenceAt (antisymmetricExponentialMode z) n =
      (2 - z⁻¹ - z) * antisymmetricExponentialMode z n := by
  have hzinv : z⁻¹ ≠ 0 := inv_ne_zero hz
  have hinv (m : ℤ) : exponentialMode z (-m) = exponentialMode z⁻¹ m := by
    simp [exponentialMode, zpow_neg]
  rw [show antisymmetricExponentialMode z =
      fun m => exponentialMode z m - exponentialMode z⁻¹ m by
        funext m
        simp [antisymmetricExponentialMode, hinv]]
  rw [negativeSecondDifferenceAt_sub,
    negativeSecondDifferenceAt_exponentialMode z hz n,
    negativeSecondDifferenceAt_exponentialMode z⁻¹ hzinv n]
  simp only [inv_inv]
  ring

/-- `QM-EXPONENTIAL-THM-005`: every antisymmetric exponential mode vanishes at the origin. -/
theorem antisymmetricExponentialMode_zero (z : ℂ) :
    antisymmetricExponentialMode z 0 = 0 := by
  simp [antisymmetricExponentialMode, exponentialMode]

/--
`QM-EXPONENTIAL-THM-006`: equality of the forward and backward phase at a declared endpoint gives
the exact Dirichlet boundary value there.
-/
theorem antisymmetricExponentialMode_eq_zero_of_forward_eq_backward
    (z : ℂ) (endpoint : ℤ) (hendpoint : z ^ endpoint = z ^ (-endpoint)) :
    antisymmetricExponentialMode z endpoint = 0 := by
  unfold antisymmetricExponentialMode exponentialMode
  rw [hendpoint]
  simp

/-- `QM-EXPONENTIAL-DEF-004`: sine normalization of the antisymmetric exponential mode. -/
noncomputable def normalizedAntisymmetricExponentialMode (z : ℂ) (n : ℤ) : ℂ :=
  antisymmetricExponentialMode z n / (2 * Complex.I)

/-- `QM-EXPONENTIAL-DEF-005`: real coordinate carried by the normalized mode. -/
noncomputable def realAntisymmetricExponentialMode (z : ℂ) (n : ℤ) : ℝ :=
  (normalizedAntisymmetricExponentialMode z n).re

/-- `QM-EXPONENTIAL-THM-007`: normalization preserves the centered-difference eigen-equation. -/
theorem negativeSecondDifferenceAt_normalizedAntisymmetricExponentialMode
    (z : ℂ) (hz : z ≠ 0) (n : ℤ) :
    negativeSecondDifferenceAt (normalizedAntisymmetricExponentialMode z) n =
      (2 - z⁻¹ - z) * normalizedAntisymmetricExponentialMode z n := by
  have h := negativeSecondDifferenceAt_antisymmetricExponentialMode z hz n
  unfold normalizedAntisymmetricExponentialMode
  calc
    negativeSecondDifferenceAt
        (fun m => antisymmetricExponentialMode z m / (2 * Complex.I)) n =
        negativeSecondDifferenceAt (antisymmetricExponentialMode z) n /
          (2 * Complex.I) := by
            unfold negativeSecondDifferenceAt
            ring
    _ = ((2 - z⁻¹ - z) * antisymmetricExponentialMode z n) /
          (2 * Complex.I) := by rw [h]
    _ = (2 - z⁻¹ - z) * (antisymmetricExponentialMode z n / (2 * Complex.I)) := by ring

/--
`QM-EXPONENTIAL-THM-008`: when conjugation inverts the phase, the sine-normalized mode is the
complex embedding of its real coordinate.
-/
theorem ofReal_realAntisymmetricExponentialMode
    (z : ℂ) (n : ℤ) (hconj : starRingEnd ℂ z = z⁻¹) :
    (realAntisymmetricExponentialMode z n : ℂ) =
      normalizedAntisymmetricExponentialMode z n := by
  apply Complex.conj_eq_iff_re.mp
  have ha : starRingEnd ℂ (antisymmetricExponentialMode z n) =
      -antisymmetricExponentialMode z n := by
    simp [antisymmetricExponentialMode, exponentialMode, hconj, zpow_neg]
  unfold normalizedAntisymmetricExponentialMode
  rw [map_div₀, ha]
  simp only [map_mul, map_ofNat, Complex.conj_I]
  ring

end ProjectKoios.QuantumMechanics.FiniteDifference

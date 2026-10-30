/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Source proof author: naok1
Formal proof completed: 2026-10-31

The proof architecture in this file is adapted from the Apache-2.0-licensed theorem
`QuantumTheory.Transport.polarFourierZerothAngularKernel_eq_besselJ` in
`naoki-cpp/LeanCondensedMatter` merge commit
`47d64b9d2e85522dbbef295bf0ce3d2a1d0afe87`, file
`LeanCondensedMatter/Transport/Analysis/PolarFourier.lean`.
-/
module

public import Mathlib.Analysis.Calculus.ParametricIntervalIntegral
public import Mathlib.Analysis.SpecialFunctions.Bessel
public import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
public import Mathlib.Analysis.SpecificLimits.Normed
public import Mathlib.MeasureTheory.Integral.DominatedConvergence
public import Mathlib.MeasureTheory.Integral.IntervalIntegral.Periodic
public import Mathlib.Tactic

/-!
# Zeroth Bessel function as a full-angle exponential integral

This module proves the exact source-neutral identity

`∫ θ in 0..2π, exp (i z cos θ) = 2π * J₀(z)`

for every real `z`, with Mathlib's `Complex.besselJ`. The proof expands the exponential under the
integral, evaluates the even cosine moments, eliminates the odd moments, and identifies the
resulting series with Mathlib's regularized-hypergeometric definition of `Complex.besselJ`.

The theorem concerns exact interval integration only. It does not authenticate a runtime phase,
quadrature rule, finite mesh, floating-point value, external coordinate convention, physical model,
or finite-to-continuum approximation.
-/

open MeasureTheory
open scoped Interval

@[expose] public section

namespace ProjectKoios.BandGauge.SpecialFunctions

/-- `BG-SPECIAL-DEF-001`: the full-angle exponential cosine kernel. -/
noncomputable def fullAngleCosineExponentialKernel (z : ℝ) : ℂ :=
  ∫ θ : ℝ in (0 : ℝ)..(2 * Real.pi),
    Complex.exp (Complex.I * (((z * Real.cos θ : ℝ) : ℂ)))

/-- `BG-SPECIAL-DEF-002`: the real cosine moment over a full revolution. -/
noncomputable def fullAngleCosineMoment (n : ℕ) : ℝ :=
  ∫ θ in (0 : ℝ)..(2 * Real.pi), Real.cos θ ^ n

/-- `BG-SPECIAL-THM-001`: the zeroth full-angle cosine moment is `2π`. -/
@[simp] theorem fullAngleCosineMoment_zero :
    fullAngleCosineMoment 0 = 2 * Real.pi := by
  simp [fullAngleCosineMoment]

/-- `BG-SPECIAL-THM-002`: the first full-angle cosine moment vanishes. -/
@[simp] theorem fullAngleCosineMoment_one :
    fullAngleCosineMoment 1 = 0 := by
  simp [fullAngleCosineMoment]

/-- `BG-SPECIAL-THM-003`: full-angle cosine moments satisfy the standard two-step reduction. -/
theorem fullAngleCosineMoment_add_two (n : ℕ) :
    fullAngleCosineMoment (n + 2) =
      ((n : ℝ) + 1) / ((n : ℝ) + 2) * fullAngleCosineMoment n := by
  simpa [fullAngleCosineMoment] using
    (integral_cos_pow (a := (0 : ℝ)) (b := 2 * Real.pi) n)

/-- `BG-SPECIAL-THM-004`: closed finite-product formula for every even cosine moment. -/
theorem fullAngleCosineMoment_even (n : ℕ) :
    fullAngleCosineMoment (2 * n) =
      (2 * Real.pi) *
        ∏ k ∈ Finset.range n, ((2 * (k : ℝ) + 1) / (2 * (k : ℝ) + 2)) := by
  induction n with
  | zero => simp
  | succ n ih =>
      have hindex : 2 * (n + 1) = 2 * n + 2 := by omega
      rw [hindex, fullAngleCosineMoment_add_two, ih, Finset.prod_range_succ]
      push_cast
      ring

/-- `BG-SPECIAL-THM-005`: factorial formula for every even cosine moment. -/
theorem fullAngleCosineMoment_even_factorial (n : ℕ) :
    fullAngleCosineMoment (2 * n) =
      (2 * Real.pi) * (Nat.factorial (2 * n) : ℝ) /
        ((4 : ℝ) ^ n * (Nat.factorial n : ℝ) ^ 2) := by
  rw [fullAngleCosineMoment_even]
  have hprod (n : ℕ) :
      (∏ k ∈ Finset.range n, ((2 * (k : ℝ) + 1) / (2 * (k : ℝ) + 2))) =
        (Nat.factorial (2 * n) : ℝ) /
          ((4 : ℝ) ^ n * (Nat.factorial n : ℝ) ^ 2) := by
    induction n with
    | zero => norm_num
    | succ n ih =>
        have hfac2 :
            (Nat.factorial (2 * (n + 1)) : ℝ) =
              (2 * (n : ℝ) + 2) * (2 * (n : ℝ) + 1) *
                (Nat.factorial (2 * n) : ℝ) := by
          have hindex : 2 * (n + 1) = (2 * n + 1) + 1 := by omega
          rw [hindex, Nat.factorial_succ, Nat.factorial_succ]
          push_cast
          ring
        have hfacn :
            (Nat.factorial (n + 1) : ℝ) =
              ((n : ℝ) + 1) * (Nat.factorial n : ℝ) := by
          rw [Nat.factorial_succ]
          push_cast
          ring
        rw [Finset.prod_range_succ, ih, hfac2, hfacn, pow_succ]
        have hfact : (Nat.factorial n : ℝ) ≠ 0 := by
          exact_mod_cast Nat.factorial_ne_zero n
        have hpow : (4 : ℝ) ^ n ≠ 0 := pow_ne_zero _ (by norm_num)
        have hden : 2 * (n : ℝ) + 2 ≠ 0 := by positivity
        have hsucc : (n : ℝ) + 1 ≠ 0 := by positivity
        field_simp [hfact, hpow, hden, hsucc]
        ring
  rw [hprod]
  ring

/-- `BG-SPECIAL-THM-006`: every odd full-angle cosine moment vanishes. -/
@[simp] theorem fullAngleCosineMoment_odd (n : ℕ) :
    fullAngleCosineMoment (2 * n + 1) = 0 := by
  induction n with
  | zero => simp
  | succ n ih =>
      have hindex : 2 * (n + 1) + 1 = (2 * n + 1) + 2 := by omega
      rw [hindex, fullAngleCosineMoment_add_two, ih, mul_zero]

/-- `BG-SPECIAL-THM-007`: the exponential series may be integrated termwise over a full angle. -/
theorem fullAngleCosineExponentialKernel_eq_tsum_exp_integrals (z : ℝ) :
    fullAngleCosineExponentialKernel z =
      ∑' n : ℕ, ∫ θ in (0 : ℝ)..(2 * Real.pi),
        (Complex.I * (((z * Real.cos θ : ℝ) : ℂ))) ^ n /
          (Nat.factorial n : ℂ) := by
  let term : ℕ → ℝ → ℂ := fun n θ =>
    (Complex.I * (((z * Real.cos θ : ℝ) : ℂ))) ^ n /
      (Nat.factorial n : ℂ)
  have hbound (n : ℕ) (θ : ℝ) :
      ‖term n θ‖ ≤ |z| ^ n / (Nat.factorial n : ℝ) := by
    have hnorm :
        ‖Complex.I * (((z * Real.cos θ : ℝ) : ℂ))‖ ≤ |z| := by
      calc
        ‖Complex.I * (((z * Real.cos θ : ℝ) : ℂ))‖ =
            |z| * |Real.cos θ| := by
          simp only [norm_mul, Complex.norm_I, one_mul, Complex.norm_real,
            Real.norm_eq_abs]
        _ ≤ |z| * 1 :=
          mul_le_mul_of_nonneg_left (Real.abs_cos_le_one θ) (abs_nonneg z)
        _ = |z| := by ring
    calc
      ‖term n θ‖ =
          ‖Complex.I * (((z * Real.cos θ : ℝ) : ℂ))‖ ^ n /
            (Nat.factorial n : ℝ) := by simp [term]
      _ ≤ |z| ^ n / (Nat.factorial n : ℝ) := by gcongr
  have hseries :
      HasSum
        (fun n : ℕ => ∫ θ in (0 : ℝ)..(2 * Real.pi), term n θ)
        (∫ θ in (0 : ℝ)..(2 * Real.pi),
          Complex.exp (Complex.I * (((z * Real.cos θ : ℝ) : ℂ)))) := by
    apply intervalIntegral.hasSum_integral_of_dominated_convergence
      (F := term)
      (f := fun θ => Complex.exp (Complex.I * (((z * Real.cos θ : ℝ) : ℂ))))
      (bound := fun n (_ : ℝ) => |z| ^ n / (Nat.factorial n : ℝ))
    · intro n
      have hc : Continuous (term n) := by
        dsimp [term]
        fun_prop
      exact hc.aestronglyMeasurable
    · intro n
      filter_upwards [] with θ hθ
      exact hbound n θ
    · filter_upwards [] with θ hθ
      exact Real.summable_pow_div_factorial |z|
    · exact intervalIntegrable_const
    · filter_upwards [] with θ hθ
      change HasSum
        (fun n : ℕ =>
          (Complex.I * (((z * Real.cos θ : ℝ) : ℂ))) ^ n /
            (Nat.factorial n : ℂ))
        (Complex.exp (Complex.I * (((z * Real.cos θ : ℝ) : ℂ))))
      rw [Complex.exp_eq_exp_ℂ]
      exact NormedSpace.expSeries_div_hasSum_exp _
  simpa only [fullAngleCosineExponentialKernel, term] using hseries.tsum_eq.symm

/-- `BG-SPECIAL-THM-008`: the kernel series is expressed through real cosine moments. -/
theorem fullAngleCosineExponentialKernel_eq_tsum_moments (z : ℝ) :
    fullAngleCosineExponentialKernel z =
      ∑' n : ℕ, (Complex.I * (z : ℂ)) ^ n / (Nat.factorial n : ℂ) *
        (fullAngleCosineMoment n : ℂ) := by
  rw [fullAngleCosineExponentialKernel_eq_tsum_exp_integrals]
  congr 1
  funext n
  have hcos :
      (∫ θ in (0 : ℝ)..(2 * Real.pi), (((Real.cos θ : ℝ) : ℂ) ^ n)) =
        (fullAngleCosineMoment n : ℂ) := by
    simp only [← Complex.ofReal_pow, intervalIntegral.integral_ofReal,
      fullAngleCosineMoment]
  have hterm (θ : ℝ) :
      (Complex.I * (((z * Real.cos θ : ℝ) : ℂ))) ^ n /
          (Nat.factorial n : ℂ) =
        ((Complex.I * (z : ℂ)) ^ n / (Nat.factorial n : ℂ)) *
          (((Real.cos θ : ℝ) : ℂ) ^ n) := by
    have heq :
        Complex.I * (((z * Real.cos θ : ℝ) : ℂ)) =
          (Complex.I * (z : ℂ)) * ((Real.cos θ : ℝ) : ℂ) := by
      push_cast
      ring
    rw [heq, mul_pow]
    ring
  calc
    (∫ θ in (0 : ℝ)..(2 * Real.pi),
        (Complex.I * (((z * Real.cos θ : ℝ) : ℂ))) ^ n /
          (Nat.factorial n : ℂ)) =
      ∫ θ in (0 : ℝ)..(2 * Real.pi),
        ((Complex.I * (z : ℂ)) ^ n / (Nat.factorial n : ℂ)) *
          (((Real.cos θ : ℝ) : ℂ) ^ n) := by
      apply intervalIntegral.integral_congr
      intro θ _
      exact hterm θ
    _ = ((Complex.I * (z : ℂ)) ^ n / (Nat.factorial n : ℂ)) *
        (∫ θ in (0 : ℝ)..(2 * Real.pi), (((Real.cos θ : ℝ) : ℂ) ^ n)) := by
      rw [intervalIntegral.integral_const_mul]
    _ = _ := by rw [hcos]

/-- `BG-SPECIAL-THM-009`: Mathlib's zeroth-order Bessel coefficient is a reciprocal factorial
square. -/
theorem besselJZero_regularizedHGFunCoeff (n : ℕ) :
    Complex.regularizedHGFunCoeff 0 {(1 : ℂ)} n =
      1 / (Nat.factorial n : ℂ) ^ 2 := by
  have hgamma :
      Complex.Gamma ((1 : ℂ) + (n : ℂ)) = (Nat.factorial n : ℂ) := by
    simpa only [add_comm] using Complex.Gamma_nat_eq_factorial n
  simp [Complex.regularizedHGFunCoeff, hgamma, pow_two]

/-- `BG-SPECIAL-THM-010`: every full-angle cosine moment is bounded by the interval length. -/
theorem fullAngleCosineMoment_norm_le (n : ℕ) :
    ‖fullAngleCosineMoment n‖ ≤ 2 * Real.pi := by
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (0 : ℝ)) (b := 2 * Real.pi) (C := (1 : ℝ))
    (f := fun θ : ℝ => Real.cos θ ^ n) (by
      intro θ _
      simp only [Real.norm_eq_abs, abs_pow]
      exact pow_le_one₀ (abs_nonneg _) (Real.abs_cos_le_one θ))
  simpa only [fullAngleCosineMoment, one_mul, sub_zero,
    abs_of_nonneg (mul_nonneg (by norm_num : (0 : ℝ) ≤ 2) Real.pi_pos.le)] using h

/-- `BG-SPECIAL-THM-011`: the kernel's exponential/moment series is absolutely summable. -/
theorem fullAngleCosineMoments_summable (z : ℝ) :
    Summable (fun n : ℕ =>
      (Complex.I * (z : ℂ)) ^ n / (Nat.factorial n : ℂ) *
        (fullAngleCosineMoment n : ℂ)) := by
  have hs := (Real.summable_pow_div_factorial |z|).mul_left (2 * Real.pi)
  apply Summable.of_norm_bounded hs
  intro n
  have hfact : (0 : ℝ) ≤ (Nat.factorial n : ℝ) := by positivity
  have hpow : (0 : ℝ) ≤ |z| ^ n := pow_nonneg (abs_nonneg z) _
  have hmoment := fullAngleCosineMoment_norm_le n
  calc
    ‖(Complex.I * (z : ℂ)) ^ n / (Nat.factorial n : ℂ) *
        (fullAngleCosineMoment n : ℂ)‖ =
        (|z| ^ n / (Nat.factorial n : ℝ)) *
          ‖fullAngleCosineMoment n‖ := by
      simp only [norm_mul, norm_div, norm_pow, Complex.norm_I,
        Complex.norm_real, Complex.norm_natCast, Real.norm_eq_abs, one_mul]
    _ ≤ (|z| ^ n / (Nat.factorial n : ℝ)) * (2 * Real.pi) :=
      mul_le_mul_of_nonneg_left hmoment (div_nonneg hpow hfact)
    _ = (2 * Real.pi) * (|z| ^ n / (Nat.factorial n : ℝ)) := by ring

/-- `BG-SPECIAL-THM-012`: Mathlib's `J₀` equals its regularized-hypergeometric coefficient series. -/
theorem besselJZero_eq_tsum (z : ℂ) :
    Complex.besselJ 0 z =
      ∑' n : ℕ, Complex.regularizedHGFunCoeff 0 {(1 : ℂ)} n *
        (-(z / 2) ^ 2) ^ n := by
  rw [Complex.besselJ_def]
  simp only [Complex.cpow_zero, one_mul, zero_add]
  change (Complex.regularizedHGFunSeries 0 {(1 : ℂ)}).sum (-(z / 2) ^ 2) = _
  rw [Complex.regularizedHGFunSeries, ← FormalMultilinearSeries.ofScalarsSum,
    FormalMultilinearSeries.ofScalars_sum_eq]
  simp only [smul_eq_mul]

/-- `BG-SPECIAL-THM-013`: every even kernel coefficient agrees with the corresponding `J₀`
coefficient after multiplication by `2π`. -/
theorem fullAngleCosineMoment_even_eq_besselJZero (z : ℝ) (n : ℕ) :
    (Complex.I * (z : ℂ)) ^ (2 * n) / (Nat.factorial (2 * n) : ℂ) *
      (fullAngleCosineMoment (2 * n) : ℂ) =
      ((2 * Real.pi : ℝ) : ℂ) *
        (Complex.regularizedHGFunCoeff 0 {(1 : ℂ)} n *
          (-((z : ℂ) / 2) ^ 2) ^ n) := by
  rw [fullAngleCosineMoment_even_factorial, besselJZero_regularizedHGFunCoeff]
  push_cast
  have hI :
      (Complex.I * (z : ℂ)) ^ (2 * n) = (-(z : ℂ) ^ 2) ^ n := by
    rw [pow_mul, mul_pow, Complex.I_sq]
    ring
  have hdiv :
      (-((z : ℂ) / 2) ^ 2) ^ n =
        (-(z : ℂ) ^ 2) ^ n / (4 : ℂ) ^ n := by
    rw [← div_pow]
    congr 1
    ring
  rw [hI, hdiv]
  have hfac : (Nat.factorial (2 * n) : ℂ) ≠ 0 := by
    exact_mod_cast Nat.factorial_ne_zero (2 * n)
  have hfacn : (Nat.factorial n : ℂ) ≠ 0 := by
    exact_mod_cast Nat.factorial_ne_zero n
  have hfour : (4 : ℂ) ^ n ≠ 0 := pow_ne_zero _ (by norm_num)
  field_simp

/-- `BG-SPECIAL-THM-014`: the full-angle complex exponential cosine integral is exactly
`2π J₀(z)` for every real `z`. -/
theorem fullAngleCosineExponentialKernel_eq_besselJZero (z : ℝ) :
    fullAngleCosineExponentialKernel z =
      ((2 * Real.pi : ℝ) : ℂ) * Complex.besselJ 0 (z : ℂ) := by
  let f : ℕ → ℂ := fun n =>
    (Complex.I * (z : ℂ)) ^ n / (Nat.factorial n : ℂ) *
      (fullAngleCosineMoment n : ℂ)
  have hf : Summable f := fullAngleCosineMoments_summable z
  have he : Summable (fun n : ℕ => f (2 * n)) :=
    hf.comp_injective (by intro a b hab; omega)
  have ho : Summable (fun n : ℕ => f (2 * n + 1)) :=
    hf.comp_injective (by
      intro a b hab
      change 2 * a + 1 = 2 * b + 1 at hab
      omega)
  have hodd (n : ℕ) : f (2 * n + 1) = 0 := by
    simp [f]
  calc
    fullAngleCosineExponentialKernel z = ∑' n : ℕ, f n := by
      exact fullAngleCosineExponentialKernel_eq_tsum_moments z
    _ = (∑' n : ℕ, f (2 * n)) + ∑' n : ℕ, f (2 * n + 1) :=
      (tsum_even_add_odd he ho).symm
    _ = ∑' n : ℕ, f (2 * n) := by
      simp only [hodd, tsum_zero, add_zero]
    _ = ∑' n : ℕ, ((2 * Real.pi : ℝ) : ℂ) *
        (Complex.regularizedHGFunCoeff 0 {(1 : ℂ)} n *
          (-((z : ℂ) / 2) ^ 2) ^ n) := by
      apply tsum_congr
      intro n
      exact fullAngleCosineMoment_even_eq_besselJZero z n
    _ = ((2 * Real.pi : ℝ) : ℂ) *
        (∑' n : ℕ, Complex.regularizedHGFunCoeff 0 {(1 : ℂ)} n *
          (-((z : ℂ) / 2) ^ 2) ^ n) := by
      rw [tsum_mul_left]
    _ = ((2 * Real.pi : ℝ) : ℂ) * Complex.besselJ 0 (z : ℂ) := by
      rw [besselJZero_eq_tsum]

end ProjectKoios.BandGauge.SpecialFunctions

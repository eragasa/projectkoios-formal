/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import Mathlib.Analysis.Calculus.Deriv.Polynomial
public import Mathlib.Analysis.SpecialFunctions.ExpDeriv
public import Mathlib.Tactic.LinearCombination
public import Mathlib.Tactic.Module

/-!
# Hermite-polynomial eigenfunctions of the dimensionless harmonic oscillator

This module constructs the physicists' Hermite polynomials by their raising recurrence, proves their
polynomial differential equation, and proves that a Hermite polynomial times the Gaussian
`exp (-x²/2)` is an eigenfunction of the dimensionless oscillator differential expression.

Mathlib's `Polynomial.hermite` uses the probabilists' convention.  A separate definition is used
here so the recurrence and Gaussian match the numerical QHO source directly.  The theorem is
pointwise.  It does not yet prove `L²` normalization, orthogonality, completeness, operator-domain
membership, self-adjointness, or spectral completeness.
-/

@[expose] public section

open Polynomial

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

/--
`QHO-HERMITE-DEF-001`: physicists' Hermite polynomial, defined by
`H₀ = 1` and `Hₙ₊₁ = 2 X Hₙ - Hₙ'`.
-/
noncomputable def physicistsHermitePolynomial : ℕ → Polynomial ℝ
  | 0 => 1
  | n + 1 => (2 : ℝ) • (X * physicistsHermitePolynomial n) -
      derivative (physicistsHermitePolynomial n)

/-- `QHO-HERMITE-LEM-001`: the degree-zero physicists' Hermite polynomial is one. -/
@[simp]
lemma physicistsHermitePolynomial_zero : physicistsHermitePolynomial 0 = 1 := rfl

/-- `QHO-HERMITE-LEM-002`: raising recurrence for physicists' Hermite polynomials. -/
@[simp]
lemma physicistsHermitePolynomial_succ (n : ℕ) :
    physicistsHermitePolynomial (n + 1) =
      (2 : ℝ) • (X * physicistsHermitePolynomial n) -
        derivative (physicistsHermitePolynomial n) := rfl

/-- `QHO-HERMITE-DEF-002`: polynomial residual for the physicists' Hermite equation. -/
noncomputable def physicistsHermiteDifferentialResidual (n : ℕ) : Polynomial ℝ :=
  derivative (derivative (physicistsHermitePolynomial n)) -
    (2 : ℝ) • (X * derivative (physicistsHermitePolynomial n)) +
      (2 * n : ℝ) • physicistsHermitePolynomial n

/--
`QHO-HERMITE-LEM-003`: the Hermite differential equation at degree `n` implies the derivative
formula for degree `n + 1`.
-/
lemma derivative_physicistsHermitePolynomial_succ_of_residual_eq_zero
    (n : ℕ) (h : physicistsHermiteDifferentialResidual n = 0) :
    derivative (physicistsHermitePolynomial (n + 1)) =
      (2 * (n + 1) : ℝ) • physicistsHermitePolynomial n := by
  rw [physicistsHermitePolynomial_succ, derivative_sub, derivative_smul,
    derivative_mul, derivative_X]
  simp only [one_mul]
  unfold physicistsHermiteDifferentialResidual at h
  have hsecond :
      derivative (derivative (physicistsHermitePolynomial n)) =
        (2 : ℝ) • (X * derivative (physicistsHermitePolynomial n)) -
          (2 * n : ℝ) • physicistsHermitePolynomial n := by
    linear_combination h
  rw [hsecond]
  module

/-- `QHO-HERMITE-THM-001`: every physicists' Hermite polynomial satisfies its differential equation. -/
theorem physicistsHermiteDifferentialResidual_eq_zero (n : ℕ) :
    physicistsHermiteDifferentialResidual n = 0 := by
  induction n with
  | zero => simp [physicistsHermiteDifferentialResidual]
  | succ n ih =>
      have hd := derivative_physicistsHermitePolynomial_succ_of_residual_eq_zero n ih
      have hdd := congrArg derivative hd
      simp only [derivative_smul] at hdd
      rw [physicistsHermiteDifferentialResidual, hdd, hd,
        physicistsHermitePolynomial_succ]
      push_cast
      simp only [mul_smul_comm]
      module

/-- `QHO-HERMITE-LEM-004`: derivative lowering formula for physicists' Hermite polynomials. -/
lemma derivative_physicistsHermitePolynomial (n : ℕ) :
    derivative (physicistsHermitePolynomial n) =
      (2 * n : ℝ) • physicistsHermitePolynomial (n - 1) := by
  cases n with
  | zero => simp
  | succ n =>
      simpa using derivative_physicistsHermitePolynomial_succ_of_residual_eq_zero n
        (physicistsHermiteDifferentialResidual_eq_zero n)

/-- `QHO-HERMITE-LEM-005`: source-aligned three-term physicists' Hermite recurrence. -/
lemma physicistsHermitePolynomial_succ_eq_three_term (n : ℕ) :
    physicistsHermitePolynomial (n + 1) =
      (2 : ℝ) • (X * physicistsHermitePolynomial n) -
        (2 * n : ℝ) • physicistsHermitePolynomial (n - 1) := by
  rw [physicistsHermitePolynomial_succ, derivative_physicistsHermitePolynomial]

/-- `QHO-HERMITE-LEM-006`: pointwise form of the physicists' Hermite differential equation. -/
lemma physicistsHermiteDifferentialEquation (n : ℕ) (x : ℝ) :
    aeval x (derivative (derivative (physicistsHermitePolynomial n))) -
      2 * x * aeval x (derivative (physicistsHermitePolynomial n)) +
      2 * n * aeval x (physicistsHermitePolynomial n) = 0 := by
  have h := congrArg (fun p : Polynomial ℝ => aeval x p)
    (physicistsHermiteDifferentialResidual_eq_zero n)
  simp only [physicistsHermiteDifferentialResidual, map_add, map_sub, map_smul, map_zero] at h
  simpa [smul_eq_mul, mul_assoc] using h

/-- `QHO-HERMITE-DEF-003`: dimensionless Gaussian `exp (-x²/2)`. -/
noncomputable def oscillatorGaussian (x : ℝ) : ℝ :=
  Real.exp (-(x ^ 2 / 2))

/-- `QHO-HERMITE-DEF-004`: unnormalized Hermite--Gaussian function. -/
noncomputable def hermiteGaussianFunction (n : ℕ) : ℝ → ℝ :=
  (fun x => aeval x (physicistsHermitePolynomial n)) * oscillatorGaussian

/-- `QHO-HERMITE-DEF-005`: explicit first-derivative expression for a Hermite--Gaussian function. -/
noncomputable def hermiteGaussianFirstDerivative (n : ℕ) : ℝ → ℝ :=
  ((fun x => aeval x (derivative (physicistsHermitePolynomial n))) -
      id * (fun x => aeval x (physicistsHermitePolynomial n))) * oscillatorGaussian

/-- `QHO-HERMITE-DEF-006`: explicit second-derivative expression for a Hermite--Gaussian function. -/
noncomputable def hermiteGaussianSecondDerivative (n : ℕ) (x : ℝ) : ℝ :=
  (aeval x (derivative (derivative (physicistsHermitePolynomial n))) -
    2 * x * aeval x (derivative (physicistsHermitePolynomial n)) +
    (x ^ 2 - 1) * aeval x (physicistsHermitePolynomial n)) * oscillatorGaussian x

/-- `QHO-HERMITE-LEM-007`: derivative of the dimensionless oscillator Gaussian. -/
lemma hasDerivAt_oscillatorGaussian (x : ℝ) :
    HasDerivAt oscillatorGaussian (-x * oscillatorGaussian x) x := by
  change HasDerivAt (fun y : ℝ => Real.exp (-(y ^ 2 / 2)))
    (-x * Real.exp (-(x ^ 2 / 2))) x
  have hinner : HasDerivAt (fun y : ℝ => -(y ^ 2 / 2)) (-x) x := by
    convert ((hasDerivAt_pow 2 x).div_const 2).neg using 1
    all_goals ring
  convert hinner.exp using 1
  all_goals ring

/-- `QHO-HERMITE-LEM-008`: exact first derivative of the Hermite--Gaussian function. -/
lemma hasDerivAt_hermiteGaussianFunction (n : ℕ) (x : ℝ) :
    HasDerivAt (hermiteGaussianFunction n) (hermiteGaussianFirstDerivative n x) x := by
  have hp := (Polynomial.hasDerivAt_aeval (physicistsHermitePolynomial n) x).mul
    (hasDerivAt_oscillatorGaussian x)
  change HasDerivAt
    ((fun x => aeval x (physicistsHermitePolynomial n)) * oscillatorGaussian)
    (hermiteGaussianFirstDerivative n x) x
  convert hp using 1
  all_goals simp [hermiteGaussianFirstDerivative]
  all_goals ring

/-- `QHO-HERMITE-LEM-009`: exact second derivative of the Hermite--Gaussian function. -/
lemma hasDerivAt_hermiteGaussianFirstDerivative (n : ℕ) (x : ℝ) :
    HasDerivAt (hermiteGaussianFirstDerivative n)
      (hermiteGaussianSecondDerivative n x) x := by
  have hp := Polynomial.hasDerivAt_aeval (physicistsHermitePolynomial n) x
  have hdp := Polynomial.hasDerivAt_aeval
    (derivative (physicistsHermitePolynomial n)) x
  have hx := (hasDerivAt_id x).mul hp
  have hfactor := hdp.sub hx
  have hproduct := hfactor.mul (hasDerivAt_oscillatorGaussian x)
  change HasDerivAt
    (((fun x => aeval x (derivative (physicistsHermitePolynomial n))) -
      id * (fun x => aeval x (physicistsHermitePolynomial n))) * oscillatorGaussian)
    (hermiteGaussianSecondDerivative n x) x
  convert hproduct using 1
  all_goals simp [hermiteGaussianSecondDerivative]
  all_goals ring

/-- `QHO-HERMITE-LEM-010`: first derivative as Lean's `deriv`. -/
lemma deriv_hermiteGaussianFunction (n : ℕ) (x : ℝ) :
    deriv (hermiteGaussianFunction n) x = hermiteGaussianFirstDerivative n x :=
  (hasDerivAt_hermiteGaussianFunction n x).deriv

/-- `QHO-HERMITE-LEM-011`: second derivative as an iterated Lean `deriv`. -/
lemma second_deriv_hermiteGaussianFunction (n : ℕ) (x : ℝ) :
    deriv (deriv (hermiteGaussianFunction n)) x = hermiteGaussianSecondDerivative n x := by
  have hfun : deriv (hermiteGaussianFunction n) = hermiteGaussianFirstDerivative n :=
    funext (deriv_hermiteGaussianFunction n)
  rw [hfun]
  exact (hasDerivAt_hermiteGaussianFirstDerivative n x).deriv

/-- `QHO-HERMITE-DEF-007`: dimensionless QHO differential expression. -/
noncomputable def dimensionlessHarmonicOscillator (f : ℝ → ℝ) (x : ℝ) : ℝ :=
  -(1 / 2 : ℝ) * deriv (deriv f) x + (x ^ 2 / 2) * f x

/--
`QHO-HERMITE-THM-002`: Hermite--Gaussian functions are pointwise eigenfunctions of the
dimensionless QHO differential expression with eigenvalue `n + 1/2`.
-/
theorem dimensionlessHarmonicOscillator_hermiteGaussianFunction
    (n : ℕ) (x : ℝ) :
    dimensionlessHarmonicOscillator (hermiteGaussianFunction n) x =
      (n + 1 / 2 : ℝ) * hermiteGaussianFunction n x := by
  rw [dimensionlessHarmonicOscillator, second_deriv_hermiteGaussianFunction]
  have hode := physicistsHermiteDifferentialEquation n x
  unfold hermiteGaussianSecondDerivative hermiteGaussianFunction
  simp only [Pi.mul_apply]
  ring_nf at hode ⊢
  linear_combination (-oscillatorGaussian x / 2) * hode

end ProjectKoios.QuantumMechanics.HarmonicOscillator

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-31
-/
module

public import ProjectKoios.BandGauge.Fourier.NormalizedProductTorus
public import ProjectKoios.BandGauge.SpecialFunctions.BesselJZeroIntegral
public import Mathlib.Analysis.SpecialFunctions.Complex.Circle

/-!
# Normalized circle and product-torus Bessel identities

This module fixes the circle carrier, normalized Haar measure, period-one coordinate convention,
positive phase sign, and amplitude scaling. It proves that the normalized one-circle average of
`exp (i b sin(2πq))` is Mathlib's `J₀(b)`, then combines that result with the finite product-torus
factorization laws.

These exact identities do not bind an external runtime phase or coordinate, authenticate quadrature
or a finite mesh, establish finite-to-continuum convergence, or certify a numerical or scientific
comparator.
-/

open Complex MeasureTheory Real
open scoped MeasureTheory

@[expose] public section

namespace ProjectKoios.BandGauge.Fourier

/-- `BG-FOURIER-DEF-057`: the sine coordinate on the unit additive circle induced by its standard
map to the complex unit circle. For a real representative `x`, this is `sin (2πx)`. -/
noncomputable def unitAddCircleSine (coordinate : UnitAddCircle) : ℝ :=
  ((AddCircle.toCircle coordinate : Circle) : ℂ).im

/-- `BG-FOURIER-DEF-058`: the positive-sign one-circle complex phase `i b sin(2πq)`. -/
noncomputable def oneCircleSinePhase (amplitude : ℝ) (coordinate : UnitAddCircle) : ℂ :=
  Complex.I * (amplitude : ℂ) * (unitAddCircleSine coordinate : ℂ)

/-- `BG-FOURIER-THM-128`: a real representative of the unit additive circle has sine coordinate
`sin (2πx)`. -/
theorem unitAddCircleSine_coe (x : ℝ) :
    unitAddCircleSine x = Real.sin (2 * Real.pi * x) := by
  rw [unitAddCircleSine, AddCircle.toCircle_apply_mk, Circle.coe_exp]
  simp only [div_one]
  rw [Complex.exp_ofReal_mul_I_im]

/-- `BG-FOURIER-THM-129`: the normalized one-circle exponential sine average is exactly
Mathlib's zeroth Bessel function. -/
theorem integral_exp_oneCircleSinePhase_eq_besselJZero (amplitude : ℝ) :
    (∫ coordinate : UnitAddCircle,
      Complex.exp (oneCircleSinePhase amplitude coordinate)) =
      Complex.besselJ 0 amplitude := by
  let f : ℝ → ℂ := fun θ =>
    Complex.exp (Complex.I * (amplitude : ℂ) * (Real.sin θ : ℂ))
  let g : ℝ → ℂ := fun θ =>
    Complex.exp (Complex.I * (amplitude : ℂ) * (Real.cos θ : ℂ))
  have hcircle :
      (∫ coordinate : UnitAddCircle,
        Complex.exp (oneCircleSinePhase amplitude coordinate)) =
        ∫ x in (0 : ℝ)..1, f (2 * Real.pi * x) := by
    simpa [f, oneCircleSinePhase, unitAddCircleSine_coe] using
      (UnitAddCircle.intervalIntegral_preimage 0
        (fun coordinate : UnitAddCircle =>
          Complex.exp (oneCircleSinePhase amplitude coordinate))).symm
  have hscale :
      (∫ x in (0 : ℝ)..1, f (2 * Real.pi * x)) =
        (2 * Real.pi)⁻¹ • ∫ θ in (0 : ℝ)..(2 * Real.pi), f θ := by
    simpa only [mul_zero, mul_one] using
      (intervalIntegral.integral_comp_mul_left
        (f := f) (a := (0 : ℝ)) (b := (1 : ℝ))
        (c := 2 * Real.pi) (by positivity))
  have hg_periodic : Function.Periodic g (2 * Real.pi) := by
    intro θ
    unfold g
    rw [Real.cos_add_two_pi]
  have hsin_cos :
      (∫ θ in (0 : ℝ)..(2 * Real.pi), f θ) =
        ∫ θ in (0 : ℝ)..(2 * Real.pi), g θ := by
    calc
      (∫ θ in (0 : ℝ)..(2 * Real.pi), f θ) =
          ∫ θ in (0 : ℝ)..(2 * Real.pi), g (θ - Real.pi / 2) := by
        apply intervalIntegral.integral_congr
        intro θ _
        simp only [f, g, Real.cos_sub_pi_div_two]
      _ = ∫ θ in (0 : ℝ) - Real.pi / 2..(2 * Real.pi) - Real.pi / 2, g θ := by
        rw [intervalIntegral.integral_comp_sub_right]
      _ = ∫ θ in (0 : ℝ)..(2 * Real.pi), g θ := by
        convert hg_periodic.intervalIntegral_add_eq (-Real.pi / 2) 0 using 1 <;> ring_nf
  have hfull :
      (∫ θ in (0 : ℝ)..(2 * Real.pi), g θ) =
        ((2 * Real.pi : ℝ) : ℂ) * Complex.besselJ 0 (amplitude : ℂ) := by
    simpa [g, SpecialFunctions.fullAngleCosineExponentialKernel, mul_assoc] using
      SpecialFunctions.fullAngleCosineExponentialKernel_eq_besselJZero amplitude
  rw [hcircle, hscale, hsin_cos, hfull, real_smul]
  have hpi : (2 * Real.pi : ℝ) ≠ 0 := by positivity
  push_cast
  field_simp

/-- `BG-FOURIER-THM-130`: equal positive sine phases on a finite normalized product torus average
to the corresponding cardinality power of `J₀`. -/
theorem normalizedProductTorusAverage_exp_sameSinePhase_eq_besselJZero_pow
    {Dimension : Type*} [Fintype Dimension] (amplitude : ℝ) :
    normalizedProductTorusAverage
        (fun point => Complex.exp
          (separableProductTorusPhase
            (fun _ : Dimension => oneCircleSinePhase amplitude) point)) =
      Complex.besselJ 0 amplitude ^ Fintype.card Dimension := by
  rw [normalizedProductTorusAverage_exp_samePhase_eq_pow,
    integral_exp_oneCircleSinePhase_eq_besselJZero]

/-- `BG-FOURIER-THM-131`: two equal normalized sine-phase coordinates give `J₀(b)²`. -/
theorem normalizedProductTorusAverage_exp_finTwo_sameSinePhase_eq_besselJZero_sq
    (amplitude : ℝ) :
    normalizedProductTorusAverage
        (fun point : NormalizedProductTorus (Fin 2) => Complex.exp
          (separableProductTorusPhase
            (fun _ : Fin 2 => oneCircleSinePhase amplitude) point)) =
      Complex.besselJ 0 amplitude ^ 2 := by
  simpa using
    (normalizedProductTorusAverage_exp_sameSinePhase_eq_besselJZero_pow
      (Dimension := Fin 2) amplitude)

/-- `BG-FOURIER-THM-132`: three equal normalized sine-phase coordinates give `J₀(b)³`. -/
theorem normalizedProductTorusAverage_exp_finThree_sameSinePhase_eq_besselJZero_cube
    (amplitude : ℝ) :
    normalizedProductTorusAverage
        (fun point : NormalizedProductTorus (Fin 3) => Complex.exp
          (separableProductTorusPhase
            (fun _ : Fin 3 => oneCircleSinePhase amplitude) point)) =
      Complex.besselJ 0 amplitude ^ 3 := by
  simpa using
    (normalizedProductTorusAverage_exp_sameSinePhase_eq_besselJZero_pow
      (Dimension := Fin 3) amplitude)

/-- `BG-FOURIER-THM-133`: three normalized sine-phase coordinates with amplitude `2a/3` give
`J₀(2a/3)³`. This is an exact scaling corollary, not an external phase-binding theorem. -/
theorem normalizedProductTorusAverage_exp_finThree_twoThirdsSinePhase_eq_besselJZero_cube
    (amplitude : ℝ) :
    normalizedProductTorusAverage
        (fun point : NormalizedProductTorus (Fin 3) => Complex.exp
          (separableProductTorusPhase
            (fun _ : Fin 3 => oneCircleSinePhase (2 * amplitude / 3)) point)) =
      Complex.besselJ 0 ((2 * amplitude / 3 : ℝ) : ℂ) ^ 3 := by
  exact normalizedProductTorusAverage_exp_finThree_sameSinePhase_eq_besselJZero_cube
    (2 * amplitude / 3)

end ProjectKoios.BandGauge.Fourier

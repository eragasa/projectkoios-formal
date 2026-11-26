/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.Fourier.FourierTransform
public import Mathlib.MeasureTheory.Measure.CharacteristicFunction.Basic
public import Mathlib.MeasureTheory.VectorMeasure.WithDensity

/-!
# Injectivity of the pointwise Fourier integral on integrable functions

This module proves that an integrable complex-valued function on `ℝ` whose pointwise Fourier
integral vanishes is zero almost everywhere.

## i. Overview

Mathlib's `L²` Fourier transform is an abstract linear isometric equivalence, while Physlib's legacy
one-dimensional harmonic-oscillator completeness proof uses the pointwise Fourier integral of an
integrable square-integrable function. Instead of identifying those two transforms, this module
proves the exact injectivity statement needed by that argument.

The proof represents the positive and negative parts of a real integrable function as finite
measures. Equality of their characteristic functions implies equality of the measures, and
uniqueness of vector-measure densities gives almost-everywhere vanishing. A complex function is
then reduced to its real and imaginary parts using Fourier compatibility with conjugation,
addition, and complex scaling.

## ii. Key results

- `ae_eq_zero_of_fourier_eq_zero`

## iii. Table of contents

- A. Real-valued density measures
- B. Fourier algebra
- C. Complex Fourier-integral injectivity

## iv. References

The proof uses Mathlib revision `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`, especially
`Measure.ext_of_charFun`, `Integrable.withDensityᵥ_eq_iff`, and the pointwise Fourier-integral API.
No external scientific source or numerical evidence is used.

## A. Proof schematic

```mermaid
flowchart TD
    fourierZero["pointwise Fourier integral = 0"]
    realParts["positive/negative real densities"]
    charEq["equal characteristic functions"]
    measureEq["equal finite measures"]
    realZero["real density = 0 almost everywhere"]
    complexSplit["real/imaginary decomposition"]
    complexZero["complex function = 0 almost everywhere"]

    fourierZero --> charEq
    realParts --> charEq
    charEq --> measureEq
    measureEq --> realZero
    realZero --> complexSplit
    complexSplit --> complexZero
```
-/

@[expose] public section

open Filter MeasureTheory Complex Module Real
open scoped FourierTransform RealInnerProductSpace Complex

noncomputable section

namespace ProjectKoios.QuantumMechanics.Fourier

/-! ## A. Real-valued density measures -/

private lemma charFun_withDensity_ofReal (h : ℝ → ℝ) (hh : Integrable h) (t : ℝ) :
    charFun (volume.withDensity fun x => ENNReal.ofReal (h x)) t =
      ∫ x, ((max (h x) 0 : ℝ) : ℂ) * BoundedContinuousFunction.innerProbChar t x := by
  rw [charFun_eq_integral_innerProbChar,
    integral_withDensity_eq_integral_toReal_smul₀]
  · apply integral_congr_ae
    filter_upwards with x
    rw [ENNReal.toReal_ofReal']
    simp
  · exact hh.aestronglyMeasurable.aemeasurable.ennreal_ofReal
  · filter_upwards with x
    exact ENNReal.ofReal_lt_top

private lemma charFun_pos_sub_neg_eq_fourier (h : ℝ → ℝ) (hh : Integrable h) (t : ℝ) :
    charFun (volume.withDensity fun x => ENNReal.ofReal (h x)) t -
        charFun (volume.withDensity fun x => ENNReal.ofReal (-h x)) t =
      𝓕 (fun x => (h x : ℂ)) (-(2 * Real.pi)⁻¹ * t) := by
  rw [charFun_withDensity_ofReal h hh,
    charFun_withDensity_ofReal (fun x => -h x) hh.neg]
  have hpReal : Integrable (fun x => max (h x) 0) :=
    hh.sup (integrable_zero ℝ ℝ volume)
  have hnReal : Integrable (fun x => max (-h x) 0) :=
    hh.neg.sup (integrable_zero ℝ ℝ volume)
  have hp : Integrable (fun x => ((max (h x) 0 : ℝ) : ℂ)) :=
    Complex.ofRealCLM.integrable_comp hpReal
  have hn : Integrable (fun x => ((max (-h x) 0 : ℝ) : ℂ)) :=
    Complex.ofRealCLM.integrable_comp hnReal
  have hchar : AEStronglyMeasurable
      (fun x : ℝ => BoundedContinuousFunction.innerProbChar t x) := by
    fun_prop
  have hcharNorm : ∀ᵐ x : ℝ, ‖BoundedContinuousFunction.innerProbChar t x‖ ≤ 1 := by
    filter_upwards with x
    rw [BoundedContinuousFunction.innerProbChar_apply, Complex.norm_exp]
    simp
  have hpInt : Integrable (fun x => ((max (h x) 0 : ℝ) : ℂ) *
      BoundedContinuousFunction.innerProbChar t x) := by
    simpa [mul_comm] using hp.bdd_mul hchar hcharNorm
  have hnInt : Integrable (fun x => ((max (-h x) 0 : ℝ) : ℂ) *
      BoundedContinuousFunction.innerProbChar t x) := by
    simpa [mul_comm] using hn.bdd_mul hchar hcharNorm
  rw [← integral_sub hpInt hnInt,
    Real.fourier_real_eq_integral_exp_smul]
  apply integral_congr_ae
  filter_upwards with x
  rw [BoundedContinuousFunction.innerProbChar_apply]
  simp only [RCLike.inner_apply, conj_trivial, smul_eq_mul]
  rw [← sub_mul, ← Complex.ofReal_sub, max_zero_sub_max_neg_zero_eq_self, mul_comm]
  congr 1
  push_cast
  field_simp [Real.pi_ne_zero]

private lemma ae_eq_zero_of_fourier_ofReal_eq_zero (h : ℝ → ℝ) (hh : Integrable h)
    (hFourier : 𝓕 (fun x => (h x : ℂ)) = 0) : h =ᵐ[volume] 0 := by
  let μpos : Measure ℝ := volume.withDensity fun x => ENNReal.ofReal (h x)
  let μneg : Measure ℝ := volume.withDensity fun x => ENNReal.ofReal (-h x)
  let _ : IsFiniteMeasure μpos := by
    dsimp [μpos]
    exact isFiniteMeasure_withDensity_ofReal hh.2
  let _ : IsFiniteMeasure μneg := by
    dsimp [μneg]
    exact isFiniteMeasure_withDensity_ofReal hh.neg.2
  have hMeasure : μpos = μneg := by
    apply Measure.ext_of_charFun
    funext t
    have hIdentity := charFun_pos_sub_neg_eq_fourier h hh t
    change charFun μpos t - charFun μneg t = _ at hIdentity
    rw [hFourier] at hIdentity
    simpa using sub_eq_zero.mp hIdentity
  have hSigned : μpos.toSignedMeasure = μneg.toSignedMeasure := by
    apply VectorMeasure.ext
    intro s hs
    rw [Measure.toSignedMeasure_apply_measurable hs,
      Measure.toSignedMeasure_apply_measurable hs]
    exact congrArg (fun μ : Measure ℝ => μ.real s) hMeasure
  apply (hh.withDensityᵥ_eq_iff (integrable_zero ℝ ℝ volume)).mp
  rw [withDensityᵥ_eq_withDensity_pos_part_sub_withDensity_neg_part hh]
  change μpos.toSignedMeasure - μneg.toSignedMeasure = _
  rw [hSigned]
  simp

/-! ## B. Fourier algebra -/

private lemma fourier_conj (f : ℝ → ℂ) (w : ℝ) :
    𝓕 (fun x => starRingEnd ℂ (f x)) w = starRingEnd ℂ (𝓕 f (-w)) := by
  rw [Real.fourier_real_eq_integral_exp_smul,
    Real.fourier_real_eq_integral_exp_smul, ← integral_conj]
  apply integral_congr_ae
  filter_upwards with x
  simp only [smul_eq_mul, map_mul]
  congr 1
  rw [← Complex.exp_conj]
  congr 1
  simp only [map_mul, conj_ofReal, conj_I]
  push_cast
  ring

private lemma fourier_add_integrable (f g : ℝ → ℂ) (hf : Integrable f) (hg : Integrable g) :
    𝓕 (f + g) = 𝓕 f + 𝓕 g :=
  VectorFourier.fourierIntegral_add Real.continuous_fourierChar continuous_inner hf hg

private lemma fourier_const_smul (c : ℂ) (f : ℝ → ℂ) : 𝓕 (c • f) = c • 𝓕 f := by
  funext w
  simp only [Pi.smul_apply]
  rw [Real.fourier_real_eq_integral_exp_smul,
    Real.fourier_real_eq_integral_exp_smul, ← integral_smul]
  apply integral_congr_ae
  filter_upwards with x
  simp only [Pi.smul_apply, smul_eq_mul]
  ring

/-! ## C. Complex Fourier-integral injectivity -/

/-- An integrable complex-valued function on `ℝ` whose pointwise Fourier integral vanishes is zero
almost everywhere.

This is an injectivity theorem for Mathlib's function-level Fourier integral, not an identification
with the abstract `L²` Fourier isometry.

Project Koios ID: `QM-FOURIER-LEM-001`. -/
lemma ae_eq_zero_of_fourier_eq_zero (f : ℝ → ℂ) (hf : Integrable f)
    (hFourier : 𝓕 f = 0) : f =ᵐ[volume] 0 := by
  let fConj : ℝ → ℂ := fun x => starRingEnd ℂ (f x)
  have hfConj : Integrable fConj :=
    Complex.conjCLE.toContinuousLinearMap.integrable_comp hf
  have hFourierConj : 𝓕 fConj = 0 := by
    funext w
    rw [fourier_conj, hFourier]
    simp
  let fRe : ℝ → ℂ := fun x => (re (f x) : ℂ)
  have hfReReal : Integrable (fun x => re (f x)) := Complex.reCLM.integrable_comp hf
  have hfRe : Integrable fRe := Complex.ofRealCLM.integrable_comp hfReReal
  have hfRe_eq : fRe = (2 : ℂ)⁻¹ • (f + fConj) := by
    funext x
    simp only [fRe, fConj, Pi.smul_apply, Pi.add_apply, smul_eq_mul]
    apply Complex.ext
    · simp
      ring
    · simp
  have hFourierRe : 𝓕 fRe = 0 := by
    rw [hfRe_eq, fourier_const_smul,
      fourier_add_integrable f fConj hf hfConj, hFourier, hFourierConj]
    simp
  have hReZero : (fun x => re (f x)) =ᵐ[volume] 0 :=
    ae_eq_zero_of_fourier_ofReal_eq_zero (fun x => re (f x)) hfReReal hFourierRe
  let fIm : ℝ → ℂ := fun x => (im (f x) : ℂ)
  have hfImReal : Integrable (fun x => im (f x)) := Complex.imCLM.integrable_comp hf
  have hfIm : Integrable fIm := Complex.ofRealCLM.integrable_comp hfImReal
  have hf_eq_im : f =ᵐ[volume] Complex.I • fIm := by
    filter_upwards [hReZero] with x hx
    simp only [Pi.zero_apply] at hx
    simp only [fIm, Pi.smul_apply, smul_eq_mul]
    apply Complex.ext
    · simp [hx]
    · simp
  have hFourier_eq_im : 𝓕 f = 𝓕 (Complex.I • fIm) := by
    funext w
    exact Real.fourier_congr_ae hf_eq_im w
  have hFourierIm : 𝓕 fIm = 0 := by
    have hI : Complex.I • 𝓕 fIm = 0 := by
      rw [← fourier_const_smul, ← hFourier_eq_im, hFourier]
    exact (smul_eq_zero.mp hI).resolve_left Complex.I_ne_zero
  have hImZero : (fun x => im (f x)) =ᵐ[volume] 0 :=
    ae_eq_zero_of_fourier_ofReal_eq_zero (fun x => im (f x)) hfImReal hFourierIm
  filter_upwards [hReZero, hImZero] with x hxRe hxIm
  simp only [Pi.zero_apply] at hxRe hxIm ⊢
  apply Complex.ext
  · simpa using hxRe
  · simpa using hxIm

end ProjectKoios.QuantumMechanics.Fourier

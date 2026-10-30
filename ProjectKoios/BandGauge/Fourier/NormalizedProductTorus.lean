/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-31
-/
module

public import Mathlib.MeasureTheory.Integral.Pi
public import Mathlib.MeasureTheory.Integral.IntervalIntegral.Periodic
public import Mathlib.Analysis.Complex.Exponential

/-!
# Normalized finite product-torus factorization

This module gives a narrow exact interface for normalized integration on finite products of the
unit additive circle. The product-torus measure is the finite product of the standard circle Haar
measure, whose total mass is one. Coordinate-separable complex fields therefore have factored
averages, and exponentials of coordinatewise additive phases factor in the same way. Equal
coordinate factors yield a power, with explicit square and cube corollaries for two and three
dimensions.

The generic finite-product integration theorem is supplied by pinned Mathlib. These declarations
make the normalization and product-torus carrier explicit for downstream BandGauge consumers.
They do not identify an external coordinate convention, prove a Bessel integral, authenticate a
finite mesh or quadrature, establish finite-to-continuum convergence, or bind a runtime phase,
Fourier coefficient, numerical value, physical model, or scientific acceptance decision.
-/

open scoped BigOperators MeasureTheory ENNReal
open MeasureTheory

@[expose] public section

namespace ProjectKoios.BandGauge.Fourier

/-- `BG-FOURIER-DEF-052`: the normalized finite product torus indexed by `Dimension`.
Each coordinate is the unit additive circle. -/
abbrev NormalizedProductTorus (Dimension : Type*) := Dimension → UnitAddCircle

/-- `BG-FOURIER-DEF-053`: the product of the standard unit-circle Haar measures. -/
noncomputable def normalizedProductTorusMeasure (Dimension : Type*) [Fintype Dimension] :
    Measure (NormalizedProductTorus Dimension) :=
  Measure.pi fun _ : Dimension => (volume : Measure UnitAddCircle)

/-- `BG-FOURIER-DEF-054`: the exact complex average with respect to the normalized product-torus
measure. -/
noncomputable def normalizedProductTorusAverage
    {Dimension : Type*} [Fintype Dimension]
    (field : NormalizedProductTorus Dimension → ℂ) : ℂ :=
  ∫ point, field point ∂normalizedProductTorusMeasure Dimension

/-- `BG-FOURIER-DEF-055`: a product-torus field made from one factor per coordinate. -/
def separableProductTorusField
    {Dimension : Type*} [Fintype Dimension]
    (coordinateFactor : Dimension → UnitAddCircle → ℂ)
    (point : NormalizedProductTorus Dimension) : ℂ :=
  ∏ dimension, coordinateFactor dimension (point dimension)

/-- `BG-FOURIER-DEF-056`: a product-torus phase made from one additive term per coordinate. -/
def separableProductTorusPhase
    {Dimension : Type*} [Fintype Dimension]
    (coordinatePhase : Dimension → UnitAddCircle → ℂ)
    (point : NormalizedProductTorus Dimension) : ℂ :=
  ∑ dimension, coordinatePhase dimension (point dimension)

/-- `BG-FOURIER-THM-119`: the declared finite product-torus measure has total mass one. -/
theorem normalizedProductTorusMeasure_univ
    {Dimension : Type*} [Fintype Dimension] :
    normalizedProductTorusMeasure Dimension Set.univ = 1 := by
  rw [normalizedProductTorusMeasure, Measure.pi_univ]
  simp [AddCircle.measure_univ]

/-- `BG-FOURIER-THM-120`: the normalized product-torus average of the constant one field is one. -/
theorem normalizedProductTorusAverage_one
    {Dimension : Type*} [Fintype Dimension] :
    normalizedProductTorusAverage
        (fun _ : NormalizedProductTorus Dimension => (1 : ℂ)) = 1 := by
  rw [normalizedProductTorusAverage, integral_const, MeasureTheory.measureReal_def,
    normalizedProductTorusMeasure_univ]
  norm_num

/-- `BG-FOURIER-THM-121`: exponentiating a coordinatewise additive phase gives the corresponding
coordinatewise product field pointwise. -/
theorem exp_separableProductTorusPhase
    {Dimension : Type*} [Fintype Dimension]
    (coordinatePhase : Dimension → UnitAddCircle → ℂ)
    (point : NormalizedProductTorus Dimension) :
    Complex.exp (separableProductTorusPhase coordinatePhase point) =
      separableProductTorusField
        (fun dimension coordinate => Complex.exp (coordinatePhase dimension coordinate)) point := by
  simp [separableProductTorusPhase, separableProductTorusField, Complex.exp_sum]

/-- `BG-FOURIER-THM-122`: the normalized average of a coordinate-separable field factors into the
product of its one-circle averages. -/
theorem normalizedProductTorusAverage_separable
    {Dimension : Type*} [Fintype Dimension]
    (coordinateFactor : Dimension → UnitAddCircle → ℂ) :
    normalizedProductTorusAverage (separableProductTorusField coordinateFactor) =
      ∏ dimension, ∫ coordinate, coordinateFactor dimension coordinate := by
  exact MeasureTheory.integral_fintype_prod_eq_prod coordinateFactor

/-- `BG-FOURIER-THM-123`: if every coordinate uses the same factor, the normalized product-torus
average is the corresponding one-circle average raised to the number of dimensions. -/
theorem normalizedProductTorusAverage_sameFactor_eq_pow
    {Dimension : Type*} [Fintype Dimension]
    (factor : UnitAddCircle → ℂ) :
    normalizedProductTorusAverage
        (separableProductTorusField (fun _ : Dimension => factor)) =
      (∫ coordinate, factor coordinate) ^ Fintype.card Dimension := by
  exact MeasureTheory.integral_fintype_prod_eq_pow factor

/-- `BG-FOURIER-THM-124`: the normalized average of the exponential of a coordinatewise additive
phase factors into one-circle exponential averages. -/
theorem normalizedProductTorusAverage_exp_separablePhase
    {Dimension : Type*} [Fintype Dimension]
    (coordinatePhase : Dimension → UnitAddCircle → ℂ) :
    normalizedProductTorusAverage
        (fun point => Complex.exp (separableProductTorusPhase coordinatePhase point)) =
      ∏ dimension, ∫ coordinate, Complex.exp (coordinatePhase dimension coordinate) := by
  simpa [normalizedProductTorusAverage, normalizedProductTorusMeasure,
    separableProductTorusPhase, Complex.exp_sum] using
    (MeasureTheory.integral_fintype_prod_eq_prod (𝕜 := ℂ)
      (μ := fun _ : Dimension => (volume : Measure UnitAddCircle))
      (fun dimension coordinate => Complex.exp (coordinatePhase dimension coordinate)))

/-- `BG-FOURIER-THM-125`: equal coordinate phases give a power of one one-circle exponential
average. -/
theorem normalizedProductTorusAverage_exp_samePhase_eq_pow
    {Dimension : Type*} [Fintype Dimension]
    (phase : UnitAddCircle → ℂ) :
    normalizedProductTorusAverage
        (fun point => Complex.exp
          (separableProductTorusPhase (fun _ : Dimension => phase) point)) =
      (∫ coordinate, Complex.exp (phase coordinate)) ^ Fintype.card Dimension := by
  simpa [normalizedProductTorusAverage, normalizedProductTorusMeasure,
    separableProductTorusPhase, Complex.exp_sum] using
    (MeasureTheory.integral_fintype_prod_eq_pow (𝕜 := ℂ)
      (ι := Dimension) (μ := (volume : Measure UnitAddCircle))
      (fun coordinate => Complex.exp (phase coordinate)))

/-- `BG-FOURIER-THM-126`: in two dimensions, equal coordinate phases give the square of the
one-circle exponential average. -/
theorem normalizedProductTorusAverage_exp_finTwo_eq_sq
    (phase : UnitAddCircle → ℂ) :
    normalizedProductTorusAverage
        (fun point => Complex.exp
          (separableProductTorusPhase (fun _ : Fin 2 => phase) point)) =
      (∫ coordinate, Complex.exp (phase coordinate)) ^ 2 := by
  simpa using
    (normalizedProductTorusAverage_exp_samePhase_eq_pow (Dimension := Fin 2) phase)

/-- `BG-FOURIER-THM-127`: in three dimensions, equal coordinate phases give the cube of the
one-circle exponential average. -/
theorem normalizedProductTorusAverage_exp_finThree_eq_cube
    (phase : UnitAddCircle → ℂ) :
    normalizedProductTorusAverage
        (fun point => Complex.exp
          (separableProductTorusPhase (fun _ : Fin 3 => phase) point)) =
      (∫ coordinate, Complex.exp (phase coordinate)) ^ 3 := by
  simpa using
    (normalizedProductTorusAverage_exp_samePhase_eq_pow (Dimension := Fin 3) phase)

end ProjectKoios.BandGauge.Fourier

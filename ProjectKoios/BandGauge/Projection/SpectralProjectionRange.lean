/-
Copyright (c) 2026 Eugene Joseph M. Ragasa. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.BandGauge.Projection.LaurentObstruction

import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Analysis.SpecialFunctions.Complex.Circle
import Mathlib.Order.Interval.Set.Infinite
import Mathlib.Tactic.FieldSimp

/-!
# The two-band spectral-projection range counterexample

This module completes the exact Ragasa2026b proposition that spectral projection can
destroy finite hopping support. It freezes finite Fourier support as representability by
a complex Laurent polynomial under `z = exp(i k)`, proves that this unit-circle
evaluation is injective, constructs the algebraic lower-band projector, verifies its
idempotency, lower-eigenvalue relation, and sandwich identity, and proves that the
sandwich has no finite matrix Fourier representation although the parent does.

No claim is made about every finite-range parent, numerical evidence, material
validation, or a continuum localization rate.
-/

public section

open Matrix Polynomial

namespace ProjectKoios.BandGauge.Projection

/-- `BG-PROJECTION-DEF-003`: the unit `exp(i k)` used by the frozen circle-evaluation
convention. -/
noncomputable def unitCircleUnit (angle : ℝ) : ℂˣ :=
  Units.mk0 (Complex.exp ((angle : ℂ) * Complex.I)) (Complex.exp_ne_zero _)

/-- `BG-PROJECTION-DEF-004`: evaluate a complex Laurent polynomial at `z = exp(i k)`. -/
noncomputable def evalLaurentOnUnitCircle
    (f : LaurentPolynomial ℂ) (angle : ℝ) : ℂ :=
  LaurentPolynomial.eval₂ (RingHom.id ℂ) (unitCircleUnit angle) f

@[simp] private lemma unitCircleUnit_val (angle : ℝ) :
    (unitCircleUnit angle : ℂ) = Complex.exp ((angle : ℂ) * Complex.I) := rfl

@[simp] private lemma evalLaurentOnUnitCircle_toLaurent
    (p : ℂ[X]) (angle : ℝ) :
    evalLaurentOnUnitCircle p.toLaurent angle =
      p.eval (Complex.exp ((angle : ℂ) * Complex.I)) := by
  simp [evalLaurentOnUnitCircle, Polynomial.eval₂_id]

private lemma unitCircleArc_infinite :
    ((Complex.exp ∘ fun angle : ℝ => (angle : ℂ) * Complex.I) ''
      Set.Icc 0 Real.pi).Infinite := by
  have interval_infinite : (Set.Icc (0 : ℝ) Real.pi).Infinite := Set.Icc_infinite Real.pi_pos
  apply interval_infinite.image
  intro x hx y hy hxy
  apply Circle.exp_injOn_Icc (a := 0) (b := Real.pi) (by nlinarith [Real.pi_pos]) hx hy
  apply Subtype.ext
  simpa [Function.comp_apply, Circle.coe_exp] using hxy

private theorem evalLaurentOnUnitCircle_twoBandLaurentRadicand
    (gap hopping angle : ℝ) :
    evalLaurentOnUnitCircle (twoBandLaurentRadicand gap hopping) angle =
      ((gap ^ 2 + 4 * hopping ^ 2 * Real.cos (angle / 2) ^ 2 : ℝ) : ℂ) := by
  simp [evalLaurentOnUnitCircle, twoBandLaurentRadicand, unitCircleUnit]
  rw [← Complex.exp_neg]
  have neg_mul_I : -(angle : ℂ) * Complex.I = -((angle : ℂ) * Complex.I) := by ring
  rw [← neg_mul_I, Complex.exp_mul_I, Complex.exp_mul_I]
  rw [Complex.cos_neg, Complex.sin_neg]
  simp only [neg_mul]
  rw [show (angle : ℂ) / 2 = ((angle / 2 : ℝ) : ℂ) by norm_num]
  rw [← Complex.ofReal_cos]
  norm_cast
  rw [Real.cos_sq]
  push_cast
  ring_nf

/-- `BG-PROJECTION-THM-003`: equality of complex Laurent polynomials on the whole
unit circle implies equality in the Laurent ring. -/
theorem evalLaurentOnUnitCircle_injective :
    Function.Injective (fun f : LaurentPolynomial ℂ =>
      evalLaurentOnUnitCircle f) := by
  intro f g hfg
  suffices f - g = 0 by exact sub_eq_zero.mp this
  let q := f - g
  have hq_eval : ∀ angle : ℝ, evalLaurentOnUnitCircle q angle = 0 := by
    intro angle
    simp only [q, evalLaurentOnUnitCircle, map_sub]
    exact sub_eq_zero.mpr (congr_fun hfg angle)
  obtain ⟨n, p, hp⟩ := LaurentPolynomial.exists_T_pow q
  have roots_infinite : {z : ℂ | p.IsRoot z}.Infinite := by
    apply unitCircleArc_infinite.mono
    rintro z ⟨angle, angle_mem, rfl⟩
    change p.eval _ = 0
    have evaluated_product := congrArg
      (fun polynomial => evalLaurentOnUnitCircle polynomial angle) hp
    rw [evalLaurentOnUnitCircle_toLaurent] at evaluated_product
    simp only [evalLaurentOnUnitCircle, map_mul,
      LaurentPolynomial.eval₂_T] at evaluated_product
    change p.eval (Complex.exp ((angle : ℂ) * Complex.I)) =
      evalLaurentOnUnitCircle q angle *
        ((unitCircleUnit angle) ^ (n : ℤ) : ℂˣ).val at evaluated_product
    rw [hq_eval, zero_mul] at evaluated_product
    simpa [Function.comp_apply] using evaluated_product
  have p_eq_zero := Polynomial.eq_zero_of_infinite_isRoot p roots_infinite
  rw [p_eq_zero, map_zero] at hp
  change q = 0
  exact (mul_eq_zero.mp hp.symm).resolve_right
    (LaurentPolynomial.isUnit_T (R := ℂ) n).ne_zero


/-- `BG-PROJECTION-DEF-005`: a scalar circle function has finite Fourier support when it
is represented by a complex Laurent polynomial under the frozen unit-circle convention. -/
def HasFiniteFourierSupport (function : ℝ → ℂ) : Prop :=
  ∃ f : LaurentPolynomial ℂ, evalLaurentOnUnitCircle f = function

/-- `BG-PROJECTION-DEF-006`: the positive two-band dispersion from the source example. -/
noncomputable def twoBandDispersion (gap hopping angle : ℝ) : ℝ :=
  Real.sqrt (gap ^ 2 + 4 * hopping ^ 2 * Real.cos (angle / 2) ^ 2)

private lemma twoBandDispersion_sq (gap hopping angle : ℝ) :
    twoBandDispersion gap hopping angle ^ 2 =
      gap ^ 2 + 4 * hopping ^ 2 * Real.cos (angle / 2) ^ 2 := by
  apply Real.sq_sqrt
  positivity

/-- `BG-PROJECTION-THM-004`: under `Δt ≠ 0`, the positive dispersion cannot have
finite Fourier support. -/
theorem twoBandDispersion_not_hasFiniteFourierSupport
    (gap hopping : ℝ) (gap_mul_hopping_ne : gap * hopping ≠ 0) :
    ¬ HasFiniteFourierSupport
      (fun angle => (twoBandDispersion gap hopping angle : ℂ)) := by
  rintro ⟨f, f_represents_dispersion⟩
  apply twoBandLaurentRadicand_not_sq gap hopping gap_mul_hopping_ne
  refine ⟨f, evalLaurentOnUnitCircle_injective ?_⟩
  funext angle
  simp only [evalLaurentOnUnitCircle, map_pow]
  change evalLaurentOnUnitCircle f angle ^ 2 =
    evalLaurentOnUnitCircle (twoBandLaurentRadicand gap hopping) angle
  rw [congr_fun f_represents_dispersion angle]
  rw [evalLaurentOnUnitCircle_twoBandLaurentRadicand]
  norm_cast
  exact twoBandDispersion_sq gap hopping angle


/-- `BG-PROJECTION-DEF-007`: entrywise unit-circle evaluation of a rank-two
Laurent-polynomial matrix. -/
noncomputable def evalLaurentMatrixOnUnitCircle
    (matrix : Matrix (Fin 2) (Fin 2) (LaurentPolynomial ℂ))
    (angle : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun row column => evalLaurentOnUnitCircle (matrix row column) angle

@[simp] private lemma evalLaurentMatrixOnUnitCircle_mul
    (left right : Matrix (Fin 2) (Fin 2) (LaurentPolynomial ℂ))
    (angle : ℝ) :
    evalLaurentMatrixOnUnitCircle (left * right) angle =
      evalLaurentMatrixOnUnitCircle left angle *
        evalLaurentMatrixOnUnitCircle right angle := by
  ext row column
  simp [evalLaurentMatrixOnUnitCircle, Matrix.mul_apply,
    evalLaurentOnUnitCircle]

@[simp] private lemma evalLaurentMatrixOnUnitCircle_one (angle : ℝ) :
    evalLaurentMatrixOnUnitCircle
        (1 : Matrix (Fin 2) (Fin 2) (LaurentPolynomial ℂ)) angle = 1 := by
  ext row column
  simp [evalLaurentMatrixOnUnitCircle, evalLaurentOnUnitCircle,
    Matrix.one_apply]

@[simp] private lemma evalLaurentMatrixOnUnitCircle_smul
    (scalar : LaurentPolynomial ℂ)
    (matrix : Matrix (Fin 2) (Fin 2) (LaurentPolynomial ℂ))
    (angle : ℝ) :
    evalLaurentMatrixOnUnitCircle (scalar • matrix) angle =
      evalLaurentOnUnitCircle scalar angle •
        evalLaurentMatrixOnUnitCircle matrix angle := by
  ext row column
  simp [evalLaurentMatrixOnUnitCircle, evalLaurentOnUnitCircle]

/-- `BG-PROJECTION-DEF-008`: a rank-two matrix circle function has finite Fourier support
when one Laurent-polynomial matrix represents it entrywise. -/
def HasFiniteMatrixFourierSupport
    (function : ℝ → Matrix (Fin 2) (Fin 2) ℂ) : Prop :=
  ∃ matrix : Matrix (Fin 2) (Fin 2) (LaurentPolynomial ℂ),
    evalLaurentMatrixOnUnitCircle matrix = function

/-- `BG-PROJECTION-DEF-009`: unit-circle evaluation of the nearest-neighbor Laurent
parent. -/
noncomputable def twoBandParentOnUnitCircle
    (gap hopping angle : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  evalLaurentMatrixOnUnitCircle
    (twoBandParentLaurentMatrix gap hopping) angle

private lemma twoBandParentOnUnitCircle_sq (gap hopping angle : ℝ) :
    twoBandParentOnUnitCircle gap hopping angle *
        twoBandParentOnUnitCircle gap hopping angle =
      (twoBandDispersion gap hopping angle : ℂ) ^ 2 • 1 := by
  have mapped := congrArg
    (fun matrix => evalLaurentMatrixOnUnitCircle matrix angle)
    (twoBandParentLaurentMatrix_sq gap hopping)
  simp only [evalLaurentMatrixOnUnitCircle_mul,
    evalLaurentMatrixOnUnitCircle_smul,
    evalLaurentMatrixOnUnitCircle_one] at mapped
  rw [evalLaurentOnUnitCircle_twoBandLaurentRadicand] at mapped
  have dispersion_sq_complex :
      (twoBandDispersion gap hopping angle : ℂ) ^ 2 =
        ((gap ^ 2 + 4 * hopping ^ 2 * Real.cos (angle / 2) ^ 2 : ℝ) : ℂ) := by
    norm_cast
    exact twoBandDispersion_sq gap hopping angle
  simpa [twoBandParentOnUnitCircle, dispersion_sq_complex] using mapped

/-- `BG-PROJECTION-DEF-010`: the embedded lower-band operator `(H - dI)/2` in the
source identity. -/
noncomputable def twoBandProjectedOperator
    (gap hopping angle : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (2 : ℂ)⁻¹ •
    (twoBandParentOnUnitCircle gap hopping angle -
      (twoBandDispersion gap hopping angle : ℂ) • 1)

private lemma twoBandDispersion_pos
    (gap hopping angle : ℝ) (gap_ne : gap ≠ 0) :
    0 < twoBandDispersion gap hopping angle := by
  rw [twoBandDispersion, Real.sqrt_pos]
  have gap_sq_pos : 0 < gap ^ 2 := sq_pos_of_ne_zero gap_ne
  positivity

/-- `BG-PROJECTION-DEF-011`: the algebraic lower-band projector `(I - H/d)/2` for the
two-band parent. -/
noncomputable def twoBandLowerBandProjector
    (gap hopping angle : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (2 : ℂ)⁻¹ •
    (1 - (twoBandDispersion gap hopping angle : ℂ)⁻¹ •
      twoBandParentOnUnitCircle gap hopping angle)

private lemma projector_idempotent
    (operator : Matrix (Fin 2) (Fin 2) ℂ) (dispersion : ℂ)
    (dispersion_ne : dispersion ≠ 0)
    (operator_sq : operator * operator =
      dispersion ^ 2 • (1 : Matrix (Fin 2) (Fin 2) ℂ)) :
    let projector := (2 : ℂ)⁻¹ • (1 - dispersion⁻¹ • operator)
    projector * projector = projector := by
  dsimp
  rw [Matrix.smul_mul, Matrix.mul_smul]
  rw [sub_mul, one_mul, Matrix.smul_mul]
  rw [mul_sub, mul_one, Matrix.mul_smul]
  rw [operator_sq]
  simp only [smul_smul]
  ext row column
  simp [Matrix.smul_apply, Matrix.sub_apply, smul_eq_mul]
  field_simp
  ring

private lemma projector_lower_eigenrelation
    (operator : Matrix (Fin 2) (Fin 2) ℂ) (dispersion : ℂ)
    (dispersion_ne : dispersion ≠ 0)
    (operator_sq : operator * operator =
      dispersion ^ 2 • (1 : Matrix (Fin 2) (Fin 2) ℂ)) :
    let projector := (2 : ℂ)⁻¹ • (1 - dispersion⁻¹ • operator)
    operator * projector = (-dispersion) • projector := by
  dsimp
  rw [Matrix.mul_smul, mul_sub, mul_one, Matrix.mul_smul, operator_sq]
  simp only [smul_smul]
  ext row column
  simp [Matrix.smul_apply, Matrix.sub_apply, smul_eq_mul]
  field_simp
  ring

private lemma projector_sandwich_eq
    (operator : Matrix (Fin 2) (Fin 2) ℂ) (dispersion : ℂ)
    (dispersion_ne : dispersion ≠ 0)
    (operator_sq : operator * operator =
      dispersion ^ 2 • (1 : Matrix (Fin 2) (Fin 2) ℂ)) :
    let projector := (2 : ℂ)⁻¹ • (1 - dispersion⁻¹ • operator)
    projector * operator * projector =
      (2 : ℂ)⁻¹ • (operator - dispersion • 1) := by
  dsimp
  rw [Matrix.smul_mul, Matrix.mul_smul, Matrix.smul_mul]
  rw [sub_mul, one_mul, Matrix.smul_mul, operator_sq]
  rw [mul_sub, mul_one, Matrix.mul_smul]
  rw [sub_mul, operator_sq, Matrix.smul_mul]
  simp only [smul_smul]
  ext row column
  simp [Matrix.smul_apply, Matrix.sub_apply, smul_eq_mul]
  field_simp
  ring

/-- `BG-PROJECTION-THM-005`: the source projector formula is idempotent and its range
lies in the `-d` eigenspace of the parent. -/
theorem twoBandLowerBandProjector_specification
    (gap hopping angle : ℝ) (gap_mul_hopping_ne : gap * hopping ≠ 0) :
    twoBandLowerBandProjector gap hopping angle *
        twoBandLowerBandProjector gap hopping angle =
      twoBandLowerBandProjector gap hopping angle ∧
    twoBandParentOnUnitCircle gap hopping angle *
        twoBandLowerBandProjector gap hopping angle =
      (-(twoBandDispersion gap hopping angle : ℂ)) •
        twoBandLowerBandProjector gap hopping angle := by
  have gap_ne : gap ≠ 0 := (mul_ne_zero_iff.mp gap_mul_hopping_ne).1
  have dispersion_ne :
      (twoBandDispersion gap hopping angle : ℂ) ≠ 0 := by
    exact_mod_cast (twoBandDispersion_pos gap hopping angle gap_ne).ne'
  constructor
  · exact projector_idempotent
      (twoBandParentOnUnitCircle gap hopping angle)
      (twoBandDispersion gap hopping angle : ℂ)
      dispersion_ne (twoBandParentOnUnitCircle_sq gap hopping angle)
  · exact projector_lower_eigenrelation
      (twoBandParentOnUnitCircle gap hopping angle)
      (twoBandDispersion gap hopping angle : ℂ)
      dispersion_ne (twoBandParentOnUnitCircle_sq gap hopping angle)

/-- `BG-PROJECTION-THM-006`: the source lower-band projector sandwich equals
`(H - dI)/2`. -/
theorem twoBandLowerBandProjector_sandwich
    (gap hopping angle : ℝ) (gap_mul_hopping_ne : gap * hopping ≠ 0) :
    twoBandLowerBandProjector gap hopping angle *
        twoBandParentOnUnitCircle gap hopping angle *
          twoBandLowerBandProjector gap hopping angle =
      twoBandProjectedOperator gap hopping angle := by
  have gap_ne : gap ≠ 0 := (mul_ne_zero_iff.mp gap_mul_hopping_ne).1
  have dispersion_ne :
      (twoBandDispersion gap hopping angle : ℂ) ≠ 0 := by
    exact_mod_cast (twoBandDispersion_pos gap hopping angle gap_ne).ne'
  exact projector_sandwich_eq
    (twoBandParentOnUnitCircle gap hopping angle)
    (twoBandDispersion gap hopping angle : ℂ)
    dispersion_ne (twoBandParentOnUnitCircle_sq gap hopping angle)

/-- `BG-PROJECTION-THM-007`: under `Δt ≠ 0`, the embedded lower-band operator has
no finite matrix Fourier support. -/
theorem twoBandProjectedOperator_not_hasFiniteMatrixFourierSupport
    (gap hopping : ℝ) (gap_mul_hopping_ne : gap * hopping ≠ 0) :
    ¬ HasFiniteMatrixFourierSupport
      (twoBandProjectedOperator gap hopping) := by
  rintro ⟨matrix, matrix_represents_projected⟩
  apply twoBandDispersion_not_hasFiniteFourierSupport
    gap hopping gap_mul_hopping_ne
  refine ⟨LaurentPolynomial.C (gap : ℂ) -
    LaurentPolynomial.C (2 : ℂ) * matrix 0 0, ?_⟩
  funext angle
  have entry_equality := congrArg (fun value => value 0 0)
    (congr_fun matrix_represents_projected angle)
  simp [evalLaurentOnUnitCircle, evalLaurentMatrixOnUnitCircle,
    twoBandProjectedOperator, twoBandParentOnUnitCircle,
    twoBandParentLaurentMatrix] at entry_equality ⊢
  linear_combination -2 * entry_equality

/-- `BG-PROJECTION-THM-008`: spectral projection can destroy finite hopping support:
the source parent is a Laurent-polynomial matrix, while its lower-band projector sandwich
is not. -/
theorem spectralProjection_can_destroy_finite_hopping_support
    (gap hopping : ℝ) (gap_mul_hopping_ne : gap * hopping ≠ 0) :
    HasFiniteMatrixFourierSupport
        (twoBandParentOnUnitCircle gap hopping) ∧
      ¬ HasFiniteMatrixFourierSupport
        (fun angle =>
          twoBandLowerBandProjector gap hopping angle *
            twoBandParentOnUnitCircle gap hopping angle *
              twoBandLowerBandProjector gap hopping angle) := by
  constructor
  · exact ⟨twoBandParentLaurentMatrix gap hopping, rfl⟩
  · have sandwich_eq :
        (fun angle =>
          twoBandLowerBandProjector gap hopping angle *
            twoBandParentOnUnitCircle gap hopping angle *
              twoBandLowerBandProjector gap hopping angle) =
          twoBandProjectedOperator gap hopping := by
      funext angle
      exact twoBandLowerBandProjector_sandwich
        gap hopping angle gap_mul_hopping_ne
    rw [sandwich_eq]
    exact twoBandProjectedOperator_not_hasFiniteMatrixFourierSupport
      gap hopping gap_mul_hopping_ne

end ProjectKoios.BandGauge.Projection

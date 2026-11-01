/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.BandGauge.Alignment.FiniteFrame

/-!
# Finite gauge-alignment identity and metric-isometry contracts

This module separates the gauge-group family, represented finite dimension, action side, and
inner-product convention used by a finite alignment contract. The represented dimension is derived
from the retained index type rather than stored as unrelated metadata.

The currently supported family is unitary and the currently implemented frame action is the
Euclidean right action. Frame orthonormality remains a separate predicate on concrete frames.
`IsMetricUnitary` records the exact equation needed by a future positive-definite metric formulation
without claiming that a metric-aware adjoint, Procrustes objective, optimizer, or runtime verifier
exists.

For the column-frame convention in `FiniteFrame.lean`, a retained-space gauge acts from the right.
A left action would require a separately typed frame convention or an ambient-space action; the
`left` constructor below records the owner-side vocabulary but does not silently choose either
meaning.
-/

@[expose] public section

open scoped ComplexConjugate Matrix

namespace ProjectKoios.BandGauge.Alignment

/-- `BG-ALIGNMENT-DEF-030`: closed family vocabulary for finite gauge transformations.

Only the unitary family is currently supported. Orthogonal, special-unitary, and other constraints
must be introduced as new formal contracts rather than accepted as free-form labels. -/
inductive GaugeGroupFamily where
  | unitary
  deriving DecidableEq, Repr

/-- `BG-ALIGNMENT-DEF-031`: side on which a represented frame receives a gauge action.

This convention is independent of the gauge-group family. -/
inductive GaugeActionSide where
  | left
  | right
  deriving DecidableEq, Repr

/-- `BG-ALIGNMENT-DEF-032`: currently supported inner-product convention for gauge alignment.

This labels the standard Euclidean metric on retained coordinates. Frame orthonormality is a
separate predicate and is not implied by this metadata value. A future positive-definite metric
contract must retain its metric explicitly; it is not another `GaugeGroupFamily` constructor. -/
inductive GaugeInnerProductConvention where
  | euclidean
  deriving DecidableEq, Repr

/-- `BG-ALIGNMENT-DEF-033`: type-indexed identity of a finite gauge-alignment convention.

The retained index type supplies the represented dimension. Sample domains, pointwise-versus-global
families, numerical objectives, and acceptance rules remain separate. -/
structure FiniteGaugeAlignmentIdentity (Retained : Type*) [Fintype Retained] where
  groupFamily : GaugeGroupFamily
  actionSide : GaugeActionSide
  innerProductConvention : GaugeInnerProductConvention

/-- `BG-ALIGNMENT-DEF-034`: represented finite dimension derived from the retained index type. -/
def FiniteGaugeAlignmentIdentity.representedDimension
    {Retained : Type*} [Fintype Retained]
    (_ : FiniteGaugeAlignmentIdentity Retained) : ℕ :=
  Fintype.card Retained

/-- `BG-ALIGNMENT-DEF-035`: the convention implemented by the existing finite-frame and
right-unitary Procrustes modules. -/
def euclideanRightUnitaryIdentity (Retained : Type*) [Fintype Retained] :
    FiniteGaugeAlignmentIdentity Retained where
  groupFamily := .unitary
  actionSide := .right
  innerProductConvention := .euclidean

/-- `BG-ALIGNMENT-DEF-036`: exact metric-isometry equation `gaugeᴴ * metric * gauge = metric`.

Positive-definiteness of `metric`, the corresponding metric adjoint, and any alignment objective
are deliberately separate hypotheses or future definitions. -/
def IsMetricUnitary
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (metric gauge : Matrix Retained Retained ℂ) : Prop :=
  gaugeᴴ * metric * gauge = metric

/-- `BG-ALIGNMENT-DEF-037`: represented-operator conjugation induced by the current right action.

This is the exact Euclidean compressed-form formula. It does not assert frame orthonormality and
does not by itself define the coordinate-endomorphism law for a nonorthonormal basis. -/
def rightGaugeConjugate
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge operator : Matrix Retained Retained ℂ) : Matrix Retained Retained ℂ :=
  gaugeᴴ * operator * gauge

/-- `BG-ALIGNMENT-THM-059`: on the canonical `Fin rank` carrier, the represented dimension is
exactly `rank`. -/
theorem euclideanRightUnitaryIdentity_representedDimension (rank : ℕ) :
    (euclideanRightUnitaryIdentity (Fin rank)).representedDimension = rank := by
  simp [FiniteGaugeAlignmentIdentity.representedDimension]

/-- `BG-ALIGNMENT-THM-060`: every ordinary finite complex unitary preserves the identity metric. -/
theorem unitary_isMetricUnitary_identity
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    IsMetricUnitary (1 : Matrix Retained Retained ℂ)
      (gauge : Matrix Retained Retained ℂ) := by
  rw [IsMetricUnitary, Matrix.mul_one]
  simpa only [Matrix.star_eq_conjTranspose] using
    Matrix.mem_unitaryGroup_iff'.mp gauge.property

/-- `BG-ALIGNMENT-THM-061`: the existing compressed-operator covariance theorem has exactly the
named right-action conjugation form. -/
theorem compressOperator_rightUnitaryFrame_eq_rightGaugeConjugate
    {Ambient Retained : Type*}
    [Fintype Ambient] [DecidableEq Ambient]
    [Fintype Retained] [DecidableEq Retained]
    (frame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ) :
    compressOperator (rightUnitaryFrame frame gauge) operator =
      rightGaugeConjugate (gauge : Matrix Retained Retained ℂ)
        (compressOperator frame operator) := by
  exact compressOperator_rightUnitaryFrame frame gauge operator

/-- `BG-ALIGNMENT-THM-062`: the identity gauge preserves every finite metric matrix. -/
theorem identity_isMetricUnitary
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (metric : Matrix Retained Retained ℂ) :
    IsMetricUnitary metric (1 : Matrix Retained Retained ℂ) := by
  simp [IsMetricUnitary]

/-- `BG-ALIGNMENT-THM-063`: metric-unitary gauges are closed under multiplication. -/
theorem IsMetricUnitary.mul
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    {metric first second : Matrix Retained Retained ℂ}
    (hfirst : IsMetricUnitary metric first)
    (hsecond : IsMetricUnitary metric second) :
    IsMetricUnitary metric (first * second) := by
  rw [IsMetricUnitary] at hfirst hsecond ⊢
  rw [Matrix.conjTranspose_mul]
  calc
    secondᴴ * firstᴴ * metric * (first * second) =
        secondᴴ * (firstᴴ * metric * first) * second := by
      simp only [Matrix.mul_assoc]
    _ = secondᴴ * metric * second := by rw [hfirst]
    _ = metric := hsecond

/-- `BG-ALIGNMENT-THM-064`: the identity gauge acts trivially on represented operators. -/
theorem rightGaugeConjugate_one
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (operator : Matrix Retained Retained ℂ) :
    rightGaugeConjugate (1 : Matrix Retained Retained ℂ) operator = operator := by
  simp [rightGaugeConjugate]

/-- `BG-ALIGNMENT-THM-065`: successive right-gauge conjugations compose in right-action order. -/
theorem rightGaugeConjugate_mul
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (first second operator : Matrix Retained Retained ℂ) :
    rightGaugeConjugate second (rightGaugeConjugate first operator) =
      rightGaugeConjugate (first * second) operator := by
  simp only [rightGaugeConjugate, Matrix.conjTranspose_mul]
  simp only [Matrix.mul_assoc]

/-- `BG-ALIGNMENT-THM-066`: right-gauge conjugation commutes with conjugate transpose. -/
theorem rightGaugeConjugate_conjTranspose
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge operator : Matrix Retained Retained ℂ) :
    (rightGaugeConjugate gauge operator)ᴴ =
      rightGaugeConjugate gauge operatorᴴ := by
  simp only [rightGaugeConjugate, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_conjTranspose]
  simp only [Matrix.mul_assoc]

/-- `BG-ALIGNMENT-THM-067`: right-gauge conjugation preserves Hermiticity. -/
theorem rightGaugeConjugate_isHermitian
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge operator : Matrix Retained Retained ℂ)
    (hoperator : operator.IsHermitian) :
    (rightGaugeConjugate gauge operator).IsHermitian := by
  rw [Matrix.IsHermitian, rightGaugeConjugate_conjTranspose, hoperator]

end ProjectKoios.BandGauge.Alignment

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-08
-/
module

public import Mathlib.Basic.Complex.Basic
public import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
public import Mathlib.LinearAlgebra.Matrix.ConjTranspose

/-!
# Conjugate-linear coordinate algebra

This module records exact finite-dimensional coordinate formulas for maps that act as
`x ↦ M * conjugateVector x`.  Source and target coordinate types may have different finite
cardinalities; independently invertible source and target basis changes are represented by
`Matrix.GeneralLinearGroup`.

The metric-compatibility predicate is only the algebraic equation
`Mᴴ * targetMetric * M = entrywiseConjugate sourceMetric`.  It does not assert that either metric
is Hermitian or positive definite, that the coordinate action is bijective or isometric, or that
it represents an antiunitary operator.  Those interpretations require separate hypotheses.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Alignment

open scoped Matrix

/-- Coordinatewise complex conjugation of a finite coordinate vector.

Declaration ID: `BG-ALIGNMENT-DEF-050`.
-/
def conjugateVector {ι : Type*} (x : ι → ℂ) : ι → ℂ :=
  fun i => star (x i)

/-- Entrywise complex conjugation of a rectangular matrix.

Declaration ID: `BG-ALIGNMENT-DEF-051`.
-/
def entrywiseConjugate {m n : Type*} (M : Matrix m n ℂ) : Matrix m n ℂ :=
  M.map (starRingEnd ℂ)

/-- Coordinate action of the conjugate-linear matrix representative `M`.

Declaration ID: `BG-ALIGNMENT-DEF-052`.
-/
def conjugateLinearCoordinateAction {m n : Type*} [Fintype n]
    (M : Matrix m n ℂ) (x : n → ℂ) : m → ℂ :=
  M *ᵥ conjugateVector x

/-- Coordinate matrix after independently changing target and source bases:
`M' = A_t⁻¹ M conjugate(A_s)`.

Declaration ID: `BG-ALIGNMENT-DEF-053`.
-/
def conjugateLinearBasisChange {Source Target : Type*}
    [Fintype Source] [DecidableEq Source] [Fintype Target] [DecidableEq Target]
    (sourceBasis : Matrix.GeneralLinearGroup Source ℂ)
    (targetBasis : Matrix.GeneralLinearGroup Target ℂ)
    (M : Matrix Target Source ℂ) : Matrix Target Source ℂ :=
  (↑targetBasis⁻¹ : Matrix Target Target ℂ) * M *
    entrywiseConjugate (sourceBasis : Matrix Source Source ℂ)

/-- Congruence transformation of a coordinate metric, `G' = Aᴴ G A`.

Declaration ID: `BG-ALIGNMENT-DEF-054`.
-/
def metricBasisChange {ι : Type*} [Fintype ι] [DecidableEq ι]
    (basis : Matrix.GeneralLinearGroup ι ℂ) (metric : Matrix ι ι ℂ) : Matrix ι ι ℂ :=
  (basis : Matrix ι ι ℂ)ᴴ * metric * (basis : Matrix ι ι ℂ)

/-- Purely algebraic compatibility equation for a conjugate-linear matrix representative.

This definition alone carries no Hermitian, positive-definite, bijective, isometric, or
antiunitary interpretation.

Declaration ID: `BG-ALIGNMENT-DEF-055`.
-/
def IsConjugateLinearMetricCompatible {Source Target : Type*}
    [Fintype Source] [Fintype Target]
    (sourceMetric : Matrix Source Source ℂ)
    (targetMetric : Matrix Target Target ℂ)
    (M : Matrix Target Source ℂ) : Prop :=
  Mᴴ * targetMetric * M = entrywiseConjugate sourceMetric

/-- Separate predicate for bijectivity of the conjugate-linear coordinate action.

Metric compatibility does not imply this predicate without additional hypotheses.

Declaration ID: `BG-ALIGNMENT-DEF-056`.
-/
def IsBijectiveConjugateLinearCoordinateAction {Source Target : Type*} [Fintype Source]
    (M : Matrix Target Source ℂ) : Prop :=
  Function.Bijective (conjugateLinearCoordinateAction M)

/-- Coordinatewise complex conjugation is involutive.

Declaration ID: `BG-ALIGNMENT-LEM-012`.
-/
lemma conjugateVector_conjugateVector {ι : Type*} (x : ι → ℂ) :
    conjugateVector (conjugateVector x) = x := by
  funext i
  simp [conjugateVector]

/-- Entrywise matrix conjugation acts on conjugated vectors by conjugating the original action.

Declaration ID: `BG-ALIGNMENT-LEM-013`.
-/
lemma entrywiseConjugate_mulVec_conjugateVector {Source Target : Type*} [Fintype Source]
    (M : Matrix Target Source ℂ) (x : Source → ℂ) :
    entrywiseConjugate M *ᵥ conjugateVector x = conjugateVector (M *ᵥ x) := by
  funext i
  change (M.map (starRingEnd ℂ) *ᵥ (fun j => star (x j))) i =
    star ((M *ᵥ x) i)
  exact (RingHom.map_mulVec (starRingEnd ℂ) M x i).symm

/-- The conjugate-linear basis-change matrix has the expected coordinate action.

Declaration ID: `BG-ALIGNMENT-LEM-014`.
-/
lemma conjugateLinearBasisChange_action {Source Target : Type*}
    [Fintype Source] [DecidableEq Source] [Fintype Target] [DecidableEq Target]
    (sourceBasis : Matrix.GeneralLinearGroup Source ℂ)
    (targetBasis : Matrix.GeneralLinearGroup Target ℂ)
    (M : Matrix Target Source ℂ) (x : Source → ℂ) :
    conjugateLinearCoordinateAction
        (conjugateLinearBasisChange sourceBasis targetBasis M) x =
      (↑targetBasis⁻¹ : Matrix Target Target ℂ) *ᵥ
        (conjugateLinearCoordinateAction M
          ((sourceBasis : Matrix Source Source ℂ) *ᵥ x)) := by
  rw [conjugateLinearCoordinateAction, conjugateLinearBasisChange,
    ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
    entrywiseConjugate_mulVec_conjugateVector]
  rfl

/-- Conjugating a conjugate transpose entrywise leaves the transpose.

Declaration ID: `BG-ALIGNMENT-LEM-015`.
-/
lemma entrywiseConjugate_conjTranspose {m n : Type*} (M : Matrix m n ℂ) :
    entrywiseConjugate Mᴴ = Mᵀ := by
  ext i j
  simp [entrywiseConjugate]

/-- Entrywise complex conjugation preserves matrix multiplication.

Declaration ID: `BG-ALIGNMENT-LEM-016`.
-/
lemma entrywiseConjugate_mul {m n o : Type*} [Fintype n]
    (M : Matrix m n ℂ) (N : Matrix n o ℂ) :
    entrywiseConjugate (M * N) = entrywiseConjugate M * entrywiseConjugate N := by
  exact Matrix.map_mul

/-- Entrywise conjugation of a congruence-transformed metric.

Declaration ID: `BG-ALIGNMENT-LEM-017`.
-/
lemma entrywiseConjugate_metricBasisChange {ι : Type*} [Fintype ι] [DecidableEq ι]
    (basis : Matrix.GeneralLinearGroup ι ℂ) (metric : Matrix ι ι ℂ) :
    entrywiseConjugate (metricBasisChange basis metric) =
      (basis : Matrix ι ι ℂ)ᵀ * entrywiseConjugate metric *
        entrywiseConjugate (basis : Matrix ι ι ℂ) := by
  rw [metricBasisChange]
  simp only [entrywiseConjugate, Matrix.map_mul]
  rw [show (basis : Matrix ι ι ℂ)ᴴ.map (starRingEnd ℂ) =
      (basis : Matrix ι ι ℂ)ᵀ by
    ext i j
    simp]

/-- The algebraic conjugate-linear metric equation is preserved by independent invertible source
and target basis changes.

No Hermitian, positivity, bijectivity, norm, isometry, or antiunitary premise is used.

Declaration ID: `BG-ALIGNMENT-LEM-018`.
-/
lemma conjugateLinearBasisChange_metricCompatible {Source Target : Type*}
    [Fintype Source] [DecidableEq Source] [Fintype Target] [DecidableEq Target]
    (sourceBasis : Matrix.GeneralLinearGroup Source ℂ)
    (targetBasis : Matrix.GeneralLinearGroup Target ℂ)
    (sourceMetric : Matrix Source Source ℂ)
    (targetMetric : Matrix Target Target ℂ)
    (M : Matrix Target Source ℂ)
    (hM : IsConjugateLinearMetricCompatible sourceMetric targetMetric M) :
    IsConjugateLinearMetricCompatible
      (metricBasisChange sourceBasis sourceMetric)
      (metricBasisChange targetBasis targetMetric)
      (conjugateLinearBasisChange sourceBasis targetBasis M) := by
  let As : Matrix Source Source ℂ := sourceBasis
  let At : Matrix Target Target ℂ := targetBasis
  let AtInv : Matrix Target Target ℂ := ↑targetBasis⁻¹
  let barAs : Matrix Source Source ℂ := entrywiseConjugate As
  have hleft (B : Matrix Target Source ℂ) :
      AtInvᴴ * (Atᴴ * B) = B := by
    rw [← Matrix.mul_assoc, ← Matrix.conjTranspose_mul]
    simp [At, AtInv]
  have hright (B : Matrix Target Source ℂ) :
      At * (AtInv * B) = B := by
    rw [← Matrix.mul_assoc]
    simp [At, AtInv]
  rw [IsConjugateLinearMetricCompatible] at hM ⊢
  change (AtInv * M * barAs)ᴴ * (Atᴴ * targetMetric * At) *
      (AtInv * M * barAs) = entrywiseConjugate (Asᴴ * sourceMetric * As)
  simp only [Matrix.conjTranspose_mul]
  rw [show barAsᴴ = Asᵀ by
    dsimp [barAs]
    exact entrywiseConjugate_conjTranspose As]
  simp only [Matrix.mul_assoc]
  rw [hleft, hright]
  rw [← Matrix.mul_assoc targetMetric M barAs]
  rw [← Matrix.mul_assoc Mᴴ (targetMetric * M) barAs]
  rw [← Matrix.mul_assoc Mᴴ targetMetric M, hM]
  simpa [As, barAs, metricBasisChange, Matrix.mul_assoc] using
    (entrywiseConjugate_metricBasisChange sourceBasis sourceMetric).symm

/-- Two conjugate-linear coordinate actions compose to the linear matrix product
`M * entrywiseConjugate N`.

The source, middle, and target coordinate types are independent.

Declaration ID: `BG-ALIGNMENT-LEM-019`.
-/
lemma conjugateLinearCoordinateAction_comp {Source Middle Target : Type*}
    [Fintype Source] [Fintype Middle]
    (M : Matrix Target Middle ℂ) (N : Matrix Middle Source ℂ) (x : Source → ℂ) :
    conjugateLinearCoordinateAction M (conjugateLinearCoordinateAction N x) =
      (M * entrywiseConjugate N) *ᵥ x := by
  rw [conjugateLinearCoordinateAction, conjugateLinearCoordinateAction]
  rw [← entrywiseConjugate_mulVec_conjugateVector]
  rw [conjugateVector_conjugateVector, Matrix.mulVec_mulVec]

end ProjectKoios.BandGauge.Alignment

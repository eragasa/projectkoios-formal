/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.InnerProductSpace.Basic
public import Mathlib.Analysis.SpecialFunctions.Complex.Arg
public import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Exact finite gauge-loop algebra

This module defines ordered link products on finite vertex lists. Under the pointwise gauge action

`L(x,y) ↦ g(x)⁻¹ L(x,y) g(y)`,

internal vertex factors cancel. An open product transforms at its two endpoints, while a closed
product transforms by conjugation at its chosen base vertex. Closed products are therefore exactly
invariant in a commutative monoid. Four-edge plaquettes are exposed as a named specialization.

For complex Hilbert-space states, Mathlib's inner product is conjugate-linear in its first
argument. Unit-modulus pointwise phase changes consequently induce the scalar link gauge action,
so finite Bargmann products and their principal arguments are invariant. For matrix-valued links,
a unitary frame change conjugates the Wilson product and preserves its determinant.

The results are finite exact algebra. They do not construct overlap matrices from runtime arrays,
choose loop orientation or boundary sewing, unwrap phase branches, establish Chern integrality or
continuum topology, execute Wannier90, validate a numerical mesh, or establish physical
applicability.
-/

@[expose] public section

open InnerProductSpace

namespace ProjectKoios.SolidState.FiniteLattice

universe u v w

section OrderedProducts

variable {V : Type u} {M : Type v} [Monoid M]

/-- `SS-GAUGE-DEF-001`: terminal vertex of a path represented by a start vertex and an ordered
list of subsequently visited vertices. -/
def pathEndpoint (start : V) : List V → V
  | [] => start
  | next :: rest => pathEndpoint next rest

/-- `SS-GAUGE-DEF-002`: ordered product of directed link values along a finite path. -/
def orderedLinkProduct (link : V → V → M) (start : V) : List V → M
  | [] => 1
  | next :: rest => link start next * orderedLinkProduct link next rest

/-- `SS-GAUGE-DEF-003`: pointwise gauge action on a directed link. Gauge values are units of the
link-value monoid, while link values themselves need not be invertible. -/
def gaugeTransformLink (gauge : V → Mˣ) (link : V → V → M) (x y : V) : M :=
  (↑((gauge x)⁻¹) : M) * link x y * ↑(gauge y)

/-- `SS-GAUGE-DEF-004`: ordered path product followed by the closing link back to its chosen base
vertex. The empty tail is the one-edge self-loop at `base`. -/
def closedLoopProduct (link : V → V → M) (base : V) (tail : List V) : M :=
  orderedLinkProduct link base tail * link (pathEndpoint base tail) base

/-- `SS-GAUGE-DEF-005`: the oriented four-edge loop `a → b → c → d → a`. -/
def orientedPlaquetteProduct (link : V → V → M) (a b c d : V) : M :=
  closedLoopProduct link a [b, c, d]

/-- `SS-GAUGE-THM-001`: internal pointwise gauge factors cancel in an ordered open path, leaving
only the inverse gauge at the start and the gauge at the endpoint. -/
theorem orderedLinkProduct_gaugeTransform (gauge : V → Mˣ) (link : V → V → M)
    (start : V) (tail : List V) :
    orderedLinkProduct (gaugeTransformLink gauge link) start tail =
      (↑((gauge start)⁻¹) : M) * orderedLinkProduct link start tail *
        ↑(gauge (pathEndpoint start tail)) := by
  induction tail generalizing start with
  | nil => simp [orderedLinkProduct, pathEndpoint]
  | cons next rest ih =>
      simp only [orderedLinkProduct, gaugeTransformLink, pathEndpoint]
      rw [ih]
      simp [mul_assoc]

/-- `SS-GAUGE-THM-002`: a closed ordered link product transforms by conjugation at its chosen
base vertex. No commutativity premise is used. -/
theorem closedLoopProduct_gaugeTransform (gauge : V → Mˣ) (link : V → V → M)
    (base : V) (tail : List V) :
    closedLoopProduct (gaugeTransformLink gauge link) base tail =
      (↑((gauge base)⁻¹) : M) * closedLoopProduct link base tail * ↑(gauge base) := by
  simp only [closedLoopProduct, orderedLinkProduct_gaugeTransform, gaugeTransformLink]
  simp [mul_assoc]

/-- `SS-GAUGE-THM-004`: a four-edge plaquette product transforms by conjugation at its chosen
base vertex. -/
theorem orientedPlaquetteProduct_gaugeTransform (gauge : V → Mˣ)
    (link : V → V → M) (a b c d : V) :
    orientedPlaquetteProduct (gaugeTransformLink gauge link) a b c d =
      (↑((gauge a)⁻¹) : M) * orientedPlaquetteProduct link a b c d * ↑(gauge a) := by
  exact closedLoopProduct_gaugeTransform _ _ _ _

end OrderedProducts

section Commutative

variable {V : Type u} {M : Type v} [CommMonoid M]

/-- `SS-GAUGE-THM-003`: in a commutative link-value monoid, conjugation is trivial and every
closed-loop product is pointwise-gauge invariant. -/
theorem closedLoopProduct_gaugeInvariant (gauge : V → Mˣ) (link : V → V → M)
    (base : V) (tail : List V) :
    closedLoopProduct (gaugeTransformLink gauge link) base tail =
      closedLoopProduct link base tail := by
  rw [closedLoopProduct_gaugeTransform]
  calc
    (↑((gauge base)⁻¹) : M) * closedLoopProduct link base tail * ↑(gauge base) =
        closedLoopProduct link base tail * ((↑((gauge base)⁻¹) : M) * ↑(gauge base)) := by
          ac_rfl
    _ = closedLoopProduct link base tail := by simp

/-- `SS-GAUGE-THM-005`: a scalar or other commutative four-edge plaquette product is pointwise-
gauge invariant. -/
theorem orientedPlaquetteProduct_gaugeInvariant (gauge : V → Mˣ)
    (link : V → V → M) (a b c d : V) :
    orientedPlaquetteProduct (gaugeTransformLink gauge link) a b c d =
      orientedPlaquetteProduct link a b c d := by
  exact closedLoopProduct_gaugeInvariant _ _ _ _

end Commutative

section Bargmann

variable {V : Type u} {E : Type w} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

/-- `SS-GAUGE-DEF-006`: convert a pointwise unit-modulus complex phase into the corresponding
unit of the complex multiplicative monoid. -/
def phaseGaugeUnits (phase : V → unitary ℂ) (x : V) : ℂˣ :=
  Unitary.toUnits (phase x)

/-- `SS-GAUGE-DEF-007`: pointwise unit-modulus phase change of a complex state family. -/
def phaseGaugeState (phase : V → unitary ℂ) (state : V → E) (x : V) : E :=
  (phase x : ℂ) • state x

/-- `SS-GAUGE-DEF-008`: directed overlap link using Mathlib's conjugate-linear-first complex inner
product convention. -/
def bargmannLink (state : V → E) (x y : V) : ℂ :=
  ⟪state x, state y⟫_ℂ

/-- `SS-GAUGE-DEF-009`: finite closed-loop product of consecutive state overlaps. -/
def bargmannLoopProduct (state : V → E) (base : V) (tail : List V) : ℂ :=
  closedLoopProduct (bargmannLink state) base tail

/-- `SS-GAUGE-DEF-010`: principal complex argument of the finite Bargmann loop product. At a zero
product this is Mathlib's totalized `Complex.arg`; no nonvanishing claim is inferred. -/
noncomputable def bargmannLoopPhase (state : V → E) (base : V) (tail : List V) : ℝ :=
  Complex.arg (bargmannLoopProduct state base tail)

/-- `SS-GAUGE-THM-006`: conjugation of a unit-modulus scalar equals the inverse coefficient used by
the generic link gauge action. -/
theorem star_phase_eq_gaugeUnit_inv (phase : V → unitary ℂ) (x : V) :
    star (phase x : ℂ) = (↑((phaseGaugeUnits phase x)⁻¹) : ℂ) := by
  rw [← Unitary.coe_star, Unitary.star_eq_inv]
  rfl

/-- `SS-GAUGE-THM-007`: pointwise phase changes of states induce the corresponding inverse-left,
forward-right gauge action on overlap links. -/
theorem bargmannLink_phaseGaugeState (phase : V → unitary ℂ) (state : V → E)
    (x y : V) :
    bargmannLink (phaseGaugeState phase state) x y =
      gaugeTransformLink (phaseGaugeUnits phase) (bargmannLink state) x y := by
  simp only [bargmannLink, phaseGaugeState, inner_smul_left, inner_smul_right,
    starRingEnd_apply, gaugeTransformLink, phaseGaugeUnits, Unitary.val_toUnits_apply]
  rw [star_phase_eq_gaugeUnit_inv]
  simp only [phaseGaugeUnits]
  ring

/-- `SS-GAUGE-THM-008`: every finite Bargmann loop product is invariant under independent
unit-modulus phase changes at its vertices. -/
theorem bargmannLoopProduct_phaseGaugeState (phase : V → unitary ℂ) (state : V → E)
    (base : V) (tail : List V) :
    bargmannLoopProduct (phaseGaugeState phase state) base tail =
      bargmannLoopProduct state base tail := by
  rw [bargmannLoopProduct, bargmannLoopProduct]
  have hlink : bargmannLink (phaseGaugeState phase state) =
      gaugeTransformLink (phaseGaugeUnits phase) (bargmannLink state) := by
    funext x y
    exact bargmannLink_phaseGaugeState phase state x y
  rw [hlink]
  exact closedLoopProduct_gaugeInvariant _ _ _ _

/-- `SS-GAUGE-THM-009`: the principal Bargmann loop phase is invariant under independent
unit-modulus phase changes at its vertices. -/
theorem bargmannLoopPhase_phaseGaugeState (phase : V → unitary ℂ) (state : V → E)
    (base : V) (tail : List V) :
    bargmannLoopPhase (phaseGaugeState phase state) base tail =
      bargmannLoopPhase state base tail := by
  simp only [bargmannLoopPhase, bargmannLoopProduct_phaseGaugeState]

end Bargmann

section MatrixWilson

variable {V : Type u} {ι : Type v} [Fintype ι] [DecidableEq ι]

/-- `SS-GAUGE-DEF-011`: convert a pointwise unitary matrix frame into units of the matrix monoid. -/
def unitaryMatrixGaugeUnits (gauge : V → Matrix.unitaryGroup ι ℂ)
    (x : V) : (Matrix ι ι ℂ)ˣ :=
  Unitary.toUnits (gauge x)

/-- `SS-GAUGE-DEF-012`: ordered closed-loop product of finite square complex link matrices. The
individual link matrices need not be invertible. -/
def wilsonLoopProduct (link : V → V → Matrix ι ι ℂ) (base : V)
    (tail : List V) : Matrix ι ι ℂ :=
  closedLoopProduct link base tail

/-- `SS-GAUGE-THM-010`: a matrix Wilson product under a pointwise unitary frame change is
conjugated by the unitary frame at its chosen base vertex. -/
theorem wilsonLoopProduct_unitaryGaugeTransform
    (gauge : V → Matrix.unitaryGroup ι ℂ) (link : V → V → Matrix ι ι ℂ)
    (base : V) (tail : List V) :
    wilsonLoopProduct
        (gaugeTransformLink (unitaryMatrixGaugeUnits gauge) link) base tail =
      (↑((unitaryMatrixGaugeUnits gauge base)⁻¹) : Matrix ι ι ℂ) *
        wilsonLoopProduct link base tail *
          (↑(unitaryMatrixGaugeUnits gauge base) : Matrix ι ι ℂ) := by
  exact closedLoopProduct_gaugeTransform _ _ _ _

/-- `SS-GAUGE-THM-011`: the determinant of a finite matrix Wilson product is invariant under a
pointwise unitary frame change. -/
theorem wilsonLoopDet_unitaryGaugeInvariant
    (gauge : V → Matrix.unitaryGroup ι ℂ) (link : V → V → Matrix ι ι ℂ)
    (base : V) (tail : List V) :
    Matrix.det (wilsonLoopProduct
        (gaugeTransformLink (unitaryMatrixGaugeUnits gauge) link) base tail) =
      Matrix.det (wilsonLoopProduct link base tail) := by
  rw [wilsonLoopProduct_unitaryGaugeTransform]
  rw [Matrix.det_mul, Matrix.det_mul]
  have hdet :
      Matrix.det (↑((unitaryMatrixGaugeUnits gauge base)⁻¹) : Matrix ι ι ℂ) *
          Matrix.det (↑(unitaryMatrixGaugeUnits gauge base) : Matrix ι ι ℂ) = 1 := by
    rw [← Matrix.det_mul]
    simp
  calc
    Matrix.det (↑((unitaryMatrixGaugeUnits gauge base)⁻¹) : Matrix ι ι ℂ) *
          Matrix.det (wilsonLoopProduct link base tail) *
          Matrix.det (↑(unitaryMatrixGaugeUnits gauge base) : Matrix ι ι ℂ) =
        Matrix.det (wilsonLoopProduct link base tail) *
          (Matrix.det (↑((unitaryMatrixGaugeUnits gauge base)⁻¹) : Matrix ι ι ℂ) *
           Matrix.det (↑(unitaryMatrixGaugeUnits gauge base) : Matrix ι ι ℂ)) := by
      ring
    _ = Matrix.det (wilsonLoopProduct link base tail) := by rw [hdet, mul_one]

end MatrixWilson

end ProjectKoios.SolidState.FiniteLattice

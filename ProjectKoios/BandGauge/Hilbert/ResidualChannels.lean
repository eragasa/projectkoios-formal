/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-28
-/
module

public import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Finite three-channel residual algebra

This module separates a reference-to-interpolant residual, an interpolant-to-truncation residual,
and the resulting reference-to-truncation residual. It proves the exact additive identity and its
pointwise, finite-maximum, and finite root-mean-square triangle bounds.

The results are source-independent finite normed-space algebra. They do not assert that three
reported scalar errors are equal or additive. They do not certify a runtime mesh, floating-point
value, interpolation algorithm, eigensolver, threshold, first-passing decision, or scientific
adequacy claim.
-/

@[expose] public section

open scoped BigOperators NNReal

namespace ProjectKoios.BandGauge.Hilbert

variable {I V : Type*}

/-- `BG-HILBERT-DEF-013`: a finite field of residual values. -/
abbrev FiniteResidualField (I V : Type*) := I → V

/-- `BG-HILBERT-DEF-014`: the reference-minus-interpolant residual channel. -/
def interpolationResidual [Sub V]
    (reference interpolant : FiniteResidualField I V) : FiniteResidualField I V :=
  fun i => reference i - interpolant i

/-- `BG-HILBERT-DEF-015`: the interpolant-minus-truncated residual channel. -/
def truncationResidual [Sub V]
    (interpolant truncated : FiniteResidualField I V) : FiniteResidualField I V :=
  fun i => interpolant i - truncated i

/-- `BG-HILBERT-DEF-016`: the reference-minus-truncated total residual channel. -/
def totalResidual [Sub V]
    (reference truncated : FiniteResidualField I V) : FiniteResidualField I V :=
  fun i => reference i - truncated i

/-- `BG-HILBERT-DEF-017`: the finite maximum norm of a residual field. -/
noncomputable def finiteMaximumNorm [Fintype I] [NormedAddCommGroup V]
    (field : FiniteResidualField I V) : ℝ :=
  ‖field‖

/-- `BG-HILBERT-DEF-018`: the finite root-mean-square norm of a residual field. The empty
inventory has denominator zero and therefore evaluates to zero under Lean's totalized division. -/
noncomputable def finiteRootMeanSquareNorm [Fintype I] [NormedAddCommGroup V]
    (field : FiniteResidualField I V) : ℝ :=
  ‖(WithLp.toLp 2 field : PiLp 2 fun _ : I => V)‖ /
    Real.sqrt (Fintype.card I : ℝ)

/-- `BG-HILBERT-THM-016`: the finite maximum norm is the supremum of the pointwise norms. -/
theorem finiteMaximumNorm_eq_sup [Fintype I] [NormedAddCommGroup V]
    (field : FiniteResidualField I V) :
    finiteMaximumNorm field =
      ((Finset.univ.sup fun i : I => ‖field i‖₊ : ℝ≥0) : ℝ) := by
  rfl

/-- `BG-HILBERT-THM-017`: the finite root-mean-square norm has the explicit square-sum form. -/
theorem finiteRootMeanSquareNorm_eq [Fintype I] [NormedAddCommGroup V]
    (field : FiniteResidualField I V) :
    finiteRootMeanSquareNorm field =
      Real.sqrt (∑ i, ‖field i‖ ^ 2) / Real.sqrt (Fintype.card I : ℝ) := by
  rw [finiteRootMeanSquareNorm, PiLp.norm_eq_of_L2]

/-- `BG-HILBERT-THM-018`: the total residual is exactly the sum of the interpolation and
truncation residuals. -/
theorem totalResidual_eq_add [AddCommGroup V]
    (reference interpolant truncated : FiniteResidualField I V) :
    totalResidual reference truncated =
      interpolationResidual reference interpolant + truncationResidual interpolant truncated := by
  funext i
  simp [totalResidual, interpolationResidual, truncationResidual]

/-- `BG-HILBERT-THM-019`: the total pointwise residual norm is bounded by the sum of the two
component residual norms. -/
theorem norm_totalResidual_le_add [SeminormedAddCommGroup V]
    (reference interpolant truncated : FiniteResidualField I V) (i : I) :
    ‖totalResidual reference truncated i‖ ≤
      ‖interpolationResidual reference interpolant i‖ +
        ‖truncationResidual interpolant truncated i‖ := by
  rw [show totalResidual reference truncated i =
      interpolationResidual reference interpolant i +
        truncationResidual interpolant truncated i by
    simp [totalResidual, interpolationResidual, truncationResidual]]
  exact norm_add_le _ _

/-- `BG-HILBERT-THM-020`: the finite maximum total error is bounded by the sum of the finite
maximum interpolation and truncation errors. -/
theorem finiteMaximumNorm_totalResidual_le_add [Fintype I] [NormedAddCommGroup V]
    (reference interpolant truncated : FiniteResidualField I V) :
    finiteMaximumNorm (totalResidual reference truncated) ≤
      finiteMaximumNorm (interpolationResidual reference interpolant) +
        finiteMaximumNorm (truncationResidual interpolant truncated) := by
  rw [totalResidual_eq_add reference interpolant truncated]
  exact norm_add_le _ _

/-- `BG-HILBERT-THM-021`: the finite root-mean-square total error is bounded by the sum of the
finite root-mean-square interpolation and truncation errors. -/
theorem finiteRootMeanSquareNorm_totalResidual_le_add
    [Fintype I] [NormedAddCommGroup V]
    (reference interpolant truncated : FiniteResidualField I V) :
    finiteRootMeanSquareNorm (totalResidual reference truncated) ≤
      finiteRootMeanSquareNorm (interpolationResidual reference interpolant) +
        finiteRootMeanSquareNorm (truncationResidual interpolant truncated) := by
  have hfield :
      (WithLp.toLp 2 (totalResidual reference truncated) : PiLp 2 fun _ : I => V) =
        WithLp.toLp 2 (interpolationResidual reference interpolant) +
          WithLp.toLp 2 (truncationResidual interpolant truncated) := by
    ext i
    simp [totalResidual, interpolationResidual, truncationResidual]
  rw [finiteRootMeanSquareNorm, finiteRootMeanSquareNorm, finiteRootMeanSquareNorm, hfield]
  rw [← add_div]
  exact div_le_div_of_nonneg_right (norm_add_le _ _) (Real.sqrt_nonneg _)

end ProjectKoios.BandGauge.Hilbert

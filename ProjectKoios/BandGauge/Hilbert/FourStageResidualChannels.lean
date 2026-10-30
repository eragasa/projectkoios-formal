/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Hilbert.ResidualChannels

/-!
# Four-stage residual channels

This module refines the finite residual ledger to four fields:

1. a reference field;
2. an interpolated field;
3. a converted field; and
4. a deliberately truncated field.

The three component residual channels are reference-minus-interpolated,
interpolated-minus-converted, and converted-minus-truncated. Their field sum equals the
reference-minus-truncated total residual exactly. Pointwise, finite-maximum, and finite
root-mean-square summaries satisfy triangle inequalities; the scalar summaries are not claimed
to add exactly.

No runtime interpolation, representation conversion, truncation implementation, mesh, floating-
point value, or certificate is authenticated here.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Hilbert

variable {I V : Type*}

/-- `BG-HILBERT-DEF-019`: four exact finite fields defining the reference, interpolation,
conversion, and deliberate-truncation stages of one residual ledger. -/
structure FourStageResidualFields (I V : Type*) where
  reference : FiniteResidualField I V
  interpolated : FiniteResidualField I V
  converted : FiniteResidualField I V
  truncated : FiniteResidualField I V

/-- `BG-HILBERT-DEF-020`: the interpolated-minus-converted residual channel. -/
def conversionResidual [Sub V]
    (interpolated converted : FiniteResidualField I V) : FiniteResidualField I V :=
  fun i => interpolated i - converted i

/-- `BG-HILBERT-THM-022`: the total residual field is exactly the sum of the interpolation,
conversion, and deliberate-truncation residual fields. -/
theorem totalResidual_eq_interpolation_add_conversion_add_truncation [AddCommGroup V]
    (fields : FourStageResidualFields I V) :
    totalResidual fields.reference fields.truncated =
      interpolationResidual fields.reference fields.interpolated +
        conversionResidual fields.interpolated fields.converted +
          truncationResidual fields.converted fields.truncated := by
  funext i
  simp [totalResidual, interpolationResidual, conversionResidual, truncationResidual]

/-- `BG-HILBERT-THM-023`: the total pointwise residual norm is bounded by the sum of the
three component residual norms. -/
theorem norm_totalResidual_le_three [SeminormedAddCommGroup V]
    (fields : FourStageResidualFields I V) (i : I) :
    ‖totalResidual fields.reference fields.truncated i‖ ≤
      ‖interpolationResidual fields.reference fields.interpolated i‖ +
        ‖conversionResidual fields.interpolated fields.converted i‖ +
          ‖truncationResidual fields.converted fields.truncated i‖ := by
  rw [show totalResidual fields.reference fields.truncated i =
      interpolationResidual fields.reference fields.interpolated i +
        conversionResidual fields.interpolated fields.converted i +
          truncationResidual fields.converted fields.truncated i by
    simp [totalResidual, interpolationResidual, conversionResidual, truncationResidual]]
  calc
    ‖interpolationResidual fields.reference fields.interpolated i +
        conversionResidual fields.interpolated fields.converted i +
          truncationResidual fields.converted fields.truncated i‖ ≤
      ‖interpolationResidual fields.reference fields.interpolated i +
        conversionResidual fields.interpolated fields.converted i‖ +
          ‖truncationResidual fields.converted fields.truncated i‖ := norm_add_le _ _
    _ ≤ ‖interpolationResidual fields.reference fields.interpolated i‖ +
        ‖conversionResidual fields.interpolated fields.converted i‖ +
          ‖truncationResidual fields.converted fields.truncated i‖ :=
      add_le_add (norm_add_le _ _) le_rfl

/-- `BG-HILBERT-THM-024`: the finite maximum total error is bounded by the sum of the
finite maximum interpolation, conversion, and deliberate-truncation errors. -/
theorem finiteMaximumNorm_totalResidual_le_three [Fintype I] [NormedAddCommGroup V]
    (fields : FourStageResidualFields I V) :
    finiteMaximumNorm (totalResidual fields.reference fields.truncated) ≤
      finiteMaximumNorm (interpolationResidual fields.reference fields.interpolated) +
        finiteMaximumNorm (conversionResidual fields.interpolated fields.converted) +
          finiteMaximumNorm (truncationResidual fields.converted fields.truncated) := by
  rw [totalResidual_eq_interpolation_add_conversion_add_truncation fields]
  calc
    ‖interpolationResidual fields.reference fields.interpolated +
        conversionResidual fields.interpolated fields.converted +
          truncationResidual fields.converted fields.truncated‖ ≤
      ‖interpolationResidual fields.reference fields.interpolated +
        conversionResidual fields.interpolated fields.converted‖ +
          ‖truncationResidual fields.converted fields.truncated‖ := norm_add_le _ _
    _ ≤ ‖interpolationResidual fields.reference fields.interpolated‖ +
        ‖conversionResidual fields.interpolated fields.converted‖ +
          ‖truncationResidual fields.converted fields.truncated‖ :=
      add_le_add (norm_add_le _ _) le_rfl

/-- `BG-HILBERT-THM-025`: the finite root-mean-square total error is bounded by the sum of
the finite root-mean-square interpolation, conversion, and deliberate-truncation errors. -/
theorem finiteRootMeanSquareNorm_totalResidual_le_three
    [Fintype I] [NormedAddCommGroup V]
    (fields : FourStageResidualFields I V) :
    finiteRootMeanSquareNorm (totalResidual fields.reference fields.truncated) ≤
      finiteRootMeanSquareNorm
        (interpolationResidual fields.reference fields.interpolated) +
        finiteRootMeanSquareNorm
          (conversionResidual fields.interpolated fields.converted) +
          finiteRootMeanSquareNorm
            (truncationResidual fields.converted fields.truncated) := by
  have hfield :
      (WithLp.toLp 2 (totalResidual fields.reference fields.truncated) :
          PiLp 2 fun _ : I => V) =
        WithLp.toLp 2 (interpolationResidual fields.reference fields.interpolated) +
          WithLp.toLp 2 (conversionResidual fields.interpolated fields.converted) +
            WithLp.toLp 2 (truncationResidual fields.converted fields.truncated) := by
    ext i
    simp [totalResidual, interpolationResidual, conversionResidual, truncationResidual]
  rw [finiteRootMeanSquareNorm, finiteRootMeanSquareNorm,
    finiteRootMeanSquareNorm, finiteRootMeanSquareNorm, hfield]
  rw [← add_div, ← add_div]
  apply div_le_div_of_nonneg_right _ (Real.sqrt_nonneg _)
  calc
    ‖WithLp.toLp 2 (interpolationResidual fields.reference fields.interpolated) +
        WithLp.toLp 2 (conversionResidual fields.interpolated fields.converted) +
          WithLp.toLp 2 (truncationResidual fields.converted fields.truncated)‖ ≤
      ‖WithLp.toLp 2 (interpolationResidual fields.reference fields.interpolated) +
        WithLp.toLp 2 (conversionResidual fields.interpolated fields.converted)‖ +
          ‖WithLp.toLp 2 (truncationResidual fields.converted fields.truncated)‖ :=
      norm_add_le _ _
    _ ≤ ‖WithLp.toLp 2 (interpolationResidual fields.reference fields.interpolated)‖ +
        ‖WithLp.toLp 2 (conversionResidual fields.interpolated fields.converted)‖ +
          ‖WithLp.toLp 2 (truncationResidual fields.converted fields.truncated)‖ :=
      add_le_add (norm_add_le _ _) le_rfl

end ProjectKoios.BandGauge.Hilbert

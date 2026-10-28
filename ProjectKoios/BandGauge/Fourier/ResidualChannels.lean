/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-28
-/
module

public import ProjectKoios.BandGauge.Hilbert.ResidualChannels
public import ProjectKoios.BandGauge.Fourier.MatrixFrobenius

/-!
# Fourier bridge for finite residual channels

This module identifies the deliberate-truncation channel with the existing exact finite Fourier
truncation residual. It exposes the Hilbert-power and entrywise matrix-Frobenius tail identities
through the three-channel vocabulary, then derives their exact finite root-mean-square
normalizations.

The matrix root-mean-square quantity is defined from the explicit entrywise Frobenius power rather
than the ambient matrix norm. The maximum-norm result bounds the ambient norm at every momentum,
and therefore its finite maximum, by the omitted coefficient one-norm tail. The bridge is exact
finite algebra for the repository's declared transform convention. It does not bind a runtime
interpolant, numerical mesh, floating-point coefficient, physical hopping range, or scientific
adequacy decision.
-/

@[expose] public section

open Fintype (card)

namespace ProjectKoios.BandGauge.Fourier

open ProjectKoios.BandGauge.Hilbert

variable {G V : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-067`: when the interpolant is exact finite Fourier reconstruction and the
truncated field reconstructs the retained coefficients, the three-channel truncation residual is
the existing finite Fourier truncation residual. -/
theorem truncationResidual_fourierReconstruction_eq
    [AddCommGroup V] [Module ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) :
    truncationResidual
        (finiteFourierReconstruction coefficients)
        (finiteFourierReconstruction (truncateCoefficients support coefficients)) =
      finiteFourierTruncationResidual support coefficients := by
  rfl

/-- `BG-FOURIER-THM-068`: the Hilbert power of the deliberate-truncation channel equals the
cardinality-scaled omitted coefficient power. -/
theorem finiteFourierPower_truncationResidual_eq_omitted
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) :
    finiteFourierPower
        (truncationResidual
          (finiteFourierReconstruction coefficients)
          (finiteFourierReconstruction (truncateCoefficients support coefficients))) =
      (card G : ℝ) * omittedWeight (fun mode => ‖coefficients mode‖ ^ 2) support := by
  rw [truncationResidual_fourierReconstruction_eq]
  exact finiteFourierTruncationResidual_parseval support coefficients

variable {m n : Type*} [Fintype m] [Fintype n]

/-- `BG-FOURIER-THM-069`: for complex matrix coefficients, the entrywise Frobenius power of the
deliberate-truncation channel equals the cardinality-scaled omitted matrix coefficient power. -/
theorem finiteMatrixFrobeniusPower_truncationResidual_eq_omitted
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix m n ℂ) :
    finiteMatrixFrobeniusPower
        (truncationResidual
          (finiteFourierReconstruction coefficients)
          (finiteFourierReconstruction (truncateCoefficients support coefficients))) =
      (card G : ℝ) * omittedMatrixFrobeniusPower coefficients support := by
  rw [truncationResidual_fourierReconstruction_eq]
  exact finiteMatrixFrobeniusTruncationResidual_parseval support coefficients

/-- `BG-FOURIER-DEF-031`: the finite root-mean-square entrywise Frobenius norm of a complex
matrix field. The empty inventory has denominator zero and therefore evaluates to zero under
Lean's totalized division. -/
noncomputable def finiteMatrixFrobeniusRootMeanSquare
    (field : G → Matrix m n ℂ) : ℝ :=
  Real.sqrt (finiteMatrixFrobeniusPower field) / Real.sqrt (card G : ℝ)

variable [Nonempty G]

/-- `BG-FOURIER-THM-070`: the finite root-mean-square norm of the Hilbert-valued
deliberate-truncation channel equals the square root of the omitted coefficient power. -/
theorem finiteRootMeanSquareNorm_truncationResidual_eq_sqrt_omitted
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) :
    finiteRootMeanSquareNorm
        (truncationResidual
          (finiteFourierReconstruction coefficients)
          (finiteFourierReconstruction (truncateCoefficients support coefficients))) =
      Real.sqrt (omittedWeight (fun mode => ‖coefficients mode‖ ^ 2) support) := by
  rw [finiteRootMeanSquareNorm_eq, ← finiteFourierPower_eq_sum_norm_sq,
    finiteFourierPower_truncationResidual_eq_omitted]
  rw [Real.sqrt_mul (by exact_mod_cast (Nat.zero_le (card G)))]
  have hcardPos : (0 : ℝ) < card G := by
    exact_mod_cast Fintype.card_pos
  have hcard : Real.sqrt (card G : ℝ) ≠ 0 :=
    ne_of_gt (Real.sqrt_pos.2 hcardPos)
  exact (div_eq_iff hcard).2 (by ring)

/-- `BG-FOURIER-THM-071`: the squared finite root-mean-square norm of the Hilbert-valued
deliberate-truncation channel equals the omitted coefficient power. -/
theorem finiteRootMeanSquareNorm_truncationResidual_sq_eq_omitted
    [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) :
    finiteRootMeanSquareNorm
        (truncationResidual
          (finiteFourierReconstruction coefficients)
          (finiteFourierReconstruction (truncateCoefficients support coefficients))) ^ 2 =
      omittedWeight (fun mode => ‖coefficients mode‖ ^ 2) support := by
  rw [finiteRootMeanSquareNorm_truncationResidual_eq_sqrt_omitted]
  apply Real.sq_sqrt
  unfold omittedWeight
  exact Finset.sum_nonneg fun mode _ => sq_nonneg ‖coefficients mode‖

/-- `BG-FOURIER-THM-072`: the finite root-mean-square entrywise Frobenius norm of the matrix
deliberate-truncation channel equals the square root of the omitted coefficient Frobenius
power. -/
theorem finiteMatrixFrobeniusRootMeanSquare_truncationResidual_eq_sqrt_omitted
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix m n ℂ) :
    finiteMatrixFrobeniusRootMeanSquare
        (truncationResidual
          (finiteFourierReconstruction coefficients)
          (finiteFourierReconstruction (truncateCoefficients support coefficients))) =
      Real.sqrt (omittedMatrixFrobeniusPower coefficients support) := by
  rw [finiteMatrixFrobeniusRootMeanSquare,
    finiteMatrixFrobeniusPower_truncationResidual_eq_omitted]
  rw [Real.sqrt_mul (by exact_mod_cast (Nat.zero_le (card G)))]
  have hcardPos : (0 : ℝ) < card G := by
    exact_mod_cast Fintype.card_pos
  have hcard : Real.sqrt (card G : ℝ) ≠ 0 :=
    ne_of_gt (Real.sqrt_pos.2 hcardPos)
  exact (div_eq_iff hcard).2 (by ring)

/-- `BG-FOURIER-THM-073`: the squared finite root-mean-square entrywise Frobenius norm of the
matrix deliberate-truncation channel equals the omitted coefficient Frobenius power. -/
theorem finiteMatrixFrobeniusRootMeanSquare_truncationResidual_sq_eq_omitted
    (support : Finset (AddChar G ℂ))
    (coefficients : AddChar G ℂ → Matrix m n ℂ) :
    finiteMatrixFrobeniusRootMeanSquare
        (truncationResidual
          (finiteFourierReconstruction coefficients)
          (finiteFourierReconstruction (truncateCoefficients support coefficients))) ^ 2 =
      omittedMatrixFrobeniusPower coefficients support := by
  rw [finiteMatrixFrobeniusRootMeanSquare_truncationResidual_eq_sqrt_omitted]
  apply Real.sq_sqrt
  unfold omittedMatrixFrobeniusPower
  exact Finset.sum_nonneg fun mode _ =>
    Finset.sum_nonneg fun i _ =>
      Finset.sum_nonneg fun j _ => sq_nonneg ‖coefficients mode i j‖

omit [DecidableEq G] [Nonempty G] in
/-- `BG-FOURIER-THM-074`: at every momentum, the norm of the deliberate-truncation channel is
bounded by the exact one-norm tail of the omitted coefficients. -/
theorem norm_truncationResidual_fourierReconstruction_le_omitted
    [NormedAddCommGroup V] [NormedSpace ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V)
    (momentum : G) :
    ‖truncationResidual
        (finiteFourierReconstruction coefficients)
        (finiteFourierReconstruction (truncateCoefficients support coefficients)) momentum‖ ≤
      omittedWeight (fun mode => ‖coefficients mode‖) support := by
  change ‖finiteReconstruction finiteCharacterPhase coefficients momentum -
      truncatedReconstruction finiteCharacterPhase support coefficients momentum‖ ≤ _
  rw [finiteReconstruction_sub_truncatedReconstruction_eq_omitted]
  calc
    ‖∑ mode ∈ supportᶜ, finiteCharacterPhase momentum mode • coefficients mode‖ ≤
        ∑ mode ∈ supportᶜ,
          ‖finiteCharacterPhase momentum mode • coefficients mode‖ :=
      norm_sum_le supportᶜ fun mode => finiteCharacterPhase momentum mode • coefficients mode
    _ = omittedWeight (fun mode => ‖coefficients mode‖) support := by
      unfold omittedWeight
      apply Finset.sum_congr rfl
      intro mode _
      rw [norm_smul]
      simp [finiteCharacterPhase]

omit [DecidableEq G] [Nonempty G] in
/-- `BG-FOURIER-THM-075`: the finite maximum norm of the deliberate-truncation channel is bounded
by the exact one-norm tail of the omitted coefficients. -/
theorem finiteMaximumNorm_truncationResidual_le_omitted
    [NormedAddCommGroup V] [NormedSpace ℂ V]
    (support : Finset (AddChar G ℂ)) (coefficients : AddChar G ℂ → V) :
    finiteMaximumNorm
        (truncationResidual
          (finiteFourierReconstruction coefficients)
          (finiteFourierReconstruction (truncateCoefficients support coefficients))) ≤
      omittedWeight (fun mode => ‖coefficients mode‖) support := by
  unfold finiteMaximumNorm
  have hnonneg : 0 ≤ omittedWeight (fun mode => ‖coefficients mode‖) support := by
    unfold omittedWeight
    exact Finset.sum_nonneg fun mode _ => norm_nonneg _
  exact (pi_norm_le_iff_of_nonneg (x := truncationResidual
    (finiteFourierReconstruction coefficients)
    (finiteFourierReconstruction (truncateCoefficients support coefficients))) hnonneg).2
      fun momentum =>
        norm_truncationResidual_fourierReconstruction_le_omitted support coefficients momentum

end ProjectKoios.BandGauge.Fourier

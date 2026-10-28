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
truncation residual. It then exposes the Hilbert-power and entrywise matrix-Frobenius tail
identities through the three-channel vocabulary.

The bridge is exact finite algebra for the repository's declared transform convention. It does not
bind a runtime interpolant, numerical mesh, floating-point coefficient, physical hopping range, or
scientific adequacy decision.
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

end ProjectKoios.BandGauge.Fourier

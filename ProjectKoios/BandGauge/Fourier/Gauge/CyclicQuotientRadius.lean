/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-03
-/
module

public import ProjectKoios.BandGauge.Fourier.Gauge.PointwiseConvolution
public import ProjectKoios.BandGauge.Fourier.Support.CyclicQuotientRadius

/-!
# Gauge-support growth on a finite cyclic quotient

This module instantiates the finite-character gauge-support theorem with the periodic quotient radius
on `AddChar (ZMod n) ℂ`.  It therefore handles modular wraparound through the quotient seminorm and
does not assume that a selected centered integer representative is additive across the seam.

The result remains a support inclusion.  It does not identify Fourier characters with runtime array
indices, choose a gauge, certify numerical coefficients, or attach physical units to the radius.
-/

@[expose] public section

open scoped Matrix

namespace ProjectKoios.BandGauge.Fourier.Gauge

open ProjectKoios.BandGauge.Fourier.FiniteAbelian
open ProjectKoios.BandGauge.Fourier.Support

/-- `BG-FOURIER-GAUGE-THM-004`: on a finite cyclic momentum group, quotient-radius-supported gauge
and field coefficients imply the exact wrapped support bound `R_A + 2 R_U`. -/
theorem cyclicPointwiseUnitaryConjugation_coefficients_supportedOn_quotientRadius
    (pointCount : ℕ) [NeZero pointCount]
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (gauge : ZMod pointCount → Matrix.unitaryGroup ι ℂ)
    (field : ZMod pointCount → Matrix ι ι ℂ)
    (gaugeRadius fieldRadius : NNReal)
    (hgauge : CoefficientSupportedOn
      (metricShell Finset.univ (cyclicCharacterQuotientRadius pointCount) gaugeRadius)
      (finiteFourierCoefficient
        (fun momentum => (gauge momentum : Matrix ι ι ℂ))))
    (hfield : CoefficientSupportedOn
      (metricShell Finset.univ (cyclicCharacterQuotientRadius pointCount) fieldRadius)
      (finiteFourierCoefficient field)) :
    CoefficientSupportedOn
      (metricShell Finset.univ (cyclicCharacterQuotientRadius pointCount)
        (fieldRadius + 2 * gaugeRadius))
      (finiteFourierCoefficient (pointwiseUnitaryConjugation gauge field)) := by
  exact pointwiseUnitaryConjugation_coefficients_supportedOn_metricShell
    gauge field (cyclicCharacterQuotientRadius pointCount) gaugeRadius fieldRadius
    (cyclicCharacterQuotientRadius_neg pointCount)
    (cyclicCharacterQuotientRadius_add_le pointCount) hgauge hfield

end ProjectKoios.BandGauge.Fourier.Gauge

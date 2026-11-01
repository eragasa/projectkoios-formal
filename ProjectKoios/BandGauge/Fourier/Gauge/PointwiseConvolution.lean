/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-31
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.Convolution
public import ProjectKoios.BandGauge.Fourier.Gauge.PointwiseGauge
public import ProjectKoios.BandGauge.Fourier.Support.RadiusGrowth

/-!
# Pointwise-gauge Fourier convolution

This module gives the exact finite Fourier coefficient law for momentum-dependent unitary
conjugation.  Under the normalized conjugated-character forward convention, conjugate transpose
negates the mode, so the coefficient field of `Uᴴ A U` is a triple convolution with mode relation
`-a + b + c = m`.

The resulting support statement is only an inclusion in a finite character inventory.  Matrix
products and sums may cancel, so no equality of supports is claimed.  The declarations do not
identify a runtime gauge, coefficient array, physical hopping range, continuum decay rate, or
scientific locality conclusion.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix Pointwise

namespace ProjectKoios.BandGauge.Fourier.Gauge

open ProjectKoios.BandGauge.Fourier.FiniteAbelian
open ProjectKoios.BandGauge.Fourier.Support

variable {G m n ι : Type*} [AddCommGroup G] [Fintype G]

/-- `BG-FOURIER-GAUGE-LEM-001`: coefficient conjugation negates the finite character mode. -/
lemma finiteFourierCoefficient_conj
    (field : G → ℂ) (mode : AddChar G ℂ) :
    finiteFourierCoefficient (fun momentum => conj (field momentum)) mode =
      conj (finiteFourierCoefficient field (-mode)) := by
  simp only [finiteFourierCoefficient, smul_eq_mul]
  rw [map_mul, map_inv₀, map_natCast, map_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro momentum _
  rw [map_mul]
  simp only [starRingEnd_apply, star_star]
  rw [AddChar.neg_apply, AddChar.map_neg_eq_inv, AddChar.inv_apply_eq_conj]
  rfl

/-- `BG-FOURIER-GAUGE-LEM-002`: coefficient conjugate transpose negates the finite character mode. -/
lemma finiteFourierCoefficient_conjTranspose
    (field : G → Matrix m n ℂ) (mode : AddChar G ℂ) :
    finiteFourierCoefficient (fun momentum => (field momentum)ᴴ) mode =
      (finiteFourierCoefficient field (-mode))ᴴ := by
  ext i j
  simpa [finiteFourierCoefficient, Matrix.sum_apply, Matrix.smul_apply,
    Matrix.conjTranspose_apply] using
      (finiteFourierCoefficient_conj (fun momentum => field momentum j i) mode)

omit [Fintype G] in
/-- `BG-FOURIER-GAUGE-LEM-003`: negating modes and taking conjugate transpose negates an exact
coefficient support. -/
lemma conjTranspose_negated_coefficients_supportedOn_neg
    (coefficients : AddChar G ℂ → Matrix m n ℂ)
    (support : Finset (AddChar G ℂ))
    (hsupport : CoefficientSupportedOn support coefficients) :
    CoefficientSupportedOn (-support)
      (fun mode => (coefficients (-mode))ᴴ) := by
  intro mode hmode
  have hneg : -mode ∉ support := by
    intro hmem
    apply hmode
    rw [Finset.mem_neg]
    exact ⟨-mode, hmem, neg_neg mode⟩
  change (coefficients (-mode))ᴴ = 0
  rw [hsupport (-mode) hneg]
  simp

section Radius

variable {Mode : Type*} [AddCommGroup Mode] [Fintype Mode] [DecidableEq Mode]

/-- `BG-FOURIER-GAUGE-LEM-004`: gauge-field-gauge addition of complete shells for an
inversion-invariant subadditive radius lies in the shell with radius bound `R_A + 2 R_U`. -/
lemma pointwiseConjugation_supportShell_subset
    (radius : Mode → NNReal) (gaugeRadius fieldRadius : NNReal)
    (hneg : ∀ mode, radius (-mode) = radius mode)
    (hadd : ∀ left right, radius (left + right) ≤ radius left + radius right) :
    ((-(metricShell Finset.univ radius gaugeRadius) +
        metricShell Finset.univ radius fieldRadius) +
      metricShell Finset.univ radius gaugeRadius) ⊆
      metricShell Finset.univ radius (fieldRadius + 2 * gaugeRadius) := by
  rw [neg_metricShell_univ_eq radius gaugeRadius hneg]
  have hsubset := (Finset.add_subset_add
    (metricShell_univ_add_subset radius gaugeRadius fieldRadius hadd)
    (fun _ h => h)).trans
      (metricShell_univ_add_subset radius
        (gaugeRadius + fieldRadius) gaugeRadius hadd)
  simpa only [two_mul, add_assoc, add_left_comm, add_comm] using hsubset

end Radius

section Matrix

variable [DecidableEq G] [Fintype ι] [DecidableEq ι]

/-- `BG-FOURIER-GAUGE-THM-001`: exact triple-convolution law for a pointwise unitary conjugation.
The nested form expands to matrix products `Û(a)ᴴ * Â(b) * Û(c)` over modes satisfying
`-a + b + c = mode`.  The coefficient identity itself uses no numerical or runtime gauge data. -/
theorem finiteFourierCoefficient_pointwiseUnitaryConjugation_convolution
    (gauge : G → Matrix.unitaryGroup ι ℂ)
    (field : G → Matrix ι ι ℂ) (mode : AddChar G ℂ) :
    finiteFourierCoefficient (pointwiseUnitaryConjugation gauge field) mode =
      finiteMatrixConvolution
        (finiteMatrixConvolution
          (fun gaugeMode =>
            (finiteFourierCoefficient
              (fun momentum => (gauge momentum : Matrix ι ι ℂ)) (-gaugeMode))ᴴ)
          (finiteFourierCoefficient field))
        (finiteFourierCoefficient
          (fun momentum => (gauge momentum : Matrix ι ι ℂ))) mode := by
  change finiteFourierCoefficient
    (fun momentum =>
      ((gauge momentum : Matrix ι ι ℂ)ᴴ * field momentum) *
        (gauge momentum : Matrix ι ι ℂ)) mode = _
  rw [finiteFourierCoefficient_mul]
  congr 1
  funext leftMode
  rw [finiteFourierCoefficient_mul]
  congr 1
  funext gaugeMode
  exact finiteFourierCoefficient_conjTranspose
    (fun momentum => (gauge momentum : Matrix ι ι ℂ)) gaugeMode

/-- `BG-FOURIER-GAUGE-THM-002`: if the gauge coefficients are supported on `S_U` and the field
coefficients on `S_A`, then the pointwise-conjugated field is supported on
`(-S_U + S_A) + S_U`.  This is a finite exact inclusion, not support equality or a physical-range
claim. -/
theorem pointwiseUnitaryConjugation_coefficients_supportedOn
    (gauge : G → Matrix.unitaryGroup ι ℂ)
    (field : G → Matrix ι ι ℂ)
    (gaugeSupport fieldSupport : Finset (AddChar G ℂ))
    (hgauge : CoefficientSupportedOn gaugeSupport
      (finiteFourierCoefficient
        (fun momentum => (gauge momentum : Matrix ι ι ℂ))))
    (hfield : CoefficientSupportedOn fieldSupport
      (finiteFourierCoefficient field)) :
    CoefficientSupportedOn ((-gaugeSupport + fieldSupport) + gaugeSupport)
      (finiteFourierCoefficient (pointwiseUnitaryConjugation gauge field)) := by
  have hleft := finiteMatrixConvolution_supportedOn_add
    (fun gaugeMode =>
      (finiteFourierCoefficient
        (fun momentum => (gauge momentum : Matrix ι ι ℂ)) (-gaugeMode))ᴴ)
    (finiteFourierCoefficient field) (-gaugeSupport) fieldSupport
    (conjTranspose_negated_coefficients_supportedOn_neg
      (finiteFourierCoefficient
        (fun momentum => (gauge momentum : Matrix ι ι ℂ)))
      gaugeSupport hgauge)
    hfield
  have htriple := finiteMatrixConvolution_supportedOn_add
    (finiteMatrixConvolution
      (fun gaugeMode =>
        (finiteFourierCoefficient
          (fun momentum => (gauge momentum : Matrix ι ι ℂ)) (-gaugeMode))ᴴ)
      (finiteFourierCoefficient field))
    (finiteFourierCoefficient
      (fun momentum => (gauge momentum : Matrix ι ι ℂ)))
    (-gaugeSupport + fieldSupport) gaugeSupport hleft hgauge
  intro mode hmode
  rw [finiteFourierCoefficient_pointwiseUnitaryConjugation_convolution]
  exact htriple mode hmode

/-- `BG-FOURIER-GAUGE-THM-003`: if the gauge coefficients lie in a complete shell of radius
`R_U` and the field coefficients lie in a complete shell of radius `R_A`, then an
inversion-invariant subadditive mode radius bounds the pointwise-conjugated coefficients by the
complete shell of radius `R_A + 2 R_U`.  This is an exact finite inclusion, not support equality or
a physical-range claim. -/
theorem pointwiseUnitaryConjugation_coefficients_supportedOn_metricShell
    (gauge : G → Matrix.unitaryGroup ι ℂ)
    (field : G → Matrix ι ι ℂ)
    (radius : AddChar G ℂ → NNReal)
    (gaugeRadius fieldRadius : NNReal)
    (hneg : ∀ mode, radius (-mode) = radius mode)
    (hadd : ∀ left right, radius (left + right) ≤ radius left + radius right)
    (hgauge : CoefficientSupportedOn
      (metricShell Finset.univ radius gaugeRadius)
      (finiteFourierCoefficient
        (fun momentum => (gauge momentum : Matrix ι ι ℂ))))
    (hfield : CoefficientSupportedOn
      (metricShell Finset.univ radius fieldRadius)
      (finiteFourierCoefficient field)) :
    CoefficientSupportedOn
      (metricShell Finset.univ radius (fieldRadius + 2 * gaugeRadius))
      (finiteFourierCoefficient (pointwiseUnitaryConjugation gauge field)) := by
  apply coefficientSupportedOn_mono
    (pointwiseConjugation_supportShell_subset
      radius gaugeRadius fieldRadius hneg hadd)
  exact pointwiseUnitaryConjugation_coefficients_supportedOn
    gauge field
    (metricShell Finset.univ radius gaugeRadius)
    (metricShell Finset.univ radius fieldRadius)
    hgauge hfield

end Matrix

end ProjectKoios.BandGauge.Fourier.Gauge

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.BandGauge.Alignment.GaugeIdentity
public import Mathlib.Analysis.Matrix.Spectrum

/-!
# Exact finite-rank unitary gauge construction

This module packages the exact construction

`gaugedFrame = referenceFrame * gauge`

and

`gaugedOperator = gaugeᴴ * referenceOperator * gauge`

for an arbitrary finite retained dimension.  Exact frame orthonormality and the complex spectrum are
preserved.  Right multiplication of the constructed frame by `gaugeᴴ` recovers the reference frame,
and right-gauge conjugation by `gaugeᴴ` recovers the reference represented operator.

The reference operator is arbitrary; a diagonal analytic parent is a specialization.  The supplied
unitary is exact.  No runtime frame, diagonalization, eigensolver, band ordering, Procrustes solve,
mesh, floating-point value, artifact, or scientific applicability is authenticated.
-/

@[expose] public section

open scoped ComplexConjugate Matrix
open Matrix

namespace ProjectKoios.BandGauge.Alignment

variable {Ambient Retained : Type*}
  [Fintype Ambient] [DecidableEq Ambient]
  [Fintype Retained] [DecidableEq Retained]

omit [Fintype Ambient] [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-LEM-001`: the conjugate transpose of the constructing unitary exactly recovers
the reference frame. -/
lemma rightUnitaryFrame_mul_conjTranspose
    (referenceFrame : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    rightUnitaryFrame referenceFrame gauge *
        (gauge : Matrix Retained Retained ℂ)ᴴ = referenceFrame := by
  have hunit :
      (gauge : Matrix Retained Retained ℂ) *
          (gauge : Matrix Retained Retained ℂ)ᴴ = 1 :=
    Matrix.mem_unitaryGroup_iff.mp gauge.property
  rw [rightUnitaryFrame, Matrix.mul_assoc, hunit]
  simp

/-- `BG-ALIGNMENT-THM-069`: exact finite-dimensional unitary right-gauge conjugation preserves the
complex spectrum. -/
theorem spectrum_rightGaugeConjugate_unitary
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (referenceOperator : Matrix Retained Retained ℂ) :
    spectrum ℂ
        (rightGaugeConjugate (gauge : Matrix Retained Retained ℂ) referenceOperator) =
      spectrum ℂ referenceOperator := by
  exact Unitary.spectrum_star_left_conjugate

/-- `BG-ALIGNMENT-LEM-002`: applying the conjugate-transpose gauge to an operator constructed by
`Gᴴ D G` exactly recovers `D`. -/
lemma rightGaugeConjugate_conjTranspose_recover
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (referenceOperator : Matrix Retained Retained ℂ) :
    rightGaugeConjugate (gauge : Matrix Retained Retained ℂ)ᴴ
        (rightGaugeConjugate (gauge : Matrix Retained Retained ℂ) referenceOperator) =
      referenceOperator := by
  have hunit :
      (gauge : Matrix Retained Retained ℂ) *
          (gauge : Matrix Retained Retained ℂ)ᴴ = 1 :=
    Matrix.mem_unitaryGroup_iff.mp gauge.property
  rw [rightGaugeConjugate_mul, hunit, rightGaugeConjugate_one]

omit [DecidableEq Ambient] in
/-- `BG-ALIGNMENT-THM-071`: the exact finite-rank unitary construction simultaneously preserves
frame orthonormality and represented spectrum and admits known-inverse recovery by `Gᴴ`. -/
theorem exactUnitaryGaugeConstruction
    (referenceFrame : ComplexFrame Ambient Retained)
    (referenceOperator : Matrix Retained Retained ℂ)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (hframe : IsOrthonormalFrame referenceFrame) :
    IsOrthonormalFrame (rightUnitaryFrame referenceFrame gauge) ∧
      spectrum ℂ
          (rightGaugeConjugate (gauge : Matrix Retained Retained ℂ) referenceOperator) =
        spectrum ℂ referenceOperator ∧
      rightUnitaryFrame referenceFrame gauge *
          (gauge : Matrix Retained Retained ℂ)ᴴ = referenceFrame ∧
      rightGaugeConjugate (gauge : Matrix Retained Retained ℂ)ᴴ
          (rightGaugeConjugate (gauge : Matrix Retained Retained ℂ) referenceOperator) =
        referenceOperator := by
  exact ⟨rightUnitaryFrame_isOrthonormal referenceFrame gauge hframe,
    spectrum_rightGaugeConjugate_unitary gauge referenceOperator,
    rightUnitaryFrame_mul_conjTranspose referenceFrame gauge,
    rightGaugeConjugate_conjTranspose_recover gauge referenceOperator⟩

end ProjectKoios.BandGauge.Alignment

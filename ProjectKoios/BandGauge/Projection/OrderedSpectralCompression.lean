/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.BandGauge.Foundations.HermitianEigenvaluePerturbation
public import ProjectKoios.BandGauge.Projection.MixedNormCompression

/-!
# Ordered spectral transfer for finite-frame compression

This module transfers the maximum-form Hermitian Weyl bound through the mixed
Frobenius/operator-norm compression estimates.  For exact orthonormal frames, the maximum ordered
retained eigenvalue error is controlled by twice the ambient operator norm times the Frobenius
frame mismatch.  A separate theorem uses the repository's frozen right-unitary action.

These are exact finite-dimensional inequalities.  They do not authenticate runtime frames,
orthonormality, matrices, gauges, eigensolver output, degeneracy handling, or scientific adequacy.
They also do not provide the distinct Frobenius-to-RMS Hoffman--Wielandt perturbation result.
-/

@[expose] public section

open scoped ComplexConjugate Matrix
open Matrix

namespace ProjectKoios.BandGauge.Projection

open ProjectKoios.BandGauge.Alignment
open ProjectKoios.BandGauge.Foundations

variable {Ambient Retained : Type*}
  [Fintype Ambient] [DecidableEq Ambient]
  [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]

/-- `BG-PROJECTION-THM-021`: maximum ordered retained-eigenvalue error between two exact
orthonormal-frame compressions is controlled by ambient operator norm and Frobenius frame
mismatch. -/
theorem compression_orderedEigenvalueMaxError_frob_le
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hoperator : operator.IsHermitian)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    orderedEigenvalueMaxError
        (compressOperator_isHermitian candidate operator hoperator)
        (compressOperator_isHermitian reference operator hoperator) ≤
      2 * matrixL2OperatorNorm operator * matrixFrobeniusNorm (candidate - reference) := by
  let hcandidateCompression := compressOperator_isHermitian candidate operator hoperator
  let hreferenceCompression := compressOperator_isHermitian reference operator hoperator
  calc
    orderedEigenvalueMaxError hcandidateCompression hreferenceCompression
        ≤ matrixL2OperatorNorm
          (compressOperator candidate operator - compressOperator reference operator) := by
      simpa [matrixL2OperatorNorm] using
        orderedEigenvalueMaxError_le_l2OperatorNorm
          hcandidateCompression hreferenceCompression
    _ ≤ matrixFrobeniusNorm
          (compressOperator candidate operator - compressOperator reference operator) :=
      matrixL2OperatorNorm_le_matrixFrobeniusNorm _
    _ ≤ 2 * matrixL2OperatorNorm operator *
          matrixFrobeniusNorm (candidate - reference) :=
      compression_difference_frob_le candidate reference operator hcandidate hreference

omit [DecidableEq Ambient] [Nonempty Retained] in
/-- `BG-PROJECTION-LEM-017`: the explicitly right-unitary-conjugated retained operator is
Hermitian when the ambient operator is Hermitian. -/
lemma rightUnitaryRepresentedOperator_isHermitian
    (reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ)
    (hoperator : operator.IsHermitian) :
    ((gauge : Matrix Retained Retained ℂ)ᴴ * compressOperator reference operator *
      (gauge : Matrix Retained Retained ℂ)).IsHermitian := by
  rw [← compressOperator_rightUnitaryFrame]
  exact compressOperator_isHermitian (rightUnitaryFrame reference gauge) operator hoperator

/-- `BG-PROJECTION-THM-022`: right-unitary specialization of the maximum ordered retained-spectrum
compression bound, with represented reference `Uᴴ (Fᴴ H F) U` in the frozen right-action
convention. -/
theorem compression_rightUnitaryFrame_orderedEigenvalueMaxError_frob_le
    (candidate reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ)
    (hoperator : operator.IsHermitian)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    orderedEigenvalueMaxError
        (compressOperator_isHermitian candidate operator hoperator)
        (rightUnitaryRepresentedOperator_isHermitian reference gauge operator hoperator) ≤
      2 * matrixL2OperatorNorm operator *
        matrixFrobeniusNorm (candidate - rightUnitaryFrame reference gauge) := by
  simpa only [compressOperator_rightUnitaryFrame] using
    compression_orderedEigenvalueMaxError_frob_le
      candidate (rightUnitaryFrame reference gauge) operator hoperator hcandidate
      (rightUnitaryFrame_isOrthonormal reference gauge hreference)

end ProjectKoios.BandGauge.Projection

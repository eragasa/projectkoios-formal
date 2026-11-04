/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-04
-/
module

public import ProjectKoios.BandGauge.Foundations.HermitianEigenvalueRmsPerturbation
public import ProjectKoios.BandGauge.Projection.OrderedSpectralCompression

/-!
# Ordered spectral RMS transfer for finite-frame compression

This module transfers the exact Hoffman--Wielandt bound through finite-frame compression.  For a
retained space of dimension `N`, the ordered-eigenvalue RMS error is bounded by the Frobenius norm
of the retained operator difference divided by `sqrt N`.  Combining this with the mixed
compression estimate gives

`RMS(λ(CᴴHC), λ(FᴴHF)) ≤ 2 ‖H‖op ‖C-F‖F / sqrt N`.

A separate theorem uses the frozen right-unitary representation `Uᴴ(FᴴHF)U`.  These are exact
finite-dimensional inequalities.  They do not authenticate runtime frames, matrices, gauges,
eigensolver output, degeneracy handling, Fourier conventions, or scientific applicability.
-/

@[expose] public section

open scoped ComplexConjugate Matrix
open Matrix

namespace ProjectKoios.BandGauge.Projection

open ProjectKoios.BandGauge.Alignment
open ProjectKoios.BandGauge.Foundations

/-- `BG-PROJECTION-LEM-018`: squared explicit Frobenius norm is the entrywise sum of squared
complex norms. -/
lemma matrixFrobeniusNorm_sq_eq_sum_entry {m n : Type*} [Fintype m] [Fintype n]
    (A : Matrix m n ℂ) :
    matrixFrobeniusNorm A ^ 2 = ∑ i : m, ∑ j : n, ‖A i j‖ ^ 2 := by
  rw [frob_sq_eq_sum_col]
  calc
    (∑ j : n, ‖(EuclideanSpace.equiv m ℂ).symm (A · j)‖ ^ 2) =
        ∑ j : n, ∑ i : m, ‖A i j‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro j _
      rw [PiLp.norm_sq_eq_of_L2]
      rfl
    _ = ∑ i : m, ∑ j : n, ‖A i j‖ ^ 2 := by rw [Finset.sum_comm]

/-- `BG-PROJECTION-THM-023`: Hoffman--Wielandt bounds ordered-eigenvalue RMS error by the
Frobenius matrix difference divided by the square root of the nonzero matrix dimension. -/
theorem orderedEigenvalueRmsError_le_normalizedFrobenius
    {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    {A B : Matrix n n ℂ} (hA : A.IsHermitian) (hB : B.IsHermitian) :
    orderedEigenvalueRmsError hA hB ≤
      matrixFrobeniusNorm (A - B) / Real.sqrt (Fintype.card n) := by
  rw [← sq_le_sq₀ (orderedEigenvalueRmsError_nonneg hA hB)
    (div_nonneg (frob_nonneg _) (Real.sqrt_nonneg _))]
  calc
    orderedEigenvalueRmsError hA hB ^ 2 ≤
        (∑ i : n, ∑ j : n, ‖(A - B) i j‖ ^ 2) / Fintype.card n :=
      orderedEigenvalueRmsError_sq_le_entrywiseFrobeniusAverage hA hB
    _ = matrixFrobeniusNorm (A - B) ^ 2 / Fintype.card n := by
      rw [matrixFrobeniusNorm_sq_eq_sum_entry]
    _ = (matrixFrobeniusNorm (A - B) / Real.sqrt (Fintype.card n)) ^ 2 := by
      rw [div_pow, Real.sq_sqrt (Nat.cast_nonneg _)]

variable {Ambient Retained : Type*}
  [Fintype Ambient] [DecidableEq Ambient]
  [Fintype Retained] [DecidableEq Retained] [Nonempty Retained]

/-- `BG-PROJECTION-THM-024`: ordered-eigenvalue RMS error between two exact orthonormal-frame
compressions is controlled by ambient operator norm, Frobenius frame mismatch, and the retained
dimension normalization. -/
theorem compression_orderedEigenvalueRmsError_frob_le
    (candidate reference : ComplexFrame Ambient Retained)
    (operator : Matrix Ambient Ambient ℂ)
    (hoperator : operator.IsHermitian)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    orderedEigenvalueRmsError
        (compressOperator_isHermitian candidate operator hoperator)
        (compressOperator_isHermitian reference operator hoperator) ≤
      (2 * matrixL2OperatorNorm operator * matrixFrobeniusNorm (candidate - reference)) /
        Real.sqrt (Fintype.card Retained) := by
  let hcandidateCompression := compressOperator_isHermitian candidate operator hoperator
  let hreferenceCompression := compressOperator_isHermitian reference operator hoperator
  calc
    orderedEigenvalueRmsError hcandidateCompression hreferenceCompression ≤
        matrixFrobeniusNorm
          (compressOperator candidate operator - compressOperator reference operator) /
            Real.sqrt (Fintype.card Retained) :=
      orderedEigenvalueRmsError_le_normalizedFrobenius _ _
    _ ≤ (2 * matrixL2OperatorNorm operator * matrixFrobeniusNorm (candidate - reference)) /
          Real.sqrt (Fintype.card Retained) :=
      div_le_div_of_nonneg_right
        (compression_difference_frob_le candidate reference operator hcandidate hreference)
        (Real.sqrt_nonneg _)

/-- `BG-PROJECTION-THM-025`: right-unitary specialization of the RMS ordered-spectrum compression
bound, with represented reference `Uᴴ(FᴴHF)U` in the frozen right-action convention. -/
theorem compression_rightUnitaryFrame_orderedEigenvalueRmsError_frob_le
    (candidate reference : ComplexFrame Ambient Retained)
    (gauge : Matrix.unitaryGroup Retained ℂ)
    (operator : Matrix Ambient Ambient ℂ)
    (hoperator : operator.IsHermitian)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    orderedEigenvalueRmsError
        (compressOperator_isHermitian candidate operator hoperator)
        (rightUnitaryRepresentedOperator_isHermitian reference gauge operator hoperator) ≤
      (2 * matrixL2OperatorNorm operator *
        matrixFrobeniusNorm (candidate - rightUnitaryFrame reference gauge)) /
          Real.sqrt (Fintype.card Retained) := by
  simpa only [compressOperator_rightUnitaryFrame] using
    compression_orderedEigenvalueRmsError_frob_le
      candidate (rightUnitaryFrame reference gauge) operator hoperator hcandidate
      (rightUnitaryFrame_isOrthonormal reference gauge hreference)

end ProjectKoios.BandGauge.Projection

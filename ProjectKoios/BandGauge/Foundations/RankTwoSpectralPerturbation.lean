/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.BandGauge.Foundations.RankTwoPauli
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.LinearAlgebra.Matrix.Charpoly.Eigs

/-!
# Rank-two spectral perturbation

This module gives the two canonical band values of a Hermitian `2 × 2` Pauli-coordinate
matrix and proves that their sorted error is bounded by the unnormalized entrywise
Frobenius norm of the matrix difference.

The factor `1 / √2` used for per-state loss normalization is deliberately absent from the
perturbation bound. The stronger factor fails in general: against the zero matrix,
`diag(2, 0)` has maximum sorted-band error `2` and unnormalized Frobenius distance `2`.
The result is exact finite-dimensional algebra and does not certify a floating-point
eigensolver, a momentum mesh, or a physical model.
-/

open scoped BigOperators ComplexConjugate Matrix
open Matrix Polynomial

@[expose] public section

namespace ProjectKoios.BandGauge.Foundations

/-- `BG-FOUNDATION-DEF-010`: a Hermitian rank-two matrix with scalar coordinate `t` and
real Pauli coordinates `(x,y,z)`. -/
def rankTwoHermitianMatrix (t x y z : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((t + z : ℝ) : ℂ), (x : ℂ) - (y : ℂ) * Complex.I;
     (x : ℂ) + (y : ℂ) * Complex.I, ((t - z : ℝ) : ℂ)]

/-- `BG-FOUNDATION-DEF-011`: the nonnegative radius of a real Pauli vector. -/
noncomputable def rankTwoBandRadius (x y z : ℝ) : ℝ :=
  Real.sqrt (x ^ 2 + y ^ 2 + z ^ 2)

/-- `BG-FOUNDATION-DEF-012`: the lower canonical band of a Hermitian rank-two matrix. -/
noncomputable def rankTwoLowerBand (t x y z : ℝ) : ℝ :=
  t - rankTwoBandRadius x y z

/-- `BG-FOUNDATION-DEF-013`: the upper canonical band of a Hermitian rank-two matrix. -/
noncomputable def rankTwoUpperBand (t x y z : ℝ) : ℝ :=
  t + rankTwoBandRadius x y z

-- The auxiliary Euclidean vector keeps the perturbation proof in standard norm language.
-- It is private because the public API is the matrix-and-band formulation above.
private abbrev RankTwoPauliVector := EuclideanSpace ℝ (Fin 3)

private def rankTwoPauliVector (x y z : ℝ) : RankTwoPauliVector :=
  WithLp.toLp 2 ![x, y, z]

-- The square-root definition agrees exactly with the Euclidean norm of `(x,y,z)`.
private lemma rankTwoBandRadius_eq_norm (x y z : ℝ) :
    rankTwoBandRadius x y z = ‖rankTwoPauliVector x y z‖ := by
  rw [rankTwoBandRadius, EuclideanSpace.norm_eq]
  congr 1
  simp [rankTwoPauliVector, Fin.sum_univ_three]

-- Squaring the radius removes the square root because the radicand is a sum of squares.
private lemma rankTwoBandRadius_sq (x y z : ℝ) :
    rankTwoBandRadius x y z ^ 2 = x ^ 2 + y ^ 2 + z ^ 2 := by
  rw [rankTwoBandRadius, Real.sq_sqrt]
  positivity

/-- `BG-FOUNDATION-THM-008`: the Pauli-coordinate matrix is Hermitian. -/
theorem rankTwoHermitianMatrix_conjTranspose
    (t x y z : ℝ) :
    (rankTwoHermitianMatrix t x y z)ᴴ = rankTwoHermitianMatrix t x y z := by
  -- The diagonal entries are real and the off-diagonal entries are conjugates.
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rankTwoHermitianMatrix, Complex.ext_iff]

/-- `BG-FOUNDATION-THM-009`: the lower canonical band belongs to the exact matrix
spectrum. -/
theorem rankTwoLowerBand_mem_spectrum (t x y z : ℝ) :
    ((rankTwoLowerBand t x y z : ℝ) : ℂ) ∈
      spectrum ℂ (rankTwoHermitianMatrix t x y z) := by
  -- For a finite matrix, spectral membership is an exact characteristic-polynomial root.
  rw [Matrix.mem_spectrum_iff_isRoot_charpoly]
  rw [Matrix.charpoly_fin_two]
  simp [Polynomial.IsRoot, rankTwoHermitianMatrix, rankTwoLowerBand,
    Matrix.trace, Fin.sum_univ_two, Matrix.det_fin_two]
  -- Cast `r² = x²+y²+z²` to `ℂ`, then cancel the remaining polynomial terms.
  have hr := congrArg (fun q : ℝ => (q : ℂ)) (rankTwoBandRadius_sq x y z)
  push_cast at hr
  ring_nf
  rw [hr, Complex.I_sq]
  ring

/-- `BG-FOUNDATION-THM-010`: the upper canonical band belongs to the exact matrix
spectrum. -/
theorem rankTwoUpperBand_mem_spectrum (t x y z : ℝ) :
    ((rankTwoUpperBand t x y z : ℝ) : ℂ) ∈
      spectrum ℂ (rankTwoHermitianMatrix t x y z) := by
  -- This is the same exact root calculation as for the lower band, with the other sign.
  rw [Matrix.mem_spectrum_iff_isRoot_charpoly]
  rw [Matrix.charpoly_fin_two]
  simp [Polynomial.IsRoot, rankTwoHermitianMatrix, rankTwoUpperBand,
    Matrix.trace, Fin.sum_univ_two, Matrix.det_fin_two]
  have hr := congrArg (fun q : ℝ => (q : ℂ)) (rankTwoBandRadius_sq x y z)
  push_cast at hr
  ring_nf
  rw [hr, Complex.I_sq]
  ring

/-- `BG-FOUNDATION-THM-011`: the unnormalized squared entrywise Frobenius distance between
two rank-two Hermitian matrices is twice the squared Euclidean coefficient distance. -/
theorem rankTwoHermitianMatrix_frobeniusSq_sub
    (t x y z T X Y Z : ℝ) :
    (∑ i : Fin 2, ∑ j : Fin 2,
      ‖(rankTwoHermitianMatrix t x y z - rankTwoHermitianMatrix T X Y Z) i j‖ ^ 2) =
      2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2) := by
  -- Expand all four entries. The diagonal pair supplies the `t,z` terms and the
  -- conjugate off-diagonal pair supplies the `x,y` terms, each with multiplicity two.
  simp [rankTwoHermitianMatrix, Fin.sum_univ_two, Complex.sq_norm,
    Complex.normSq_apply, Matrix.sub_apply]
  ring

private lemma lower_band_error_le_coefficient_frobenius
    (t x y z T X Y Z : ℝ) :
    |rankTwoLowerBand t x y z - rankTwoLowerBand T X Y Z| ≤
      Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) := by
  simp only [rankTwoLowerBand, rankTwoBandRadius_eq_norm]
  -- Package both Pauli triples as Euclidean vectors so the reverse triangle inequality applies.
  let v := rankTwoPauliVector x y z
  let w := rankTwoPauliVector X Y Z
  have hr : |‖v‖ - ‖w‖| ≤ ‖v - w‖ := abs_norm_sub_norm_le v w
  -- Separate the scalar-center error from the radius error.
  have htri : |(t - T) - (‖v‖ - ‖w‖)| ≤ |t - T| + ‖v - w‖ := by
    calc
      |(t - T) - (‖v‖ - ‖w‖)| ≤ |t - T| + |‖v‖ - ‖w‖| := abs_sub _ _
      _ ≤ |t - T| + ‖v - w‖ := add_le_add_right hr _
  -- Expand the Euclidean norm square back into the three coordinate differences.
  have hvSq : ‖v - w‖ ^ 2 = (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2 := by
    rw [EuclideanSpace.real_norm_sq_eq]
    simp [v, w, rankTwoPauliVector, Fin.sum_univ_three]
  have hsumNonneg : 0 ≤ |t - T| + ‖v - w‖ :=
    add_nonneg (abs_nonneg _) (norm_nonneg _)
  have hfNonneg :
      0 ≤ Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) :=
    Real.sqrt_nonneg _
  -- The elementary bound `(a+b)² ≤ 2(a²+b²)` supplies the exact coefficient
  -- appearing in the unnormalized rank-two Frobenius identity.
  have hsq :
      (|t - T| + ‖v - w‖) ^ 2 ≤
        Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) ^ 2 := by
    rw [Real.sq_sqrt]
    · calc
        (|t - T| + ‖v - w‖) ^ 2 ≤ 2 * ((t - T) ^ 2 + ‖v - w‖ ^ 2) := by
          nlinarith [sq_nonneg (|t - T| - ‖v - w‖), sq_abs (t - T)]
        _ = 2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2) := by
          rw [hvSq]
          ring
    · positivity
  have hsum :
      |t - T| + ‖v - w‖ ≤
        Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) :=
    (sq_le_sq₀ hsumNonneg hfNonneg).1 hsq
  -- Remove the local abbreviations and chain both bounds.
  dsimp [v, w] at htri hsum
  calc
    |t - ‖rankTwoPauliVector x y z‖ -
        (T - ‖rankTwoPauliVector X Y Z‖)| =
        |(t - T) - (‖rankTwoPauliVector x y z‖ -
          ‖rankTwoPauliVector X Y Z‖)| := by
      apply congrArg abs
      ring
    _ ≤ |t - T| + ‖rankTwoPauliVector x y z - rankTwoPauliVector X Y Z‖ := htri
    _ ≤ Real.sqrt
        (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) := hsum

private lemma upper_band_error_le_coefficient_frobenius
    (t x y z T X Y Z : ℝ) :
    |rankTwoUpperBand t x y z - rankTwoUpperBand T X Y Z| ≤
      Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) := by
  simp only [rankTwoUpperBand, rankTwoBandRadius_eq_norm]
  -- Repeat the Euclidean-vector argument for the upper-band `t + radius` sign.
  let v := rankTwoPauliVector x y z
  let w := rankTwoPauliVector X Y Z
  have hr : |‖v‖ - ‖w‖| ≤ ‖v - w‖ := abs_norm_sub_norm_le v w
  have htri : |(t - T) + (‖v‖ - ‖w‖)| ≤ |t - T| + ‖v - w‖ := by
    calc
      |(t - T) + (‖v‖ - ‖w‖)| ≤ |t - T| + |‖v‖ - ‖w‖| := abs_add_le _ _
      _ ≤ |t - T| + ‖v - w‖ := add_le_add_right hr _
  -- The vector norm has the same coordinate expansion as in the lower-band proof.
  have hvSq : ‖v - w‖ ^ 2 = (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2 := by
    rw [EuclideanSpace.real_norm_sq_eq]
    simp [v, w, rankTwoPauliVector, Fin.sum_univ_three]
  have hsumNonneg : 0 ≤ |t - T| + ‖v - w‖ :=
    add_nonneg (abs_nonneg _) (norm_nonneg _)
  have hfNonneg :
      0 ≤ Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) :=
    Real.sqrt_nonneg _
  -- Bound the scalar and radius errors jointly before taking square roots.
  have hsq :
      (|t - T| + ‖v - w‖) ^ 2 ≤
        Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) ^ 2 := by
    rw [Real.sq_sqrt]
    · calc
        (|t - T| + ‖v - w‖) ^ 2 ≤ 2 * ((t - T) ^ 2 + ‖v - w‖ ^ 2) := by
          nlinarith [sq_nonneg (|t - T| - ‖v - w‖), sq_abs (t - T)]
        _ = 2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2) := by
          rw [hvSq]
          ring
    · positivity
  have hsum :
      |t - T| + ‖v - w‖ ≤
        Real.sqrt (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) :=
    (sq_le_sq₀ hsumNonneg hfNonneg).1 hsq
  -- The upper-band conclusion follows from the same square-root estimate.
  dsimp [v, w] at htri hsum
  calc
    |t + ‖rankTwoPauliVector x y z‖ -
        (T + ‖rankTwoPauliVector X Y Z‖)| =
        |(t - T) + (‖rankTwoPauliVector x y z‖ -
          ‖rankTwoPauliVector X Y Z‖)| := by
      apply congrArg abs
      ring
    _ ≤ |t - T| + ‖rankTwoPauliVector x y z - rankTwoPauliVector X Y Z‖ := htri
    _ ≤ Real.sqrt
        (2 * ((t - T) ^ 2 + (x - X) ^ 2 + (y - Y) ^ 2 + (z - Z) ^ 2)) := hsum

/-- `BG-FOUNDATION-THM-012`: the maximum sorted-band error of two Hermitian rank-two
matrices is bounded by their **unnormalized** entrywise Frobenius distance. No factor
`1 / √2` is valid here without an additional structural hypothesis. -/
theorem rankTwo_max_band_error_le_frobenius
    (t x y z T X Y Z : ℝ) :
    max
      |rankTwoLowerBand t x y z - rankTwoLowerBand T X Y Z|
      |rankTwoUpperBand t x y z - rankTwoUpperBand T X Y Z| ≤
      Real.sqrt (∑ i : Fin 2, ∑ j : Fin 2,
        ‖(rankTwoHermitianMatrix t x y z - rankTwoHermitianMatrix T X Y Z) i j‖ ^ 2) := by
  -- Replace the matrix expression by the exact coefficient-space Frobenius identity.
  rw [rankTwoHermitianMatrix_frobeniusSq_sub]
  -- Both sorted band errors obey the same bound, so their maximum does too.
  exact max_le
    (lower_band_error_le_coefficient_frobenius t x y z T X Y Z)
    (upper_band_error_le_coefficient_frobenius t x y z T X Y Z)

/-- `BG-FOUNDATION-THM-013`: every Hermitian complex `2 × 2` matrix has the scalar-plus-
Pauli coordinate form used by the spectral perturbation bound. -/
theorem eq_rankTwoHermitianMatrix_of_conjTranspose_eq_self
    (M : Matrix (Fin 2) (Fin 2) ℂ) (hHermitian : Mᴴ = M) :
    M = rankTwoHermitianMatrix
      ((M 0 0).re / 2 + (M 1 1).re / 2)
      (rankTwoPauliX M) (rankTwoPauliY M)
      ((M 0 0).re / 2 - (M 1 1).re / 2) := by
  -- Hermiticity makes each diagonal entry fixed by conjugation and relates the
  -- two off-diagonal entries by conjugation.
  have h00 : conj (M 0 0) = M 0 0 := by
    simpa using congrFun (congrFun hHermitian 0) 0
  have h11 : conj (M 1 1) = M 1 1 := by
    simpa using congrFun (congrFun hHermitian 1) 1
  have h01 : conj (M 1 0) = M 0 1 := by
    simpa using congrFun (congrFun hHermitian 0) 1
  -- A complex number fixed by conjugation has zero imaginary part.
  have him00 : (M 0 0).im = 0 := by
    have h := congrArg Complex.im h00
    simp at h
    linarith
  have him11 : (M 1 1).im = 0 := by
    have h := congrArg Complex.im h11
    simp at h
    linarith
  have h10 : M 1 0 = conj (M 0 1) := by
    rw [← h01]
    simp
  -- Check the reconstructed scalar-plus-Pauli matrix entry by entry.
  ext i j
  fin_cases i <;> fin_cases j
  · apply Complex.ext <;>
      simp [rankTwoHermitianMatrix, him00]
  · apply Complex.ext <;>
      simp [rankTwoHermitianMatrix, rankTwoPauliX, rankTwoPauliY]
  · change M 1 0 = _
    rw [h10]
    apply Complex.ext <;>
      simp [rankTwoHermitianMatrix, rankTwoPauliX, rankTwoPauliY]
  · apply Complex.ext <;>
      simp [rankTwoHermitianMatrix, him11]

/-- `BG-FOUNDATION-THM-014`: the canonical rank-two band values are in increasing order. -/
theorem rankTwoLowerBand_le_upperBand (t x y z : ℝ) :
    rankTwoLowerBand t x y z ≤ rankTwoUpperBand t x y z := by
  -- The only ordering input is the nonnegativity of the square-root radius.
  have hr : 0 ≤ rankTwoBandRadius x y z := by
    exact Real.sqrt_nonneg _
  unfold rankTwoLowerBand rankTwoUpperBand
  linarith

end ProjectKoios.BandGauge.Foundations

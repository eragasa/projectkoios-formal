module

public import ProjectKoios.BandGauge.Foundations.RankTwoRotation

/-!
# Pauli coordinates for traceless Hermitian rank-two matrices

This module supplies elementary `2 × 2` matrix identities for real Pauli coordinates.
It is reusable supporting algebra and carries no paper-contribution or novelty claim.
-/

open scoped BigOperators ComplexConjugate Matrix
open Finset

@[expose] public section

namespace ProjectKoios.BandGauge.Foundations

/-- `BG-FOUNDATION-DEF-005`: the traceless Hermitian matrix
`x σₓ + y σᵧ + z σ_z` in the standard Pauli convention. -/
def rankTwoPauliMatrix (x y z : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(z : ℂ), (x : ℂ) - (y : ℂ) * Complex.I;
     (x : ℂ) + (y : ℂ) * Complex.I, -(z : ℂ)]

/-- `BG-FOUNDATION-DEF-007`: the canonical Pauli `x` coordinate of a rank-two matrix. -/
def rankTwoPauliX (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  (M 0 1).re

/-- `BG-FOUNDATION-DEF-008`: the canonical Pauli `y` coordinate of a rank-two matrix. -/
def rankTwoPauliY (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  -(M 0 1).im

/-- `BG-FOUNDATION-DEF-009`: the canonical Pauli `z` coordinate of a rank-two matrix. -/
def rankTwoPauliZ (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  (M 0 0).re

/-- `BG-FOUNDATION-THM-003`: conjugation by the standard real rotation fixes the Pauli
`y` coordinate and rotates the `(x,z)` coordinates through angle `2φ`. -/
theorem rankTwoRealRotation_conjTranspose_mul_pauli_mul
    (φ x y z : ℝ) :
    ((rankTwoRealRotation φ : Matrix (Fin 2) (Fin 2) ℂ)ᴴ *
        rankTwoPauliMatrix x y z *
        (rankTwoRealRotation φ : Matrix (Fin 2) (Fin 2) ℂ)) =
      rankTwoPauliMatrix
        (x * Real.cos (2 * φ) - z * Real.sin (2 * φ)) y
        (x * Real.sin (2 * φ) + z * Real.cos (2 * φ)) := by
  have hcos : Real.cos φ ^ 2 = 1 - Real.sin φ ^ 2 := by
    nlinarith [Real.sin_sq_add_cos_sq φ]
  ext i j
  fin_cases i <;> fin_cases j <;> apply Complex.ext <;>
    simp [-Complex.ofReal_cos, -Complex.ofReal_sin, rankTwoRealRotation,
      rankTwoPauliMatrix, Matrix.mul_apply, Fin.sum_univ_two,
      Real.cos_two_mul, Real.sin_two_mul] <;>
    simp only [← Complex.ofReal_pow, Complex.ofReal_re, Complex.ofReal_im] <;>
    ring_nf <;> rw [hcos] <;> ring

/-- `BG-FOUNDATION-THM-004`: the real Frobenius pairing of two real Pauli-coordinate
matrices is twice their Euclidean coefficient pairing. -/
theorem rankTwoPauliMatrix_frobeniusCorrelation
    (x y z X Y Z : ℝ) :
    (∑ m : Fin 2, ∑ n : Fin 2,
      (conj (rankTwoPauliMatrix x y z m n) *
        rankTwoPauliMatrix X Y Z m n).re) =
      2 * (x * X + y * Y + z * Z) := by
  simp [rankTwoPauliMatrix, Fin.sum_univ_two]
  ring

/-- `BG-FOUNDATION-THM-007`: every traceless Hermitian complex `2 × 2` matrix is exactly
its canonical real Pauli-coordinate matrix. -/
theorem eq_rankTwoPauliMatrix_of_conjTranspose_eq_self_of_trace_eq_zero
    (M : Matrix (Fin 2) (Fin 2) ℂ) (hHermitian : Mᴴ = M)
    (hTrace : Matrix.trace M = 0) :
    M = rankTwoPauliMatrix (rankTwoPauliX M) (rankTwoPauliY M) (rankTwoPauliZ M) := by
  have h00 : conj (M 0 0) = M 0 0 := by
    have h := congrFun (congrFun hHermitian 0) 0
    simpa using h
  have h01 : conj (M 1 0) = M 0 1 := by
    have h := congrFun (congrFun hHermitian 0) 1
    simpa using h
  have htraceEntries : M 0 0 + M 1 1 = 0 := by
    simpa [Matrix.trace, Fin.sum_univ_two] using hTrace
  have him00 : (M 0 0).im = 0 := by
    have h := congrArg Complex.im h00
    simp at h
    linarith
  have h10 : M 1 0 = conj (M 0 1) := by
    rw [← h01]
    simp
  have h11 : M 1 1 = -(M 0 0) :=
    eq_neg_of_add_eq_zero_right htraceEntries
  ext i j
  fin_cases i <;> fin_cases j
  · change M 0 0 = _
    apply Complex.ext <;>
      simp [rankTwoPauliMatrix, rankTwoPauliZ, him00]
  · change M 0 1 = _
    apply Complex.ext <;>
      simp [rankTwoPauliMatrix, rankTwoPauliX, rankTwoPauliY]
  · change M 1 0 = _
    rw [h10]
    apply Complex.ext <;>
      simp [rankTwoPauliMatrix, rankTwoPauliX, rankTwoPauliY]
  · change M 1 1 = _
    rw [h11]
    apply Complex.ext <;>
      simp [rankTwoPauliMatrix, rankTwoPauliZ, him00]

end ProjectKoios.BandGauge.Foundations

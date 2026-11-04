/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-06
-/
module

public import ProjectKoios.BandGauge.Alignment.PolarTransport

/-!
# Polar principal values and the frame/projector bridge

For orthonormal finite complex frames, this module connects three exact quantities:

* the minimum right-unitary Procrustes frame error;
* the eigenvalues of the positive factor in a supplied exact polar decomposition of the overlap
  matrix; and
* the Frobenius distance between the two ambient frame projectors.

The positive-factor eigenvalues are proved to lie in `[0, 1]`. The minimum frame error is twice the
sum of `1 - σᵢ`, while the projector error is twice the sum of `1 - σᵢ²`. Consequently the minimum
frame error is at most the projector error, which is at most twice the minimum frame error.

These are finite exact matrix identities. They do not authenticate runtime frames, a numerical SVD,
singular-value ordering, principal-angle arrays, numerical rank or tolerance, external projector
construction, mesh ordering, or scientific applicability. The polar factor remains supplied exact
input; this module proves consequences of that witness rather than constructing it from data.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate ComplexOrder Matrix Matrix.Norms.Frobenius
open Matrix

namespace ProjectKoios.BandGauge.Alignment

variable {Ambient Retained : Type*}
  [Fintype Ambient] [DecidableEq Ambient]
  [Fintype Retained] [DecidableEq Retained]

/-- `BG-ALIGNMENT-DEF-046`: retained-coordinate overlap matrix `candidateᴴ * reference`. -/
def frameOverlap
    (candidate reference : ComplexFrame Ambient Retained) : Matrix Retained Retained ℂ :=
  candidateᴴ * reference

/-- `BG-ALIGNMENT-DEF-047`: an exact polar principal value, defined as an eigenvalue of the
positive-semidefinite factor in a supplied overlap polar witness. -/
noncomputable def polarPrincipalValue
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (i : Retained) : ℝ :=
  witness.positiveSemidefinite.isHermitian.eigenvalues i

/-- `BG-ALIGNMENT-DEF-048`: sum of the exact polar principal-value frame defects `1 - σᵢ`. -/
noncomputable def polarPrincipalFrameDefect
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference) : ℝ :=
  ∑ i, (1 - polarPrincipalValue witness i)

/-- `BG-ALIGNMENT-DEF-049`: sum of the exact polar principal-value projector defects `1 - σᵢ²`. -/
noncomputable def polarPrincipalProjectorDefect
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference) : ℝ :=
  ∑ i, (1 - (polarPrincipalValue witness i) ^ 2)

/-- `BG-ALIGNMENT-LEM-003`: an orthonormal frame has squared Frobenius power equal to its retained
dimension. -/
lemma frobeniusPower_eq_card_of_isOrthonormal
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    frobeniusPower frame = Fintype.card Retained := by
  rw [frobeniusPower, hframe, Matrix.trace_one]
  simp

/-- `BG-ALIGNMENT-LEM-004`: the projector of an orthonormal frame has squared Frobenius power equal
to the retained dimension. -/
lemma frobeniusPower_frameProjector_eq_card
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    frobeniusPower (frameProjector frame) = Fintype.card Retained := by
  rw [frobeniusPower]
  rw [(frameProjector_isHermitian frame).eq, frameProjector_mul_self frame hframe]
  rw [frameProjector, Matrix.trace_mul_comm, hframe, Matrix.trace_one]
  simp

/-- `BG-ALIGNMENT-LEM-005`: the projector cross trace equals the overlap Frobenius power. -/
lemma frameProjector_crossTrace_eq_overlapPower
    (candidate reference : ComplexFrame Ambient Retained) :
    (Matrix.trace ((frameProjector candidate)ᴴ * frameProjector reference)).re =
      frobeniusPower (frameOverlap candidate reference) := by
  rw [frobeniusPower]
  rw [(frameProjector_isHermitian candidate).eq]
  simp only [frameProjector, frameOverlap, Matrix.conjTranspose_mul]
  rw [Matrix.conjTranspose_conjTranspose]
  have hcycle := Matrix.trace_mul_cycle candidate (candidateᴴ * reference) referenceᴴ
  simpa only [Matrix.mul_assoc] using congrArg Complex.re hcycle

/-- `BG-ALIGNMENT-THM-086`: exact projector-distance identity in terms of the frame overlap. -/
theorem frameProjector_distance_eq_overlapPower
    (candidate reference : ComplexFrame Ambient Retained)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    frobeniusPower (frameProjector candidate - frameProjector reference) =
      2 * Fintype.card Retained - 2 * frobeniusPower (frameOverlap candidate reference) := by
  rw [frobeniusPower_sub,
    frobeniusPower_frameProjector_eq_card candidate hcandidate,
    frobeniusPower_frameProjector_eq_card reference hreference,
    frameProjector_crossTrace_eq_overlapPower]
  ring

/-- `BG-ALIGNMENT-LEM-006`: the complement of an orthonormal frame projector is positive
semidefinite. -/
lemma one_sub_frameProjector_posSemidef
    (frame : ComplexFrame Ambient Retained)
    (hframe : IsOrthonormalFrame frame) :
    (1 - frameProjector frame).PosSemidef := by
  let complement : Matrix Ambient Ambient ℂ := 1 - frameProjector frame
  have hhermitian : complementᴴ = complement := by
    rw [show complement = 1 - frameProjector frame by rfl, Matrix.conjTranspose_sub,
      Matrix.conjTranspose_one, (frameProjector_isHermitian frame).eq]
  have hidempotent : complement * complement = complement := by
    dsimp [complement]
    rw [Matrix.sub_mul, Matrix.one_mul, Matrix.mul_sub, Matrix.mul_one,
      frameProjector_mul_self frame hframe]
    abel
  have hgram : complementᴴ * complement = complement := by
    rw [hhermitian, hidempotent]
  change complement.PosSemidef
  rw [← hgram]
  exact Matrix.posSemidef_conjTranspose_mul_self complement

/-- `BG-ALIGNMENT-LEM-007`: the overlap of two orthonormal frames is contractive in the exact Gram
sense `1 - overlapᴴ * overlap ≥ 0`. -/
lemma one_sub_frameOverlap_gram_posSemidef
    (candidate reference : ComplexFrame Ambient Retained)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    (1 - (frameOverlap candidate reference)ᴴ * frameOverlap candidate reference).PosSemidef := by
  have hsandwich :=
    (one_sub_frameProjector_posSemidef candidate hcandidate).conjTranspose_mul_mul_same reference
  have heq :
      referenceᴴ * (1 - frameProjector candidate) * reference =
        1 - (frameOverlap candidate reference)ᴴ * frameOverlap candidate reference := by
    rw [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one, hreference]
    simp only [frameProjector, frameOverlap, Matrix.conjTranspose_mul,
      Matrix.conjTranspose_conjTranspose, Matrix.mul_assoc]
  rwa [heq] at hsandwich

/-- `BG-ALIGNMENT-LEM-008`: the overlap Gram matrix is the square of the positive polar factor. -/
lemma frameOverlap_gram_eq_positiveFactor_sq
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference) :
    (frameOverlap candidate reference)ᴴ * frameOverlap candidate reference =
      witness.positiveFactor * witness.positiveFactor := by
  rw [frameOverlap, witness.crossFactorization, Matrix.conjTranspose_mul]
  rw [witness.positiveSemidefinite.isHermitian.eq]
  have hunit :
      (witness.minimizer : Matrix Retained Retained ℂ)ᴴ *
          (witness.minimizer : Matrix Retained Retained ℂ) = 1 :=
    Matrix.mem_unitaryGroup_iff'.mp witness.minimizer.property
  simp only [Matrix.mul_assoc]
  rw [← Matrix.mul_assoc
    (witness.minimizer : Matrix Retained Retained ℂ)ᴴ
    (witness.minimizer : Matrix Retained Retained ℂ)
    witness.positiveFactor, hunit, Matrix.one_mul]

/-- `BG-ALIGNMENT-LEM-009`: overlap Frobenius power equals positive-polar-factor Frobenius power. -/
lemma frobeniusPower_frameOverlap_eq_positiveFactor
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference) :
    frobeniusPower (frameOverlap candidate reference) =
      frobeniusPower witness.positiveFactor := by
  unfold frobeniusPower
  rw [frameOverlap_gram_eq_positiveFactor_sq witness,
    witness.positiveSemidefinite.isHermitian.eq]

/-- `BG-ALIGNMENT-THM-091`: every exact polar principal value is nonnegative. -/
theorem polarPrincipalValue_nonneg
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (i : Retained) :
    0 ≤ polarPrincipalValue witness i := by
  exact witness.positiveSemidefinite.eigenvalues_nonneg i

/-- `BG-ALIGNMENT-THM-092`: for orthonormal frames, every exact polar principal value is at most
one. -/
theorem polarPrincipalValue_le_one
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference)
    (i : Retained) :
    polarPrincipalValue witness i ≤ 1 := by
  have hoverlap :=
    one_sub_frameOverlap_gram_posSemidef candidate reference hcandidate hreference
  rw [frameOverlap_gram_eq_positiveFactor_sq witness] at hoverlap
  let eigenvectors : Matrix.unitaryGroup Retained ℂ :=
    witness.positiveSemidefinite.isHermitian.eigenvectorUnitary
  let principal : Retained → ℝ := polarPrincipalValue witness
  have hspectral : witness.positiveFactor =
      (eigenvectors : Matrix Retained Retained ℂ) *
        Matrix.diagonal (fun j => (principal j : ℂ)) *
          (eigenvectors : Matrix Retained Retained ℂ)ᴴ := by
    rw [witness.positiveSemidefinite.isHermitian.spectral_theorem,
      Unitary.conjStarAlgAut_apply]
    congr 2
  have hconjugated :
      ((eigenvectors : Matrix Retained Retained ℂ) *
        Matrix.diagonal (fun j => ((1 - (principal j) ^ 2 : ℝ) : ℂ)) *
          (eigenvectors : Matrix Retained Retained ℂ)ᴴ).PosSemidef := by
    convert hoverlap using 1
    rw [hspectral]
    let diagonal : Matrix Retained Retained ℂ :=
      Matrix.diagonal (fun j => (principal j : ℂ))
    have hdiagonal :
        Matrix.diagonal (fun j => ((1 - (principal j) ^ 2 : ℝ) : ℂ)) =
          1 - diagonal * diagonal := by
      ext a b
      by_cases hab : a = b
      · subst b
        simp [diagonal, Matrix.mul_apply, Matrix.diagonal, pow_two]
      · simp [diagonal, Matrix.mul_apply, Matrix.diagonal, hab]
    have hleft :
        (eigenvectors : Matrix Retained Retained ℂ)ᴴ *
            (eigenvectors : Matrix Retained Retained ℂ) = 1 :=
      Matrix.mem_unitaryGroup_iff'.mp eigenvectors.property
    have hright :
        (eigenvectors : Matrix Retained Retained ℂ) *
            (eigenvectors : Matrix Retained Retained ℂ)ᴴ = 1 :=
      Matrix.mem_unitaryGroup_iff.mp eigenvectors.property
    change (eigenvectors : Matrix Retained Retained ℂ) *
        Matrix.diagonal (fun j => ((1 - (principal j) ^ 2 : ℝ) : ℂ)) *
          (eigenvectors : Matrix Retained Retained ℂ)ᴴ =
      1 - ((eigenvectors : Matrix Retained Retained ℂ) * diagonal *
          (eigenvectors : Matrix Retained Retained ℂ)ᴴ) *
        ((eigenvectors : Matrix Retained Retained ℂ) * diagonal *
          (eigenvectors : Matrix Retained Retained ℂ)ᴴ)
    rw [hdiagonal, Matrix.mul_sub, Matrix.mul_one, Matrix.sub_mul]
    rw [hright]
    congr 1
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc (eigenvectors : Matrix Retained Retained ℂ)ᴴ
      (eigenvectors : Matrix Retained Retained ℂ)
      (diagonal * (eigenvectors : Matrix Retained Retained ℂ)ᴴ), hleft, Matrix.one_mul]
  have heigenvectorsUnit :
      IsUnit (eigenvectors : Matrix Retained Retained ℂ) := Unitary.isUnit_coe
  have hdiagonal :
      (Matrix.diagonal (fun j => ((1 - (principal j) ^ 2 : ℝ) : ℂ))).PosSemidef :=
    heigenvectorsUnit.posSemidef_star_right_conjugate_iff.mp hconjugated
  have hiComplex := Matrix.posSemidef_diagonal_iff.mp hdiagonal i
  have hi : 0 ≤ (1 - (principal i) ^ 2 : ℝ) := by
    have hire := (Complex.nonneg_iff.mp hiComplex).1
    change 0 ≤ (1 - (principal i) ^ 2 : ℝ) at hire
    exact hire
  have hnonneg : 0 ≤ principal i := polarPrincipalValue_nonneg witness i
  change principal i ≤ 1
  nlinarith

/-- `BG-ALIGNMENT-LEM-010`: the positive-factor trace is the sum of exact polar principal values. -/
lemma positiveFactor_trace_eq_sum_polarPrincipalValue
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference) :
    (Matrix.trace witness.positiveFactor).re =
      ∑ i, polarPrincipalValue witness i := by
  rw [witness.positiveSemidefinite.isHermitian.trace_eq_sum_eigenvalues,
    Complex.re_sum]
  simp [polarPrincipalValue]

/-- `BG-ALIGNMENT-LEM-011`: positive-factor Frobenius power is the sum of squared exact polar
principal values. -/
lemma frobeniusPower_positiveFactor_eq_sum_polarPrincipalValue_sq
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference) :
    frobeniusPower witness.positiveFactor =
      ∑ i, (polarPrincipalValue witness i) ^ 2 := by
  let eigenvectors : Matrix.unitaryGroup Retained ℂ :=
    witness.positiveSemidefinite.isHermitian.eigenvectorUnitary
  let principal : Retained → ℝ := polarPrincipalValue witness
  have hspectral : witness.positiveFactor =
      (eigenvectors : Matrix Retained Retained ℂ) *
        Matrix.diagonal (fun i => (principal i : ℂ)) *
          (eigenvectors : Matrix Retained Retained ℂ)ᴴ := by
    rw [witness.positiveSemidefinite.isHermitian.spectral_theorem,
      Unitary.conjStarAlgAut_apply]
    congr 2
  rw [hspectral]
  calc
    frobeniusPower
        ((eigenvectors : Matrix Retained Retained ℂ) *
          Matrix.diagonal (fun i => (principal i : ℂ)) *
            (eigenvectors : Matrix Retained Retained ℂ)ᴴ) =
      frobeniusPower
        ((eigenvectors : Matrix Retained Retained ℂ) *
          Matrix.diagonal (fun i => (principal i : ℂ))) := by
            simpa [rightUnitaryFrame, Matrix.star_eq_conjTranspose] using
              frobeniusPower_rightUnitaryFrame
                ((eigenvectors : Matrix Retained Retained ℂ) *
                  Matrix.diagonal (fun i => (principal i : ℂ))) eigenvectors⁻¹
    _ = frobeniusPower (Matrix.diagonal (fun i => (principal i : ℂ))) := by
      rw [frobeniusPower, Matrix.conjTranspose_mul]
      have hunit :
          (eigenvectors : Matrix Retained Retained ℂ)ᴴ *
              (eigenvectors : Matrix Retained Retained ℂ) = 1 :=
        Matrix.mem_unitaryGroup_iff'.mp eigenvectors.property
      simp only [Matrix.mul_assoc]
      rw [← Matrix.mul_assoc
        (eigenvectors : Matrix Retained Retained ℂ)ᴴ
        (eigenvectors : Matrix Retained Retained ℂ)
        (Matrix.diagonal (fun i => (principal i : ℂ))), hunit, Matrix.one_mul]
      rfl
    _ = ∑ i, (polarPrincipalValue witness i) ^ 2 := by
      rw [frobeniusPower]
      simp [Matrix.trace, Matrix.mul_apply, Matrix.diagonal, principal,
        polarPrincipalValue, pow_two]

/-- `BG-ALIGNMENT-THM-095`: the optimal exact Procrustes frame error is twice the summed principal
frame defect. -/
theorem rightUnitaryProcrustesObjective_eq_polarPrincipalFrameDefect
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    rightUnitaryProcrustesObjective candidate reference witness.minimizer =
      2 * polarPrincipalFrameDefect witness := by
  rw [rightUnitaryProcrustesObjective_expansion,
    frobeniusPower_eq_card_of_isOrthonormal candidate hcandidate,
    frobeniusPower_eq_card_of_isOrthonormal reference hreference,
    witness.score_eq_trace,
    witness.positiveSemidefinite.isHermitian.trace_eq_sum_eigenvalues,
    Complex.re_sum]
  rw [polarPrincipalFrameDefect, Finset.sum_sub_distrib]
  simp [polarPrincipalValue]
  ring

/-- `BG-ALIGNMENT-THM-096`: exact projector error is twice the summed principal projector defect. -/
theorem frameProjector_distance_eq_polarPrincipalProjectorDefect
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    frobeniusPower (frameProjector candidate - frameProjector reference) =
      2 * polarPrincipalProjectorDefect witness := by
  rw [frameProjector_distance_eq_overlapPower candidate reference hcandidate hreference,
    frobeniusPower_frameOverlap_eq_positiveFactor witness,
    frobeniusPower_positiveFactor_eq_sum_polarPrincipalValue_sq witness,
    polarPrincipalProjectorDefect, Finset.sum_sub_distrib]
  simp
  ring

/-- `BG-ALIGNMENT-THM-097`: the summed frame and projector principal defects differ by at most a
factor of two. -/
theorem polarPrincipalDefect_bounds
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    polarPrincipalFrameDefect witness ≤ polarPrincipalProjectorDefect witness ∧
      polarPrincipalProjectorDefect witness ≤ 2 * polarPrincipalFrameDefect witness := by
  constructor
  · rw [polarPrincipalFrameDefect, polarPrincipalProjectorDefect]
    apply Finset.sum_le_sum
    intro i _
    have hnonneg := polarPrincipalValue_nonneg witness i
    have hupper := polarPrincipalValue_le_one witness hcandidate hreference i
    nlinarith [mul_nonneg hnonneg (sub_nonneg.mpr hupper)]
  · rw [polarPrincipalFrameDefect, polarPrincipalProjectorDefect, Finset.mul_sum]
    apply Finset.sum_le_sum
    intro i _
    nlinarith [sq_nonneg (1 - polarPrincipalValue witness i)]

/-- `BG-ALIGNMENT-THM-098`: the optimal exact Procrustes frame error bounds the projector error
within a factor of two. -/
theorem rightUnitaryProcrustesObjective_frameProjector_bounds
    {candidate reference : ComplexFrame Ambient Retained}
    (witness : RightUnitaryProcrustesPolarWitness candidate reference)
    (hcandidate : IsOrthonormalFrame candidate)
    (hreference : IsOrthonormalFrame reference) :
    rightUnitaryProcrustesObjective candidate reference witness.minimizer ≤
        frobeniusPower (frameProjector candidate - frameProjector reference) ∧
      frobeniusPower (frameProjector candidate - frameProjector reference) ≤
        2 * rightUnitaryProcrustesObjective candidate reference witness.minimizer := by
  rw [rightUnitaryProcrustesObjective_eq_polarPrincipalFrameDefect witness hcandidate hreference,
    frameProjector_distance_eq_polarPrincipalProjectorDefect witness hcandidate hreference]
  obtain ⟨hlower, hupper⟩ := polarPrincipalDefect_bounds witness hcandidate hreference
  constructor <;> nlinarith

end ProjectKoios.BandGauge.Alignment

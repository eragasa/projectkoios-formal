module

public import Mathlib.Analysis.InnerProductSpace.Basic
public import Mathlib.Analysis.Normed.Affine.AddTorsor
public import ProjectKoios.BandGauge.Geometry.AdmissibleSets

/-!
# Hilbert-space admissible balls

This module proves exact intersection and distance geometry for two closed balls in a
real Hilbert space. The results are intended for later instantiation with the paper's
finite weighted Frobenius residual space. They do not choose a matrix representation,
weights, Bloch-section regularity, or an operator norm.
-/

open scoped ENNReal
open Set

@[expose] public section

namespace ProjectKoios.BandGauge.Hilbert

variable {H : Type*} [NormedAddCommGroup H]
  [instHilbert : InnerProductSpace ℝ H]

include instHilbert

/-- `BG-HILBERT-DEF-001`: the closed Hilbert-space ball representing one residual
budget. A negative radius gives the empty set. -/
def hilbertAdmissibleBall (center : H) (radius : ℝ) : Set H :=
  {x | dist x center ≤ radius}

/-- `BG-HILBERT-DEF-002`: the candidate exact distance between two nonnegative-radius
Hilbert-space balls. -/
def hilbertBallDistance (center₁ center₂ : H) (radius₁ radius₂ : ℝ) : ℝ :=
  max 0 (dist center₁ center₂ - radius₁ - radius₂)

/-- `BG-HILBERT-THM-001`: two nonnegative-radius Hilbert-space balls intersect exactly
when their center distance is at most the sum of their radii. -/
theorem hilbertAdmissibleBalls_inter_nonempty_iff
    {center₁ center₂ : H} {radius₁ radius₂ : ℝ}
    (hradius₁ : 0 ≤ radius₁) (hradius₂ : 0 ≤ radius₂) :
    (hilbertAdmissibleBall center₁ radius₁ ∩
      hilbertAdmissibleBall center₂ radius₂).Nonempty ↔
      dist center₁ center₂ ≤ radius₁ + radius₂ := by
  constructor
  · rintro ⟨x, hx₁, hx₂⟩
    have htriangle : dist center₁ center₂ ≤ dist center₁ x + dist x center₂ :=
      dist_triangle center₁ x center₂
    have hx₁' : dist center₁ x ≤ radius₁ := by
      simpa [hilbertAdmissibleBall, dist_comm] using hx₁
    have hx₂' : dist x center₂ ≤ radius₂ := by
      simpa [hilbertAdmissibleBall] using hx₂
    linarith
  · intro hcenters
    by_cases hinside : dist center₁ center₂ ≤ radius₁
    · refine ⟨center₂, ?_, ?_⟩
      · simpa [hilbertAdmissibleBall, dist_comm] using hinside
      · simpa [hilbertAdmissibleBall] using hradius₂
    · have hdistPos : 0 < dist center₁ center₂ :=
        lt_of_le_of_lt hradius₁ (lt_of_not_ge hinside)
      let t : ℝ := radius₁ / dist center₁ center₂
      let x : H := AffineMap.lineMap center₁ center₂ t
      have htNonneg : 0 ≤ t := div_nonneg hradius₁ hdistPos.le
      have htLe : t ≤ 1 := by
        exact (div_le_one hdistPos).2 (le_of_not_ge hinside)
      have hleft : dist x center₁ = radius₁ := by
        change dist (AffineMap.lineMap center₁ center₂ t) center₁ = radius₁
        rw [dist_lineMap_left]
        rw [Real.norm_eq_abs, abs_of_nonneg htNonneg]
        exact div_mul_cancel₀ radius₁ hdistPos.ne'
      have hright : dist x center₂ = dist center₁ center₂ - radius₁ := by
        change dist (AffineMap.lineMap center₁ center₂ t) center₂ = _
        rw [dist_lineMap_right]
        rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.2 htLe)]
        dsimp [t]
        field_simp
      refine ⟨x, ?_, ?_⟩
      · change dist x center₁ ≤ radius₁
        exact hleft.le
      · change dist x center₂ ≤ radius₂
        rw [hright]
        linarith

omit instHilbert in
/-- `BG-HILBERT-THM-002`: the closed formula is a lower bound for every pairwise
distance between the two balls. This lower-bound direction only needs the underlying
metric geometry. -/
theorem hilbertBallDistance_le_dist_of_mem
    {center₁ center₂ : H} {radius₁ radius₂ : ℝ}
    {x y : H}
    (hx : x ∈ hilbertAdmissibleBall center₁ radius₁)
    (hy : y ∈ hilbertAdmissibleBall center₂ radius₂) :
    hilbertBallDistance center₁ center₂ radius₁ radius₂ ≤ dist x y := by
  have hpath : dist center₁ center₂ ≤
      dist center₁ x + dist x y + dist y center₂ := by
    calc
      dist center₁ center₂ ≤ dist center₁ x + dist x center₂ :=
        dist_triangle center₁ x center₂
      _ ≤ dist center₁ x + (dist x y + dist y center₂) := by
        simpa [add_comm, add_left_comm, add_assoc] using
          add_le_add_left (dist_triangle x y center₂) (dist center₁ x)
      _ = dist center₁ x + dist x y + dist y center₂ := by ring
  have hx' : dist center₁ x ≤ radius₁ := by
    simpa [hilbertAdmissibleBall, dist_comm] using hx
  have hy' : dist y center₂ ≤ radius₂ := by
    simpa [hilbertAdmissibleBall] using hy
  rw [hilbertBallDistance]
  apply max_le dist_nonneg
  linarith

/-- `BG-HILBERT-THM-003`: points in the two balls attain the closed distance formula. -/
theorem exists_hilbertBallDistance_eq_dist
    {center₁ center₂ : H} {radius₁ radius₂ : ℝ}
    (hradius₁ : 0 ≤ radius₁) (hradius₂ : 0 ≤ radius₂) :
    ∃ x ∈ hilbertAdmissibleBall center₁ radius₁,
      ∃ y ∈ hilbertAdmissibleBall center₂ radius₂,
        dist x y = hilbertBallDistance center₁ center₂ radius₁ radius₂ := by
  by_cases hcompatible : dist center₁ center₂ ≤ radius₁ + radius₂
  · obtain ⟨x, hx₁, hx₂⟩ :=
      (hilbertAdmissibleBalls_inter_nonempty_iff hradius₁ hradius₂).2 hcompatible
    have hformula : hilbertBallDistance center₁ center₂ radius₁ radius₂ = 0 := by
      rw [hilbertBallDistance, max_eq_left]
      linarith
    exact ⟨x, hx₁, x, hx₂, by simp [hformula]⟩
  · have hseparated : radius₁ + radius₂ < dist center₁ center₂ :=
      lt_of_not_ge hcompatible
    have hdistPos : 0 < dist center₁ center₂ := by linarith
    let tx : ℝ := radius₁ / dist center₁ center₂
    let ty : ℝ := 1 - radius₂ / dist center₁ center₂
    let x : H := AffineMap.lineMap center₁ center₂ tx
    let y : H := AffineMap.lineMap center₁ center₂ ty
    have htxNonneg : 0 ≤ tx := div_nonneg hradius₁ hdistPos.le
    have htxLe : tx ≤ 1 := by
      apply (div_le_one hdistPos).2
      linarith
    have htyLe : ty ≤ 1 := by
      dsimp [ty]
      exact sub_le_self _ (div_nonneg hradius₂ hdistPos.le)
    have htyNonneg : 0 ≤ ty := by
      dsimp [ty]
      apply sub_nonneg.2
      apply (div_le_one hdistPos).2
      linarith
    have hxyOrder : tx ≤ ty := by
      dsimp [tx, ty]
      apply (div_le_iff₀ hdistPos).2
      field_simp
      linarith
    have hxCenter : dist x center₁ = radius₁ := by
      change dist (AffineMap.lineMap center₁ center₂ tx) center₁ = radius₁
      rw [dist_lineMap_left]
      rw [Real.norm_eq_abs, abs_of_nonneg htxNonneg]
      exact div_mul_cancel₀ radius₁ hdistPos.ne'
    have hyCenter : dist y center₂ = radius₂ := by
      change dist (AffineMap.lineMap center₁ center₂ ty) center₂ = radius₂
      rw [dist_lineMap_right]
      rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.2 htyLe)]
      dsimp [ty]
      have : 1 - (1 - radius₂ / dist center₁ center₂) =
          radius₂ / dist center₁ center₂ := by ring
      rw [this]
      exact div_mul_cancel₀ radius₂ hdistPos.ne'
    have hxy : dist x y = dist center₁ center₂ - radius₁ - radius₂ := by
      change dist (AffineMap.lineMap center₁ center₂ tx)
        (AffineMap.lineMap center₁ center₂ ty) = _
      rw [dist_lineMap_lineMap]
      rw [Real.dist_eq, abs_of_nonpos (sub_nonpos.2 hxyOrder)]
      dsimp [tx, ty]
      field_simp
      ring
    have hformula : hilbertBallDistance center₁ center₂ radius₁ radius₂ =
        dist center₁ center₂ - radius₁ - radius₂ := by
      rw [hilbertBallDistance, max_eq_right]
      linarith
    refine ⟨x, ?_, y, ?_, ?_⟩
    · change dist x center₁ ≤ radius₁
      exact hxCenter.le
    · change dist y center₂ ≤ radius₂
      exact hyCenter.le
    · rw [hxy, hformula]

/-- `BG-HILBERT-THM-004`: the real admissible-set distance between two nonnegative-radius
Hilbert-space balls is the closed center-gap formula. -/
theorem hilbertAdmissibleBall_admissibleSetDist_eq
    {center₁ center₂ : H} {radius₁ radius₂ : ℝ}
    (hradius₁ : 0 ≤ radius₁) (hradius₂ : 0 ≤ radius₂) :
    ProjectKoios.BandGauge.Geometry.admissibleSetDist
      (hilbertAdmissibleBall center₁ radius₁)
      (hilbertAdmissibleBall center₂ radius₂)
      (by exact ⟨center₁, by simp [hilbertAdmissibleBall, hradius₁]⟩)
      (by exact ⟨center₂, by simp [hilbertAdmissibleBall, hradius₂]⟩) =
        hilbertBallDistance center₁ center₂ radius₁ radius₂ := by
  let A := hilbertAdmissibleBall center₁ radius₁
  let B := hilbertAdmissibleBall center₂ radius₂
  have hA : A.Nonempty := ⟨center₁, by simp [A, hilbertAdmissibleBall, hradius₁]⟩
  have hB : B.Nonempty := ⟨center₂, by simp [B, hilbertAdmissibleBall, hradius₂]⟩
  obtain ⟨x, hx, y, hy, hdist⟩ :=
    exists_hilbertBallDistance_eq_dist
      (center₁ := center₁) (center₂ := center₂) hradius₁ hradius₂
  have hformulaNonneg :
      0 ≤ hilbertBallDistance center₁ center₂ radius₁ radius₂ := le_max_left _ _
  have hedist :
      ProjectKoios.BandGauge.Geometry.admissibleSetEDist A B =
        ENNReal.ofReal (hilbertBallDistance center₁ center₂ radius₁ radius₂) := by
    apply le_antisymm
    · have hupper :=
        ProjectKoios.BandGauge.Geometry.admissibleSetEDist_le_edist_of_mem hx hy
      simpa [A, B, edist_dist, hdist] using hupper
    · rw [ProjectKoios.BandGauge.Geometry.admissibleSetEDist]
      refine le_iInf fun x' => le_iInf fun hx' =>
        le_iInf fun y' => le_iInf fun hy' => ?_
      rw [edist_dist]
      exact ENNReal.ofReal_le_ofReal
        (hilbertBallDistance_le_dist_of_mem hx' hy')
  unfold ProjectKoios.BandGauge.Geometry.admissibleSetDist
  change ENNReal.toReal
    (ProjectKoios.BandGauge.Geometry.admissibleSetEDist A B) = _
  rw [hedist, ENNReal.toReal_ofReal hformulaNonneg]

end ProjectKoios.BandGauge.Hilbert

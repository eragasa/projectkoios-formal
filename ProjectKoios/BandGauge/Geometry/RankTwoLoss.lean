module

public import ProjectKoios.BandGauge.Geometry.AdmissibleSets
public import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Tactic.Linarith

/-!
# Reduced rank-two loss geometry

This module encodes the scalar quadratic loss formulas used by the audited rank-two
model family. It proves consequences of those formulas; it does not derive them from the
underlying matrix residuals or prove the normalized-correlation bound.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Geometry

/-- The paper's Euclidean parameter plane for the shift and positive splitting-scale
coordinates `(s, λ)`. Domain restrictions such as `λ > 0` are imposed separately. -/
abbrev RankTwoParameter := EuclideanSpace ℝ (Fin 2)

/-- The reduced spectral squared loss `s² + κ(λ - 1)²`. -/
def rankTwoSpectralLossSq (κ : ℝ) (p : RankTwoParameter) : ℝ :=
  (p 0) ^ 2 + κ * (p 1 - 1) ^ 2

/-- The reduced aligned-operator squared loss
`s² + κ(λ - μ)² + κ(1 - μ²)` for one normalized correlation `μ`. -/
def rankTwoAlignedOperatorLossSq (κ μ : ℝ) (p : RankTwoParameter) : ℝ :=
  (p 0) ^ 2 + κ * (p 1 - μ) ^ 2 + κ * (1 - μ ^ 2)

/-- For nonnegative splitting curvature, the reduced aligned-operator squared loss is at
least its irreducible floor `κ(1 - μ²)`. -/
theorem irreducibleOperatorFloor_le_rankTwoAlignedOperatorLossSq
    {κ μ : ℝ} (hκ : 0 ≤ κ) (p : RankTwoParameter) :
    κ * (1 - μ ^ 2) ≤ rankTwoAlignedOperatorLossSq κ μ p := by
  unfold rankTwoAlignedOperatorLossSq
  nlinarith [sq_nonneg (p 0), mul_nonneg hκ (sq_nonneg (p 1 - μ))]

/-- If the squared operator budget is strictly below the irreducible floor, the reduced
aligned-operator admissible set is empty. -/
theorem rankTwoAlignedOperatorAdmissibleSet_eq_empty_of_sq_lt_floor
    {κ μ operatorBudget : ℝ} (hκ : 0 ≤ κ)
    (hbelow : operatorBudget ^ 2 < κ * (1 - μ ^ 2)) :
    alignedOperatorAdmissibleSet
      (rankTwoAlignedOperatorLossSq κ μ) (operatorBudget ^ 2) = ∅ := by
  apply Set.eq_empty_iff_forall_notMem.2
  intro p hp
  have hlower :=
    irreducibleOperatorFloor_le_rankTwoAlignedOperatorLossSq (μ := μ) hκ p
  exact (not_le_of_gt hbelow) (hlower.trans hp)

/-- The scalar correlation normalized by the positive splitting scale. The matrix-residual
layer is responsible for supplying the correlation bound used below. -/
noncomputable def rankTwoNormalizedCorrelation (κ b : ℝ) : ℝ :=
  b / κ

/-- A correlation whose magnitude does not exceed a positive splitting scale has
normalized magnitude at most one. -/
theorem abs_rankTwoNormalizedCorrelation_le_one
    {κ b : ℝ} (hκ : 0 < κ) (hb : |b| ≤ κ) :
    |rankTwoNormalizedCorrelation κ b| ≤ 1 := by
  rw [rankTwoNormalizedCorrelation, abs_div, abs_of_pos hκ]
  exact (div_le_one hκ).2 hb

/-- Nonnegative splitting curvature and a normalized correlation of magnitude at most
one make the irreducible operator floor nonnegative. -/
theorem rankTwoIrreducibleOperatorFloor_nonneg
    {κ μ : ℝ} (hκ : 0 ≤ κ) (hμ : |μ| ≤ 1) :
    0 ≤ κ * (1 - μ ^ 2) := by
  have hsqAbs : |μ| ^ 2 ≤ (1 : ℝ) ^ 2 :=
    (sq_le_sq₀ (abs_nonneg μ) zero_le_one).2 hμ
  have hsq : μ ^ 2 ≤ 1 := by simpa using hsqAbs
  exact mul_nonneg hκ (sub_nonneg.2 hsq)

/-- Under the same scalar bounds, the reduced aligned-operator squared loss is
nonnegative at every parameter point. -/
theorem rankTwoAlignedOperatorLossSq_nonneg
    {κ μ : ℝ} (hκ : 0 ≤ κ) (hμ : |μ| ≤ 1) (p : RankTwoParameter) :
    0 ≤ rankTwoAlignedOperatorLossSq κ μ p := by
  exact (rankTwoIrreducibleOperatorFloor_nonneg hκ hμ).trans
    (irreducibleOperatorFloor_le_rankTwoAlignedOperatorLossSq hκ p)

end ProjectKoios.BandGauge.Geometry

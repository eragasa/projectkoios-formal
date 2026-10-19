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

/-- Nonnegative splitting curvature makes the reduced spectral squared loss
nonnegative at every parameter point. -/
theorem rankTwoSpectralLossSq_nonneg
    {κ : ℝ} (hκ : 0 ≤ κ) (p : RankTwoParameter) :
    0 ≤ rankTwoSpectralLossSq κ p := by
  exact add_nonneg (sq_nonneg (p 0)) (mul_nonneg hκ (sq_nonneg (p 1 - 1)))

/-- The nonnegative real spectral loss obtained from the reduced squared-loss formula. -/
noncomputable def rankTwoSpectralLoss (κ : ℝ) (p : RankTwoParameter) : ℝ :=
  Real.sqrt (rankTwoSpectralLossSq κ p)

/-- The nonnegative real aligned-operator loss obtained from the reduced squared-loss
formula. -/
noncomputable def rankTwoAlignedOperatorLoss (κ μ : ℝ) (p : RankTwoParameter) : ℝ :=
  Real.sqrt (rankTwoAlignedOperatorLossSq κ μ p)

/-- Under nonnegative splitting curvature, squaring the real spectral loss recovers its
reduced squared-loss formula. -/
theorem rankTwoSpectralLoss_sq
    {κ : ℝ} (hκ : 0 ≤ κ) (p : RankTwoParameter) :
    rankTwoSpectralLoss κ p ^ 2 = rankTwoSpectralLossSq κ p := by
  exact Real.sq_sqrt (rankTwoSpectralLossSq_nonneg hκ p)

/-- Under the scalar curvature and correlation bounds, squaring the real aligned-operator
loss recovers its reduced squared-loss formula. -/
theorem rankTwoAlignedOperatorLoss_sq
    {κ μ : ℝ} (hκ : 0 ≤ κ) (hμ : |μ| ≤ 1) (p : RankTwoParameter) :
    rankTwoAlignedOperatorLoss κ μ p ^ 2 =
      rankTwoAlignedOperatorLossSq κ μ p := by
  exact Real.sq_sqrt (rankTwoAlignedOperatorLossSq_nonneg hκ hμ p)

/-- For a nonnegative budget, the spectral real-loss threshold is equivalent to the
corresponding squared-loss threshold. -/
theorem rankTwoSpectralLoss_le_iff_sq_le_sq
    {κ spectralBudget : ℝ} (hκ : 0 ≤ κ) (hBudget : 0 ≤ spectralBudget)
    (p : RankTwoParameter) :
    rankTwoSpectralLoss κ p ≤ spectralBudget ↔
      rankTwoSpectralLossSq κ p ≤ spectralBudget ^ 2 := by
  constructor
  · intro h
    calc
      rankTwoSpectralLossSq κ p = rankTwoSpectralLoss κ p ^ 2 :=
        (rankTwoSpectralLoss_sq hκ p).symm
      _ ≤ spectralBudget ^ 2 :=
        (sq_le_sq₀ (Real.sqrt_nonneg _) hBudget).2 h
  · intro h
    apply (sq_le_sq₀ (Real.sqrt_nonneg _) hBudget).1
    calc
      rankTwoSpectralLoss κ p ^ 2 = rankTwoSpectralLossSq κ p :=
        rankTwoSpectralLoss_sq hκ p
      _ ≤ spectralBudget ^ 2 := h

/-- For a nonnegative budget, the aligned-operator real-loss threshold is equivalent to
the corresponding squared-loss threshold. -/
theorem rankTwoAlignedOperatorLoss_le_iff_sq_le_sq
    {κ μ operatorBudget : ℝ} (hκ : 0 ≤ κ) (hμ : |μ| ≤ 1)
    (hBudget : 0 ≤ operatorBudget) (p : RankTwoParameter) :
    rankTwoAlignedOperatorLoss κ μ p ≤ operatorBudget ↔
      rankTwoAlignedOperatorLossSq κ μ p ≤ operatorBudget ^ 2 := by
  constructor
  · intro h
    calc
      rankTwoAlignedOperatorLossSq κ μ p =
          rankTwoAlignedOperatorLoss κ μ p ^ 2 :=
        (rankTwoAlignedOperatorLoss_sq hκ hμ p).symm
      _ ≤ operatorBudget ^ 2 :=
        (sq_le_sq₀ (Real.sqrt_nonneg _) hBudget).2 h
  · intro h
    apply (sq_le_sq₀ (Real.sqrt_nonneg _) hBudget).1
    calc
      rankTwoAlignedOperatorLoss κ μ p ^ 2 =
          rankTwoAlignedOperatorLossSq κ μ p :=
        rankTwoAlignedOperatorLoss_sq hκ hμ p
      _ ≤ operatorBudget ^ 2 := h

/-- The operator ellipse radius obtained after subtracting the irreducible floor from the
squared operator budget. -/
noncomputable def rankTwoOperatorRadius (κ μ operatorBudget : ℝ) : ℝ :=
  Real.sqrt (operatorBudget ^ 2 - κ * (1 - μ ^ 2))

/-- The real spectral-loss sublevel condition is exactly the corresponding ellipse
inequality in the shift/splitting-scale plane. -/
theorem rankTwoSpectralLoss_le_iff_ellipse
    {κ spectralBudget : ℝ} (hκ : 0 ≤ κ) (hBudget : 0 ≤ spectralBudget)
    (p : RankTwoParameter) :
    rankTwoSpectralLoss κ p ≤ spectralBudget ↔
      (p 0) ^ 2 + κ * (p 1 - 1) ^ 2 ≤ spectralBudget ^ 2 := by
  simpa only [rankTwoSpectralLossSq] using
    rankTwoSpectralLoss_le_iff_sq_le_sq hκ hBudget p

/-- When the operator-radius radicand is nonnegative, squaring the radius recovers that
radicand. -/
theorem rankTwoOperatorRadius_sq
    {κ μ operatorBudget : ℝ}
    (hRadicand : κ * (1 - μ ^ 2) ≤ operatorBudget ^ 2) :
    rankTwoOperatorRadius κ μ operatorBudget ^ 2 =
      operatorBudget ^ 2 - κ * (1 - μ ^ 2) := by
  exact Real.sq_sqrt (sub_nonneg.2 hRadicand)

/-- Under the scalar bounds and a nonnegative radius radicand, the real aligned-operator
sublevel condition is exactly the corresponding centered ellipse inequality. -/
theorem rankTwoAlignedOperatorLoss_le_iff_ellipse
    {κ μ operatorBudget : ℝ} (hκ : 0 ≤ κ) (hμ : |μ| ≤ 1)
    (hBudget : 0 ≤ operatorBudget)
    (hRadicand : κ * (1 - μ ^ 2) ≤ operatorBudget ^ 2)
    (p : RankTwoParameter) :
    rankTwoAlignedOperatorLoss κ μ p ≤ operatorBudget ↔
      (p 0) ^ 2 + κ * (p 1 - μ) ^ 2 ≤
        rankTwoOperatorRadius κ μ operatorBudget ^ 2 := by
  rw [rankTwoAlignedOperatorLoss_le_iff_sq_le_sq hκ hμ hBudget p,
    rankTwoOperatorRadius_sq hRadicand]
  simp only [rankTwoAlignedOperatorLossSq]
  constructor <;> intro h <;> linarith

/-- The full spectral ellipse before intersection with any declared parameter
rectangle. -/
def rankTwoFullSpectralEllipse (κ spectralBudget : ℝ) : Set RankTwoParameter :=
  {p | (p 0) ^ 2 + κ * (p 1 - 1) ^ 2 ≤ spectralBudget ^ 2}

/-- The full aligned-operator ellipse with supplied radius, before intersection with any
declared parameter rectangle. -/
def rankTwoFullOperatorEllipse (κ μ operatorRadius : ℝ) : Set RankTwoParameter :=
  {p | (p 0) ^ 2 + κ * (p 1 - μ) ^ 2 ≤ operatorRadius ^ 2}

/-- A common point of the two full ellipses forces the scaled center separation to be no
larger than the sum of their radii. -/
theorem sqrt_mul_abs_centerSeparation_le_add_of_mem_rankTwoFullEllipses
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius) {p : RankTwoParameter}
    (hpSpectral : p ∈ rankTwoFullSpectralEllipse κ spectralBudget)
    (hpOperator : p ∈ rankTwoFullOperatorEllipse κ μ operatorRadius) :
    Real.sqrt κ * |1 - μ| ≤ spectralBudget + operatorRadius := by
  have hsSq : (Real.sqrt κ * |p 1 - 1|) ^ 2 ≤ spectralBudget ^ 2 := by
    rw [mul_pow, Real.sq_sqrt hκ.le, sq_abs]
    exact (le_add_of_nonneg_left (sq_nonneg (p 0))).trans hpSpectral
  have hs : Real.sqrt κ * |p 1 - 1| ≤ spectralBudget :=
    (sq_le_sq₀ (mul_nonneg (Real.sqrt_nonneg κ) (abs_nonneg _))
      hSpectralBudget).1 hsSq
  have hoSq : (Real.sqrt κ * |p 1 - μ|) ^ 2 ≤ operatorRadius ^ 2 := by
    rw [mul_pow, Real.sq_sqrt hκ.le, sq_abs]
    exact (le_add_of_nonneg_left (sq_nonneg (p 0))).trans hpOperator
  have ho : Real.sqrt κ * |p 1 - μ| ≤ operatorRadius :=
    (sq_le_sq₀ (mul_nonneg (Real.sqrt_nonneg κ) (abs_nonneg _))
      hOperatorRadius).1 hoSq
  have hdecomp : 1 - μ = (1 - p 1) + (p 1 - μ) := by ring
  rw [hdecomp]
  calc
    Real.sqrt κ * |(1 - p 1) + (p 1 - μ)| ≤
        Real.sqrt κ * (|1 - p 1| + |p 1 - μ|) :=
      mul_le_mul_of_nonneg_left (abs_add_le _ _) (Real.sqrt_nonneg κ)
    _ = Real.sqrt κ * |p 1 - 1| + Real.sqrt κ * |p 1 - μ| := by
      rw [abs_sub_comm (1 : ℝ) (p 1)]
      ring
    _ ≤ spectralBudget + operatorRadius := add_le_add hs ho

/-- If the sum of the two full-ellipse radii is strictly smaller than their scaled center
separation, the full ellipses are disjoint. -/
theorem disjoint_rankTwoFullEllipses_of_add_lt_sqrt_mul_abs_centerSeparation
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius)
    (hseparated : spectralBudget + operatorRadius < Real.sqrt κ * |1 - μ|) :
    Disjoint (rankTwoFullSpectralEllipse κ spectralBudget)
      (rankTwoFullOperatorEllipse κ μ operatorRadius) := by
  rw [Set.disjoint_left]
  intro p hpSpectral hpOperator
  have hcompatible :=
    sqrt_mul_abs_centerSeparation_le_add_of_mem_rankTwoFullEllipses
      hκ hSpectralBudget hOperatorRadius hpSpectral hpOperator
  exact (not_lt_of_ge hcompatible) hseparated

/-- The full-ellipse compatibility bound constructs a common point of the spectral and
operator ellipses. -/
theorem rankTwoFullEllipses_inter_nonempty_of_sqrt_mul_abs_centerSeparation_le_add
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius)
    (hcompatible : Real.sqrt κ * |1 - μ| ≤ spectralBudget + operatorRadius) :
    (rankTwoFullSpectralEllipse κ spectralBudget ∩
      rankTwoFullOperatorEllipse κ μ operatorRadius).Nonempty := by
  let t := Real.sqrt κ
  have ht : 0 < t := Real.sqrt_pos.2 hκ
  let a := spectralBudget / t
  let b := operatorRadius / t
  have ha : 0 ≤ a := div_nonneg hSpectralBudget ht.le
  have hb : 0 ≤ b := div_nonneg hOperatorRadius ht.le
  have hcenterRaw : |1 - μ| ≤ (spectralBudget + operatorRadius) / t := by
    apply (le_div_iff₀ ht).2
    simpa [t, mul_comm] using hcompatible
  have hcenter : |1 - μ| ≤ a + b := by
    simpa [a, b, add_div] using hcenterRaw
  have hcenterBounds := (abs_le.1 hcenter)
  let lambda := max (1 - a) (μ - b)
  have hLowerSpectral : 1 - a ≤ lambda := le_max_left _ _
  have hLowerOperator : μ - b ≤ lambda := le_max_right _ _
  have hUpperSpectral : lambda ≤ 1 + a := by
    apply max_le
    · linarith
    · linarith [hcenterBounds.1]
  have hUpperOperator : lambda ≤ μ + b := by
    apply max_le
    · linarith [hcenterBounds.2]
    · linarith
  have hSpectralAbs : |lambda - 1| ≤ a :=
    abs_le.2 ⟨by linarith, by linarith⟩
  have hOperatorAbs : |lambda - μ| ≤ b :=
    abs_le.2 ⟨by linarith, by linarith⟩
  have hta : t * a = spectralBudget := by
    dsimp [a]
    exact mul_div_cancel₀ spectralBudget ht.ne'
  have htb : t * b = operatorRadius := by
    dsimp [b]
    exact mul_div_cancel₀ operatorRadius ht.ne'
  have hSpectralScaled : t * |lambda - 1| ≤ spectralBudget := by
    calc
      t * |lambda - 1| ≤ t * a := mul_le_mul_of_nonneg_left hSpectralAbs ht.le
      _ = spectralBudget := hta
  have hOperatorScaled : t * |lambda - μ| ≤ operatorRadius := by
    calc
      t * |lambda - μ| ≤ t * b := mul_le_mul_of_nonneg_left hOperatorAbs ht.le
      _ = operatorRadius := htb
  have hSpectralEllipse : κ * (lambda - 1) ^ 2 ≤ spectralBudget ^ 2 := by
    have hsquared :=
      (sq_le_sq₀ (mul_nonneg ht.le (abs_nonneg _)) hSpectralBudget).2
        hSpectralScaled
    dsimp [t] at hsquared
    rw [mul_pow, sq_abs, Real.sq_sqrt hκ.le] at hsquared
    exact hsquared
  have hOperatorEllipse : κ * (lambda - μ) ^ 2 ≤ operatorRadius ^ 2 := by
    have hsquared :=
      (sq_le_sq₀ (mul_nonneg ht.le (abs_nonneg _)) hOperatorRadius).2
        hOperatorScaled
    dsimp [t] at hsquared
    rw [mul_pow, sq_abs, Real.sq_sqrt hκ.le] at hsquared
    exact hsquared
  let p : RankTwoParameter := EuclideanSpace.single (1 : Fin 2) lambda
  refine ⟨p, ?_, ?_⟩
  · simpa [rankTwoFullSpectralEllipse, p] using hSpectralEllipse
  · simpa [rankTwoFullOperatorEllipse, p] using hOperatorEllipse

/-- The two full rank-two ellipses intersect exactly when their scaled center separation
is no larger than the sum of their radii. -/
theorem rankTwoFullEllipses_inter_nonempty_iff
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius) :
    (rankTwoFullSpectralEllipse κ spectralBudget ∩
      rankTwoFullOperatorEllipse κ μ operatorRadius).Nonempty ↔
      Real.sqrt κ * |1 - μ| ≤ spectralBudget + operatorRadius := by
  constructor
  · rintro ⟨p, hpSpectral, hpOperator⟩
    exact sqrt_mul_abs_centerSeparation_le_add_of_mem_rankTwoFullEllipses
      hκ hSpectralBudget hOperatorRadius hpSpectral hpOperator
  · exact rankTwoFullEllipses_inter_nonempty_of_sqrt_mul_abs_centerSeparation_le_add
      hκ hSpectralBudget hOperatorRadius

/-- The actual reduced real-loss admissible sets have a common point exactly when the
full-ellipse compatibility inequality holds with the operator radius. -/
theorem rankTwoLossAdmissibleSets_inter_nonempty_iff
    {κ μ spectralBudget operatorBudget : ℝ}
    (hκ : 0 < κ) (hμ : |μ| ≤ 1)
    (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorBudget : 0 ≤ operatorBudget)
    (hRadicand : κ * (1 - μ ^ 2) ≤ operatorBudget ^ 2) :
    (spectralAdmissibleSet (rankTwoSpectralLoss κ) spectralBudget ∩
      alignedOperatorAdmissibleSet
        (rankTwoAlignedOperatorLoss κ μ) operatorBudget).Nonempty ↔
      Real.sqrt κ * |1 - μ| ≤
        spectralBudget + rankTwoOperatorRadius κ μ operatorBudget := by
  constructor
  · rintro ⟨p, hpSpectral, hpOperator⟩
    apply sqrt_mul_abs_centerSeparation_le_add_of_mem_rankTwoFullEllipses
      hκ hSpectralBudget (Real.sqrt_nonneg _)
    · exact (rankTwoSpectralLoss_le_iff_ellipse hκ.le hSpectralBudget p).1 hpSpectral
    · exact (rankTwoAlignedOperatorLoss_le_iff_ellipse
        hκ.le hμ hOperatorBudget hRadicand p).1 hpOperator
  · intro hcompatible
    obtain ⟨p, hpSpectral, hpOperator⟩ :=
      rankTwoFullEllipses_inter_nonempty_of_sqrt_mul_abs_centerSeparation_le_add
        hκ hSpectralBudget (Real.sqrt_nonneg _) hcompatible
    refine ⟨p, ?_, ?_⟩
    · exact (rankTwoSpectralLoss_le_iff_ellipse hκ.le hSpectralBudget p).2 hpSpectral
    · exact (rankTwoAlignedOperatorLoss_le_iff_ellipse
        hκ.le hμ hOperatorBudget hRadicand p).2 hpOperator

/-- The exact Euclidean-distance formula for the two full ellipses. -/
noncomputable def rankTwoFullEllipseDistance
    (κ μ spectralBudget operatorRadius : ℝ) : ℝ :=
  max 0 (|1 - μ| - (spectralBudget + operatorRadius) / Real.sqrt κ)

/-- Every pair drawn from the two full ellipses has Euclidean distance at least the
claimed full-ellipse distance formula. -/
theorem rankTwoFullEllipseDistance_le_dist_of_mem
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius)
    {p q : RankTwoParameter}
    (hp : p ∈ rankTwoFullSpectralEllipse κ spectralBudget)
    (hq : q ∈ rankTwoFullOperatorEllipse κ μ operatorRadius) :
    rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius ≤ dist p q := by
  let t := Real.sqrt κ
  have ht : 0 < t := Real.sqrt_pos.2 hκ
  have hpSq : (t * |p 1 - 1|) ^ 2 ≤ spectralBudget ^ 2 := by
    dsimp [t]
    rw [mul_pow, Real.sq_sqrt hκ.le, sq_abs]
    exact (le_add_of_nonneg_left (sq_nonneg (p 0))).trans hp
  have hpScaled : t * |p 1 - 1| ≤ spectralBudget :=
    (sq_le_sq₀ (mul_nonneg ht.le (abs_nonneg _)) hSpectralBudget).1 hpSq
  have hqSq : (t * |q 1 - μ|) ^ 2 ≤ operatorRadius ^ 2 := by
    dsimp [t]
    rw [mul_pow, Real.sq_sqrt hκ.le, sq_abs]
    exact (le_add_of_nonneg_left (sq_nonneg (q 0))).trans hq
  have hqScaled : t * |q 1 - μ| ≤ operatorRadius :=
    (sq_le_sq₀ (mul_nonneg ht.le (abs_nonneg _)) hOperatorRadius).1 hqSq
  have hpUnscaled : |1 - p 1| ≤ spectralBudget / t := by
    apply (le_div_iff₀ ht).2
    simpa [abs_sub_comm, mul_comm] using hpScaled
  have hqUnscaled : |q 1 - μ| ≤ operatorRadius / t := by
    exact (le_div_iff₀ ht).2 (by simpa [mul_comm] using hqScaled)
  have hpath : |1 - μ| ≤ |1 - p 1| + |p 1 - q 1| + |q 1 - μ| := by
    calc
      |1 - μ| ≤ |1 - p 1| + |p 1 - μ| := abs_sub_le _ _ _
      _ ≤ |1 - p 1| + (|p 1 - q 1| + |q 1 - μ|) :=
        add_le_add (le_refl _) (abs_sub_le _ _ _)
      _ = |1 - p 1| + |p 1 - q 1| + |q 1 - μ| := by ring
  have hgap : |1 - μ| - (spectralBudget + operatorRadius) / t ≤
      |p 1 - q 1| := by
    rw [add_div]
    linarith
  have hcoord : |p 1 - q 1| ≤ dist p q := by
    apply (sq_le_sq₀ (abs_nonneg _) dist_nonneg).1
    rw [EuclideanSpace.dist_sq_eq]
    simp only [Fin.sum_univ_two, Real.dist_eq, sq_abs]
    exact le_add_of_nonneg_left (sq_nonneg (p 0 - q 0))
  rw [rankTwoFullEllipseDistance]
  apply max_le dist_nonneg
  simpa [t] using hgap.trans hcoord

/-- A pair of points on the two full ellipses attains the claimed Euclidean-distance
formula. -/
theorem exists_rankTwoFullEllipseDistance_eq_dist
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius) :
    ∃ p ∈ rankTwoFullSpectralEllipse κ spectralBudget,
      ∃ q ∈ rankTwoFullOperatorEllipse κ μ operatorRadius,
        dist p q = rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius := by
  let t := Real.sqrt κ
  have ht : 0 < t := Real.sqrt_pos.2 hκ
  by_cases hcompatible : t * |1 - μ| ≤ spectralBudget + operatorRadius
  · obtain ⟨p, hpSpectral, hpOperator⟩ :=
      rankTwoFullEllipses_inter_nonempty_of_sqrt_mul_abs_centerSeparation_le_add
        hκ hSpectralBudget hOperatorRadius (by simpa [t] using hcompatible)
    have hgapNonpos :
        |1 - μ| - (spectralBudget + operatorRadius) / t ≤ 0 := by
      apply sub_nonpos.2
      exact (le_div_iff₀ ht).2 (by simpa [mul_comm] using hcompatible)
    have hformula : rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius = 0 := by
      rw [rankTwoFullEllipseDistance, max_eq_left]
      simpa [t] using hgapNonpos
    exact ⟨p, hpSpectral, p, hpOperator, by simp [hformula]⟩
  · have hseparated : spectralBudget + operatorRadius < t * |1 - μ| :=
      lt_of_not_ge hcompatible
    have hgapPos : 0 < |1 - μ| - (spectralBudget + operatorRadius) / t := by
      apply sub_pos.2
      exact (div_lt_iff₀ ht).2 (by simpa [mul_comm] using hseparated)
    have hformula : rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius =
        |1 - μ| - (spectralBudget + operatorRadius) / t := by
      rw [rankTwoFullEllipseDistance, max_eq_right]
      simpa [t] using hgapPos.le
    let a := spectralBudget / t
    let b := operatorRadius / t
    have hta : t * a = spectralBudget := by
      dsimp [a]
      exact mul_div_cancel₀ spectralBudget ht.ne'
    have htb : t * b = operatorRadius := by
      dsimp [b]
      exact mul_div_cancel₀ operatorRadius ht.ne'
    have htSq : t ^ 2 = κ := by
      simpa [t] using Real.sq_sqrt hκ.le
    have haSq : κ * a ^ 2 = spectralBudget ^ 2 := by
      calc
        κ * a ^ 2 = t ^ 2 * a ^ 2 := by rw [htSq]
        _ = (t * a) ^ 2 := by ring
        _ = spectralBudget ^ 2 := by rw [hta]
    have hbSq : κ * b ^ 2 = operatorRadius ^ 2 := by
      calc
        κ * b ^ 2 = t ^ 2 * b ^ 2 := by rw [htSq]
        _ = (t * b) ^ 2 := by ring
        _ = operatorRadius ^ 2 := by rw [htb]
    have hab : a + b = (spectralBudget + operatorRadius) / t := by
      simp [a, b, add_div]
    have hsingleDist (x y : ℝ) :
        dist (EuclideanSpace.single (1 : Fin 2) x : RankTwoParameter)
          (EuclideanSpace.single (1 : Fin 2) y) = |x - y| := by
      rw [EuclideanSpace.dist_eq]
      simp [Fin.sum_univ_two, Real.dist_eq, Real.sqrt_sq_eq_abs]
    by_cases horder : 1 ≤ μ
    · have hmuAbs : |1 - μ| = μ - 1 := by
        calc
          |1 - μ| = -(1 - μ) := abs_of_nonpos (by linarith)
          _ = μ - 1 := by ring
      have hsepDiv : (spectralBudget + operatorRadius) / t < μ - 1 := by
        apply (div_lt_iff₀ ht).2
        simpa [hmuAbs, mul_comm] using hseparated
      let p : RankTwoParameter := EuclideanSpace.single (1 : Fin 2) (1 + a)
      let q : RankTwoParameter := EuclideanSpace.single (1 : Fin 2) (μ - b)
      have hp : p ∈ rankTwoFullSpectralEllipse κ spectralBudget := by
        simpa [rankTwoFullSpectralEllipse, p] using le_of_eq haSq
      have hq : q ∈ rankTwoFullOperatorEllipse κ μ operatorRadius := by
        simpa [rankTwoFullOperatorEllipse, q] using le_of_eq hbSq
      have hpq : (1 + a) - (μ - b) ≤ 0 := by
        linarith [hsepDiv, hab]
      refine ⟨p, hp, q, hq, ?_⟩
      calc
        dist p q = |(1 + a) - (μ - b)| := by
          simpa [p, q] using hsingleDist (1 + a) (μ - b)
        _ = -((1 + a) - (μ - b)) := abs_of_nonpos hpq
        _ = μ - 1 - (a + b) := by ring
        _ = |1 - μ| - (spectralBudget + operatorRadius) / t := by
          rw [hmuAbs, hab]
        _ = rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius :=
          hformula.symm
    · have hmuless : μ < 1 := lt_of_not_ge horder
      have hmuAbs : |1 - μ| = 1 - μ := abs_of_pos (by linarith)
      have hsepDiv : (spectralBudget + operatorRadius) / t < 1 - μ := by
        apply (div_lt_iff₀ ht).2
        simpa [hmuAbs, mul_comm] using hseparated
      let p : RankTwoParameter := EuclideanSpace.single (1 : Fin 2) (1 - a)
      let q : RankTwoParameter := EuclideanSpace.single (1 : Fin 2) (μ + b)
      have hp : p ∈ rankTwoFullSpectralEllipse κ spectralBudget := by
        simpa [rankTwoFullSpectralEllipse, p] using le_of_eq haSq
      have hq : q ∈ rankTwoFullOperatorEllipse κ μ operatorRadius := by
        simpa [rankTwoFullOperatorEllipse, q] using le_of_eq hbSq
      have hpq : 0 ≤ (1 - a) - (μ + b) := by
        linarith [hsepDiv, hab]
      refine ⟨p, hp, q, hq, ?_⟩
      calc
        dist p q = |(1 - a) - (μ + b)| := by
          simpa [p, q] using hsingleDist (1 - a) (μ + b)
        _ = (1 - a) - (μ + b) := abs_of_nonneg hpq
        _ = 1 - μ - (a + b) := by ring
        _ = |1 - μ| - (spectralBudget + operatorRadius) / t := by
          rw [hmuAbs, hab]
        _ = rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius :=
          hformula.symm

/-- The real admissible-set distance between the two full ellipses equals the claimed
closed-form Euclidean distance. -/
theorem rankTwoFullEllipse_admissibleSetDist_eq
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius)
    (hSpectralNonempty :
      (rankTwoFullSpectralEllipse κ spectralBudget).Nonempty)
    (hOperatorNonempty :
      (rankTwoFullOperatorEllipse κ μ operatorRadius).Nonempty) :
    admissibleSetDist
      (rankTwoFullSpectralEllipse κ spectralBudget)
      (rankTwoFullOperatorEllipse κ μ operatorRadius)
      hSpectralNonempty hOperatorNonempty =
        rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius := by
  obtain ⟨p, hp, q, hq, hdist⟩ :=
    exists_rankTwoFullEllipseDistance_eq_dist
      hκ hSpectralBudget hOperatorRadius
  have hformulaNonneg :
      0 ≤ rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius := by
    exact le_max_left _ _
  have hedist :
      admissibleSetEDist
        (rankTwoFullSpectralEllipse κ spectralBudget)
        (rankTwoFullOperatorEllipse κ μ operatorRadius) =
          ENNReal.ofReal
            (rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius) := by
    apply le_antisymm
    · have hupper := admissibleSetEDist_le_edist_of_mem hp hq
      simpa [edist_dist, hdist] using hupper
    · rw [admissibleSetEDist]
      refine le_iInf fun p' => le_iInf fun hp' =>
        le_iInf fun q' => le_iInf fun hq' => ?_
      rw [edist_dist]
      exact ENNReal.ofReal_le_ofReal
        (rankTwoFullEllipseDistance_le_dist_of_mem
          hκ hSpectralBudget hOperatorRadius hp' hq')
  unfold admissibleSetDist
  rw [hedist, ENNReal.toReal_ofReal hformulaNonneg]

/-- The exact full-ellipse distance formula specializes to the reduced real-loss
admissible sets when the operator radius is real. -/
theorem rankTwoLossAdmissibleSetDist_eq
    {κ μ spectralBudget operatorBudget : ℝ}
    (hκ : 0 < κ) (hμ : |μ| ≤ 1)
    (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorBudget : 0 ≤ operatorBudget)
    (hRadicand : κ * (1 - μ ^ 2) ≤ operatorBudget ^ 2)
    (hSpectralNonempty :
      (spectralAdmissibleSet
        (rankTwoSpectralLoss κ) spectralBudget).Nonempty)
    (hOperatorNonempty :
      (alignedOperatorAdmissibleSet
        (rankTwoAlignedOperatorLoss κ μ) operatorBudget).Nonempty) :
    admissibleSetDist
      (spectralAdmissibleSet (rankTwoSpectralLoss κ) spectralBudget)
      (alignedOperatorAdmissibleSet
        (rankTwoAlignedOperatorLoss κ μ) operatorBudget)
      hSpectralNonempty hOperatorNonempty =
        rankTwoFullEllipseDistance κ μ spectralBudget
          (rankTwoOperatorRadius κ μ operatorBudget) := by
  have hSpectralSet :
      spectralAdmissibleSet (rankTwoSpectralLoss κ) spectralBudget =
        rankTwoFullSpectralEllipse κ spectralBudget := by
    ext p
    exact rankTwoSpectralLoss_le_iff_ellipse hκ.le hSpectralBudget p
  have hOperatorSet :
      alignedOperatorAdmissibleSet
          (rankTwoAlignedOperatorLoss κ μ) operatorBudget =
        rankTwoFullOperatorEllipse κ μ
          (rankTwoOperatorRadius κ μ operatorBudget) := by
    ext p
    exact rankTwoAlignedOperatorLoss_le_iff_ellipse
      hκ.le hμ hOperatorBudget hRadicand p
  have hFullSpectralNonempty :
      (rankTwoFullSpectralEllipse κ spectralBudget).Nonempty :=
    hSpectralSet ▸ hSpectralNonempty
  have hFullOperatorNonempty :
      (rankTwoFullOperatorEllipse κ μ
        (rankTwoOperatorRadius κ μ operatorBudget)).Nonempty :=
    hOperatorSet ▸ hOperatorNonempty
  simpa only [admissibleSetDist, hSpectralSet, hOperatorSet] using
    rankTwoFullEllipse_admissibleSetDist_eq
      (μ := μ)
      (operatorRadius := rankTwoOperatorRadius κ μ operatorBudget)
      hκ hSpectralBudget (by exact Real.sqrt_nonneg _)
      hFullSpectralNonempty hFullOperatorNonempty

/-- `BG-DEF-015`: the declared closed candidate rectangle in the `(s, λ)` parameter
plane, represented by coordinatewise lower and upper endpoints. -/
def rankTwoCandidateRectangle
    (lower upper : RankTwoParameter) : Set RankTwoParameter :=
  Set.Icc lower upper

/-- `BG-DEF-016`: the spectral ellipse restricted to the declared candidate rectangle. -/
def rankTwoSpectralEllipseInRectangle
    (lower upper : RankTwoParameter) (κ spectralBudget : ℝ) : Set RankTwoParameter :=
  rankTwoFullSpectralEllipse κ spectralBudget ∩
    rankTwoCandidateRectangle lower upper

/-- `BG-DEF-017`: the aligned-operator ellipse restricted to the declared candidate
rectangle. -/
def rankTwoOperatorEllipseInRectangle
    (lower upper : RankTwoParameter) (κ μ operatorRadius : ℝ) : Set RankTwoParameter :=
  rankTwoFullOperatorEllipse κ μ operatorRadius ∩
    rankTwoCandidateRectangle lower upper

/-- `BG-THM-031`: explicit containment of the full spectral ellipse in the declared
rectangle makes rectangle restriction leave that ellipse unchanged. -/
theorem rankTwoSpectralEllipseInRectangle_eq_full_of_subset
    {lower upper : RankTwoParameter} {κ spectralBudget : ℝ}
    (hContained : rankTwoFullSpectralEllipse κ spectralBudget ⊆
      rankTwoCandidateRectangle lower upper) :
    rankTwoSpectralEllipseInRectangle lower upper κ spectralBudget =
      rankTwoFullSpectralEllipse κ spectralBudget := by
  exact Set.inter_eq_left.2 hContained

/-- `BG-THM-032`: explicit containment of the full operator ellipse in the declared
rectangle makes rectangle restriction leave that ellipse unchanged. -/
theorem rankTwoOperatorEllipseInRectangle_eq_full_of_subset
    {lower upper : RankTwoParameter} {κ μ operatorRadius : ℝ}
    (hContained : rankTwoFullOperatorEllipse κ μ operatorRadius ⊆
      rankTwoCandidateRectangle lower upper) :
    rankTwoOperatorEllipseInRectangle lower upper κ μ operatorRadius =
      rankTwoFullOperatorEllipse κ μ operatorRadius := by
  exact Set.inter_eq_left.2 hContained

/-- `BG-THM-033`: under the publication's explicit full-ellipse containment premises,
the ellipses restricted to the candidate rectangle intersect exactly under the same
scaled-center compatibility inequality as the full ellipses. -/
theorem rankTwoEllipsesInRectangle_inter_nonempty_iff
    {lower upper : RankTwoParameter}
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius)
    (hSpectralContained : rankTwoFullSpectralEllipse κ spectralBudget ⊆
      rankTwoCandidateRectangle lower upper)
    (hOperatorContained : rankTwoFullOperatorEllipse κ μ operatorRadius ⊆
      rankTwoCandidateRectangle lower upper) :
    (rankTwoSpectralEllipseInRectangle lower upper κ spectralBudget ∩
      rankTwoOperatorEllipseInRectangle lower upper κ μ operatorRadius).Nonempty ↔
      Real.sqrt κ * |1 - μ| ≤ spectralBudget + operatorRadius := by
  rw [rankTwoSpectralEllipseInRectangle_eq_full_of_subset hSpectralContained,
    rankTwoOperatorEllipseInRectangle_eq_full_of_subset hOperatorContained]
  exact rankTwoFullEllipses_inter_nonempty_iff
    hκ hSpectralBudget hOperatorRadius

/-- `BG-THM-034`: under explicit containment, rectangle restriction preserves the exact
Euclidean distance formula for the two full ellipses. -/
theorem rankTwoEllipsesInRectangle_admissibleSetDist_eq
    {lower upper : RankTwoParameter}
    {κ μ spectralBudget operatorRadius : ℝ}
    (hκ : 0 < κ) (hSpectralBudget : 0 ≤ spectralBudget)
    (hOperatorRadius : 0 ≤ operatorRadius)
    (hSpectralContained : rankTwoFullSpectralEllipse κ spectralBudget ⊆
      rankTwoCandidateRectangle lower upper)
    (hOperatorContained : rankTwoFullOperatorEllipse κ μ operatorRadius ⊆
      rankTwoCandidateRectangle lower upper)
    (hSpectralNonempty :
      (rankTwoSpectralEllipseInRectangle lower upper κ spectralBudget).Nonempty)
    (hOperatorNonempty :
      (rankTwoOperatorEllipseInRectangle lower upper κ μ operatorRadius).Nonempty) :
    admissibleSetDist
      (rankTwoSpectralEllipseInRectangle lower upper κ spectralBudget)
      (rankTwoOperatorEllipseInRectangle lower upper κ μ operatorRadius)
      hSpectralNonempty hOperatorNonempty =
        rankTwoFullEllipseDistance κ μ spectralBudget operatorRadius := by
  have hSpectralSet :=
    rankTwoSpectralEllipseInRectangle_eq_full_of_subset hSpectralContained
  have hOperatorSet :=
    rankTwoOperatorEllipseInRectangle_eq_full_of_subset hOperatorContained
  have hFullSpectralNonempty :
      (rankTwoFullSpectralEllipse κ spectralBudget).Nonempty :=
    hSpectralSet ▸ hSpectralNonempty
  have hFullOperatorNonempty :
      (rankTwoFullOperatorEllipse κ μ operatorRadius).Nonempty :=
    hOperatorSet ▸ hOperatorNonempty
  simpa only [hSpectralSet, hOperatorSet] using
    rankTwoFullEllipse_admissibleSetDist_eq
      hκ hSpectralBudget hOperatorRadius
      hFullSpectralNonempty hFullOperatorNonempty

end ProjectKoios.BandGauge.Geometry

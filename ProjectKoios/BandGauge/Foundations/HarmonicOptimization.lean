module

public import Mathlib.Analysis.SpecialFunctions.Complex.Arg

/-!
# Optimization of a first trigonometric harmonic

This module proves the standard maximum of `c cos θ + d sin θ`. It is reusable
supporting analysis and carries no paper-contribution or novelty claim.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Foundations

/-- `BG-FOUNDATION-DEF-002`: a constant plus the second harmonic used by the rank-two
real-rotation correlation. -/
noncomputable def secondHarmonicValue (b₀ c d φ : ℝ) : ℝ :=
  b₀ + c * Real.cos (2 * φ) + d * Real.sin (2 * φ)

/-- `BG-FOUNDATION-DEF-003`: the exact maximum value of the second harmonic. -/
noncomputable def secondHarmonicMaximum (b₀ c d : ℝ) : ℝ :=
  b₀ + Real.sqrt (c ^ 2 + d ^ 2)

/-- `BG-FOUNDATION-DEF-004`: one maximizing angle obtained from the complex argument.
This definition does not impose the paper's later half-open reporting convention. -/
noncomputable def secondHarmonicMaximizingAngle (c d : ℝ) : ℝ :=
  Complex.arg ((c : ℂ) + (d : ℂ) * Complex.I) / 2

/-- `BG-FOUNDATION-DEF-006`: a maximizing angle reduced to the half-open reporting
interval `[-π/2, π/2)`. The endpoint replacement preserves the second harmonic. -/
noncomputable def canonicalSecondHarmonicMaximizingAngle (c d : ℝ) : ℝ :=
  if secondHarmonicMaximizingAngle c d = Real.pi / 2 then
    -Real.pi / 2
  else
    secondHarmonicMaximizingAngle c d

/-- `BG-FOUNDATION-THM-001`: every value of the second harmonic is bounded by its exact
maximum. -/
theorem secondHarmonicValue_le_maximum (b₀ c d φ : ℝ) :
    secondHarmonicValue b₀ c d φ ≤ secondHarmonicMaximum b₀ c d := by
  let x := c * Real.cos (2 * φ) + d * Real.sin (2 * φ)
  let r := Real.sqrt (c ^ 2 + d ^ 2)
  have hsum : 0 ≤ c ^ 2 + d ^ 2 := add_nonneg (sq_nonneg c) (sq_nonneg d)
  have hr : 0 ≤ r := Real.sqrt_nonneg _
  have hrSq : r ^ 2 = c ^ 2 + d ^ 2 := Real.sq_sqrt hsum
  have hxSq : x ^ 2 ≤ c ^ 2 + d ^ 2 := by
    have horth := sq_nonneg
      (c * Real.sin (2 * φ) - d * Real.cos (2 * φ))
    have htrig := Real.sin_sq_add_cos_sq (2 * φ)
    dsimp [x]
    nlinarith
  have hxr : x ≤ r := by
    by_cases hx : x ≤ 0
    · exact hx.trans hr
    · exact (sq_le_sq₀ (le_of_not_ge hx) hr).1 (by simpa [hrSq] using hxSq)
  unfold secondHarmonicValue secondHarmonicMaximum
  dsimp [x, r] at hxr
  linarith

/-- `BG-FOUNDATION-THM-002`: the complex-argument angle attains the exact second-harmonic
maximum, including the degenerate case `c = d = 0`. -/
theorem secondHarmonicValue_maximizingAngle
    (b₀ c d : ℝ) :
    secondHarmonicValue b₀ c d (secondHarmonicMaximizingAngle c d) =
      secondHarmonicMaximum b₀ c d := by
  let z : ℂ := (c : ℂ) + (d : ℂ) * Complex.I
  let θ := Complex.arg z
  have hc : ‖z‖ * Real.cos θ = c := by
    simp [z, θ]
  have hd : ‖z‖ * Real.sin θ = d := by
    simp [z, θ]
  have hnorm : ‖z‖ = Real.sqrt (c ^ 2 + d ^ 2) := by
    rw [Complex.norm_def]
    congr 1
    simp [z, Complex.normSq_apply]
    ring
  have hattain : c * Real.cos θ + d * Real.sin θ =
      Real.sqrt (c ^ 2 + d ^ 2) := by
    calc
      c * Real.cos θ + d * Real.sin θ =
          ‖z‖ * (Real.cos θ ^ 2 + Real.sin θ ^ 2) := by
        rw [← hc, ← hd]
        ring
      _ = ‖z‖ := by rw [Real.cos_sq_add_sin_sq]; ring
      _ = Real.sqrt (c ^ 2 + d ^ 2) := hnorm
  rw [secondHarmonicValue, secondHarmonicMaximizingAngle,
    secondHarmonicMaximum]
  have hangle : 2 * (Complex.arg ((c : ℂ) + (d : ℂ) * Complex.I) / 2) = θ := by
    dsimp [θ, z]
    ring
  rw [hangle]
  linarith [hattain]

/-- `BG-FOUNDATION-THM-005`: the canonical maximizing angle belongs to the half-open
interval `[-π/2, π/2)`. -/
theorem canonicalSecondHarmonicMaximizingAngle_mem (c d : ℝ) :
    canonicalSecondHarmonicMaximizingAngle c d ∈
      Set.Ico (-Real.pi / 2) (Real.pi / 2) := by
  have hl : -Real.pi / 2 < secondHarmonicMaximizingAngle c d := by
    rw [secondHarmonicMaximizingAngle]
    have := Complex.neg_pi_lt_arg ((c : ℂ) + (d : ℂ) * Complex.I)
    linarith
  have hu : secondHarmonicMaximizingAngle c d ≤ Real.pi / 2 := by
    rw [secondHarmonicMaximizingAngle]
    have := Complex.arg_le_pi ((c : ℂ) + (d : ℂ) * Complex.I)
    linarith
  rw [canonicalSecondHarmonicMaximizingAngle]
  split_ifs with h
  · constructor <;> nlinarith [Real.pi_pos]
  · exact ⟨hl.le, lt_of_le_of_ne hu h⟩

/-- `BG-FOUNDATION-THM-006`: reducing the complex-argument angle to the half-open
interval preserves attainment of the exact maximum. -/
theorem secondHarmonicValue_canonicalMaximizingAngle
    (b₀ c d : ℝ) :
    secondHarmonicValue b₀ c d
        (canonicalSecondHarmonicMaximizingAngle c d) =
      secondHarmonicMaximum b₀ c d := by
  rw [canonicalSecondHarmonicMaximizingAngle]
  split_ifs with h
  · rw [← secondHarmonicValue_maximizingAngle b₀ c d, h]
    simp only [secondHarmonicValue]
    have hneg : 2 * (-Real.pi / 2) = -Real.pi := by ring
    have hpos : 2 * (Real.pi / 2) = Real.pi := by ring
    rw [hneg, hpos, Real.cos_neg, Real.sin_neg, Real.cos_pi, Real.sin_pi]
    ring
  · exact secondHarmonicValue_maximizingAngle b₀ c d

end ProjectKoios.BandGauge.Foundations

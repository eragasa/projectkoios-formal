module

public import Mathlib.Analysis.Complex.Trigonometric
public import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Standard real rotations on a complex rank-two fiber

This module supplies the elementary real `SO(2)` rotation used as a complex unitary
matrix. It is reusable supporting infrastructure and carries no paper-contribution or
novelty claim.
-/

open scoped Matrix ComplexConjugate

@[expose] public section

namespace ProjectKoios.BandGauge.Foundations

/-- `BG-FOUNDATION-DEF-001`: the standard real planar rotation, embedded as a complex
unitary `2 × 2` matrix. -/
noncomputable def rankTwoRealRotation (φ : ℝ) :
    Matrix.unitaryGroup (Fin 2) ℂ :=
  ⟨!![(Real.cos φ : ℂ), -(Real.sin φ : ℂ);
      (Real.sin φ : ℂ), (Real.cos φ : ℂ)], by
    rw [Matrix.mem_unitaryGroup_iff]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
    all_goals rw [← Complex.ofReal_cos φ, ← Complex.ofReal_sin φ]
    all_goals simp only [Complex.conj_ofReal]
    all_goals norm_cast
    all_goals nlinarith [Real.sin_sq_add_cos_sq φ]⟩

end ProjectKoios.BandGauge.Foundations

module

public import ProjectKoios.SolidState.TightBinding.TetrahedralSp3
public import Mathlib.Analysis.Complex.Exponential

/-!
# Exact tetrahedral nearest-neighbor structure-factor identities

The four structure factors are the normalized Hadamard combinations of four complex
bond phases. This module proves the exact Gamma-point value and the normalization for
unit-modulus phases. It does not connect those phases to floating-point trigonometric
execution.
-/

open scoped Matrix ComplexConjugate

@[expose] public section

namespace ProjectKoios.SolidState.TightBinding

/-- `SS-TB-DEF-009`: the four tetrahedral structure factors obtained from bond phases.
The factor `1/4` is the convention used in the nearest-neighbor `sp³s⋆` model. -/
noncomputable def tetrahedralStructureFactors (bondPhase : Fin 4 → ℂ) : Fin 4 → ℂ :=
  (1 / 4 : ℂ) •
    (tetrahedralHadamard.map (algebraMap ℝ ℂ) *ᵥ bondPhase)

/-- `SS-TB-THM-020`: if all four bond phases equal one, the structure factors are
`(1, 0, 0, 0)`. -/
theorem tetrahedralStructureFactors_atGamma :
    tetrahedralStructureFactors (fun _ => 1) = ![(1 : ℂ), 0, 0, 0] := by
  funext i
  fin_cases i <;>
    norm_num [tetrahedralStructureFactors, tetrahedralHadamard, Matrix.mulVec,
      dotProduct, Fin.sum_univ_four]

/-- `SS-TB-THM-021`: the squared moduli of the four structure factors sum to one when
the four input bond phases have unit modulus. -/
theorem tetrahedralStructureFactors_normSq_sum
    (bondPhase : Fin 4 → ℂ)
    (hunit : ∀ i, Complex.normSq (bondPhase i) = 1) :
    ∑ i, Complex.normSq (tetrahedralStructureFactors bondPhase i) = 1 := by
  have h0 := hunit 0
  have h1 := hunit 1
  have h2 := hunit 2
  have h3 := hunit 3
  simp [tetrahedralStructureFactors, tetrahedralHadamard, Matrix.mulVec,
    dotProduct, Fin.sum_univ_four, Complex.normSq_apply] at h0 h1 h2 h3 ⊢
  nlinarith

/-- `SS-TB-DEF-010`: complex phases associated with the four tetrahedral bond
sign-vectors for a real three-component phase argument. -/
noncomputable def tetrahedralBondPhase (phaseArgument : Fin 3 → ℝ) : Fin 4 → ℂ :=
  fun i => Complex.exp
    (Complex.I * ((tetrahedralBondDirection i ⬝ᵥ phaseArgument : ℝ) : ℂ))

/-- `SS-TB-THM-022`: every exact tetrahedral bond phase has unit squared modulus. -/
theorem tetrahedralBondPhase_normSq (phaseArgument : Fin 3 → ℝ) (i : Fin 4) :
    Complex.normSq (tetrahedralBondPhase phaseArgument i) = 1 := by
  rw [Complex.normSq_eq_norm_sq]
  simp [tetrahedralBondPhase, Complex.norm_exp_I_mul_ofReal]

/-- `SS-TB-THM-023`: structure factors constructed from exact tetrahedral bond phases
satisfy the unit sum rule. -/
theorem tetrahedralStructureFactors_bondPhase_normSq_sum
    (phaseArgument : Fin 3 → ℝ) :
    ∑ i, Complex.normSq
      (tetrahedralStructureFactors (tetrahedralBondPhase phaseArgument) i) = 1 :=
  tetrahedralStructureFactors_normSq_sum _
    (tetrahedralBondPhase_normSq phaseArgument)

/-- `SS-TB-DEF-011`: the structure factors in the reduced-wavevector convention
`k = (2π/a_L) q`, for which the tetrahedral bond-phase argument is `(π/2) q`. -/
noncomputable def voglReducedStructureFactors (q : Fin 3 → ℝ) : Fin 4 → ℂ :=
  tetrahedralStructureFactors (tetrahedralBondPhase ((Real.pi / 2) • q))

/-- `SS-TB-THM-031`: reduced-wavevector structure factors satisfy the exact unit sum
rule. -/
theorem voglReducedStructureFactors_normSq_sum (q : Fin 3 → ℝ) :
    ∑ i, Complex.normSq (voglReducedStructureFactors q i) = 1 :=
  tetrahedralStructureFactors_bondPhase_normSq_sum _

/-- `SS-TB-THM-032`: the reduced-wavevector Gamma point has structure factors
`(1, 0, 0, 0)`. -/
theorem voglReducedStructureFactors_atGamma :
    voglReducedStructureFactors (0 : Fin 3 → ℝ) = ![(1 : ℂ), 0, 0, 0] := by
  rw [voglReducedStructureFactors]
  have hphase :
      tetrahedralBondPhase ((Real.pi / 2) • (0 : Fin 3 → ℝ)) =
        (fun _ => 1) := by
    funext i
    simp [tetrahedralBondPhase]
  rw [hphase]
  exact tetrahedralStructureFactors_atGamma

end ProjectKoios.SolidState.TightBinding

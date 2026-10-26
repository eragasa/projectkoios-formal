module

public import ProjectKoios.SolidState.TightBinding.TetrahedralSp3sStar
public import ProjectKoios.SolidState.TightBinding.TetrahedralStructureFactors
public import Mathlib.LinearAlgebra.Matrix.Hermitian
public import Mathlib.Analysis.Complex.Trigonometric

/-!
# Algebraic skeleton of the Vogl nearest-neighbor `sp³s⋆` Hamiltonian

This module records the 13 real scalar slots, the five-by-five inter-sublattice hopping
block, and the ten-by-ten Hermitian block construction. The proof of Hermiticity is
parameter-independent and exact. Structural zero couplings are also exposed as exact
theorems.

The declarations do not encode the numerical Table 1 transcription, parameter
accuracy, a calculated spectrum, or material-model adequacy.
-/

open scoped Matrix ComplexConjugate

@[expose] public section

namespace ProjectKoios.SolidState.TightBinding

/-- `SS-TB-DEF-012`: the 13 real scalar slots of a Vogl nearest-neighbor `sp³s⋆`
parameter row. Energies and transfers remain abstract real numbers. -/
structure VoglSp3sStarParameters where
  eSA : ℝ
  ePA : ℝ
  eSStarA : ℝ
  eSC : ℝ
  ePC : ℝ
  eSStarC : ℝ
  vSS : ℝ
  vSAPC : ℝ
  vSCPA : ℝ
  vXX : ℝ
  vXY : ℝ
  vPASStarC : ℝ
  vSStarAPC : ℝ

/-- `SS-TB-DEF-013`: the diagonal anion onsite block in the
`(s, pₓ, pᵧ, p_z, s⋆)` order. -/
noncomputable def voglSp3sStarOnsiteA (p : VoglSp3sStarParameters) :
    Matrix (Fin 5) (Fin 5) ℂ :=
  Matrix.diagonal ![(p.eSA : ℂ), p.ePA, p.ePA, p.ePA, p.eSStarA]

/-- `SS-TB-DEF-014`: the diagonal cation onsite block in the
`(s, pₓ, pᵧ, p_z, s⋆)` order. -/
noncomputable def voglSp3sStarOnsiteC (p : VoglSp3sStarParameters) :
    Matrix (Fin 5) (Fin 5) ℂ :=
  Matrix.diagonal ![(p.eSC : ℂ), p.ePC, p.ePC, p.ePC, p.eSStarC]

/-- `SS-TB-DEF-015`: the anion-to-cation nearest-neighbor hopping block for four
structure factors in the `sp³s⋆` orbital order. -/
noncomputable def voglSp3sStarHopping
    (p : VoglSp3sStarParameters) (g : Fin 4 → ℂ) : Matrix (Fin 5) (Fin 5) ℂ :=
  !![p.vSS * g 0, p.vSAPC * g 1, p.vSAPC * g 2, p.vSAPC * g 3, 0;
     -p.vSCPA * g 1, p.vXX * g 0, p.vXY * g 3, p.vXY * g 2,
       -p.vPASStarC * g 1;
     -p.vSCPA * g 2, p.vXY * g 3, p.vXX * g 0, p.vXY * g 1,
       -p.vPASStarC * g 2;
     -p.vSCPA * g 3, p.vXY * g 2, p.vXY * g 1, p.vXX * g 0,
       -p.vPASStarC * g 3;
     0, p.vSStarAPC * g 1, p.vSStarAPC * g 2, p.vSStarAPC * g 3, 0]

/-- `SS-TB-DEF-016`: the ten-by-ten Vogl block Hamiltonian
`[[D_A, T], [Tᴴ, D_C]]`. -/
noncomputable def voglSp3sStarHamiltonian
    (p : VoglSp3sStarParameters) (g : Fin 4 → ℂ) :
    Matrix VoglSp3sStarBasis VoglSp3sStarBasis ℂ :=
  Matrix.fromBlocks
    (voglSp3sStarOnsiteA p)
    (voglSp3sStarHopping p g)
    (voglSp3sStarHopping p g)ᴴ
    (voglSp3sStarOnsiteC p)

/-- `SS-TB-THM-024`: the anion onsite block is Hermitian for every real parameter
row. -/
theorem voglSp3sStarOnsiteA_isHermitian (p : VoglSp3sStarParameters) :
    (voglSp3sStarOnsiteA p).IsHermitian := by
  rw [voglSp3sStarOnsiteA, Matrix.isHermitian_diagonal_iff]
  intro i
  fin_cases i <;> simp [isSelfAdjoint_iff]

/-- `SS-TB-THM-025`: the cation onsite block is Hermitian for every real parameter
row. -/
theorem voglSp3sStarOnsiteC_isHermitian (p : VoglSp3sStarParameters) :
    (voglSp3sStarOnsiteC p).IsHermitian := by
  rw [voglSp3sStarOnsiteC, Matrix.isHermitian_diagonal_iff]
  intro i
  fin_cases i <;> simp [isSelfAdjoint_iff]

/-- `SS-TB-THM-026`: the ten-orbital block Hamiltonian is Hermitian for every real
parameter row and every complex structure-factor vector. -/
theorem voglSp3sStarHamiltonian_isHermitian
    (p : VoglSp3sStarParameters) (g : Fin 4 → ℂ) :
    (voglSp3sStarHamiltonian p g).IsHermitian := by
  apply Matrix.IsHermitian.fromBlocks
    (voglSp3sStarOnsiteA_isHermitian p)
    rfl
    (voglSp3sStarOnsiteC_isHermitian p)

/-- `SS-TB-THM-027`: the anion `s` to cation `s⋆` hopping is a structural zero. -/
theorem voglSp3sStarHopping_s_sStar
    (p : VoglSp3sStarParameters) (g : Fin 4 → ℂ) :
    voglSp3sStarHopping p g 0 4 = 0 := by
  simp [voglSp3sStarHopping]

/-- `SS-TB-THM-028`: the anion `s⋆` to cation `s` hopping is a structural zero. -/
theorem voglSp3sStarHopping_sStar_s
    (p : VoglSp3sStarParameters) (g : Fin 4 → ℂ) :
    voglSp3sStarHopping p g 4 0 = 0 := by
  simp [voglSp3sStarHopping]

/-- `SS-TB-THM-029`: the inter-sublattice `s⋆` to `s⋆` hopping is a structural zero. -/
theorem voglSp3sStarHopping_sStar_sStar
    (p : VoglSp3sStarParameters) (g : Fin 4 → ℂ) :
    voglSp3sStarHopping p g 4 4 = 0 := by
  simp [voglSp3sStarHopping]

/-- `SS-TB-DEF-017`: the exact Hamiltonian assembled from four tetrahedral bond
phases. -/
noncomputable def voglSp3sStarHamiltonianFromBondPhases
    (p : VoglSp3sStarParameters) (bondPhase : Fin 4 → ℂ) :
    Matrix VoglSp3sStarBasis VoglSp3sStarBasis ℂ :=
  voglSp3sStarHamiltonian p (tetrahedralStructureFactors bondPhase)

/-- `SS-TB-THM-030`: the bond-phase specialization remains Hermitian. -/
theorem voglSp3sStarHamiltonianFromBondPhases_isHermitian
    (p : VoglSp3sStarParameters) (bondPhase : Fin 4 → ℂ) :
    (voglSp3sStarHamiltonianFromBondPhases p bondPhase).IsHermitian :=
  voglSp3sStarHamiltonian_isHermitian _ _

/-- `SS-TB-DEF-018`: the exact ten-orbital Hamiltonian in the reduced-wavevector
convention `k = (2π/a_L) q`. -/
noncomputable def voglSp3sStarHamiltonianAtReducedWavevector
    (p : VoglSp3sStarParameters) (q : Fin 3 → ℝ) :
    Matrix VoglSp3sStarBasis VoglSp3sStarBasis ℂ :=
  voglSp3sStarHamiltonian p (voglReducedStructureFactors q)

/-- `SS-TB-THM-033`: the reduced-wavevector Hamiltonian is Hermitian at every exact
real wavevector and for every real parameter row. -/
theorem voglSp3sStarHamiltonianAtReducedWavevector_isHermitian
    (p : VoglSp3sStarParameters) (q : Fin 3 → ℝ) :
    (voglSp3sStarHamiltonianAtReducedWavevector p q).IsHermitian :=
  voglSp3sStarHamiltonian_isHermitian _ _

end ProjectKoios.SolidState.TightBinding

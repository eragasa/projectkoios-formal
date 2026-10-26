module

public import ProjectKoios.SolidState.TightBinding.TetrahedralSp3
public import Mathlib.Data.Matrix.Block

/-!
# Exact `sp³s⋆` extension of the tetrahedral hybrid transform

The tetrahedral transform acts on `(s, pₓ, pᵧ, p_z)`. The excited `s⋆` orbital is an
additional scalar channel, not a fifth tetrahedral direction. Accordingly, this module
extends the four-dimensional transform by the identity on `s⋆`, and then places one
copy on each of the two sublattices of the ten-orbital basis.

Only the exact change-of-basis algebra is certified here. No empirical `sp³s⋆`
parameter, numerical eigenspectrum, or material-model adequacy claim is formalized.
-/

open scoped Matrix

@[expose] public section

namespace ProjectKoios.SolidState.TightBinding

/-- `SS-TB-DEF-005`: the orbital indices `(s, pₓ, pᵧ, p_z, s⋆)` on one sublattice. -/
abbrev Sp3sStarOrbital := Fin 5

/-- `SS-TB-DEF-006`: the normalized tetrahedral transform extended by the identity on
`s⋆`. -/
noncomputable def sp3sStarHybridTransform : Matrix Sp3sStarOrbital Sp3sStarOrbital ℝ :=
  !![1 / 2, 1 / 2, 1 / 2, 1 / 2, 0;
     1 / 2, 1 / 2, -1 / 2, -1 / 2, 0;
     1 / 2, -1 / 2, 1 / 2, -1 / 2, 0;
     1 / 2, -1 / 2, -1 / 2, 1 / 2, 0;
     0, 0, 0, 0, 1]

/-- `SS-TB-THM-010`: the one-sublattice `sp³s⋆` transform is orthogonal. -/
theorem sp3sStarHybridTransform_mul_transpose :
    sp3sStarHybridTransform * sp3sStarHybridTransform.transpose =
      (1 : Matrix Sp3sStarOrbital Sp3sStarOrbital ℝ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [sp3sStarHybridTransform, Matrix.mul_apply, Fin.sum_univ_succ]

/-- `SS-TB-THM-011`: the one-sublattice `sp³s⋆` transform is symmetric. -/
theorem sp3sStarHybridTransform_transpose :
    sp3sStarHybridTransform.transpose = sp3sStarHybridTransform := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [sp3sStarHybridTransform]

/-- `SS-TB-THM-012`: the one-sublattice `sp³s⋆` transform is its own inverse. -/
theorem sp3sStarHybridTransform_mul_self :
    sp3sStarHybridTransform * sp3sStarHybridTransform =
      (1 : Matrix Sp3sStarOrbital Sp3sStarOrbital ℝ) := by
  simpa only [sp3sStarHybridTransform_transpose] using
    sp3sStarHybridTransform_mul_transpose

/-- `SS-TB-THM-013`: the one-sublattice `sp³s⋆` transform preserves the real dot
product. -/
theorem sp3sStarHybridTransform_dotProduct (x y : Sp3sStarOrbital → ℝ) :
    (sp3sStarHybridTransform *ᵥ x) ⬝ᵥ
        (sp3sStarHybridTransform *ᵥ y) = x ⬝ᵥ y := by
  rw [Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec,
    sp3sStarHybridTransform_transpose, sp3sStarHybridTransform_mul_self]
  simp

/-- `SS-TB-THM-014`: applying the one-sublattice `sp³s⋆` transform twice recovers the
original orbital coordinates. -/
theorem sp3sStarHybridTransform_involutive (x : Sp3sStarOrbital → ℝ) :
    sp3sStarHybridTransform *ᵥ (sp3sStarHybridTransform *ᵥ x) = x := by
  rw [Matrix.mulVec_mulVec, sp3sStarHybridTransform_mul_self]
  simp

/-- `SS-TB-THM-015`: the `s⋆` coordinate is unchanged by the extended transform. -/
theorem sp3sStarHybridTransform_sStar (x : Sp3sStarOrbital → ℝ) :
    (sp3sStarHybridTransform *ᵥ x) 4 = x 4 := by
  simp [sp3sStarHybridTransform, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]

/-- `SS-TB-DEF-007`: the ten-orbital basis as the disjoint union of anion and cation
five-orbital bases. `Sum.inl` is the anion and `Sum.inr` is the cation. -/
abbrev VoglSp3sStarBasis := Sp3sStarOrbital ⊕ Sp3sStarOrbital

/-- `SS-TB-DEF-008`: two identical `sp³s⋆` hybrid transforms, one per sublattice. -/
noncomputable def twoSublatticeSp3sStarHybridTransform :
    Matrix VoglSp3sStarBasis VoglSp3sStarBasis ℝ :=
  Matrix.fromBlocks sp3sStarHybridTransform 0 0 sp3sStarHybridTransform

/-- `SS-TB-THM-016`: the ten-orbital two-sublattice transform is symmetric. -/
theorem twoSublatticeSp3sStarHybridTransform_transpose :
    twoSublatticeSp3sStarHybridTransform.transpose =
      twoSublatticeSp3sStarHybridTransform := by
  rw [twoSublatticeSp3sStarHybridTransform, Matrix.fromBlocks_transpose]
  simp [sp3sStarHybridTransform_transpose]

/-- `SS-TB-THM-017`: the ten-orbital two-sublattice transform is its own inverse. -/
theorem twoSublatticeSp3sStarHybridTransform_mul_self :
    twoSublatticeSp3sStarHybridTransform *
        twoSublatticeSp3sStarHybridTransform =
      (1 : Matrix VoglSp3sStarBasis VoglSp3sStarBasis ℝ) := by
  rw [twoSublatticeSp3sStarHybridTransform, Matrix.fromBlocks_multiply]
  simp [sp3sStarHybridTransform_mul_self]

/-- `SS-TB-THM-018`: the ten-orbital two-sublattice transform is orthogonal. -/
theorem twoSublatticeSp3sStarHybridTransform_mul_transpose :
    twoSublatticeSp3sStarHybridTransform *
        twoSublatticeSp3sStarHybridTransform.transpose =
      (1 : Matrix VoglSp3sStarBasis VoglSp3sStarBasis ℝ) := by
  rw [twoSublatticeSp3sStarHybridTransform_transpose]
  exact twoSublatticeSp3sStarHybridTransform_mul_self

/-- `SS-TB-THM-019`: the ten-orbital two-sublattice transform preserves the real dot
product. -/
theorem twoSublatticeSp3sStarHybridTransform_dotProduct
    (x y : VoglSp3sStarBasis → ℝ) :
    (twoSublatticeSp3sStarHybridTransform *ᵥ x) ⬝ᵥ
        (twoSublatticeSp3sStarHybridTransform *ᵥ y) = x ⬝ᵥ y := by
  rw [Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec,
    twoSublatticeSp3sStarHybridTransform_transpose,
    twoSublatticeSp3sStarHybridTransform_mul_self]
  simp

end ProjectKoios.SolidState.TightBinding

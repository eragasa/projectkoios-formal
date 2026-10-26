module

public import Mathlib.LinearAlgebra.Matrix.DotProduct
public import Mathlib.LinearAlgebra.Matrix.Notation
public import Mathlib.Tactic

/-!
# Exact tetrahedral `sp³` hybrid transform

This module formalizes the normalized four-by-four Hadamard transform that maps an
orthonormal `(s, pₓ, pᵧ, p_z)` orbital coordinate vector to four tetrahedral `sp³`
hybrid coordinates. It proves only exact finite-dimensional algebra and tetrahedral
sign geometry. It makes no claim about empirical parameters, electronic-structure
accuracy, or calculator output.
-/

open scoped Matrix

@[expose] public section

namespace ProjectKoios.SolidState.TightBinding

/-- `SS-TB-DEF-001`: the sign matrix for the four tetrahedral `sp³` hybrids. -/
def tetrahedralHadamard : Matrix (Fin 4) (Fin 4) ℝ :=
  !![1, 1, 1, 1;
     1, 1, -1, -1;
     1, -1, 1, -1;
     1, -1, -1, 1]

/-- `SS-TB-DEF-002`: the normalized tetrahedral hybrid transform `H / 2`. -/
noncomputable def tetrahedralHybridTransform : Matrix (Fin 4) (Fin 4) ℝ :=
  (1 / 2 : ℝ) • tetrahedralHadamard

/-- `SS-TB-THM-001`: the tetrahedral sign matrix has mutually orthogonal rows of
squared length four. -/
theorem tetrahedralHadamard_mul_transpose :
    tetrahedralHadamard * tetrahedralHadamard.transpose =
      4 • (1 : Matrix (Fin 4) (Fin 4) ℝ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [tetrahedralHadamard, Matrix.mul_apply, Fin.sum_univ_four]

/-- `SS-TB-THM-002`: the normalized hybrid transform is orthogonal. -/
theorem tetrahedralHybridTransform_mul_transpose :
    tetrahedralHybridTransform * tetrahedralHybridTransform.transpose =
      (1 : Matrix (Fin 4) (Fin 4) ℝ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [tetrahedralHybridTransform, tetrahedralHadamard, Matrix.mul_apply,
      Fin.sum_univ_four]

/-- `SS-TB-THM-003`: the normalized tetrahedral transform is symmetric. -/
theorem tetrahedralHybridTransform_transpose :
    tetrahedralHybridTransform.transpose = tetrahedralHybridTransform := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [tetrahedralHybridTransform, tetrahedralHadamard]

/-- `SS-TB-THM-004`: applying the normalized hybrid transform twice is the identity. -/
theorem tetrahedralHybridTransform_mul_self :
    tetrahedralHybridTransform * tetrahedralHybridTransform =
      (1 : Matrix (Fin 4) (Fin 4) ℝ) := by
  simpa only [tetrahedralHybridTransform_transpose] using
    tetrahedralHybridTransform_mul_transpose

/-- `SS-TB-THM-005`: the tetrahedral hybrid transform preserves the real dot product. -/
theorem tetrahedralHybridTransform_dotProduct (x y : Fin 4 → ℝ) :
    (tetrahedralHybridTransform *ᵥ x) ⬝ᵥ
        (tetrahedralHybridTransform *ᵥ y) = x ⬝ᵥ y := by
  rw [Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec,
    tetrahedralHybridTransform_transpose, tetrahedralHybridTransform_mul_self]
  simp

/-- `SS-TB-THM-006`: the same normalized transform recovers the original orbital
coordinates from the hybrid coordinates. -/
theorem tetrahedralHybridTransform_involutive (x : Fin 4 → ℝ) :
    tetrahedralHybridTransform *ᵥ (tetrahedralHybridTransform *ᵥ x) = x := by
  rw [Matrix.mulVec_mulVec, tetrahedralHybridTransform_mul_self]
  simp

/-- `SS-TB-DEF-003`: one row of the normalized hybrid transform, regarded as a hybrid
coordinate vector. -/
noncomputable def tetrahedralHybridVector (i : Fin 4) : Fin 4 → ℝ :=
  tetrahedralHybridTransform i

/-- `SS-TB-THM-007`: the four hybrid coordinate vectors are orthonormal. -/
theorem tetrahedralHybridVector_dotProduct (i j : Fin 4) :
    tetrahedralHybridVector i ⬝ᵥ tetrahedralHybridVector j =
      if i = j then 1 else 0 := by
  fin_cases i <;> fin_cases j <;>
    norm_num [tetrahedralHybridVector, tetrahedralHybridTransform,
      tetrahedralHadamard, dotProduct, Fin.sum_univ_four]

/-- `SS-TB-DEF-004`: the four unnormalized tetrahedral bond directions. -/
def tetrahedralBondDirection : Fin 4 → Fin 3 → ℝ :=
  !![1, 1, 1;
     1, -1, -1;
     -1, 1, -1;
     -1, -1, 1]

/-- `SS-TB-THM-008`: each unnormalized tetrahedral direction has squared length three. -/
theorem tetrahedralBondDirection_self_dotProduct (i : Fin 4) :
    tetrahedralBondDirection i ⬝ᵥ tetrahedralBondDirection i = 3 := by
  fin_cases i <;>
    norm_num [tetrahedralBondDirection, dotProduct, Fin.sum_univ_three]

/-- `SS-TB-THM-009`: distinct unnormalized tetrahedral directions have dot product
minus one. -/
theorem tetrahedralBondDirection_pair_dotProduct {i j : Fin 4} (hij : i ≠ j) :
    tetrahedralBondDirection i ⬝ᵥ tetrahedralBondDirection j = -1 := by
  fin_cases i <;> fin_cases j <;>
    simp_all [tetrahedralBondDirection, dotProduct, Fin.sum_univ_three]

/-- `SS-TB-DEF-019`: the four tetrahedral bond directions normalized to unit length. -/
noncomputable def normalizedTetrahedralBondDirection (i : Fin 4) : Fin 3 → ℝ :=
  (1 / Real.sqrt 3) • tetrahedralBondDirection i

/-- `SS-TB-THM-034`: every normalized tetrahedral direction has unit squared length. -/
theorem normalizedTetrahedralBondDirection_self_dotProduct (i : Fin 4) :
    normalizedTetrahedralBondDirection i ⬝ᵥ
      normalizedTetrahedralBondDirection i = 1 := by
  simp only [normalizedTetrahedralBondDirection]
  rw [smul_dotProduct, dotProduct_smul,
    tetrahedralBondDirection_self_dotProduct]
  simp only [smul_eq_mul]
  have hsqrt : Real.sqrt 3 ≠ 0 := by positivity
  field_simp
  nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]

/-- `SS-TB-THM-035`: distinct normalized tetrahedral directions have dot product
`-1/3`. -/
theorem normalizedTetrahedralBondDirection_pair_dotProduct
    {i j : Fin 4} (hij : i ≠ j) :
    normalizedTetrahedralBondDirection i ⬝ᵥ
      normalizedTetrahedralBondDirection j = -(1 / 3 : ℝ) := by
  simp only [normalizedTetrahedralBondDirection]
  rw [smul_dotProduct, dotProduct_smul,
    tetrahedralBondDirection_pair_dotProduct hij]
  simp only [smul_eq_mul]
  have hsqrt : Real.sqrt 3 ≠ 0 := by positivity
  field_simp
  nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]

end ProjectKoios.SolidState.TightBinding

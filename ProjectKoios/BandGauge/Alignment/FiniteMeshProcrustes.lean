/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Alignment.Family
public import ProjectKoios.BandGauge.Alignment.UnitaryProcrustes
public import Mathlib.Analysis.InnerProductSpace.Adjoint

/-!
# Exact unitary Procrustes optimization on a finite mesh

This module lifts the supplied-witness right-unitary Procrustes result from one
matrix pair to a finite mesh.  The mesh objective is the unweighted sum of the
pointwise squared Frobenius objectives.  A supplied exact positive-semidefinite
polar witness at every mesh point gives a global pointwise minimizer.  If every
positive factor is positive definite, equality in the summed objective forces
pointwise equality with that minimizer.

The resulting pointwise field is no worse than any constant unitary field and,
in particular, no worse than the identity field.  A separate known-inverse
control theorem gives zero objective only from an explicit exact frame-equality
hypothesis.

The module also embeds matrix unitary fields into the existing abstract
`AlignmentField` hierarchy on complex Euclidean retained spaces.  This bridge
is exact mathematics; it does not construct or certify a numerical SVD, rank
test, mesh, tolerance, runtime optimizer, or serialized certificate.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Alignment

open scoped BigOperators ComplexOrder

/-- **BG-ALIGNMENT-DEF-021** — A unitary matrix acts as an exact complex linear
isometric equivalence on the retained Euclidean space. -/
noncomputable def matrixUnitaryAlignment
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    EuclideanSpace ℂ Retained ≃ₗᵢ[ℂ] EuclideanSpace ℂ Retained := by
  let u : EuclideanSpace ℂ Retained →L[ℂ] EuclideanSpace ℂ Retained :=
    gauge.1.toEuclideanLin.toContinuousLinearMap
  have hleft : Matrix.conjTranspose gauge.1 * gauge.1 = 1 := by
    simpa only [Matrix.star_eq_conjTranspose] using gauge.2.1
  have hright : gauge.1 * Matrix.conjTranspose gauge.1 = 1 := by
    simpa only [Matrix.star_eq_conjTranspose] using gauge.2.2
  have hu : u ∈ unitary
      (EuclideanSpace ℂ Retained →L[ℂ] EuclideanSpace ℂ Retained) := by
    rw [Unitary.mem_iff]
    constructor
    · rw [ContinuousLinearMap.star_eq_adjoint]
      apply ContinuousLinearMap.coe_injective
      rw [ContinuousLinearMap.toLinearMap_mul, ← ContinuousLinearMap.adjoint_toLinearMap,
        ContinuousLinearMap.toLinearMap_one]
      simp only [u, LinearMap.coe_toContinuousLinearMap]
      rw [← Matrix.toEuclideanLin_conjTranspose_eq_adjoint]
      rw [Matrix.toEuclideanLin_eq_toLin_orthonormal, Module.End.mul_eq_comp,
        ← Matrix.toLin_mul, hleft, Matrix.toLin_one]
      rfl
    · rw [ContinuousLinearMap.star_eq_adjoint]
      apply ContinuousLinearMap.coe_injective
      rw [ContinuousLinearMap.toLinearMap_mul, ← ContinuousLinearMap.adjoint_toLinearMap,
        ContinuousLinearMap.toLinearMap_one]
      simp only [u, LinearMap.coe_toContinuousLinearMap]
      rw [← Matrix.toEuclideanLin_conjTranspose_eq_adjoint]
      rw [Matrix.toEuclideanLin_eq_toLin_orthonormal, Module.End.mul_eq_comp,
        ← Matrix.toLin_mul, hright, Matrix.toLin_one]
      rfl
  exact Unitary.linearIsometryEquiv ⟨u, hu⟩

/-- **BG-ALIGNMENT-DEF-022** — A unitary gauge chosen independently at each
point of a finite mesh. -/
abbrev FiniteMeshUnitaryField (Mesh Retained : Type*)
    [Fintype Retained] [DecidableEq Retained] :=
  Mesh → Matrix.unitaryGroup Retained ℂ

/-- **BG-ALIGNMENT-DEF-023** — The unweighted finite-mesh sum of pointwise
right-unitary squared Frobenius objectives. -/
noncomputable def finiteMeshProcrustesObjective
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained] [DecidableEq Retained]
    (candidate reference : Mesh → Matrix Ambient Retained ℂ)
    (gauge : FiniteMeshUnitaryField Mesh Retained) : ℝ :=
  ∑ k, rightUnitaryProcrustesObjective (candidate k) (reference k) (gauge k)

/-- **BG-ALIGNMENT-DEF-024** — A single unitary used at every mesh point. -/
def constantFiniteMeshUnitaryField
    {Mesh Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    FiniteMeshUnitaryField Mesh Retained :=
  fun _ => gauge

/-- **BG-ALIGNMENT-DEF-025** — The identity unitary at every mesh point. -/
def identityFiniteMeshUnitaryField
    {Mesh Retained : Type*} [Fintype Retained] [DecidableEq Retained] :
    FiniteMeshUnitaryField Mesh Retained :=
  constantFiniteMeshUnitaryField (1 : Matrix.unitaryGroup Retained ℂ)

/-- **BG-ALIGNMENT-DEF-026** — One supplied exact right-polar witness for the
pointwise cross matrix at every mesh point. -/
abbrev FiniteMeshRightPolarWitness
    {Mesh Ambient Retained : Type*}
    [Fintype Ambient] [Fintype Retained] [DecidableEq Retained]
    (candidate reference : Mesh → Matrix Ambient Retained ℂ) :=
  ∀ k, RightUnitaryProcrustesPolarWitness (candidate k) (reference k)

/-- **BG-ALIGNMENT-DEF-027** — The pointwise unitary field supplied by a finite
mesh of exact polar witnesses. -/
def finiteMeshPolarMinimizerField
    {Mesh Ambient Retained : Type*}
    [Fintype Ambient] [Fintype Retained] [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    (witness : FiniteMeshRightPolarWitness candidate reference) :
    FiniteMeshUnitaryField Mesh Retained :=
  fun k => (witness k).minimizer

/-- **BG-ALIGNMENT-DEF-028** — An exact known-inverse control: applying the
supplied unitary field to the candidate frame gives the reference frame at every
mesh point. -/
def IsKnownInverseUnitaryField
    {Mesh Ambient Retained : Type*}
    [Fintype Retained] [DecidableEq Retained]
    (candidate reference : Mesh → Matrix Ambient Retained ℂ)
    (gauge : FiniteMeshUnitaryField Mesh Retained) : Prop :=
  ∀ k, candidate k * (gauge k : Matrix Retained Retained ℂ) = reference k

/-- **BG-ALIGNMENT-DEF-029** — Embed a matrix unitary field into the existing
abstract alignment-field carrier on retained Euclidean spaces. -/
noncomputable def matrixUnitaryAlignmentField
    {Mesh Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge : FiniteMeshUnitaryField Mesh Retained) :
    AlignmentField Mesh (EuclideanSpace ℂ Retained) (EuclideanSpace ℂ Retained) :=
  fun k => matrixUnitaryAlignment (gauge k)

/-- **BG-ALIGNMENT-THM-046** — The identity matrix induces the identity
alignment. -/
theorem matrixUnitaryAlignment_one
    {Retained : Type*} [Fintype Retained] [DecidableEq Retained] :
    matrixUnitaryAlignment (1 : Matrix.unitaryGroup Retained ℂ) =
      LinearIsometryEquiv.refl ℂ (EuclideanSpace ℂ Retained) := by
  apply LinearIsometryEquiv.ext
  intro x
  change Matrix.toEuclideanLin (1 : Matrix Retained Retained ℂ) x = x
  rw [Matrix.toEuclideanLin_eq_toLin_orthonormal, Matrix.toLin_one,
    LinearMap.id_apply]

/-- **BG-ALIGNMENT-THM-047** — Every matrix unitary field belongs to the
existing complete pointwise-unitary alignment family. -/
theorem matrixUnitaryAlignmentField_mem_complete
    {Mesh Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge : FiniteMeshUnitaryField Mesh Retained) :
    matrixUnitaryAlignmentField gauge ∈
      completeAlignmentFamily (K := Mesh) (Eref := EuclideanSpace ℂ Retained)
        (Ecand := EuclideanSpace ℂ Retained) := by
  trivial

/-- **BG-ALIGNMENT-THM-048** — A constant matrix unitary field maps into the
existing global-unitary alignment family. -/
theorem constantMatrixUnitaryAlignmentField_mem_global
    {Mesh Retained : Type*} [Fintype Retained] [DecidableEq Retained]
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    matrixUnitaryAlignmentField
        (constantFiniteMeshUnitaryField (Mesh := Mesh) gauge) ∈
      globalAlignmentFamily (K := Mesh) (Eref := EuclideanSpace ℂ Retained)
        (Ecand := EuclideanSpace ℂ Retained) := by
  exact ⟨matrixUnitaryAlignment gauge, rfl⟩

/-- **BG-ALIGNMENT-THM-049** — The identity matrix field maps into the existing
identity alignment family. -/
theorem identityMatrixUnitaryAlignmentField_mem_identity
    {Mesh Retained : Type*} [Fintype Retained] [DecidableEq Retained] :
    matrixUnitaryAlignmentField
        (identityFiniteMeshUnitaryField (Mesh := Mesh) (Retained := Retained)) ∈
      identityAlignmentFamily (K := Mesh) (E := EuclideanSpace ℂ Retained) := by
  rw [identityAlignmentFamily, singletonAlignmentFamily, Set.mem_singleton_iff]
  funext k
  exact matrixUnitaryAlignment_one

/-- **BG-ALIGNMENT-THM-050** — The finite-mesh objective is nonnegative. -/
theorem finiteMeshProcrustesObjective_nonneg
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained] [DecidableEq Retained]
    (candidate reference : Mesh → Matrix Ambient Retained ℂ)
    (gauge : FiniteMeshUnitaryField Mesh Retained) :
    0 ≤ finiteMeshProcrustesObjective candidate reference gauge := by
  rw [finiteMeshProcrustesObjective]
  apply Finset.sum_nonneg
  intro k _
  rw [rightUnitaryProcrustesObjective, frobeniusPower_eq_norm_sq]
  exact sq_nonneg _

/-- **BG-ALIGNMENT-THM-051** — Every supplied local polar witness minimizes its
pointwise objective. -/
theorem finiteMeshPolarMinimizer_pointwise
    {Mesh Ambient Retained : Type*}
    [Fintype Ambient] [Fintype Retained] [DecidableEq Ambient] [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    (witness : FiniteMeshRightPolarWitness candidate reference)
    (gauge : FiniteMeshUnitaryField Mesh Retained) (k : Mesh) :
    rightUnitaryProcrustesObjective (candidate k) (reference k)
        (finiteMeshPolarMinimizerField witness k) ≤
      rightUnitaryProcrustesObjective (candidate k) (reference k) (gauge k) :=
  (witness k).objective_minimal (gauge k)

/-- **BG-ALIGNMENT-THM-052** — Pointwise exact polar witnesses jointly minimize
the summed finite-mesh objective. -/
theorem finiteMeshPolarMinimizer_is_global
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained]
    [DecidableEq Ambient] [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    (witness : FiniteMeshRightPolarWitness candidate reference)
    (gauge : FiniteMeshUnitaryField Mesh Retained) :
    finiteMeshProcrustesObjective candidate reference
        (finiteMeshPolarMinimizerField witness) ≤
      finiteMeshProcrustesObjective candidate reference gauge := by
  rw [finiteMeshProcrustesObjective, finiteMeshProcrustesObjective]
  apply Finset.sum_le_sum
  intro k _
  exact finiteMeshPolarMinimizer_pointwise witness gauge k

/-- **BG-ALIGNMENT-THM-053** — If every supplied positive factor is positive
definite, equality in the summed objective forces equality with the pointwise
polar-minimizer field. -/
theorem finiteMeshPolarMinimizer_unique
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained]
    [DecidableEq Ambient] [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    (witness : FiniteMeshRightPolarWitness candidate reference)
    (hPos : ∀ k : Mesh, (witness k).positiveFactor.PosDef)
    (gauge : FiniteMeshUnitaryField Mesh Retained)
    (hObjective : finiteMeshProcrustesObjective candidate reference gauge =
      finiteMeshProcrustesObjective candidate reference
        (finiteMeshPolarMinimizerField witness)) :
    gauge = finiteMeshPolarMinimizerField witness := by
  funext k
  apply (witness k).eq_minimizer_of_objective_eq (hPos k) (gauge k)
  by_contra hne
  have hlt : rightUnitaryProcrustesObjective (candidate k) (reference k)
        (finiteMeshPolarMinimizerField witness k) <
      rightUnitaryProcrustesObjective (candidate k) (reference k) (gauge k) :=
    lt_of_le_of_ne (finiteMeshPolarMinimizer_pointwise witness gauge k)
      (Ne.symm hne)
  have hsumlt : finiteMeshProcrustesObjective candidate reference
        (finiteMeshPolarMinimizerField witness) <
      finiteMeshProcrustesObjective candidate reference gauge := by
    rw [finiteMeshProcrustesObjective, finiteMeshProcrustesObjective]
    apply Finset.sum_lt_sum
    · intro i _
      exact finiteMeshPolarMinimizer_pointwise witness gauge i
    · exact ⟨k, Finset.mem_univ k, hlt⟩
  exact (ne_of_lt hsumlt) hObjective.symm

/-- **BG-ALIGNMENT-THM-054** — The pointwise polar field is no worse than any
single constant global unitary. -/
theorem finiteMeshPolarMinimizer_le_constant
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained]
    [DecidableEq Ambient] [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    (witness : FiniteMeshRightPolarWitness candidate reference)
    (gauge : Matrix.unitaryGroup Retained ℂ) :
    finiteMeshProcrustesObjective candidate reference
        (finiteMeshPolarMinimizerField witness) ≤
      finiteMeshProcrustesObjective candidate reference
        (constantFiniteMeshUnitaryField gauge) :=
  finiteMeshPolarMinimizer_is_global witness _

/-- **BG-ALIGNMENT-THM-055** — The pointwise polar field is no worse than the
identity alignment. -/
theorem finiteMeshPolarMinimizer_le_identity
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained]
    [DecidableEq Ambient] [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    (witness : FiniteMeshRightPolarWitness candidate reference) :
    finiteMeshProcrustesObjective candidate reference
        (finiteMeshPolarMinimizerField witness) ≤
      finiteMeshProcrustesObjective candidate reference
        (identityFiniteMeshUnitaryField (Mesh := Mesh) (Retained := Retained)) :=
  finiteMeshPolarMinimizer_is_global witness _

/-- **BG-ALIGNMENT-THM-056** — An exact known-inverse control has zero summed
objective. -/
theorem knownInverseUnitaryField_objective_zero
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained]
    [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    {gauge : FiniteMeshUnitaryField Mesh Retained}
    (hOracle : IsKnownInverseUnitaryField candidate reference gauge) :
    finiteMeshProcrustesObjective candidate reference gauge = 0 := by
  rw [finiteMeshProcrustesObjective]
  apply Finset.sum_eq_zero
  intro k _
  rw [rightUnitaryProcrustesObjective, rightUnitaryFrame, hOracle k, sub_self,
    frobeniusPower]
  simp

/-- **BG-ALIGNMENT-THM-057** — A known-inverse control is a global minimizer,
because its exact objective is zero and every finite-mesh objective is
nonnegative. -/
theorem knownInverseUnitaryField_is_global
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained]
    [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    {oracle : FiniteMeshUnitaryField Mesh Retained}
    (hOracle : IsKnownInverseUnitaryField candidate reference oracle)
    (gauge : FiniteMeshUnitaryField Mesh Retained) :
    finiteMeshProcrustesObjective candidate reference oracle ≤
      finiteMeshProcrustesObjective candidate reference gauge := by
  rw [knownInverseUnitaryField_objective_zero hOracle]
  exact finiteMeshProcrustesObjective_nonneg candidate reference gauge

/-- **BG-ALIGNMENT-THM-058** — Under pointwise positive definiteness, an exact
known-inverse control agrees with the unique pointwise polar-minimizer field. -/
theorem knownInverseUnitaryField_eq_polarMinimizer
    {Mesh Ambient Retained : Type*}
    [Fintype Mesh] [Fintype Ambient] [Fintype Retained]
    [DecidableEq Ambient] [DecidableEq Retained]
    {candidate reference : Mesh → Matrix Ambient Retained ℂ}
    (witness : FiniteMeshRightPolarWitness candidate reference)
    (hPos : ∀ k : Mesh, (witness k).positiveFactor.PosDef)
    (oracle : FiniteMeshUnitaryField Mesh Retained)
    (hOracle : IsKnownInverseUnitaryField candidate reference oracle) :
    oracle = finiteMeshPolarMinimizerField witness := by
  apply finiteMeshPolarMinimizer_unique witness hPos oracle
  apply le_antisymm
  · rw [knownInverseUnitaryField_objective_zero hOracle]
    exact finiteMeshProcrustesObjective_nonneg candidate reference _
  · exact finiteMeshPolarMinimizer_is_global witness oracle

end ProjectKoios.BandGauge.Alignment

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-02
-/
module

public import Mathlib.GroupTheory.Index
public import Mathlib.GroupTheory.QuotientGroup.Basic
public import Mathlib.LinearAlgebra.Matrix.Adjugate
public import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Exact admission of integer coordinate maps to lattice quotients

This module separates three questions that must not be conflated:

1. whether an integer matrix preserves a lattice and therefore induces a quotient map;
2. whether an inverse matrix also preserves the lattice; and
3. whether the two induced quotient maps are mutually inverse and hence bijective.

For `L = B ℤ³`, the certificate `A * B = B * C` with integer `C` is the exact
integrality criterion corresponding to `B⁻¹ A B = C` whenever `B` is invertible over
`ℚ`. The theorem itself does not divide by `B`; it checks the stronger implementation-ready
integer identity directly.

These declarations concern exact integer arithmetic only. They do not authenticate a runtime
mesh or array, establish numerical convergence, or validate a scientific calculation.
-/

@[expose] public section

namespace ProjectKoios.SolidState.FiniteLattice

open Matrix

/-- `SS-QUOTIENT-DEF-001`: three exact integer lattice coordinates. -/
abbrev IntegerCoordinate3 := Fin 3 → ℤ

/-- `SS-QUOTIENT-DEF-002`: the additive coordinate map induced by an integer matrix. -/
def integerMatrixCoordinateMap (A : Matrix (Fin 3) (Fin 3) ℤ) :
    IntegerCoordinate3 →+ IntegerCoordinate3 :=
  (Matrix.mulVecLin A).toAddMonoidHom

/-- `SS-QUOTIENT-DEF-003`: the integer lattice `B ℤ³`, represented as the range of
column-coordinate multiplication by `B`. -/
def integerMatrixLattice (B : Matrix (Fin 3) (Fin 3) ℤ) : AddSubgroup IntegerCoordinate3 :=
  (integerMatrixCoordinateMap B).range

/-- `SS-QUOTIENT-DEF-004`: exact well-definedness criterion for a matrix action on
`ℤ³ / L`: the matrix sends every vector in `L` back into `L`. -/
def IntegerMatrixPreservesLattice
    (L : AddSubgroup IntegerCoordinate3)
    (A : Matrix (Fin 3) (Fin 3) ℤ) : Prop :=
  ∀ ⦃x : IntegerCoordinate3⦄, x ∈ L → A *ᵥ x ∈ L

/-- `SS-QUOTIENT-DEF-005`: an implementation-ready integer certificate for preservation of
`B ℤ³`. The witness equation is `A B = B C`; for nonsingular `B`, this says exactly that
`B⁻¹ A B` has the integer matrix `C`. -/
def IntegerLatticeMapCertificate
    (B A C : Matrix (Fin 3) (Fin 3) ℤ) : Prop :=
  A * B = B * C

/-- `SS-QUOTIENT-DEF-006`: the quotient-coordinate map induced by a supplied proof that
`A` preserves `L`. The preservation proof is the well-definedness boundary. -/
def integerLatticeQuotientMap
    (L : AddSubgroup IntegerCoordinate3)
    (A : Matrix (Fin 3) (Fin 3) ℤ)
    (hA : IntegerMatrixPreservesLattice L A) :
    IntegerCoordinate3 ⧸ L →+ IntegerCoordinate3 ⧸ L :=
  QuotientAddGroup.map L L (integerMatrixCoordinateMap A) (by
    intro x hx
    exact hA hx)

/-- `SS-QUOTIENT-DEF-007`: the coordinatewise scalar sublattice `nℤ³`. -/
def integerScalarLattice (n : ℕ) : AddSubgroup IntegerCoordinate3 where
  carrier := {x | ∀ i, (n : ℤ) ∣ x i}
  zero_mem' := fun _ => dvd_zero _
  add_mem' := by
    intro x y hx hy i
    exact dvd_add (hx i) (hy i)
  neg_mem' := by
    intro x hx i
    exact dvd_neg.mpr (hx i)

/-- `SS-QUOTIENT-DEF-008`: coordinatewise reduction modulo one common natural modulus. -/
def integerScalarModMap (n : ℕ) : IntegerCoordinate3 →+ (Fin 3 → ZMod n) :=
  AddMonoidHom.pi fun i =>
    (Int.castAddHom (ZMod n)).comp (Pi.evalAddMonoidHom (fun _ : Fin 3 => ℤ) i)

/-- `SS-QUOTIENT-LEM-003`: coordinatewise reduction has kernel `nℤ³`. -/
lemma integerScalarModMap_ker (n : ℕ) :
    (integerScalarModMap n).ker = integerScalarLattice n := by
  ext x
  constructor
  · intro hx i
    have hi := congrFun hx i
    change ((x i : ℤ) : ZMod n) = 0 at hi
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd (x i) n).mp hi
  · intro hx
    funext i
    change ((x i : ℤ) : ZMod n) = 0
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd (x i) n).mpr (hx i)

/-- `SS-QUOTIENT-THM-004`: positive common modulus gives a finite cubic quotient. -/
theorem finite_integerScalarLattice_quotient (n : ℕ) (hn : 0 < n) :
    Finite (IntegerCoordinate3 ⧸ integerScalarLattice n) := by
  let : NeZero n := ⟨Nat.ne_of_gt hn⟩
  rw [← integerScalarModMap_ker n]
  exact Finite.of_injective
    (QuotientAddGroup.quotientKerEquivRange (integerScalarModMap n)).toFun
    (QuotientAddGroup.quotientKerEquivRange (integerScalarModMap n)).injective

/-- `SS-QUOTIENT-LEM-004`: the scalar lattice at `|det B|` lies in `Bℤ³`.

The witness follows from `B adj(B) = det(B) I`. The integer sign converts `det B` to
its natural absolute value. At determinant zero this is the trivial zero-subgroup inclusion.
-/
lemma integerScalarLattice_le_integerMatrixLattice
    (B : Matrix (Fin 3) (Fin 3) ℤ) :
    integerScalarLattice B.det.natAbs ≤ integerMatrixLattice B := by
  intro x hx
  let y : IntegerCoordinate3 := fun i => Classical.choose (hx i)
  let z : IntegerCoordinate3 := fun i => B.det.sign * y i
  refine ⟨B.adjugate *ᵥ z, ?_⟩
  change B *ᵥ (B.adjugate *ᵥ z) = x
  rw [Matrix.mulVec_mulVec, Matrix.mul_adjugate, Matrix.smul_mulVec, Matrix.one_mulVec]
  funext i
  change B.det * (B.det.sign * y i) = x i
  rw [← mul_assoc, mul_comm B.det B.det.sign, Int.sign_mul_self]
  exact (Classical.choose_spec (hx i)).symm

/-- `SS-QUOTIENT-THM-005`: a full-rank integer generator has a finite quotient.

Here full rank is expressed exactly as `det B ≠ 0`. This theorem supplies the finiteness
component independently of quotient-map well-definedness or bijectivity.
-/
theorem finite_integerMatrixLattice_quotient_of_det_ne_zero
    (B : Matrix (Fin 3) (Fin 3) ℤ) (hdet : B.det ≠ 0) :
    Finite (IntegerCoordinate3 ⧸ integerMatrixLattice B) := by
  let : Finite (IntegerCoordinate3 ⧸ integerScalarLattice B.det.natAbs) :=
    finite_integerScalarLattice_quotient B.det.natAbs (Int.natAbs_pos.mpr hdet)
  let : (integerScalarLattice B.det.natAbs).FiniteIndex :=
    AddSubgroup.finiteIndex_of_finite_quotient
  let : (integerMatrixLattice B).FiniteIndex :=
    AddSubgroup.finiteIndex_of_le (integerScalarLattice_le_integerMatrixLattice B)
  exact AddSubgroup.finite_quotient_of_finiteIndex

/-- `SS-QUOTIENT-LEM-001`: an integer conjugation certificate proves lattice preservation,
and hence supplies the well-definedness premise for the quotient map. -/
lemma integerLatticeMapCertificate_preserves
    (B A C : Matrix (Fin 3) (Fin 3) ℤ)
    (h : IntegerLatticeMapCertificate B A C) :
    IntegerMatrixPreservesLattice (integerMatrixLattice B) A := by
  intro x hx
  rcases hx with ⟨y, rfl⟩
  refine ⟨C *ᵥ y, ?_⟩
  change B *ᵥ (C *ᵥ y) = A *ᵥ (B *ᵥ y)
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, h]

/-- `SS-QUOTIENT-THM-006`: preservation of `Bℤ³` is equivalent to existence of an exact
integer conjugation certificate `A B = B C`.

The reverse direction constructs the columns of `C` from the preserved images of the columns of
`B`. Thus the certificate is complete for quotient-map well-definedness, not merely sufficient.
-/
theorem exists_integerLatticeMapCertificate_iff
    (B A : Matrix (Fin 3) (Fin 3) ℤ) :
    (∃ C, IntegerLatticeMapCertificate B A C) ↔
      IntegerMatrixPreservesLattice (integerMatrixLattice B) A := by
  constructor
  · rintro ⟨C, hC⟩
    exact integerLatticeMapCertificate_preserves B A C hC
  · intro hA
    have hcol : ∀ j : Fin 3, ∃ z : IntegerCoordinate3,
        B *ᵥ z = (A * B) *ᵥ (Pi.single j 1) := by
      intro j
      obtain ⟨z, hz⟩ := hA ⟨Pi.single j 1, rfl⟩
      change B *ᵥ z = A *ᵥ (B *ᵥ (Pi.single j 1)) at hz
      rw [Matrix.mulVec_mulVec] at hz
      exact ⟨z, hz⟩
    let C : Matrix (Fin 3) (Fin 3) ℤ := fun i j => Classical.choose (hcol j) i
    refine ⟨C, ?_⟩
    ext i j
    have hj := Classical.choose_spec (hcol j)
    calc
      (A * B) i j = ((A * B) *ᵥ (Pi.single j 1)) i := by
        rw [Matrix.mulVec_single_one]
        rfl
      _ = (B *ᵥ Classical.choose (hcol j)) i := congrFun hj.symm i
      _ = (B * C) i j := by
        rfl

/-- `SS-QUOTIENT-LEM-002`: the induced map sends the class of `x` to the class of `A x`. -/
lemma integerLatticeQuotientMap_mk
    (L : AddSubgroup IntegerCoordinate3)
    (A : Matrix (Fin 3) (Fin 3) ℤ)
    (hA : IntegerMatrixPreservesLattice L A)
    (x : IntegerCoordinate3) :
    integerLatticeQuotientMap L A hA (QuotientAddGroup.mk' L x) =
      QuotientAddGroup.mk' L (A *ᵥ x) := by
  simp [integerLatticeQuotientMap, integerMatrixCoordinateMap]

/-- `SS-QUOTIENT-THM-001`: two-sided integer inverses that each preserve `L` induce
mutually inverse quotient maps. This theorem distinguishes well-definedness of each map from
bijectivity of the resulting coordinate change. -/
theorem integerLatticeQuotientMap_mutualInverse
    (L : AddSubgroup IntegerCoordinate3)
    (A Ainv : Matrix (Fin 3) (Fin 3) ℤ)
    (hA : IntegerMatrixPreservesLattice L A)
    (hAinv : IntegerMatrixPreservesLattice L Ainv)
    (hA_Ainv : A * Ainv = 1)
    (hAinv_A : Ainv * A = 1) :
    Function.LeftInverse
        (integerLatticeQuotientMap L Ainv hAinv)
        (integerLatticeQuotientMap L A hA) ∧
      Function.RightInverse
        (integerLatticeQuotientMap L Ainv hAinv)
        (integerLatticeQuotientMap L A hA) := by
  constructor
  · intro q
    refine QuotientAddGroup.induction_on q ?_
    intro x
    change integerLatticeQuotientMap L Ainv hAinv
        (integerLatticeQuotientMap L A hA (QuotientAddGroup.mk' L x)) =
      QuotientAddGroup.mk' L x
    rw [integerLatticeQuotientMap_mk, integerLatticeQuotientMap_mk,
      Matrix.mulVec_mulVec, hAinv_A]
    simp
  · intro q
    refine QuotientAddGroup.induction_on q ?_
    intro x
    change integerLatticeQuotientMap L A hA
        (integerLatticeQuotientMap L Ainv hAinv (QuotientAddGroup.mk' L x)) =
      QuotientAddGroup.mk' L x
    rw [integerLatticeQuotientMap_mk, integerLatticeQuotientMap_mk,
      Matrix.mulVec_mulVec, hA_Ainv]
    simp

/-- `SS-QUOTIENT-THM-002`: the admitted quotient-coordinate map is bijective. -/
theorem integerLatticeQuotientMap_bijective
    (L : AddSubgroup IntegerCoordinate3)
    (A Ainv : Matrix (Fin 3) (Fin 3) ℤ)
    (hA : IntegerMatrixPreservesLattice L A)
    (hAinv : IntegerMatrixPreservesLattice L Ainv)
    (hA_Ainv : A * Ainv = 1)
    (hAinv_A : Ainv * A = 1) :
    Function.Bijective (integerLatticeQuotientMap L A hA) := by
  constructor
  · exact (integerLatticeQuotientMap_mutualInverse L A Ainv hA hAinv
      hA_Ainv hAinv_A).1.injective
  · exact (integerLatticeQuotientMap_mutualInverse L A Ainv hA hAinv
      hA_Ainv hAinv_A).2.surjective

/-- `SS-QUOTIENT-THM-003`: two integer conjugation certificates plus two-sided inverse
identities are a usable sufficient admission criterion for a bijection of `ℤ³ / Bℤ³`. -/
theorem integerLatticeMapCertificates_bijective
    (B A Ainv C Cinv : Matrix (Fin 3) (Fin 3) ℤ)
    (hA : IntegerLatticeMapCertificate B A C)
    (hAinv : IntegerLatticeMapCertificate B Ainv Cinv)
    (hA_Ainv : A * Ainv = 1)
    (hAinv_A : Ainv * A = 1) :
    Function.Bijective
      (integerLatticeQuotientMap (integerMatrixLattice B) A
        (integerLatticeMapCertificate_preserves B A C hA)) :=
  integerLatticeQuotientMap_bijective
    (integerMatrixLattice B) A Ainv
    (integerLatticeMapCertificate_preserves B A C hA)
    (integerLatticeMapCertificate_preserves B Ainv Cinv hAinv)
    hA_Ainv hAinv_A

end ProjectKoios.SolidState.FiniteLattice

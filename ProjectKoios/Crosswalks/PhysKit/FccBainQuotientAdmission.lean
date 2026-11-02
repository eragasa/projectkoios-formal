/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-02
-/
module

public import ProjectKoios.Crosswalks.PhysKit.FccBainCoordinateBridge
public import ProjectKoios.SolidState.FiniteLattice.QuotientAdmission
public import Mathlib.GroupTheory.Index
public import Mathlib.Tactic.FinCases

/-!
# Finite-quotient admission for the exact FCC--Bain integer map

This module checks when the exact integer matrix

```text
U = ((1,1,0),(0,0,1),(0,-1,0))
```

and its declared inverse descend to a mixed diagonal quotient lattice. For moduli
`(N₁,N₂,N₃)`, the exact condition is

```text
0 < N₁, 0 < N₂, 0 < N₃, N₂ = N₃, and N₁ ∣ N₂.
```

Both preservation directions are proved separately before quotient bijectivity is concluded.
Thus an unsupported mixed quotient is rejected rather than silently treated as admitted.

The results are exact coordinate and quotient algebra. They do not prove runtime mesh identity,
numerical convergence, execution correctness, or a scientific claim.
-/

@[expose] public section

namespace ProjectKoios.Crosswalks.PhysKit

open Matrix
open ProjectKoios.SolidState.FiniteLattice

/-- `PKF-PHYSKIT-QUOTIENT-DEF-001`: the diagonal integer lattice with coordinate moduli
`N₁`, `N₂`, and `N₃`. Membership means coordinatewise divisibility. -/
def integerDiagonalLattice (N : Fin 3 → ℕ) : AddSubgroup IntegerCoordinate3 where
  carrier := {x | ∀ i, (N i : ℤ) ∣ x i}
  zero_mem' := fun i => dvd_zero _
  add_mem' := by
    intro x y hx hy i
    exact dvd_add (hx i) (hy i)
  neg_mem' := by
    intro x hx i
    exact dvd_neg.mpr (hx i)

/-- `PKF-PHYSKIT-QUOTIENT-DEF-002`: exact positive-modulus and two-sided lattice
preservation required before the fixed Bain map is admitted on a mixed quotient. -/
def BainMixedModuliLatticeAdmitted (N : Fin 3 → ℕ) : Prop :=
  (∀ i, 0 < N i) ∧
    IntegerMatrixPreservesLattice (integerDiagonalLattice N) bainToFccMatrix ∧
    IntegerMatrixPreservesLattice (integerDiagonalLattice N) fccToBainMatrix

/-- `PKF-PHYSKIT-QUOTIENT-DEF-003`: a small decidable natural-arithmetic certificate that
owner calculations can reproduce without coupling repositories. -/
def BainMixedModuliAdmissionCertificate (N₁ N₂ N₃ : ℕ) : Prop :=
  0 < N₁ ∧ 0 < N₂ ∧ 0 < N₃ ∧ N₂ = N₃ ∧ N₁ ∣ N₂

/-- `PKF-PHYSKIT-QUOTIENT-DEF-004`: coordinatewise reduction from `ℤ³` to the finite
product of cyclic quotients. -/
def integerDiagonalModMap (N : Fin 3 → ℕ) :
    IntegerCoordinate3 →+ ((i : Fin 3) → ZMod (N i)) :=
  AddMonoidHom.pi fun i =>
    (Int.castAddHom (ZMod (N i))).comp
      (Pi.evalAddMonoidHom (fun _ : Fin 3 => ℤ) i)

/-- `PKF-PHYSKIT-QUOTIENT-LEM-001`: the coordinatewise divisibility lattice is exactly
`diag(N₁,N₂,N₃) ℤ³`. -/
lemma integerDiagonalLattice_eq_integerMatrixLattice (N : Fin 3 → ℕ) :
    integerDiagonalLattice N =
      integerMatrixLattice (Matrix.diagonal (fun i => (N i : ℤ))) := by
  ext x
  constructor
  · intro hx
    let y : IntegerCoordinate3 := fun i => Classical.choose (hx i)
    refine ⟨y, ?_⟩
    funext i
    change (Matrix.diagonal (fun i => (N i : ℤ)) *ᵥ y) i = x i
    rw [Matrix.mulVec_diagonal]
    exact (Classical.choose_spec (hx i)).symm
  · rintro ⟨y, hy⟩ i
    refine ⟨y i, ?_⟩
    rw [← hy]
    change (Matrix.diagonal (fun i => (N i : ℤ)) *ᵥ y) i = _
    rw [Matrix.mulVec_diagonal]

/-- `PKF-PHYSKIT-QUOTIENT-LEM-002`: the diagonal lattice is the kernel of coordinatewise
reduction modulo the three periods. -/
lemma integerDiagonalModMap_ker (N : Fin 3 → ℕ) :
    (integerDiagonalModMap N).ker = integerDiagonalLattice N := by
  ext x
  constructor
  · intro hx i
    have hi := congrFun hx i
    change ((x i : ℤ) : ZMod (N i)) = 0 at hi
    exact ZMod.intCast_zmod_eq_zero_iff_dvd (x i) (N i) |>.mp hi
  · intro hx
    funext i
    change ((x i : ℤ) : ZMod (N i)) = 0
    exact ZMod.intCast_zmod_eq_zero_iff_dvd (x i) (N i) |>.mpr (hx i)

/-- `PKF-PHYSKIT-QUOTIENT-THM-001`: positive diagonal periods make the quotient lattice
finite. This establishes the finite-mesh property independently of Bain-map admission. -/
theorem finite_integerDiagonalLattice_quotient
    (N : Fin 3 → ℕ)
    (hpos : ∀ i, 0 < N i) :
    Finite (IntegerCoordinate3 ⧸ integerDiagonalLattice N) := by
  let (i : Fin 3) : NeZero (N i) := ⟨Nat.ne_of_gt (hpos i)⟩
  rw [← integerDiagonalModMap_ker N]
  exact Finite.of_injective
    (QuotientAddGroup.quotientKerEquivRange (integerDiagonalModMap N)).toFun
    (QuotientAddGroup.quotientKerEquivRange (integerDiagonalModMap N)).injective

/-- `PKF-PHYSKIT-QUOTIENT-LEM-003`: exact action of the selected forward matrix. -/
lemma bainToFccMatrix_mulVec (x : IntegerCoordinate3) :
    bainToFccMatrix *ᵥ x = ![x 0 + x 1, x 2, -x 1] := by
  funext i
  fin_cases i <;>
    simp [bainToFccMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]

/-- `PKF-PHYSKIT-QUOTIENT-LEM-004`: exact action of the selected inverse matrix. -/
lemma fccToBainMatrix_mulVec (x : IntegerCoordinate3) :
    fccToBainMatrix *ᵥ x = ![x 0 + x 2, -x 2, x 1] := by
  funext i
  fin_cases i <;>
    simp [fccToBainMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]

/-- `PKF-PHYSKIT-QUOTIENT-THM-002`: the forward matrix preserves a mixed diagonal lattice
if and only if the second and third moduli agree and the first divides the second. This is the
well-definedness theorem for the forward quotient map. -/
theorem bainToFccMatrix_preserves_integerDiagonalLattice_iff
    (N : Fin 3 → ℕ) :
    IntegerMatrixPreservesLattice (integerDiagonalLattice N) bainToFccMatrix ↔
      N 1 = N 2 ∧ N 0 ∣ N 1 := by
  constructor
  · intro h
    have hx1 : (![0, (N 1 : ℤ), 0] : IntegerCoordinate3) ∈ integerDiagonalLattice N := by
      intro i
      fin_cases i <;> simp
    have hx2 : (![0, 0, (N 2 : ℤ)] : IntegerCoordinate3) ∈ integerDiagonalLattice N := by
      intro i
      fin_cases i <;> simp
    have hy1 := h hx1
    have hy2 := h hx2
    rw [bainToFccMatrix_mulVec] at hy1 hy2
    have h12z : (N 2 : ℤ) ∣ (N 1 : ℤ) := by
      simpa using hy1 (2 : Fin 3)
    have h21z : (N 1 : ℤ) ∣ (N 2 : ℤ) := by
      simpa using hy2 (1 : Fin 3)
    have h01z : (N 0 : ℤ) ∣ (N 1 : ℤ) := by
      simpa using hy1 (0 : Fin 3)
    have h12 : N 2 ∣ N 1 := Int.natCast_dvd_natCast.mp h12z
    have h21 : N 1 ∣ N 2 := Int.natCast_dvd_natCast.mp h21z
    exact ⟨Nat.dvd_antisymm h21 h12, Int.natCast_dvd_natCast.mp h01z⟩
  · rintro ⟨h12, h01⟩ x hx
    rw [bainToFccMatrix_mulVec]
    intro i
    fin_cases i
    · simpa using dvd_add (hx 0) ((Int.natCast_dvd_natCast.mpr h01).trans (hx 1))
    · simpa [h12] using hx (2 : Fin 3)
    · simpa [← h12] using dvd_neg.mpr (hx 1)

/-- `PKF-PHYSKIT-QUOTIENT-THM-003`: the inverse matrix has exactly the same mixed-modulus
preservation condition. This is a separate well-definedness theorem, not a consequence of the
forward map being well-defined. -/
theorem fccToBainMatrix_preserves_integerDiagonalLattice_iff
    (N : Fin 3 → ℕ) :
    IntegerMatrixPreservesLattice (integerDiagonalLattice N) fccToBainMatrix ↔
      N 1 = N 2 ∧ N 0 ∣ N 1 := by
  constructor
  · intro h
    have hx1 : (![0, (N 1 : ℤ), 0] : IntegerCoordinate3) ∈ integerDiagonalLattice N := by
      intro i
      fin_cases i <;> simp
    have hx2 : (![0, 0, (N 2 : ℤ)] : IntegerCoordinate3) ∈ integerDiagonalLattice N := by
      intro i
      fin_cases i <;> simp
    have hy1 := h hx1
    have hy2 := h hx2
    rw [fccToBainMatrix_mulVec] at hy1 hy2
    have h12z : (N 2 : ℤ) ∣ (N 1 : ℤ) := by
      simpa using hy1 (2 : Fin 3)
    have h21z : (N 1 : ℤ) ∣ (N 2 : ℤ) := by
      simpa using hy2 (1 : Fin 3)
    have h02z : (N 0 : ℤ) ∣ (N 2 : ℤ) := by
      simpa using hy2 (0 : Fin 3)
    have h12 : N 2 ∣ N 1 := Int.natCast_dvd_natCast.mp h12z
    have h21 : N 1 ∣ N 2 := Int.natCast_dvd_natCast.mp h21z
    have heq := Nat.dvd_antisymm h21 h12
    refine ⟨heq, ?_⟩
    rw [heq]
    exact Int.natCast_dvd_natCast.mp h02z
  · rintro ⟨h12, h01⟩ x hx
    rw [fccToBainMatrix_mulVec]
    intro i
    have h02 : (N 0 : ℤ) ∣ (N 2 : ℤ) := by
      simpa [← h12] using Int.natCast_dvd_natCast.mpr h01
    fin_cases i
    · simpa using dvd_add (hx 0) (h02.trans (hx 2))
    · simpa [h12] using dvd_neg.mpr (hx 2)
    · simpa [← h12] using hx (1 : Fin 3)

/-- `PKF-PHYSKIT-QUOTIENT-THM-004`: complete exact admission criterion for positive mixed
moduli. -/
theorem bainMixedModuliLatticeAdmitted_iff (N : Fin 3 → ℕ) :
    BainMixedModuliLatticeAdmitted N ↔
      (∀ i, 0 < N i) ∧ N 1 = N 2 ∧ N 0 ∣ N 1 := by
  rw [BainMixedModuliLatticeAdmitted,
    bainToFccMatrix_preserves_integerDiagonalLattice_iff,
    fccToBainMatrix_preserves_integerDiagonalLattice_iff]
  tauto

/-- `PKF-PHYSKIT-QUOTIENT-THM-005`: the three-number certificate is equivalent to exact
lattice admission. -/
theorem bainMixedModuliAdmissionCertificate_iff
    (N₁ N₂ N₃ : ℕ) :
    BainMixedModuliAdmissionCertificate N₁ N₂ N₃ ↔
      BainMixedModuliLatticeAdmitted ![N₁, N₂, N₃] := by
  rw [bainMixedModuliLatticeAdmitted_iff]
  constructor
  · rintro ⟨h₁, h₂, h₃, h₂₃, h₁₂⟩
    refine ⟨?_, h₂₃, h₁₂⟩
    intro i
    fin_cases i <;> assumption
  · rintro ⟨hpos, h₂₃, h₁₂⟩
    exact ⟨hpos 0, hpos 1, hpos 2, h₂₃, h₁₂⟩

/-- `PKF-PHYSKIT-QUOTIENT-THM-006`: every positive cubic quotient `N ℤ³` is admitted. -/
theorem bain_cubic_integerDiagonalLattice_admitted (N : ℕ) (hN : 0 < N) :
    BainMixedModuliLatticeAdmitted (fun _ : Fin 3 => N) := by
  rw [bainMixedModuliLatticeAdmitted_iff]
  exact ⟨fun _ => hN, rfl, dvd_refl N⟩

/-- `PKF-PHYSKIT-QUOTIENT-THM-007`: on every admitted positive mixed quotient, the induced
forward coordinate map is bijective. -/
theorem bain_integerDiagonalLattice_quotientMap_bijective
    (N : Fin 3 → ℕ)
    (h : BainMixedModuliLatticeAdmitted N) :
    Function.Bijective
      (integerLatticeQuotientMap
        (integerDiagonalLattice N)
        bainToFccMatrix h.2.1) :=
  integerLatticeQuotientMap_bijective
    (integerDiagonalLattice N)
    bainToFccMatrix fccToBainMatrix
    h.2.1 h.2.2
    bainToFccMatrix_mul_fccToBainMatrix
    fccToBainMatrix_mul_bainToFccMatrix

/-- `PKF-PHYSKIT-QUOTIENT-THM-008`: if either mixed-modulus equality or divisibility fails,
the positive quotient is not admitted. -/
theorem bain_mixed_integerDiagonalLattice_not_admitted
    (N : Fin 3 → ℕ)
    (hbad : N 1 ≠ N 2 ∨ ¬ N 0 ∣ N 1) :
    ¬ BainMixedModuliLatticeAdmitted N := by
  rw [bainMixedModuliLatticeAdmitted_iff]
  tauto

end ProjectKoios.Crosswalks.PhysKit

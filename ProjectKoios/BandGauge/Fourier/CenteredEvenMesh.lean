/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteReconstruction
public import ProjectKoios.BandGauge.Fourier.MatrixFrobenius
public import Mathlib.Data.Int.Interval

/-!
# Centered even finite-mode inventories

This module records the exact integer inventory used by a positive even finite mesh.  The centered
representative at index `j` is `j - N / 2`, so the representatives are
`{-N/2, ..., N/2 - 1}`.  It then isolates deletion of the self-inverse negative Nyquist
representative from any later symmetric support truncation.

The reconstruction theorem is kernel-agnostic: it proves that the full finite synthesis is the
negative-Nyquist-removed synthesis plus the one deleted term.  It does not identify a NumPy FFT,
`fftshift`, floating-point array, serialized result, reciprocal coordinate, or runtime calculation
with these exact declarations.  The normalized deleted-block power uses the explicit entrywise
squared Frobenius sum and is not an off-mesh error or an ordinary omitted-tail norm.
-/

@[expose] public section

open scoped BigOperators

namespace ProjectKoios.BandGauge.Fourier

/-- `BG-FOURIER-DEF-032`: a positive even finite-mesh size. -/
structure CenteredEvenMesh where
  pointCount : ℕ
  pointCount_pos : 0 < pointCount
  pointCount_even : Even pointCount

namespace CenteredEvenMesh

/-- `BG-FOURIER-DEF-033`: half of the positive even mesh size. -/
def halfCount (mesh : CenteredEvenMesh) : ℕ := mesh.pointCount / 2

/-- `BG-FOURIER-THM-076`: doubling the half-count recovers the even point count. -/
theorem two_mul_halfCount (mesh : CenteredEvenMesh) :
    2 * mesh.halfCount = mesh.pointCount := by
  exact Nat.two_mul_div_two_of_even mesh.pointCount_even

/-- `BG-FOURIER-DEF-034`: the self-inverse negative Nyquist integer representative. -/
def negativeNyquist (mesh : CenteredEvenMesh) : ℤ :=
  -(mesh.halfCount : ℤ)

/-- `BG-FOURIER-DEF-035`: the half-open centered integer inventory `[-N/2, N/2)`. -/
def centeredRepresentatives (mesh : CenteredEvenMesh) : Finset ℤ :=
  Finset.Ico mesh.negativeNyquist (mesh.halfCount : ℤ)

/-- `BG-FOURIER-DEF-036`: a mode carrying proof that its integer representative is centered. -/
abbrev Mode (mesh : CenteredEvenMesh) :=
  {representative : ℤ // representative ∈ mesh.centeredRepresentatives}

/-- `BG-FOURIER-DEF-037`: the centered integer representative at a finite array index. -/
def centeredRepresentativeAt (mesh : CenteredEvenMesh)
    (index : Fin mesh.pointCount) : ℤ :=
  (index : ℤ) - (mesh.halfCount : ℤ)

/-- `BG-FOURIER-THM-077`: every centered array-index representative belongs to the inventory. -/
theorem centeredRepresentativeAt_mem (mesh : CenteredEvenMesh)
    (index : Fin mesh.pointCount) :
    mesh.centeredRepresentativeAt index ∈ mesh.centeredRepresentatives := by
  rw [centeredRepresentatives, Finset.mem_Ico]
  have htwo := mesh.two_mul_halfCount
  have hindex := index.isLt
  constructor <;> simp only [centeredRepresentativeAt, negativeNyquist] <;> omega

/-- `BG-FOURIER-DEF-038`: exact equivalence between array indices and centered modes. -/
noncomputable def centeredIndexEquiv (mesh : CenteredEvenMesh) :
    Fin mesh.pointCount ≃ mesh.Mode :=
  Equiv.ofBijective
    (fun index =>
      ⟨mesh.centeredRepresentativeAt index, mesh.centeredRepresentativeAt_mem index⟩)
    (by
      constructor
      · intro first second heq
        apply Fin.ext
        have hval := congrArg Subtype.val heq
        simp only [centeredRepresentativeAt] at hval
        exact_mod_cast (sub_left_inj.mp hval)
      · rintro ⟨representative, hrepresentative⟩
        rw [centeredRepresentatives, Finset.mem_Ico] at hrepresentative
        have htwo := mesh.two_mul_halfCount
        have hnonnegative : 0 ≤ representative + (mesh.halfCount : ℤ) := by
          simp only [negativeNyquist] at hrepresentative
          omega
        have hless : representative + (mesh.halfCount : ℤ) < (mesh.pointCount : ℤ) := by
          simp only [negativeNyquist] at hrepresentative
          omega
        have hindex :
            (representative + (mesh.halfCount : ℤ)).toNat < mesh.pointCount := by
          rw [Int.toNat_lt hnonnegative]
          exact hless
        let index : Fin mesh.pointCount :=
          ⟨(representative + (mesh.halfCount : ℤ)).toNat, hindex⟩
        refine ⟨index, ?_⟩
        apply Subtype.ext
        simp only [centeredRepresentativeAt, index]
        rw [Int.toNat_of_nonneg hnonnegative]
        omega)

/-- `BG-FOURIER-THM-078`: the centered-index equivalence uses the formula `j - N/2`. -/
theorem centeredIndexEquiv_apply (mesh : CenteredEvenMesh)
    (index : Fin mesh.pointCount) :
    ((mesh.centeredIndexEquiv index : mesh.Mode) : ℤ) =
      (index : ℤ) - (mesh.halfCount : ℤ) := by
  rfl

/-- `BG-FOURIER-THM-079`: the centered integer inventory has exactly `N` elements. -/
theorem card_centeredRepresentatives (mesh : CenteredEvenMesh) :
    mesh.centeredRepresentatives.card = mesh.pointCount := by
  rw [centeredRepresentatives, Int.card_Ico]
  simp only [negativeNyquist, sub_neg_eq_add]
  rw [Int.toNat_add (by positivity) (by positivity)]
  simp only [Int.toNat_natCast]
  simpa [two_mul] using mesh.two_mul_halfCount

/-- `BG-FOURIER-THM-080`: the negative Nyquist representative belongs to the inventory. -/
theorem negativeNyquist_mem_centeredRepresentatives (mesh : CenteredEvenMesh) :
    mesh.negativeNyquist ∈ mesh.centeredRepresentatives := by
  rw [centeredRepresentatives, Finset.mem_Ico]
  constructor
  · exact le_rfl
  · simp only [negativeNyquist]
    have hhalf : 0 < mesh.halfCount := by
      have htwo := mesh.two_mul_halfCount
      have hpositive := mesh.pointCount_pos
      omega
    exact neg_lt_self (by exact_mod_cast hhalf)

/-- `BG-FOURIER-DEF-039`: the centered mode at the negative Nyquist representative. -/
def negativeNyquistMode (mesh : CenteredEvenMesh) : mesh.Mode :=
  ⟨mesh.negativeNyquist, mesh.negativeNyquist_mem_centeredRepresentatives⟩

/-- `BG-FOURIER-DEF-040`: the complete centered inventory with negative Nyquist deleted. -/
def negativeNyquistRemovedSupport (mesh : CenteredEvenMesh) : Finset mesh.Mode :=
  Finset.univ.erase mesh.negativeNyquistMode

/-- `BG-FOURIER-THM-081`: deleting negative Nyquist omits exactly that one centered mode. -/
@[simp] theorem negativeNyquistRemovedSupport_compl (mesh : CenteredEvenMesh) :
    mesh.negativeNyquistRemovedSupportᶜ = {mesh.negativeNyquistMode} := by
  ext mode
  simp [negativeNyquistRemovedSupport]

/-- `BG-FOURIER-DEF-041`: centered integer representatives after deleting negative Nyquist. -/
def ordinaryRepresentatives (mesh : CenteredEvenMesh) : Finset ℤ :=
  mesh.centeredRepresentatives.erase mesh.negativeNyquist

/-- `BG-FOURIER-THM-082`: the ordinary representative inventory is the declared singleton deletion. -/
theorem ordinaryRepresentatives_eq_erase_negativeNyquist (mesh : CenteredEvenMesh) :
    mesh.ordinaryRepresentatives =
      mesh.centeredRepresentatives.erase mesh.negativeNyquist := by
  rfl

/-- `BG-FOURIER-DEF-042`: the symmetric ordinary integer support `[-R, R]`. -/
def symmetricIntegerSupport (maximumRange : ℕ) : Finset ℤ :=
  Finset.Icc (-(maximumRange : ℤ)) (maximumRange : ℤ)

/-- `BG-FOURIER-THM-083`: symmetric ordinary integer support is closed under negation. -/
theorem mem_symmetricIntegerSupport_neg_iff
    (maximumRange : ℕ) (representative : ℤ) :
    representative ∈ symmetricIntegerSupport maximumRange ↔
      -representative ∈ symmetricIntegerSupport maximumRange := by
  simp only [symmetricIntegerSupport, Finset.mem_Icc]
  constructor <;> omega

/-- `BG-FOURIER-THM-084`: for `R < N/2`, symmetric support lies in the ordinary inventory. -/
theorem symmetricIntegerSupport_subset_ordinaryRepresentatives
    (mesh : CenteredEvenMesh) (maximumRange : ℕ)
    (hRange : maximumRange < mesh.halfCount) :
    symmetricIntegerSupport maximumRange ⊆ mesh.ordinaryRepresentatives := by
  intro representative hrepresentative
  rw [symmetricIntegerSupport, Finset.mem_Icc] at hrepresentative
  rw [ordinaryRepresentatives, Finset.mem_erase]
  constructor
  · simp only [negativeNyquist]
    omega
  · rw [centeredRepresentatives, Finset.mem_Ico]
    simp only [negativeNyquist]
    constructor <;> omega

/-- `BG-FOURIER-THM-085`: a symmetric range below `N/2` excludes negative Nyquist. -/
theorem negativeNyquist_not_mem_symmetricIntegerSupport
    (mesh : CenteredEvenMesh) (maximumRange : ℕ)
    (hRange : maximumRange < mesh.halfCount) :
    mesh.negativeNyquist ∉ symmetricIntegerSupport maximumRange := by
  intro hmember
  have hsubset := mesh.symmetricIntegerSupport_subset_ordinaryRepresentatives
    maximumRange hRange
  have hordinary := hsubset hmember
  exact (Finset.mem_erase.mp hordinary).1 rfl

end CenteredEvenMesh

/-- `BG-FOURIER-DEF-043`: reconstruction after deleting exactly negative Nyquist. -/
def negativeNyquistRemovedReconstruction
    {Momentum V : Type*} [AddCommMonoid V] [Module ℂ V]
    (mesh : CenteredEvenMesh)
    (phase : Momentum → mesh.Mode → ℂ)
    (coefficients : mesh.Mode → V)
    (momentum : Momentum) : V :=
  truncatedReconstruction phase mesh.negativeNyquistRemovedSupport coefficients momentum

/-- `BG-FOURIER-THM-086`: full synthesis is removed synthesis plus the negative Nyquist term. -/
theorem finiteReconstruction_eq_negativeNyquistRemoved_add
    {Momentum V : Type*} [AddCommMonoid V] [Module ℂ V]
    (mesh : CenteredEvenMesh)
    (phase : Momentum → mesh.Mode → ℂ)
    (coefficients : mesh.Mode → V)
    (momentum : Momentum) :
    finiteReconstruction phase coefficients momentum =
      negativeNyquistRemovedReconstruction mesh phase coefficients momentum +
        phase momentum mesh.negativeNyquistMode • coefficients mesh.negativeNyquistMode := by
  calc
    finiteReconstruction phase coefficients momentum =
        truncatedReconstruction phase mesh.negativeNyquistRemovedSupport coefficients momentum +
          ∑ mode ∈ mesh.negativeNyquistRemovedSupportᶜ,
            phase momentum mode • coefficients mode :=
      finiteReconstruction_eq_truncated_add_omitted
    _ = negativeNyquistRemovedReconstruction mesh phase coefficients momentum +
          phase momentum mesh.negativeNyquistMode • coefficients mesh.negativeNyquistMode := by
      simp [negativeNyquistRemovedReconstruction]

/-- `BG-FOURIER-DEF-044`: normalized entrywise power of the deleted negative Nyquist block. -/
noncomputable def normalizedNegativeNyquistPower
    {ι : Type*} [Fintype ι] [Nonempty ι]
    (mesh : CenteredEvenMesh)
    (coefficients : mesh.Mode → Matrix ι ι ℂ) : ℝ :=
  (∑ row, ∑ column,
      ‖coefficients mesh.negativeNyquistMode row column‖ ^ 2) /
    (Fintype.card ι : ℝ)

/-- `BG-FOURIER-THM-087`: singleton omitted weight equals normalized deleted-block power. -/
theorem normalizedNegativeNyquistPower_eq_removed_omittedWeight
    {ι : Type*} [Fintype ι] [Nonempty ι]
    (mesh : CenteredEvenMesh)
    (coefficients : mesh.Mode → Matrix ι ι ℂ) :
    normalizedNegativeNyquistPower mesh coefficients =
      omittedWeight
          (fun mode => ∑ row, ∑ column, ‖coefficients mode row column‖ ^ 2)
          mesh.negativeNyquistRemovedSupport /
        (Fintype.card ι : ℝ) := by
  simp [normalizedNegativeNyquistPower, omittedWeight]

/-- `BG-FOURIER-THM-088`: deleted-block power is independent of later support range. -/
theorem normalizedNegativeNyquistPower_range_independent
    {ι : Type*} [Fintype ι] [Nonempty ι]
    (mesh : CenteredEvenMesh)
    (coefficients : mesh.Mode → Matrix ι ι ℂ)
    (firstRange secondRange : ℕ) :
    (fun _maximumRange : ℕ => normalizedNegativeNyquistPower mesh coefficients) firstRange =
      (fun _maximumRange : ℕ => normalizedNegativeNyquistPower mesh coefficients) secondRange := by
  rfl

end ProjectKoios.BandGauge.Fourier

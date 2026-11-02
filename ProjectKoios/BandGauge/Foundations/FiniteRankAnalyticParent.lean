/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# Finite-rank analytic parent qualification

This module isolates exact real-algebra properties of a finite-rank analytic parent family.  The
formulas use an abstract structure-factor value in `[-1, 1]`; no reciprocal-space mesh, numerical
trigonometric evaluation, eigensolver, runtime array, or scientific applicability is encoded.
-/

@[expose] public section

open scoped BigOperators

namespace ProjectKoios.BandGauge.Foundations

/-- `BG-FOUNDATION-DEF-017`: evenly spaced orbital coordinate for a finite retained rank. -/
noncomputable def finiteRankOrbitalCoordinate (rank index : ℕ) : ℝ :=
  (2 * (index : ℝ) - rank + 1) / ((rank : ℝ) - 1)

/-- `BG-FOUNDATION-DEF-018`: retained-sector energy of the analytic parent. -/
noncomputable def finiteRankRetainedEnergy (orbital parentScale structureFactor : ℝ) : ℝ :=
  (2 / 5 : ℝ) * orbital +
    (1 / 4 : ℝ) * parentScale * (1 + (1 / 5 : ℝ) * orbital) * structureFactor

/-- `BG-FOUNDATION-DEF-019`: exterior-sector energy of the analytic parent. -/
noncomputable def finiteRankExteriorEnergy (orbital parentScale structureFactor : ℝ) : ℝ :=
  3 + (3 / 10 : ℝ) * orbital +
    (1 / 10 : ℝ) * parentScale * structureFactor

/-- `BG-FOUNDATION-DEF-020`: the weighted first/second cosine harmonic used for every bond. -/
noncomputable def finiteRankBondHarmonic (phase : ℝ) : ℝ :=
  (3 / 4 : ℝ) * Real.cos phase + (1 / 4 : ℝ) * Real.cos (2 * phase)

/-- `BG-FOUNDATION-DEF-021`: equal-weight average of the bond harmonics on a nonempty finite
bond inventory. -/
noncomputable def finiteRankStructureFactor
    {Bond : Type*} [Fintype Bond] [Nonempty Bond] (phase : Bond → ℝ) : ℝ :=
  (∑ bond, finiteRankBondHarmonic (phase bond)) / Fintype.card Bond

/-- `BG-FOUNDATION-LEM-001`: an admissible scale times a bounded structure factor remains in
`[-1, 1]`. -/
lemma parentScale_mul_structureFactor_mem_Icc
    {parentScale structureFactor : ℝ}
    (hscale : parentScale ∈ Set.Icc 0 1)
    (hstructure : structureFactor ∈ Set.Icc (-1) 1) :
    parentScale * structureFactor ∈ Set.Icc (-1 : ℝ) 1 := by
  have hscaleAbs : |parentScale| ≤ 1 :=
    abs_le.mpr ⟨le_trans (by norm_num) hscale.1, hscale.2⟩
  have hstructureAbs : |structureFactor| ≤ 1 := abs_le.mpr hstructure
  have hproductAbs : |parentScale * structureFactor| ≤ 1 := by
    rw [abs_mul]
    calc
      |parentScale| * |structureFactor| ≤ 1 * 1 :=
        mul_le_mul hscaleAbs hstructureAbs (abs_nonneg _) (by norm_num)
      _ = 1 := by norm_num
  exact abs_le.mp hproductAbs

/-- `BG-FOUNDATION-THM-026`: every weighted first/second cosine harmonic belongs to
`[-1, 1]`. -/
theorem finiteRankBondHarmonic_mem_Icc (phase : ℝ) :
    finiteRankBondHarmonic phase ∈ Set.Icc (-1 : ℝ) 1 := by
  have hfirst := Real.neg_one_le_cos phase
  have hfirst' := Real.cos_le_one phase
  have hsecond := Real.neg_one_le_cos (2 * phase)
  have hsecond' := Real.cos_le_one (2 * phase)
  rw [finiteRankBondHarmonic]
  constructor <;> norm_num [div_eq_mul_inv] <;> linarith

/-- `BG-FOUNDATION-THM-027`: every nonempty finite bond average belongs to `[-1, 1]`. -/
theorem finiteRankStructureFactor_mem_Icc
    {Bond : Type*} [Fintype Bond] [Nonempty Bond] (phase : Bond → ℝ) :
    finiteRankStructureFactor phase ∈ Set.Icc (-1 : ℝ) 1 := by
  have hcardNat : 0 < Fintype.card Bond := Fintype.card_pos
  have hcard : (0 : ℝ) < Fintype.card Bond := by exact_mod_cast hcardNat
  have hlower :
      ∑ bond : Bond, (-1 : ℝ) ≤ ∑ bond, finiteRankBondHarmonic (phase bond) := by
    exact Finset.sum_le_sum fun bond _ => (finiteRankBondHarmonic_mem_Icc (phase bond)).1
  have hupper :
      ∑ bond : Bond, finiteRankBondHarmonic (phase bond) ≤ ∑ _bond : Bond, (1 : ℝ) := by
    exact Finset.sum_le_sum fun bond _ => (finiteRankBondHarmonic_mem_Icc (phase bond)).2
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at hlower hupper
  rw [finiteRankStructureFactor]
  constructor
  · apply (le_div_iff₀ hcard).2
    simpa only [neg_mul, one_mul, mul_neg, mul_one] using hlower
  · apply (div_le_iff₀ hcard).2
    simpa only [one_mul, mul_one] using hupper

/-- `BG-FOUNDATION-THM-028`: every selected finite-rank orbital coordinate lies in
`[-1, 1]`. -/
theorem finiteRankOrbitalCoordinate_mem_Icc
    {rank index : ℕ} (hrank : 2 ≤ rank) (hindex : index < rank) :
    finiteRankOrbitalCoordinate rank index ∈ Set.Icc (-1 : ℝ) 1 := by
  have hrankReal : (2 : ℝ) ≤ rank := by exact_mod_cast hrank
  have hindexNonneg : (0 : ℝ) ≤ index := by positivity
  have hindexUpper : (index : ℝ) + 1 ≤ rank := by
    exact_mod_cast (Nat.succ_le_iff.mpr hindex)
  have hden : 0 < (rank : ℝ) - 1 := by linarith
  rw [finiteRankOrbitalCoordinate]
  constructor
  · apply (le_div_iff₀ hden).2
    nlinarith
  · apply (div_le_iff₀ hden).2
    nlinarith

/-- `BG-FOUNDATION-LEM-002`: adjacent orbital coordinates differ by `2 / (rank - 1)`. -/
lemma finiteRankOrbitalCoordinate_succ_sub
    {rank index : ℕ} (hrank : 2 ≤ rank) :
    finiteRankOrbitalCoordinate rank (index + 1) -
        finiteRankOrbitalCoordinate rank index =
      2 / ((rank : ℝ) - 1) := by
  have hrankReal : (2 : ℝ) ≤ rank := by exact_mod_cast hrank
  have hden : (rank : ℝ) - 1 ≠ 0 := by linarith
  rw [finiteRankOrbitalCoordinate, finiteRankOrbitalCoordinate]
  field_simp
  push_cast
  ring

/-- `BG-FOUNDATION-THM-029`: every retained-sector energy is at most `7/10`. -/
theorem finiteRankRetainedEnergy_le
    {orbital parentScale structureFactor : ℝ}
    (horbital : orbital ∈ Set.Icc (-1) 1)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (hstructure : structureFactor ∈ Set.Icc (-1) 1) :
    finiteRankRetainedEnergy orbital parentScale structureFactor ≤ (7 / 10 : ℝ) := by
  have hproduct := parentScale_mul_structureFactor_mem_Icc hscale hstructure
  let product := parentScale * structureFactor
  have hcoefficient : 0 ≤ (2 / 5 : ℝ) + (1 / 20 : ℝ) * product := by
    dsimp [product]
    norm_num at hproduct ⊢
    linarith [hproduct.1]
  have horbitalBound :
      ((2 / 5 : ℝ) + (1 / 20 : ℝ) * product) * orbital ≤
        (2 / 5 : ℝ) + (1 / 20 : ℝ) * product :=
    mul_le_of_le_one_right hcoefficient horbital.2
  have henergy :
      finiteRankRetainedEnergy orbital parentScale structureFactor =
        ((2 / 5 : ℝ) + (1 / 20 : ℝ) * product) * orbital + (1 / 4 : ℝ) * product := by
    simp only [finiteRankRetainedEnergy, product]
    ring
  rw [henergy]
  norm_num at horbitalBound hproduct ⊢
  linarith [hproduct.2]

/-- `BG-FOUNDATION-THM-030`: every exterior-sector energy is at least `13/5`. -/
theorem finiteRankExteriorEnergy_ge
    {orbital parentScale structureFactor : ℝ}
    (horbital : orbital ∈ Set.Icc (-1) 1)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (hstructure : structureFactor ∈ Set.Icc (-1) 1) :
    (13 / 5 : ℝ) ≤ finiteRankExteriorEnergy orbital parentScale structureFactor := by
  have hproduct := parentScale_mul_structureFactor_mem_Icc hscale hstructure
  rw [finiteRankExteriorEnergy]
  have horbitalLower := horbital.1
  have hproductLower := hproduct.1
  norm_num [div_eq_mul_inv] at horbitalLower hproductLower ⊢
  linarith

/-- `BG-FOUNDATION-THM-031`: every exterior energy is separated from every retained energy by at
least `19/10`. -/
theorem finiteRank_externalGap_ge
    {retainedOrbital exteriorOrbital parentScale structureFactor : ℝ}
    (hretained : retainedOrbital ∈ Set.Icc (-1) 1)
    (hexterior : exteriorOrbital ∈ Set.Icc (-1) 1)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (hstructure : structureFactor ∈ Set.Icc (-1) 1) :
    (19 / 10 : ℝ) ≤
      finiteRankExteriorEnergy exteriorOrbital parentScale structureFactor -
        finiteRankRetainedEnergy retainedOrbital parentScale structureFactor := by
  have hretainedUpper := finiteRankRetainedEnergy_le hretained hscale hstructure
  have hexteriorLower := finiteRankExteriorEnergy_ge hexterior hscale hstructure
  linarith

/-- `BG-FOUNDATION-LEM-003`: the difference of two retained energies factors through the orbital
coordinate difference. -/
lemma finiteRankRetainedEnergy_sub
    (upper lower parentScale structureFactor : ℝ) :
    finiteRankRetainedEnergy upper parentScale structureFactor -
        finiteRankRetainedEnergy lower parentScale structureFactor =
      (upper - lower) *
        ((2 / 5 : ℝ) + (1 / 20 : ℝ) * parentScale * structureFactor) := by
  simp only [finiteRankRetainedEnergy]
  ring

/-- `BG-FOUNDATION-THM-033`: retained energies are strictly ordered whenever their orbital
coordinates are strictly ordered. -/
theorem finiteRankRetainedEnergy_strictMono
    {lower upper parentScale structureFactor : ℝ}
    (horbital : lower < upper)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (hstructure : structureFactor ∈ Set.Icc (-1) 1) :
    finiteRankRetainedEnergy lower parentScale structureFactor <
      finiteRankRetainedEnergy upper parentScale structureFactor := by
  have hproduct := parentScale_mul_structureFactor_mem_Icc hscale hstructure
  have hcoefficient :
      0 < (2 / 5 : ℝ) + (1 / 20 : ℝ) * parentScale * structureFactor := by
    norm_num at hproduct ⊢
    linarith [hproduct.1]
  rw [sub_pos.symm, finiteRankRetainedEnergy_sub]
  exact mul_pos (sub_pos.mpr horbital) hcoefficient

/-- `BG-FOUNDATION-THM-034`: adjacent retained energies have the explicit positive lower gap
`7 / (10 * (rank - 1))`. -/
theorem finiteRankRetainedEnergy_adjacentGap_ge
    {rank index : ℕ} {parentScale structureFactor : ℝ}
    (hrank : 2 ≤ rank)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (hstructure : structureFactor ∈ Set.Icc (-1) 1) :
    7 / (10 * ((rank : ℝ) - 1)) ≤
      finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank (index + 1))
          parentScale structureFactor -
        finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank index)
          parentScale structureFactor := by
  have hrankReal : (2 : ℝ) ≤ rank := by exact_mod_cast hrank
  have hden : 0 < (rank : ℝ) - 1 := by linarith
  have hproduct := parentScale_mul_structureFactor_mem_Icc hscale hstructure
  have hcoefficient :
      (7 / 20 : ℝ) ≤
        (2 / 5 : ℝ) + (1 / 20 : ℝ) * parentScale * structureFactor := by
    norm_num at hproduct ⊢
    linarith [hproduct.1]
  rw [finiteRankRetainedEnergy_sub, finiteRankOrbitalCoordinate_succ_sub hrank]
  have hfactor : 0 ≤ 2 / ((rank : ℝ) - 1) := (div_nonneg (by norm_num) hden.le)
  have hmul := mul_le_mul_of_nonneg_left hcoefficient hfactor
  have hleft :
      7 / (10 * ((rank : ℝ) - 1)) =
        (2 / ((rank : ℝ) - 1)) * (7 / 20 : ℝ) := by
    field_simp
    ring
  rw [hleft]
  exact hmul

/-- `BG-FOUNDATION-THM-035`: the explicit finite-bond analytic parent has external gap at least
`19/10` at every pair of retained/exterior orbital indices. -/
theorem finiteRankStructureFactor_externalGap_ge
    {Bond : Type*} [Fintype Bond] [Nonempty Bond]
    {rank retainedIndex exteriorIndex : ℕ} {parentScale : ℝ}
    (hrank : 2 ≤ rank)
    (hretainedIndex : retainedIndex < rank)
    (hexteriorIndex : exteriorIndex < rank)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (phase : Bond → ℝ) :
    (19 / 10 : ℝ) ≤
      finiteRankExteriorEnergy (finiteRankOrbitalCoordinate rank exteriorIndex)
          parentScale (finiteRankStructureFactor phase) -
        finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank retainedIndex)
          parentScale (finiteRankStructureFactor phase) := by
  exact finiteRank_externalGap_ge
    (finiteRankOrbitalCoordinate_mem_Icc hrank hretainedIndex)
    (finiteRankOrbitalCoordinate_mem_Icc hrank hexteriorIndex)
    hscale
    (finiteRankStructureFactor_mem_Icc phase)

/-- `BG-FOUNDATION-THM-036`: the explicit finite-bond analytic parent has the declared adjacent
retained-energy lower gap. -/
theorem finiteRankStructureFactor_adjacentGap_ge
    {Bond : Type*} [Fintype Bond] [Nonempty Bond]
    {rank index : ℕ} {parentScale : ℝ}
    (hrank : 2 ≤ rank)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (phase : Bond → ℝ) :
    7 / (10 * ((rank : ℝ) - 1)) ≤
      finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank (index + 1))
          parentScale (finiteRankStructureFactor phase) -
        finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank index)
          parentScale (finiteRankStructureFactor phase) := by
  exact finiteRankRetainedEnergy_adjacentGap_ge hrank hscale
    (finiteRankStructureFactor_mem_Icc phase)

/-- `BG-FOUNDATION-THM-037`: adjacent selected retained energies are strictly ordered. -/
theorem finiteRankStructureFactor_adjacent_strictMono
    {Bond : Type*} [Fintype Bond] [Nonempty Bond]
    {rank index : ℕ} {parentScale : ℝ}
    (hrank : 2 ≤ rank)
    (_hindex : index + 1 < rank)
    (hscale : parentScale ∈ Set.Icc 0 1)
    (phase : Bond → ℝ) :
    finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank index)
        parentScale (finiteRankStructureFactor phase) <
      finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank (index + 1))
        parentScale (finiteRankStructureFactor phase) := by
  have hrankReal : (2 : ℝ) ≤ rank := by exact_mod_cast hrank
  have hrankMinus : 0 < (rank : ℝ) - 1 := by linarith
  have hden : 0 < 10 * ((rank : ℝ) - 1) := mul_pos (by norm_num) hrankMinus
  have hlower : (0 : ℝ) < 7 / (10 * ((rank : ℝ) - 1)) := div_pos (by norm_num) hden
  have hgap :
      7 / (10 * ((rank : ℝ) - 1)) ≤
        finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank (index + 1))
            parentScale (finiteRankStructureFactor phase) -
          finiteRankRetainedEnergy (finiteRankOrbitalCoordinate rank index)
            parentScale (finiteRankStructureFactor phase) :=
    finiteRankStructureFactor_adjacentGap_ge hrank hscale phase
  exact sub_pos.mp (lt_of_lt_of_le hlower hgap)

end ProjectKoios.BandGauge.Foundations

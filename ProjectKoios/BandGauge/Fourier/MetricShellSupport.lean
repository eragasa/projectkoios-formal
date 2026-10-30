/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-30
-/
module

public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Data.Finset.Image
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Complete finite metric-shell supports

This module defines the exact support obtained by retaining every member of a declared finite
inventory whose exact radius is at most a cutoff. It proves nesting, equal-radius tie retention,
closure under supplied inversion and symmetry invariances, strict growth at every attained radius,
and the fact that every support change is witnessed by an attained radius. Thus an inventory of all
attained radii through a cap cannot skip an intermediate attainable shell.

The square, triangular, simple-cubic, and FCC declarations are exact dimensionless integer shell
indices in reduced lattice coordinates. They do not bind a serialized inventory, lattice constant,
physical hopping range, runtime shell generator, Fourier coefficient, numerical error, continuum
limit, material model, or scientific acceptance decision. Symmetry completeness remains
conditional on the caller supplying an inventory and action that satisfy the explicit invariance
hypotheses. A complete metric shell is not thereby a source-defined physical hopping range.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Fourier

variable {Mode Radius Symmetry : Type*}

/-- `BG-FOURIER-DEF-045`: all declared modes with exact radius at most `cutoff`. -/
def metricShell [DecidableEq Mode] [LinearOrder Radius]
    (inventory : Finset Mode) (radius : Mode → Radius) (cutoff : Radius) : Finset Mode :=
  inventory.filter fun mode => radius mode ≤ cutoff

/-- `BG-FOURIER-DEF-046`: every distinct radius attained by the declared finite inventory. -/
def attainedMetricRadii [DecidableEq Mode] [DecidableEq Radius]
    (inventory : Finset Mode) (radius : Mode → Radius) : Finset Radius :=
  inventory.image radius

/-- `BG-FOURIER-DEF-047`: every attained radius no larger than the declared cap. -/
def attainedMetricRadiiThrough [DecidableEq Mode] [LinearOrder Radius]
    (inventory : Finset Mode) (radius : Mode → Radius) (cap : Radius) : Finset Radius :=
  (attainedMetricRadii inventory radius).filter fun value => value ≤ cap

variable [DecidableEq Mode] [LinearOrder Radius]

/-- `BG-FOURIER-THM-089`: attained-radius membership has an exact inventory witness. -/
@[simp]
theorem mem_attainedMetricRadii {inventory : Finset Mode}
    {radius : Mode → Radius} {value : Radius} :
    value ∈ attainedMetricRadii inventory radius ↔
      ∃ mode ∈ inventory, radius mode = value := by
  simp [attainedMetricRadii]

/-- `BG-FOURIER-THM-090`: capped attained-radius membership is exact witness membership plus the cap. -/
@[simp]
theorem mem_attainedMetricRadiiThrough {inventory : Finset Mode}
    {radius : Mode → Radius} {cap value : Radius} :
    value ∈ attainedMetricRadiiThrough inventory radius cap ↔
      (∃ mode ∈ inventory, radius mode = value) ∧ value ≤ cap := by
  simp [attainedMetricRadiiThrough]

/-- `BG-FOURIER-THM-091`: shell membership is inventory membership plus the radius cutoff. -/
@[simp]
theorem mem_metricShell {inventory : Finset Mode} {radius : Mode → Radius}
    {cutoff : Radius} {mode : Mode} :
    mode ∈ metricShell inventory radius cutoff ↔
      mode ∈ inventory ∧ radius mode ≤ cutoff := by
  simp [metricShell]

/-- `BG-FOURIER-THM-092`: increasing the cap preserves every previously attained radius. -/
theorem attainedMetricRadiiThrough_mono (inventory : Finset Mode) (radius : Mode → Radius)
    {first second : Radius} (hcutoff : first ≤ second) :
    attainedMetricRadiiThrough inventory radius first ⊆
      attainedMetricRadiiThrough inventory radius second := by
  intro value hvalue
  rw [mem_attainedMetricRadiiThrough] at hvalue ⊢
  exact ⟨hvalue.1, hvalue.2.trans hcutoff⟩

/-- `BG-FOURIER-THM-093`: a metric shell never adds a mode outside the declared inventory. -/
theorem metricShell_subset_inventory (inventory : Finset Mode) (radius : Mode → Radius)
    (cutoff : Radius) :
    metricShell inventory radius cutoff ⊆ inventory := by
  intro mode hmode
  exact (mem_metricShell.mp hmode).1

/-- `BG-FOURIER-THM-094`: metric shells are nested under cutoff relaxation. -/
theorem metricShell_mono (inventory : Finset Mode) (radius : Mode → Radius)
    {first second : Radius} (hcutoff : first ≤ second) :
    metricShell inventory radius first ⊆ metricShell inventory radius second := by
  intro mode hmode
  rw [mem_metricShell] at hmode ⊢
  exact ⟨hmode.1, hmode.2.trans hcutoff⟩

/-- `BG-FOURIER-THM-095`: two inventoried modes with equal radius are retained together. -/
theorem metricShell_tie_iff {inventory : Finset Mode} {radius : Mode → Radius}
    {cutoff : Radius} {first second : Mode}
    (hfirst : first ∈ inventory) (hsecond : second ∈ inventory)
    (hradius : radius first = radius second) :
    first ∈ metricShell inventory radius cutoff ↔
      second ∈ metricShell inventory radius cutoff := by
  simp only [mem_metricShell, hfirst, hsecond, true_and]
  rw [hradius]

/-- `BG-FOURIER-THM-096`: supplied inventory and radius inversion invariance passes to every shell. -/
theorem neg_mem_metricShell_iff [Neg Mode]
    {inventory : Finset Mode} {radius : Mode → Radius} {cutoff : Radius}
    (hinventory : ∀ mode, -mode ∈ inventory ↔ mode ∈ inventory)
    (hradius : ∀ mode, radius (-mode) = radius mode)
    (mode : Mode) :
    -mode ∈ metricShell inventory radius cutoff ↔
      mode ∈ metricShell inventory radius cutoff := by
  simp only [mem_metricShell, hinventory, hradius]

/-- `BG-FOURIER-THM-097`: supplied inventory and radius action invariance passes to every shell. -/
theorem smul_mem_metricShell_iff [SMul Symmetry Mode]
    {inventory : Finset Mode} {radius : Mode → Radius} {cutoff : Radius}
    (hinventory : ∀ (symmetry : Symmetry) (mode : Mode),
      symmetry • mode ∈ inventory ↔ mode ∈ inventory)
    (hradius : ∀ (symmetry : Symmetry) (mode : Mode),
      radius (symmetry • mode) = radius mode)
    (symmetry : Symmetry) (mode : Mode) :
    symmetry • mode ∈ metricShell inventory radius cutoff ↔
      mode ∈ metricShell inventory radius cutoff := by
  simp only [mem_metricShell, hinventory, hradius]

/-- `BG-FOURIER-THM-098`: every shell contains the full supplied symmetry orbit of each member. -/
theorem smul_mem_metricShell [SMul Symmetry Mode]
    {inventory : Finset Mode} {radius : Mode → Radius} {cutoff : Radius}
    (hinventory : ∀ (symmetry : Symmetry) (mode : Mode),
      symmetry • mode ∈ inventory ↔ mode ∈ inventory)
    (hradius : ∀ (symmetry : Symmetry) (mode : Mode),
      radius (symmetry • mode) = radius mode)
    {mode : Mode} (hmode : mode ∈ metricShell inventory radius cutoff)
    (symmetry : Symmetry) :
    symmetry • mode ∈ metricShell inventory radius cutoff := by
  exact (smul_mem_metricShell_iff hinventory hradius symmetry mode).2 hmode

/-- `BG-FOURIER-THM-099`: a shell changes exactly when an inventoried mode lies in the cutoff gap. -/
theorem metricShell_ne_iff_exists_between
    {inventory : Finset Mode} {radius : Mode → Radius} {first second : Radius}
    (hcutoff : first ≤ second) :
    metricShell inventory radius first ≠ metricShell inventory radius second ↔
      ∃ mode ∈ inventory, first < radius mode ∧ radius mode ≤ second := by
  constructor
  · intro hne
    by_contra hnone
    apply hne
    apply Finset.Subset.antisymm
    · exact metricShell_mono inventory radius hcutoff
    · intro mode hmode
      rw [mem_metricShell] at hmode ⊢
      refine ⟨hmode.1, ?_⟩
      by_contra hnot
      exact hnone ⟨mode, hmode.1, lt_of_not_ge hnot, hmode.2⟩
  · rintro ⟨mode, hmode, hfirst, hsecond⟩ heq
    have hmemSecond : mode ∈ metricShell inventory radius second :=
      mem_metricShell.mpr ⟨hmode, hsecond⟩
    have hmemFirst : mode ∈ metricShell inventory radius first := by
      rw [heq]
      exact hmemSecond
    exact (not_le_of_gt hfirst) (mem_metricShell.mp hmemFirst).2

/-- `BG-FOURIER-THM-100`: every shell change is exactly witnessed by an attained radius. -/
theorem metricShell_ne_iff_exists_attained_between
    {inventory : Finset Mode} {radius : Mode → Radius} {first second : Radius}
    (hcutoff : first ≤ second) :
    metricShell inventory radius first ≠ metricShell inventory radius second ↔
      ∃ value ∈ attainedMetricRadii inventory radius,
        first < value ∧ value ≤ second := by
  rw [metricShell_ne_iff_exists_between hcutoff]
  constructor
  · rintro ⟨mode, hmode, hfirst, hsecond⟩
    exact ⟨radius mode, Finset.mem_image.mpr ⟨mode, hmode, rfl⟩, hfirst, hsecond⟩
  · rintro ⟨value, hvalue, hfirst, hsecond⟩
    obtain ⟨mode, hmode, rfl⟩ := Finset.mem_image.mp hvalue
    exact ⟨mode, hmode, hfirst, hsecond⟩

/-- `BG-FOURIER-THM-101`: every strictly higher attained radius strictly enlarges the shell. -/
theorem metricShell_ssubset_of_lt_attained
    (inventory : Finset Mode) (radius : Mode → Radius)
    {first second : Radius} (hlt : first < second)
    (hsecond : second ∈ attainedMetricRadii inventory radius) :
    metricShell inventory radius first ⊂ metricShell inventory radius second := by
  rw [Finset.ssubset_iff_subset_ne]
  refine ⟨metricShell_mono inventory radius hlt.le, ?_⟩
  rw [metricShell_ne_iff_exists_attained_between hlt.le]
  exact ⟨second, hsecond, hlt, le_rfl⟩

/-- `BG-FOURIER-THM-102`: every strictly higher attained radius strictly increases block count. -/
theorem metricShell_card_lt_of_lt_attained
    (inventory : Finset Mode) (radius : Mode → Radius)
    {first second : Radius} (hlt : first < second)
    (hsecond : second ∈ attainedMetricRadii inventory radius) :
    (metricShell inventory radius first).card <
      (metricShell inventory radius second).card := by
  exact Finset.card_lt_card
    (metricShell_ssubset_of_lt_attained inventory radius hlt hsecond)

/-- `BG-FOURIER-THM-103`: attained radii are determined by their exact metric shells. -/
theorem attainedMetricRadius_eq_of_shell_eq
    (inventory : Finset Mode) (radius : Mode → Radius)
    {first second : Radius}
    (hfirst : first ∈ attainedMetricRadii inventory radius)
    (hsecond : second ∈ attainedMetricRadii inventory radius)
    (hshell : metricShell inventory radius first = metricShell inventory radius second) :
    first = second := by
  rcases lt_trichotomy first second with hlt | heq | hgt
  · exact False.elim
      ((metricShell_ssubset_of_lt_attained inventory radius hlt hsecond).ne hshell)
  · exact heq
  · exact False.elim
      ((metricShell_ssubset_of_lt_attained inventory radius hgt hfirst).ne hshell.symm)

/-- `BG-FOURIER-THM-104`: two ordered cutoffs have equal shells exactly when no radius occurs between. -/
theorem metricShell_eq_iff_no_attained_between
    {inventory : Finset Mode} {radius : Mode → Radius} {first second : Radius}
    (hcutoff : first ≤ second) :
    metricShell inventory radius first = metricShell inventory radius second ↔
      ¬ ∃ value ∈ attainedMetricRadii inventory radius,
        first < value ∧ value ≤ second := by
  rw [← not_iff_not]
  simp only [not_not]
  exact metricShell_ne_iff_exists_attained_between hcutoff

/-- `BG-FOURIER-THM-105`: a shell change below a cap appears in the capped attained-radius inventory. -/
theorem exists_attainedMetricRadiusThrough_of_shell_ne
    {inventory : Finset Mode} {radius : Mode → Radius} {first second cap : Radius}
    (hcutoff : first ≤ second)
    (hsecondCap : second ≤ cap)
    (hne : metricShell inventory radius first ≠ metricShell inventory radius second) :
    ∃ value ∈ attainedMetricRadiiThrough inventory radius cap,
      first < value ∧ value ≤ second := by
  obtain ⟨value, hvalue, hfirst, hsecond⟩ :=
    (metricShell_ne_iff_exists_attained_between hcutoff).mp hne
  refine ⟨value, ?_, hfirst, hsecond⟩
  simp [attainedMetricRadiiThrough, hvalue, hsecond.trans hsecondCap]

/-- `BG-FOURIER-DEF-048`: the reduced-coordinate square-lattice squared-radius index. -/
def squareShellIndex (mode : ℤ × ℤ) : ℤ :=
  mode.1 ^ 2 + mode.2 ^ 2

/-- `BG-FOURIER-DEF-049`: the reduced-coordinate triangular-lattice squared-radius index. -/
def triangularShellIndex (mode : ℤ × ℤ) : ℤ :=
  mode.1 ^ 2 + mode.1 * mode.2 + mode.2 ^ 2

/-- `BG-FOURIER-DEF-050`: the reduced-coordinate simple-cubic squared-radius index. -/
def simpleCubicShellIndex (mode : ℤ × (ℤ × ℤ)) : ℤ :=
  mode.1 ^ 2 + mode.2.1 ^ 2 + mode.2.2 ^ 2

/-- `BG-FOURIER-DEF-051`: the reduced-coordinate normalized FCC squared-radius index. -/
def fccShellIndex (mode : ℤ × (ℤ × ℤ)) : ℤ :=
  mode.1 ^ 2 + mode.2.1 ^ 2 + mode.2.2 ^ 2 +
    mode.1 * mode.2.1 + mode.1 * mode.2.2 + mode.2.1 * mode.2.2

/-- `BG-FOURIER-THM-106`: the square-lattice shell index is nonnegative. -/
theorem squareShellIndex_nonneg (mode : ℤ × ℤ) :
    0 ≤ squareShellIndex mode := by
  rcases mode with ⟨x, y⟩
  simp only [squareShellIndex]
  positivity

/-- `BG-FOURIER-THM-107`: the triangular-lattice shell index is nonnegative. -/
theorem triangularShellIndex_nonneg (mode : ℤ × ℤ) :
    0 ≤ triangularShellIndex mode := by
  rcases mode with ⟨x, y⟩
  simp only [triangularShellIndex]
  have hfirst : 0 ≤ (2 * x + y) ^ 2 := sq_nonneg (2 * x + y)
  have hsecond : 0 ≤ y ^ 2 := sq_nonneg y
  nlinarith

/-- `BG-FOURIER-THM-108`: the simple-cubic shell index is nonnegative. -/
theorem simpleCubicShellIndex_nonneg (mode : ℤ × (ℤ × ℤ)) :
    0 ≤ simpleCubicShellIndex mode := by
  rcases mode with ⟨x, y, z⟩
  simp only [simpleCubicShellIndex]
  positivity

/-- `BG-FOURIER-THM-109`: the normalized FCC shell index is nonnegative. -/
theorem fccShellIndex_nonneg (mode : ℤ × (ℤ × ℤ)) :
    0 ≤ fccShellIndex mode := by
  rcases mode with ⟨x, y, z⟩
  simp only [fccShellIndex]
  have hsum : 0 ≤ (x + y + z) ^ 2 := sq_nonneg (x + y + z)
  have hx : 0 ≤ x ^ 2 := sq_nonneg x
  have hy : 0 ≤ y ^ 2 := sq_nonneg y
  have hz : 0 ≤ z ^ 2 := sq_nonneg z
  nlinarith

/-- `BG-FOURIER-THM-110`: the square shell index is inversion invariant. -/
@[simp]
theorem squareShellIndex_neg (mode : ℤ × ℤ) :
    squareShellIndex (-mode) = squareShellIndex mode := by
  rcases mode with ⟨x, y⟩
  simp [squareShellIndex]

/-- `BG-FOURIER-THM-111`: the triangular shell index is inversion invariant. -/
@[simp]
theorem triangularShellIndex_neg (mode : ℤ × ℤ) :
    triangularShellIndex (-mode) = triangularShellIndex mode := by
  rcases mode with ⟨x, y⟩
  simp [triangularShellIndex]

/-- `BG-FOURIER-THM-112`: the simple-cubic shell index is inversion invariant. -/
@[simp]
theorem simpleCubicShellIndex_neg (mode : ℤ × (ℤ × ℤ)) :
    simpleCubicShellIndex (-mode) = simpleCubicShellIndex mode := by
  rcases mode with ⟨x, y, z⟩
  simp [simpleCubicShellIndex]

/-- `BG-FOURIER-THM-113`: the normalized FCC shell index is inversion invariant. -/
@[simp]
theorem fccShellIndex_neg (mode : ℤ × (ℤ × ℤ)) :
    fccShellIndex (-mode) = fccShellIndex mode := by
  rcases mode with ⟨x, y, z⟩
  simp [fccShellIndex]

/-- `BG-FOURIER-THM-114`: the square shell index is invariant under coordinate exchange. -/
theorem squareShellIndex_swap (x y : ℤ) :
    squareShellIndex (y, x) = squareShellIndex (x, y) := by
  simp [squareShellIndex, add_comm]

/-- `BG-FOURIER-THM-115`: the triangular shell index is invariant under coordinate exchange. -/
theorem triangularShellIndex_swap (x y : ℤ) :
    triangularShellIndex (y, x) = triangularShellIndex (x, y) := by
  simp [triangularShellIndex]
  ring

/-- `BG-FOURIER-THM-116`: the triangular shell index is invariant under a sixty-degree generator. -/
theorem triangularShellIndex_rotate (x y : ℤ) :
    triangularShellIndex (-y, x + y) = triangularShellIndex (x, y) := by
  simp [triangularShellIndex]
  ring

/-- `BG-FOURIER-THM-117`: the simple-cubic shell index is invariant under coordinate exchange. -/
theorem simpleCubicShellIndex_swap12 (x y z : ℤ) :
    simpleCubicShellIndex (y, x, z) = simpleCubicShellIndex (x, y, z) := by
  simp [simpleCubicShellIndex]
  ring

/-- `BG-FOURIER-THM-118`: the normalized FCC shell index is invariant under coordinate exchange. -/
theorem fccShellIndex_swap12 (x y z : ℤ) :
    fccShellIndex (y, x, z) = fccShellIndex (x, y, z) := by
  simp [fccShellIndex]
  ring

end ProjectKoios.BandGauge.Fourier

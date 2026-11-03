/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-02
-/
module

public import ProjectKoios.BandGauge.Fourier.Support.MetricShell
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Algebra.Group.Pointwise.Set.Basic

/-!
# Subadditive radii for exact integer lattice shells

This module turns the existing square, triangular, simple-cubic, and normalized FCC integer
squared-shell indices into genuine nonnegative radii.  Each radius is the Euclidean norm of an
explicit additive real embedding.  Consequently it is invariant under inversion and satisfies the
triangle inequality.  Its real square is exactly the corresponding integer shell index. Complete
set-valued shells for these radii therefore satisfy the `R_A + 2 R_U` support inclusion.

These results supply the missing exact bridge from the squared-index formulas to the radius
hypotheses used by support-growth arguments.  They concern the infinite integer lattices.  They do
not by themselves identify a finite character group with centered integer representatives: such a
quotient binding must separately account for wraparound and prove that the selected quotient radius
is compatible with addition.  No runtime mesh, physical length, Fourier array, or hopping-range
claim is made.
-/

@[expose] public section

open scoped Matrix Pointwise

namespace ProjectKoios.BandGauge.Fourier.Support

/-- `BG-FOURIER-SUPPORT-DEF-001`: additive Euclidean realization of square-lattice coordinates. -/
noncomputable def squareShellVector (mode : ℤ × ℤ) :
    EuclideanSpace ℝ (Fin 2) :=
  !₂[(mode.1 : ℝ), (mode.2 : ℝ)]

/-- `BG-FOURIER-SUPPORT-DEF-002`: additive Euclidean realization of triangular-lattice coordinates. -/
noncomputable def triangularShellVector (mode : ℤ × ℤ) :
    EuclideanSpace ℝ (Fin 2) :=
  !₂[(mode.1 : ℝ) + (mode.2 : ℝ) / 2,
    Real.sqrt 3 / 2 * (mode.2 : ℝ)]

/-- `BG-FOURIER-SUPPORT-DEF-003`: additive Euclidean realization of simple-cubic coordinates. -/
noncomputable def simpleCubicShellVector (mode : ℤ × (ℤ × ℤ)) :
    EuclideanSpace ℝ (Fin 3) :=
  WithLp.toLp 2 ![(mode.1 : ℝ), (mode.2.1 : ℝ), (mode.2.2 : ℝ)]

/-- `BG-FOURIER-SUPPORT-DEF-004`: additive Euclidean realization of normalized FCC coordinates. -/
noncomputable def fccShellVector (mode : ℤ × (ℤ × ℤ)) :
    EuclideanSpace ℝ (Fin 4) :=
  WithLp.toLp 2
    ![Real.sqrt 2 / 2 * ((mode.1 : ℝ) + (mode.2.1 : ℝ) + (mode.2.2 : ℝ)),
      Real.sqrt 2 / 2 * (mode.1 : ℝ),
      Real.sqrt 2 / 2 * (mode.2.1 : ℝ),
      Real.sqrt 2 / 2 * (mode.2.2 : ℝ)]

/-- `BG-FOURIER-SUPPORT-DEF-005`: Euclidean radius associated with the square-lattice shell index. -/
noncomputable def squareShellRadius (mode : ℤ × ℤ) : NNReal :=
  ‖squareShellVector mode‖₊

/-- `BG-FOURIER-SUPPORT-DEF-006`: Euclidean radius associated with the triangular-lattice shell
index. -/
noncomputable def triangularShellRadius (mode : ℤ × ℤ) : NNReal :=
  ‖triangularShellVector mode‖₊

/-- `BG-FOURIER-SUPPORT-DEF-007`: Euclidean radius associated with the simple-cubic shell index. -/
noncomputable def simpleCubicShellRadius (mode : ℤ × (ℤ × ℤ)) : NNReal :=
  ‖simpleCubicShellVector mode‖₊

/-- `BG-FOURIER-SUPPORT-DEF-008`: Euclidean radius associated with the normalized FCC shell index. -/
noncomputable def fccShellRadius (mode : ℤ × (ℤ × ℤ)) : NNReal :=
  ‖fccShellVector mode‖₊

private lemma squareShellVector_add (left right : ℤ × ℤ) :
    squareShellVector (left + right) = squareShellVector left + squareShellVector right := by
  ext i
  fin_cases i <;> simp [squareShellVector]

private lemma triangularShellVector_add (left right : ℤ × ℤ) :
    triangularShellVector (left + right) =
      triangularShellVector left + triangularShellVector right := by
  ext i
  fin_cases i <;> simp [triangularShellVector] <;> ring

private lemma simpleCubicShellVector_add (left right : ℤ × (ℤ × ℤ)) :
    simpleCubicShellVector (left + right) =
      simpleCubicShellVector left + simpleCubicShellVector right := by
  ext i
  fin_cases i <;> simp [simpleCubicShellVector]

private lemma fccShellVector_add (left right : ℤ × (ℤ × ℤ)) :
    fccShellVector (left + right) = fccShellVector left + fccShellVector right := by
  ext i
  fin_cases i <;> simp [fccShellVector] <;> ring

private lemma squareShellVector_neg (mode : ℤ × ℤ) :
    squareShellVector (-mode) = -squareShellVector mode := by
  ext i
  fin_cases i <;> simp [squareShellVector]

private lemma triangularShellVector_neg (mode : ℤ × ℤ) :
    triangularShellVector (-mode) = -triangularShellVector mode := by
  ext i
  fin_cases i <;> simp [triangularShellVector]
  ring

private lemma simpleCubicShellVector_neg (mode : ℤ × (ℤ × ℤ)) :
    simpleCubicShellVector (-mode) = -simpleCubicShellVector mode := by
  ext i
  fin_cases i <;> simp [simpleCubicShellVector]

private lemma fccShellVector_neg (mode : ℤ × (ℤ × ℤ)) :
    fccShellVector (-mode) = -fccShellVector mode := by
  ext i
  fin_cases i <;> simp [fccShellVector]
  ring

/-- `BG-FOURIER-SUPPORT-THM-001`: the square of the square-lattice radius is exactly the cast of the
existing square shell index. -/
theorem squareShellRadius_sq (mode : ℤ × ℤ) :
    (squareShellRadius mode : ℝ) ^ 2 = (squareShellIndex mode : ℝ) := by
  change ‖squareShellVector mode‖ ^ 2 = _
  rw [EuclideanSpace.real_norm_sq_eq]
  simp [squareShellVector, squareShellIndex, Fin.sum_univ_two]

/-- `BG-FOURIER-SUPPORT-THM-002`: the square of the triangular-lattice radius is exactly the cast of
the existing triangular shell index. -/
theorem triangularShellRadius_sq (mode : ℤ × ℤ) :
    (triangularShellRadius mode : ℝ) ^ 2 = (triangularShellIndex mode : ℝ) := by
  change ‖triangularShellVector mode‖ ^ 2 = _
  rw [EuclideanSpace.real_norm_sq_eq]
  simp [triangularShellVector, triangularShellIndex, Fin.sum_univ_two]
  ring_nf
  rw [show Real.sqrt 3 ^ 2 = 3 by norm_num]
  ring

/-- `BG-FOURIER-SUPPORT-THM-003`: the square of the simple-cubic radius is exactly the cast of the
existing simple-cubic shell index. -/
theorem simpleCubicShellRadius_sq (mode : ℤ × (ℤ × ℤ)) :
    (simpleCubicShellRadius mode : ℝ) ^ 2 = (simpleCubicShellIndex mode : ℝ) := by
  change ‖simpleCubicShellVector mode‖ ^ 2 = _
  rw [EuclideanSpace.real_norm_sq_eq]
  simp [simpleCubicShellVector, simpleCubicShellIndex, Fin.sum_univ_three]

/-- `BG-FOURIER-SUPPORT-THM-004`: the square of the normalized FCC radius is exactly the cast of the
existing FCC shell index. -/
theorem fccShellRadius_sq (mode : ℤ × (ℤ × ℤ)) :
    (fccShellRadius mode : ℝ) ^ 2 = (fccShellIndex mode : ℝ) := by
  change ‖fccShellVector mode‖ ^ 2 = _
  rw [EuclideanSpace.real_norm_sq_eq]
  simp [fccShellVector, fccShellIndex, Fin.sum_univ_four]
  ring_nf
  rw [show Real.sqrt 2 ^ 2 = 2 by norm_num]
  ring

/-- `BG-FOURIER-SUPPORT-LEM-003`: the square-lattice radius is inversion invariant. -/
@[simp]
lemma squareShellRadius_neg (mode : ℤ × ℤ) :
    squareShellRadius (-mode) = squareShellRadius mode := by
  simp only [squareShellRadius, squareShellVector_neg, nnnorm_neg]

/-- `BG-FOURIER-SUPPORT-LEM-004`: the triangular-lattice radius is inversion invariant. -/
@[simp]
lemma triangularShellRadius_neg (mode : ℤ × ℤ) :
    triangularShellRadius (-mode) = triangularShellRadius mode := by
  simp only [triangularShellRadius, triangularShellVector_neg, nnnorm_neg]

/-- `BG-FOURIER-SUPPORT-LEM-005`: the simple-cubic radius is inversion invariant. -/
@[simp]
lemma simpleCubicShellRadius_neg (mode : ℤ × (ℤ × ℤ)) :
    simpleCubicShellRadius (-mode) = simpleCubicShellRadius mode := by
  simp only [simpleCubicShellRadius, simpleCubicShellVector_neg, nnnorm_neg]

/-- `BG-FOURIER-SUPPORT-LEM-006`: the normalized FCC radius is inversion invariant. -/
@[simp]
lemma fccShellRadius_neg (mode : ℤ × (ℤ × ℤ)) :
    fccShellRadius (-mode) = fccShellRadius mode := by
  simp only [fccShellRadius, fccShellVector_neg, nnnorm_neg]

/-- `BG-FOURIER-SUPPORT-THM-005`: the square-lattice radius satisfies the triangle inequality. -/
theorem squareShellRadius_add_le (left right : ℤ × ℤ) :
    squareShellRadius (left + right) ≤ squareShellRadius left + squareShellRadius right := by
  rw [squareShellRadius, squareShellVector_add]
  exact nnnorm_add_le _ _

/-- `BG-FOURIER-SUPPORT-THM-006`: the triangular-lattice radius satisfies the triangle inequality. -/
theorem triangularShellRadius_add_le (left right : ℤ × ℤ) :
    triangularShellRadius (left + right) ≤
      triangularShellRadius left + triangularShellRadius right := by
  rw [triangularShellRadius, triangularShellVector_add]
  exact nnnorm_add_le _ _

/-- `BG-FOURIER-SUPPORT-THM-007`: the simple-cubic radius satisfies the triangle inequality. -/
theorem simpleCubicShellRadius_add_le (left right : ℤ × (ℤ × ℤ)) :
    simpleCubicShellRadius (left + right) ≤
      simpleCubicShellRadius left + simpleCubicShellRadius right := by
  rw [simpleCubicShellRadius, simpleCubicShellVector_add]
  exact nnnorm_add_le _ _

/-- `BG-FOURIER-SUPPORT-THM-008`: the normalized FCC radius satisfies the triangle inequality. -/
theorem fccShellRadius_add_le (left right : ℤ × (ℤ × ℤ)) :
    fccShellRadius (left + right) ≤ fccShellRadius left + fccShellRadius right := by
  rw [fccShellRadius, fccShellVector_add]
  exact nnnorm_add_le _ _

/-- `BG-FOURIER-SUPPORT-DEF-009`: complete set-valued shell for a supplied nonnegative radius. -/
def radiusShellSet {Mode : Type*} (radius : Mode → NNReal) (cutoff : NNReal) : Set Mode :=
  {mode | radius mode ≤ cutoff}

/-- `BG-FOURIER-SUPPORT-LEM-007`: the elementwise radius estimate behind the
`R_A + 2 R_U` gauge-support bound does not require a finite carrier. -/
lemma radius_neg_add_add_le
    {Mode : Type*} [AddCommGroup Mode]
    (radius : Mode → NNReal)
    (hneg : ∀ mode, radius (-mode) = radius mode)
    (hadd : ∀ left right, radius (left + right) ≤ radius left + radius right)
    {leftGauge field rightGauge : Mode} {gaugeRadius fieldRadius : NNReal}
    (hleft : radius leftGauge ≤ gaugeRadius)
    (hfield : radius field ≤ fieldRadius)
    (hright : radius rightGauge ≤ gaugeRadius) :
    radius ((-leftGauge + field) + rightGauge) ≤
      fieldRadius + 2 * gaugeRadius := by
  calc
    radius ((-leftGauge + field) + rightGauge) ≤
        radius (-leftGauge + field) + radius rightGauge :=
      hadd (-leftGauge + field) rightGauge
    _ ≤ (radius (-leftGauge) + radius field) + radius rightGauge :=
      add_le_add (hadd (-leftGauge) field) le_rfl
    _ = (radius leftGauge + radius field) + radius rightGauge := by rw [hneg]
    _ ≤ (gaugeRadius + fieldRadius) + gaugeRadius :=
      add_le_add (add_le_add hleft hfield) hright
    _ = fieldRadius + 2 * gaugeRadius := by
      simp only [two_mul]
      ac_rfl

/-- `BG-FOURIER-SUPPORT-THM-009`: square-lattice modes obey the exact elementwise
`R_A + 2 R_U` gauge-support radius bound. -/
theorem squareShellRadius_neg_add_add_le
    {leftGauge field rightGauge : ℤ × ℤ} {gaugeRadius fieldRadius : NNReal}
    (hleft : squareShellRadius leftGauge ≤ gaugeRadius)
    (hfield : squareShellRadius field ≤ fieldRadius)
    (hright : squareShellRadius rightGauge ≤ gaugeRadius) :
    squareShellRadius ((-leftGauge + field) + rightGauge) ≤
      fieldRadius + 2 * gaugeRadius :=
  radius_neg_add_add_le squareShellRadius squareShellRadius_neg
    squareShellRadius_add_le hleft hfield hright

/-- `BG-FOURIER-SUPPORT-THM-010`: triangular-lattice modes obey the exact elementwise
`R_A + 2 R_U` gauge-support radius bound. -/
theorem triangularShellRadius_neg_add_add_le
    {leftGauge field rightGauge : ℤ × ℤ} {gaugeRadius fieldRadius : NNReal}
    (hleft : triangularShellRadius leftGauge ≤ gaugeRadius)
    (hfield : triangularShellRadius field ≤ fieldRadius)
    (hright : triangularShellRadius rightGauge ≤ gaugeRadius) :
    triangularShellRadius ((-leftGauge + field) + rightGauge) ≤
      fieldRadius + 2 * gaugeRadius :=
  radius_neg_add_add_le triangularShellRadius triangularShellRadius_neg
    triangularShellRadius_add_le hleft hfield hright

/-- `BG-FOURIER-SUPPORT-THM-011`: simple-cubic modes obey the exact elementwise
`R_A + 2 R_U` gauge-support radius bound. -/
theorem simpleCubicShellRadius_neg_add_add_le
    {leftGauge field rightGauge : ℤ × (ℤ × ℤ)} {gaugeRadius fieldRadius : NNReal}
    (hleft : simpleCubicShellRadius leftGauge ≤ gaugeRadius)
    (hfield : simpleCubicShellRadius field ≤ fieldRadius)
    (hright : simpleCubicShellRadius rightGauge ≤ gaugeRadius) :
    simpleCubicShellRadius ((-leftGauge + field) + rightGauge) ≤
      fieldRadius + 2 * gaugeRadius :=
  radius_neg_add_add_le simpleCubicShellRadius simpleCubicShellRadius_neg
    simpleCubicShellRadius_add_le hleft hfield hright

/-- `BG-FOURIER-SUPPORT-THM-012`: normalized FCC modes obey the exact elementwise
`R_A + 2 R_U` gauge-support radius bound. -/
theorem fccShellRadius_neg_add_add_le
    {leftGauge field rightGauge : ℤ × (ℤ × ℤ)} {gaugeRadius fieldRadius : NNReal}
    (hleft : fccShellRadius leftGauge ≤ gaugeRadius)
    (hfield : fccShellRadius field ≤ fieldRadius)
    (hright : fccShellRadius rightGauge ≤ gaugeRadius) :
    fccShellRadius ((-leftGauge + field) + rightGauge) ≤
      fieldRadius + 2 * gaugeRadius :=
  radius_neg_add_add_le fccShellRadius fccShellRadius_neg
    fccShellRadius_add_le hleft hfield hright

/-- `BG-FOURIER-SUPPORT-LEM-008`: complete radius shells obey the exact support inclusion behind the
`R_A + 2 R_U` gauge-support bound on any additive commutative group. -/
lemma radiusShellSet_neg_add_add_subset
    {Mode : Type*} [AddCommGroup Mode]
    (radius : Mode → NNReal)
    (hneg : ∀ mode, radius (-mode) = radius mode)
    (hadd : ∀ left right, radius (left + right) ≤ radius left + radius right)
    (gaugeRadius fieldRadius : NNReal) :
    (-radiusShellSet radius gaugeRadius + radiusShellSet radius fieldRadius) +
        radiusShellSet radius gaugeRadius ⊆
      radiusShellSet radius (fieldRadius + 2 * gaugeRadius) := by
  intro mode hmode
  rw [Set.mem_add] at hmode
  rcases hmode with ⟨leftField, hleftField, rightGauge, hright, rfl⟩
  rw [Set.mem_add] at hleftField
  rcases hleftField with ⟨negativeLeftGauge, hnegative, field, hfield, rfl⟩
  rw [Set.mem_neg] at hnegative
  change radius (-negativeLeftGauge) ≤ gaugeRadius at hnegative
  change radius field ≤ fieldRadius at hfield
  change radius rightGauge ≤ gaugeRadius at hright
  change radius ((negativeLeftGauge + field) + rightGauge) ≤ _
  simpa only [neg_neg] using
    (radius_neg_add_add_le radius hneg hadd
      (leftGauge := -negativeLeftGauge) (field := field) (rightGauge := rightGauge)
      hnegative hfield hright)

/-- `BG-FOURIER-SUPPORT-THM-013`: square-lattice complete shells obey the support inclusion
`(-shell R_U + shell R_A) + shell R_U ⊆ shell (R_A + 2 R_U)`. -/
theorem squareShellRadius_shell_neg_add_add_subset (gaugeRadius fieldRadius : NNReal) :
    (-radiusShellSet squareShellRadius gaugeRadius +
          radiusShellSet squareShellRadius fieldRadius) +
        radiusShellSet squareShellRadius gaugeRadius ⊆
      radiusShellSet squareShellRadius (fieldRadius + 2 * gaugeRadius) :=
  radiusShellSet_neg_add_add_subset squareShellRadius squareShellRadius_neg
    squareShellRadius_add_le gaugeRadius fieldRadius

/-- `BG-FOURIER-SUPPORT-THM-014`: triangular-lattice complete shells obey the support inclusion
`(-shell R_U + shell R_A) + shell R_U ⊆ shell (R_A + 2 R_U)`. -/
theorem triangularShellRadius_shell_neg_add_add_subset (gaugeRadius fieldRadius : NNReal) :
    (-radiusShellSet triangularShellRadius gaugeRadius +
          radiusShellSet triangularShellRadius fieldRadius) +
        radiusShellSet triangularShellRadius gaugeRadius ⊆
      radiusShellSet triangularShellRadius (fieldRadius + 2 * gaugeRadius) :=
  radiusShellSet_neg_add_add_subset triangularShellRadius triangularShellRadius_neg
    triangularShellRadius_add_le gaugeRadius fieldRadius

/-- `BG-FOURIER-SUPPORT-THM-015`: simple-cubic complete shells obey the support inclusion
`(-shell R_U + shell R_A) + shell R_U ⊆ shell (R_A + 2 R_U)`. -/
theorem simpleCubicShellRadius_shell_neg_add_add_subset (gaugeRadius fieldRadius : NNReal) :
    (-radiusShellSet simpleCubicShellRadius gaugeRadius +
          radiusShellSet simpleCubicShellRadius fieldRadius) +
        radiusShellSet simpleCubicShellRadius gaugeRadius ⊆
      radiusShellSet simpleCubicShellRadius (fieldRadius + 2 * gaugeRadius) :=
  radiusShellSet_neg_add_add_subset simpleCubicShellRadius simpleCubicShellRadius_neg
    simpleCubicShellRadius_add_le gaugeRadius fieldRadius

/-- `BG-FOURIER-SUPPORT-THM-016`: normalized FCC complete shells obey the support inclusion
`(-shell R_U + shell R_A) + shell R_U ⊆ shell (R_A + 2 R_U)`. -/
theorem fccShellRadius_shell_neg_add_add_subset (gaugeRadius fieldRadius : NNReal) :
    (-radiusShellSet fccShellRadius gaugeRadius + radiusShellSet fccShellRadius fieldRadius) +
        radiusShellSet fccShellRadius gaugeRadius ⊆
      radiusShellSet fccShellRadius (fieldRadius + 2 * gaugeRadius) :=
  radiusShellSet_neg_add_add_subset fccShellRadius fccShellRadius_neg
    fccShellRadius_add_le gaugeRadius fieldRadius

end ProjectKoios.BandGauge.Fourier.Support

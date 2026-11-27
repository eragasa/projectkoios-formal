/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinSO3Covariance

/-!
# Collinearity after a global spin-frame rotation

Global finite spin collinearity means that one spatially independent `SU(2)` frame makes all
cross-spin orbital blocks vanish.

## i. Overview

The fixed-basis predicate `IsSpinCollinearZ` detects block diagonality in the standard spin basis.
This module separates that basis-relative statement from collinearity after choosing one global
spin frame.  The same `SU(2)` matrix acts on every orbital index through the active action
`spinFrameRotate U M`.

The existential predicate is insensitive to any further global active rotation.  It is equivalent
to vanishing transverse components of the induced `SO(3)`-rotated Pauli coefficient vector, to a
rotated scalar-plus-Pauli-`z` representation, and to commuting with the fixed lifted Pauli-`z`
observable after one global rotation.

This is source-neutral finite matrix algebra.  It does not choose a preferred physical axis, define
a position-dependent or almost-everywhere spin frame, bind a continuum spin-density matrix, or
assert compatibility with spin--orbit coupling.

## ii. Key results

- `IsSpinCollinearInFrame`: fixed-`z` collinearity after one specified active global rotation.
- `IsGloballySpinCollinear`: existence of one global frame making the matrix fixed-`z` collinear.
- `isGloballySpinCollinear_spinFrameRotate`: invariance under further global spin rotation.
- `isGloballySpinCollinear_iff_exists_rotatedPauliCoefficients`: induced-`SO(3)` characterization.
- `isGloballySpinCollinear_iff_exists_rotated_collinear_form`: rotated canonical form.

## iii. Table of contents

- A. Global-frame predicates
- B. Pauli-coefficient and commutator characterizations
- C. Rotation invariance and canonical forms
- D. Proof schematic

## iv. References

- Pinned PhyslibAlpha `StandardModel.su2AdjointMatrix` for the induced `SO(3)` action.
- The active `SU(2)` convention is fixed in `SpinFrameRotation.lean`; no new literature claim is
  introduced here.

## D. Proof schematic

```mermaid
flowchart TD
    fixed["QM-SPIN-DECOMPOSITION-DEF-004<br/>fixed-z collinearity"]
    frame["QM-SPIN-GLOBAL-COLLINEAR-DEF-001<br/>collinear in frame U"]
    global["QM-SPIN-GLOBAL-COLLINEAR-DEF-002<br/>one global frame exists"]
    covariance["QM-SPIN-SO3-LEM-012<br/>Pauli coefficients rotate by R(U)"]
    transverse["transverse coefficients vanish<br/>in a chosen collinear frame"]
    representation["existence of a rotated<br/>scalar plus Pauli-z form"]
    commute["existence of a rotation giving<br/>commutation with lifted sigma-z"]
    invariant["global-rotation invariance"]

    fixed -->|identity frame| frame
    frame --> global
    covariance --> transverse
    frame --> transverse
    fixed --> representation
    fixed --> commute
    global --> representation
    global --> commute
    frame --> invariant
    global --> invariant
```
-/

@[expose] public section

open scoped ComplexConjugate Kronecker Matrix

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-! ## A. Global-frame predicates -/

/--
Fixed-`z` collinearity after applying one specified active global spin rotation.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-DEF-001`.

The frame acts identically on every orbital index.  This is an active rotation predicate, not a
passive coordinate-change definition.
-/
def IsSpinCollinearInFrame (U : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Prop :=
  IsSpinCollinearZ (spinFrameRotate U M)

/--
Existence of one global `SU(2)` frame in which the spinful matrix is fixed-`z` collinear.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-DEF-002`.

The witness is one frame for the entire orbital matrix; it may not vary with an orbital pair or a
spatial point.
-/
def IsGloballySpinCollinear (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) : Prop :=
  ∃ U : SpinFrame, IsSpinCollinearInFrame U M

/--
The identity global frame recovers fixed-basis collinearity.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-001`.
-/
@[simp] lemma isSpinCollinearInFrame_one
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsSpinCollinearInFrame (1 : SpinFrame) M ↔ IsSpinCollinearZ M := by
  simp [IsSpinCollinearInFrame]

/--
Every matrix collinear in the fixed standard basis is globally spin collinear.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-002`.
-/
lemma IsSpinCollinearZ.isGloballySpinCollinear
    {M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ} (hM : IsSpinCollinearZ M) :
    IsGloballySpinCollinear M := by
  exact ⟨1, isSpinCollinearInFrame_one M |>.2 hM⟩

/--
Composing the matrix rotation with the frame predicate multiplies the two active frames in order.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-003`.
-/
lemma isSpinCollinearInFrame_spinFrameRotate (U V : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsSpinCollinearInFrame U (spinFrameRotate V M) ↔
      IsSpinCollinearInFrame (U * V) M := by
  simp only [IsSpinCollinearInFrame, spinFrameRotate_mul]

/-! ## B. Pauli-coefficient and commutator characterizations -/

/--
Collinearity in a specified frame is equivalent to vanishing transverse components of the
induced-`SO(3)`-rotated Pauli coefficient vector.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-004`.

The coefficient convention is active and column-oriented:
`B'ᵢ = ∑ⱼ R(U)ᵢⱼ Bⱼ`.
-/
lemma isSpinCollinearInFrame_iff_rotatedPauliCoefficients
    (U : SpinFrame) (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsSpinCollinearInFrame U M ↔
      spinFrameRotatePauliCoefficients U (spinPauliPartVector M) 0 = 0 ∧
      spinFrameRotatePauliCoefficients U (spinPauliPartVector M) 1 = 0 := by
  rw [IsSpinCollinearInFrame, isSpinCollinearZ_iff_pauliXY_eq_zero]
  change
    spinPauliPartVector (spinFrameRotate U M) 0 = 0 ∧
      spinPauliPartVector (spinFrameRotate U M) 1 = 0 ↔ _
  rw [spinFrameRotate_spinPauliPartVector]

/--
Global spin collinearity is equivalent to the existence of one induced rotation killing both
transverse Pauli coefficients.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-005`.
-/
lemma isGloballySpinCollinear_iff_exists_rotatedPauliCoefficients
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsGloballySpinCollinear M ↔
      ∃ U : SpinFrame,
        spinFrameRotatePauliCoefficients U (spinPauliPartVector M) 0 = 0 ∧
        spinFrameRotatePauliCoefficients U (spinPauliPartVector M) 1 = 0 := by
  simp only [IsGloballySpinCollinear,
    isSpinCollinearInFrame_iff_rotatedPauliCoefficients]

/--
Global spin collinearity is equivalent to commuting with the fixed lifted Pauli-`z` observable
after one global active rotation.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-006`.
-/
lemma isGloballySpinCollinear_iff_exists_rotated_commute
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsGloballySpinCollinear M ↔
      ∃ U : SpinFrame,
        Commute (spinFrameRotate U M) (spinCollinearTerm (1 : Matrix ι ι ℂ)) := by
  simp only [IsGloballySpinCollinear, IsSpinCollinearInFrame,
    isSpinCollinearZ_iff_commute_spinCollinearTerm_one]

/-! ## C. Rotation invariance and canonical forms -/

/--
Global spin collinearity is invariant under every further active global spin rotation.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-007`.

This does not assert invariance under position-dependent rotations or under a spin--orbit
time-evolution operator.
-/
@[simp] lemma isGloballySpinCollinear_spinFrameRotate (V : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsGloballySpinCollinear (spinFrameRotate V M) ↔ IsGloballySpinCollinear M := by
  constructor
  · rintro ⟨U, hU⟩
    exact ⟨U * V, (isSpinCollinearInFrame_spinFrameRotate U V M).1 hU⟩
  · rintro ⟨U, hU⟩
    refine ⟨U * V⁻¹, ?_⟩
    rw [isSpinCollinearInFrame_spinFrameRotate]
    simpa [mul_assoc] using hU

/--
Global spin collinearity is equivalent to a fixed-axis scalar-plus-Pauli-`z` form after one global
rotation.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-008`.
-/
lemma isGloballySpinCollinear_iff_exists_collinear_form_after_rotation
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsGloballySpinCollinear M ↔
      ∃ U : SpinFrame, ∃ A Z : Matrix ι ι ℂ,
        spinFrameRotate U M = spinDegenerateLift A + spinCollinearTerm Z := by
  simp only [IsGloballySpinCollinear, IsSpinCollinearInFrame,
    isSpinCollinearZ_iff_exists_lift_add_spinCollinearTerm]

/--
Global spin collinearity is equivalent to being a global rotation of a fixed-axis collinear
scalar-plus-Pauli-`z` matrix.

Project Koios declaration ID: `QM-SPIN-GLOBAL-COLLINEAR-LEM-009`.

The witness rotation in this statement is the inverse of a frame that makes `M` fixed-`z`
collinear.
-/
lemma isGloballySpinCollinear_iff_exists_rotated_collinear_form
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    IsGloballySpinCollinear M ↔
      ∃ U : SpinFrame, ∃ A Z : Matrix ι ι ℂ,
        M = spinFrameRotate U (spinDegenerateLift A + spinCollinearTerm Z) := by
  constructor
  · rw [isGloballySpinCollinear_iff_exists_collinear_form_after_rotation]
    rintro ⟨U, A, Z, hU⟩
    refine ⟨U⁻¹, A, Z, ?_⟩
    calc
      M = spinFrameRotate U⁻¹ (spinFrameRotate U M) :=
        (spinFrameRotate_inv_rotate U M).symm
      _ = spinFrameRotate U⁻¹ (spinDegenerateLift A + spinCollinearTerm Z) := by rw [hU]
  · rintro ⟨U, A, Z, rfl⟩
    rw [isGloballySpinCollinear_spinFrameRotate]
    exact (isSpinCollinearZ_iff_exists_lift_add_spinCollinearTerm
      (spinDegenerateLift A + spinCollinearTerm Z)).2 ⟨A, Z, rfl⟩ |>
      IsSpinCollinearZ.isGloballySpinCollinear

end ProjectKoios.QuantumMechanics.FiniteDimensional

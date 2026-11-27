/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinFrameRotation
public import PhyslibAlpha.Particles.StandardModel.GaugeGroup.AdjointMatrix
public import PhyslibAlpha.Particles.StandardModel.GaugeGroup.SU2Conjugation

/-!
# Induced SO(3) covariance of global spin frames

An exact active `SU(2)` spin-frame action induces an `SO(3)` rotation of Pauli coefficients.

## i. Overview

This module binds the existing active global `SU(2)` spin-frame action to PhyslibAlpha's exact
three-dimensional adjoint matrix.  For a frame `U`, the real matrix
`spinFrameRotationMatrix U` is the trace-pairing matrix of conjugation on the ordered Pauli basis.
The module proves that this matrix is in `SO(3)`, packages the construction as a group homomorphism,
and proves the active covariance law

`U σⱼ Uᴴ = ∑ᵢ R(U)ᵢⱼ σᵢ`.

The same law is lifted to orbital-major matrices.  The spin-independent coefficient is invariant,
while the three recovered Pauli coefficient matrices transform by the induced real rotation.  The
coefficient convention is active and column-oriented:

`B'ᵢ = ∑ⱼ R(U)ᵢⱼ Bⱼ`.

This remains source-neutral finite matrix algebra.  It does not define collinearity after choosing
some global frame, introduce position-dependent frames, bind a spin-density field, or model
spin--orbit coupling.

## ii. Key results

- `spinFrameSO3Hom`: the induced group homomorphism from global `SU(2)` frames to `SO(3)`.
- `spinFrame_pauli_covariance`: covariance of each Pauli basis matrix.
- `spinFrameRotate_spinPauliDot`: covariance of an arbitrary orbital-valued Pauli contraction.
- `spinFrameRotate_spinPauliPartVector`: covariance of the recovered Pauli coefficient vector.

## iii. Table of contents

- A. Induced real rotation
- B. Pauli-basis covariance
- C. Orbital-valued coefficient covariance
- D. Proof schematic

## iv. References

The pinned PhyslibAlpha revision `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd` supplies
`StandardModel.su2AdjointMatrix`, its entry/inverse/row-orthogonality lemmas, and the `SU(2)` entry
relations in `Particles/StandardModel/GaugeGroup/AdjointMatrix.lean` and `SU2Conjugation.lean`.
The local spin interpretation uses an explicit fixed-Pauli-order crosswalk, not a new Standard
Model representation or a new group type. Mathlib supplies `Matrix.specialUnitaryGroup`,
`Matrix.specialOrthogonalGroup`, and Kronecker matrix algebra. The earlier Project Koios spin-frame
and scalar-plus-Pauli decomposition modules supply the orbital-major carrier and coefficient
reconstruction. This is a source-neutral application of those APIs, not a publication crosswalk.

## D. Proof schematic

```mermaid
flowchart TD
    su2["QM-SPIN-FRAME-DEF-001<br/>global SU2 frame"] --> rotation["QM-SPIN-SO3-DEF-001<br/>PhyslibAlpha real adjoint matrix"]
    rotation --> structure["QM-SPIN-SO3-LEM-002 to 007<br/>group laws, orthogonality and det one<br/>via upstream adjoint/SU2 identities<br/>hence membership in SO3"]
    structure --> hom["QM-SPIN-SO3-DEF-002/003<br/>bundled SO3 element<br/>and group homomorphism"]
    rotation --> pauli["QM-SPIN-SO3-LEM-008<br/>active covariance via<br/>ordered Pauli-basis crosswalk"]
    pauli --> dot["QM-SPIN-SO3-LEM-009/010<br/>orbital Kronecker lift<br/>and Pauli-dot covariance"]
    dot --> coefficients["QM-SPIN-SO3-LEM-011/012<br/>scalar invariance<br/>and vector covariance"]
    decomposition["QM-SPIN-DECOMPOSITION-THM-002<br/>QM-SPIN-FRAME-THM-003<br/>exact reconstruction and fixed scalar lifts"] --> coefficients
```
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Kronecker Matrix

open Matrix StandardModel

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

set_option maxHeartbeats 4000000

/-! ## A. Induced real rotation -/

/--
The real adjoint matrix induced by a global `SU(2)` spin frame.

Project Koios declaration ID: `QM-SPIN-SO3-DEF-001`.
-/
noncomputable def spinFrameRotationMatrix (U : SpinFrame) : Matrix (Fin 3) (Fin 3) ℝ :=
  su2AdjointMatrix U

/-- Match the local ordered Pauli coordinates to Physlib's fixed basis. -/
private lemma spinPauliVector_eq_physlibPauliMatrix (a : Fin 3) :
    spinPauliVector a = PauliMatrix.pauliMatrix (Sum.inr a) := by
  fin_cases a <;> rfl

/--
Entries of the induced rotation are the real Pauli trace pairings.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-001`.
-/
@[simp] lemma spinFrameRotationMatrix_apply (U : SpinFrame) (i j : Fin 3) :
    spinFrameRotationMatrix U i j =
      2⁻¹ * (Matrix.trace (spinPauliVector i *
        (U.1 * spinPauliVector j * star U.1))).re := by
  simpa only [spinFrameRotationMatrix, spinPauliVector_eq_physlibPauliMatrix] using
    su2AdjointMatrix_apply U i j

/--
The identity spin frame induces the identity real rotation.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-002`.
-/
@[simp] lemma spinFrameRotationMatrix_one :
    spinFrameRotationMatrix (1 : SpinFrame) = 1 := by
  ext i j
  have h := congrFun (congrFun GaugeAlgebra.adjointMatrix_one
    (Sum.inr (Sum.inl i))) (Sum.inr (Sum.inl j))
  simpa [spinFrameRotationMatrix, Matrix.one_apply] using h

/--
Induced rotations respect multiplication of active spin frames.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-003`.
-/
@[simp] lemma spinFrameRotationMatrix_mul (U V : SpinFrame) :
    spinFrameRotationMatrix (U * V) =
      spinFrameRotationMatrix U * spinFrameRotationMatrix V := by
  ext i j
  have h := congrFun (congrFun
    (GaugeAlgebra.adjointMatrix_mul ((1, U, 1) : GaugeGroupI) ((1, V, 1) : GaugeGroupI))
    (Sum.inr (Sum.inl i))) (Sum.inr (Sum.inl j))
  simpa [spinFrameRotationMatrix, Matrix.mul_apply, Fintype.sum_sum_type] using h

/--
The inverse spin frame induces the transpose real rotation.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-004`.
-/
@[simp] lemma spinFrameRotationMatrix_inv (U : SpinFrame) :
    spinFrameRotationMatrix U⁻¹ = (spinFrameRotationMatrix U)ᵀ := by
  ext i j
  exact su2AdjointMatrix_inv U i j

/--
The induced real rotation is orthogonal.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-005`.
-/
lemma spinFrameRotationMatrix_mem_orthogonalGroup (U : SpinFrame) :
    spinFrameRotationMatrix U ∈ Matrix.orthogonalGroup (Fin 3) ℝ := by
  rw [Matrix.mem_orthogonalGroup_iff]
  ext c d
  rw [Matrix.mul_apply]
  simp only [spinFrameRotationMatrix, Matrix.transpose_apply, Matrix.one_apply]
  rw [sum_su2AdjointMatrix_row_mul]

/--
The induced real orthogonal rotation has determinant one.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-006`.
-/
lemma spinFrameRotationMatrix_det (U : SpinFrame) :
    (spinFrameRotationMatrix U).det = 1 := by
  have h00 := su2_conj_apply_zero_zero U
  have h00re : (U.1 0 0).re = (U.1 1 1).re := by
    simpa only [Complex.conj_re] using congrArg Complex.re h00
  have h00im : -(U.1 0 0).im = (U.1 1 1).im := by
    simpa only [Complex.conj_im] using congrArg Complex.im h00
  have h01 := su2_conj_apply_zero_one U
  have h01re : (U.1 0 1).re = -(U.1 1 0).re := by
    simpa only [Complex.conj_re, Complex.neg_re] using congrArg Complex.re h01
  have h01im : -(U.1 0 1).im = -(U.1 1 0).im := by
    simpa only [Complex.conj_im, Complex.neg_im] using congrArg Complex.im h01
  have h10re : (U.1 1 0).re = -(U.1 0 1).re := by
    linarith
  have h10im : (U.1 1 0).im = (U.1 0 1).im := by
    linarith
  have hunit := congrFun (congrFun U.property.1.2 0) 0
  simp [Matrix.mul_apply, Matrix.star_eq_conjTranspose, Matrix.conjTranspose_apply,
    Fin.sum_univ_two, Complex.ext_iff] at hunit
  rw [← h00re, ← h00im, h10re, h10im] at hunit
  have hnorm :
      (U.1 0 0).re ^ 2 + (U.1 0 0).im ^ 2 +
        ((U.1 0 1).re ^ 2 + (U.1 0 1).im ^ 2) = 1 := by
    nlinarith [hunit.1]
  rw [spinFrameRotationMatrix, Matrix.det_fin_three]
  simp only [su2AdjointMatrix_apply]
  simp [PauliMatrix.pauliMatrix, Matrix.trace, Matrix.mul_apply, Matrix.vecMul,
    dotProduct, Fin.sum_univ_two, Matrix.star_eq_conjTranspose, Matrix.conjTranspose_apply]
  rw [← h00re, ← h00im, h10re, h10im]
  have hcub :
      ((U.1 0 0).re ^ 2 + (U.1 0 0).im ^ 2 +
        ((U.1 0 1).re ^ 2 + (U.1 0 1).im ^ 2)) ^ 3 = 1 := by
    rw [hnorm]
    norm_num
  ring_nf at hcub ⊢
  exact hcub

/--
The induced real rotation belongs to `SO(3)`.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-007`.
-/
lemma spinFrameRotationMatrix_mem_specialOrthogonalGroup (U : SpinFrame) :
    spinFrameRotationMatrix U ∈ Matrix.specialOrthogonalGroup (Fin 3) ℝ := by
  rw [Matrix.mem_specialOrthogonalGroup_iff]
  exact ⟨spinFrameRotationMatrix_mem_orthogonalGroup U, spinFrameRotationMatrix_det U⟩

/--
The induced `SO(3)` element of a global spin frame.

Project Koios declaration ID: `QM-SPIN-SO3-DEF-002`.
-/
noncomputable def spinFrameSO3 (U : SpinFrame) : Matrix.specialOrthogonalGroup (Fin 3) ℝ :=
  ⟨spinFrameRotationMatrix U, spinFrameRotationMatrix_mem_specialOrthogonalGroup U⟩

/--
The induced group homomorphism from global `SU(2)` frames to `SO(3)`.

Project Koios declaration ID: `QM-SPIN-SO3-DEF-003`.
-/
noncomputable def spinFrameSO3Hom : SpinFrame →* Matrix.specialOrthogonalGroup (Fin 3) ℝ where
  toFun := spinFrameSO3
  map_one' := Subtype.ext spinFrameRotationMatrix_one
  map_mul' U V := Subtype.ext (spinFrameRotationMatrix_mul U V)

/-! ## B. Pauli-basis covariance -/

/--
Active conjugation of one Pauli coordinate is the corresponding column of the induced rotation.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-008`.
-/
lemma spinFrame_pauli_covariance (U : SpinFrame) (j : Fin 3) :
    (U.1 : Matrix (Fin 2) (Fin 2) ℂ) * spinPauliVector j * star U.1 =
      ∑ i : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) • spinPauliVector i := by
  rw [spinPauliVector_eq_physlibPauliMatrix]
  have h := congrArg GaugeAlgebra.toSU2Matrix
    (GaugeAlgebra.adjoint_stdBasis ((1, U, 1) : GaugeGroupI) (Sum.inr (Sum.inl j)))
  rw [GaugeAlgebra.adjoint_toSU2Matrix,
    GaugeAlgebra.stdBasis_inr_inl_toSU2Matrix,
    GaugeAlgebra.toSU2Matrix_sum] at h
  simp only [Fintype.sum_sum_type, GaugeAlgebra.smul_toSU2Matrix,
    GaugeAlgebra.stdBasis_inl_toSU2Matrix, GaugeAlgebra.stdBasis_inr_inl_toSU2Matrix,
    GaugeAlgebra.stdBasis_inr_inr_toSU2Matrix, smul_zero, Finset.sum_const_zero,
    add_zero, zero_add] at h
  change
    U.1 * PauliMatrix.pauliMatrix (Sum.inr j) * star U.1 =
      ∑ x : Fin 3, ((spinFrameRotationMatrix U x j : ℝ) : ℂ) •
        PauliMatrix.pauliMatrix (Sum.inr x) at h
  simpa only [spinPauliVector_eq_physlibPauliMatrix] using h

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/--
An orbital coefficient tensored with one Pauli coordinate transforms by the corresponding column
of the induced rotation.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-009`.
-/
lemma spinFrameRotate_kronecker_pauli (U : SpinFrame) (B : Matrix ι ι ℂ) (j : Fin 3) :
    spinFrameRotate U (B ⊗ₖ spinPauliVector j) =
      ∑ i : Fin 3, (((spinFrameRotationMatrix U i j : ℝ) : ℂ) • B) ⊗ₖ
        spinPauliVector i := by
  rw [spinFrameRotate]
  have hleft :
      spinFrameLift (ι := ι) U * (B ⊗ₖ spinPauliVector j) =
        B ⊗ₖ ((U.1 : Matrix (Fin 2) (Fin 2) ℂ) * spinPauliVector j) := by
    simpa [spinFrameLift] using
      (Matrix.mul_kronecker_mul
        (1 : Matrix ι ι ℂ) B
        (U.1 : Matrix (Fin 2) (Fin 2) ℂ) (spinPauliVector j)).symm
  rw [hleft, spinFrameLift_conjTranspose]
  change
    (B ⊗ₖ ((U.1 : Matrix (Fin 2) (Fin 2) ℂ) * spinPauliVector j)) *
      ((1 : Matrix ι ι ℂ) ⊗ₖ star (U.1 : Matrix (Fin 2) (Fin 2) ℂ)) = _
  rw [← Matrix.mul_kronecker_mul]
  simp only [Matrix.mul_one]
  rw [spinFrame_pauli_covariance]
  ext ⟨a, s⟩ ⟨b, t⟩
  change
    B a b * (∑ i : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) *
      spinPauliVector i s t) =
      ∑ i : Fin 3, (((spinFrameRotationMatrix U i j : ℝ) : ℂ) * B a b) *
        spinPauliVector i s t
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro c _
  ring

/-! ## C. Orbital-valued coefficient covariance -/

/--
The active action of the induced real rotation on orbital-valued Pauli coefficients.

Project Koios declaration ID: `QM-SPIN-SO3-DEF-004`.
-/
noncomputable def spinFrameRotatePauliCoefficients (U : SpinFrame)
    (B : Fin 3 → Matrix ι ι ℂ) : Fin 3 → Matrix ι ι ℂ := fun i =>
  ∑ j : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) • B j

/--
Active spin rotation is covariant on every orbital-valued Pauli contraction.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-010`.
-/
lemma spinFrameRotate_spinPauliDot (U : SpinFrame) (B : Fin 3 → Matrix ι ι ℂ) :
    spinFrameRotate U (spinPauliDot B) =
      spinPauliDot (spinFrameRotatePauliCoefficients U B) := by
  rw [spinPauliDot, spinPauliDot]
  unfold spinFrameRotate
  rw [Matrix.mul_sum, Finset.sum_mul]
  change (∑ j : Fin 3, spinFrameRotate U (B j ⊗ₖ spinPauliVector j)) = _
  simp_rw [spinFrameRotate_kronecker_pauli]
  ext ⟨a, s⟩ ⟨b, t⟩
  change
    (∑ j : Fin 3, ∑ i : Fin 3,
      (((spinFrameRotationMatrix U i j : ℝ) : ℂ) * B j a b) * spinPauliVector i s t) =
    ∑ i : Fin 3,
      (∑ j : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) * B j a b) *
        spinPauliVector i s t
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_mul]

/-- Active conjugation distributes over a sum of spinful matrices. -/
private lemma spinFrameRotate_add (U : SpinFrame)
    (M N : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinFrameRotate U (M + N) = spinFrameRotate U M + spinFrameRotate U N := by
  simp [spinFrameRotate, Matrix.mul_add, Matrix.add_mul]

omit [DecidableEq ι] in
/-- Match vector-indexed and three-coordinate Pauli contractions. -/
private lemma spinPauliDot_eq_spinPauliTerm (B : Fin 3 → Matrix ι ι ℂ) :
    spinPauliDot B = spinPauliTerm (B 0) (B 1) (B 2) := by
  rw [← spinPauliDot_coefficientVector]
  congr 1
  funext a
  fin_cases a <;> rfl

omit [DecidableEq ι] in
/-- Extract the scalar coefficient from its canonical vector-form decomposition. -/
@[simp] private lemma spinIndependentPart_lift_add_spinPauliDot
    (A : Matrix ι ι ℂ) (B : Fin 3 → Matrix ι ι ℂ) :
    spinIndependentPart (spinDegenerateLift A + spinPauliDot B) = A := by
  rw [spinPauliDot_eq_spinPauliTerm]
  exact spinIndependentPart_lift_add_spinPauliTerm A (B 0) (B 1) (B 2)

/-- Extract the vector coefficient from its canonical scalar-plus-Pauli decomposition. -/
@[simp] private lemma spinPauliPartVector_lift_add_spinPauliDot
    (A : Matrix ι ι ℂ) (B : Fin 3 → Matrix ι ι ℂ) :
    spinPauliPartVector (spinDegenerateLift A + spinPauliDot B) = B := by
  rw [spinPauliDot_eq_spinPauliTerm]
  funext a
  fin_cases a <;>
    simp [spinPauliPartVector, spinPauliCoefficientVector]

/--
Active global spin rotation preserves the spin-independent coefficient.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-011`.
-/
lemma spinFrameRotate_spinIndependentPart (U : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinIndependentPart (spinFrameRotate U M) = spinIndependentPart M := by
  have hM := spinPauliVectorDecomposition M
  conv_lhs =>
    rw [hM, spinFrameRotate_add, spinFrameRotate_spinDegenerateLift,
      spinFrameRotate_spinPauliDot]
  exact spinIndependentPart_lift_add_spinPauliDot (ι := ι) _ _

/--
The recovered orbital-valued Pauli coefficient vector transforms by the induced `SO(3)` rotation.

Project Koios declaration ID: `QM-SPIN-SO3-LEM-012`.
-/
lemma spinFrameRotate_spinPauliPartVector (U : SpinFrame)
    (M : Matrix (ι × Fin 2) (ι × Fin 2) ℂ) :
    spinPauliPartVector (spinFrameRotate U M) =
      spinFrameRotatePauliCoefficients U (spinPauliPartVector M) := by
  have hM := spinPauliVectorDecomposition M
  conv_lhs =>
    rw [hM, spinFrameRotate_add, spinFrameRotate_spinDegenerateLift,
      spinFrameRotate_spinPauliDot]
  exact spinPauliPartVector_lift_add_spinPauliDot (ι := ι) _ _

end ProjectKoios.QuantumMechanics.FiniteDimensional

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.Matrix.PosDef

/-!
# Finite spinor density-matrix algebra

Finite outer products, occupation-weighted positivity, traces, and exact density differences.

## i. Overview

This module contains only finite, pointwise spinor algebra.  It deliberately has no measure space,
`Lᵖ` carrier, spatial representative, basis-completeness claim, or convergence statement.

For a supplied two-component spinor value `v : Fin 2 → ℂ`, `spinorOuterProduct v` is the `2 × 2`
matrix `v vᴴ`.  The cross outer product `v wᴴ` exposes the exact difference decomposition used by
downstream approximation estimates. A finite family with supplied real occupations gives the
corresponding weighted sum. The module proves Hermiticity, positive semidefiniteness under
nonnegative weights, trace formulas, and the finite outer-product difference identity.

The representative-safe continuum module imports this algebra and applies it almost everywhere.
Keeping this layer separate leaves finite-basis reconstruction, discretization error, and
finite-to-continuum convergence to explicit downstream comparison maps. The cross outer product is
linear in its first complex argument and conjugate-linear in the second, hence bilinear over `ℝ`.

The spinor values and occupations are supplied finite data. No normalization, orthogonality,
particle number, spatial basis, quadrature, or physical applicability is inferred. These matrices
are not normalized QuantumInfo mixed states: their trace need not be one.

## ii. Key results

- `spinorOuterProduct`, `spinorCrossOuterProduct`: outer and cross outer products on two components.
- `occupationWeightedSpinorDensityMatrix`: finite sums with supplied real occupations.
- `spinorOuterProduct_isHermitian`, `spinorOuterProduct_posSemidef`: one-spinor structure.
- `occupationWeightedSpinorDensityMatrix_posSemidef`: positivity under nonnegative occupations;
  Hermiticity holds for arbitrary real occupations.
- `trace_spinorOuterProduct`, `trace_occupationWeightedSpinorDensityMatrix`: exact sums of component
  norm squares in the traces.
- `spinorOuterProduct_sub`: the two-cross-term density difference identity.

## iii. Table of contents

- A. Outer-product constructions
- B. Hermiticity and positivity
- C. Trace identities
- D. Density difference identity
- E. Proof schematic

## iv. References

This source-neutral finite algebra reuses Mathlib `Matrix.PosSemidef`,
`Matrix.posSemidef_vecMulVec_self_star`, and `Matrix.posSemidef_sum` from the imported matrix
positivity API. Trace calculations use `Matrix.trace_sum`, `Matrix.trace_smul`, and the complex
norm-square identity. It does not port a publication statement or introduce a state abstraction.

## E. Proof schematic

```mermaid
flowchart TD
    data["supplied two-component spinor values<br/>finite families and real occupations"] --> outer["QM-SPIN-DENSITY-FINITE-DEF-001<br/>outer product v v^H"]
    data --> cross["QM-SPIN-DENSITY-FINITE-DEF-003<br/>cross outer product v w^H"]
    outer --> single["QM-SPIN-DENSITY-FINITE-LEM-001/002/005<br/>Hermitian, positive semidefinite<br/>and component norm-square trace"]
    outer --> weighted["QM-SPIN-DENSITY-FINITE-DEF-002<br/>occupation-weighted sum"]
    data --> weighted
    weighted --> family["QM-SPIN-DENSITY-FINITE-LEM-003/004/006<br/>Hermitian for real weights<br/>PSD requires nonnegative weights<br/>weighted component norm-square trace"]
    single --> family
    outer --> difference["QM-SPIN-DENSITY-FINITE-LEM-007<br/>two-cross-term difference identity"]
    cross --> difference
```
-/

open scoped BigOperators ComplexConjugate ComplexOrder Matrix

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

/-! ## A. Outer-product constructions -/

/--
The finite `2 × 2` outer-product density matrix `v vᴴ` of one spinor value.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-DEF-001`.
-/
noncomputable def spinorOuterProduct (v : Fin 2 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun s t => v s * star (v t)

/--
The occupation-weighted finite density matrix of a supplied finite family of spinor values.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-DEF-002`.
-/
noncomputable def occupationWeightedSpinorDensityMatrix
    {ι : Type*} [Fintype ι] (v : ι → Fin 2 → ℂ) (occupation : ι → ℝ) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  ∑ i, (occupation i : ℂ) • spinorOuterProduct (v i)

/--
The finite cross outer product `v wᴴ` of two spinor values.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-DEF-003`.

Unlike `spinorOuterProduct`, this matrix need not be Hermitian or positive semidefinite. It is the
real-bilinear algebraic term needed to separate orbital approximation errors.
-/
noncomputable def spinorCrossOuterProduct (v w : Fin 2 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun s t => v s * star (w t)

/-! ## B. Hermiticity and positivity -/

/--
A finite spinor outer product is Hermitian.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-LEM-001`.
-/
lemma spinorOuterProduct_isHermitian (v : Fin 2 → ℂ) :
    Matrix.IsHermitian (spinorOuterProduct v) := by
  unfold Matrix.IsHermitian
  ext s t
  change star (v t * star (v s)) = v s * star (v t)
  simp [mul_comm]

/--
A finite spinor outer product is positive semidefinite.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-LEM-002`.

The proof reuses Mathlib's canonical `vecMulVec v (star v)` positivity theorem.
-/
lemma spinorOuterProduct_posSemidef (v : Fin 2 → ℂ) :
    Matrix.PosSemidef (spinorOuterProduct v) := by
  have h := Matrix.posSemidef_vecMulVec_self_star v
  have heq : spinorOuterProduct v = Matrix.vecMulVec v (star v) := by
    ext s t
    simp [spinorOuterProduct, Matrix.vecMulVec_apply]
  rw [heq]
  exact h

/--
Every real occupation-weighted finite spinor density matrix is Hermitian.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-LEM-003`.
-/
lemma occupationWeightedSpinorDensityMatrix_isHermitian
    {ι : Type*} [Fintype ι] (v : ι → Fin 2 → ℂ) (occupation : ι → ℝ) :
    Matrix.IsHermitian (occupationWeightedSpinorDensityMatrix v occupation) := by
  unfold occupationWeightedSpinorDensityMatrix
  refine Finset.sum_induction
    (s := Finset.univ)
    (f := fun i => (occupation i : ℂ) • spinorOuterProduct (v i))
    (p := Matrix.IsHermitian) ?_ ?_ ?_
  · intro A B hA hB
    exact hA.add hB
  · exact Matrix.isHermitian_zero
  · intro i _
    exact (spinorOuterProduct_isHermitian (v i)).smul (by rw [isSelfAdjoint_iff]; simp)

/--
Nonnegative occupations give a positive-semidefinite finite spinor density matrix.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-LEM-004`.
-/
lemma occupationWeightedSpinorDensityMatrix_posSemidef
    {ι : Type*} [Fintype ι] (v : ι → Fin 2 → ℂ) (occupation : ι → ℝ)
    (hoccupation : ∀ i, 0 ≤ occupation i) :
    Matrix.PosSemidef (occupationWeightedSpinorDensityMatrix v occupation) := by
  unfold occupationWeightedSpinorDensityMatrix
  apply Matrix.posSemidef_sum Finset.univ
  intro i _
  apply (spinorOuterProduct_posSemidef (v i)).smul
  exact Complex.nonneg_iff.mpr ⟨hoccupation i, rfl⟩

/-! ## C. Trace identities -/

/--
The trace of one finite spinor outer product is the sum of its two component norm squares.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-LEM-005`.
-/
lemma trace_spinorOuterProduct (v : Fin 2 → ℂ) :
    Matrix.trace (spinorOuterProduct v) = (↑(∑ s : Fin 2, ‖v s‖ ^ 2) : ℂ) := by
  change (∑ s : Fin 2, v s * star (v s)) = (↑(∑ s : Fin 2, ‖v s‖ ^ 2) : ℂ)
  push_cast
  apply Finset.sum_congr rfl
  intro s _
  change v s * (starRingEnd ℂ) (v s) = _
  rw [Complex.mul_conj, ← Complex.sq_norm]
  norm_cast

/--
The trace of a weighted finite spinor density matrix is the weighted sum of component norm squares.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-LEM-006`.
-/
lemma trace_occupationWeightedSpinorDensityMatrix
    {ι : Type*} [Fintype ι] (v : ι → Fin 2 → ℂ) (occupation : ι → ℝ) :
    Matrix.trace (occupationWeightedSpinorDensityMatrix v occupation) =
      (↑(∑ i, occupation i * ∑ s : Fin 2, ‖v i s‖ ^ 2) : ℂ) := by
  unfold occupationWeightedSpinorDensityMatrix
  rw [Matrix.trace_sum]
  push_cast
  apply Finset.sum_congr rfl
  intro i _
  rw [Matrix.trace_smul, trace_spinorOuterProduct]
  simp only [smul_eq_mul]
  push_cast
  rfl

/-! ## D. Density difference identity -/

/--
The exact finite difference decomposition
`v vᴴ - w wᴴ = (v - w) vᴴ + w (v - w)ᴴ`.

Project Koios declaration ID: `QM-SPIN-DENSITY-FINITE-LEM-007`.

This identity separates a density-matrix error into two cross terms and is the pointwise algebraic
input to the representative-safe continuum `L² × L² → L¹` stability estimate.
-/
lemma spinorOuterProduct_sub (v w : Fin 2 → ℂ) :
    spinorOuterProduct v - spinorOuterProduct w =
      spinorCrossOuterProduct (v - w) v + spinorCrossOuterProduct w (v - w) := by
  ext s t
  simp only [spinorOuterProduct, spinorCrossOuterProduct, Matrix.sub_apply, Matrix.add_apply,
    Pi.sub_apply, star_sub]
  ring

end ProjectKoios.QuantumMechanics.FiniteDimensional

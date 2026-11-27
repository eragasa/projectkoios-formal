/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinGlobalCollinearity
public import ProjectKoios.QuantumMechanics.FiniteDimensional.SpinorDensityMatrix
public import Mathlib.Analysis.CStarAlgebra.Matrix
public import Mathlib.Analysis.Normed.Operator.Mul
public import Mathlib.MeasureTheory.Function.Holder
public import Mathlib.MeasureTheory.Function.L1Space.Integrable
public import Mathlib.MeasureTheory.Function.LpSeminorm.CompareExp
public import Mathlib.MeasureTheory.Function.LpSpace.Basic

/-!
# Representative-safe continuum spin-density matrices

Complex matrix-valued `L¹` classes provide a representative-safe continuum carrier for spin-density
matrices, global `SU(2)` rotations, Pauli magnetization components, and finite-orbital sums whose
spatial carrier remains continuum `L²`/`L¹`.

## i. Overview

A pointwise noncollinear spin density is a Hermitian `2 × 2` matrix.  In a continuum formalization,
its entries are defined only almost everywhere.  This module therefore uses one matrix-valued `L¹`
equivalence class rather than selecting a pointwise representative.  Hermiticity and fixed-axis
collinearity are stated almost everywhere, while equality of densities is equality in `L¹`.

The module lifts the finite active convention `ρ ↦ U ρ Uᴴ` to the continuum carrier and proves its
group laws.  It defines the particle density `n = tr ρ` and magnetization components
`mᵢ = tr (σᵢ ρ)`, proves their representative formulas and reality for Hermitian densities,
shows that `n` is rotation invariant and `m` transforms by the induced `SO(3)` matrix, and
establishes the exact Pauli reconstruction

`ρ = (1/2) (n I₂ + ∑ᵢ mᵢ σᵢ)`.

A continuum spinor is represented by two scalar complex `L²` components. Their pointwise finite
outer-product algebra comes from `FiniteDimensional/SpinorDensityMatrix.lean`; the products are
lifted into matrix-valued `L¹` using Hölder integrability. Finite orbital-index sums then give the
representative-safe continuum spin-density matrix. Such matrices are positive semidefinite
almost everywhere when the supplied occupations are nonnegative.

## ii. Key results

- `ContinuumSpinDensityMatrix`: matrix-valued complex `L¹` carrier.
- `continuumSpinFrameRotate`: representative-safe active global `SU(2)` rotation.
- `IsGloballySpinCollinearAE`: one common frame gives fixed-axis collinearity almost everywhere.
- `continuumParticleDensity` and `continuumMagnetizationDensity`: trace and Pauli-trace components.
- `continuumParticleDensity_rotate` and `continuumMagnetizationDensity_rotate`: induced covariance.
- `continuumSpinDensity_reconstruction`: exact `L¹` Pauli reconstruction.
- `continuumOccupationWeightedSpinDensityMatrix_apply_ae`: orbital outer-product formula.
- `continuumOccupationWeightedSpinDensityMatrix_isPositiveSemidefiniteAE`: positivity under
  nonnegative occupations.
- `norm_continuumSpinorDensityEntry_sub_le`: explicit `L² × L² → L¹` component-density stability.
- `norm_continuumSpinorDensityMatrix_sub_le`: full matrix-valued `L¹` density-error aggregation.
- `norm_continuumOccupationWeightedSpinDensityMatrix_sub_le`: fixed-occupation family error bound.
- `continuumOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise`: conditional convergence
  transfer from component orbitals to the spin density, particle trace, and magnetization.

## iii. Table of contents

- A. Matrix-valued continuum carrier and global rotations
- B. Almost-everywhere Hermiticity and global collinearity
- C. Particle and magnetization densities
- D. Pauli reconstruction
- E. Orbital spinors and occupation-weighted density matrices
- F. Almost-everywhere positivity
- G. Orbital-to-density stability
- H. Proof schematic

## iv. References

- Carsten A. Ullrich, “Density-functional theory for systems with noncollinear spin,”
  *Physical Review B* **98**, 035140 (2018), DOI `10.1103/PhysRevB.98.035140`,
  arXiv:1805.06417v1, Section II.A, equations (3)--(5).
- Audit record `AUD-SRC-001` records the inspected bytes, exact locators, and candidate-identity
  limitation.  The Lean carrier adapts Ullrich's pointwise matrices to `L¹` equivalence classes and
  allows supplied real occupations; it does not claim a completed publication crosswalk.

## H. Proof schematic

```mermaid
flowchart TD
    l2["supplied two-component L2 spinors<br/>finite orbital families and real weights"] --> holder["QM-SPIN-DENSITY-CONTINUUM-DEF-011/015<br/>Hölder products and real-bilinear lift"]
    holder --> densities["QM-SPIN-DENSITY-CONTINUUM-DEF-012/013<br/>outer-product and weighted L1 densities"]
    densities --> positive["QM-SPIN-DENSITY-CONTINUUM-LEM-028/029<br/>PSD almost everywhere<br/>weighted case requires nonnegative occupations"]
    densities --> carrier["QM-SPIN-DENSITY-CONTINUUM-DEF-001<br/>matrix-valued L1 carrier"]
    carrier --> maps["QM-SPIN-DENSITY-CONTINUUM-DEF-002/006/007/008<br/>rotation, trace/Pauli maps and collinearity predicate<br/>collinearity requires one common frame<br/>giving almost-everywhere diagonality"]
    maps --> reconstruct["QM-SPIN-DENSITY-CONTINUUM-LEM-020<br/>exact L1 Pauli reconstruction"]
    holder --> entries["QM-SPIN-DENSITY-CONTINUUM-LEM-034/035<br/>component L2-to-L1 error bounds"]
    entries --> matrixBound["QM-SPIN-DENSITY-CONTINUUM-LEM-039/040<br/>matrix-unit norm aggregation<br/>finite family with fixed real weights"]
    holder --> continuity["QM-SPIN-DENSITY-CONTINUUM-LEM-041 to 049<br/>continuous density/trace maps<br/>L1 convergence given componentwise L2 convergence<br/>and fixed occupations"]
    %% Invisible links constrain layout only, not mathematical dependencies.
    densities ~~~ entries
    matrixBound ~~~ continuity
```
-/

@[expose] public section

open scoped BigOperators ComplexConjugate ComplexOrder Matrix Matrix.Norms.L2Operator Topology

namespace ProjectKoios.QuantumMechanics.SpinDensity

open Filter MeasureTheory
open ProjectKoios.QuantumMechanics.FiniteDimensional

/-! ## A. Matrix-valued continuum carrier and global rotations -/

/--
Matrix-valued complex `L¹` equivalence classes for representative-safe continuum spin densities.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-001`.

No Hermiticity, positivity, normalization, orbital representability, finite-basis reconstruction,
or convergence property is built into the carrier; those are separate predicates or constructions.
-/
noncomputable abbrev ContinuumSpinDensityMatrix (α : Type*) [MeasurableSpace α]
    (μ : Measure α) := Lp (Matrix (Fin 2) (Fin 2) ℂ) 1 μ

/--
Active global spin-frame rotation of a matrix-valued continuum density.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-002`.

The continuous linear map acts on the `L¹` class, so the definition is independent of any chosen
pointwise representative.
-/
noncomputable def continuumSpinFrameRotate {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (U : SpinFrame) (ρ : ContinuumSpinDensityMatrix α μ) :
    ContinuumSpinDensityMatrix α μ :=
  ((ContinuousLinearMap.mulLeftRight ℂ (Matrix (Fin 2) (Fin 2) ℂ))
    U.1 (star U.1)).compLp ρ

/--
The continuum rotation is represented almost everywhere by `x ↦ U ρ(x) Uᴴ`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-001`.
-/
lemma continuumSpinFrameRotate_apply_ae {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (U : SpinFrame) (ρ : ContinuumSpinDensityMatrix α μ) :
    continuumSpinFrameRotate U ρ =ᵐ[μ] fun x => U.1 * ρ x * star U.1 := by
  unfold continuumSpinFrameRotate
  exact ((ContinuousLinearMap.mulLeftRight ℂ (Matrix (Fin 2) (Fin 2) ℂ))
    U.1 (star U.1)).coeFn_compLp ρ

/--
The identity spin frame acts trivially on continuum spin densities.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-002`.
-/
@[simp] lemma continuumSpinFrameRotate_one {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) :
    continuumSpinFrameRotate (1 : SpinFrame) ρ = ρ := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumSpinFrameRotate_apply_ae (1 : SpinFrame) ρ] with x hx
  simpa using hx

/--
Continuum active spin rotations compose in `SU(2)` multiplication order.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-003`.
-/
@[simp] lemma continuumSpinFrameRotate_mul {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (U V : SpinFrame) (ρ : ContinuumSpinDensityMatrix α μ) :
    continuumSpinFrameRotate (U * V) ρ =
      continuumSpinFrameRotate U (continuumSpinFrameRotate V ρ) := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumSpinFrameRotate_apply_ae (U * V) ρ,
    continuumSpinFrameRotate_apply_ae V ρ,
    continuumSpinFrameRotate_apply_ae U (continuumSpinFrameRotate V ρ)] with x hUV hV hU
  rw [hUV, hU, hV]
  simp [Matrix.mul_assoc]

/--
Rotation by the inverse frame exactly undoes a continuum spin rotation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-004`.
-/
@[simp] lemma continuumSpinFrameRotate_inv_rotate {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (U : SpinFrame) (ρ : ContinuumSpinDensityMatrix α μ) :
    continuumSpinFrameRotate U⁻¹ (continuumSpinFrameRotate U ρ) = ρ := by
  rw [← continuumSpinFrameRotate_mul, inv_mul_cancel, continuumSpinFrameRotate_one]

/-! ## B. Almost-everywhere Hermiticity and global collinearity -/

/--
A matrix-valued continuum density is Hermitian almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-003`.
-/
def IsHermitianAE {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) : Prop :=
  ∀ᵐ x ∂μ, (ρ x).IsHermitian

/--
Almost-everywhere Hermiticity is preserved by every global spin-frame rotation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-005`.
-/
lemma IsHermitianAE.rotate {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {ρ : ContinuumSpinDensityMatrix α μ} (hρ : IsHermitianAE ρ) (U : SpinFrame) :
    IsHermitianAE (continuumSpinFrameRotate U ρ) := by
  filter_upwards [hρ, continuumSpinFrameRotate_apply_ae U ρ] with x hx hrot
  rw [hrot]
  exact Matrix.isHermitian_mul_mul_conjTranspose U.1 hx

/--
Fixed-`z` continuum collinearity means that both cross-spin entries vanish almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-004`.
-/
def IsSpinCollinearZAE {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) : Prop :=
  ∀ᵐ x ∂μ, ρ x 0 1 = 0 ∧ ρ x 1 0 = 0

/--
Almost-everywhere fixed-axis collinearity after one specified global active spin rotation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-005`.
-/
def IsSpinCollinearInGlobalFrame {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (U : SpinFrame) (ρ : ContinuumSpinDensityMatrix α μ) : Prop :=
  IsSpinCollinearZAE (continuumSpinFrameRotate U ρ)

/--
Existence of one spatially independent frame making a continuum density fixed-axis collinear almost
everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-006`.

The witness cannot vary with `x`; local spin frames are deliberately excluded.
-/
def IsGloballySpinCollinearAE {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) : Prop :=
  ∃ U : SpinFrame, IsSpinCollinearInGlobalFrame U ρ

/--
The identity global frame recovers almost-everywhere fixed-`z` collinearity.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-006`.
-/
@[simp] lemma isSpinCollinearInGlobalFrame_one {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ρ : ContinuumSpinDensityMatrix α μ) :
    IsSpinCollinearInGlobalFrame (1 : SpinFrame) ρ ↔ IsSpinCollinearZAE ρ := by
  simp [IsSpinCollinearInGlobalFrame]

/--
Almost-everywhere fixed-axis collinearity implies global continuum collinearity.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-007`.
-/
lemma IsSpinCollinearZAE.isGloballySpinCollinearAE {α : Type*} [MeasurableSpace α]
    {μ : Measure α} {ρ : ContinuumSpinDensityMatrix α μ} (hρ : IsSpinCollinearZAE ρ) :
    IsGloballySpinCollinearAE ρ := by
  exact ⟨1, isSpinCollinearInGlobalFrame_one ρ |>.2 hρ⟩

/--
Testing collinearity after rotating the density composes the two active global frames.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-008`.
-/
lemma isSpinCollinearInGlobalFrame_rotate (U V : SpinFrame)
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) :
    IsSpinCollinearInGlobalFrame U (continuumSpinFrameRotate V ρ) ↔
      IsSpinCollinearInGlobalFrame (U * V) ρ := by
  simp only [IsSpinCollinearInGlobalFrame, continuumSpinFrameRotate_mul]

/--
Global almost-everywhere spin collinearity is invariant under further global spin rotation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-009`.
-/
@[simp] lemma isGloballySpinCollinearAE_rotate (V : SpinFrame)
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) :
    IsGloballySpinCollinearAE (continuumSpinFrameRotate V ρ) ↔
      IsGloballySpinCollinearAE ρ := by
  constructor
  · rintro ⟨U, hU⟩
    exact ⟨U * V, (isSpinCollinearInGlobalFrame_rotate U V ρ).1 hU⟩
  · rintro ⟨U, hU⟩
    refine ⟨U * V⁻¹, ?_⟩
    rw [isSpinCollinearInGlobalFrame_rotate]
    simpa [mul_assoc] using hU

/-! ## C. Particle and magnetization densities -/

/--
The representative-safe particle-density class `n = tr ρ`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-007`.

The codomain is complex `L¹`; `IsHermitianAE.continuumParticleDensity_im_zero` proves that the
class has a real-valued representative almost everywhere for Hermitian `ρ`.
-/
noncomputable def continuumParticleDensity {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) : Lp ℂ 1 μ :=
  ((Matrix.traceLinearMap (Fin 2) ℂ ℂ).toContinuousLinearMap).compLp ρ

/--
The representative-safe Pauli magnetization component `mᵢ = tr (σᵢ ρ)`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-008`.
-/
noncomputable def continuumMagnetizationDensity {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) (a : Fin 3) : Lp ℂ 1 μ :=
  ((Matrix.traceLinearMap (Fin 2) ℂ ℂ).toContinuousLinearMap.comp
    ((ContinuousLinearMap.mulLeftRight ℂ (Matrix (Fin 2) (Fin 2) ℂ))
      (spinPauliVector a) 1)).compLp ρ

/--
The particle-density class is represented almost everywhere by the pointwise matrix trace.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-010`.
-/
lemma continuumParticleDensity_apply_ae {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) :
    continuumParticleDensity ρ =ᵐ[μ] fun x => Matrix.trace (ρ x) := by
  unfold continuumParticleDensity
  exact ((Matrix.traceLinearMap (Fin 2) ℂ ℂ).toContinuousLinearMap).coeFn_compLp ρ

/--
Each magnetization class is represented almost everywhere by its pointwise Pauli trace.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-011`.
-/
lemma continuumMagnetizationDensity_apply_ae {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) (a : Fin 3) :
    continuumMagnetizationDensity ρ a =ᵐ[μ]
      fun x => Matrix.trace (spinPauliVector a * ρ x) := by
  unfold continuumMagnetizationDensity
  filter_upwards [((Matrix.traceLinearMap (Fin 2) ℂ ℂ).toContinuousLinearMap.comp
    ((ContinuousLinearMap.mulLeftRight ℂ (Matrix (Fin 2) (Fin 2) ℂ))
      (spinPauliVector a) 1)).coeFn_compLp ρ] with x hx
  simpa using hx

/--
The particle density of an almost-everywhere Hermitian spin density is real almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-012`.
-/
lemma IsHermitianAE.continuumParticleDensity_im_zero {α : Type*} [MeasurableSpace α]
    {μ : Measure α} {ρ : ContinuumSpinDensityMatrix α μ} (hρ : IsHermitianAE ρ) :
    ∀ᵐ x ∂μ, (continuumParticleDensity ρ x).im = 0 := by
  filter_upwards [hρ, continuumParticleDensity_apply_ae ρ] with x hx hn
  rw [hn]
  apply Complex.conj_eq_iff_im.mp
  exact (Matrix.trace_conjTranspose (ρ x)).symm.trans (congrArg Matrix.trace hx.eq)

/--
Every Pauli magnetization component of an almost-everywhere Hermitian density is real almost
everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-013`.
-/
lemma IsHermitianAE.continuumMagnetizationDensity_im_zero {α : Type*}
    [MeasurableSpace α] {μ : Measure α} {ρ : ContinuumSpinDensityMatrix α μ}
    (hρ : IsHermitianAE ρ) (a : Fin 3) :
    ∀ᵐ x ∂μ, (continuumMagnetizationDensity ρ a x).im = 0 := by
  filter_upwards [hρ, continuumMagnetizationDensity_apply_ae ρ a] with x hx hm
  rw [hm]
  apply Complex.conj_eq_iff_im.mp
  calc
    (starRingEnd ℂ) (Matrix.trace (spinPauliVector a * ρ x)) =
        Matrix.trace ((spinPauliVector a * ρ x)ᴴ) :=
      (Matrix.trace_conjTranspose (spinPauliVector a * ρ x)).symm
    _ = Matrix.trace (ρ x * spinPauliVector a) := by
      rw [Matrix.conjTranspose_mul, hx.eq, (spinPauliVector_isHermitian a).eq]
    _ = Matrix.trace (spinPauliVector a * ρ x) := Matrix.trace_mul_comm _ _

/--
The trace of a finite spin-density matrix is invariant under active global spin conjugation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-014`.
-/
lemma trace_spinFrame_conjugation (U : SpinFrame) (M : Matrix (Fin 2) (Fin 2) ℂ) :
    Matrix.trace (U.1 * M * star U.1) = Matrix.trace M := by
  calc
    Matrix.trace (U.1 * M * star U.1) = Matrix.trace (star U.1 * U.1 * M) :=
      Matrix.trace_mul_cycle U.1 M (star U.1)
    _ = Matrix.trace M := by rw [U.property.1.1, Matrix.one_mul]

/--
Pauli traces transform by the induced active `SO(3)` rotation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-015`.

The convention is `m'ᵢ = ∑ⱼ R(U)ᵢⱼ mⱼ`.
-/
lemma pauliTrace_spinFrame_conjugation (U : SpinFrame)
    (M : Matrix (Fin 2) (Fin 2) ℂ) (i : Fin 3) :
    Matrix.trace (spinPauliVector i * (U.1 * M * star U.1)) =
      ∑ j : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) *
        Matrix.trace (spinPauliVector j * M) := by
  calc
    Matrix.trace (spinPauliVector i * (U.1 * M * star U.1)) =
        Matrix.trace (star U.1 * spinPauliVector i * U.1 * M) := by
      simpa [Matrix.mul_assoc] using
        (Matrix.trace_mul_cycle (spinPauliVector i * U.1) M (star U.1))
    _ = Matrix.trace
        ((∑ j : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) •
          spinPauliVector j) * M) := by
      have h := spinFrame_pauli_covariance U⁻¹ i
      change star U.1 * spinPauliVector i * star (star U.1) = _ at h
      simp only [star_star] at h
      rw [spinFrameRotationMatrix_inv] at h
      simp only [Matrix.transpose_apply] at h
      rw [h]
    _ = ∑ j : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) *
        Matrix.trace (spinPauliVector j * M) := by
      simp [Finset.sum_mul, Matrix.trace_sum]

/--
The representative-safe continuum particle density is invariant under global spin rotation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-016`.
-/
lemma continuumParticleDensity_rotate {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (U : SpinFrame) (ρ : ContinuumSpinDensityMatrix α μ) :
    continuumParticleDensity (continuumSpinFrameRotate U ρ) = continuumParticleDensity ρ := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumParticleDensity_apply_ae (continuumSpinFrameRotate U ρ),
    continuumSpinFrameRotate_apply_ae U ρ,
    continuumParticleDensity_apply_ae ρ] with x hleft hrot hright
  rw [hleft, hrot, hright]
  exact trace_spinFrame_conjugation U (ρ x)

/--
The representative-safe continuum magnetization vector transforms by the induced `SO(3)` matrix.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-017`.

The equality is in complex `L¹`; Hermitian densities have real-valued representatives almost
everywhere by `IsHermitianAE.continuumMagnetizationDensity_im_zero`.
-/
lemma continuumMagnetizationDensity_rotate {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (U : SpinFrame) (ρ : ContinuumSpinDensityMatrix α μ) (i : Fin 3) :
    continuumMagnetizationDensity (continuumSpinFrameRotate U ρ) i =
      ∑ j : Fin 3, ((spinFrameRotationMatrix U i j : ℝ) : ℂ) •
        continuumMagnetizationDensity ρ j := by
  apply Lp.ext (μ := μ)
  have hm : ∀ᵐ x ∂μ, ∀ j : Fin 3,
      continuumMagnetizationDensity ρ j x =
        Matrix.trace (spinPauliVector j * ρ x) :=
    Filter.eventually_all.mpr fun j => continuumMagnetizationDensity_apply_ae ρ j
  have hsmul : ∀ᵐ x ∂μ, ∀ j : Fin 3,
      (((spinFrameRotationMatrix U i j : ℝ) : ℂ) •
        continuumMagnetizationDensity ρ j) x =
      ((spinFrameRotationMatrix U i j : ℝ) : ℂ) *
        continuumMagnetizationDensity ρ j x :=
    Filter.eventually_all.mpr fun j => by
      filter_upwards [Lp.coeFn_smul ((spinFrameRotationMatrix U i j : ℝ) : ℂ)
        (continuumMagnetizationDensity ρ j)] with x hx
      simpa using hx
  filter_upwards [continuumMagnetizationDensity_apply_ae
      (continuumSpinFrameRotate U ρ) i,
    continuumSpinFrameRotate_apply_ae U ρ, hm, hsmul,
    Lp.coeFn_finsetSum Finset.univ (fun j : Fin 3 =>
      ((spinFrameRotationMatrix U i j : ℝ) : ℂ) •
        continuumMagnetizationDensity ρ j)] with x hleft hrot hma hs hsum
  rw [hleft, hrot, hsum]
  simp only [Finset.sum_apply]
  simp_rw [hs, hma]
  exact pauliTrace_spinFrame_conjugation U (ρ x) i

/-! ## D. Pauli reconstruction -/

/--
Lift a complex scalar `L¹` class to a matrix-valued class by multiplication with a fixed matrix.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-009`.
-/
noncomputable def continuumConstantMatrixMul {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (A : Matrix (Fin 2) (Fin 2) ℂ) (f : Lp ℂ 1 μ) :
    ContinuumSpinDensityMatrix α μ :=
  (ContinuousLinearMap.toSpanSingleton ℂ A).compLp f

/--
The fixed-matrix lift is represented almost everywhere by pointwise scalar multiplication.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-018`.
-/
lemma continuumConstantMatrixMul_apply_ae {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (A : Matrix (Fin 2) (Fin 2) ℂ) (f : Lp ℂ 1 μ) :
    continuumConstantMatrixMul A f =ᵐ[μ] fun x => f x • A := by
  exact (ContinuousLinearMap.toSpanSingleton ℂ A).coeFn_compLp f

/--
Every complex `2 × 2` matrix has the exact trace-plus-Pauli reconstruction.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-019`.

This is the finite pointwise algebra underlying Ullrich's equation (5); no Hermiticity hypothesis is
needed for the complex identity.
-/
lemma matrix_pauli_reconstruction (M : Matrix (Fin 2) (Fin 2) ℂ) :
    M = (2 : ℂ)⁻¹ •
      ((Matrix.trace M) • (1 : Matrix (Fin 2) (Fin 2) ℂ) +
        ∑ a : Fin 3, Matrix.trace (spinPauliVector a * M) • spinPauliVector a) := by
  ext i j
  fin_cases i <;> fin_cases j
  all_goals simp [Matrix.trace, Matrix.mul_apply, spinPauliVector, spinPauliX,
    spinPauliY, spinPauliZ, Fin.sum_univ_two, Fin.sum_univ_three]
  all_goals ring_nf
  all_goals simp [Complex.I_sq]
  all_goals ring

/--
Exact representative-safe Pauli reconstruction of every continuum spin-density class.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-020`.

Equality is in matrix-valued `L¹`, so the result is independent of representative choices.
-/
lemma continuumSpinDensity_reconstruction {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) :
    ρ = (2 : ℂ)⁻¹ •
      (continuumConstantMatrixMul (1 : Matrix (Fin 2) (Fin 2) ℂ)
          (continuumParticleDensity ρ) +
        ∑ a : Fin 3, continuumConstantMatrixMul (spinPauliVector a)
          (continuumMagnetizationDensity ρ a)) := by
  apply Lp.ext (μ := μ)
  have hm : ∀ᵐ x ∂μ, ∀ a : Fin 3,
      continuumMagnetizationDensity ρ a x =
        Matrix.trace (spinPauliVector a * ρ x) :=
    Filter.eventually_all.mpr (fun a => continuumMagnetizationDensity_apply_ae ρ a)
  have hliftm : ∀ᵐ x ∂μ, ∀ a : Fin 3,
      continuumConstantMatrixMul (spinPauliVector a)
          (continuumMagnetizationDensity ρ a) x =
        continuumMagnetizationDensity ρ a x • spinPauliVector a :=
    Filter.eventually_all.mpr (fun a =>
      continuumConstantMatrixMul_apply_ae (spinPauliVector a)
        (continuumMagnetizationDensity ρ a))
  filter_upwards [continuumParticleDensity_apply_ae ρ,
    continuumConstantMatrixMul_apply_ae (1 : Matrix (Fin 2) (Fin 2) ℂ)
      (continuumParticleDensity ρ), hm, hliftm,
    Lp.coeFn_finsetSum Finset.univ (fun a : Fin 3 =>
      continuumConstantMatrixMul (spinPauliVector a) (continuumMagnetizationDensity ρ a)),
    Lp.coeFn_add
      (continuumConstantMatrixMul (1 : Matrix (Fin 2) (Fin 2) ℂ)
        (continuumParticleDensity ρ))
      (∑ a : Fin 3, continuumConstantMatrixMul (spinPauliVector a)
        (continuumMagnetizationDensity ρ a)),
    Lp.coeFn_smul (2 : ℂ)⁻¹
      (continuumConstantMatrixMul (1 : Matrix (Fin 2) (Fin 2) ℂ)
          (continuumParticleDensity ρ) +
        ∑ a : Fin 3, continuumConstantMatrixMul (spinPauliVector a)
          (continuumMagnetizationDensity ρ a))] with x hn hliftn hma hliftma hsum hadd hsmul
  rw [hsmul]
  change ρ x = (2 : ℂ)⁻¹ •
    ((continuumConstantMatrixMul (1 : Matrix (Fin 2) (Fin 2) ℂ)
      (continuumParticleDensity ρ) +
      ∑ a : Fin 3, continuumConstantMatrixMul (spinPauliVector a)
        (continuumMagnetizationDensity ρ a)) x)
  rw [hadd]
  simp only [Pi.add_apply]
  rw [hliftn, hn, hsum]
  simp only [Finset.sum_apply]
  simp_rw [hliftma, hma]
  exact matrix_pauli_reconstruction (ρ x)

/-! ## E. Orbital spinors and occupation-weighted density matrices -/

/--
A representative-safe continuum spinor as two scalar complex `L²` components.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-010`.

The definition is generic over a measure space.  Taking `α = Space d` recovers the Physlib
continuum spatial carrier componentwise.
-/
noncomputable abbrev ContinuumSpinor (α : Type*) [MeasurableSpace α] (μ : Measure α) :=
  Fin 2 → Lp ℂ 2 μ

/--
The scalar complex `L¹` class represented by one pair of spinor components
`ψₛ(x) conj(ψₜ(x))`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-011`.
-/
noncomputable def continuumSpinorDensityEntry {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ : ContinuumSpinor α μ) (s t : Fin 2) : Lp ℂ 1 μ := by
  have hs : MemLp (fun x => ψ s x) (2 : ENNReal) μ := Lp.memLp (ψ s)
  have ht : MemLp (fun x => star (ψ t x)) (2 : ENNReal) μ :=
    (Lp.memLp (ψ t)).star
  have hst : Integrable (fun x => ψ s x * star (ψ t x)) μ :=
    hs.integrable_mul ht
  exact hst.toL1 (fun x => ψ s x * star (ψ t x))

/--
A spinor density entry is represented almost everywhere by its component product.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-021`.
-/
lemma continuumSpinorDensityEntry_apply_ae {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ : ContinuumSpinor α μ) (s t : Fin 2) :
    continuumSpinorDensityEntry ψ s t =ᵐ[μ] fun x => ψ s x * star (ψ t x) := by
  unfold continuumSpinorDensityEntry
  exact Integrable.coeFn_toL1 _

/--
The matrix-valued `L¹` outer-product density of one continuum spinor.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-012`.
-/
noncomputable def continuumSpinorDensityMatrix {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ : ContinuumSpinor α μ) : ContinuumSpinDensityMatrix α μ :=
  ∑ s : Fin 2, ∑ t : Fin 2,
    continuumConstantMatrixMul (Matrix.single s t 1) (continuumSpinorDensityEntry ψ s t)

/--
One spinor density is represented almost everywhere by the pointwise outer matrix
`ψₛ(x) conj(ψₜ(x))`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-022`.
-/
lemma continuumSpinorDensityMatrix_apply_ae {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ : ContinuumSpinor α μ) :
    continuumSpinorDensityMatrix ψ =ᵐ[μ]
      fun x => spinorOuterProduct (fun s => ψ s x) := by
  have hentry : ∀ᵐ x ∂μ, ∀ s t : Fin 2,
      continuumSpinorDensityEntry ψ s t x = ψ s x * star (ψ t x) :=
    Filter.eventually_all.mpr fun s => Filter.eventually_all.mpr fun t =>
      continuumSpinorDensityEntry_apply_ae ψ s t
  have hlift : ∀ᵐ x ∂μ, ∀ s t : Fin 2,
      continuumConstantMatrixMul (Matrix.single s t 1)
          (continuumSpinorDensityEntry ψ s t) x =
        continuumSpinorDensityEntry ψ s t x • Matrix.single s t 1 :=
    Filter.eventually_all.mpr fun s => Filter.eventually_all.mpr fun t =>
      continuumConstantMatrixMul_apply_ae (Matrix.single s t 1)
        (continuumSpinorDensityEntry ψ s t)
  have hinner : ∀ᵐ x ∂μ, ∀ s : Fin 2,
      (∑ t : Fin 2, continuumConstantMatrixMul (Matrix.single s t 1)
        (continuumSpinorDensityEntry ψ s t)) x =
      ∑ t : Fin 2, continuumConstantMatrixMul (Matrix.single s t 1)
        (continuumSpinorDensityEntry ψ s t) x :=
    Filter.eventually_all.mpr fun s =>
      Lp.coeFn_finsetSum Finset.univ (fun t : Fin 2 =>
        continuumConstantMatrixMul (Matrix.single s t 1)
          (continuumSpinorDensityEntry ψ s t))
  filter_upwards [hentry, hlift, hinner,
    Lp.coeFn_finsetSum Finset.univ (fun s : Fin 2 =>
      ∑ t : Fin 2, continuumConstantMatrixMul (Matrix.single s t 1)
        (continuumSpinorDensityEntry ψ s t))] with x he hl hi ho
  unfold continuumSpinorDensityMatrix
  change (∑ s : Fin 2, ∑ t : Fin 2,
    continuumConstantMatrixMul (Matrix.single s t 1)
      (continuumSpinorDensityEntry ψ s t)) x =
    spinorOuterProduct (fun s => ψ s x)
  rw [ho]
  apply Matrix.ext
  intro a b
  change (∑ s : Fin 2, ((∑ t : Fin 2,
    continuumConstantMatrixMul (Matrix.single s t 1)
      (continuumSpinorDensityEntry ψ s t)) x) a b) =
    spinorOuterProduct (fun s => ψ s x) a b
  calc
    (∑ s : Fin 2, ((∑ t : Fin 2,
        continuumConstantMatrixMul (Matrix.single s t 1)
          (continuumSpinorDensityEntry ψ s t)) x) a b) =
        ∑ s : Fin 2, ∑ t : Fin 2,
          (continuumConstantMatrixMul (Matrix.single s t 1)
            (continuumSpinorDensityEntry ψ s t) x) a b := by
      apply Finset.sum_congr rfl
      intro s _
      rw [hi s]
      rw [Matrix.sum_apply]
    _ = spinorOuterProduct (fun s => ψ s x) a b := by
      simp_rw [hl, he]
      fin_cases a <;> fin_cases b <;>
        simp [Matrix.single_apply, spinorOuterProduct]

/--
The outer-product density of one continuum spinor is Hermitian almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-023`.
-/
lemma continuumSpinorDensityMatrix_isHermitianAE {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ : ContinuumSpinor α μ) :
    IsHermitianAE (continuumSpinorDensityMatrix ψ) := by
  filter_upwards [continuumSpinorDensityMatrix_apply_ae ψ] with x hx
  rw [hx]
  exact spinorOuterProduct_isHermitian (fun s => ψ s x)

/--
Finite occupation-weighted sum of continuum spinor outer-product densities.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-013`.

Occupations are supplied real numbers.  Nonnegativity and normalization are not inferred by this
definition.
-/
noncomputable def continuumOccupationWeightedSpinDensityMatrix
    {Orbital α : Type*} [Fintype Orbital] [MeasurableSpace α] {μ : Measure α}
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) :
    ContinuumSpinDensityMatrix α μ :=
  ∑ i, (occupation i : ℂ) • continuumSpinorDensityMatrix (orbitals i)

/--
The occupation-weighted density has Ullrich's orbital outer-product representative almost
everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-024`.

This adapts the occupied-orbital sum by allowing explicit supplied real occupation weights.
-/
lemma continuumOccupationWeightedSpinDensityMatrix_apply_ae
    {Orbital α : Type*} [Fintype Orbital] [MeasurableSpace α] {μ : Measure α}
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) :
    continuumOccupationWeightedSpinDensityMatrix orbitals occupation =ᵐ[μ]
      fun x => occupationWeightedSpinorDensityMatrix
        (fun i s => orbitals i s x) occupation := by
  have horb : ∀ᵐ x ∂μ, ∀ i : Orbital,
      continuumSpinorDensityMatrix (orbitals i) x =
        spinorOuterProduct (fun s => orbitals i s x) :=
    Filter.eventually_all.mpr fun i => continuumSpinorDensityMatrix_apply_ae (orbitals i)
  have hsmul : ∀ᵐ x ∂μ, ∀ i : Orbital,
      ((occupation i : ℂ) • continuumSpinorDensityMatrix (orbitals i)) x =
        (occupation i : ℂ) • continuumSpinorDensityMatrix (orbitals i) x :=
    Filter.eventually_all.mpr fun i =>
      Lp.coeFn_smul (occupation i : ℂ) (continuumSpinorDensityMatrix (orbitals i))
  filter_upwards [horb, hsmul,
    Lp.coeFn_finsetSum Finset.univ (fun i : Orbital =>
      (occupation i : ℂ) • continuumSpinorDensityMatrix (orbitals i))] with x ho hs hsum
  unfold continuumOccupationWeightedSpinDensityMatrix
  rw [hsum, Finset.sum_apply]
  unfold occupationWeightedSpinorDensityMatrix
  apply Finset.sum_congr rfl
  intro i _
  rw [hs i, ho i]

/--
Every real occupation-weighted finite spinor density is Hermitian almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-025`.

Positivity under nonnegative occupations is proved separately below.
-/
lemma continuumOccupationWeightedSpinDensityMatrix_isHermitianAE
    {Orbital α : Type*} [Fintype Orbital] [MeasurableSpace α] {μ : Measure α}
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) :
    IsHermitianAE (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) := by
  filter_upwards [continuumOccupationWeightedSpinDensityMatrix_apply_ae orbitals occupation]
    with x hx
  rw [hx]
  exact occupationWeightedSpinorDensityMatrix_isHermitian
    (fun i s => orbitals i s x) occupation

/-! ## F. Almost-everywhere positivity -/

/--
A continuum spin-density matrix is positive semidefinite almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-014`.

This predicate uses Mathlib's exact complex Hermitian positive-semidefinite matrix semantics at
almost every spatial point.
-/
def IsPositiveSemidefiniteAE {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ρ : ContinuumSpinDensityMatrix α μ) : Prop :=
  ∀ᵐ x ∂μ, Matrix.PosSemidef (ρ x)

/--
Almost-everywhere positive semidefiniteness implies almost-everywhere Hermiticity.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-026`.
-/
lemma IsPositiveSemidefiniteAE.isHermitianAE {α : Type*} [MeasurableSpace α]
    {μ : Measure α} {ρ : ContinuumSpinDensityMatrix α μ}
    (hρ : IsPositiveSemidefiniteAE ρ) : IsHermitianAE ρ :=
  hρ.mono fun _ hx => hx.isHermitian

/--
Almost-everywhere positive semidefiniteness is preserved by global active spin rotation.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-027`.
-/
lemma IsPositiveSemidefiniteAE.rotate {α : Type*} [MeasurableSpace α]
    {μ : Measure α} {ρ : ContinuumSpinDensityMatrix α μ}
    (hρ : IsPositiveSemidefiniteAE ρ) (U : SpinFrame) :
    IsPositiveSemidefiniteAE (continuumSpinFrameRotate U ρ) := by
  filter_upwards [hρ, continuumSpinFrameRotate_apply_ae U ρ] with x hx hrot
  rw [hrot]
  exact hx.mul_mul_conjTranspose_same U.1

/--
The outer-product density matrix of one continuum spinor is positive semidefinite almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-028`.
-/
lemma continuumSpinorDensityMatrix_isPositiveSemidefiniteAE
    {α : Type*} [MeasurableSpace α] {μ : Measure α} (ψ : ContinuumSpinor α μ) :
    IsPositiveSemidefiniteAE (continuumSpinorDensityMatrix ψ) := by
  filter_upwards [continuumSpinorDensityMatrix_apply_ae ψ] with x hx
  rw [hx]
  exact spinorOuterProduct_posSemidef (fun s => ψ s x)

/--
A finite occupation-weighted continuum spin-density matrix is positive semidefinite almost
everywhere when every supplied occupation is nonnegative.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-029`.
-/
lemma continuumOccupationWeightedSpinDensityMatrix_isPositiveSemidefiniteAE
    {Orbital α : Type*} [Fintype Orbital] [MeasurableSpace α] {μ : Measure α}
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ)
    (hoccupation : ∀ i, 0 ≤ occupation i) :
    IsPositiveSemidefiniteAE
      (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) := by
  filter_upwards [continuumOccupationWeightedSpinDensityMatrix_apply_ae orbitals occupation]
    with x hx
  rw [hx]
  exact occupationWeightedSpinorDensityMatrix_posSemidef
    (fun i s => orbitals i s x) occupation hoccupation

/-! ## G. Orbital-to-density stability -/

/--
The real-bilinear complex map `(z, w) ↦ z conj(w)` used by the Hölder lift from two `L²`
components to one `L¹` density entry.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-DEF-015`.

Real bilinearity is essential: complex conjugation is conjugate-linear over `ℂ` but linear over
`ℝ`. The downstream `holder` construction therefore treats complex `Lᵖ` spaces as real normed
spaces while preserving their complex-valued representatives.
-/
noncomputable def spinorDensityEntryBilinear : ℂ →L[ℝ] ℂ →L[ℝ] ℂ :=
  (ContinuousLinearMap.precompR ℂ (ContinuousLinearMap.mul ℝ ℂ)).flip Complex.conjCLE

/--
The density-entry bilinear map evaluates to `z conj(w)`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-030`.
-/
lemma spinorDensityEntryBilinear_apply (z w : ℂ) :
    spinorDensityEntryBilinear z w = z * star w := by
  rfl

/--
The operator norm of the density-entry bilinear map is exactly one.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-031`.
-/
lemma spinorDensityEntryBilinear_norm : ‖spinorDensityEntryBilinear‖ = 1 := by
  apply le_antisymm
  · apply ContinuousLinearMap.opNorm_le_bound _ zero_le_one
    intro z
    rw [one_mul]
    apply ContinuousLinearMap.opNorm_le_bound _ (norm_nonneg z)
    intro w
    simp [spinorDensityEntryBilinear]
  · have h := ContinuousLinearMap.le_opNorm₂ spinorDensityEntryBilinear (1 : ℂ) (1 : ℂ)
    simpa [spinorDensityEntryBilinear] using h

/--
The existing representative-safe density entry is exactly Mathlib's Hölder lift of
`(z, w) ↦ z conj(w)`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-032`.
-/
lemma continuumSpinorDensityEntry_eq_holder {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ : ContinuumSpinor α μ) (s t : Fin 2) :
    continuumSpinorDensityEntry ψ s t =
      spinorDensityEntryBilinear.holder 1 (ψ s) (ψ t) := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumSpinorDensityEntry_apply_ae ψ s t,
    spinorDensityEntryBilinear.coeFn_holder (r := 1) (ψ s) (ψ t)] with x hx hholder
  rw [hx, hholder]
  rfl

/--
The exact representative-safe density-entry difference decomposition.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-033`.

It is the `L¹` counterpart of `spinorOuterProduct_sub`, with both cross terms constructed by
Mathlib's continuous Hölder lift.
-/
lemma continuumSpinorDensityEntry_sub_eq {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ φ : ContinuumSpinor α μ) (s t : Fin 2) :
    continuumSpinorDensityEntry ψ s t - continuumSpinorDensityEntry φ s t =
      spinorDensityEntryBilinear.holder 1 (ψ s - φ s) (ψ t) +
        spinorDensityEntryBilinear.holder 1 (φ s) (ψ t - φ t) := by
  simp only [continuumSpinorDensityEntry_eq_holder]
  let H := spinorDensityEntryBilinear.holderL μ 2 2 1
  change H (ψ s) (ψ t) - H (φ s) (φ t) =
    H (ψ s - φ s) (ψ t) + H (φ s) (ψ t - φ t)
  rw [map_sub, map_sub]
  simp only [sub_apply]
  abel

/--
A representative-safe `L¹` error bound for one spin-density matrix entry:

`‖ψₛ conj(ψₜ) - φₛ conj(φₜ)‖₁ ≤ ‖ψₛ - φₛ‖₂ ‖ψₜ‖₂ + ‖φₛ‖₂ ‖ψₜ - φₜ‖₂`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-034`.

This theorem is an explicit stability statement, not a basis-convergence claim. A concrete finite
basis still requires separate approximation or projection hypotheses proving `L²` orbital error.
-/
lemma norm_continuumSpinorDensityEntry_sub_le {α : Type*} [MeasurableSpace α]
    {μ : Measure α} (ψ φ : ContinuumSpinor α μ) (s t : Fin 2) :
    ‖continuumSpinorDensityEntry ψ s t - continuumSpinorDensityEntry φ s t‖ ≤
      ‖ψ s - φ s‖ * ‖ψ t‖ + ‖φ s‖ * ‖ψ t - φ t‖ := by
  rw [continuumSpinorDensityEntry_sub_eq]
  calc
    _ ≤ ‖spinorDensityEntryBilinear.holder 1 (ψ s - φ s) (ψ t)‖ +
        ‖spinorDensityEntryBilinear.holder 1 (φ s) (ψ t - φ t)‖ := norm_add_le _ _
    _ ≤ (‖spinorDensityEntryBilinear‖ * ‖ψ s - φ s‖ * ‖ψ t‖) +
        (‖spinorDensityEntryBilinear‖ * ‖φ s‖ * ‖ψ t - φ t‖) :=
      add_le_add
        (ContinuousLinearMap.norm_holder_apply_apply_le spinorDensityEntryBilinear _ _)
        (ContinuousLinearMap.norm_holder_apply_apply_le spinorDensityEntryBilinear _ _)
    _ = _ := by
      rw [spinorDensityEntryBilinear_norm]
      ring

/--
The diagonal density-entry stability estimate in the standard quadratic-map form:

`‖|ψₛ|² - |φₛ|²‖₁ ≤ (‖ψₛ‖₂ + ‖φₛ‖₂) ‖ψₛ - φₛ‖₂`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-035`.

This is the componentwise form of the usual orbital-density estimate. It still transfers only a
supplied `L²` orbital error and does not establish convergence of any particular basis.
-/
lemma norm_continuumSpinorDensityEntry_diagonal_sub_le
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ψ φ : ContinuumSpinor α μ) (s : Fin 2) :
    ‖continuumSpinorDensityEntry ψ s s - continuumSpinorDensityEntry φ s s‖ ≤
      (‖ψ s‖ + ‖φ s‖) * ‖ψ s - φ s‖ := by
  calc
    _ ≤ ‖ψ s - φ s‖ * ‖ψ s‖ + ‖φ s‖ * ‖ψ s - φ s‖ :=
      norm_continuumSpinorDensityEntry_sub_le ψ φ s s
    _ = _ := by
      ring

/--
The fixed-matrix lift preserves subtraction.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-036`.
-/
lemma continuumConstantMatrixMul_sub
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (A : Matrix (Fin 2) (Fin 2) ℂ) (f g : Lp ℂ 1 μ) :
    continuumConstantMatrixMul A f - continuumConstantMatrixMul A g =
      continuumConstantMatrixMul A (f - g) := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumConstantMatrixMul_apply_ae A f,
    continuumConstantMatrixMul_apply_ae A g,
    continuumConstantMatrixMul_apply_ae A (f - g),
    Lp.coeFn_sub f g,
    Lp.coeFn_sub (continuumConstantMatrixMul A f) (continuumConstantMatrixMul A g)]
      with x hf hg hfg hsub hout
  rw [hout, Pi.sub_apply, hf, hg, hfg, hsub, Pi.sub_apply]
  module

/--
The fixed-matrix lift has the expected `L¹` operator-norm bound.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-037`.
-/
lemma norm_continuumConstantMatrixMul_le
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (A : Matrix (Fin 2) (Fin 2) ℂ) (f : Lp ℂ 1 μ) :
    ‖continuumConstantMatrixMul A f‖ ≤ ‖A‖ * ‖f‖ := by
  unfold continuumConstantMatrixMul
  calc
    _ ≤ ‖ContinuousLinearMap.toSpanSingleton ℂ A‖ * ‖f‖ :=
      ContinuousLinearMap.norm_compLp_le _ _
    _ = _ := by rw [ContinuousLinearMap.norm_toSpanSingleton]

/--
The difference of two spinor density matrices is the finite matrix-unit lift of their entrywise
`L¹` differences.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-038`.
-/
lemma continuumSpinorDensityMatrix_sub_eq
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ψ φ : ContinuumSpinor α μ) :
    continuumSpinorDensityMatrix ψ - continuumSpinorDensityMatrix φ =
      ∑ s : Fin 2, ∑ t : Fin 2,
        continuumConstantMatrixMul (Matrix.single s t (1 : ℂ))
          (continuumSpinorDensityEntry ψ s t - continuumSpinorDensityEntry φ s t) := by
  unfold continuumSpinorDensityMatrix
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro s _
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro t _
  exact continuumConstantMatrixMul_sub _ _ _

/--
An explicit matrix-valued `L¹` stability bound for the full continuum spinor density matrix.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-039`.

The finite matrix-unit norms make the aggregation constant explicit without assuming a different
matrix norm. The orbital factors are exactly the componentwise Hölder bounds from `LEM-034`.
-/
lemma norm_continuumSpinorDensityMatrix_sub_le
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (ψ φ : ContinuumSpinor α μ) :
    ‖continuumSpinorDensityMatrix ψ - continuumSpinorDensityMatrix φ‖ ≤
      ∑ s : Fin 2, ∑ t : Fin 2,
        ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
          (‖ψ s - φ s‖ * ‖ψ t‖ + ‖φ s‖ * ‖ψ t - φ t‖) := by
  rw [continuumSpinorDensityMatrix_sub_eq]
  calc
    _ ≤ ∑ s : Fin 2, ‖∑ t : Fin 2,
        continuumConstantMatrixMul (Matrix.single s t (1 : ℂ))
          (continuumSpinorDensityEntry ψ s t - continuumSpinorDensityEntry φ s t)‖ :=
      norm_sum_le _ _
    _ ≤ ∑ s : Fin 2, ∑ t : Fin 2,
        ‖continuumConstantMatrixMul (Matrix.single s t (1 : ℂ))
          (continuumSpinorDensityEntry ψ s t - continuumSpinorDensityEntry φ s t)‖ := by
      apply Finset.sum_le_sum
      intro s _
      exact norm_sum_le _ _
    _ ≤ ∑ s : Fin 2, ∑ t : Fin 2,
        ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
          ‖continuumSpinorDensityEntry ψ s t - continuumSpinorDensityEntry φ s t‖ := by
      apply Finset.sum_le_sum
      intro s _
      apply Finset.sum_le_sum
      intro t _
      exact norm_continuumConstantMatrixMul_le _ _
    _ ≤ _ := by
      apply Finset.sum_le_sum
      intro s _
      apply Finset.sum_le_sum
      intro t _
      exact mul_le_mul_of_nonneg_left
        (norm_continuumSpinorDensityEntry_sub_le ψ φ s t) (norm_nonneg _)

/--
A finite occupation-weighted full-matrix density error bound.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-040`.

The occupations are fixed on both sides and enter through their absolute values. This transfers
supplied orbital `L²` errors but does not assert how those errors were obtained.
-/
lemma norm_continuumOccupationWeightedSpinDensityMatrix_sub_le
    {Orbital α : Type*} [Fintype Orbital] [MeasurableSpace α] {μ : Measure α}
    (orbitals approximations : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) :
    ‖continuumOccupationWeightedSpinDensityMatrix orbitals occupation -
        continuumOccupationWeightedSpinDensityMatrix approximations occupation‖ ≤
      ∑ i : Orbital, |occupation i| *
        (∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (‖orbitals i s - approximations i s‖ * ‖orbitals i t‖ +
              ‖approximations i s‖ * ‖orbitals i t - approximations i t‖)) := by
  unfold continuumOccupationWeightedSpinDensityMatrix
  rw [← Finset.sum_sub_distrib]
  calc
    _ ≤ ∑ i : Orbital,
        ‖(occupation i : ℂ) • continuumSpinorDensityMatrix (orbitals i) -
          (occupation i : ℂ) • continuumSpinorDensityMatrix (approximations i)‖ :=
      norm_sum_le _ _
    _ = ∑ i : Orbital, |occupation i| *
        ‖continuumSpinorDensityMatrix (orbitals i) -
          continuumSpinorDensityMatrix (approximations i)‖ := by
      apply Finset.sum_congr rfl
      intro i _
      rw [← smul_sub, norm_smul, Complex.norm_real, Real.norm_eq_abs]
    _ ≤ _ := by
      apply Finset.sum_le_sum
      intro i _
      exact mul_le_mul_of_nonneg_left
        (norm_continuumSpinorDensityMatrix_sub_le (orbitals i) (approximations i))
        (abs_nonneg _)

/--
The fixed-matrix `L¹` lift is continuous.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-041`.
-/
lemma continuumConstantMatrixMul_continuous
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (A : Matrix (Fin 2) (Fin 2) ℂ) :
    Continuous (continuumConstantMatrixMul (α := α) (μ := μ) A) := by
  unfold continuumConstantMatrixMul
  exact (ContinuousLinearMap.toSpanSingleton ℂ A).lipschitzWith.continuous_compLp
    (map_zero (ContinuousLinearMap.toSpanSingleton ℂ A))

/--
Each continuum spinor density entry depends continuously on the two-component `L²` spinor.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-042`.
-/
lemma continuumSpinorDensityEntry_continuous
    {α : Type*} [MeasurableSpace α] {μ : Measure α} (s t : Fin 2) :
    Continuous (fun ψ : ContinuumSpinor α μ => continuumSpinorDensityEntry ψ s t) := by
  simp only [continuumSpinorDensityEntry_eq_holder]
  let H := spinorDensityEntryBilinear.holderL μ 2 2 1
  change Continuous (fun ψ : ContinuumSpinor α μ => H (ψ s) (ψ t))
  exact H.continuous₂.comp₂ (continuous_apply s) (continuous_apply t)

/--
The full matrix-valued continuum spinor-density construction is continuous from the finite product
of component `L²` spaces to matrix-valued `L¹`.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-043`.
-/
lemma continuumSpinorDensityMatrix_continuous
    {α : Type*} [MeasurableSpace α] {μ : Measure α} :
    Continuous (continuumSpinorDensityMatrix (α := α) (μ := μ)) := by
  unfold continuumSpinorDensityMatrix
  apply continuous_finsetSum Finset.univ
  intro s _
  apply continuous_finsetSum Finset.univ
  intro t _
  exact (continuumConstantMatrixMul_continuous (Matrix.single s t (1 : ℂ))).comp
    (continuumSpinorDensityEntry_continuous s t)

/--
For fixed occupations, the finite occupation-weighted continuum spin-density construction is
continuous in the orbital family.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-044`.
-/
lemma continuumOccupationWeightedSpinDensityMatrix_continuous
    {Orbital α : Type*} [Fintype Orbital] [MeasurableSpace α]
    {μ : Measure α} (occupation : Orbital → ℝ) :
    Continuous (fun orbitals : Orbital → ContinuumSpinor α μ =>
      continuumOccupationWeightedSpinDensityMatrix orbitals occupation) := by
  unfold continuumOccupationWeightedSpinDensityMatrix
  apply continuous_finsetSum Finset.univ
  intro i _
  exact ((continuumSpinorDensityMatrix_continuous (α := α) (μ := μ)).comp
    (continuous_apply i)).const_smul (occupation i : ℂ)

/--
Componentwise `L²` convergence of a finite orbital family implies matrix-valued `L¹` convergence of
the corresponding fixed-occupation spin density.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-045`.

This is conditional transfer of convergence: the hypotheses must be proved separately for any
concrete finite basis, projection, or reconstruction scheme.
-/
lemma continuumOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise
    {Orbital α β : Type*} [Fintype Orbital] [MeasurableSpace α]
    {μ : Measure α} {l : Filter β}
    (approximations : β → Orbital → ContinuumSpinor α μ)
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ)
    (h : ∀ i s, Tendsto (fun b => approximations b i s) l (𝓝 (orbitals i s))) :
    Tendsto (fun b => continuumOccupationWeightedSpinDensityMatrix (approximations b) occupation)
      l (𝓝 (continuumOccupationWeightedSpinDensityMatrix orbitals occupation)) := by
  apply (continuumOccupationWeightedSpinDensityMatrix_continuous occupation).continuousAt.tendsto.comp
  exact tendsto_pi_nhds.mpr fun i => tendsto_pi_nhds.mpr (h i)

/--
The particle-trace map from matrix-valued `L¹` spin densities to scalar complex `L¹` is continuous.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-046`.
-/
lemma continuumParticleDensity_continuous
    {α : Type*} [MeasurableSpace α] {μ : Measure α} :
    Continuous (continuumParticleDensity (α := α) (μ := μ)) := by
  unfold continuumParticleDensity
  let L := (Matrix.traceLinearMap (Fin 2) ℂ ℂ).toContinuousLinearMap
  exact L.lipschitzWith.continuous_compLp (map_zero L)

/--
Each Pauli magnetization map from matrix-valued `L¹` spin densities to scalar complex `L¹` is
continuous.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-047`.
-/
lemma continuumMagnetizationDensity_continuous
    {α : Type*} [MeasurableSpace α] {μ : Measure α} (a : Fin 3) :
    Continuous (fun ρ : ContinuumSpinDensityMatrix α μ => continuumMagnetizationDensity ρ a) := by
  unfold continuumMagnetizationDensity
  let L := (Matrix.traceLinearMap (Fin 2) ℂ ℂ).toContinuousLinearMap.comp
    ((ContinuousLinearMap.mulLeftRight ℂ (Matrix (Fin 2) (Fin 2) ℂ))
      (spinPauliVector a) 1)
  exact L.lipschitzWith.continuous_compLp (map_zero L)

/--
Componentwise `L²` convergence of a finite orbital family implies `L¹` convergence of its
fixed-occupation particle density.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-048`.
-/
lemma continuumOccupationWeightedParticleDensity_tendsto_of_componentwise
    {Orbital α β : Type*} [Fintype Orbital] [MeasurableSpace α]
    {μ : Measure α} {l : Filter β}
    (approximations : β → Orbital → ContinuumSpinor α μ)
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ)
    (h : ∀ i s, Tendsto (fun b => approximations b i s) l (𝓝 (orbitals i s))) :
    Tendsto (fun b => continuumParticleDensity
      (continuumOccupationWeightedSpinDensityMatrix (approximations b) occupation)) l
      (𝓝 (continuumParticleDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation))) :=
  continuumParticleDensity_continuous.continuousAt.tendsto.comp
    (continuumOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise
      approximations orbitals occupation h)

/--
Componentwise `L²` convergence of a finite orbital family implies `L¹` convergence of every
fixed-occupation Pauli magnetization component.

Project Koios declaration ID: `QM-SPIN-DENSITY-CONTINUUM-LEM-049`.
-/
lemma continuumOccupationWeightedMagnetizationDensity_tendsto_of_componentwise
    {Orbital α β : Type*} [Fintype Orbital] [MeasurableSpace α]
    {μ : Measure α} {l : Filter β}
    (approximations : β → Orbital → ContinuumSpinor α μ)
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ)
    (h : ∀ i s, Tendsto (fun b => approximations b i s) l (𝓝 (orbitals i s)))
    (a : Fin 3) :
    Tendsto (fun b => continuumMagnetizationDensity
      (continuumOccupationWeightedSpinDensityMatrix (approximations b) occupation) a) l
      (𝓝 (continuumMagnetizationDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) a)) :=
  (continuumMagnetizationDensity_continuous a).continuousAt.tendsto.comp
    (continuumOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise
      approximations orbitals occupation h)

end ProjectKoios.QuantumMechanics.SpinDensity

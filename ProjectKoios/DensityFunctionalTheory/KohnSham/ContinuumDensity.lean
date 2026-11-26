/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.KohnSham.OccupiedOrbitals
public import Physlib.QuantumMechanics.HilbertSpaces.SpaceD.Basic
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm

/-!
# Representative-safe continuum orbital densities

This module binds Physlib's continuum single-particle Hilbert space to the scalar Project Koios
Kohn--Sham density and variational interfaces. A wavefunction in `SpaceDHilbertSpace d μ` is an
`L²` equivalence class, so its density is defined as an `L¹` equivalence class rather than as a
chosen pointwise function.

For an orbital `ψ`, `continuumOrbitalDensity ψ` is the `L¹` class represented almost everywhere by
`x ↦ ‖ψ x‖²`. Finite occupied and occupation-weighted densities are sums in `L¹`. The almost-
everywhere comparison lemmas connect these canonical continuum objects to the source-neutral
pointwise `FiniteOrbitalFamily` API.

## Proof schematic

```mermaid
flowchart LR
    orbital["Physlib L² orbital ψ"]
    square["integrable representative ‖ψ·‖²"]
    density["DFT-KS-CONTINUUM-DEF-002<br/>L¹ orbital density"]
    finite["finite L¹ orbital sum"]
    pointwise["FiniteOrbitalFamily density<br/>almost everywhere"]
    model["abstract HK / Levy--Lieb<br/>variational model"]

    orbital --> square
    square --> density
    density --> finite
    finite --> pointwise
    finite --> model
```

## Boundaries

- Equality of continuum densities is equality modulo `μ`-almost-everywhere equality.
- The coercion of an `L²` class supplies a measurable representative only for stating
  almost-everywhere comparison lemmas; no pointwise representative-independent value is claimed.
- Occupation nonnegativity is an explicit hypothesis.
- Orbital normalization and occupation sums remain explicit hypotheses. The particle-number
  identities below derive their conclusions only from those supplied conditions.
- This module does not assert orbital orthogonality, many-electron representability, or existence
  of a continuum Kohn--Sham minimizer.
- `continuumOrbitalVariationalModel` is a thin binding to the existing abstract scalar
  Hohenberg--Kohn and Levy--Lieb interfaces. It does not add physical Hamiltonian or energy claims.
-/

open scoped BigOperators

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.KohnSham

open MeasureTheory
open _root_.QuantumMechanics

/-! ## A. Single-orbital density -/

/-- The representative-safe continuum density carrier: real `L¹` classes on `Space d`.

Project Koios ID: `DFT-KS-CONTINUUM-DEF-001`. -/
noncomputable abbrev ContinuumDensity (d : ℕ) (μ : Measure (Space d) := volume) :=
  Lp ℝ 1 μ

/-- The `L¹` density class represented by the squared norm of one `L²` orbital.

Project Koios ID: `DFT-KS-CONTINUUM-DEF-002`. -/
noncomputable def continuumOrbitalDensity {d : ℕ} {μ : Measure (Space d)}
    (ψ : SpaceDHilbertSpace d μ) : ContinuumDensity d μ := by
  have hintegrable : Integrable (fun x => ‖ψ x‖ ^ 2) μ :=
    (Lp.memLp ψ).integrable_norm_pow (by norm_num)
  exact hintegrable.toL1 (fun x => ‖ψ x‖ ^ 2)

/-- The continuum orbital density is represented almost everywhere by `x ↦ ‖ψ x‖²`.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-001`. -/
lemma continuumOrbitalDensity_apply_ae {d : ℕ} {μ : Measure (Space d)}
    (ψ : SpaceDHilbertSpace d μ) :
    continuumOrbitalDensity ψ =ᵐ[μ] fun x => ‖ψ x‖ ^ 2 := by
  unfold continuumOrbitalDensity
  exact Integrable.coeFn_toL1 _

/-- A continuum orbital density is nonnegative almost everywhere.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-002`. -/
lemma continuumOrbitalDensity_nonneg_ae {d : ℕ} {μ : Measure (Space d)}
    (ψ : SpaceDHilbertSpace d μ) :
    ∀ᵐ x ∂μ, 0 ≤ continuumOrbitalDensity ψ x := by
  filter_upwards [continuumOrbitalDensity_apply_ae ψ] with x hx
  rw [hx]
  positivity

/-- Multiplication of an orbital by a unit-norm complex phase does not change its continuum
density.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-003`. -/
lemma continuumOrbitalDensity_phase {d : ℕ} {μ : Measure (Space d)}
    (ψ : SpaceDHilbertSpace d μ) (c : ℂ) (hc : ‖c‖ = 1) :
    continuumOrbitalDensity (c • ψ) = continuumOrbitalDensity ψ := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumOrbitalDensity_apply_ae (c • ψ),
    continuumOrbitalDensity_apply_ae ψ, Lp.coeFn_smul c ψ] with x hleft hright hsmul
  rw [hleft, hright, hsmul, Pi.smul_apply, norm_smul, hc, one_mul]

/-! ## B. Finite orbital families -/

/-- The representative-safe occupation-weighted sum of finitely many continuum orbital densities.

Project Koios ID: `DFT-KS-CONTINUUM-DEF-003`. -/
noncomputable def continuumOccupationWeightedDensity {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ)
    (occupation : Orbital → ℝ) : ContinuumDensity d μ :=
  ∑ i, occupation i • continuumOrbitalDensity (orbitals i)

/-- The representative-safe unit-occupation sum of finitely many continuum orbital densities.

Project Koios ID: `DFT-KS-CONTINUUM-DEF-004`. -/
noncomputable def continuumOccupiedDensity {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ) :
    ContinuumDensity d μ :=
  ∑ i, continuumOrbitalDensity (orbitals i)

/-- The occupation-weighted `L¹` density has the expected finite-sum representative almost
everywhere.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-004`. -/
lemma continuumOccupationWeightedDensity_apply_ae {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ)
    (occupation : Orbital → ℝ) :
    continuumOccupationWeightedDensity orbitals occupation =ᵐ[μ]
      fun x => ∑ i, occupation i * ‖orbitals i x‖ ^ 2 := by
  unfold continuumOccupationWeightedDensity
  refine (Lp.coeFn_finsetSum Finset.univ
    (fun i => occupation i • continuumOrbitalDensity (orbitals i))).trans ?_
  refine (eventuallyEq_sum (s := Finset.univ) fun i _ =>
    (Lp.coeFn_smul (occupation i) (continuumOrbitalDensity (orbitals i))).trans
      ((continuumOrbitalDensity_apply_ae (orbitals i)).fun_comp
        (fun y => occupation i * y))).trans ?_
  exact Filter.Eventually.of_forall fun x => by simp [Function.comp_apply]

/-- The unit-occupation `L¹` density has the expected finite-sum representative almost everywhere.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-005`. -/
lemma continuumOccupiedDensity_apply_ae {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ) :
    continuumOccupiedDensity orbitals =ᵐ[μ]
      fun x => ∑ i, ‖orbitals i x‖ ^ 2 := by
  unfold continuumOccupiedDensity
  refine (Lp.coeFn_finsetSum Finset.univ
    (fun i => continuumOrbitalDensity (orbitals i))).trans ?_
  refine (eventuallyEq_sum (s := Finset.univ) fun i _ =>
    continuumOrbitalDensity_apply_ae (orbitals i)).trans ?_
  exact Filter.Eventually.of_forall fun x => by simp

/-- Nonnegative occupations give a nonnegative continuum density almost everywhere.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-006`. -/
lemma continuumOccupationWeightedDensity_nonneg_ae {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ)
    (occupation : Orbital → ℝ) (hoccupation : ∀ i, 0 ≤ occupation i) :
    ∀ᵐ x ∂μ, 0 ≤ continuumOccupationWeightedDensity orbitals occupation x := by
  filter_upwards [continuumOccupationWeightedDensity_apply_ae orbitals occupation] with x hx
  rw [hx]
  exact Finset.sum_nonneg fun i _ => mul_nonneg (hoccupation i) (sq_nonneg _)

/-- The unit-occupation continuum density is nonnegative almost everywhere.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-007`. -/
lemma continuumOccupiedDensity_nonneg_ae {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ) :
    ∀ᵐ x ∂μ, 0 ≤ continuumOccupiedDensity orbitals x := by
  filter_upwards [continuumOccupiedDensity_apply_ae orbitals] with x hx
  rw [hx]
  exact Finset.sum_nonneg fun _ _ => sq_nonneg _

/-- Unit occupations recover the unweighted occupied density.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-008`. -/
lemma continuumOccupationWeightedDensity_one {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ) :
    continuumOccupationWeightedDensity orbitals (fun _ => 1) =
      continuumOccupiedDensity orbitals := by
  simp [continuumOccupationWeightedDensity, continuumOccupiedDensity]

/-- Zero occupations give the zero continuum density.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-009`. -/
lemma continuumOccupationWeightedDensity_zero {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ) :
    continuumOccupationWeightedDensity orbitals (fun _ => 0) = 0 := by
  simp [continuumOccupationWeightedDensity]

/-- Continuum occupation-weighted density is additive in the occupation weights.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-010`. -/
lemma continuumOccupationWeightedDensity_add {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ)
    (occupation₁ occupation₂ : Orbital → ℝ) :
    continuumOccupationWeightedDensity orbitals (occupation₁ + occupation₂) =
      continuumOccupationWeightedDensity orbitals occupation₁ +
        continuumOccupationWeightedDensity orbitals occupation₂ := by
  simp only [continuumOccupationWeightedDensity, Pi.add_apply, add_smul,
    Finset.sum_add_distrib]

/-- The integral of the squared-norm representative of an `L²` orbital is its Hilbert-space norm
squared.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-011`. -/
lemma integral_sq_norm_eq_norm_sq {d : ℕ} {μ : Measure (Space d)}
    (ψ : SpaceDHilbertSpace d μ) :
    (∫ x, ‖ψ x‖ ^ 2 ∂μ) = ‖ψ‖ ^ 2 := by
  rw [Lp.norm_def, toReal_eLpNorm,
    lpNorm_eq_integral_norm_rpow_toReal (by norm_num) (by norm_num)
      (Lp.aestronglyMeasurable ψ)]
  simp only [ENNReal.toReal_ofNat]
  have hnonneg : 0 ≤ ∫ x, ‖ψ x‖ ^ 2 ∂μ := integral_nonneg fun _ => sq_nonneg _
  rw [show (2 : ℝ)⁻¹ = (1 / 2 : ℝ) by norm_num, ← Real.sqrt_eq_rpow]
  simpa [Real.rpow_natCast] using (Real.sq_sqrt hnonneg).symm

/-- The integral of one representative-safe continuum orbital density is the orbital norm squared.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-012`. -/
lemma continuumOrbitalDensity_integral {d : ℕ} {μ : Measure (Space d)}
    (ψ : SpaceDHilbertSpace d μ) :
    L1.integral (continuumOrbitalDensity ψ) = ‖ψ‖ ^ 2 := by
  rw [L1.integral_eq_integral]
  calc
    (∫ x, continuumOrbitalDensity ψ x ∂μ) = ∫ x, ‖ψ x‖ ^ 2 ∂μ :=
      integral_congr_ae (continuumOrbitalDensity_apply_ae ψ)
    _ = ‖ψ‖ ^ 2 := integral_sq_norm_eq_norm_sq ψ

/-- The integral of a weighted continuum density is the finite sum of each occupation times the
corresponding orbital norm squared.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-013`. -/
lemma continuumOccupationWeightedDensity_integral {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ)
    (occupation : Orbital → ℝ) :
    L1.integral (continuumOccupationWeightedDensity orbitals occupation) =
      ∑ i, occupation i * ‖orbitals i‖ ^ 2 := by
  rw [continuumOccupationWeightedDensity, L1.integral_eq, map_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [map_smul]
  simp only [smul_eq_mul]
  rw [← L1.integral_eq, continuumOrbitalDensity_integral]

/-- For normalized orbitals, the integral of the weighted continuum density is the sum of the
supplied occupations.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-014`. -/
lemma continuumOccupationWeightedDensity_integral_of_normalized
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → SpaceDHilbertSpace d μ) (occupation : Orbital → ℝ)
    (hnorm : ∀ i, ‖orbitals i‖ = 1) :
    L1.integral (continuumOccupationWeightedDensity orbitals occupation) =
      ∑ i, occupation i := by
  rw [continuumOccupationWeightedDensity_integral]
  apply Finset.sum_congr rfl
  intro i _
  rw [hnorm i]
  norm_num

/-- For normalized orbitals with unit occupations, the integral of the occupied density is the
cardinality of the supplied finite orbital index.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-015`. -/
lemma continuumOccupiedDensity_integral_of_normalized
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → SpaceDHilbertSpace d μ) (hnorm : ∀ i, ‖orbitals i‖ = 1) :
    L1.integral (continuumOccupiedDensity orbitals) = Fintype.card Orbital := by
  rw [← continuumOccupationWeightedDensity_one,
    continuumOccupationWeightedDensity_integral_of_normalized orbitals (fun _ => 1) hnorm]
  simp

/-! ## C. Pointwise Kohn--Sham and variational bindings -/

/-- The pointwise `FiniteOrbitalFamily` obtained from the measurable representatives carried by a
finite family of `L²` orbitals.

This construction is used only beneath almost-everywhere comparison statements.

Project Koios ID: `DFT-KS-CONTINUUM-DEF-005`. -/
noncomputable def continuumAmplitudeFamily {Orbital : Type*} {d : ℕ}
    {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ) :
    FiniteOrbitalFamily Orbital (Space d) where
  amplitude i x := orbitals i x

/-- The representative-safe weighted density agrees almost everywhere with the source-neutral
pointwise weighted-density formula.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-016`. -/
lemma continuumOccupationWeightedDensity_eq_pointwise_ae
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → SpaceDHilbertSpace d μ) (occupation : Orbital → ℝ) :
    continuumOccupationWeightedDensity orbitals occupation =ᵐ[μ]
      (continuumAmplitudeFamily orbitals).occupationWeightedDensity occupation := by
  refine (continuumOccupationWeightedDensity_apply_ae orbitals occupation).trans ?_
  exact Filter.Eventually.of_forall fun x => by
    simp [FiniteOrbitalFamily.occupationWeightedDensity,
      FiniteOrbitalFamily.orbitalDensity, continuumAmplitudeFamily,
      Complex.normSq_eq_norm_sq]

/-- The representative-safe occupied density agrees almost everywhere with the source-neutral
pointwise occupied-density formula.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-017`. -/
lemma continuumOccupiedDensity_eq_pointwise_ae {Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)} (orbitals : Orbital → SpaceDHilbertSpace d μ) :
    continuumOccupiedDensity orbitals =ᵐ[μ]
      (continuumAmplitudeFamily orbitals).occupiedDensity := by
  refine (continuumOccupiedDensity_apply_ae orbitals).trans ?_
  exact Filter.Eventually.of_forall fun x => by
    simp [FiniteOrbitalFamily.occupiedDensity, FiniteOrbitalFamily.orbitalDensity,
      continuumAmplitudeFamily, Complex.normSq_eq_norm_sq]

/-- Thin binding from a supplied state-to-orbitals map and supplied energy data to the existing
abstract scalar density variational model.

The density carrier is `ContinuumDensity d μ`, so all Hohenberg--Kohn and Levy--Lieb declarations
apply without replacing their abstract energy assumptions by unproved continuum claims.

Project Koios ID: `DFT-KS-CONTINUUM-DEF-006`. -/
noncomputable def continuumOrbitalVariationalModel
    {State Potential Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)}
    (orbitals : State → Orbital → SpaceDHilbertSpace d μ)
    (occupation : Orbital → ℝ) (internalEnergy : State → ℝ)
    (externalEnergy : Potential → ContinuumDensity d μ → ℝ) :
    ProjectKoios.DensityFunctionalTheory.Foundations.VariationalDensityModel
      State (ContinuumDensity d μ) Potential where
  density state := continuumOccupationWeightedDensity (orbitals state) occupation
  internalEnergy := internalEnergy
  externalEnergy := externalEnergy

/-- The density map of the continuum-bound variational model is exactly the representative-safe
occupation-weighted orbital density.

Project Koios ID: `DFT-KS-CONTINUUM-LEM-018`. -/
@[simp]
lemma continuumOrbitalVariationalModel_density
    {State Potential Orbital : Type*} [Fintype Orbital]
    {d : ℕ} {μ : Measure (Space d)}
    (orbitals : State → Orbital → SpaceDHilbertSpace d μ)
    (occupation : Orbital → ℝ) (internalEnergy : State → ℝ)
    (externalEnergy : Potential → ContinuumDensity d μ → ℝ) (state : State) :
    (continuumOrbitalVariationalModel orbitals occupation internalEnergy externalEnergy).density state =
      continuumOccupationWeightedDensity (orbitals state) occupation :=
  rfl

end ProjectKoios.DensityFunctionalTheory.KohnSham

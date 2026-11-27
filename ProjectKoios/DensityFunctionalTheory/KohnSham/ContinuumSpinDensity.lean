/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumDensity
public import ProjectKoios.QuantumMechanics.SpinDensity.Continuum

/-!
# Continuum spinor particle-density binding

Exact scalar/matrix trace agreement and normalization-dependent particle counts for continuum spinors.

## i. Overview

This module is a thin representative-safe bridge from the continuum spin-density matrix to the
existing real scalar Kohn--Sham density carrier.  A two-component complex `L²` spinor contributes
the real `L¹` particle density

`n(x) = ∑ₛ ‖ψₛ(x)‖²`.

The trace of the spinor outer-product density matrix is exactly the complexification of this scalar
density. The same statement holds for a finite family with supplied real occupation weights. The
module also derives the scalar-density integral and particle-number identities under explicit
normalization hypotheses.

Occupations are arbitrary real numbers unless nonnegativity is explicitly supplied. The module
proves nonnegativity under nonnegative occupations, and particle-number identities under explicit
spinor-normalization and occupation-sum hypotheses; none of those inputs is inferred. Equalities
are equalities of `L¹` classes, with representative formulas stated almost everywhere.

Finite pointwise spinor algebra remains in `FiniteDimensional/SpinorDensityMatrix.lean`. This module
only binds the continuum `L²`/`L¹` carriers. It adds no exchange-correlation functional, effective
potential, self-consistency equation, continuum spin--orbit Hamiltonian, or representability converse.

## ii. Key results

- `complexifyContinuumDensity`: real-to-complex inclusion of the existing scalar `L¹` carrier.
- `continuumSpinorParticleDensity`: sum of the scalar densities of two `L²` components.
- `continuumOccupationWeightedSpinorParticleDensity`: the corresponding finite real-weighted family.
- `continuumSpinorDensityMatrix_particleDensity` and
  `continuumOccupationWeightedSpinDensityMatrix_particleDensity`: exact trace/complexification bridges.
- `continuumOccupationWeightedSpinorParticleDensity_integral`: weighted component-norm-square count.
- `continuumOccupationWeightedSpinorParticleDensity_integral_eq_particleNumber`: particle number
  under independently supplied normalization and occupation sum.

## iii. Table of contents

- A. Scalar-density construction
- B. Trace bridge
- C. Normalization and particle number
- D. Proof schematic

## iv. References

This source-neutral carrier binding reuses `KohnSham/ContinuumDensity.lean`, especially
`continuumOrbitalDensity_apply_ae` and `continuumOrbitalDensity_integral`, together with the
representative-safe matrix/trace maps in `SpinDensity/Continuum.lean`. Pointwise trace calculations
reuse `trace_spinorOuterProduct` and `trace_occupationWeightedSpinorDensityMatrix`. Mathlib supplies
`Complex.ofRealCLM.compLp`, almost-everywhere `Lp` sum/scalar identities, and linearity of
`L1.integral`. No new publication crosswalk or normalization convention is introduced.

## D. Proof schematic

```mermaid
flowchart TD
    spinors["supplied L2 spinors<br/>finite families and real occupations"] --> scalar["DFT-KS-SPIN-CONTINUUM-DEF-001 to 003<br/>real scalar L1 densities<br/>and complexification"]
    spinors --> matrix["QM-SPIN-DENSITY-CONTINUUM-DEF-012/013<br/>matrix-valued L1 densities<br/>and particle trace"]
    scalar --> bridge["DFT-KS-SPIN-CONTINUUM-LEM-005/006<br/>scalar/matrix trace bridges<br/>via finite trace algebra and a.e. formulas"]
    matrix --> bridge
    scalar --> integral["DFT-KS-SPIN-CONTINUUM-LEM-007/008<br/>component norm-square integrals<br/>via scalar orbital integral identities"]
    integral --> normalized["DFT-KS-SPIN-CONTINUUM-LEM-009<br/>integral equals occupation sum<br/>requires component norm squares<br/>summing to one for each spinor"]
    normalized --> count["DFT-KS-SPIN-CONTINUUM-LEM-010<br/>requested particle number N<br/>requires explicit occupation sum N"]
```
-/

open scoped BigOperators ComplexConjugate Matrix Matrix.Norms.L2Operator

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.KohnSham

open MeasureTheory
open _root_.QuantumMechanics
open ProjectKoios.QuantumMechanics.SpinDensity
open ProjectKoios.QuantumMechanics.FiniteDimensional

/-! ## A. Scalar-density construction -/

/--
Complexify a real representative-safe continuum density.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-DEF-001`.
-/
noncomputable def complexifyContinuumDensity {d : ℕ} {μ : Measure (Space d)}
    (n : ContinuumDensity d μ) : Lp ℂ 1 μ :=
  Complex.ofRealCLM.compLp n

/--
Complexification agrees almost everywhere with the pointwise real-to-complex inclusion.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-001`.
-/
lemma complexifyContinuumDensity_apply_ae {d : ℕ} {μ : Measure (Space d)}
    (n : ContinuumDensity d μ) :
    complexifyContinuumDensity n =ᵐ[μ] fun x => (n x : ℂ) := by
  exact Complex.ofRealCLM.coeFn_compLp n

/--
The real particle density of one two-component continuum spinor.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-DEF-002`.
-/
noncomputable def continuumSpinorParticleDensity {d : ℕ} {μ : Measure (Space d)}
    (ψ : ContinuumSpinor (Space d) μ) : ContinuumDensity d μ :=
  ∑ s : Fin 2, continuumOrbitalDensity (ψ s)

/--
The spinor particle density is represented almost everywhere by the sum of component norm squares.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-002`.
-/
lemma continuumSpinorParticleDensity_apply_ae {d : ℕ} {μ : Measure (Space d)}
    (ψ : ContinuumSpinor (Space d) μ) :
    continuumSpinorParticleDensity ψ =ᵐ[μ] fun x => ∑ s : Fin 2, ‖ψ s x‖ ^ 2 := by
  unfold continuumSpinorParticleDensity
  refine (Lp.coeFn_finsetSum Finset.univ
    (fun s : Fin 2 => continuumOrbitalDensity (ψ s))).trans ?_
  refine (eventuallyEq_sum (s := Finset.univ) fun s _ =>
    continuumOrbitalDensity_apply_ae (ψ s)).trans ?_
  exact Filter.Eventually.of_forall fun x => by simp

/--
The real particle density of a finite family of continuum spinors with supplied occupations.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-DEF-003`.
-/
noncomputable def continuumOccupationWeightedSpinorParticleDensity
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ) :
    ContinuumDensity d μ :=
  ∑ i, occupation i • continuumSpinorParticleDensity (orbitals i)

/--
The weighted spinor particle density has the expected finite-sum representative almost everywhere.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-003`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_apply_ae
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ) :
    continuumOccupationWeightedSpinorParticleDensity orbitals occupation =ᵐ[μ]
      fun x => ∑ i, occupation i * ∑ s : Fin 2, ‖orbitals i s x‖ ^ 2 := by
  unfold continuumOccupationWeightedSpinorParticleDensity
  refine (Lp.coeFn_finsetSum Finset.univ
    (fun i => occupation i • continuumSpinorParticleDensity (orbitals i))).trans ?_
  refine (eventuallyEq_sum (s := Finset.univ) fun i _ =>
    (Lp.coeFn_smul (occupation i) (continuumSpinorParticleDensity (orbitals i))).trans
      ((continuumSpinorParticleDensity_apply_ae (orbitals i)).fun_comp
        (fun y => occupation i * y))).trans ?_
  exact Filter.Eventually.of_forall fun x => by simp [Function.comp_apply]

/--
Nonnegative occupations give a nonnegative scalar spinor particle density almost everywhere.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-004`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_nonneg_ae
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (hoccupation : ∀ i, 0 ≤ occupation i) :
    ∀ᵐ x ∂μ, 0 ≤ continuumOccupationWeightedSpinorParticleDensity orbitals occupation x := by
  filter_upwards [continuumOccupationWeightedSpinorParticleDensity_apply_ae orbitals occupation]
    with x hx
  rw [hx]
  exact Finset.sum_nonneg fun i _ => mul_nonneg (hoccupation i)
    (Finset.sum_nonneg fun s _ => sq_nonneg _)

/-! ## B. Trace bridge -/

/--
The particle trace of one spinor density matrix is the complexification of its real scalar density.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-005`.
-/
lemma continuumSpinorDensityMatrix_particleDensity {d : ℕ} {μ : Measure (Space d)}
    (ψ : ContinuumSpinor (Space d) μ) :
    continuumParticleDensity (continuumSpinorDensityMatrix ψ) =
      complexifyContinuumDensity (continuumSpinorParticleDensity ψ) := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumParticleDensity_apply_ae (continuumSpinorDensityMatrix ψ),
    continuumSpinorDensityMatrix_apply_ae ψ,
    complexifyContinuumDensity_apply_ae (continuumSpinorParticleDensity ψ),
    continuumSpinorParticleDensity_apply_ae ψ] with x htrace hmatrix hcomplex hscalar
  rw [htrace, hmatrix, hcomplex, hscalar]
  exact trace_spinorOuterProduct (fun s => ψ s x)

/--
The particle trace of a finite weighted spin-density matrix is the complexification of the
corresponding real scalar Kohn--Sham density.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-006`.
-/
lemma continuumOccupationWeightedSpinDensityMatrix_particleDensity
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ) :
    continuumParticleDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) =
      complexifyContinuumDensity
        (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) := by
  apply Lp.ext (μ := μ)
  filter_upwards [continuumParticleDensity_apply_ae
      (continuumOccupationWeightedSpinDensityMatrix orbitals occupation),
    continuumOccupationWeightedSpinDensityMatrix_apply_ae orbitals occupation,
    complexifyContinuumDensity_apply_ae
      (continuumOccupationWeightedSpinorParticleDensity orbitals occupation),
    continuumOccupationWeightedSpinorParticleDensity_apply_ae orbitals occupation]
      with x htrace hmatrix hcomplex hscalar
  rw [htrace, hmatrix, hcomplex, hscalar]
  exact trace_occupationWeightedSpinorDensityMatrix
    (fun i s => orbitals i s x) occupation

/-! ## C. Normalization and particle number -/

/--
The integral of one continuum spinor particle density is the sum of its component `L²` norm
squares.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-007`.
-/
lemma continuumSpinorParticleDensity_integral {d : ℕ} {μ : Measure (Space d)}
    (ψ : ContinuumSpinor (Space d) μ) :
    L1.integral (continuumSpinorParticleDensity ψ) = ∑ s : Fin 2, ‖ψ s‖ ^ 2 := by
  rw [continuumSpinorParticleDensity, L1.integral_eq, map_sum]
  apply Finset.sum_congr rfl
  intro s _
  rw [← L1.integral_eq, continuumOrbitalDensity_integral]

/--
The integral of a weighted spinor particle density is the weighted sum of component `L²` norm
squares.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-008`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_integral
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) =
      ∑ i, occupation i * ∑ s : Fin 2, ‖orbitals i s‖ ^ 2 := by
  rw [continuumOccupationWeightedSpinorParticleDensity, L1.integral_eq, map_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [map_smul]
  simp only [smul_eq_mul]
  rw [← L1.integral_eq, continuumSpinorParticleDensity_integral]

/--
If each supplied continuum spinor has total component norm one, the total scalar density integral
is the sum of the occupations.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-009`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_integral_of_normalized
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (hnormalized : ∀ i, ∑ s : Fin 2, ‖orbitals i s‖ ^ 2 = 1) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) =
      ∑ i, occupation i := by
  rw [continuumOccupationWeightedSpinorParticleDensity_integral]
  apply Finset.sum_congr rfl
  intro i _
  rw [hnormalized i, mul_one]

/--
Explicit spinor normalization and an explicit occupation sum give the requested particle number.

Project Koios declaration ID: `DFT-KS-SPIN-CONTINUUM-LEM-010`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_integral_eq_particleNumber
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (particleNumber : ℝ)
    (hnormalized : ∀ i, ∑ s : Fin 2, ‖orbitals i s‖ ^ 2 = 1)
    (hoccupation : ∑ i, occupation i = particleNumber) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) =
      particleNumber := by
  rw [continuumOccupationWeightedSpinorParticleDensity_integral_of_normalized
    orbitals occupation hnormalized, hoccupation]

end ProjectKoios.DensityFunctionalTheory.KohnSham

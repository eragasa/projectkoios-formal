/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumSpinDensity
public import ProjectKoios.QuantumMechanics.SpinDensity.OscillatorBasis

/-!
# Finite-basis convergence for scalar Kohn--Sham spinor densities

Real scalar density convergence and exact particle-number truncation deficits.

## i. Overview

This module transfers the representative-safe matrix spin-density convergence results to the
existing real scalar Kohn--Sham particle-density carrier. It uses the exact trace/complexification
bridge from `ContinuumSpinDensity.lean`, followed by the continuous real-part map on complex `L¹`.

The resulting chain is

`finite coefficients → L² spinors → matrix-valued L¹ density → real scalar L¹ density → integral`.

Generic componentwise, countable-Hilbert-basis, and one-dimensional oscillator/Hermite convergence
results are provided. Exact Hilbert-truncation particle-number deficits are also identified with
weighted squared orbital residuals and coefficient tails. Nonnegative occupations imply an integral
upper bound, not pointwise ordering of densities. A supplied summable weighted coefficient moment
also gives explicit integral-deficit rates and cutoff guarantees; that global regularity hypothesis
is not derived from finite coefficients. For the one-dimensional oscillator closure domain,
`OscillatorBasis.lean` now derives the `p=2` moment contract from the actual Hamiltonian image, and
this module obtains an explicit inverse-square particle-number deficit bound. No energy convergence
is inferred. The oscillator basis is only an approximation basis for the supplied orbitals; it is not
asserted to be a Kohn--Sham eigenbasis or a numerical discretization.

## ii. Key results

- `continuumOccupationWeightedSpinorParticleDensity_tendsto_of_componentwise`: real `L¹` transfer.
- `oscillatorSpinorParticleDensity_integral_tendsto_occupationSum`: normalized limiting count.
- `hilbertBasisSpinorParticleDensity_integral_deficit`: exact weighted squared-residual deficit.
- `hilbertBasisSpinorParticleDensity_integral_deficit_eq_tail`: exact coefficient-tail deficit.
- `hilbertBasisSpinorParticleDensity_integral_le`: integral upper bound for nonnegative occupations.
- `oscillatorSpinorParticleDensity_integral_deficit_le_of_hamiltonian_domain`: inverse-square
  particle-number deficit from selected-closure-domain regularity.

## iii. Table of contents

- A. Real-part and convergence transfer
- B. Hilbert-basis and oscillator convergence
- C. Exact truncation deficits
- D. Moment-based deficit rates and cutoff guarantees
- E. Proof schematic

## iv. References

This source-neutral binding reuses `continuumOccupationWeightedSpinorParticleDensity_integral`
and the existing scalar trace bridge, together with the exact Hilbert-projection identities in
`ProjectKoios/QuantumMechanics/SpinDensity/HilbertBasis.lean`. It does not add a publication
crosswalk or assert that oscillator eigenstates are Kohn--Sham eigenstates.

## E. Proof schematic

```mermaid
flowchart TD
    matrix["given component/matrix convergence<br/>or actual Hilbert-basis reconstruction"] --> scalar["DFT-KS-SPIN-BASIS-LEM-001 to 005<br/>trace bridge and continuous real part<br/>give scalar L1 convergence"]
    scalar --> limits["DFT-KS-SPIN-BASIS-LEM-006 to 010<br/>integral convergence and concrete instances<br/>occupation-sum limit requires component norm squares<br/>summing to one for each target spinor"]
    geometry["scalar norm-square integral identities<br/>Hilbert projection Pythagoras and Parseval"] --> tail["DFT-KS-SPIN-BASIS-LEM-011/012/015<br/>exact weighted squared-residual<br/>and coefficient-tail deficits"]
    tail --> order["DFT-KS-SPIN-BASIS-LEM-013/016<br/>integral upper bounds<br/>require nonnegative occupations"]
    tail --> count["DFT-KS-SPIN-BASIS-LEM-014<br/>occupation-sum deficit identity<br/>requires explicit target normalization"]
    moment["supplied positive exponent and<br/>genuinely summable bounded component moments"] --> rate["DFT-KS-SPIN-BASIS-LEM-017/018<br/>inverse-power deficit and sufficient cutoff<br/>require nonnegative occupations"]
    tail --> rate
    domain["actual oscillator closure-domain components<br/>and derived p=2 moment via<br/>QM-SPIN-DENSITY-OSCILLATOR-LEM-005"] --> inverse["DFT-KS-SPIN-BASIS-LEM-019<br/>inverse-square particle-number deficit<br/>nonnegative occupations; actual Hamiltonian-image norms"]
    rate --> inverse
    %% Invisible links constrain layout only, not mathematical dependencies.
    matrix ~~~ geometry
    geometry ~~~ moment
    moment ~~~ domain
    count ~~~ order
```
-/

@[expose] public section

open scoped BigOperators Topology

namespace ProjectKoios.DensityFunctionalTheory.KohnSham

open Filter MeasureTheory
open _root_.QuantumMechanics
open ProjectKoios.QuantumMechanics.SpinDensity
open ProjectKoios.QuantumMechanics.HarmonicOscillator

/-! ## A. Real-part and convergence transfer -/

/--
Take the real part of a complex representative-safe continuum `L¹` density.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-DEF-001`.
-/
noncomputable def realPartContinuumDensity {d : ℕ} {μ : Measure (Space d)}
    (n : Lp ℂ 1 μ) : ContinuumDensity d μ :=
  Complex.reCLM.compLp n

/--
The continuum real-part map agrees almost everywhere with pointwise complex real part.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-001`.
-/
lemma realPartContinuumDensity_apply_ae {d : ℕ} {μ : Measure (Space d)}
    (n : Lp ℂ 1 μ) : realPartContinuumDensity n =ᵐ[μ] fun x => (n x).re := by
  exact Complex.reCLM.coeFn_compLp n

/--
Taking real part after complexifying a real continuum density is the identity.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-002`.
-/
@[simp]
lemma realPart_complexifyContinuumDensity {d : ℕ} {μ : Measure (Space d)}
    (n : ContinuumDensity d μ) :
    realPartContinuumDensity (complexifyContinuumDensity n) = n := by
  apply Lp.ext (μ := μ)
  filter_upwards [realPartContinuumDensity_apply_ae (complexifyContinuumDensity n),
    complexifyContinuumDensity_apply_ae n] with x hre hc
  rw [hre, hc]
  simp

/--
The continuum real-part map is continuous on `L¹`.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-003`.
-/
lemma realPartContinuumDensity_continuous {d : ℕ} {μ : Measure (Space d)} :
    Continuous (realPartContinuumDensity (d := d) (μ := μ)) := by
  unfold realPartContinuumDensity
  exact Complex.reCLM.lipschitzWith.continuous_compLp (map_zero Complex.reCLM)

/--
Matrix-valued spin-density convergence implies convergence of the corresponding real scalar
Kohn--Sham particle densities in `L¹`.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-004`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_tendsto_of_spinDensityMatrix
    {Orbital β : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)} {l : Filter β}
    (approximations : β → Orbital → ContinuumSpinor (Space d) μ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (h : Tendsto (fun b => continuumOccupationWeightedSpinDensityMatrix
      (approximations b) occupation) l
      (𝓝 (continuumOccupationWeightedSpinDensityMatrix orbitals occupation))) :
    Tendsto (fun b => continuumOccupationWeightedSpinorParticleDensity
      (approximations b) occupation) l
      (𝓝 (continuumOccupationWeightedSpinorParticleDensity orbitals occupation)) := by
  have htrace := continuumParticleDensity_continuous.continuousAt.tendsto.comp h
  have hcomplex : Tendsto (fun b => complexifyContinuumDensity
      (continuumOccupationWeightedSpinorParticleDensity (approximations b) occupation)) l
      (𝓝 (complexifyContinuumDensity
        (continuumOccupationWeightedSpinorParticleDensity orbitals occupation))) := by
    convert htrace using 1
    · funext b
      exact (continuumOccupationWeightedSpinDensityMatrix_particleDensity
        (approximations b) occupation).symm
    · exact congrArg 𝓝
        (continuumOccupationWeightedSpinDensityMatrix_particleDensity orbitals occupation).symm
  have hre := realPartContinuumDensity_continuous.continuousAt.tendsto.comp hcomplex
  change Tendsto (fun b => realPartContinuumDensity (complexifyContinuumDensity
      (continuumOccupationWeightedSpinorParticleDensity (approximations b) occupation))) l
    (𝓝 (realPartContinuumDensity (complexifyContinuumDensity
      (continuumOccupationWeightedSpinorParticleDensity orbitals occupation)))) at hre
  simpa using hre

/--
Componentwise orbital `L²` convergence implies real scalar Kohn--Sham particle-density convergence
in `L¹`.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-005`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_tendsto_of_componentwise
    {Orbital β : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)} {l : Filter β}
    (approximations : β → Orbital → ContinuumSpinor (Space d) μ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (h : ∀ i s, Tendsto (fun b => approximations b i s) l (𝓝 (orbitals i s))) :
    Tendsto (fun b => continuumOccupationWeightedSpinorParticleDensity
      (approximations b) occupation) l
      (𝓝 (continuumOccupationWeightedSpinorParticleDensity orbitals occupation)) :=
  continuumOccupationWeightedSpinorParticleDensity_tendsto_of_spinDensityMatrix
    approximations orbitals occupation
    (continuumOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise
      approximations orbitals occupation h)

/--
Matrix-valued spin-density convergence implies convergence of scalar particle-number integrals.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-006`.
-/
lemma continuumOccupationWeightedSpinorParticleDensity_integral_tendsto_of_spinDensityMatrix
    {Orbital β : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)} {l : Filter β}
    (approximations : β → Orbital → ContinuumSpinor (Space d) μ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (h : Tendsto (fun b => continuumOccupationWeightedSpinDensityMatrix
      (approximations b) occupation) l
      (𝓝 (continuumOccupationWeightedSpinDensityMatrix orbitals occupation))) :
    Tendsto (fun b => L1.integral
      (continuumOccupationWeightedSpinorParticleDensity (approximations b) occupation)) l
      (𝓝 (L1.integral
        (continuumOccupationWeightedSpinorParticleDensity orbitals occupation))) := by
  have hs := continuumOccupationWeightedSpinorParticleDensity_tendsto_of_spinDensityMatrix
    approximations orbitals occupation h
  have hi := L1.integralCLM.continuous.continuousAt.tendsto.comp hs
  change Tendsto (fun b => L1.integralCLM
      (continuumOccupationWeightedSpinorParticleDensity (approximations b) occupation)) l
    (𝓝 (L1.integralCLM
      (continuumOccupationWeightedSpinorParticleDensity orbitals occupation))) at hi
  simpa only [← L1.integral_eq] using hi

/-! ## B. Hilbert-basis and oscillator convergence -/

/--
Countable Hilbert-basis partial sums give real scalar Kohn--Sham particle-density convergence in
`L¹`.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-007`.
-/
lemma hilbertBasisSpinorParticleDensity_tendsto
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ))
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumOccupationWeightedSpinorParticleDensity
      ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation)
      atTop (𝓝 (continuumOccupationWeightedSpinorParticleDensity orbitals occupation)) :=
  continuumOccupationWeightedSpinorParticleDensity_tendsto_of_spinDensityMatrix
    (fun n => (hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n))
    orbitals occupation (hilbertBasisSpinDensityMatrix_tendsto basis orbitals occupation)

/--
Oscillator/Hermite partial sums give real scalar Kohn--Sham particle-density convergence in `L¹`.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-008`.
-/
lemma oscillatorSpinorParticleDensity_tendsto
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumOccupationWeightedSpinorParticleDensity
      ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
      occupation) atTop
      (𝓝 (continuumOccupationWeightedSpinorParticleDensity orbitals occupation)) :=
  continuumOccupationWeightedSpinorParticleDensity_tendsto_of_spinDensityMatrix
    (fun n => (oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
    orbitals occupation (oscillatorSpinDensityMatrix_tendsto Q orbitals occupation)

/--
Oscillator/Hermite partial sums give convergence of the scalar particle-number integral.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-009`.
-/
lemma oscillatorSpinorParticleDensity_integral_tendsto
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ) :
    Tendsto (fun n => L1.integral (continuumOccupationWeightedSpinorParticleDensity
      ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
      occupation)) atTop
      (𝓝 (L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation))) :=
  continuumOccupationWeightedSpinorParticleDensity_integral_tendsto_of_spinDensityMatrix
    (fun n => (oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
    orbitals occupation (oscillatorSpinDensityMatrix_tendsto Q orbitals occupation)

/--
For normalized target spinors, oscillator/Hermite partial-sum particle-number integrals converge to
the supplied occupation sum.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-010`.
-/
lemma oscillatorSpinorParticleDensity_integral_tendsto_occupationSum
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ)
    (hnormalized : ∀ i, ∑ s : Fin 2, ‖orbitals i s‖ ^ 2 = 1) :
    Tendsto (fun n => L1.integral (continuumOccupationWeightedSpinorParticleDensity
      ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
      occupation)) atTop (𝓝 (∑ i, occupation i)) := by
  convert oscillatorSpinorParticleDensity_integral_tendsto Q orbitals occupation using 1
  rw [continuumOccupationWeightedSpinorParticleDensity_integral_of_normalized
    orbitals occupation hnormalized]

/-! ## C. Exact truncation deficits -/

/--
The exact loss of particle-number integral under Hilbert truncation is the occupation-weighted sum
of squared component orbital residuals.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-011`.

This is an identity for arbitrary real occupations. Positivity is needed only for order bounds.
-/
lemma hilbertBasisSpinorParticleDensity_integral_deficit
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) -
      L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) =
      ∑ i : Orbital, occupation i * ∑ s : Fin 2,
        ‖orbitals i s - hilbertBasisPartialSumProjection basis n (orbitals i s)‖ ^ 2 := by
  rw [continuumOccupationWeightedSpinorParticleDensity_integral,
    continuumOccupationWeightedSpinorParticleDensity_integral, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro i _
  rw [← mul_sub, ← Finset.sum_sub_distrib]
  congr 1
  apply Finset.sum_congr rfl
  intro s _
  change ‖orbitals i s‖ ^ 2 -
    ‖(hilbertBasisExpansion basis orbitals).reconstructOn (Finset.range n) i s‖ ^ 2 = _
  rw [hilbertBasis_reconstruct_eq_projection,
    hilbertBasisPartialSumProjection_norm_sq_deficit]

/--
The exact Hilbert-truncation particle-number deficit is the weighted discarded coefficient energy.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-012`.

The tail is an infinite series. Bounding it from finite numerical information is a separate task.
-/
lemma hilbertBasisSpinorParticleDensity_integral_deficit_eq_tail
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) -
      L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) =
      ∑ i : Orbital, occupation i * ∑ s : Fin 2,
        hilbertBasisCoefficientTailEnergy basis n (orbitals i s) := by
  rw [hilbertBasisSpinorParticleDensity_integral_deficit]
  simp_rw [hilbertBasisPartialSumProjection_residual_sq_eq_tail]

/--
Nonnegative occupations ensure that a Hilbert-truncated density integral does not exceed the target
integral. This does not assert a pointwise inequality between densities.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-013`.
-/
lemma hilbertBasisSpinorParticleDensity_integral_le
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (hoccupation : ∀ i, 0 ≤ occupation i) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) ≤
      L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) := by
  apply sub_nonneg.mp
  rw [hilbertBasisSpinorParticleDensity_integral_deficit]
  exact Finset.sum_nonneg fun i _ => mul_nonneg (hoccupation i)
    (Finset.sum_nonneg fun s _ => sq_nonneg _)

/--
For normalized target spinors, the deficit from the occupation sum equals the weighted discarded
coefficient energy. Truncated spinors are not assumed normalized or renormalized.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-014`.
-/
lemma hilbertBasisSpinorParticleDensity_occupationSum_deficit_eq_tail
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (hnormalized : ∀ i, ∑ s : Fin 2, ‖orbitals i s‖ ^ 2 = 1) :
    (∑ i, occupation i) -
      L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) =
      ∑ i : Orbital, occupation i * ∑ s : Fin 2,
        hilbertBasisCoefficientTailEnergy basis n (orbitals i s) := by
  rw [← continuumOccupationWeightedSpinorParticleDensity_integral_of_normalized
    orbitals occupation hnormalized]
  exact hilbertBasisSpinorParticleDensity_integral_deficit_eq_tail basis n orbitals occupation

/--
The one-dimensional oscillator/Hermite particle-number deficit equals its discarded coefficient
energy, with no additional completeness premise.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-015`.
-/
lemma oscillatorSpinorParticleDensity_integral_deficit_eq_tail
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) -
      L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
        occupation) =
      ∑ i : Orbital, occupation i * ∑ s : Fin 2,
        hilbertBasisCoefficientTailEnergy (oneDimensionalEigenstateHilbertBasis Q) n
          (orbitals i s) :=
  hilbertBasisSpinorParticleDensity_integral_deficit_eq_tail
    (oneDimensionalEigenstateHilbertBasis Q) n orbitals occupation

/--
For nonnegative occupations, oscillator/Hermite truncation cannot increase the particle-number
integral. No pointwise density ordering or energy convergence is implied.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-016`.
-/
lemma oscillatorSpinorParticleDensity_integral_le
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ)
    (hoccupation : ∀ i, 0 ≤ occupation i) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
        occupation) ≤
      L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) :=
  hilbertBasisSpinorParticleDensity_integral_le
    (oneDimensionalEigenstateHilbertBasis Q) n orbitals occupation hoccupation

/-! ## D. Moment-based deficit rates and cutoff guarantees -/

/--
Nonnegative occupations and global component coefficient-moment bounds give an inverse-power
particle-number deficit rate.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-017`.

The moment budgets and their summability must be established independently; finite retained
coefficients alone do not justify them. The occupations are fixed, and no truncated spinor is
renormalized.
-/
lemma hilbertBasisSpinorParticleDensity_integral_deficit_le_moment_bound
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p : ℝ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (M : Orbital → Fin 2 → ℝ)
    (h : ∀ i s, HasHilbertBasisCoefficientMomentBound basis p (M i s) (orbitals i s))
    (hoccupation : ∀ i, 0 ≤ occupation i) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) -
      L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) ≤
      (∑ i : Orbital, occupation i * ∑ s : Fin 2, M i s) / ((n : ℝ) + 1) ^ p := by
  rw [hilbertBasisSpinorParticleDensity_integral_deficit_eq_tail]
  calc
    _ ≤ ∑ i : Orbital, occupation i * ∑ s : Fin 2, M i s / ((n : ℝ) + 1) ^ p := by
      apply Finset.sum_le_sum
      intro i _
      apply mul_le_mul_of_nonneg_left _ (hoccupation i)
      apply Finset.sum_le_sum
      intro s _
      exact hilbertBasisCoefficientTailEnergy_le_of_moment_bound basis n p _ _ (h i s)
    _ = _ := by simp only [Finset.sum_div, mul_div_assoc]

/--
If the weighted moment budget is at most `ε (n + 1)^p`, the particle-number deficit lies between
zero and the requested tolerance `ε`.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-018`.

This is a sufficient algebraic cutoff condition, not an algorithm choosing the cutoff or a
numerical certificate of the global moment. It asserts no pointwise density ordering.
-/
lemma hilbertBasisSpinorParticleDensity_integral_deficit_le_of_moment_cutoff
    {Orbital : Type*} [Fintype Orbital] {d : ℕ} {μ : Measure (Space d)}
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p ε : ℝ)
    (orbitals : Orbital → ContinuumSpinor (Space d) μ) (occupation : Orbital → ℝ)
    (M : Orbital → Fin 2 → ℝ)
    (h : ∀ i s, HasHilbertBasisCoefficientMomentBound basis p (M i s) (orbitals i s))
    (hoccupation : ∀ i, 0 ≤ occupation i)
    (hcutoff : (∑ i : Orbital, occupation i * ∑ s : Fin 2, M i s) ≤
      ε * ((n : ℝ) + 1) ^ p) :
    0 ≤ L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) -
      L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) ∧
    L1.integral (continuumOccupationWeightedSpinorParticleDensity orbitals occupation) -
      L1.integral (continuumOccupationWeightedSpinorParticleDensity
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) ≤ ε := by
  refine ⟨sub_nonneg.mpr (hilbertBasisSpinorParticleDensity_integral_le
    basis n orbitals occupation hoccupation), ?_⟩
  exact (hilbertBasisSpinorParticleDensity_integral_deficit_le_moment_bound
    basis n p orbitals occupation M h hoccupation).trans
    ((div_le_iff₀ (Real.rpow_pos_of_pos (by positivity) p)).mpr hcutoff)

/--
The selected oscillator Hamiltonian closure domain gives an explicit inverse-square particle-number
deficit bound for nonnegative fixed occupations.

Project Koios declaration ID: `DFT-KS-SPIN-BASIS-LEM-019`.

Every supplied spin component belongs to `Q.hamiltonian.closure.domain`. Its global moment is
derived, not assumed. The bound uses the sum of squared Hamiltonian-image norms, not energy
expectations; no renormalization, pointwise density ordering, energy convergence, or numerical norm
certificate is inferred.
-/
lemma oscillatorSpinorParticleDensity_integral_deficit_le_of_hamiltonian_domain
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Orbital → Fin 2 → Q.hamiltonian.closure.domain) (occupation : Orbital → ℝ)
    (hoccupation : ∀ i, 0 ≤ occupation i) :
    L1.integral (continuumOccupationWeightedSpinorParticleDensity
      (fun i s => (ψ i s : Q.HS)) occupation) -
    L1.integral (continuumOccupationWeightedSpinorParticleDensity
      ((oscillatorSpinorBasisExpansion Q (fun i s => (ψ i s : Q.HS))).reconstructedFamilyOn
        (Finset.range n)) occupation) ≤
      (4 / (((Constants.ℏ : ℝ) * Q.ω 0) ^ 2 * ((n : ℝ) + 1) ^ 2)) *
        ∑ i : Orbital, occupation i * ∑ s : Fin 2, ‖Q.hamiltonian.closure (ψ i s)‖ ^ 2 := by
  have h := hilbertBasisSpinorParticleDensity_integral_deficit_le_moment_bound
    (oneDimensionalEigenstateHilbertBasis Q) n 2 (fun i s => (ψ i s : Q.HS)) occupation
    (fun i s => oneDimensionalHamiltonianMomentBudget Q (ψ i s))
    (fun i s => oscillatorHamiltonianDomain_coefficientMomentBound Q (ψ i s)) hoccupation
  apply h.trans_eq
  simp only [Real.rpow_two, oneDimensionalHamiltonianMomentBudget, Finset.mul_sum, Finset.sum_div]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro s _
  field_simp

end ProjectKoios.DensityFunctionalTheory.KohnSham

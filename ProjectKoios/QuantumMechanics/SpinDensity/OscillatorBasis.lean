/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.HarmonicOscillator.HilbertBasis
public import ProjectKoios.QuantumMechanics.SpinDensity.HilbertBasis

/-!
# One-dimensional oscillator basis for continuum spin densities

Concrete continuum reconstruction and Hamiltonian-domain density-error rates.

## i. Overview

This module binds the proved one-dimensional Cartesian harmonic-oscillator eigenstate Hilbert basis
to the representative-safe continuum spin-density reconstruction layer. The reconstructed spinor
components are the first `n` oscillator/Hermite Hilbert coefficients, and Mathlib Hilbert-basis
convergence yields `L²` orbital convergence and downstream matrix, particle, and magnetization
convergence in `L¹`.

For components in `Q.hamiltonian.closure.domain`, the Hamiltonian-coordinate Parseval identity now
constructs the global `p=2` moment contract rather than assuming it. With `a = ℏ ω₀ > 0`, the orbital
error is at most `2 ‖H̄ψ‖ / (a (n+1))`, and a fixed finite orbital family has an explicit full
matrix-density `L¹` error bound proportional to `1/(n+1)`.

This is the first concrete basis satisfying the Project Koios projection/completeness contract. It
is a one-dimensional oscillator basis, not a Kohn--Sham eigenbasis, a general spatial basis, a
numerical discretization, or a physical approximation claim. The quantitative results require the
actual selected closure domain, not merely `L²` membership. These rate bounds alone assert neither
energy convergence nor numerical certification of Hamiltonian norms. The reconstruction is also
identified exactly with the domain-valued partial sums in `HarmonicOscillator/HilbertBasis.lean`,
where graph-norm convergence and appropriately normalized oscillator energy-expectation convergence
are proved separately under their domain and normalization hypotheses.

## ii. Key results

- `oscillatorSpinorBasisProjectionContract`: concrete reconstruction completeness.
- `oscillatorSpinDensityMatrix_tendsto`: full matrix-density convergence for `L²` families.
- `oscillatorHamiltonianDomain_coefficientMomentBound`: derived global `p=2` moment contract.
- `oscillatorHamiltonianDomain_residual_norm_le`: explicit inverse-linear orbital bound.
- `oscillatorSpinDensityMatrix_sub_norm_le_of_hamiltonian_domain`: full density-error rate.
- `oscillatorSpinorBasisExpansion_reconstructOn_eq_domainPartialSum`: exact identification with
  the same domain-valued approximants used for graph-norm and energy-expectation convergence.

## iii. Table of contents

- A. Reconstruction and convergence
- B. Hamiltonian-domain quantitative bounds
- C. Proof schematic

## iv. References

This source-neutral binding reuses the local `HarmonicOscillator/HilbertBasis.lean` closure-domain
Parseval identity and the generic `SpinDensity/HilbertBasis.lean` moment and density-stability APIs.
The Hamiltonian is exactly `Q.hamiltonian.closure`, as packaged by `oneDimensionalQuantumSystem`.
No new publication crosswalk is asserted.

## C. Proof schematic

```mermaid
flowchart TD
    hilbert["QHO-HILBERT-DEF-002<br/>concrete oscillator Hilbert basis"] --> contract["QM-SPIN-DENSITY-OSCILLATOR-DEF-002<br/>projection contract"]
    contract --> converge["L2 orbitals to L1 densities<br/>finite families with fixed occupations"]
    domain["Actual selected Hamiltonian closure domain"] --> moment["QM-SPIN-DENSITY-OSCILLATOR-LEM-005<br/>derived p=2 moment bound"]
    parseval["QHO-HILBERT-LEM-009/012<br/>Hamiltonian Parseval and comparison"] --> moment
    moment --> rate["QM-SPIN-DENSITY-OSCILLATOR-LEM-006/007<br/>quantitative orbital error"]
    rate --> density["QM-SPIN-DENSITY-OSCILLATOR-LEM-008<br/>full matrix L1 error rate"]
    stable["Hölder stability and projection contraction"] --> density
    hilbert --> same["QM-SPIN-DENSITY-OSCILLATOR-LEM-009<br/>same domain-valued approximants"]
    same --> graphConv["Separate QHO convergence theorems<br/>require actual target domain membership<br/>and the stated normalization hypotheses"]
    %% Invisible links constrain layout only, not mathematical dependencies.
    hilbert ~~~ domain
    domain ~~~ stable
```
-/

@[expose] public section

open scoped BigOperators InnerProductSpace Matrix.Norms.L2Operator Topology

namespace ProjectKoios.QuantumMechanics.SpinDensity

open Filter MeasureTheory
open ProjectKoios.QuantumMechanics.HarmonicOscillator

/-! ## A. Reconstruction and convergence -/

/--
The continuum spinor expansion induced by the one-dimensional oscillator eigenstate Hilbert basis.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-DEF-001`.
-/
noncomputable def oscillatorSpinorBasisExpansion
    {Orbital : Type*} (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) :
    ContinuumSpinorBasisExpansion ℕ Orbital (Space 1) volume :=
  hilbertBasisExpansion (oneDimensionalEigenstateHilbertBasis Q) orbitals

/--
The canonical projection/completeness contract supplied by the one-dimensional oscillator
Hilbert basis.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-DEF-002`.
-/
noncomputable def oscillatorSpinorBasisProjectionContract
    {Orbital : Type*} (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) :
    ContinuumSpinorBasisProjectionContract
      (oscillatorSpinorBasisExpansion Q orbitals) Finset.range orbitals :=
  hilbertBasisProjectionContract (oneDimensionalEigenstateHilbertBasis Q) orbitals

/--
Oscillator/Hermite partial-sum reconstruction converges in `L²` to every supplied orbital spin
component.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-001`.
-/
lemma oscillatorSpinorReconstruct_tendsto
    {Orbital : Type*} (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (i : Orbital) (s : Fin 2) :
    Tendsto (fun n => (oscillatorSpinorBasisExpansion Q orbitals).reconstructOn
      (Finset.range n) i s) atTop (𝓝 (orbitals i s)) :=
  ContinuumSpinorBasisProjectionContract.reconstructOn_tendsto
    (oscillatorSpinorBasisExpansion Q orbitals) Finset.range orbitals
    (oscillatorSpinorBasisProjectionContract Q orbitals) i s

/--
Oscillator/Hermite partial-sum reconstruction gives matrix-valued spin-density convergence in
`L¹` for every fixed finite orbital family and occupation table.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-002`.
-/
lemma oscillatorSpinDensityMatrix_tendsto
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumOccupationWeightedSpinDensityMatrix
      ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
      occupation) atTop
      (𝓝 (continuumOccupationWeightedSpinDensityMatrix orbitals occupation)) :=
  hilbertBasisSpinDensityMatrix_tendsto
    (oneDimensionalEigenstateHilbertBasis Q) orbitals occupation

/--
Oscillator/Hermite partial-sum reconstruction gives particle-density convergence in `L¹`.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-003`.
-/
lemma oscillatorParticleDensity_tendsto
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumParticleDensity
      (continuumOccupationWeightedSpinDensityMatrix
        ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
        occupation)) atTop
      (𝓝 (continuumParticleDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation))) :=
  hilbertBasisParticleDensity_tendsto
    (oneDimensionalEigenstateHilbertBasis Q) orbitals occupation

/--
Oscillator/Hermite partial-sum reconstruction gives `L¹` convergence of every Pauli magnetization
component.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-004`.
-/
lemma oscillatorMagnetizationDensity_tendsto
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (occupation : Orbital → ℝ)
    (a : Fin 3) :
    Tendsto (fun n => continuumMagnetizationDensity
      (continuumOccupationWeightedSpinDensityMatrix
        ((oscillatorSpinorBasisExpansion Q orbitals).reconstructedFamilyOn (Finset.range n))
        occupation) a) atTop
      (𝓝 (continuumMagnetizationDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) a)) :=
  hilbertBasisMagnetizationDensity_tendsto
    (oneDimensionalEigenstateHilbertBasis Q) orbitals occupation a

/-! ## B. Hamiltonian-domain quantitative bounds -/

/--
Membership in the selected oscillator closure domain supplies a summable global coefficient moment
with exponent two and the explicit Hamiltonian-norm budget.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-005`.

This discharges both summability and the moment upper bound; neither is an additional assumption.
The premise remains the actual `Q.hamiltonian.closure.domain` subtype.
-/
lemma oscillatorHamiltonianDomain_coefficientMomentBound
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) :
    HasHilbertBasisCoefficientMomentBound (oneDimensionalEigenstateHilbertBasis Q)
      2 (oneDimensionalHamiltonianMomentBudget Q ψ) (ψ : Q.HS) where
  exponent_pos := by norm_num
  summable := by
    simpa only [Real.rpow_two] using
      oneDimensionalHamiltonianClosure_coefficientMoment_summable Q ψ
  sum_le := by
    simpa only [Real.rpow_two] using oneDimensionalHamiltonianClosure_coefficientMoment_le Q ψ

/--
Squared oscillator orbital error is bounded by the derived Hamiltonian moment budget divided by
`(n+1)²`.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-006`.
-/
lemma oscillatorHamiltonianDomain_residual_sq_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) (n : ℕ) :
    ‖(ψ : Q.HS) - hilbertBasisPartialSumProjection (oneDimensionalEigenstateHilbertBasis Q) n ψ‖ ^ 2 ≤
      oneDimensionalHamiltonianMomentBudget Q ψ / ((n : ℝ) + 1) ^ 2 := by
  simpa only [Real.rpow_two] using
    hilbertBasisPartialSumProjection_residual_sq_le_of_moment_bound
      (oneDimensionalEigenstateHilbertBasis Q) n 2 _ (ψ : Q.HS)
      (oscillatorHamiltonianDomain_coefficientMomentBound Q ψ)

/--
An explicit inverse-linear orbital truncation bound from the selected Hamiltonian domain:
`‖ψ-Pₙψ‖ ≤ 2 ‖H̄ψ‖ / (ℏ ω₀ (n+1))`.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-007`.
-/
lemma oscillatorHamiltonianDomain_residual_norm_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) (n : ℕ) :
    ‖(ψ : Q.HS) - hilbertBasisPartialSumProjection (oneDimensionalEigenstateHilbertBasis Q) n ψ‖ ≤
      2 * ‖Q.hamiltonian.closure ψ‖ / ((Constants.ℏ : ℝ) * Q.ω 0 * ((n : ℝ) + 1)) := by
  have ha : 0 < (Constants.ℏ : ℝ) * Q.ω 0 := mul_pos Constants.ℏ_pos (Q.ω_pos 0)
  have hn : 0 < (n : ℝ) + 1 := by positivity
  have hs := oscillatorHamiltonianDomain_residual_sq_le Q ψ n
  have hr : oneDimensionalHamiltonianMomentBudget Q ψ / ((n : ℝ) + 1) ^ 2 =
      (2 * ‖Q.hamiltonian.closure ψ‖ / ((Constants.ℏ : ℝ) * Q.ω 0 * ((n : ℝ) + 1))) ^ 2 := by
    unfold oneDimensionalHamiltonianMomentBudget
    field_simp
    ring
  rw [hr] at hs
  have hp : 0 ≤ 2 * ‖Q.hamiltonian.closure ψ‖ /
      ((Constants.ℏ : ℝ) * Q.ω 0 * ((n : ℝ) + 1)) := by positivity
  have he := norm_nonneg ((ψ : Q.HS) -
    hilbertBasisPartialSumProjection (oneDimensionalEigenstateHilbertBasis Q) n ψ)
  nlinarith

/--
A full matrix-density inverse-linear `L¹` error bound for a fixed finite orbital family whose
components lie in the selected oscillator Hamiltonian closure domain.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-008`.

The finite amplification factor uses target orbital and Hamiltonian-image norms. Occupations are
arbitrary fixed real weights and enter by absolute value; no numerical norm bounds or energy
convergence are inferred.
-/
lemma oscillatorSpinDensityMatrix_sub_norm_le_of_hamiltonian_domain
    {Orbital : Type*} [Fintype Orbital]
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Orbital → Fin 2 → Q.hamiltonian.closure.domain) (occupation : Orbital → ℝ) :
    ‖continuumOccupationWeightedSpinDensityMatrix (fun i s => (ψ i s : Q.HS)) occupation -
      continuumOccupationWeightedSpinDensityMatrix
        ((oscillatorSpinorBasisExpansion Q (fun i s => (ψ i s : Q.HS))).reconstructedFamilyOn
          (Finset.range n)) occupation‖ ≤
      (2 / ((Constants.ℏ : ℝ) * Q.ω 0 * ((n : ℝ) + 1))) *
        ∑ i : Orbital, |occupation i| * ∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (‖Q.hamiltonian.closure (ψ i s)‖ * ‖(ψ i t : Q.HS)‖ +
              ‖(ψ i s : Q.HS)‖ * ‖Q.hamiltonian.closure (ψ i t)‖) := by
  let b := oneDimensionalEigenstateHilbertBasis Q
  let C : ℝ := 2 / ((Constants.ℏ : ℝ) * Q.ω 0 * ((n : ℝ) + 1))
  have herr : ∀ i s, ‖(ψ i s : Q.HS) - hilbertBasisPartialSumProjection b n (ψ i s)‖ ≤
      C * ‖Q.hamiltonian.closure (ψ i s)‖ := by
    intro i s
    simpa only [C, div_mul_eq_mul_div, mul_comm (2 : ℝ)] using
      oscillatorHamiltonianDomain_residual_norm_le Q (ψ i s) n
  apply (norm_reconstructedOccupationWeightedSpinDensityMatrix_sub_le
    (hilbertBasisExpansion b (fun i s => (ψ i s : Q.HS))) (Finset.range n)
    (fun i s => (ψ i s : Q.HS)) occupation).trans
  simp only [hilbertBasis_reconstruct_eq_projection]
  calc
    _ ≤ ∑ i : Orbital, |occupation i| * ∑ s : Fin 2, ∑ t : Fin 2,
        ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
          ((C * ‖Q.hamiltonian.closure (ψ i s)‖) * ‖(ψ i t : Q.HS)‖ +
            ‖(ψ i s : Q.HS)‖ * (C * ‖Q.hamiltonian.closure (ψ i t)‖)) := by
      apply Finset.sum_le_sum
      intro i _
      apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
      apply Finset.sum_le_sum
      intro s _
      apply Finset.sum_le_sum
      intro t _
      apply mul_le_mul_of_nonneg_left _ (norm_nonneg _)
      apply add_le_add
      · exact mul_le_mul_of_nonneg_right (herr i s) (norm_nonneg _)
      · exact mul_le_mul (hilbertBasisPartialSumProjection_norm_le b n _) (herr i t)
          (norm_nonneg _) (norm_nonneg _)
    _ = _ := by
      change _ = C * _
      simp only [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro s _
      apply Finset.sum_congr rfl
      intro t _
      ring

/--
The existing oscillator spinor reconstruction equals the domain-valued Hilbert partial sum in the
ambient `L²` space.

Project Koios declaration ID: `QM-SPIN-DENSITY-OSCILLATOR-LEM-009`.

This identifies the reconstruction used by the density layer with the same approximants used in
the oscillator graph-norm and energy-expectation convergence results; it does not infer that an
arbitrary target belongs to the Hamiltonian domain.
-/
lemma oscillatorSpinorBasisExpansion_reconstructOn_eq_domainPartialSum
    {Orbital : Type*} (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (orbitals : Orbital → ContinuumSpinor (Space 1) volume) (n : ℕ) (i : Orbital) (s : Fin 2) :
    (oscillatorSpinorBasisExpansion Q orbitals).reconstructOn (Finset.range n) i s =
      (oneDimensionalEigenstateDomainPartialSum Q n (orbitals i s) : Q.HS) := by
  rw [oneDimensionalEigenstateDomainPartialSum_coe]
  rfl

end ProjectKoios.QuantumMechanics.SpinDensity

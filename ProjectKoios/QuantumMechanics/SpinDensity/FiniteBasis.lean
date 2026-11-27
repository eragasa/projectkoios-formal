/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.SpinDensity.Continuum

/-!
# Finite-basis reconstruction of continuum spinors

Explicit finite coefficient reconstruction and conditional continuum spin-density approximation.

## i. Overview

This module defines an explicit comparison map from a finite set of supplied continuum `L²` basis
functions and complex spin-orbital coefficients to the separate representative-safe continuum
spinor and spin-density carriers. For a basis-index set `S`, orbital `i`, and spin component `s`,
reconstruction uses

`ψ[S] i s = ∑ k in S, C k i s • χ k`.

The basis-index type may be infinite; each reconstruction uses only its supplied `Finset`.
The orbital carrier is arbitrary for reconstruction, while occupation-weighted density bounds and
convergence statements require a finite orbital family. Representative formulas hold almost
everywhere, not at arbitrary chosen points of an `L²` class.
No completeness, linear independence, orthogonality, projection property, or convergence is built
into the coefficient construction. Error and convergence statements specialize the continuum
stability results. Occupations are fixed real weights; error budgets use their absolute values and
do not require positivity or normalization.

The separate projection contract requires bounded idempotent maps, reconstruction equality on the
target components, and strong convergence to the identity on all scalar `L²` vectors. Its fields
must be supplied or proved: idempotence alone is not completeness. The later Hilbert-basis adapter
constructs a concrete instance, but this module does not identify a numerical or physical basis,
validate a coefficient computation, or infer a Hamiltonian-domain or energy approximation result.

## ii. Key results

- `ContinuumSpinorBasisExpansion.reconstructOn`: explicit finite-basis `L²` spinor reconstruction.
- `ContinuumSpinorBasisExpansion.reconstructOn_apply_ae`: almost-everywhere coefficient formula.
- `norm_reconstructedOccupationWeightedSpinDensityMatrix_sub_le`: full `L¹` density error bound.
- `reconstructedOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise`: conditional
  matrix-density convergence, with corresponding particle/magnetization convergence statements.
- `ContinuumSpinorBasisProjectionContract`: separately supplied projection/completeness contract.
- `ContinuumSpinorBasisProjectionContract.reconstructOn_tendsto`: discharge of the componentwise
  convergence premise, followed by the contract's three density convergence methods.

## iii. Table of contents

- A. Finite coefficient reconstruction
- B. Conditional density error and convergence
- C. Projection and completeness contract
- D. Proof schematic

## iv. References

This source-neutral comparison layer reuses `SpinDensity/Continuum.lean`, especially
`norm_continuumOccupationWeightedSpinDensityMatrix_sub_le` and its conditional componentwise
convergence transfers. Representative formulas use Mathlib `Lp.coeFn_smul`, `Lp.coeFn_finsetSum`,
and finite-index almost-everywhere conjunctions. No publication claim or independent completeness
result is ported here; the semantic carrier and declarations remain under `ProjectKoios`.

## D. Proof schematic

```mermaid
flowchart TD
    data["QM-SPIN-DENSITY-BASIS-DEF-001<br/>supplied L2 functions and coefficients<br/>explicit finite index set"] --> reconstruct["QM-SPIN-DENSITY-BASIS-DEF-002/003<br/>finite-basis reconstructed spinors"]
    contract["QM-SPIN-DENSITY-BASIS-DEF-004<br/>supplied bounded idempotent projections<br/>reconstruction equality and strong completeness"] --> components["QM-SPIN-DENSITY-BASIS-LEM-006<br/>target-component L2 convergence"]
    reconstruct --> localBounds["QM-SPIN-DENSITY-BASIS-LEM-001/002<br/>a.e. representative and density error<br/>error bound requires a finite orbital family<br/>via existing continuum identities/stability"]
    reconstruct --> conditional["QM-SPIN-DENSITY-BASIS-LEM-003 to 005<br/>density convergence for finite orbital families<br/>assuming componentwise L2 convergence<br/>and fixed real occupations"]
    components --> conditional
    conditional --> result["QM-SPIN-DENSITY-BASIS-LEM-007 to 009<br/>contract-based density convergence"]
    contract --> result
```
-/

@[expose] public section

open scoped BigOperators Matrix.Norms.L2Operator Topology

namespace ProjectKoios.QuantumMechanics.SpinDensity

open Filter MeasureTheory

/-! ## A. Finite coefficient reconstruction -/

/--
Supplied continuum `L²` basis functions and complex spin-orbital coefficient data.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-DEF-001`.

The basis-index type need not be finite because each reconstruction is restricted to an explicit
`Finset`. The orbital carrier is also arbitrary.
-/
structure ContinuumSpinorBasisExpansion
    (Basis Orbital α : Type*) [MeasurableSpace α] (μ : Measure α) where
  /-- One supplied scalar complex continuum `L²` basis function. -/
  basisFunction : Basis → Lp ℂ 2 μ
  /-- Coefficient of a basis function in one orbital and spin component. -/
  coefficient : Basis → Orbital → Fin 2 → ℂ

variable {Basis Orbital α : Type*} [MeasurableSpace α] {μ : Measure α}

/--
Reconstruct one continuum spinor from a finite set of basis indices.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-DEF-002`.
-/
noncomputable def ContinuumSpinorBasisExpansion.reconstructOn
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : Finset Basis) (orbital : Orbital) : ContinuumSpinor α μ :=
  fun s => ∑ k ∈ indices, expansion.coefficient k orbital s • expansion.basisFunction k

/--
Reconstruct the entire orbital family on one finite basis-index set.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-DEF-003`.
-/
noncomputable def ContinuumSpinorBasisExpansion.reconstructedFamilyOn
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : Finset Basis) : Orbital → ContinuumSpinor α μ :=
  fun orbital => expansion.reconstructOn indices orbital

/--
Each reconstructed component has the expected finite-sum representative almost everywhere.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-001`.
-/
lemma ContinuumSpinorBasisExpansion.reconstructOn_apply_ae
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : Finset Basis) (orbital : Orbital) (s : Fin 2) :
    expansion.reconstructOn indices orbital s =ᵐ[μ]
      fun x => ∑ k ∈ indices, expansion.coefficient k orbital s * expansion.basisFunction k x := by
  unfold ContinuumSpinorBasisExpansion.reconstructOn
  have hsmul : ∀ᵐ x ∂μ, ∀ k ∈ indices,
      (expansion.coefficient k orbital s • expansion.basisFunction k) x =
        expansion.coefficient k orbital s * expansion.basisFunction k x :=
    (Filter.eventually_all_finset indices).mpr fun k hk => by
      filter_upwards [Lp.coeFn_smul (expansion.coefficient k orbital s)
        (expansion.basisFunction k)] with x hx
      exact hx
  filter_upwards [Lp.coeFn_finsetSum indices (fun k =>
    expansion.coefficient k orbital s • expansion.basisFunction k), hsmul] with x hsum hs
  rw [hsum]
  simp only [Finset.sum_apply]
  apply Finset.sum_congr rfl
  intro k hk
  exact hs k hk

/-! ## B. Conditional density error and convergence -/

/--
The full matrix-valued `L¹` error of a reconstructed fixed-occupation density is bounded explicitly
by the supplied component `L²` reconstruction errors.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-002`.

This bound does not assert that the right-hand side tends to zero for any chosen basis.
-/
lemma norm_reconstructedOccupationWeightedSpinDensityMatrix_sub_le
    [Fintype Orbital]
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (occupation : Orbital → ℝ) :
    ‖continuumOccupationWeightedSpinDensityMatrix orbitals occupation -
        continuumOccupationWeightedSpinDensityMatrix
          (expansion.reconstructedFamilyOn indices) occupation‖ ≤
      ∑ i : Orbital, |occupation i| *
        (∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (‖orbitals i s - expansion.reconstructOn indices i s‖ * ‖orbitals i t‖ +
              ‖expansion.reconstructOn indices i s‖ *
                ‖orbitals i t - expansion.reconstructOn indices i t‖)) := by
  exact norm_continuumOccupationWeightedSpinDensityMatrix_sub_le
    orbitals (expansion.reconstructedFamilyOn indices) occupation

/--
Componentwise `L²` convergence of explicit finite-basis reconstructions implies matrix-valued `L¹`
convergence of the fixed-occupation spin density.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-003`.

The componentwise convergence premise is the target-approximation obligation a concrete
reconstruction must discharge. A projection/completeness contract is one sufficient route; this
conditional statement does not itself require strong convergence for every scalar `L²` vector.
-/
lemma reconstructedOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise
    [Fintype Orbital] {β : Type*} {l : Filter β}
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : β → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (occupation : Orbital → ℝ)
    (h : ∀ i s, Tendsto (fun b => expansion.reconstructOn (indices b) i s)
      l (𝓝 (orbitals i s))) :
    Tendsto (fun b => continuumOccupationWeightedSpinDensityMatrix
      (expansion.reconstructedFamilyOn (indices b)) occupation) l
      (𝓝 (continuumOccupationWeightedSpinDensityMatrix orbitals occupation)) :=
  continuumOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise
    (fun b => expansion.reconstructedFamilyOn (indices b)) orbitals occupation h

/--
Componentwise `L²` convergence of explicit finite-basis reconstructions implies scalar particle-
density convergence in `L¹`.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-004`.
-/
lemma reconstructedOccupationWeightedParticleDensity_tendsto_of_componentwise
    [Fintype Orbital] {β : Type*} {l : Filter β}
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : β → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (occupation : Orbital → ℝ)
    (h : ∀ i s, Tendsto (fun b => expansion.reconstructOn (indices b) i s)
      l (𝓝 (orbitals i s))) :
    Tendsto (fun b => continuumParticleDensity
      (continuumOccupationWeightedSpinDensityMatrix
        (expansion.reconstructedFamilyOn (indices b)) occupation)) l
      (𝓝 (continuumParticleDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation))) :=
  continuumOccupationWeightedParticleDensity_tendsto_of_componentwise
    (fun b => expansion.reconstructedFamilyOn (indices b)) orbitals occupation h

/--
Componentwise `L²` convergence of explicit finite-basis reconstructions implies `L¹` convergence of
every Pauli magnetization component.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-005`.
-/
lemma reconstructedOccupationWeightedMagnetizationDensity_tendsto_of_componentwise
    [Fintype Orbital] {β : Type*} {l : Filter β}
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : β → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (occupation : Orbital → ℝ)
    (h : ∀ i s, Tendsto (fun b => expansion.reconstructOn (indices b) i s)
      l (𝓝 (orbitals i s))) (a : Fin 3) :
    Tendsto (fun b => continuumMagnetizationDensity
      (continuumOccupationWeightedSpinDensityMatrix
        (expansion.reconstructedFamilyOn (indices b)) occupation) a) l
      (𝓝 (continuumMagnetizationDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) a)) :=
  continuumOccupationWeightedMagnetizationDensity_tendsto_of_componentwise
    (fun b => expansion.reconstructedFamilyOn (indices b)) orbitals occupation h a

/-! ## C. Projection and completeness contract -/

/--
A checked projection/completeness contract connecting finite-basis reconstructions to continuum
`L²` orbitals.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-DEF-004`.

Each `projection n` is required to be idempotent, the explicit coefficient reconstruction must agree
with applying that projection to every target orbital component, and the projections must converge
strongly to the identity on all scalar complex `L²` classes. A concrete basis must construct this
record; the definition does not infer any field from coefficient data alone.
-/
structure ContinuumSpinorBasisProjectionContract
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : ℕ → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ) where
  /-- The bounded projection selected at truncation level `n`. -/
  projection : ℕ → Lp ℂ 2 μ →L[ℂ] Lp ℂ 2 μ
  /-- Every selected operator is algebraically idempotent. -/
  projection_idempotent : ∀ n f, projection n (projection n f) = projection n f
  /-- Coefficient reconstruction agrees with projection of each target component. -/
  reconstruct_eq_projection : ∀ n i s,
    expansion.reconstructOn (indices n) i s = projection n (orbitals i s)
  /-- Strong completeness: the projections converge pointwise to the identity on `L²`. -/
  projection_tendsto_identity : ∀ f, Tendsto (fun n => projection n f) atTop (𝓝 f)

/--
A projection/completeness contract discharges the componentwise `L²` convergence premise for every
target orbital and spin component.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-006`.
-/
lemma ContinuumSpinorBasisProjectionContract.reconstructOn_tendsto
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : ℕ → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (contract : ContinuumSpinorBasisProjectionContract expansion indices orbitals)
    (i : Orbital) (s : Fin 2) :
    Tendsto (fun n => expansion.reconstructOn (indices n) i s) atTop (𝓝 (orbitals i s)) := by
  convert contract.projection_tendsto_identity (orbitals i s) using 1
  funext n
  exact contract.reconstruct_eq_projection n i s

/--
A projection/completeness contract implies matrix-valued `L¹` convergence of the reconstructed
fixed-occupation spin density.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-007`.
-/
lemma ContinuumSpinorBasisProjectionContract.spinDensityMatrix_tendsto
    [Fintype Orbital]
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : ℕ → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (contract : ContinuumSpinorBasisProjectionContract expansion indices orbitals)
    (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumOccupationWeightedSpinDensityMatrix
      (expansion.reconstructedFamilyOn (indices n)) occupation) atTop
      (𝓝 (continuumOccupationWeightedSpinDensityMatrix orbitals occupation)) :=
  reconstructedOccupationWeightedSpinDensityMatrix_tendsto_of_componentwise
    expansion indices orbitals occupation contract.reconstructOn_tendsto

/--
A projection/completeness contract implies scalar particle-density convergence in `L¹`.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-008`.
-/
lemma ContinuumSpinorBasisProjectionContract.particleDensity_tendsto
    [Fintype Orbital]
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : ℕ → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (contract : ContinuumSpinorBasisProjectionContract expansion indices orbitals)
    (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumParticleDensity
      (continuumOccupationWeightedSpinDensityMatrix
        (expansion.reconstructedFamilyOn (indices n)) occupation)) atTop
      (𝓝 (continuumParticleDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation))) :=
  reconstructedOccupationWeightedParticleDensity_tendsto_of_componentwise
    expansion indices orbitals occupation contract.reconstructOn_tendsto

/--
A projection/completeness contract implies convergence in `L¹` of every Pauli magnetization
component.

Project Koios declaration ID: `QM-SPIN-DENSITY-BASIS-LEM-009`.
-/
lemma ContinuumSpinorBasisProjectionContract.magnetizationDensity_tendsto
    [Fintype Orbital]
    (expansion : ContinuumSpinorBasisExpansion Basis Orbital α μ)
    (indices : ℕ → Finset Basis) (orbitals : Orbital → ContinuumSpinor α μ)
    (contract : ContinuumSpinorBasisProjectionContract expansion indices orbitals)
    (occupation : Orbital → ℝ) (a : Fin 3) :
    Tendsto (fun n => continuumMagnetizationDensity
      (continuumOccupationWeightedSpinDensityMatrix
        (expansion.reconstructedFamilyOn (indices n)) occupation) a) atTop
      (𝓝 (continuumMagnetizationDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) a)) :=
  reconstructedOccupationWeightedMagnetizationDensity_tendsto_of_componentwise
    expansion indices orbitals occupation contract.reconstructOn_tendsto a

end ProjectKoios.QuantumMechanics.SpinDensity

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.SpinDensity.FiniteBasis
public import Mathlib.Analysis.InnerProductSpace.l2Space
public import Mathlib.MeasureTheory.Function.L2Space

/-!
# Hilbert-basis realization of continuum spinor reconstruction

Exact continuum reconstruction, convergence, and coefficient-tail truncation estimates.

## i. Overview

This module constructs the finite-basis projection contract from an actual Mathlib `HilbertBasis`
indexed by `ℕ`. Coefficients are the Hilbert coordinates

`C k i s = ⟪e k, ψ i s⟫`,

and truncation level `n` uses the finite set `Finset.range n`. The associated operator is the finite
sum of rank-one orthogonal projections

`Pₙ f = ∑ k < n, ⟪e k, f⟫ • e k`.

Orthonormality proves idempotence. Mathlib's unconditional Hilbert-basis expansion proves strong
convergence `Pₙ f → f`. The resulting `ContinuumSpinorBasisProjectionContract` therefore yields
matrix, particle, and magnetization-density convergence without adding a local completeness postulate.

The quantitative layer also identifies squared orbital residuals exactly with the discarded
coefficient tail and transfers their square roots to a full matrix-density error budget. A separate
global summable weighted coefficient-moment contract now yields explicit positive-real-exponent
cutoff rates and tolerance conditions. The moment contract is supplied, not inferred from finite
coefficients or an operator domain; no numerical tail certificate or energy convergence is asserted.

This remains a generic Hilbert-space result. The separate oscillator binding supplies the proved
one-dimensional Hermite instance.

## ii. Key results

- `hilbertBasisProjectionContract`: actual Hilbert partial sums realize the projection contract.
- `hilbertBasisSpinDensityMatrix_tendsto`: full matrix-density convergence for fixed occupations.
- `hilbertBasisPartialSumProjection_residual_sq_eq_tail`: exact squared error as a coefficient tail.
- `hilbertBasisSpinDensityMatrix_sub_norm_le_tail`: full matrix-density coefficient-tail budget.
- `HasHilbertBasisCoefficientMomentBound`: summability plus a bounded global weighted moment.
- `hilbertBasisCoefficientTailEnergy_le_of_moment_bound`: explicit `M / (n + 1)^p` tail rate.
- `hilbertBasisSpinDensityMatrix_sub_norm_le_moment_cutoff`: tolerance-oriented density bound.

## iii. Table of contents

- A. Reconstruction and projection contract
- B. Density convergence
- C. Quantitative truncation estimates
- D. Weighted coefficient moments and cutoff rates
- E. Proof schematic

## iv. References

These source-neutral results reuse the pinned Mathlib declarations `HilbertBasis.hasSum_repr` and
`lp.norm_rpow_eq_tsum` in `Mathlib/Analysis/InnerProductSpace/l2Space.lean` and
`Mathlib/Analysis/Normed/Lp/lpSpace.lean`, orthonormal coefficient extraction in
`Mathlib/Analysis/InnerProductSpace/Orthonormal.lean`, and the Pythagorean identity in
`Mathlib/Analysis/InnerProductSpace/Basic.lean`. Moment-rate estimates reuse
`Summable.tsum_le_tsum_of_inj` from `Mathlib/Topology/Algebra/InfiniteSum/Order.lean` and
`Real.rpow_le_rpow` from `Mathlib/Analysis/SpecialFunctions/Pow/Real.lean`.
No new publication crosswalk is asserted.

## E. Proof schematic

```mermaid
flowchart TD
    basis["Mathlib countable Hilbert basis<br/>orthonormality and expansion"] --> projection["QM-SPIN-DENSITY-HILBERT-DEF-002/003<br/>partial sums and projection contract"]
    projection --> convergence["QM-SPIN-DENSITY-HILBERT-LEM-005 to 007<br/>L1 density convergence<br/>finite families with fixed real occupations"]
    projection --> pyth["QM-SPIN-DENSITY-HILBERT-LEM-008/009/014<br/>orthogonal residual, Pythagoras<br/>and norm contraction"]
    basis --> parseval["QM-SPIN-DENSITY-HILBERT-LEM-010/011<br/>Parseval and retained coefficient energy"]
    pyth --> tail["QM-SPIN-DENSITY-HILBERT-LEM-012/013<br/>squared residual is exact tail<br/>norm is its nonnegative square root"]
    parseval --> tail
    tail --> density["QM-SPIN-DENSITY-HILBERT-LEM-015<br/>matrix L1 coefficient-tail budget<br/>finite families with fixed real occupations"]
    pyth --> density
    moment["QM-SPIN-DENSITY-HILBERT-DEF-005<br/>supplied positive exponent p<br/>genuinely summable weighted moment at most M"] --> rate["QM-SPIN-DENSITY-HILBERT-LEM-017 to 020<br/>tail and orbital rates<br/>nonnegative tolerance for cutoff guarantees"]
    tail --> rate
    rate --> tolerance["QM-SPIN-DENSITY-HILBERT-LEM-021/022<br/>matrix-density rate and cutoff<br/>from all component moment budgets"]
    density --> tolerance
```
-/

@[expose] public section

open scoped BigOperators InnerProductSpace Matrix.Norms.L2Operator Topology

namespace ProjectKoios.QuantumMechanics.SpinDensity

open Filter MeasureTheory

variable {Orbital α : Type*} [MeasurableSpace α] {μ : Measure α}

/-! ## A. Reconstruction and projection contract -/

/--
The continuum spinor expansion induced by a countable Hilbert basis and target orbital family.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-DEF-001`.
-/
noncomputable def hilbertBasisExpansion
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ))
    (orbitals : Orbital → ContinuumSpinor α μ) :
    ContinuumSpinorBasisExpansion ℕ Orbital α μ where
  basisFunction := basis
  coefficient := fun k i s => ⟪basis k, orbitals i s⟫_ℂ

/--
The finite partial-sum projection associated with the first `n` Hilbert-basis vectors.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-DEF-002`.
-/
noncomputable def hilbertBasisPartialSumProjection
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) :
    Lp ℂ 2 μ →L[ℂ] Lp ℂ 2 μ :=
  ∑ k ∈ Finset.range n, InnerProductSpace.rankOne ℂ (basis k) (basis k)

/--
The partial-sum projection evaluates to the expected finite Hilbert expansion.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-001`.
-/
lemma hilbertBasisPartialSumProjection_apply
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    hilbertBasisPartialSumProjection basis n f =
      ∑ k ∈ Finset.range n, ⟪basis k, f⟫_ℂ • basis k := by
  simp [hilbertBasisPartialSumProjection, InnerProductSpace.rankOne_apply]

/--
Every finite Hilbert-basis partial-sum operator is idempotent.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-002`.
-/
lemma hilbertBasisPartialSumProjection_idempotent
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    hilbertBasisPartialSumProjection basis n
      (hilbertBasisPartialSumProjection basis n f) =
      hilbertBasisPartialSumProjection basis n f := by
  rw [hilbertBasisPartialSumProjection_apply, hilbertBasisPartialSumProjection_apply]
  apply Finset.sum_congr rfl
  intro k hk
  rw [basis.orthonormal.inner_right_sum (fun j => ⟪basis j, f⟫_ℂ) hk]

/--
Finite coefficient reconstruction over `Finset.range n` equals the Hilbert partial-sum projection.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-003`.
-/
lemma hilbertBasis_reconstruct_eq_projection
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ))
    (orbitals : Orbital → ContinuumSpinor α μ) (n : ℕ) (i : Orbital) (s : Fin 2) :
    (hilbertBasisExpansion basis orbitals).reconstructOn (Finset.range n) i s =
      hilbertBasisPartialSumProjection basis n (orbitals i s) := by
  rw [hilbertBasisPartialSumProjection_apply]
  rfl

/--
Hilbert-basis partial-sum projections converge strongly to the identity.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-004`.
-/
lemma hilbertBasisPartialSumProjection_tendsto
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (f : Lp ℂ 2 μ) :
    Tendsto (fun n => hilbertBasisPartialSumProjection basis n f) atTop (𝓝 f) := by
  simpa only [hilbertBasisPartialSumProjection_apply, basis.repr_apply_apply] using
    (basis.hasSum_repr f).tendsto_sum_nat

/--
A countable Hilbert basis canonically supplies the finite-basis projection/completeness contract.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-DEF-003`.
-/
noncomputable def hilbertBasisProjectionContract
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ))
    (orbitals : Orbital → ContinuumSpinor α μ) :
    ContinuumSpinorBasisProjectionContract
      (hilbertBasisExpansion basis orbitals) Finset.range orbitals where
  projection := hilbertBasisPartialSumProjection basis
  projection_idempotent := hilbertBasisPartialSumProjection_idempotent basis
  reconstruct_eq_projection := hilbertBasis_reconstruct_eq_projection basis orbitals
  projection_tendsto_identity := hilbertBasisPartialSumProjection_tendsto basis

/-! ## B. Density convergence -/

/--
Hilbert-basis reconstruction gives matrix-valued `L¹` convergence of every fixed-occupation finite
orbital-family spin density.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-005`.
-/
lemma hilbertBasisSpinDensityMatrix_tendsto
    [Fintype Orbital]
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ))
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumOccupationWeightedSpinDensityMatrix
      ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation)
      atTop (𝓝 (continuumOccupationWeightedSpinDensityMatrix orbitals occupation)) :=
  ContinuumSpinorBasisProjectionContract.spinDensityMatrix_tendsto
    (hilbertBasisExpansion basis orbitals) Finset.range orbitals
    (hilbertBasisProjectionContract basis orbitals) occupation

/--
Hilbert-basis reconstruction gives scalar particle-density convergence in `L¹`.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-006`.
-/
lemma hilbertBasisParticleDensity_tendsto
    [Fintype Orbital]
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ))
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) :
    Tendsto (fun n => continuumParticleDensity
      (continuumOccupationWeightedSpinDensityMatrix
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation))
      atTop (𝓝 (continuumParticleDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation))) :=
  ContinuumSpinorBasisProjectionContract.particleDensity_tendsto
    (hilbertBasisExpansion basis orbitals) Finset.range orbitals
    (hilbertBasisProjectionContract basis orbitals) occupation

/--
Hilbert-basis reconstruction gives `L¹` convergence of every Pauli magnetization component.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-007`.
-/
lemma hilbertBasisMagnetizationDensity_tendsto
    [Fintype Orbital]
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ))
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) (a : Fin 3) :
    Tendsto (fun n => continuumMagnetizationDensity
      (continuumOccupationWeightedSpinDensityMatrix
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n)) occupation) a)
      atTop (𝓝 (continuumMagnetizationDensity
        (continuumOccupationWeightedSpinDensityMatrix orbitals occupation) a)) :=
  ContinuumSpinorBasisProjectionContract.magnetizationDensity_tendsto
    (hilbertBasisExpansion basis orbitals) Finset.range orbitals
    (hilbertBasisProjectionContract basis orbitals) occupation a

/-! ## C. Quantitative truncation estimates -/

/--
The discarded squared Hilbert-coordinate tail starting at index `n`.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-DEF-004`.

This is an exact infinite series, not a computed numerical certificate. Here coefficient energy
means squared `L²` norm, not Hamiltonian energy.
-/
noncomputable def hilbertBasisCoefficientTailEnergy
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) : ℝ :=
  ∑' k : ℕ, ‖⟪basis (k + n), f⟫_ℂ‖ ^ 2

/--
The retained Hilbert projection is orthogonal to its orbital residual.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-008`.
-/
lemma hilbertBasisPartialSumProjection_inner_residual
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    ⟪hilbertBasisPartialSumProjection basis n f,
      f - hilbertBasisPartialSumProjection basis n f⟫_ℂ = 0 := by
  rw [hilbertBasisPartialSumProjection_apply, sum_inner]
  apply Finset.sum_eq_zero
  intro k hk
  rw [inner_smul_left, inner_sub_right,
    basis.orthonormal.inner_right_sum (fun j => ⟪basis j, f⟫_ℂ) hk]
  simp

/--
Exact Pythagorean norm deficit for a Hilbert partial-sum projection.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-009`.
-/
lemma hilbertBasisPartialSumProjection_norm_sq_deficit
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    ‖f‖ ^ 2 - ‖hilbertBasisPartialSumProjection basis n f‖ ^ 2 =
      ‖f - hilbertBasisPartialSumProjection basis n f‖ ^ 2 := by
  have h := norm_add_sq_eq_norm_sq_add_norm_sq_of_inner_eq_zero
    (hilbertBasisPartialSumProjection basis n f)
    (f - hilbertBasisPartialSumProjection basis n f)
    (hilbertBasisPartialSumProjection_inner_residual basis n f)
  rw [add_sub_cancel] at h
  nlinarith

/--
Parseval's identity for scalar complex continuum `L²` Hilbert coordinates.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-010`.
-/
lemma hilbertBasis_norm_sq_eq_tsum
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (f : Lp ℂ 2 μ) :
    ‖f‖ ^ 2 = ∑' k, ‖⟪basis k, f⟫_ℂ‖ ^ 2 := by
  have h := lp.norm_rpow_eq_tsum (p := (2 : ENNReal)) (by norm_num) (basis.repr f)
  simpa only [ENNReal.toReal_ofNat, Real.rpow_two, basis.repr.norm_map,
    basis.repr_apply_apply] using h

/--
The squared norm of a finite Hilbert projection is its retained coefficient energy.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-011`.
-/
lemma hilbertBasisPartialSumProjection_norm_sq
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    ‖hilbertBasisPartialSumProjection basis n f‖ ^ 2 =
      ∑ k ∈ Finset.range n, ‖⟪basis k, f⟫_ℂ‖ ^ 2 := by
  rw [@InnerProductSpace.norm_sq_eq_re_inner ℂ]
  rw [hilbertBasisPartialSumProjection_apply, basis.orthonormal.inner_sum]
  simp only [map_sum]
  apply Finset.sum_congr rfl
  intro k _
  change Complex.re ((starRingEnd ℂ) ⟪basis k, f⟫_ℂ * ⟪basis k, f⟫_ℂ) = _
  rw [← Complex.normSq_eq_conj_mul_self, Complex.ofReal_re, Complex.normSq_eq_norm_sq]

/--
The exact squared orbital truncation error is the discarded Hilbert-coordinate tail.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-012`.
-/
lemma hilbertBasisPartialSumProjection_residual_sq_eq_tail
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    ‖f - hilbertBasisPartialSumProjection basis n f‖ ^ 2 =
      hilbertBasisCoefficientTailEnergy basis n f := by
  rw [← hilbertBasisPartialSumProjection_norm_sq_deficit, hilbertBasis_norm_sq_eq_tsum,
    hilbertBasisPartialSumProjection_norm_sq]
  have h := (basis.orthonormal.inner_products_summable f).sum_add_tsum_nat_add n
  unfold hilbertBasisCoefficientTailEnergy
  linarith

/--
The orbital residual norm is the nonnegative square root of the exact coefficient tail.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-013`.
-/
lemma hilbertBasisPartialSumProjection_residual_norm_eq_sqrt_tail
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    ‖f - hilbertBasisPartialSumProjection basis n f‖ =
      Real.sqrt (hilbertBasisCoefficientTailEnergy basis n f) := by
  rw [← hilbertBasisPartialSumProjection_residual_sq_eq_tail, Real.sqrt_sq (norm_nonneg _)]

/--
Hilbert partial-sum projections do not increase the orbital norm.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-014`.
-/
lemma hilbertBasisPartialSumProjection_norm_le
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (f : Lp ℂ 2 μ) :
    ‖hilbertBasisPartialSumProjection basis n f‖ ≤ ‖f‖ := by
  have h := hilbertBasisPartialSumProjection_norm_sq_deficit basis n f
  have hres := sq_nonneg ‖f - hilbertBasisPartialSumProjection basis n f‖
  have hp := norm_nonneg (hilbertBasisPartialSumProjection basis n f)
  have hf := norm_nonneg f
  nlinarith

/--
An exact coefficient-tail error budget for a fixed-occupation full matrix-valued `L¹` density.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-015`.

The infinite coefficient tails must be bounded separately to obtain a numerical certificate or
rate. No energy convergence is asserted.
-/
lemma hilbertBasisSpinDensityMatrix_sub_norm_le_tail
    [Fintype Orbital]
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ)
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ) :
    ‖continuumOccupationWeightedSpinDensityMatrix orbitals occupation -
      continuumOccupationWeightedSpinDensityMatrix
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n))
        occupation‖ ≤
      ∑ i : Orbital, |occupation i| *
        (∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (Real.sqrt (hilbertBasisCoefficientTailEnergy basis n (orbitals i s)) *
                ‖orbitals i t‖ +
              ‖orbitals i s‖ *
                Real.sqrt (hilbertBasisCoefficientTailEnergy basis n (orbitals i t)))) := by
  apply (norm_reconstructedOccupationWeightedSpinDensityMatrix_sub_le
    (hilbertBasisExpansion basis orbitals) (Finset.range n) orbitals occupation).trans
  simp only [hilbertBasis_reconstruct_eq_projection,
    hilbertBasisPartialSumProjection_residual_norm_eq_sqrt_tail]
  apply Finset.sum_le_sum
  intro i _
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  apply Finset.sum_le_sum
  intro s _
  apply Finset.sum_le_sum
  intro t _
  apply mul_le_mul_of_nonneg_left _ (norm_nonneg _)
  exact add_le_add_right
    (mul_le_mul_of_nonneg_right (hilbertBasisPartialSumProjection_norm_le basis n _)
      (Real.sqrt_nonneg _)) _

/-! ## D. Weighted coefficient moments and cutoff rates -/

/--
A global weighted Hilbert-coordinate moment is summable and bounded by `M`, at a positive real
exponent `p`.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-DEF-005`.

Summability is essential: Lean's total `tsum` is zero for a nonsummable series, so an inequality on
`tsum` alone would not express finite regularity. This contract must be justified independently of
retained finite coefficients. It does not identify the moment with Hamiltonian energy.
-/
structure HasHilbertBasisCoefficientMomentBound
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (p M : ℝ) (f : Lp ℂ 2 μ) : Prop where
  /-- The coefficient weight has positive real exponent. -/
  exponent_pos : 0 < p
  /-- The global weighted norm-square series actually converges. -/
  summable : Summable (fun k : ℕ => ((k : ℝ) + 1) ^ p * ‖⟪basis k, f⟫_ℂ‖ ^ 2)
  /-- The convergent moment is bounded by the supplied budget. -/
  sum_le : (∑' k : ℕ, ((k : ℝ) + 1) ^ p * ‖⟪basis k, f⟫_ℂ‖ ^ 2) ≤ M

/--
A weighted coefficient-moment bound necessarily has a nonnegative budget.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-016`.
-/
lemma hilbertBasisCoefficientMomentBound_nonneg
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (p M : ℝ)
    (f : Lp ℂ 2 μ) (h : HasHilbertBasisCoefficientMomentBound basis p M f) : 0 ≤ M := by
  apply le_trans _ h.sum_le
  exact tsum_nonneg fun k => by positivity

/--
A global weighted coefficient moment bounds the discarded coefficient tail by `M / (n + 1)^p`.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-017`.

The projection retains indices strictly below `n`; therefore every discarded weight is at least
`(n + 1)^p`. The bound is valid also at cutoff zero.
-/
lemma hilbertBasisCoefficientTailEnergy_le_of_moment_bound
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p M : ℝ)
    (f : Lp ℂ 2 μ) (h : HasHilbertBasisCoefficientMomentBound basis p M f) :
    hilbertBasisCoefficientTailEnergy basis n f ≤ M / ((n : ℝ) + 1) ^ p := by
  have hs := (summable_nat_add_iff n).mpr (basis.orthonormal.inner_products_summable f)
  apply (le_div_iff₀ (Real.rpow_pos_of_pos (by positivity) p)).mpr
  rw [mul_comm, hilbertBasisCoefficientTailEnergy, ← tsum_mul_left]
  apply le_trans _ h.sum_le
  apply Summable.tsum_le_tsum_of_inj (fun k : ℕ => k + n)
    (fun _ _ he => Nat.add_right_cancel he) _ _ (hs.mul_left _) h.summable
  · intro k _
    positivity
  · intro k
    apply mul_le_mul_of_nonneg_right _ (sq_nonneg _)
    apply Real.rpow_le_rpow (by positivity) _ h.exponent_pos.le
    norm_cast
    omega

/--
The squared orbital truncation error is at most the weighted moment budget divided by `(n + 1)^p`.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-018`.
-/
lemma hilbertBasisPartialSumProjection_residual_sq_le_of_moment_bound
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p M : ℝ)
    (f : Lp ℂ 2 μ) (h : HasHilbertBasisCoefficientMomentBound basis p M f) :
    ‖f - hilbertBasisPartialSumProjection basis n f‖ ^ 2 ≤ M / ((n : ℝ) + 1) ^ p := by
  rw [hilbertBasisPartialSumProjection_residual_sq_eq_tail]
  exact hilbertBasisCoefficientTailEnergy_le_of_moment_bound basis n p M f h

/--
The orbital truncation error is bounded by the square root of the moment-based squared-error rate.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-019`.
-/
lemma hilbertBasisPartialSumProjection_residual_norm_le_of_moment_bound
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p M : ℝ)
    (f : Lp ℂ 2 μ) (h : HasHilbertBasisCoefficientMomentBound basis p M f) :
    ‖f - hilbertBasisPartialSumProjection basis n f‖ ≤
      Real.sqrt (M / ((n : ℝ) + 1) ^ p) := by
  rw [hilbertBasisPartialSumProjection_residual_norm_eq_sqrt_tail]
  exact Real.sqrt_le_sqrt (hilbertBasisCoefficientTailEnergy_le_of_moment_bound basis n p M f h)

/--
The algebraic cutoff condition `M ≤ ε² (n + 1)^p` guarantees orbital error at most `ε`.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-020`.

The tolerance is nonnegative; the moment contract, not finite observed coefficients alone,
justifies the cutoff condition.
-/
lemma hilbertBasisPartialSumProjection_residual_norm_le_of_moment_cutoff
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p M ε : ℝ)
    (f : Lp ℂ 2 μ) (h : HasHilbertBasisCoefficientMomentBound basis p M f)
    (hε : 0 ≤ ε) (hcutoff : M ≤ ε ^ 2 * ((n : ℝ) + 1) ^ p) :
    ‖f - hilbertBasisPartialSumProjection basis n f‖ ≤ ε := by
  have hs := hilbertBasisPartialSumProjection_residual_sq_le_of_moment_bound basis n p M f h
  have hc : M / ((n : ℝ) + 1) ^ p ≤ ε ^ 2 :=
    (div_le_iff₀ (Real.rpow_pos_of_pos (by positivity) p)).mpr hcutoff
  have hn := norm_nonneg (f - hilbertBasisPartialSumProjection basis n f)
  nlinarith

/--
Global component moment budgets give an explicit full matrix-valued `L¹` spin-density error rate.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-021`.

Occupations are fixed real weights and enter through absolute values. The supplied component
budgets may differ, but share one positive exponent. No numerical certificate is inferred.
-/
lemma hilbertBasisSpinDensityMatrix_sub_norm_le_moment_bound
    [Fintype Orbital]
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p : ℝ)
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ)
    (M : Orbital → Fin 2 → ℝ)
    (h : ∀ i s, HasHilbertBasisCoefficientMomentBound basis p (M i s) (orbitals i s)) :
    ‖continuumOccupationWeightedSpinDensityMatrix orbitals occupation -
      continuumOccupationWeightedSpinDensityMatrix
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n))
        occupation‖ ≤
      ∑ i : Orbital, |occupation i| *
        (∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (Real.sqrt (M i s / ((n : ℝ) + 1) ^ p) * ‖orbitals i t‖ +
              ‖orbitals i s‖ * Real.sqrt (M i t / ((n : ℝ) + 1) ^ p))) := by
  apply (hilbertBasisSpinDensityMatrix_sub_norm_le_tail basis n orbitals occupation).trans
  apply Finset.sum_le_sum
  intro i _
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  apply Finset.sum_le_sum
  intro s _
  apply Finset.sum_le_sum
  intro t _
  apply mul_le_mul_of_nonneg_left _ (norm_nonneg _)
  exact add_le_add
    (mul_le_mul_of_nonneg_right
      (Real.sqrt_le_sqrt (hilbertBasisCoefficientTailEnergy_le_of_moment_bound
        basis n p _ _ (h i s))) (norm_nonneg _))
    (mul_le_mul_of_nonneg_left
      (Real.sqrt_le_sqrt (hilbertBasisCoefficientTailEnergy_le_of_moment_bound
        basis n p _ _ (h i t))) (norm_nonneg _))

/--
Uniform component cutoff conditions give a full matrix-density error bounded by `δ` times an
explicit finite amplification factor depending only on target norms and occupations.

Project Koios declaration ID: `QM-SPIN-DENSITY-HILBERT-LEM-022`.

To guarantee a requested matrix-density tolerance, choose `δ` so this finite factor times `δ` is
within that tolerance, then check `M i s ≤ δ² (n + 1)^p` for every component.
-/
lemma hilbertBasisSpinDensityMatrix_sub_norm_le_moment_cutoff
    [Fintype Orbital]
    (basis : HilbertBasis ℕ ℂ (Lp ℂ 2 μ)) (n : ℕ) (p δ : ℝ)
    (orbitals : Orbital → ContinuumSpinor α μ) (occupation : Orbital → ℝ)
    (M : Orbital → Fin 2 → ℝ)
    (h : ∀ i s, HasHilbertBasisCoefficientMomentBound basis p (M i s) (orbitals i s))
    (hδ : 0 ≤ δ) (hcutoff : ∀ i s, M i s ≤ δ ^ 2 * ((n : ℝ) + 1) ^ p) :
    ‖continuumOccupationWeightedSpinDensityMatrix orbitals occupation -
      continuumOccupationWeightedSpinDensityMatrix
        ((hilbertBasisExpansion basis orbitals).reconstructedFamilyOn (Finset.range n))
        occupation‖ ≤
      δ * ∑ i : Orbital, |occupation i| *
        (∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (‖orbitals i t‖ + ‖orbitals i s‖)) := by
  have hsqrt : ∀ i s, Real.sqrt (M i s / ((n : ℝ) + 1) ^ p) ≤ δ := by
    intro i s
    apply (Real.sqrt_le_left hδ).mpr
    exact (div_le_iff₀ (Real.rpow_pos_of_pos (by positivity) p)).mpr (hcutoff i s)
  calc
    _ ≤ ∑ i : Orbital, |occupation i| *
        (∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (Real.sqrt (M i s / ((n : ℝ) + 1) ^ p) * ‖orbitals i t‖ +
              ‖orbitals i s‖ * Real.sqrt (M i t / ((n : ℝ) + 1) ^ p))) :=
      hilbertBasisSpinDensityMatrix_sub_norm_le_moment_bound basis n p orbitals occupation M h
    _ ≤ ∑ i : Orbital, |occupation i| *
        (∑ s : Fin 2, ∑ t : Fin 2,
          ‖(Matrix.single s t (1 : ℂ) : Matrix (Fin 2) (Fin 2) ℂ)‖ *
            (δ * ‖orbitals i t‖ + ‖orbitals i s‖ * δ)) := by
      apply Finset.sum_le_sum
      intro i _
      apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
      apply Finset.sum_le_sum
      intro s _
      apply Finset.sum_le_sum
      intro t _
      apply mul_le_mul_of_nonneg_left _ (norm_nonneg _)
      exact add_le_add (mul_le_mul_of_nonneg_right (hsqrt i s) (norm_nonneg _))
        (mul_le_mul_of_nonneg_left (hsqrt i t) (norm_nonneg _))
    _ = _ := by
      simp only [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro s _
      apply Finset.sum_congr rfl
      intro t _
      ring

end ProjectKoios.QuantumMechanics.SpinDensity

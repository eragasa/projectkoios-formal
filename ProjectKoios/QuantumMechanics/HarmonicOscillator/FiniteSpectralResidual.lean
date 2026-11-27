/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteSpectralCompression
public import Mathlib.Data.Fintype.Lattice
public import Mathlib.Analysis.Normed.Module.Normalize

/-!
# Finite oscillator eigenpair residuals in the continuum

Exact residual transport and retained-energy/eigenstate bounds for the existing oscillator matrix.

## i. Overview

For complex Euclidean coefficients `c` on `Fin (K+1)` and real trial energy `energy`, the residual is
`r = H_K c - energy • c`, where `H_K` is the existing retained diagonal Hamiltonian at physical
scale `ℏω₀`, complexified and acted on through Mathlib `Matrix.toEuclideanCLM`. No new Hamiltonian
representation is introduced. Exact spectral intertwining and the coefficient isometry give

`H̄ J_K c - energy • J_K c = J_K r` and `‖H̄ J_K c - energy • J_K c‖ = ‖r‖`.

The continuum Hamiltonian is evaluated only through the actual closure-domain embedding. For unit
coefficient norm, some retained energy `E_k` satisfies `|E_k - energy| ≤ ‖r‖`. A supplied upper bound
`‖r‖ ≤ ε` therefore yields an energy error at most `ε`; no such bound is inferred from numerical
output. With an explicitly positive gap `δ ≤ |E_k - energy|` for every retained `k ≠ j`, the
component outside the selected eigenstate span has norm at most `‖r‖ / δ`. This latter estimate is
homogeneous and does not require unit coefficients. It controls the orthogonal component, not the
distance to a phase-fixed normalized eigenvector. The gap is relative to the trial energy, not
silently a gap between neighboring exact eigenvalues.

The results apply to exact vectors in the retained oscillator eigenstate span. They neither bound
an omitted continuum tail of an unrelated state nor identify sampled/grid matrices with this exact
matrix. They do not check floating-point coefficients, rounding, quadrature, runtime residual
reports, eigensolver implementations, or a Kohn--Sham basis. No numerical certificate checker is
introduced; a residual upper bound and any gap bound remain explicit proof inputs.

## ii. Key results

- `retainedSpectralResidual`: residual of the existing finite matrix at a real trial energy.
- `retainedEigenstateHamiltonian_residual`: exact continuum residual transport.
- `norm_retainedEigenstateHamiltonian_residual`: finite/continuum residual norm equality.
- `norm_retainedSpectralResidual_normalize`: residual normalization using Mathlib `normalize`.
- `retainedSpectralResidual_exists_energy_near`: retained-level proximity for unit coefficients.
- `retainedSpectralResidual_exists_energy_near_of_norm_le`: use an independently proved upper bound.
- `retainedSpectralResidual_offEigenstate_le`: continuum orthogonal-component bound with explicit gap.

## iii. Table of contents

- A. Residual and exact transport
- B. Retained-energy proximity
- C. Selected-eigenstate component
- D. Normalized residuals
- E. Proof schematic

## iv. References

Reuses `QHO-FINITE-SPECTRAL-DEF-001/002` and `QHO-FINITE-SPECTRAL-LEM-004/005` for the selected
closure-domain embedding, isometry, existing diagonal identification, and intertwining. The finite
bounds reuse Mathlib `PiLp.norm_eq_of_L2`, `Finite.exists_min`, and
`Orthonormal.inner_right_fintype`. These are source-neutral finite-dimensional residual estimates,
not a new publication crosswalk or an identification of the selected continuum spectral measure.

## E. Proof schematic

```mermaid
flowchart TD
    residual["QHO-FINITE-RESIDUAL-DEF-001<br/>existing finite matrix residual<br/>real trial energy, Euclidean coefficients"] --> entries["QHO-FINITE-RESIDUAL-LEM-001/002<br/>coordinate equals energy difference times coefficient<br/>and its norm formula"]
    residual --> transport["QHO-FINITE-RESIDUAL-LEM-003/004/008/009<br/>isometric domain-safe transport<br/>norm equality and coefficient extraction"]
    entries --> lower["QHO-FINITE-RESIDUAL-LEM-005<br/>residual norm lower bound given uniform<br/>nonnegative retained-level separation"]
    lower --> near["QHO-FINITE-RESIDUAL-LEM-006/007<br/>proximity to some retained energy<br/>requires unit coefficients<br/>optional independently proved residual upper bound"]
    entries --> offCoeff["QHO-FINITE-RESIDUAL-LEM-010<br/>off-coordinate norm bound<br/>requires positive trial-energy gap<br/>at every other retained index"]
    offCoeff --> offState["QHO-FINITE-RESIDUAL-LEM-011<br/>phase-independent orthogonal-component bound<br/>no coefficient normalization needed"]
    transport --> offState
    transport --> normalized["QHO-FINITE-RESIDUAL-LEM-012<br/>normalized residual norm ratio<br/>unit-vector interpretation requires nonzero input"]
```
-/

@[expose] public section

open scoped BigOperators InnerProductSpace Matrix

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

/-! ## A. Residual and exact transport -/

/--
Residual of the existing complexified retained oscillator matrix at a real trial energy.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-DEF-001`.

Coefficients and residuals use Mathlib's Euclidean `ℓ²` norm. `K` is the highest retained index,
so the dimension is `K+1`. Trial energies need not be positive, and coefficients need not be unit.
-/
noncomputable def retainedSpectralResidual
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) : EuclideanSpace ℂ (Fin (K+1)) :=
  Matrix.toEuclideanCLM (n := Fin (K+1)) (𝕜 := ℂ)
    ((retainedHarmonicOscillatorHamiltonian K ((Constants.ℏ : ℝ) * Q.ω 0)).map Complex.ofReal) c -
    (energy : ℂ) • c

/--
Each residual coordinate is the coefficient times its exact physical energy difference.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-001`.
-/
lemma retainedSpectralResidual_apply
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (k : Fin (K+1)) :
    retainedSpectralResidual Q K energy c k =
      ((Q.eigenEnergy (fun _ => k.val) - energy : ℝ) : ℂ) * c k := by
  simp only [retainedSpectralResidual, PiLp.sub_apply, PiLp.smul_apply,
    retainedHamiltonian_complex_eq_eigenEnergy_diagonal]
  rw [Matrix.ofLp_toEuclideanCLM, Matrix.mulVec_diagonal]
  simp [sub_mul]

/--
A residual coordinate norm is the absolute energy difference times the coefficient norm.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-002`.
-/
lemma norm_retainedSpectralResidual_apply
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (k : Fin (K+1)) :
    ‖retainedSpectralResidual Q K energy c k‖ =
      |Q.eigenEnergy (fun _ => k.val) - energy| * ‖c k‖ := by
  rw [retainedSpectralResidual_apply, norm_mul, Complex.norm_real, Real.norm_eq_abs]

/--
Embedding a finite eigenpair residual gives exactly the continuum Hamiltonian residual.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-003`.

The continuum operator is evaluated through its explicit domain lift, without a bounded extension
or a target-state regularity assumption. Only the embedded finite-span vector is under discussion.
-/
lemma retainedEigenstateHamiltonian_residual
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) :
    Q.hamiltonian.closure (retainedEigenstateDomainEmbedding Q K c) -
      (energy : ℂ) • retainedEigenstateEmbedding Q K c =
      retainedEigenstateEmbedding Q K (retainedSpectralResidual Q K energy c) := by
  rw [retainedEigenstateHamiltonian_action]
  simp only [retainedSpectralResidual, map_sub, map_smul]

/--
The continuum residual of an embedded coefficient vector has exactly the finite residual norm.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-004`.

This transfers an independently proved residual bound, not an unchecked numerical report.
-/
lemma norm_retainedEigenstateHamiltonian_residual
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) :
    ‖Q.hamiltonian.closure (retainedEigenstateDomainEmbedding Q K c) -
      (energy : ℂ) • retainedEigenstateEmbedding Q K c‖ =
      ‖retainedSpectralResidual Q K energy c‖ := by
  rw [retainedEigenstateHamiltonian_residual, (retainedEigenstateEmbedding Q K).norm_map]

/-! ## B. Retained-energy proximity -/

/--
Uniform separation of all retained energies from the trial energy gives a residual norm lower bound.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-005`.

The nonnegative separation and the coefficient norm remain explicit; no normalization is required.
-/
lemma retainedSpectralResidual_norm_lower_bound
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (δ : ℝ) (hδ : 0 ≤ δ)
    (hgap : ∀ k : Fin (K+1), δ ≤ |Q.eigenEnergy (fun _ => k.val) - energy|) :
    δ * ‖c‖ ≤ ‖retainedSpectralResidual Q K energy c‖ := by
  have h : ‖(δ : ℂ) • c‖ ≤ ‖retainedSpectralResidual Q K energy c‖ := by
    rw [PiLp.norm_eq_of_L2, PiLp.norm_eq_of_L2]
    gcongr with k
    rw [PiLp.smul_apply, norm_smul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg hδ, norm_retainedSpectralResidual_apply]
    exact mul_le_mul_of_nonneg_right (hgap k) (norm_nonneg _)
  simpa [norm_smul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hδ] using h

/--
For unit coefficients, the trial energy is within the residual norm of some retained exact energy.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-006`.

The conclusion locates at least one retained level, not a specified or unique level. Unit norm
excludes the zero-vector loophole. No full-spectrum or spectral-measure identification is needed.
-/
lemma retainedSpectralResidual_exists_energy_near
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (hc : ‖c‖ = 1) :
    ∃ k : Fin (K+1), |Q.eigenEnergy (fun _ => k.val) - energy| ≤
      ‖retainedSpectralResidual Q K energy c‖ := by
  obtain ⟨j, hj⟩ := Finite.exists_min
    (fun k : Fin (K+1) => |Q.eigenEnergy (fun _ => k.val) - energy|)
  exact ⟨j, by simpa [hc] using
    retainedSpectralResidual_norm_lower_bound Q K energy c _ (abs_nonneg _) hj⟩

/--
An independently proved finite residual upper bound yields the same retained-energy error bound.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-007`.

`hresidual` is a proof input, not an eigensolver output accepted as exact evidence. It already
implies nonnegativity of `ε`; no additional nonnegativity premise is needed.
-/
lemma retainedSpectralResidual_exists_energy_near_of_norm_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (hc : ‖c‖ = 1) (ε : ℝ)
    (hresidual : ‖retainedSpectralResidual Q K energy c‖ ≤ ε) :
    ∃ k : Fin (K+1), |Q.eigenEnergy (fun _ => k.val) - energy| ≤ ε := by
  obtain ⟨k, hk⟩ := retainedSpectralResidual_exists_energy_near Q K energy c hc
  exact ⟨k, hk.trans hresidual⟩

/-! ## C. Selected-eigenstate component -/

/--
Embedding a single supported coefficient gives the corresponding scalar multiple of the continuum
eigenstate.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-008`.
-/
lemma retainedEigenstateEmbedding_single
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (j : Fin (K+1)) (a : ℂ) :
    retainedEigenstateEmbedding Q K (EuclideanSpace.single j a) =
      a • oneDimensionalEigenstateHilbertBasis Q j.val := by
  rw [retainedEigenstateEmbedding_apply, retainedEigenstateDomainEmbedding_coe]
  simp [EuclideanSpace.single, PiLp.single_apply]

/--
The selected continuum eigenstate inner product extracts its finite coefficient.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-009`.
-/
lemma retainedEigenstateEmbedding_inner
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (j : Fin (K+1)) :
    ⟪oneDimensionalEigenstateHilbertBasis Q j.val, retainedEigenstateEmbedding Q K c⟫_ℂ = c j := by
  rw [retainedEigenstateEmbedding_apply, retainedEigenstateDomainEmbedding_coe]
  exact (retainedEigenstateFamily_orthonormal Q K).inner_right_fintype (fun k => c k) j

/--
A positive gap from the trial energy at all other retained indices bounds the off-coordinate norm.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-010`.

The separation premise is relative to `energy`, not merely to the selected exact eigenvalue.
The estimate is homogeneous and holds without coefficient normalization, including zero coefficients.
-/
lemma retainedSpectralResidual_offCoordinate_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (j : Fin (K+1)) (δ : ℝ) (hδ : 0 < δ)
    (hgap : ∀ k : Fin (K+1), k ≠ j → δ ≤ |Q.eigenEnergy (fun _ => k.val) - energy|) :
    ‖c - EuclideanSpace.single j (c j)‖ ≤ ‖retainedSpectralResidual Q K energy c‖ / δ := by
  apply (le_div_iff₀ hδ).2
  have h : ‖(δ : ℂ) • (c - EuclideanSpace.single j (c j))‖ ≤
      ‖retainedSpectralResidual Q K energy c‖ := by
    rw [PiLp.norm_eq_of_L2, PiLp.norm_eq_of_L2]
    gcongr with k
    rw [PiLp.smul_apply, norm_smul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hδ.le]
    by_cases hk : k = j
    · subst k
      simp [EuclideanSpace.single, PiLp.sub_apply]
    · rw [PiLp.sub_apply]
      simp only [EuclideanSpace.single, PiLp.single_apply, hk, ↓reduceIte, sub_zero]
      rw [norm_retainedSpectralResidual_apply]
      exact mul_le_mul_of_nonneg_right (hgap k hk) (norm_nonneg _)
  simpa [norm_smul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hδ.le, mul_comm] using h

/--
The continuum component orthogonal to the selected eigenstate has norm at most residual norm
divided by the supplied positive gap.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-011`.

The eigenstate is normalized by the existing Hilbert basis, so subtracting its inner-product
coefficient is the orthogonal component. This is a phase-independent span estimate, not a
phase-fixed eigenvector error. No unit norm of the embedded state is required. A separately proved
residual upper bound may be substituted because `δ > 0`.
-/
lemma retainedSpectralResidual_offEigenstate_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ) (energy : ℝ)
    (c : EuclideanSpace ℂ (Fin (K+1))) (j : Fin (K+1)) (δ : ℝ) (hδ : 0 < δ)
    (hgap : ∀ k : Fin (K+1), k ≠ j → δ ≤ |Q.eigenEnergy (fun _ => k.val) - energy|) :
    ‖retainedEigenstateEmbedding Q K c -
      ⟪oneDimensionalEigenstateHilbertBasis Q j.val, retainedEigenstateEmbedding Q K c⟫_ℂ •
        oneDimensionalEigenstateHilbertBasis Q j.val‖ ≤
      ‖retainedSpectralResidual Q K energy c‖ / δ := by
  rw [retainedEigenstateEmbedding_inner, ← retainedEigenstateEmbedding_single Q K j (c j),
    ← map_sub, (retainedEigenstateEmbedding Q K).norm_map]
  exact retainedSpectralResidual_offCoordinate_le Q K energy c j δ hδ hgap

/-! ## D. Normalized residuals -/

/--
Normalizing coefficients divides the residual norm by the original coefficient norm.

Project Koios declaration ID: `QHO-FINITE-RESIDUAL-LEM-012`.

This reuses Mathlib `NormedSpace.normalize`, not another normalized-state construction. The identity
is totalized at zero, where both sides vanish; a unit-vector interpretation still requires nonzero
coefficients.
-/
lemma norm_retainedSpectralResidual_normalize
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (K : ℕ)
    (energy : ℝ) (c : EuclideanSpace ℂ (Fin (K+1))) :
    ‖retainedSpectralResidual Q K energy (NormedSpace.normalize c)‖ =
      ‖retainedSpectralResidual Q K energy c‖ / ‖c‖ := by
  have h : retainedSpectralResidual Q K energy (NormedSpace.normalize c) =
      ‖c‖⁻¹ • retainedSpectralResidual Q K energy c := by
    unfold NormedSpace.normalize retainedSpectralResidual
    rw [ContinuousLinearMap.map_smul_of_tower, smul_sub,
      smul_comm (energy : ℂ) ‖c‖⁻¹ c]
  rw [h, norm_smul, Real.norm_eq_abs, abs_of_nonneg (inv_nonneg.mpr (norm_nonneg _))]
  exact inv_mul_eq_div _ _

end ProjectKoios.QuantumMechanics.HarmonicOscillator

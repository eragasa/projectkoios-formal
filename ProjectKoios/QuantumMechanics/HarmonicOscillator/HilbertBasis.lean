/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.HarmonicOscillator.Continuum
public import ProjectKoios.QuantumMechanics.HarmonicOscillator.QuantumSystem
public import Mathlib.Analysis.InnerProductSpace.l2Space
public import Physlib.QuantumMechanics.Operators.StateObservables.ExpectedValue

/-!
# One-dimensional oscillator eigenstate Hilbert basis

Concrete Hilbert reconstruction, domain regularity, graph convergence, and quantitative energy bounds.

## i. Overview

Physlib proves orthonormality of the Cartesian harmonic-oscillator eigenstates. Project Koios proves
that their complex span is dense in `SpaceDHilbertSpace 1`. This module combines those two results
through Mathlib's `HilbertBasis.mk`, packaging the constant-index one-dimensional eigenstate family
as a countable Hilbert basis.

For a vector in `Q.hamiltonian.closure.domain`, closure extension and symmetry identify its
Hamiltonian coordinates as `Eₖ` times its orbital coordinates. Here Physlib fixes
`Eₖ = ℏ ω₀ (k + 1/2)` with positive `Constants.ℏ` and `Q.ω 0`. Parseval gives the exact squared
Hamiltonian-norm identity, and comparison with `(k+1)²` gives a summable coefficient moment bounded
by `4 ‖H̄ψ‖² / (ℏ ω₀)²`. This is exactly the closure packaged by `oneDimensionalQuantumSystem`.

Domain-valued partial sums now converge in the explicit sum graph norm
`‖Pₙψ-ψ‖ + ‖H̄Pₙψ-H̄ψ‖`. This yields convergence of Physlib's quadratic energy values, Rayleigh
quotients for nonzero targets, and normalized energy expectations for unit-norm domain targets.
Partial sums can vanish at early cutoffs; normalization is physically interpreted only once they
are nonzero, which is proved to hold eventually for a nonzero target.

The first energy moment now has an exact discarded-tail identity and a nonnegative raw quadratic
energy deficit at most `‖H̄ψ‖²/Eₙ`, where `Eₙ = ℏ ω₀ (n+1/2)`. For normalized energy values, a
positive lower bound `m` on retained squared norm `r` controls amplification: a unit target has error
at most `(‖H̄ψ‖²/Eₙ + ‖H̄ψ‖ |1-r|)/m`. Both raw and normalized estimates supply sufficient
algebraic tolerance-cutoff conditions, not numerical cutoff selection or certificates.

These are exact oscillator Hilbert-space statements, not numerical basis or quadrature validation,
Kohn--Sham eigenbasis identification, Kohn--Sham total-energy functional convergence, or numerical
energy certification. `‖H̄ψ‖²` remains distinct from the expectation `re ⟪ψ,H̄ψ⟫`; the domain premise
is essential and no converse domain characterization is proved here.

## ii. Key results

- `oneDimensionalEigenstateHilbertBasis`: the concrete countable oscillator Hilbert basis.
- `oneDimensionalHamiltonianClosure_coefficient`: Hamiltonian-domain coordinate identity.
- `oneDimensionalHamiltonianClosure_norm_sq_eq_tsum`: exact energy-weighted Parseval identity.
- `oneDimensionalHamiltonianClosure_coefficientMoment_summable`: true moment summability.
- `oneDimensionalHamiltonianClosure_coefficientMoment_le`: explicit squared-norm moment budget.
- `oneDimensionalHamiltonianClosure_graphNorm_tendsto`: graph-norm convergence on the actual domain.
- `oneDimensionalHamiltonianClosure_expectedValue_tendsto`: quadratic energy-value convergence.
- `oneDimensionalHamiltonianClosure_normalizedExpectedValue_tendsto`: normalized-state energy convergence.
- `oneDimensionalHamiltonianClosure_expectedValue_deficit_eq_tail`: exact discarded first energy moment.
- `oneDimensionalHamiltonianClosure_expectedValue_deficit_le`: explicit inverse-eigenvalue energy budget.
- `oneDimensionalHamiltonianClosure_normalizedExpectedValue_error_le`: retained-mass-safe normalized error.

## iii. Table of contents

- A. Eigenstate Hilbert basis
- B. Closure-domain coefficient regularity
- C. Graph-norm and energy-expectation convergence
- D. Quantitative energy truncation bounds
- E. Proof schematic

## iv. References

Reuses pinned Physlib `HarmonicOscillator.eigenstate_mem_hamiltonian_domain`,
`hamiltonian_eigenstate`, and `eigenEnergy_eq` in
`Physlib/QuantumMechanics/HarmonicOscillator/Eigenstates.lean`; closure extension and symmetry in
`Physlib/QuantumMechanics/Operators/Unbounded.lean`; and Mathlib `HilbertBasis.mk`,
`lp.norm_rpow_eq_tsum`, orthonormal coefficient summability, and continuity of the inner product.
Energy values directly reuse `LinearPMap.expectedValue` from
`Physlib/QuantumMechanics/Operators/StateObservables/ExpectedValue.lean`; no competing expectation
carrier or graph-space abstraction is introduced. No new publication crosswalk is asserted.

## E. Proof schematic

```mermaid
flowchart TD
    basis["QHO-HILBERT-DEF-002<br/>Physlib orthonormal eigenstates<br/>and proved dense span give Hilbert basis"] --> coeff["QHO-HILBERT-LEM-004 to 006<br/>core eigenvectors extend to selected closure<br/>domain-conditioned Hamiltonian coordinates"]
    domain["actual selected-closure-domain target"] --> coeff
    coeff --> moment["QHO-HILBERT-LEM-008 to 012<br/>Hamiltonian Parseval and summable p=2 moment<br/>physical energies hbar omega times k+1/2"]
    coeff --> partial["QHO-HILBERT-DEF-004; LEM-014 to 016<br/>domain-valued partial sums<br/>commutation and L2 image convergence"]
    partial --> graphConv["QHO-HILBERT-LEM-017/018<br/>explicit graph norm and raw quadratic-energy convergence"]
    graphConv --> normalized["QHO-HILBERT-LEM-019 to 023<br/>eventual normalization for nonzero targets<br/>Rayleigh convergence; unit target for energy limit"]
    coeff --> firstMoment["QHO-HILBERT-LEM-026 to 028<br/>genuinely summable first energy moment<br/>and exact discarded tail"]
    firstMoment --> rawError["QHO-HILBERT-LEM-029 to 031<br/>nonnegative raw deficit at most norm H psi squared / E_n<br/>using positive physical eigenvalues"]
    moment --> rawError
    rawError --> normalizedError["QHO-HILBERT-LEM-033/034<br/>normalized error with explicit norm defect<br/>requires unit target and retained mass r at least m greater than zero"]
```
-/

@[expose] public section

open scoped BigOperators InnerProductSpace Topology

open Filter

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

/-! ## A. Eigenstate Hilbert basis -/

/--
The natural-number-indexed one-dimensional Cartesian oscillator eigenstate family.

Project Koios declaration ID: `QHO-HILBERT-DEF-001`.
-/
noncomputable def oneDimensionalEigenstateFamily
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) : ℕ → Q.HS :=
  fun n => (Q.eigenstate (fun _ => n) : Q.HS)

/--
The natural-number-indexed one-dimensional oscillator eigenstate family is orthonormal.

Project Koios declaration ID: `QHO-HILBERT-LEM-001`.
-/
lemma oneDimensionalEigenstateFamily_orthonormal
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    Orthonormal ℂ (oneDimensionalEigenstateFamily Q) := by
  rw [orthonormal_iff_ite]
  intro n m
  rw [show ⟪oneDimensionalEigenstateFamily Q n,
      oneDimensionalEigenstateFamily Q m⟫_ℂ =
      δ[(fun _ : Fin 1 => n),(fun _ : Fin 1 => m)] by
    exact Q.eigenstates_orthonormal (fun _ : Fin 1 => n) (fun _ : Fin 1 => m)]
  by_cases hnm : n = m
  · subst m
    simp
  · have hfun : (fun _ : Fin 1 => n) ≠ (fun _ : Fin 1 => m) := by
      intro h
      exact hnm (congrFun h 0)
    simp [hnm, hfun]

/--
The natural-number-indexed one-dimensional oscillator eigenstate family has dense complex span.

Project Koios declaration ID: `QHO-HILBERT-LEM-002`.
-/
lemma oneDimensionalEigenstateFamily_dense
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    Dense (Submodule.span ℂ (Set.range (oneDimensionalEigenstateFamily Q)) : Set Q.HS) := by
  have hrange :
      Set.range (oneDimensionalEigenstateFamily Q) =
        Set.range (fun n : Fin 1 → ℕ => (Q.eigenstate n : Q.HS)) := by
    ext ψ
    constructor
    · rintro ⟨n, rfl⟩
      exact ⟨fun _ => n, rfl⟩
    · rintro ⟨n, rfl⟩
      refine ⟨n 0, ?_⟩
      have hn : n = fun _ => n 0 := funext fun i => congrArg n (Subsingleton.elim i 0)
      rw [hn]
      rfl
  rw [hrange]
  exact eigenstate_span_dense_one Q

/--
The one-dimensional Cartesian oscillator eigenstates packaged as a Mathlib countable Hilbert basis.

Project Koios declaration ID: `QHO-HILBERT-DEF-002`.
-/
noncomputable def oneDimensionalEigenstateHilbertBasis
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) : HilbertBasis ℕ ℂ Q.HS :=
  HilbertBasis.mk (oneDimensionalEigenstateFamily_orthonormal Q) (by
    have hd := Submodule.dense_iff_topologicalClosure_eq_top.mp
      (oneDimensionalEigenstateFamily_dense Q)
    rw [hd])

/--
The oscillator Hilbert basis evaluates to the corresponding Cartesian eigenstate.

Project Koios declaration ID: `QHO-HILBERT-LEM-003`.
-/
@[simp]
lemma oneDimensionalEigenstateHilbertBasis_apply
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ) :
    oneDimensionalEigenstateHilbertBasis Q n = oneDimensionalEigenstateFamily Q n := by
  simp [oneDimensionalEigenstateHilbertBasis]

/-! ## B. Closure-domain coefficient regularity -/

/--
Every oscillator Hilbert-basis vector belongs to the selected Hamiltonian closure domain.

Project Koios declaration ID: `QHO-HILBERT-LEM-004`.
-/
lemma oneDimensionalEigenstateHilbertBasis_mem_closure_domain
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (k : ℕ) :
    oneDimensionalEigenstateHilbertBasis Q k ∈ Q.hamiltonian.closure.domain := by
  rw [oneDimensionalEigenstateHilbertBasis_apply]
  exact Q.hamiltonian.le_closure.1 (Q.eigenstate_mem_hamiltonian_domain (fun _ => k))

/--
The selected closure acts on oscillator Hilbert-basis vectors by the same eigenvalues as the core.

Project Koios declaration ID: `QHO-HILBERT-LEM-005`.
-/
lemma oneDimensionalHamiltonianClosure_eigenstate
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (k : ℕ) :
    Q.hamiltonian.closure ⟨oneDimensionalEigenstateHilbertBasis Q k,
      oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k⟩ =
      (Q.eigenEnergy (fun _ => k) : ℂ) • oneDimensionalEigenstateHilbertBasis Q k := by
  have h := Q.hamiltonian.le_closure.2
    (x := ⟨Q.eigenstate (fun _ => k), Q.eigenstate_mem_hamiltonian_domain (fun _ => k)⟩)
    (y := ⟨oneDimensionalEigenstateHilbertBasis Q k,
      oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k⟩)
    (by simp [oneDimensionalEigenstateFamily])
  rw [← h]
  simpa [oneDimensionalEigenstateFamily] using Q.hamiltonian_eigenstate (fun _ => k)
    (Q.eigenstate_mem_hamiltonian_domain (fun _ => k))

/--
For a vector in the selected closure domain, its Hamiltonian coordinates are the orbital
coordinates multiplied by the real oscillator eigenvalues.

Project Koios declaration ID: `QHO-HILBERT-LEM-006`.
-/
lemma oneDimensionalHamiltonianClosure_coefficient
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) (k : ℕ) :
    ⟪oneDimensionalEigenstateHilbertBasis Q k, Q.hamiltonian.closure ψ⟫_ℂ =
      (Q.eigenEnergy (fun _ => k) : ℂ) *
        ⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ := by
  have hsym : Q.hamiltonian.closure.IsSymmetric :=
    LinearPMap.IsSelfAdjoint.isSymmetric
      (oneDimensionalQuantumSystem_hamiltonian_isSelfAdjoint Q)
  have heq := hsym ⟨oneDimensionalEigenstateHilbertBasis Q k,
    oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k⟩ ψ
  change ⟪Q.hamiltonian.closure ⟨oneDimensionalEigenstateHilbertBasis Q k,
    oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k⟩, (ψ : Q.HS)⟫_ℂ =
    ⟪oneDimensionalEigenstateHilbertBasis Q k, Q.hamiltonian.closure ψ⟫_ℂ at heq
  rw [← heq, oneDimensionalHamiltonianClosure_eigenstate, inner_smul_left]
  simp

/--
The one-dimensional oscillator eigenvalue is `ℏ ω₀ (k + 1/2)` in the adopted Physlib convention.

Project Koios declaration ID: `QHO-HILBERT-LEM-007`.
-/
lemma oneDimensionalEigenEnergy_eq
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (k : ℕ) :
    Q.eigenEnergy (fun _ => k) = (Constants.ℏ : ℝ) * Q.ω 0 * ((k : ℝ) + 1/2) := by
  simp [Q.eigenEnergy_eq]

/--
Energy-squared-weighted oscillator coefficients are summable for every vector in the closure domain.

Project Koios declaration ID: `QHO-HILBERT-LEM-008`.
-/
lemma oneDimensionalHamiltonianClosure_energyCoefficients_summable
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) :
    Summable (fun k : ℕ => Q.eigenEnergy (fun _ => k) ^ 2 *
      ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖ ^ 2) := by
  have h := (oneDimensionalEigenstateHilbertBasis Q).orthonormal.inner_products_summable
    (Q.hamiltonian.closure ψ)
  simpa only [oneDimensionalHamiltonianClosure_coefficient, norm_mul, mul_pow,
    Complex.norm_real, Real.norm_eq_abs, sq_abs] using h

/--
The squared Hamiltonian norm equals the energy-squared-weighted coefficient sum.

Project Koios declaration ID: `QHO-HILBERT-LEM-009`.

The input lies in `Q.hamiltonian.closure.domain`. This is a Parseval identity for `H̄ψ`, not an
energy-expectation identity or a converse domain characterization.
-/
lemma oneDimensionalHamiltonianClosure_norm_sq_eq_tsum
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) :
    ‖Q.hamiltonian.closure ψ‖ ^ 2 =
      ∑' k : ℕ, Q.eigenEnergy (fun _ => k) ^ 2 *
        ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖ ^ 2 := by
  have h := lp.norm_rpow_eq_tsum (p := (2 : ENNReal)) (by norm_num)
    ((oneDimensionalEigenstateHilbertBasis Q).repr (Q.hamiltonian.closure ψ))
  simpa only [ENNReal.toReal_ofNat, Real.rpow_two,
    (oneDimensionalEigenstateHilbertBasis Q).repr.norm_map, HilbertBasis.repr_apply_apply,
    oneDimensionalHamiltonianClosure_coefficient, norm_mul, mul_pow, Complex.norm_real,
    Real.norm_eq_abs, sq_abs] using h

/--
A concrete coefficient-moment budget derived from the Hamiltonian norm on its selected domain.

Project Koios declaration ID: `QHO-HILBERT-DEF-003`.

The value is `4 ‖H̄ψ‖² / (ℏ ω₀)²`. It is not a supplied bound on arbitrary `L²` functions and is not
an energy expectation or a numerical certificate.
-/
noncomputable def oneDimensionalHamiltonianMomentBudget
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) : ℝ :=
  4 / ((Constants.ℏ : ℝ) * Q.ω 0) ^ 2 * ‖Q.hamiltonian.closure ψ‖ ^ 2

/--
The weight `(k+1)²` is bounded by `4 Eₖ² / (ℏ ω₀)²`.

Project Koios declaration ID: `QHO-HILBERT-LEM-010`.
-/
lemma oneDimensionalEigenEnergy_weight_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (k : ℕ) :
    ((k : ℝ) + 1) ^ 2 ≤
      (4 / ((Constants.ℏ : ℝ) * Q.ω 0) ^ 2) * Q.eigenEnergy (fun _ => k) ^ 2 := by
  have ha : (Constants.ℏ : ℝ) * Q.ω 0 ≠ 0 :=
    ne_of_gt (mul_pos Constants.ℏ_pos (Q.ω_pos 0))
  calc
    _ ≤ 4 * ((k : ℝ) + 1/2) ^ 2 := by nlinarith [Nat.cast_nonneg (α := ℝ) k]
    _ = _ := by rw [oneDimensionalEigenEnergy_eq]; field_simp

/--
The global `(k+1)²` coefficient moment is genuinely summable on the selected Hamiltonian domain.

Project Koios declaration ID: `QHO-HILBERT-LEM-011`.
-/
lemma oneDimensionalHamiltonianClosure_coefficientMoment_summable
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) :
    Summable (fun k : ℕ => ((k : ℝ) + 1) ^ 2 *
      ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖ ^ 2) := by
  apply (oneDimensionalHamiltonianClosure_energyCoefficients_summable Q ψ).mul_left
    (4 / ((Constants.ℏ : ℝ) * Q.ω 0) ^ 2) |>.of_nonneg_of_le
  · intro k
    positivity
  · intro k
    have h := mul_le_mul_of_nonneg_right (oneDimensionalEigenEnergy_weight_le Q k)
      (sq_nonneg ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖)
    simpa only [mul_assoc] using h

/--
The global `(k+1)²` coefficient moment is bounded by the derived Hamiltonian-norm budget.

Project Koios declaration ID: `QHO-HILBERT-LEM-012`.
-/
lemma oneDimensionalHamiltonianClosure_coefficientMoment_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) :
    (∑' k : ℕ, ((k : ℝ) + 1) ^ 2 *
      ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖ ^ 2) ≤
      oneDimensionalHamiltonianMomentBudget Q ψ := by
  have h := (oneDimensionalHamiltonianClosure_coefficientMoment_summable Q ψ).tsum_le_tsum
    (fun k => by
      have h := mul_le_mul_of_nonneg_right (oneDimensionalEigenEnergy_weight_le Q k)
        (sq_nonneg ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖)
      simpa only [mul_assoc] using h)
    ((oneDimensionalHamiltonianClosure_energyCoefficients_summable Q ψ).mul_left
      (4 / ((Constants.ℏ : ℝ) * Q.ω 0) ^ 2))
  simpa only [tsum_mul_left, ← oneDimensionalHamiltonianClosure_norm_sq_eq_tsum Q ψ,
    oneDimensionalHamiltonianMomentBudget] using h

/-! ## C. Graph-norm and energy-expectation convergence -/

/--
The oscillator Hilbert partial sum lifted into the selected Hamiltonian closure domain.

Project Koios declaration ID: `QHO-HILBERT-DEF-004`.

Every finite sum of eigenstates lies in the domain even when the supplied `L²` vector does not.
This is a domain-valued lift of the existing coefficient truncation, not a new operator or choice
of self-adjoint extension.
-/
noncomputable def oneDimensionalEigenstateDomainPartialSum
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ) (ψ : Q.HS) :
    Q.hamiltonian.closure.domain :=
  ∑ k ∈ Finset.range n, ⟪oneDimensionalEigenstateHilbertBasis Q k, ψ⟫_ℂ •
    ⟨oneDimensionalEigenstateHilbertBasis Q k,
      oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k⟩

/--
The domain-valued oscillator partial sum has the expected ambient Hilbert expansion.

Project Koios declaration ID: `QHO-HILBERT-LEM-013`.
-/
lemma oneDimensionalEigenstateDomainPartialSum_coe
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ) (ψ : Q.HS) :
    (oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS) =
      ∑ k ∈ Finset.range n, ⟪oneDimensionalEigenstateHilbertBasis Q k, ψ⟫_ℂ •
        oneDimensionalEigenstateHilbertBasis Q k := by
  simp [oneDimensionalEigenstateDomainPartialSum]

/--
Applying the selected closure to the partial sum of a domain vector gives the Hilbert partial sum
of its Hamiltonian image.

Project Koios declaration ID: `QHO-HILBERT-LEM-014`.

The domain premise is essential: the right-hand side uses the actual image `H̄ψ`.
-/
lemma oneDimensionalHamiltonianClosure_domainPartialSum
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) :
    Q.hamiltonian.closure (oneDimensionalEigenstateDomainPartialSum Q n ψ) =
      ∑ k ∈ Finset.range n,
        ⟪oneDimensionalEigenstateHilbertBasis Q k, Q.hamiltonian.closure ψ⟫_ℂ •
          oneDimensionalEigenstateHilbertBasis Q k := by
  change Q.hamiltonian.closure.toFun (∑ k ∈ Finset.range n,
    ⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ •
      ⟨oneDimensionalEigenstateHilbertBasis Q k,
        oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k⟩) = _
  rw [map_sum]
  simp only [map_smul]
  change (∑ k ∈ Finset.range n,
    ⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ •
      (Q.hamiltonian.closure ⟨oneDimensionalEigenstateHilbertBasis Q k,
        oneDimensionalEigenstateHilbertBasis_mem_closure_domain Q k⟩)) = _
  simp only [oneDimensionalHamiltonianClosure_eigenstate,
    oneDimensionalHamiltonianClosure_coefficient, smul_smul]
  apply Finset.sum_congr rfl
  intro k _
  rw [mul_comm]

/--
Ambient oscillator partial sums converge in `L²` for every supplied `L²` vector.

Project Koios declaration ID: `QHO-HILBERT-LEM-015`.
-/
lemma oneDimensionalEigenstateDomainPartialSum_tendsto
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.HS) :
    Tendsto (fun n => (oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)) atTop (𝓝 ψ) := by
  simpa only [oneDimensionalEigenstateDomainPartialSum_coe, HilbertBasis.repr_apply_apply] using
    ((oneDimensionalEigenstateHilbertBasis Q).hasSum_repr ψ).tendsto_sum_nat

/--
The Hamiltonian images of oscillator partial sums converge in `L²` for every selected-closure-domain
vector.

Project Koios declaration ID: `QHO-HILBERT-LEM-016`.
-/
lemma oneDimensionalHamiltonianClosure_domainPartialSum_tendsto
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.hamiltonian.closure.domain) :
    Tendsto (fun n => Q.hamiltonian.closure (oneDimensionalEigenstateDomainPartialSum Q n ψ))
      atTop (𝓝 (Q.hamiltonian.closure ψ)) := by
  simpa only [oneDimensionalHamiltonianClosure_domainPartialSum,
    HilbertBasis.repr_apply_apply] using
    ((oneDimensionalEigenstateHilbertBasis Q).hasSum_repr (Q.hamiltonian.closure ψ)).tendsto_sum_nat

/--
Oscillator partial sums converge in the Hamiltonian graph norm on the selected closure domain.

Project Koios declaration ID: `QHO-HILBERT-LEM-017`.

The graph norm is expressed explicitly as the sum
`‖Pₙψ-ψ‖ + ‖H̄Pₙψ-H̄ψ‖`. This is not convergence in the domain subtype's inherited `L²` norm alone,
and no alternative bundled graph-space or operator abstraction is introduced.
-/
lemma oneDimensionalHamiltonianClosure_graphNorm_tendsto
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.hamiltonian.closure.domain) :
    Tendsto (fun n => ‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS) - ψ‖ +
      ‖Q.hamiltonian.closure (oneDimensionalEigenstateDomainPartialSum Q n ψ) -
        Q.hamiltonian.closure ψ‖) atTop (𝓝 0) := by
  have h₁ := ((oneDimensionalEigenstateDomainPartialSum_tendsto Q ψ).sub
    (tendsto_const_nhds (x := (ψ : Q.HS)))).norm
  have h₂ := ((oneDimensionalHamiltonianClosure_domainPartialSum_tendsto Q ψ).sub
    (tendsto_const_nhds (x := Q.hamiltonian.closure ψ))).norm
  simpa using h₁.add h₂

/--
Physlib's real quadratic energy value of oscillator partial sums converges on the selected closure
domain.

Project Koios declaration ID: `QHO-HILBERT-LEM-018`.

This reuses `LinearPMap.expectedValue = re ⟪ψ,H̄ψ⟫`. The partial sums are generally not normalized;
normalized-state energy convergence is stated separately below.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_tendsto
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.hamiltonian.closure.domain) :
    Tendsto (fun n => Q.hamiltonian.closure.expectedValue
      (oneDimensionalEigenstateDomainPartialSum Q n ψ)) atTop
      (𝓝 (Q.hamiltonian.closure.expectedValue ψ)) := by
  have h := (oneDimensionalEigenstateDomainPartialSum_tendsto Q ψ).inner (𝕜 := ℂ)
    (oneDimensionalHamiltonianClosure_domainPartialSum_tendsto Q ψ)
  exact Complex.continuous_re.continuousAt.tendsto.comp h

/--
For a nonzero target, oscillator partial sums are nonzero at every sufficiently large cutoff.

Project Koios declaration ID: `QHO-HILBERT-LEM-019`.

Early partial sums may vanish; no normalization claim is made about those cutoffs.
-/
lemma oneDimensionalEigenstateDomainPartialSum_eventually_ne_zero
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.HS) (hψ : ψ ≠ 0) :
    ∀ᶠ n in atTop, (oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS) ≠ 0 :=
  (oneDimensionalEigenstateDomainPartialSum_tendsto Q ψ).eventually_ne hψ

/--
The energy value of the norm-rescaled domain vector equals its Rayleigh quotient.

Project Koios declaration ID: `QHO-HILBERT-LEM-020`.

The algebraic equality is totalized at zero, where both sides vanish. Its normalized-state
interpretation requires a nonzero vector. Scalar rescaling remains inside the selected domain.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_normalize_eq
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.hamiltonian.closure.domain) :
    Q.hamiltonian.closure.expectedValue ((‖(ψ : Q.HS)‖ : ℂ)⁻¹ • ψ) =
      Q.hamiltonian.closure.expectedValue ψ / ‖(ψ : Q.HS)‖ ^ 2 := by
  have hsmul : Q.hamiltonian.closure ((‖(ψ : Q.HS)‖ : ℂ)⁻¹ • ψ) =
      (‖(ψ : Q.HS)‖ : ℂ)⁻¹ • Q.hamiltonian.closure ψ :=
    Q.hamiltonian.closure.toFun.map_smul _ _
  simp only [LinearPMap.expectedValue, SetLike.val_smul, hsmul, inner_smul_left,
    inner_smul_right, map_inv₀]
  by_cases hn : ‖(ψ : Q.HS)‖ = 0
  · simp [hn]
  · simp [Complex.mul_re, div_eq_mul_inv, pow_two, mul_assoc]
    field_simp

/--
Norm-rescaled oscillator partial sums of a nonzero target eventually have unit `L²` norm.

Project Koios declaration ID: `QHO-HILBERT-LEM-021`.
-/
lemma oneDimensionalEigenstateDomainPartialSum_normalized_eventually_unit
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.HS) (hψ : ψ ≠ 0) :
    ∀ᶠ n in atTop,
      ‖(((‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ : ℂ)⁻¹ •
        oneDimensionalEigenstateDomainPartialSum Q n ψ :
          Q.hamiltonian.closure.domain) : Q.HS)‖ = 1 := by
  filter_upwards [oneDimensionalEigenstateDomainPartialSum_eventually_ne_zero Q ψ hψ] with n hn
  simp [norm_smul, hn]

/--
Oscillator partial-sum Rayleigh quotients converge for every nonzero selected-closure-domain target.

Project Koios declaration ID: `QHO-HILBERT-LEM-022`.

The nonzero target hypothesis makes the limiting denominator nonzero. The earlier eventual-nonzero
lemma supplies the normalized-state interpretation at all sufficiently large cutoffs.
-/
lemma oneDimensionalHamiltonianClosure_rayleighQuotient_tendsto
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) (hψ : (ψ : Q.HS) ≠ 0) :
    Tendsto (fun n => Q.hamiltonian.closure.expectedValue
      (oneDimensionalEigenstateDomainPartialSum Q n ψ) /
      ‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ ^ 2) atTop
      (𝓝 (Q.hamiltonian.closure.expectedValue ψ / ‖(ψ : Q.HS)‖ ^ 2)) := by
  exact (oneDimensionalHamiltonianClosure_expectedValue_tendsto Q ψ).div
    ((oneDimensionalEigenstateDomainPartialSum_tendsto Q ψ).norm.pow 2)
    (pow_ne_zero 2 (norm_ne_zero_iff.mpr hψ))

/--
Normalized oscillator partial sums have energy expectations converging to that of a unit-norm
selected-closure-domain target.

Project Koios declaration ID: `QHO-HILBERT-LEM-023`.

The approximants are norm-rescaled inside the actual domain. They are eventually unit vectors,
not necessarily nonzero or unit vectors at every early cutoff. This is an analytic oscillator
energy-expectation result, not convergence of a Kohn--Sham total-energy functional or numerical
certification.
-/
lemma oneDimensionalHamiltonianClosure_normalizedExpectedValue_tendsto
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) (hψ : ‖(ψ : Q.HS)‖ = 1) :
    Tendsto (fun n => Q.hamiltonian.closure.expectedValue
      ((‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ : ℂ)⁻¹ •
        oneDimensionalEigenstateDomainPartialSum Q n ψ)) atTop
      (𝓝 (Q.hamiltonian.closure.expectedValue ψ)) := by
  have hn : (ψ : Q.HS) ≠ 0 := by
    intro hz
    simp [hz] at hψ
  have h := oneDimensionalHamiltonianClosure_rayleighQuotient_tendsto Q ψ hn
  simpa only [oneDimensionalHamiltonianClosure_expectedValue_normalize_eq,
    hψ, one_pow, div_one] using h

/-! ## D. Quantitative energy truncation bounds -/

/--
Every one-dimensional oscillator eigenvalue is strictly positive in the adopted convention.

Project Koios declaration ID: `QHO-HILBERT-LEM-024`.
-/
lemma oneDimensionalEigenEnergy_pos
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (k : ℕ) :
    0 < Q.eigenEnergy (fun _ => k) := by
  rw [oneDimensionalEigenEnergy_eq]
  exact mul_pos (mul_pos Constants.ℏ_pos (Q.ω_pos 0)) (by positivity)

/--
The real coordinate product in the energy expansion equals `Eₖ` times the squared orbital
coefficient norm.

Project Koios declaration ID: `QHO-HILBERT-LEM-025`.
-/
lemma oneDimensionalHamiltonianClosure_coefficientProduct_re
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (ψ : Q.hamiltonian.closure.domain) (k : ℕ) :
    (⟪(ψ : Q.HS), oneDimensionalEigenstateHilbertBasis Q k⟫_ℂ *
      ⟪oneDimensionalEigenstateHilbertBasis Q k, Q.hamiltonian.closure ψ⟫_ℂ).re =
      Q.eigenEnergy (fun _ => k) *
        ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖ ^ 2 := by
  rw [oneDimensionalHamiltonianClosure_coefficient,
    ← inner_conj_symm (ψ : Q.HS) (oneDimensionalEigenstateHilbertBasis Q k)]
  rw [mul_left_comm, ← Complex.normSq_eq_conj_mul_self,
    ← Complex.ofReal_mul, Complex.ofReal_re, Complex.normSq_eq_norm_sq]

/--
The eigenvalue-weighted coefficient series genuinely sums to Physlib's real quadratic energy value
on the selected closure domain.

Project Koios declaration ID: `QHO-HILBERT-LEM-026`.

This is the first energy moment `∑ Eₖ |cₖ|²`, distinct from the squared-Hamiltonian-norm identity
with weights `Eₖ²`. The `HasSum` conclusion supplies actual summability, not merely a totalized
`tsum` equality.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_hasSum
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.hamiltonian.closure.domain) :
    HasSum (fun k : ℕ => Q.eigenEnergy (fun _ => k) *
      ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖ ^ 2)
      (Q.hamiltonian.closure.expectedValue ψ) := by
  have h := ((oneDimensionalEigenstateHilbertBasis Q).hasSum_inner_mul_inner
    (ψ : Q.HS) (Q.hamiltonian.closure ψ)).mapL Complex.reCLM
  simpa only [Complex.reCLM_apply, oneDimensionalHamiltonianClosure_coefficientProduct_re,
    LinearPMap.expectedValue] using h

/--
The quadratic energy of a domain-valued oscillator partial sum is its retained finite
energy-weighted coefficient sum.

Project Koios declaration ID: `QHO-HILBERT-LEM-027`.

The partial sum is not renormalized in this identity.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_domainPartialSum_eq_sum
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) :
    Q.hamiltonian.closure.expectedValue (oneDimensionalEigenstateDomainPartialSum Q n ψ) =
      ∑ k ∈ Finset.range n, Q.eigenEnergy (fun _ => k) *
        ‖⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ‖ ^ 2 := by
  rw [LinearPMap.expectedValue, oneDimensionalEigenstateDomainPartialSum_coe,
    oneDimensionalHamiltonianClosure_domainPartialSum,
    (oneDimensionalEigenstateHilbertBasis Q).orthonormal.inner_sum]
  change Complex.reCLM (∑ k ∈ Finset.range n,
    (starRingEnd ℂ) ⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ *
      ⟪oneDimensionalEigenstateHilbertBasis Q k, Q.hamiltonian.closure ψ⟫_ℂ) = _
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro k _
  change Complex.re ((starRingEnd ℂ) ⟪oneDimensionalEigenstateHilbertBasis Q k, (ψ : Q.HS)⟫_ℂ *
    ⟪oneDimensionalEigenstateHilbertBasis Q k, Q.hamiltonian.closure ψ⟫_ℂ) = _
  rw [inner_conj_symm]
  exact oneDimensionalHamiltonianClosure_coefficientProduct_re Q ψ k

/--
The exact discarded quadratic energy equals the omitted energy-weighted coefficient tail.

Project Koios declaration ID: `QHO-HILBERT-LEM-028`.

The cutoff retains indices strictly below `n`; the first omitted eigenvalue is
`Eₙ = ℏ ω₀ (n+1/2)`. The target lies in the actual selected Hamiltonian closure domain.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_deficit_eq_tail
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) :
    Q.hamiltonian.closure.expectedValue ψ -
      Q.hamiltonian.closure.expectedValue (oneDimensionalEigenstateDomainPartialSum Q n ψ) =
      ∑' k : ℕ, Q.eigenEnergy (fun _ => k + n) *
        ‖⟪oneDimensionalEigenstateHilbertBasis Q (k + n), (ψ : Q.HS)⟫_ℂ‖ ^ 2 := by
  have h := (oneDimensionalHamiltonianClosure_expectedValue_hasSum Q ψ).summable.sum_add_tsum_nat_add n
  rw [(oneDimensionalHamiltonianClosure_expectedValue_hasSum Q ψ).tsum_eq] at h
  rw [oneDimensionalHamiltonianClosure_expectedValue_domainPartialSum_eq_sum]
  linarith

/--
The raw quadratic energy deficit under oscillator coefficient truncation is nonnegative.

Project Koios declaration ID: `QHO-HILBERT-LEM-029`.

This does not compare renormalized energy values or assert pointwise density ordering.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_deficit_nonneg
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) :
    0 ≤ Q.hamiltonian.closure.expectedValue ψ -
      Q.hamiltonian.closure.expectedValue (oneDimensionalEigenstateDomainPartialSum Q n ψ) := by
  rw [oneDimensionalHamiltonianClosure_expectedValue_deficit_eq_tail]
  exact tsum_nonneg fun k => mul_nonneg (oneDimensionalEigenEnergy_pos Q _).le (sq_nonneg _)

/--
The discarded quadratic energy is at most `‖H̄ψ‖² / Eₙ` on the selected closure domain.

Project Koios declaration ID: `QHO-HILBERT-LEM-030`.

Positivity and ordering of the actual oscillator eigenvalues control every omitted coefficient.
This explicit inverse-linear bound is valid even at cutoff zero. A numerical guarantee still
requires a checked bound on the Hamiltonian norm.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_deficit_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) :
    Q.hamiltonian.closure.expectedValue ψ -
      Q.hamiltonian.closure.expectedValue (oneDimensionalEigenstateDomainPartialSum Q n ψ) ≤
      ‖Q.hamiltonian.closure ψ‖ ^ 2 / Q.eigenEnergy (fun _ => n) := by
  rw [oneDimensionalHamiltonianClosure_expectedValue_deficit_eq_tail]
  apply (le_div_iff₀ (oneDimensionalEigenEnergy_pos Q n)).mpr
  rw [mul_comm, ← tsum_mul_left, oneDimensionalHamiltonianClosure_norm_sq_eq_tsum]
  have hs := (summable_nat_add_iff n).mpr
    (oneDimensionalHamiltonianClosure_expectedValue_hasSum Q ψ).summable
  apply Summable.tsum_le_tsum_of_inj (fun k : ℕ => k + n)
    (fun _ _ h => Nat.add_right_cancel h) _ _ (hs.mul_left _)
    (oneDimensionalHamiltonianClosure_energyCoefficients_summable Q ψ)
  · intro k _
    exact mul_nonneg (sq_nonneg _) (sq_nonneg _)
  · intro k
    have henergy : Q.eigenEnergy (fun _ => n) ≤ Q.eigenEnergy (fun _ => k + n) := by
      simp only [oneDimensionalEigenEnergy_eq, Nat.cast_add]
      have ha := mul_pos Constants.ℏ_pos (Q.ω_pos 0)
      nlinarith [Nat.cast_nonneg (α := ℝ) k]
    have h := mul_le_mul_of_nonneg_right henergy
      (mul_nonneg (oneDimensionalEigenEnergy_pos Q (k+n)).le
        (sq_nonneg ‖⟪oneDimensionalEigenstateHilbertBasis Q (k+n), (ψ : Q.HS)⟫_ℂ‖))
    nlinarith only [h]

/--
The cutoff condition `‖H̄ψ‖² ≤ ε Eₙ` guarantees a quadratic energy deficit between zero and `ε`.

Project Koios declaration ID: `QHO-HILBERT-LEM-031`.

This is a sufficient analytic condition, not a numerical cutoff-selection or certification routine.
-/
lemma oneDimensionalHamiltonianClosure_expectedValue_deficit_le_of_cutoff
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) (ε : ℝ)
    (hcutoff : ‖Q.hamiltonian.closure ψ‖ ^ 2 ≤ ε * Q.eigenEnergy (fun _ => n)) :
    0 ≤ Q.hamiltonian.closure.expectedValue ψ -
      Q.hamiltonian.closure.expectedValue (oneDimensionalEigenstateDomainPartialSum Q n ψ) ∧
    Q.hamiltonian.closure.expectedValue ψ -
      Q.hamiltonian.closure.expectedValue (oneDimensionalEigenstateDomainPartialSum Q n ψ) ≤ ε := by
  exact ⟨oneDimensionalHamiltonianClosure_expectedValue_deficit_nonneg Q n ψ,
    (oneDimensionalHamiltonianClosure_expectedValue_deficit_le Q n ψ).trans
      ((div_le_iff₀ (oneDimensionalEigenEnergy_pos Q n)).mpr hcutoff)⟩

/--
The magnitude of the real quadratic energy value is bounded by `‖ψ‖ ‖H̄ψ‖`.

Project Koios declaration ID: `QHO-HILBERT-LEM-032`.

This directly reuses Mathlib's real-part bound and Cauchy--Schwarz inequality.
-/
lemma oneDimensionalHamiltonianClosure_abs_expectedValue_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (ψ : Q.hamiltonian.closure.domain) :
    |Q.hamiltonian.closure.expectedValue ψ| ≤ ‖(ψ : Q.HS)‖ * ‖Q.hamiltonian.closure ψ‖ :=
  (Complex.abs_re_le_norm _).trans (norm_inner_le_norm (𝕜 := ℂ) _ _)

/--
A normalized partial-sum energy-error bound controlled by a positive retained squared-norm lower
bound `m`, the Hamiltonian norm, and the retained normalization defect.

Project Koios declaration ID: `QHO-HILBERT-LEM-033`.

For a unit target and retained squared norm `r ≥ m > 0`, the error is at most
`(‖H̄ψ‖²/Eₙ + ‖H̄ψ‖ |1-r|) / m`. The retained-norm premise excludes vanishing early partial sums
at the chosen cutoff; the normalization contribution is explicit rather than silently omitted.
No monotonicity assertion about normalized energy values is needed or made.
-/
lemma oneDimensionalHamiltonianClosure_normalizedExpectedValue_error_le
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) (hunit : ‖(ψ : Q.HS)‖ = 1) (m : ℝ) (hm : 0 < m)
    (hretained : m ≤ ‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ ^ 2) :
    |Q.hamiltonian.closure.expectedValue
      ((‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ : ℂ)⁻¹ •
        oneDimensionalEigenstateDomainPartialSum Q n ψ) - Q.hamiltonian.closure.expectedValue ψ| ≤
      (‖Q.hamiltonian.closure ψ‖ ^ 2 / Q.eigenEnergy (fun _ => n) +
        ‖Q.hamiltonian.closure ψ‖ *
          |‖(ψ : Q.HS)‖ ^ 2 - ‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ ^ 2|) / m := by
  rw [oneDimensionalHamiltonianClosure_expectedValue_normalize_eq, hunit, one_pow]
  let q := Q.hamiltonian.closure.expectedValue ψ
  let qn := Q.hamiltonian.closure.expectedValue (oneDimensionalEigenstateDomainPartialSum Q n ψ)
  let r := ‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ ^ 2
  let B := ‖Q.hamiltonian.closure ψ‖ ^ 2 / Q.eigenEnergy (fun _ => n)
  change |qn / r - q| ≤ (B + ‖Q.hamiltonian.closure ψ‖ * |1-r|) / m
  have hr : 0 < r := lt_of_lt_of_le hm hretained
  have hD : 0 ≤ q-qn := oneDimensionalHamiltonianClosure_expectedValue_deficit_nonneg Q n ψ
  have hDB : q-qn ≤ B := oneDimensionalHamiltonianClosure_expectedValue_deficit_le Q n ψ
  have heq : qn / r - q = (qn - q*r) / r := by field_simp
  have hq : |q| ≤ ‖Q.hamiltonian.closure ψ‖ := by
    simpa only [hunit, one_mul] using oneDimensionalHamiltonianClosure_abs_expectedValue_le Q ψ
  have hnum : |qn-q*r| ≤ B + ‖Q.hamiltonian.closure ψ‖ * |1-r| := by
    calc
      _ = |-(q-qn)+q*(1-r)| := by congr 1; ring
      _ ≤ |-(q-qn)| + |q*(1-r)| := abs_add_le _ _
      _ = (q-qn) + |q| * |1-r| := by rw [abs_neg, abs_of_nonneg hD, abs_mul]
      _ ≤ _ := add_le_add hDB (mul_le_mul_of_nonneg_right hq (abs_nonneg _))
  rw [heq, abs_div, abs_of_pos hr]
  have hB : 0 ≤ B := div_nonneg (sq_nonneg _) (oneDimensionalEigenEnergy_pos Q n).le
  exact div_le_div₀ (add_nonneg hB (mul_nonneg (norm_nonneg _) (abs_nonneg _))) hnum hm hretained

/--
A retained-mass lower bound and an explicit energy/normalization budget imply a requested normalized
energy tolerance.

Project Koios declaration ID: `QHO-HILBERT-LEM-034`.

The sufficient cutoff condition is `‖H̄ψ‖²/Eₙ + ‖H̄ψ‖ |1-r| ≤ m ε`, together with `r ≥ m > 0`
and unit target norm. Certification of numerical Hamiltonian norms and retained mass is external.
-/
lemma oneDimensionalHamiltonianClosure_normalizedExpectedValue_error_le_of_cutoff
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (n : ℕ)
    (ψ : Q.hamiltonian.closure.domain) (hunit : ‖(ψ : Q.HS)‖ = 1)
    (m ε : ℝ) (hm : 0 < m)
    (hretained : m ≤ ‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ ^ 2)
    (hcutoff : ‖Q.hamiltonian.closure ψ‖ ^ 2 / Q.eigenEnergy (fun _ => n) +
      ‖Q.hamiltonian.closure ψ‖ *
        |‖(ψ : Q.HS)‖ ^ 2 - ‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ ^ 2| ≤ m * ε) :
    |Q.hamiltonian.closure.expectedValue
      ((‖(oneDimensionalEigenstateDomainPartialSum Q n ψ : Q.HS)‖ : ℂ)⁻¹ •
        oneDimensionalEigenstateDomainPartialSum Q n ψ) - Q.hamiltonian.closure.expectedValue ψ| ≤ ε := by
  apply (oneDimensionalHamiltonianClosure_normalizedExpectedValue_error_le
    Q n ψ hunit m hm hretained).trans
  exact (div_le_iff₀ hm).mpr (by simpa only [mul_comm m ε] using hcutoff)

end ProjectKoios.QuantumMechanics.HarmonicOscillator

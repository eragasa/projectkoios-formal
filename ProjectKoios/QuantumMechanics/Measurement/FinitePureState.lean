/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.QuantumMechanics.State
public import Mathlib.Algebra.Order.BigOperators.Group.Finset
public import Mathlib.Analysis.Normed.Module.Normalize
public import Mathlib.Analysis.Normed.Operator.Basic

/-!
# Finite pure-state measurement contracts

This module defines a finite family of bounded complex-linear measurement operations whose
squared output norms resolve the input squared norm. It proves elementary consequences for
normalized pure-state representatives: Born weights are probabilities, are invariant under
a global unit-modulus phase, and every positive-probability output can be normalized.

The completeness equation is an explicit field of `FinitePureStateMeasurement`; it is not a
repository-owned scientific assumption. The module does not assert that every observable admits
such a finite decomposition, identify the operations with spectral projectors, cover
unbounded observables, or establish source fidelity to a particular textbook postulate.

## Equations implemented

For a finite outcome type `I`, operations `Mᵢ`, and vector `ψ`:

- Measurement completeness:
  `∑ i, ‖Mᵢ ψ‖² = ‖ψ‖²`.
- Born probability for a normalized representative:
  `p(i | ψ) = ‖Mᵢ ψ‖²`.
- Probability normalization:
  `∑ i, p(i | ψ) = 1`.
- Global-phase invariance for `‖z‖ = 1`:
  `p(i | z • ψ) = p(i | ψ)`.
- Positive-probability state update:
  `ψᵢ = ‖Mᵢ ψ‖⁻¹ • Mᵢ ψ`.

## Source status

These are source-neutral finite-dimensional/bounded-operation foundations. A Shankar
Chapter 4 crosswalk and exact page/equation citations remain deferred until governed Search
admission and equation-locator evidence are available. No local PDF or protected archive
expression was used to author this module.
-/

open scoped BigOperators
open Finset

@[expose] public section

namespace ProjectKoios.QuantumMechanics.Measurement

open ProjectKoios.QuantumMechanics

variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]

/-- `QM-MEASUREMENT-DEF-001`: a finite family of bounded complex-linear measurement
operations satisfying squared-norm completeness on every input vector. -/
structure FinitePureStateMeasurement (Outcome : Type*) [Fintype Outcome]
    (V : Type*) [NormedAddCommGroup V] [InnerProductSpace ℂ V] where
  -- Each outcome is represented by a bounded operation on the same declared state space.
  operation : Outcome → V →L[ℂ] V
  -- Completeness is supplied as data. It is not silently asserted as a repository assumption.
  norm_sq_sum : ∀ ψ : V, (∑ i : Outcome, ‖operation i ψ‖ ^ 2) = ‖ψ‖ ^ 2

/-- `QM-MEASUREMENT-DEF-002`: the Born probability assigned to one outcome by the
measurement-operation norm rule. -/
def bornProbability {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (ψ : NormalizedStateVector V)
    (i : Outcome) : ℝ :=
  ‖M.operation i ψ.vector‖ ^ 2

/-- `QM-MEASUREMENT-LEM-001`: every finite pure-state Born probability is nonnegative. -/
lemma bornProbability_nonneg {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (ψ : NormalizedStateVector V)
    (i : Outcome) :
    0 ≤ bornProbability M ψ i := by
  exact sq_nonneg _

/-- `QM-MEASUREMENT-THM-001`: the Born probabilities of all declared outcomes sum to
one for a normalized state-vector representative. -/
theorem sum_bornProbability_eq_one {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (ψ : NormalizedStateVector V) :
    (∑ i : Outcome, bornProbability M ψ i) = 1 := by
  -- Specialize the supplied completeness equation and then use the state's unit norm.
  simpa [bornProbability, ψ.norm_eq_one] using M.norm_sq_sum ψ.vector

/-- `QM-MEASUREMENT-LEM-002`: every finite pure-state Born probability is at most one. -/
lemma bornProbability_le_one {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (ψ : NormalizedStateVector V)
    (i : Outcome) :
    bornProbability M ψ i ≤ 1 := by
  classical
  -- One nonnegative summand is bounded by the complete finite sum, which is one.
  calc
    bornProbability M ψ i ≤ ∑ j : Outcome, bornProbability M ψ j := by
      exact Finset.single_le_sum
        (fun j _ => bornProbability_nonneg M ψ j) (Finset.mem_univ i)
    _ = 1 := sum_bornProbability_eq_one M ψ

/-- `QM-MEASUREMENT-THM-002`: Born probabilities are unchanged when a normalized
state-vector representative is multiplied by a unit-modulus global phase. -/
theorem bornProbability_phaseShift {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (z : ℂ) (hz : ‖z‖ = 1)
    (ψ : NormalizedStateVector V) (i : Outcome) :
    bornProbability M (phaseShift z hz ψ) i = bornProbability M ψ i := by
  simp [bornProbability, phaseShift, norm_smul, hz]

/-- `QM-MEASUREMENT-DEF-003`: the normalized output state-vector representative for a
strictly positive-probability outcome. -/
noncomputable def postMeasurementState {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (ψ : NormalizedStateVector V)
    (i : Outcome) (h : 0 < bornProbability M ψ i) : NormalizedStateVector V where
  vector := NormedSpace.normalize (M.operation i ψ.vector)
  norm_eq_one := by
    apply NormedSpace.norm_normalize
    -- A zero operation output would force the supposedly positive Born weight to vanish.
    intro hzero
    simp [bornProbability, hzero] at h

/-- `QM-MEASUREMENT-LEM-003`: the post-measurement representative is the selected
operation output divided by its norm. -/
lemma postMeasurementState_vector {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (ψ : NormalizedStateVector V)
    (i : Outcome) (h : 0 < bornProbability M ψ i) :
    (postMeasurementState M ψ i h).vector =
      ‖M.operation i ψ.vector‖⁻¹ • M.operation i ψ.vector := by
  rfl

/-- `QM-MEASUREMENT-THM-003`: every admitted positive-probability post-measurement
representative has unit norm. -/
theorem norm_postMeasurementState_vector_eq_one {Outcome : Type*} [Fintype Outcome]
    (M : FinitePureStateMeasurement Outcome V) (ψ : NormalizedStateVector V)
    (i : Outcome) (h : 0 < bornProbability M ψ i) :
    ‖(postMeasurementState M ψ i h).vector‖ = 1 :=
  (postMeasurementState M ψ i h).norm_eq_one

end ProjectKoios.QuantumMechanics.Measurement

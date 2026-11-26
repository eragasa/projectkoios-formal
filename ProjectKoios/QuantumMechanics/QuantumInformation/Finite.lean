/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-27
-/
module

public import QuantumInfo.Measurements.POVM
public import QuantumInfo.States.Entanglement

/-!
# Finite quantum-information bindings

This module provides a thin Project Koios binding to the finite-dimensional state, measurement,
channel, tensor-product, and entanglement APIs in the pinned `QuantumInfo` library. It deliberately
reuses `Ket`, `KetUpToPhase`, `MState`, `POVM`, `ProbDistribution`, and `CPTPMap` rather than
introducing competing quantum-information carriers.

The binding sends a pure ray to its rank-one mixed-state density matrix, exposes finite POVM outcome
probabilities and their expectation-value formula, and records compatibility with CPTP composition,
product states, partial traces, product channels, and the pure-state separability criterion.

## Boundaries

All state spaces are basis-indexed finite types. The module does not cover infinite-dimensional
trace-class operators, continuous-outcome measurements, instruments beyond the adopted POVM map,
LOCC protocols, open-system generators, continuum density matrices, or physical applicability.
Upstream `QuantumInfo` declarations remain the mathematical authority for the adopted carriers.
-/

@[expose] public section

noncomputable section

open scoped BigOperators RealInnerProductSpace

namespace ProjectKoios.QuantumMechanics.QuantumInformation

section PureState

variable {d : Type*} [Fintype d] [DecidableEq d]

/-- `QM-QINFO-DEF-001`: the mixed-state density matrix determined by a finite pure-state ray.
This is the adopted `QuantumInfo` quotient-safe pure-state map. -/
def pureStateDensity : KetUpToPhase d → MState d :=
  MState.pureQ

/-- `QM-QINFO-LEM-001`: a ket representative maps to its rank-one pure mixed state. -/
lemma pureStateDensity_mk (ψ : Ket d) :
    pureStateDensity (KetUpToPhase.mk ψ) = MState.pure ψ := by
  rfl

/-- `QM-QINFO-LEM-002`: finite pure-state rays are determined by their density matrices. -/
lemma pureStateDensity_injective : Function.Injective (pureStateDensity (d := d)) := by
  exact MState.pureQ_injective

end PureState

section Measurement

variable {d X : Type*} [Fintype d] [DecidableEq d] [Fintype X]

/-- `QM-QINFO-DEF-002`: the finite outcome distribution produced by a POVM on a mixed state. -/
def outcomeDistribution (measurement : POVM X d) (state : MState d) : ProbDistribution X :=
  measurement.measure state

/-- `QM-QINFO-DEF-003`: the real probability of one finite POVM outcome. -/
def outcomeProbability (measurement : POVM X d) (state : MState d) (outcome : X) : ℝ :=
  measurement.measure state outcome

/-- `QM-QINFO-LEM-003`: a POVM outcome probability is the real inner product of its effect with
the mixed-state density matrix. -/
lemma outcomeProbability_eq_inner (measurement : POVM X d) (state : MState d) (outcome : X) :
    outcomeProbability measurement state outcome = ⟪measurement.mats outcome, state.M⟫ := by
  rfl

/-- `QM-QINFO-LEM-004`: a POVM outcome probability is the mixed-state expectation value of the
corresponding effect. -/
lemma outcomeProbability_eq_exp_val
    (measurement : POVM X d) (state : MState d) (outcome : X) :
    outcomeProbability measurement state outcome = state.exp_val (measurement.mats outcome) := by
  rw [outcomeProbability_eq_inner]
  exact real_inner_comm state.M (measurement.mats outcome)

/-- `QM-QINFO-LEM-005`: every finite POVM outcome probability is nonnegative. -/
lemma outcomeProbability_nonneg
    (measurement : POVM X d) (state : MState d) (outcome : X) :
    0 ≤ outcomeProbability measurement state outcome := by
  exact (measurement.measure state outcome).2.1

/-- `QM-QINFO-LEM-006`: every finite POVM outcome probability is at most one. -/
lemma outcomeProbability_le_one
    (measurement : POVM X d) (state : MState d) (outcome : X) :
    outcomeProbability measurement state outcome ≤ 1 := by
  exact (measurement.measure state outcome).2.2

/-- `QM-QINFO-LEM-007`: finite POVM outcome probabilities sum to one. -/
lemma sum_outcomeProbability_eq_one (measurement : POVM X d) (state : MState d) :
    (∑ outcome : X, outcomeProbability measurement state outcome) = 1 := by
  exact (measurement.measure state).normalized

/-- `QM-QINFO-LEM-008`: phase-equivalent ket representatives give the same POVM outcome
distribution after passage to their pure density matrices. -/
lemma outcomeDistribution_pure_phase {ψ φ : Ket d}
    (hphase : Ket.PhaseEquiv.r ψ φ) (measurement : POVM X d) :
    outcomeDistribution measurement (MState.pure ψ) =
      outcomeDistribution measurement (MState.pure φ) := by
  rw [(MState.PhaseEquiv_iff_pure_eq ψ φ).mp hphase]

/-- `QM-QINFO-LEM-009`: discarding the post-measurement quantum state leaves the classical
mixed state associated with the POVM outcome distribution. -/
lemma measureDiscard_eq_ofClassical_outcomeDistribution
    [DecidableEq X] (measurement : POVM X d) (state : MState d) :
    measurement.measureDiscard state = MState.ofClassical (outcomeDistribution measurement state) := by
  exact measurement.measureDiscard_apply state

end Measurement

section Channels

variable {dIn dMid dOut X : Type*}
variable [Fintype dIn] [DecidableEq dIn]
variable [Fintype dMid] [DecidableEq dMid]
variable [Fintype dOut] [DecidableEq dOut]
variable [Fintype X]

/-- `QM-QINFO-DEF-004`: the finite POVM outcome distribution after a CPTP channel acts on the
input mixed state. -/
def postChannelOutcomeDistribution
    (channel : CPTPMap dIn dOut) (measurement : POVM X dOut) (state : MState dIn) :
    ProbDistribution X :=
  measurement.measure (channel state)

/-- `QM-QINFO-LEM-010`: the identity channel does not change the subsequent outcome
distribution. -/
lemma postChannelOutcomeDistribution_id (measurement : POVM X dIn) (state : MState dIn) :
    postChannelOutcomeDistribution CPTPMap.id measurement state =
      outcomeDistribution measurement state := by
  simp [postChannelOutcomeDistribution, outcomeDistribution]

/-- `QM-QINFO-LEM-011`: sequential channel action agrees with CPTP-map composition before a
measurement. -/
lemma postChannelOutcomeDistribution_compose
    (first : CPTPMap dIn dMid) (second : CPTPMap dMid dOut)
    (measurement : POVM X dOut) (state : MState dIn) :
    postChannelOutcomeDistribution (second ∘ₘ first) measurement state =
      postChannelOutcomeDistribution second measurement (first state) := by
  simp [postChannelOutcomeDistribution, CPTPMap.compose_eq]

end Channels

section TensorProducts

variable {d₁ d₂ dO₁ dO₂ : Type*}
variable [Fintype d₁] [DecidableEq d₁]
variable [Fintype d₂] [DecidableEq d₂]
variable [Fintype dO₁] [DecidableEq dO₁]
variable [Fintype dO₂] [DecidableEq dO₂]

/-- `QM-QINFO-LEM-012`: the density matrix of a pure tensor-product ket is the tensor product of
the factor density matrices. -/
lemma pureStateDensity_prod (ψ₁ : Ket d₁) (ψ₂ : Ket d₂) :
    MState.pure (ψ₁ ⊗ᵠ ψ₂) = MState.pure ψ₁ ⊗ᴹ MState.pure ψ₂ := by
  exact MState.pure_prod_pure ψ₁ ψ₂

/-- `QM-QINFO-LEM-013`: tracing out the left factor of a product mixed state recovers the right
factor. -/
lemma traceLeft_productState (state₁ : MState d₁) (state₂ : MState d₂) :
    (state₁ ⊗ᴹ state₂).traceLeft = state₂ := by
  exact MState.traceLeft_prod_eq state₁ state₂

/-- `QM-QINFO-LEM-014`: tracing out the right factor of a product mixed state recovers the left
factor. -/
lemma traceRight_productState (state₁ : MState d₁) (state₂ : MState d₂) :
    (state₁ ⊗ᴹ state₂).traceRight = state₁ := by
  exact MState.traceRight_prod_eq state₁ state₂

/-- `QM-QINFO-LEM-015`: a bipartite pure density matrix is separable exactly when its ket
representative is a product state. -/
lemma pureState_separable_iff_product (ψ : Ket (d₁ × d₂)) :
    MState.IsSeparable (MState.pure ψ) ↔ ψ.IsProd := by
  exact MState.pure_separable_iff_IsProd ψ

/-- `QM-QINFO-LEM-016`: a tensor product of CPTP channels acts factorwise on a tensor product of
mixed states. -/
lemma productChannel_productState
    (channel₁ : CPTPMap d₁ dO₁) (channel₂ : CPTPMap d₂ dO₂)
    (state₁ : MState d₁) (state₂ : MState d₂) :
    (channel₁ ⊗ᶜᵖ channel₂) (state₁ ⊗ᴹ state₂) =
      channel₁ state₁ ⊗ᴹ channel₂ state₂ := by
  exact CPTPMap.prod_apply_prod channel₁ channel₂ state₁ state₂

end TensorProducts

end ProjectKoios.QuantumMechanics.QuantumInformation

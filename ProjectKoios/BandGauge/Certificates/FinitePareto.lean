/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial formalization completed: 2026-10-19
-/
module

public import ProjectKoios.BandGauge.Decision.FinitePareto

/-!
# Exact finite Pareto checks

This module supplies executable Boolean checks for exact finite objective tables. A total
function on a `Fintype` supplies one exact value for every declared decision/objective
pair. The proved bridges identify Boolean dominance, threshold feasibility, and the
nondominated mask with their propositions.

The checks do not parse runtime output, prove that an exported table covered an external
inventory, or justify floating-point values. Interval-valued comparisons require a
separate three-valued unresolved boundary.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Certificates

open ProjectKoios.BandGauge.Decision

variable {Decision Objective Value : Type*}

/-- Executable weak-all/strict-any dominance check for one exact objective table. -/
def checkDominates
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    (objectives : ObjectiveTable Decision Objective Value)
    (better worse : Decision) : Bool :=
  decide ((Finset.univ.filter fun objective =>
      objectives better objective ≤ objectives worse objective) = Finset.univ) &&
    decide ((Finset.univ.filter fun objective =>
      objectives better objective < objectives worse objective) ≠ ∅)

/-- The exact dominance Boolean accepts precisely the propositional dominance relation. -/
theorem checkDominates_eq_true_iff
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {better worse : Decision} :
    checkDominates objectives better worse = true ↔
      Dominates objectives better worse := by
  simp [checkDominates, Dominates, WeaklyImproves]

/-- Executable coordinatewise threshold-feasibility check. -/
def checkThresholdFeasible
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value]
    (objectives : ObjectiveTable Decision Objective Value)
    (budgets : Objective → Value) (decision : Decision) : Bool :=
  decide ((Finset.univ.filter fun objective =>
    objectives decision objective ≤ budgets objective) = Finset.univ)

/-- The exact threshold Boolean accepts precisely coordinatewise feasibility. -/
theorem checkThresholdFeasible_eq_true_iff
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} {decision : Decision} :
    checkThresholdFeasible objectives budgets decision = true ↔
      ThresholdFeasible objectives budgets decision := by
  simp [checkThresholdFeasible, ThresholdFeasible]

/-- Executable nondominated mask for every decision in a finite exact table. -/
def paretoEfficientMask
    [Fintype Decision] [DecidableEq Decision]
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    (objectives : ObjectiveTable Decision Objective Value) : Decision → Bool :=
  fun decision => decide ((Finset.univ.filter fun other =>
    checkDominates objectives other decision = true) = ∅)

/-- The exact mask marks precisely the Pareto-efficient decisions. This is both soundness
and completeness for the supplied finite objective table. -/
theorem paretoEfficientMask_eq_true_iff
    [Fintype Decision] [DecidableEq Decision]
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {decision : Decision} :
    paretoEfficientMask objectives decision = true ↔
      ParetoEfficient objectives decision := by
  simp [paretoEfficientMask, ParetoEfficient, checkDominates_eq_true_iff]

end ProjectKoios.BandGauge.Certificates

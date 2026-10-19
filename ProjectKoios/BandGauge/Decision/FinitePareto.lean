/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial formalization completed: 2026-10-19
-/
module

public import Mathlib.Data.Fintype.Card
public import Mathlib.Order.Preorder.Finite

/-!
# Finite multiobjective decisions

This module defines minimization dominance, Pareto efficiency, coordinatewise threshold
feasibility, and minimum feasible cost for a declared finite decision type.

The definitions use weak improvement in every objective and strict improvement in at
least one objective. They concern only the supplied finite inventory. They do not assume
convexity, interpolate between decisions, or turn a plotted triangulation into an
attainable continuum frontier.
-/

@[expose] public section

open Set

namespace ProjectKoios.BandGauge.Decision

variable {Decision Objective Value Cost : Type*}

/-- A table assigning one value to every decision/objective pair. Smaller values are
better in every objective. -/
abbrev ObjectiveTable (Decision Objective Value : Type*) :=
  Decision → Objective → Value

/-- `better` weakly improves `worse` when none of its objective values is larger. -/
def WeaklyImproves [LE Value]
    (objectives : ObjectiveTable Decision Objective Value)
    (better worse : Decision) : Prop :=
  ∀ objective, objectives better objective ≤ objectives worse objective

/-- Weak-all/strict-any minimization dominance. -/
def Dominates [Preorder Value]
    (objectives : ObjectiveTable Decision Objective Value)
    (better worse : Decision) : Prop :=
  WeaklyImproves objectives better worse ∧
    ∃ objective, objectives better objective < objectives worse objective

/-- A decision is Pareto efficient when no declared decision dominates it. -/
def ParetoEfficient [Preorder Value]
    (objectives : ObjectiveTable Decision Objective Value)
    (decision : Decision) : Prop :=
  ∀ other, ¬ Dominates objectives other decision

/-- Coordinatewise feasibility for one objective-budget vector. -/
def ThresholdFeasible [LE Value]
    (objectives : ObjectiveTable Decision Objective Value)
    (budgets : Objective → Value) (decision : Decision) : Prop :=
  ∀ objective, objectives decision objective ≤ budgets objective

/-- `relaxed` is no stricter than `strict` in any objective. -/
def ThresholdsRelaxed [LE Value]
    (strict relaxed : Objective → Value) : Prop :=
  ∀ objective, strict objective ≤ relaxed objective

/-- A feasible decision whose cost is no larger than the cost of any other feasible
decision. -/
def IsMinimumFeasibleCost [LE Cost]
    (feasible : Decision → Prop) (cost : Decision → Cost)
    (decision : Decision) : Prop :=
  feasible decision ∧ ∀ other, feasible other → cost decision ≤ cost other

/-- Exhaustive qualitative outcomes for a two-channel feasibility query. The ordering of
constructors supplies a deterministic classification when several emptiness descriptions
would otherwise apply. -/
inductive JointFeasibilityClass where
  | inventoryEmpty
  | firstChannelEmpty
  | secondChannelEmpty
  | individuallyNonemptyDisjoint
  | jointlyFeasible

/-- The proposition represented by one qualitative two-channel feasibility outcome. -/
def JointFeasibilityClass.Holds
    (classification : JointFeasibilityClass)
    (first second : Decision → Prop) : Prop :=
  match classification with
  | .inventoryEmpty => IsEmpty Decision
  | .firstChannelEmpty => Nonempty Decision ∧ ¬ ∃ decision, first decision
  | .secondChannelEmpty =>
      Nonempty Decision ∧ (∃ decision, first decision) ∧ ¬ ∃ decision, second decision
  | .individuallyNonemptyDisjoint =>
      (∃ decision, first decision) ∧
      (∃ decision, second decision) ∧
      ¬ ∃ decision, first decision ∧ second decision
  | .jointlyFeasible => ∃ decision, first decision ∧ second decision

/-- Every decision weakly improves itself. -/
theorem weaklyImproves_refl [Preorder Value]
    (objectives : ObjectiveTable Decision Objective Value) (decision : Decision) :
    WeaklyImproves objectives decision decision := by
  intro objective
  exact le_rfl

/-- Coordinatewise weak improvement is transitive. -/
theorem weaklyImproves_trans [Preorder Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {a b c : Decision}
    (hab : WeaklyImproves objectives a b)
    (hbc : WeaklyImproves objectives b c) :
    WeaklyImproves objectives a c := by
  intro objective
  exact (hab objective).trans (hbc objective)

/-- Strict-any dominance is irreflexive. -/
theorem dominates_irrefl [Preorder Value]
    (objectives : ObjectiveTable Decision Objective Value) (decision : Decision) :
    ¬ Dominates objectives decision decision := by
  rintro ⟨_, objective, hlt⟩
  exact lt_irrefl _ hlt

/-- Weak-all/strict-any dominance is transitive. -/
theorem dominates_trans [Preorder Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {a b c : Decision}
    (hab : Dominates objectives a b)
    (hbc : Dominates objectives b c) :
    Dominates objectives a c := by
  refine ⟨weaklyImproves_trans hab.1 hbc.1, ?_⟩
  obtain ⟨objective, hstrict⟩ := hab.2
  exact ⟨objective, hstrict.trans_le (hbc.1 objective)⟩

/-- Decisions with identical objective vectors do not dominate one another. -/
theorem not_dominates_of_objectives_eq [Preorder Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {a b : Decision}
    (hEq : ∀ objective, objectives a objective = objectives b objective) :
    ¬ Dominates objectives a b := by
  rintro ⟨_, objective, hlt⟩
  exact lt_irrefl _ (hEq objective ▸ hlt)

/-- In a finite decision type, every decision is weakly improved by a Pareto-efficient
decision. The conclusion remains valid when the objective type is empty. -/
theorem exists_paretoEfficient_weaklyImproves [Finite Decision] [Preorder Value]
    (objectives : ObjectiveTable Decision Objective Value) (decision : Decision) :
    ∃ efficient,
      ParetoEfficient objectives efficient ∧
      WeaklyImproves objectives efficient decision := by
  let r : Decision → Decision → Prop := fun a b => Dominates objectives a b
  let candidateSet : Set Decision :=
    {candidate | WeaklyImproves objectives candidate decision}
  have htrans : ∀ {a b c}, r a b → r b c → r a c := by
    intro a b c hab hbc
    exact dominates_trans hab hbc
  have hirrefl : ∀ a, ¬ r a a := by
    intro a
    exact dominates_irrefl objectives a
  let _ : IsTrans Decision r := ⟨fun _ _ _ => htrans⟩
  let _ : Std.Irrefl r := ⟨hirrefl⟩
  have hwf : WellFounded r := Finite.wellFounded_of_trans_of_irrefl r
  have hnonempty : candidateSet.Nonempty :=
    ⟨decision, weaklyImproves_refl objectives decision⟩
  obtain ⟨efficient, hefficientCandidate, hefficientMinimal⟩ :=
    hwf.has_min candidateSet hnonempty
  refine ⟨efficient, ?_, hefficientCandidate⟩
  intro other hdominates
  apply hefficientMinimal other
  · exact weaklyImproves_trans hdominates.1 hefficientCandidate
  · exact hdominates

/-- Weakly improving a feasible decision preserves coordinatewise threshold
feasibility. -/
theorem thresholdFeasible_of_weaklyImproves [Preorder Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} {better worse : Decision}
    (himproves : WeaklyImproves objectives better worse)
    (hfeasible : ThresholdFeasible objectives budgets worse) :
    ThresholdFeasible objectives budgets better := by
  intro objective
  exact (himproves objective).trans (hfeasible objective)

/-- Every nonempty finite threshold-feasible class contains a Pareto-efficient feasible
decision. -/
theorem exists_paretoEfficient_thresholdFeasible [Finite Decision] [Preorder Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {budgets : Objective → Value}
    (hfeasible : ∃ decision, ThresholdFeasible objectives budgets decision) :
    ∃ decision,
      ParetoEfficient objectives decision ∧
      ThresholdFeasible objectives budgets decision := by
  obtain ⟨decision, hdecision⟩ := hfeasible
  obtain ⟨efficient, hefficient, himproves⟩ :=
    exists_paretoEfficient_weaklyImproves objectives decision
  exact ⟨efficient, hefficient,
    thresholdFeasible_of_weaklyImproves himproves hdecision⟩

/-- For a finite inventory, testing the Pareto-efficient decisions is sufficient to
decide whether any decision satisfies all objective thresholds. -/
theorem exists_thresholdFeasible_iff_exists_paretoEfficient_thresholdFeasible
    [Finite Decision] [Preorder Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} :
    (∃ decision, ThresholdFeasible objectives budgets decision) ↔
      ∃ decision,
        ParetoEfficient objectives decision ∧
        ThresholdFeasible objectives budgets decision := by
  constructor
  · exact exists_paretoEfficient_thresholdFeasible
  · rintro ⟨decision, _, hfeasible⟩
    exact ⟨decision, hfeasible⟩

/-- Relaxing every threshold preserves feasibility of any fixed decision. -/
theorem thresholdFeasible_of_thresholdsRelaxed [Preorder Value]
    {objectives : ObjectiveTable Decision Objective Value}
    {strict relaxed : Objective → Value} {decision : Decision}
    (hrelaxed : ThresholdsRelaxed strict relaxed)
    (hfeasible : ThresholdFeasible objectives strict decision) :
    ThresholdFeasible objectives relaxed decision := by
  intro objective
  exact (hfeasible objective).trans (hrelaxed objective)

/-- A nonempty feasible subset of a finite decision type attains minimum cost. -/
theorem exists_minimumFeasibleCost [Finite Decision] [LinearOrder Cost]
    {feasible : Decision → Prop} {cost : Decision → Cost}
    (hnonempty : ∃ decision, feasible decision) :
    ∃ decision, IsMinimumFeasibleCost feasible cost decision := by
  let feasibleSet : Set Decision := {decision | feasible decision}
  have hfinite : feasibleSet.Finite := Set.toFinite feasibleSet
  have hnonemptySet : feasibleSet.Nonempty := hnonempty
  obtain ⟨decision, hdecision, hminimal⟩ :=
    hfinite.exists_minimalFor cost feasibleSet hnonemptySet
  refine ⟨decision, hdecision, ?_⟩
  intro other hother
  by_contra hnot
  have hotherLt : cost other < cost decision := lt_of_not_ge hnot
  have hdecisionLe : cost decision ≤ cost other := hminimal hother hotherLt.le
  exact not_lt_of_ge hdecisionLe hotherLt

/-- Every two-channel query has one of the declared qualitative outcomes. This logical
classification does not assert that either channel was computed correctly or that the
inventory is scientifically complete. -/
theorem exists_jointFeasibilityClass_holds
    (first second : Decision → Prop) :
    ∃ classification : JointFeasibilityClass,
      JointFeasibilityClass.Holds classification first second := by
  classical
  by_cases hinventory : Nonempty Decision
  · by_cases hfirst : ∃ decision, first decision
    · by_cases hsecond : ∃ decision, second decision
      · by_cases hjoint : ∃ decision, first decision ∧ second decision
        · exact ⟨.jointlyFeasible, hjoint⟩
        · exact ⟨.individuallyNonemptyDisjoint, hfirst, hsecond, hjoint⟩
      · exact ⟨.secondChannelEmpty, hinventory, hfirst, hsecond⟩
    · exact ⟨.firstChannelEmpty, hinventory, hfirst⟩
  · have hempty : IsEmpty Decision := ⟨fun decision => hinventory ⟨decision⟩⟩
    exact ⟨.inventoryEmpty, hempty⟩

/-- When thresholds are relaxed, the minimum attainable cost cannot increase. This
statement compares supplied minimizers and does not assign a finite value to an empty
feasible class. -/
theorem minimumFeasibleCost_anti_of_relaxed [Preorder Value] [Preorder Cost]
    {objectives : ObjectiveTable Decision Objective Value}
    {strict relaxed : Objective → Value} {cost : Decision → Cost}
    {strictMinimum relaxedMinimum : Decision}
    (hrelaxed : ThresholdsRelaxed strict relaxed)
    (hstrict : IsMinimumFeasibleCost
      (ThresholdFeasible objectives strict) cost strictMinimum)
    (hrelaxedMinimum : IsMinimumFeasibleCost
      (ThresholdFeasible objectives relaxed) cost relaxedMinimum) :
    cost relaxedMinimum ≤ cost strictMinimum := by
  exact hrelaxedMinimum.2 strictMinimum
    (thresholdFeasible_of_thresholdsRelaxed hrelaxed hstrict.1)

end ProjectKoios.BandGauge.Decision

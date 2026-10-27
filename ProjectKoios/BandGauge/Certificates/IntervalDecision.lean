/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-27
-/
module

public import ProjectKoios.BandGauge.Certificates.FinitePareto
public import ProjectKoios.BandGauge.Decision.FiniteCutoff

/-!
# Three-way interval decisions

This module classifies outward interval enclosures against upper thresholds as accepted,
rejected, or unresolved. Acceptance uses the upper endpoint, definite rejection uses the
lower endpoint, and a threshold lying inside the interval remains unresolved.

The finite joint checker requires one decision to satisfy every objective. The first-passing
checker requires one selected inventory member to be accepted and every earlier member to
be rejected. These definitions do not parse runtime files, prove enclosure production,
justify binary floating-point values, or establish external inventory coverage.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Certificates

open ProjectKoios.BandGauge.Decision

variable {Decision Objective Value Cutoff : Type*}

/-- `BG-CERT-DEF-023`: raw lower and upper endpoints for one outward interval estimate. -/
structure IntervalEstimate (Value : Type*) where
  lower : Value
  upper : Value

namespace IntervalEstimate

/-- `BG-CERT-DEF-024`: endpoint ordering required of a valid interval estimate. -/
def Valid [LE Value] (estimate : IntervalEstimate Value) : Prop :=
  estimate.lower ≤ estimate.upper

/-- `BG-CERT-DEF-025`: an exact value is enclosed by both interval endpoints. -/
def Contains [LE Value] (estimate : IntervalEstimate Value) (value : Value) : Prop :=
  estimate.lower ≤ value ∧ value ≤ estimate.upper

end IntervalEstimate

/-- `BG-CERT-DEF-026`: the three possible outcomes of a conservative interval decision.
`rejected` includes malformed endpoint order; no substantive failure follows from that case
without a separately supplied containment proof. -/
inductive IntervalDisposition where
  | accepted
  | rejected
  | unresolved
  deriving DecidableEq, Repr

/-- `BG-CERT-DEF-027`: classify one interval against an inclusive upper budget.

The order of checks is deliberate. Invalid endpoints fail closed. A valid enclosure is
accepted only when its upper endpoint passes and rejected only when its lower endpoint is
strictly above the budget. Every threshold-overlapping enclosure is unresolved. -/
def classifyUpperBound
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    (estimate : IntervalEstimate Value) (budget : Value) : IntervalDisposition :=
  if estimate.lower ≤ estimate.upper then
    if estimate.upper ≤ budget then
      .accepted
    else if budget < estimate.lower then
      .rejected
    else
      .unresolved
  else
    .rejected

/-- `BG-CERT-THM-017`: single-objective acceptance is exactly valid endpoint order plus
passage of the conservative upper endpoint. -/
theorem classifyUpperBound_eq_accepted_iff
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimate : IntervalEstimate Value} {budget : Value} :
    classifyUpperBound estimate budget = .accepted ↔
      estimate.Valid ∧ estimate.upper ≤ budget := by
  constructor
  · intro hstatus
    by_cases hvalid : estimate.lower ≤ estimate.upper
    · by_cases hupper : estimate.upper ≤ budget
      · exact ⟨hvalid, hupper⟩
      · by_cases hbudget : budget < estimate.lower
        · simp [classifyUpperBound, hvalid, hupper, hbudget] at hstatus
        · simp [classifyUpperBound, hvalid, hupper, hbudget] at hstatus
    · simp [classifyUpperBound, hvalid] at hstatus
  · rintro ⟨hvalid, hupper⟩
    simp [classifyUpperBound, IntervalEstimate.Valid] at hvalid ⊢
    simp [hvalid, hupper]

/-- `BG-CERT-THM-018`: acceptance transfers to every exact value contained in the
supplied interval. -/
theorem classifyUpperBound_accepted_sound
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimate : IntervalEstimate Value} {budget value : Value}
    (hstatus : classifyUpperBound estimate budget = .accepted)
    (hcontains : estimate.Contains value) :
    value ≤ budget := by
  have haccepted := classifyUpperBound_eq_accepted_iff.mp hstatus
  exact hcontains.2.trans haccepted.2

/-- `BG-CERT-THM-019`: rejection transfers to every exact value contained in the
supplied interval. Invalid endpoints cannot satisfy the containment premise. -/
theorem classifyUpperBound_rejected_sound
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimate : IntervalEstimate Value} {budget value : Value}
    (hstatus : classifyUpperBound estimate budget = .rejected)
    (hcontains : estimate.Contains value) :
    ¬ value ≤ budget := by
  by_cases hvalid : estimate.lower ≤ estimate.upper
  · by_cases hupper : estimate.upper ≤ budget
    · simp [classifyUpperBound, hvalid, hupper] at hstatus
    · by_cases hbudget : budget < estimate.lower
      · exact not_le_of_gt (hbudget.trans_le hcontains.1)
      · simp [classifyUpperBound, hvalid, hupper, hbudget] at hstatus
  · exact False.elim (hvalid (hcontains.1.trans hcontains.2))

/-- `BG-CERT-THM-020`: unresolved is exactly the threshold-overlap case. In particular,
an overlap is not classified as a rejection. -/
theorem classifyUpperBound_eq_unresolved_iff
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimate : IntervalEstimate Value} {budget : Value} :
    classifyUpperBound estimate budget = .unresolved ↔
      estimate.lower ≤ budget ∧ budget < estimate.upper := by
  constructor
  · intro hstatus
    by_cases hvalid : estimate.lower ≤ estimate.upper
    · by_cases hupper : estimate.upper ≤ budget
      · simp [classifyUpperBound, hvalid, hupper] at hstatus
      · by_cases hbudget : budget < estimate.lower
        · simp [classifyUpperBound, hvalid, hupper, hbudget] at hstatus
        · exact ⟨le_of_not_gt hbudget, lt_of_not_ge hupper⟩
    · simp [classifyUpperBound, hvalid] at hstatus
  · rintro ⟨hlower, hupper⟩
    have hvalid : estimate.lower ≤ estimate.upper := hlower.trans hupper.le
    have hnotUpper : ¬ estimate.upper ≤ budget := not_le_of_gt hupper
    have hnotLower : ¬ budget < estimate.lower := not_lt_of_ge hlower
    simp [classifyUpperBound, hvalid, hnotUpper, hnotLower]

/-- `BG-CERT-DEF-028`: one interval estimate for every decision/objective pair. -/
abbrev IntervalObjectiveTable (Decision Objective Value : Type*) :=
  Decision → Objective → IntervalEstimate Value

/-- `BG-CERT-DEF-029`: classify coordinatewise feasibility for one common decision.

All objectives must be accepted for joint acceptance. One rejected objective is enough for
joint rejection. Otherwise at least one objective remains unresolved. -/
def classifyThresholdFeasible
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    (estimates : IntervalObjectiveTable Decision Objective Value)
    (budgets : Objective → Value) (decision : Decision) : IntervalDisposition :=
  if ∀ objective, classifyUpperBound (estimates decision objective) (budgets objective) =
      .accepted then
    .accepted
  else if ∃ objective, classifyUpperBound (estimates decision objective) (budgets objective) =
      .rejected then
    .rejected
  else
    .unresolved

private theorem all_accepted_of_classifyThresholdFeasible_eq_accepted
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimates : IntervalObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} {decision : Decision}
    (hstatus : classifyThresholdFeasible estimates budgets decision = .accepted) :
    ∀ objective,
      classifyUpperBound (estimates decision objective) (budgets objective) = .accepted := by
  by_cases hall : ∀ objective,
      classifyUpperBound (estimates decision objective) (budgets objective) = .accepted
  · exact hall
  · by_cases hexists : ∃ objective,
        classifyUpperBound (estimates decision objective) (budgets objective) = .rejected
    · simp [classifyThresholdFeasible, hall, hexists] at hstatus
    · simp [classifyThresholdFeasible, hall, hexists] at hstatus

private theorem exists_rejected_of_classifyThresholdFeasible_eq_rejected
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimates : IntervalObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} {decision : Decision}
    (hstatus : classifyThresholdFeasible estimates budgets decision = .rejected) :
    ∃ objective,
      classifyUpperBound (estimates decision objective) (budgets objective) = .rejected := by
  by_cases hall : ∀ objective,
      classifyUpperBound (estimates decision objective) (budgets objective) = .accepted
  · simp [classifyThresholdFeasible, hall] at hstatus
  · by_cases hexists : ∃ objective,
        classifyUpperBound (estimates decision objective) (budgets objective) = .rejected
    · exact hexists
    · simp [classifyThresholdFeasible, hall, hexists] at hstatus

/-- `BG-CERT-THM-021`: joint acceptance proves exact coordinatewise feasibility for the
same decision whenever every exact objective is contained in its interval. -/
theorem classifyThresholdFeasible_accepted_sound
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimates : IntervalObjectiveTable Decision Objective Value}
    {actual : ObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} {decision : Decision}
    (hstatus : classifyThresholdFeasible estimates budgets decision = .accepted)
    (hcontains : ∀ objective,
      (estimates decision objective).Contains (actual decision objective)) :
    ThresholdFeasible actual budgets decision := by
  have hall := all_accepted_of_classifyThresholdFeasible_eq_accepted hstatus
  intro objective
  exact classifyUpperBound_accepted_sound (hall objective) (hcontains objective)

/-- `BG-CERT-THM-022`: one rejected objective proves that the same decision is not
exactly threshold feasible, provided every exact objective is contained. -/
theorem classifyThresholdFeasible_rejected_sound
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimates : IntervalObjectiveTable Decision Objective Value}
    {actual : ObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} {decision : Decision}
    (hstatus : classifyThresholdFeasible estimates budgets decision = .rejected)
    (hcontains : ∀ objective,
      (estimates decision objective).Contains (actual decision objective)) :
    ¬ ThresholdFeasible actual budgets decision := by
  obtain ⟨objective, hreject⟩ :=
    exists_rejected_of_classifyThresholdFeasible_eq_rejected hstatus
  intro hfeasible
  exact classifyUpperBound_rejected_sound hreject (hcontains objective) (hfeasible objective)

/-- `BG-CERT-THM-023`: joint unresolved means no objective is rejected and at least one
objective is itself unresolved. -/
theorem classifyThresholdFeasible_eq_unresolved_iff
    [Fintype Objective] [DecidableEq Objective]
    [LinearOrder Value] [DecidableLE Value] [DecidableLT Value]
    {estimates : IntervalObjectiveTable Decision Objective Value}
    {budgets : Objective → Value} {decision : Decision} :
    classifyThresholdFeasible estimates budgets decision = .unresolved ↔
      (∀ objective,
        classifyUpperBound (estimates decision objective) (budgets objective) ≠ .rejected) ∧
      ∃ objective,
        classifyUpperBound (estimates decision objective) (budgets objective) = .unresolved := by
  classical
  constructor
  · intro hstatus
    by_cases hall : ∀ objective,
        classifyUpperBound (estimates decision objective) (budgets objective) = .accepted
    · simp [classifyThresholdFeasible, hall] at hstatus
    · by_cases hexists : ∃ objective,
          classifyUpperBound (estimates decision objective) (budgets objective) = .rejected
      · simp [classifyThresholdFeasible, hall, hexists] at hstatus
      · refine ⟨fun objective hreject => hexists ⟨objective, hreject⟩, ?_⟩
        push Not at hall
        obtain ⟨objective, hnotAccepted⟩ := hall
        refine ⟨objective, ?_⟩
        cases hobjective : classifyUpperBound
            (estimates decision objective) (budgets objective) with
        | accepted => exact False.elim (hnotAccepted hobjective)
        | rejected => exact False.elim (hexists ⟨objective, hobjective⟩)
        | unresolved => rfl
  · rintro ⟨hnoneRejected, ⟨objective, hunresolved⟩⟩
    have hnotAll : ¬ ∀ current,
        classifyUpperBound (estimates decision current) (budgets current) = .accepted := by
      intro hall
      rw [hall objective] at hunresolved
      cases hunresolved
    have hnoRejected : ¬ ∃ current,
        classifyUpperBound (estimates decision current) (budgets current) = .rejected := by
      rintro ⟨current, hreject⟩
      exact hnoneRejected current hreject
    simp [classifyThresholdFeasible, hnotAll, hnoRejected]

/-- `BG-CERT-DEF-030`: classify first passage from per-cutoff three-way dispositions.

Membership failure, selected-cutoff rejection, or an earlier accepted cutoff gives a
rejection. Acceptance requires the selected cutoff to be accepted and every earlier
inventory member to be rejected. Remaining cases are unresolved. -/
def classifyFirstPassing
    [LinearOrder Cutoff] [DecidableEq Cutoff]
    (inventory : Finset Cutoff) (status : Cutoff → IntervalDisposition)
    (selected : Cutoff) : IntervalDisposition :=
  if selected ∉ inventory then
    .rejected
  else if status selected = .accepted ∧
      ∀ earlier ∈ inventory, earlier < selected → status earlier = .rejected then
    .accepted
  else if status selected = .rejected ∨
      ∃ earlier ∈ inventory, earlier < selected ∧ status earlier = .accepted then
    .rejected
  else
    .unresolved

private theorem conditions_of_classifyFirstPassing_eq_accepted
    [LinearOrder Cutoff] [DecidableEq Cutoff]
    {inventory : Finset Cutoff} {status : Cutoff → IntervalDisposition}
    {selected : Cutoff}
    (hstatus : classifyFirstPassing inventory status selected = .accepted) :
    selected ∈ inventory ∧
      status selected = .accepted ∧
      ∀ earlier ∈ inventory, earlier < selected → status earlier = .rejected := by
  by_cases hmember : selected ∈ inventory
  · by_cases hconditions : status selected = .accepted ∧
        ∀ earlier ∈ inventory, earlier < selected → status earlier = .rejected
    · exact ⟨hmember, hconditions⟩
    · by_cases hreject : status selected = .rejected ∨
          ∃ earlier ∈ inventory, earlier < selected ∧ status earlier = .accepted
      · simp [classifyFirstPassing, hmember, hconditions, hreject] at hstatus
      · simp [classifyFirstPassing, hmember, hconditions, hreject] at hstatus
  · simp [classifyFirstPassing, hmember] at hstatus

private theorem reason_of_classifyFirstPassing_eq_rejected
    [LinearOrder Cutoff] [DecidableEq Cutoff]
    {inventory : Finset Cutoff} {status : Cutoff → IntervalDisposition}
    {selected : Cutoff}
    (hstatus : classifyFirstPassing inventory status selected = .rejected) :
    selected ∉ inventory ∨
      status selected = .rejected ∨
      ∃ earlier ∈ inventory, earlier < selected ∧ status earlier = .accepted := by
  by_cases hmember : selected ∈ inventory
  · by_cases hconditions : status selected = .accepted ∧
        ∀ earlier ∈ inventory, earlier < selected → status earlier = .rejected
    · have hcomputed : classifyFirstPassing inventory status selected = .accepted := by
        unfold classifyFirstPassing
        simp only [hmember, not_true_eq_false, ↓reduceIte]
        rw [hconditions.1]
        simp only [true_and]
        split
        · rfl
        · rename_i hnot
          exact False.elim (hnot hconditions.2)
      rw [hcomputed] at hstatus
      cases hstatus
    · by_cases hreject : status selected = .rejected ∨
          ∃ earlier ∈ inventory, earlier < selected ∧ status earlier = .accepted
      · exact Or.inr hreject
      · simp [classifyFirstPassing, hmember, hconditions, hreject] at hstatus
  · exact Or.inl hmember

/-- `BG-CERT-THM-024`: accepted per-cutoff dispositions imply the exact first-passing
proposition when accepted and rejected dispositions are sound for the underlying predicate. -/
theorem classifyFirstPassing_accepted_sound
    [LinearOrder Cutoff] [DecidableEq Cutoff]
    {inventory : Finset Cutoff} {status : Cutoff → IntervalDisposition}
    {passes : Cutoff → Prop} {selected : Cutoff}
    (haccepted : ∀ cutoff, status cutoff = .accepted → passes cutoff)
    (hrejected : ∀ cutoff, status cutoff = .rejected → ¬ passes cutoff)
    (hstatus : classifyFirstPassing inventory status selected = .accepted) :
    IsFirstPassing inventory passes selected := by
  obtain ⟨hmember, hselected, hearlier⟩ :=
    conditions_of_classifyFirstPassing_eq_accepted hstatus
  exact ⟨hmember, haccepted selected hselected, fun earlier hmem hlt =>
    hrejected earlier (hearlier earlier hmem hlt)⟩

/-- `BG-CERT-THM-025`: a rejected first-passing disposition rules out the exact
first-passing proposition under the same per-cutoff soundness assumptions. -/
theorem classifyFirstPassing_rejected_sound
    [LinearOrder Cutoff] [DecidableEq Cutoff]
    {inventory : Finset Cutoff} {status : Cutoff → IntervalDisposition}
    {passes : Cutoff → Prop} {selected : Cutoff}
    (haccepted : ∀ cutoff, status cutoff = .accepted → passes cutoff)
    (hrejected : ∀ cutoff, status cutoff = .rejected → ¬ passes cutoff)
    (hstatus : classifyFirstPassing inventory status selected = .rejected) :
    ¬ IsFirstPassing inventory passes selected := by
  rcases reason_of_classifyFirstPassing_eq_rejected hstatus with
      hnotMember | hselectedRejected | ⟨earlier, hearlierMember, hearlierLt, hearlierAccepted⟩
  · intro hfirst
    exact hnotMember hfirst.1
  · intro hfirst
    exact hrejected selected hselectedRejected hfirst.2.1
  · intro hfirst
    exact hfirst.2.2 earlier hearlierMember hearlierLt
      (haccepted earlier hearlierAccepted)

end ProjectKoios.BandGauge.Certificates

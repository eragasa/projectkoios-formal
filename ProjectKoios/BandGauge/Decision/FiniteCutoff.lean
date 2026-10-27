/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import Mathlib.Data.Finset.Max

/-!
# First-passing decisions on a finite ordered inventory

This module formalizes the meaning of a first-passing cutoff. A selected cutoff passes and
every strictly earlier declared cutoff fails. No monotonicity assumption is used, so checking
only an immediate predecessor is not sufficient in general.

The joint definition requires both channels to pass at the same cutoff. Separate witnesses for
the two channels do not establish joint feasibility.
-/

@[expose] public section

namespace ProjectKoios.BandGauge.Decision

variable {Cutoff : Type*}

/-- `BG-DECISION-DEF-010`: `selected` is a first-passing member of the declared finite
ordered inventory. -/
def IsFirstPassing [LT Cutoff]
    (inventory : Finset Cutoff) (passes : Cutoff → Prop) (selected : Cutoff) : Prop :=
  selected ∈ inventory ∧
    passes selected ∧
    ∀ earlier ∈ inventory, earlier < selected → ¬ passes earlier

/-- `BG-DECISION-DEF-011`: one cutoff is first to pass both declared channels. -/
def IsFirstJointPassing [LT Cutoff]
    (inventory : Finset Cutoff) (first second : Cutoff → Prop) (selected : Cutoff) : Prop :=
  IsFirstPassing inventory (fun cutoff => first cutoff ∧ second cutoff) selected

/-- `BG-DECISION-THM-014`: every nonempty passing subset of a finite linearly ordered
inventory has a first-passing cutoff. -/
theorem exists_isFirstPassing [LinearOrder Cutoff]
    (inventory : Finset Cutoff) (passes : Cutoff → Prop)
    (hnonempty : ∃ cutoff ∈ inventory, passes cutoff) :
    ∃ selected, IsFirstPassing inventory passes selected := by
  classical
  let passing := inventory.filter passes
  have hpassing : passing.Nonempty := by
    obtain ⟨cutoff, hcutoff, hpasses⟩ := hnonempty
    exact ⟨cutoff, Finset.mem_filter.2 ⟨hcutoff, hpasses⟩⟩
  let selected := passing.min' hpassing
  have hselected : selected ∈ passing := Finset.min'_mem passing hpassing
  refine ⟨selected, (Finset.mem_filter.1 hselected).1,
    (Finset.mem_filter.1 hselected).2, ?_⟩
  intro earlier hearlier hlt hearlierPasses
  have hearlierPassing : earlier ∈ passing :=
    Finset.mem_filter.2 ⟨hearlier, hearlierPasses⟩
  have hselectedLe : selected ≤ earlier := Finset.min'_le passing earlier hearlierPassing
  exact (not_lt_of_ge hselectedLe) hlt

/-- `BG-DECISION-THM-015`: a first-passing cutoff is unique in a linearly ordered
inventory, even when later pass/fail decisions are nonmonotone. -/
theorem isFirstPassing_unique [LinearOrder Cutoff]
    {inventory : Finset Cutoff} {passes : Cutoff → Prop} {left right : Cutoff}
    (hleft : IsFirstPassing inventory passes left)
    (hright : IsFirstPassing inventory passes right) :
    left = right := by
  rcases lt_trichotomy left right with hlt | heq | hgt
  · exact False.elim (hright.2.2 left hleft.1 hlt hleft.2.1)
  · exact heq
  · exact False.elim (hleft.2.2 right hright.1 hgt hright.2.1)

/-- `BG-DECISION-THM-016`: first joint passage means that the selected cutoff passes both
channels and every earlier inventory member fails at least one channel. In particular,
the two channel witnesses cannot be taken from different cutoffs. -/
theorem isFirstJointPassing_iff [LinearOrder Cutoff]
    {inventory : Finset Cutoff} {first second : Cutoff → Prop} {selected : Cutoff} :
    IsFirstJointPassing inventory first second selected ↔
      selected ∈ inventory ∧
      first selected ∧ second selected ∧
      ∀ earlier ∈ inventory, earlier < selected → ¬ (first earlier ∧ second earlier) := by
  simp only [IsFirstJointPassing, IsFirstPassing]
  tauto

end ProjectKoios.BandGauge.Decision

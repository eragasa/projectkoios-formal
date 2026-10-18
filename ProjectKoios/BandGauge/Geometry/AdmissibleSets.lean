module

public import Mathlib.Topology.Instances.ENNReal.Lemmas
public import Mathlib.Topology.MetricSpace.Basic
public import Mathlib.Topology.Order.Compact

/-!
# Admissible-set decision geometry

This module supplies the metric-space bookkeeping used to compare the spectral and
aligned-operator admissible sets of one declared candidate model family.

The extended nonnegative codomain keeps the empty-set boundary explicit: the infimum over
an empty admissible set is `⊤`, rather than a finite value that could be mistaken for a
reported model-class distance.
-/

@[expose] public section

open Set
open scoped ENNReal

namespace ProjectKoios.BandGauge.Geometry

variable {X : Type*} [MetricSpace X]

/-- The infimum extended distance between two admissible subsets of one model-parameter
space. This is the extended-valued representation of the paper's `δ*`; later real-valued
use must retain the source's nonemptiness assumptions. -/
noncomputable def admissibleSetEDist (A B : Set X) : ENNReal :=
  ⨅ (a : X) (_ : a ∈ A) (b : X) (_ : b ∈ B), edist a b

/-- Every feasible pair supplies an upper bound on the distance between the two
admissible sets. -/
theorem admissibleSetEDist_le_edist_of_mem {A B : Set X} {a b : X}
    (ha : a ∈ A) (hb : b ∈ B) :
    admissibleSetEDist A B ≤ edist a b := by
  exact iInf_le_of_le a <| iInf_le_of_le ha <|
    iInf_le_of_le b <| iInf_le_of_le hb le_rfl

/-- A common candidate satisfying both admissibility requirements forces the
admissible-set distance to vanish. -/
theorem admissibleSetEDist_eq_zero_of_mem_inter {A B : Set X} {candidate : X}
    (h : candidate ∈ A ∩ B) :
    admissibleSetEDist A B = 0 := by
  exact le_antisymm
    (by simpa using admissibleSetEDist_le_edist_of_mem h.1 h.2)
    bot_le

/-- A certified strictly positive lower bound on the admissible-set distance proves that
the two admissible sets are disjoint. -/
theorem disjoint_of_pos_le_admissibleSetEDist {A B : Set X} {lower : ENNReal}
    (hpos : 0 < lower) (hlower : lower ≤ admissibleSetEDist A B) :
    Disjoint A B := by
  rw [Set.disjoint_left]
  intro candidate hA hB
  have hzero : admissibleSetEDist A B = 0 :=
    admissibleSetEDist_eq_zero_of_mem_inter ⟨hA, hB⟩
  have : lower ≤ 0 := by simpa [hzero] using hlower
  exact (not_lt_of_ge this) hpos

/-- Nonempty compact disjoint admissible sets attain their distance at a pair of points,
and that distance is strictly positive. -/
theorem exists_admissibleSetEDist_eq_edist_and_pos_of_compact
    {A B : Set X} (hA : IsCompact A) (hB : IsCompact B)
    (hneA : A.Nonempty) (hneB : B.Nonempty) (hdisjoint : Disjoint A B) :
    ∃ a ∈ A, ∃ b ∈ B,
      admissibleSetEDist A B = edist a b ∧ 0 < admissibleSetEDist A B := by
  obtain ⟨pair, hpair, hmin⟩ :=
    (hA.prod hB).exists_isMinOn (hneA.prod hneB) continuous_edist.continuousOn
  have heq : admissibleSetEDist A B = edist pair.1 pair.2 := by
    apply le_antisymm
    · exact admissibleSetEDist_le_edist_of_mem hpair.1 hpair.2
    · rw [admissibleSetEDist]
      refine le_iInf fun a => le_iInf fun ha => le_iInf fun b => le_iInf fun hb => ?_
      exact hmin (a := (a, b)) ⟨ha, hb⟩
  have hne : pair.1 ≠ pair.2 := by
    intro hequal
    exact (Set.disjoint_left.1 hdisjoint hpair.1) (by simpa [hequal] using hpair.2)
  exact ⟨pair.1, hpair.1, pair.2, hpair.2, heq, heq.symm ▸ edist_pos.2 hne⟩

/-- The extended admissible-set distance is finite when both sets are nonempty. -/
theorem admissibleSetEDist_ne_top_of_nonempty {A B : Set X}
    (hA : A.Nonempty) (hB : B.Nonempty) :
    admissibleSetEDist A B ≠ ⊤ := by
  obtain ⟨a, ha⟩ := hA
  obtain ⟨b, hb⟩ := hB
  exact ne_of_lt <| (admissibleSetEDist_le_edist_of_mem ha hb).trans_lt (edist_lt_top a b)

/-- The real-valued distance between two nonempty admissible sets. Nonemptiness is part of
the interface, so empty inputs cannot produce a finite reported value. -/
noncomputable def admissibleSetDist (A B : Set X)
    (_hA : A.Nonempty) (_hB : B.Nonempty) : ℝ :=
  (admissibleSetEDist A B).toReal

/-- Converting the real-valued nonempty-set distance back to `ENNReal` recovers the
extended admissible-set distance. -/
theorem ofReal_admissibleSetDist_eq_admissibleSetEDist {A B : Set X}
    (hA : A.Nonempty) (hB : B.Nonempty) :
    ENNReal.ofReal (admissibleSetDist A B hA hB) = admissibleSetEDist A B := by
  exact ENNReal.ofReal_toReal (admissibleSetEDist_ne_top_of_nonempty hA hB)

/-- Candidates whose spectral loss is within the declared spectral budget. -/
def spectralAdmissibleSet (spectralLoss : X → ℝ) (spectralBudget : ℝ) : Set X :=
  {candidate | spectralLoss candidate ≤ spectralBudget}

/-- Candidates whose restricted aligned-operator loss is within the declared operator
budget. -/
def alignedOperatorAdmissibleSet
    (alignedOperatorLoss : X → ℝ) (operatorBudget : ℝ) : Set X :=
  {candidate | alignedOperatorLoss candidate ≤ operatorBudget}

/-- One candidate satisfying both loss budgets forces zero distance between the spectral
and aligned-operator admissible sets. -/
theorem admissibleSetEDist_eq_zero_of_loss_bounds
    {spectralLoss alignedOperatorLoss : X → ℝ}
    {spectralBudget operatorBudget : ℝ} {candidate : X}
    (hSpectral : spectralLoss candidate ≤ spectralBudget)
    (hOperator : alignedOperatorLoss candidate ≤ operatorBudget) :
    admissibleSetEDist
      (spectralAdmissibleSet spectralLoss spectralBudget)
      (alignedOperatorAdmissibleSet alignedOperatorLoss operatorBudget) = 0 := by
  exact admissibleSetEDist_eq_zero_of_mem_inter ⟨hSpectral, hOperator⟩

/-- A certified positive separation between the two threshold-defined admissible sets
rules out every candidate satisfying both loss budgets. -/
theorem not_exists_jointly_admissible_of_pos_le_admissibleSetEDist
    {spectralLoss alignedOperatorLoss : X → ℝ}
    {spectralBudget operatorBudget : ℝ} {lower : ENNReal}
    (hpos : 0 < lower)
    (hlower : lower ≤ admissibleSetEDist
      (spectralAdmissibleSet spectralLoss spectralBudget)
      (alignedOperatorAdmissibleSet alignedOperatorLoss operatorBudget)) :
    ¬ ∃ candidate,
      spectralLoss candidate ≤ spectralBudget ∧
      alignedOperatorLoss candidate ≤ operatorBudget := by
  intro hJoint
  obtain ⟨candidate, hSpectral, hOperator⟩ := hJoint
  have hdisjoint := disjoint_of_pos_le_admissibleSetEDist hpos hlower
  exact (Set.disjoint_left.1 hdisjoint hSpectral) hOperator

end ProjectKoios.BandGauge.Geometry

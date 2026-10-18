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

end ProjectKoios.BandGauge.Geometry

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-01
-/
module

public import ProjectKoios.BandGauge.Fourier.Support.MetricShell
public import Mathlib.Algebra.Group.Pointwise.Finset.Basic
public import Mathlib.Basic.NNReal.Basic

/-!
# Complete-shell growth under support addition

This module proves exact addition and inversion laws for complete finite shells defined by a supplied
nonnegative radius.  The addition result requires the radius to be subadditive; the inversion result
requires exact invariance under mode negation.

The complete inventory is `Finset.univ`.  The declarations do not authenticate an external or
incomplete inventory, identify squared lattice-shell indices with a subadditive radius, assign
physical hopping-range semantics, or establish continuum decay.
-/

@[expose] public section

open scoped Pointwise

namespace ProjectKoios.BandGauge.Fourier.Support

variable {Mode : Type*} [AddCommGroup Mode] [Fintype Mode] [DecidableEq Mode]

/-- `BG-FOURIER-SUPPORT-LEM-001`: the sum of two complete shells for a subadditive nonnegative
radius lies in the complete shell at the sum of their cutoffs. -/
lemma metricShell_univ_add_subset
    (radius : Mode → NNReal) (leftRadius rightRadius : NNReal)
    (hadd : ∀ left right, radius (left + right) ≤ radius left + radius right) :
    metricShell Finset.univ radius leftRadius +
        metricShell Finset.univ radius rightRadius ⊆
      metricShell Finset.univ radius (leftRadius + rightRadius) := by
  rw [Finset.add_subset_iff]
  intro left hleft right hright
  rw [mem_metricShell] at hleft hright ⊢
  exact ⟨Finset.mem_univ _, (hadd left right).trans (add_le_add hleft.2 hright.2)⟩

/-- `BG-FOURIER-SUPPORT-LEM-002`: negation fixes every complete shell whose radius is inversion
invariant. -/
lemma neg_metricShell_univ_eq
    (radius : Mode → NNReal) (cutoff : NNReal)
    (hneg : ∀ mode, radius (-mode) = radius mode) :
    -(metricShell Finset.univ radius cutoff) =
      metricShell Finset.univ radius cutoff := by
  ext mode
  rw [Finset.mem_neg]
  constructor
  · rintro ⟨other, hother, hotherEq⟩
    subst mode
    rw [mem_metricShell] at hother ⊢
    exact ⟨Finset.mem_univ _, by rw [hneg]; exact hother.2⟩
  · intro hmode
    refine ⟨-mode, ?_, neg_neg mode⟩
    rw [mem_metricShell] at hmode ⊢
    exact ⟨Finset.mem_univ _, by rw [hneg]; exact hmode.2⟩

end ProjectKoios.BandGauge.Fourier.Support

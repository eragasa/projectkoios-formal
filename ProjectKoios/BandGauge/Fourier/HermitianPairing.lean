/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-19
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteParseval
public import Mathlib.LinearAlgebra.Matrix.ConjTranspose

/-!
# Hermitian finite Fourier pairing

This module proves the standard negative-mode/conjugate-transpose relation for the selected finite
Fourier convention.  It also proves that support truncation preserves the relation when the support
is closed under character negation, and that paired coefficients reconstruct a Hermitian matrix
field.

These are exact finite matrix statements.  They do not bind a character to a lattice vector, claim
that a support is a complete metric shell, or establish an external publication mesh.
-/

@[expose] public section

open scoped BigOperators ComplexConjugate Matrix
open Fintype (card)

namespace ProjectKoios.BandGauge.Fourier

variable {G n : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- `BG-FOURIER-DEF-011`: finite character support closed under mode negation. -/
def NegationClosedSupport (support : Finset (AddChar G ℂ)) : Prop :=
  ∀ mode, mode ∈ support ↔ -mode ∈ support

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-022`: Hermitian momentum fields have paired Fourier coefficients. -/
theorem finiteFourierCoefficient_neg_eq_conjTranspose
    (field : G → Matrix n n ℂ)
    (hHermitian : ∀ momentum, (field momentum)ᴴ = field momentum)
    (mode : AddChar G ℂ) :
    finiteFourierCoefficient field (-mode) =
      (finiteFourierCoefficient field mode)ᴴ := by
  ext i j
  simp [finiteFourierCoefficient, Matrix.conjTranspose_apply,
    AddChar.map_neg_eq_inv, AddChar.inv_apply_eq_conj]
  simp_rw [Matrix.sum_apply, Matrix.smul_apply]
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro momentum _
  have hentry : conj (field momentum j i) = field momentum i j := by
    simpa [Matrix.conjTranspose_apply] using
      congrFun (congrFun (hHermitian momentum) i) j
  simp [hentry]

omit [Fintype G] [DecidableEq G] in
/-- `BG-FOURIER-THM-023`: negation-closed truncation preserves coefficient pairing. -/
theorem truncateCoefficients_neg_eq_conjTranspose
    (support : Finset (AddChar G ℂ)) (hclosed : NegationClosedSupport support)
    (coefficients : AddChar G ℂ → Matrix n n ℂ)
    (hpair : ∀ mode, coefficients (-mode) = (coefficients mode)ᴴ)
    (mode : AddChar G ℂ) :
    truncateCoefficients support coefficients (-mode) =
      (truncateCoefficients support coefficients mode)ᴴ := by
  by_cases hmode : mode ∈ support
  · have hneg : -mode ∈ support := (hclosed mode).mp hmode
    simp [truncateCoefficients, hmode, hneg, hpair]
  · have hneg : -mode ∉ support := by
      intro hneg
      exact hmode ((hclosed mode).mpr hneg)
    simp [truncateCoefficients, hmode, hneg]

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-024`: paired matrix coefficients reconstruct a Hermitian field. -/
theorem finiteFourierReconstruction_conjTranspose_eq_self
    (coefficients : AddChar G ℂ → Matrix n n ℂ)
    (hpair : ∀ mode, coefficients (-mode) = (coefficients mode)ᴴ)
    (momentum : G) :
    (finiteFourierReconstruction coefficients momentum)ᴴ =
      finiteFourierReconstruction coefficients momentum := by
  rw [finiteFourierReconstruction, finiteReconstruction, Matrix.conjTranspose_sum]
  simp_rw [Matrix.conjTranspose_smul, ← hpair]
  calc
    (∑ mode : AddChar G ℂ, star (mode momentum) • coefficients (-mode)) =
        ∑ mode : AddChar G ℂ, (-mode) momentum • coefficients (-mode) := by
          apply Finset.sum_congr rfl
          intro mode _
          simp [AddChar.map_neg_eq_inv, AddChar.inv_apply_eq_conj]
    _ = ∑ mode : AddChar G ℂ, mode momentum • coefficients mode := by
      simpa using Equiv.sum_comp (Equiv.neg (AddChar G ℂ))
        (fun mode => mode momentum • coefficients mode)

omit [DecidableEq G] in
/-- `BG-FOURIER-THM-025`: negation-closed truncation reconstructs a Hermitian field. -/
theorem truncatedFiniteFourierReconstruction_conjTranspose_eq_self
    (support : Finset (AddChar G ℂ)) (hclosed : NegationClosedSupport support)
    (coefficients : AddChar G ℂ → Matrix n n ℂ)
    (hpair : ∀ mode, coefficients (-mode) = (coefficients mode)ᴴ)
    (momentum : G) :
    (finiteFourierReconstruction (truncateCoefficients support coefficients) momentum)ᴴ =
      finiteFourierReconstruction (truncateCoefficients support coefficients) momentum := by
  apply finiteFourierReconstruction_conjTranspose_eq_self
  intro mode
  exact truncateCoefficients_neg_eq_conjTranspose support hclosed coefficients hpair mode

end ProjectKoios.BandGauge.Fourier

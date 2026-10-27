/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.Data.Matrix.Basic

/-!
# Finite decomposition identifiability

An operator does not by itself identify an additive decomposition.  A declared nonzero shift can be
moved between the two summands without changing their sum.  These are exact algebraic statements;
they assign no physical meaning to either decomposition.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*}

/-- `QM-IDENTIFIABILITY-DEF-001`: first component after transferring a declared shift. -/
def shiftedFirstComponent (H S : Matrix ι ι ℝ) : Matrix ι ι ℝ := H - S

/-- `QM-IDENTIFIABILITY-DEF-002`: second component after transferring a declared shift. -/
def shiftedSecondComponent (_H S : Matrix ι ι ℝ) : Matrix ι ι ℝ := S

/-- `QM-IDENTIFIABILITY-THM-001`: shifting the two summands preserves their total operator. -/
theorem shiftedDecomposition_reconstructs (H S : Matrix ι ι ℝ) :
    shiftedFirstComponent H S + shiftedSecondComponent H S = H := by
  simp [shiftedFirstComponent, shiftedSecondComponent]

/--
`QM-IDENTIFIABILITY-THM-002`: a nonzero shift produces a decomposition distinct from the canonical
pair `(H, 0)` while reconstructing the same operator.
-/
theorem shiftedDecomposition_ne_canonical
    (H S : Matrix ι ι ℝ) (hS : S ≠ 0) :
    (shiftedFirstComponent H S, shiftedSecondComponent H S) ≠ (H, 0) := by
  intro h
  have hsecond : shiftedSecondComponent H S = 0 := congrArg Prod.snd h
  exact hS (by simpa [shiftedSecondComponent] using hsecond)

end ProjectKoios.QuantumMechanics.FiniteDimensional

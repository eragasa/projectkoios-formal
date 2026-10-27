/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import Mathlib.Analysis.InnerProductSpace.Basic

/-!
# Normalized complex state-vector representatives

This module defines normalized vector representatives and unit-modulus phase changes in a
complex inner-product space. It does not identify a vector with a physical ray, construct a
Hilbert-space completion, or assert a physical postulate.

## Equations implemented

- Normalization: `‖ψ‖ = 1`.
- Unit-modulus phase change: `ψ ↦ z • ψ` with `‖z‖ = 1`.

## Source status

The definitions are source-neutral supporting mathematics. A Shankar Chapter 4 crosswalk
and exact page/equation citations remain deferred until governed Search admission and
equation-locator evidence are available. No local PDF or protected archive expression was
used to author this module.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics

variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]

/-- `QM-STATE-DEF-001`: a unit-norm vector representative in a complex inner-product
space. This structure is not a quotient by global phase. -/
structure NormalizedStateVector (V : Type*) [NormedAddCommGroup V]
    [InnerProductSpace ℂ V] where
  vector : V
  norm_eq_one : ‖vector‖ = 1

/-- `QM-STATE-DEF-002`: multiplication of a normalized vector representative by a
unit-modulus complex phase. -/
def phaseShift (z : ℂ) (hz : ‖z‖ = 1)
    (ψ : NormalizedStateVector V) : NormalizedStateVector V where
  -- This changes the representative only; no quotient-by-phase type is introduced here.
  vector := z • ψ.vector
  norm_eq_one := by
    simp [norm_smul, hz, ψ.norm_eq_one]

end ProjectKoios.QuantumMechanics

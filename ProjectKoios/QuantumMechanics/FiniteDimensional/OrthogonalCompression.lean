/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Mathlib.Analysis.SpecialFunctions.Pow.Real
public import Mathlib.Data.Matrix.Basis
public import Mathlib.LinearAlgebra.Matrix.Symmetric
public import Mathlib.Tactic.NoncommRing

/-!
# Orthogonal-compression residual algebra

Exact finite matrix identities shared by controlled model-system calculations.  These
results do not identify runtime arrays with Lean matrices and do not assert that a
numerically constructed matrix is a projector.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- `QM-COMPRESSION-DEF-001`: complement of a declared finite projection. -/
def projectionComplement (P : Matrix ι ι ℝ) : Matrix ι ι ℝ := 1 - P

/-- `QM-COMPRESSION-DEF-002`: residual of a consistently compressed operator. -/
def consistentCompressionResidual (P H : Matrix ι ι ℝ) : Matrix ι ι ℝ :=
  P * H * P - P * H * P

/-- `QM-COMPRESSION-DEF-003`: embedded compression minus the full operator. -/
def unmatchedCompressionResidual (P H : Matrix ι ι ℝ) : Matrix ι ι ℝ :=
  P * H * P - H

/-- `QM-COMPRESSION-DEF-004`: negative discarded-sector block. -/
def discardedSectorResidual (P H : Matrix ι ι ℝ) : Matrix ι ι ℝ :=
  -(projectionComplement P * H * projectionComplement P)

omit [DecidableEq ι] in
/-- `QM-COMPRESSION-THM-001`: consistent compression has exactly zero residual. -/
theorem consistentCompressionResidual_eq_zero (P H : Matrix ι ι ℝ) :
    consistentCompressionResidual P H = 0 := by
  simp [consistentCompressionResidual]

/--
`QM-COMPRESSION-LEM-001`: a commuting idempotent projection gives an exact retained/discarded
block decomposition.
-/
lemma retained_add_discarded_eq
    (P H : Matrix ι ι ℝ) (hP : P * P = P) (hcomm : P * H = H * P) :
    P * H * P + projectionComplement P * H * projectionComplement P = H := by
  unfold projectionComplement
  noncomm_ring [hP, hcomm]

/--
`QM-COMPRESSION-THM-002`: for a commuting idempotent projection, unmatched compression equals the
negative discarded sector.  The commutation premise is the exact spectral-subspace boundary.
-/
theorem unmatchedCompressionResidual_eq_discardedSectorResidual
    (P H : Matrix ι ι ℝ) (hP : P * P = P) (hcomm : P * H = H * P) :
    unmatchedCompressionResidual P H = discardedSectorResidual P H := by
  rw [unmatchedCompressionResidual, discardedSectorResidual]
  have hdecomp := retained_add_discarded_eq P H hP hcomm
  have hretained : P * H * P = H - projectionComplement P * H * projectionComplement P :=
    eq_sub_of_add_eq hdecomp
  rw [hretained]
  abel

end ProjectKoios.QuantumMechanics.FiniteDimensional

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-26
-/
module

public import ProjectKoios.DensityFunctionalTheory.PAW.FiniteTransformation
public import Mathlib.Data.Matrix.Basic

/-!
# Finite-rank PAW projector augmentation

This module specializes the abstract finite PAW transformation to the finite-rank construction built
from all-electron partial waves, pseudo partial waves, and projector functions. For a finite channel
index `i`, define

`Δφᵢ = φᵢ - φ̃ᵢ`,

`T = I + ∑ i, |Δφᵢ⟩⟨p̃ᵢ|`.

The main theorem proves the pointwise finite-coordinate reconstruction formula

`T ψ̃ = ψ̃ + ∑ i, ⟨p̃ᵢ|ψ̃⟩ Δφᵢ`.

A separate duality predicate records `⟨p̃ᵢ|φ̃ⱼ⟩ = δᵢⱼ`. Under that explicit hypothesis, the
transformation maps each pseudo partial wave to its corresponding all-electron partial wave.

## Source locators

Blöchl, “Projector Augmented-Wave Method,” Physical Review B 50 (1994), DOI
`10.1103/PhysRevB.50.17953`, Section II.A:

* equations (6)--(7) for projector amplitudes and projector/pseudo-partial-wave duality;
* equation (8) for the finite-rank transformation;
* equation (9) for reconstructed states.

Proposed citekey: `Blochl1994`. The inspected PDF SHA-256 is
`a74d1f7c884153880c8c98b36a354b0d3af1c20777231e33d6b7965ad86589f6`. The scan equations were
checked against rendered page images; OCR was used only for discovery. The References-owned
canonical identity remains unresolved.

## Coordinate conventions

`State` indexes coordinates in one finite complex state space, and `Channel` indexes augmentation
triples. Kets are functions `State → ℂ`. The bra associated with a projector is represented by
`star projector`, so

`projectorAmplitude i ψ = star (p̃ i) ⬝ᵥ ψ`.

`Matrix.vecMulVec ket bra` represents the rank-one matrix `|ket⟩⟨bra|`. Consequently the correction
matrix has entries

`∑ i, (φᵢ(row) - φ̃ᵢ(row)) * conj (p̃ᵢ(column))`.

These conventions agree with the active reconstruction convention in `FiniteTransformation.lean`.
They are not passive coordinate changes.

## Formal scope

The state and channel carriers are finite, and the partial waves and projectors are supplied as
coordinate vectors. Projector duality is a separate hypothesis. No resolution-of-identity or
partial-wave completeness condition is assumed.

Accordingly, this module proves equations (8)--(9) and their direct consequences. Deriving the
explicit overlap expansion in equation (30) requires an additional completeness contract. Spatial
augmentation data and density or energy functionals require separate structures.
-/

open scoped BigOperators ComplexConjugate Matrix

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.PAW

/--
`DFT-PAW-PROJECTOR-DEF-001`: supplied finite all-electron partial waves, pseudo partial waves, and
projector vectors.

Finiteness is required at declarations that sum over channels or evaluate finite pairings. Duality
and completeness conditions are stated separately from the stored vectors.
-/
structure FiniteProjectorAugmentation (State Channel : Type*) where
  /-- All-electron partial wave `|φᵢ⟩` for one augmentation channel. -/
  allElectronPartialWave : Channel → State → ℂ
  /-- Smooth pseudo partial wave `|φ̃ᵢ⟩` for one augmentation channel. -/
  pseudoPartialWave : Channel → State → ℂ
  /-- Projector ket whose conjugate provides the bra `⟨p̃ᵢ|`. -/
  projector : Channel → State → ℂ

variable {State Channel : Type*} [Fintype State] [Fintype Channel]

/--
`DFT-PAW-PROJECTOR-DEF-002`: channel correction `Δφᵢ = φᵢ - φ̃ᵢ`.
-/
def FiniteProjectorAugmentation.partialWaveCorrection
    (data : FiniteProjectorAugmentation State Channel)
    (channel : Channel) : State → ℂ :=
  data.allElectronPartialWave channel - data.pseudoPartialWave channel

/--
`DFT-PAW-PROJECTOR-DEF-003`: projector amplitude `⟨p̃ᵢ|ψ⟩`.

The pairing is conjugate-linear in the stored projector vector and linear in the supplied state.
Source binding: Blöchl (1994), Section II.A, equations (6)--(7).
-/
def FiniteProjectorAugmentation.projectorAmplitude
    (data : FiniteProjectorAugmentation State Channel)
    (channel : Channel) (state : State → ℂ) : ℂ :=
  star (data.projector channel) ⬝ᵥ state

/--
`DFT-PAW-PROJECTOR-DEF-004`: finite-rank correction
`∑ᵢ |φᵢ - φ̃ᵢ⟩⟨p̃ᵢ|`.

`Matrix.vecMulVec` fixes the row/column and conjugation convention explicitly.
-/
def FiniteProjectorAugmentation.correctionMatrix
    (data : FiniteProjectorAugmentation State Channel) : Matrix State State ℂ :=
  ∑ channel, Matrix.vecMulVec (data.partialWaveCorrection channel)
    (star (data.projector channel))

/--
`DFT-PAW-PROJECTOR-DEF-005`: the finite-rank PAW transformation
`T = I + ∑ᵢ |φᵢ - φ̃ᵢ⟩⟨p̃ᵢ|`.

Source binding: Blöchl (1994), Section II.A, equation (8). This definition produces the abstract
`FinitePawTransformation` consumed by the operator, overlap, and generalized-eigenproblem layer.
-/
def FiniteProjectorAugmentation.transformation [DecidableEq State]
    (data : FiniteProjectorAugmentation State Channel) :
    FinitePawTransformation State :=
  1 + data.correctionMatrix

/--
`DFT-PAW-PROJECTOR-DEF-006`: projector/pseudo-partial-wave duality
`⟨p̃ᵢ|φ̃ⱼ⟩ = δᵢⱼ`.

The Kronecker delta is represented by an explicit `if`; the condition is an independent hypothesis
on the stored projector and pseudo-partial-wave families.
-/
def FiniteProjectorAugmentation.IsProjectorDual [DecidableEq Channel]
    (data : FiniteProjectorAugmentation State Channel) : Prop :=
  ∀ left right,
    data.projectorAmplitude left (data.pseudoPartialWave right) =
      if left = right then 1 else 0

/--
`DFT-PAW-PROJECTOR-LEM-001`: action of the correction matrix is the sum of projector amplitudes
multiplying their partial-wave corrections.

This supporting identity expands each rank-one matrix-vector product separately.
-/
lemma FiniteProjectorAugmentation.correctionMatrix_mulVec
    (data : FiniteProjectorAugmentation State Channel)
    (state : State → ℂ) :
    data.correctionMatrix *ᵥ state =
      ∑ channel, data.projectorAmplitude channel state •
        data.partialWaveCorrection channel := by
  simp only [FiniteProjectorAugmentation.correctionMatrix, Matrix.sum_mulVec,
    Matrix.vecMulVec_mulVec, FiniteProjectorAugmentation.projectorAmplitude]
  simp only [op_smul_eq_smul]

/--
`DFT-PAW-PROJECTOR-THM-001`: exact finite-rank PAW reconstructed-state formula.

Source locator: Blöchl (1994), DOI `10.1103/PhysRevB.50.17953`, Section II.A, equation (9), with the
transformation supplied by equation (8). Lean represents all kets as finite complex coordinate
vectors and all channel sums by `Fintype` enumeration.

No projector duality or completeness is required: the theorem is the direct action formula for the
defined finite-rank matrix.
-/
theorem FiniteProjectorAugmentation.reconstructState_eq_pseudoState_add_corrections
    [DecidableEq State]
    (data : FiniteProjectorAugmentation State Channel)
    (pseudoState : State → ℂ) :
    data.transformation.reconstructState pseudoState =
      pseudoState + ∑ channel, data.projectorAmplitude channel pseudoState •
        data.partialWaveCorrection channel := by
  -- Distribute matrix action across `I + correction`, reduce the identity action, and invoke the
  -- rank-one correction action proved immediately above.
  simp only [FiniteProjectorAugmentation.transformation,
    FinitePawTransformation.reconstructState, Matrix.add_mulVec, Matrix.one_mulVec,
    FiniteProjectorAugmentation.correctionMatrix_mulVec]

/--
`DFT-PAW-PROJECTOR-LEM-002`: exact projector duality makes the PAW transformation map each pseudo
partial wave to its corresponding all-electron partial wave.

The finite channel sum collapses to the selected channel via the explicit Kronecker-delta condition.
The proof uses duality only, not a resolution-of-identity hypothesis.
-/
lemma FiniteProjectorAugmentation.reconstructState_pseudoPartialWave
    [DecidableEq State] [DecidableEq Channel]
    (data : FiniteProjectorAugmentation State Channel)
    (hdual : data.IsProjectorDual) (channel : Channel) :
    data.transformation.reconstructState (data.pseudoPartialWave channel) =
      data.allElectronPartialWave channel := by
  rw [FiniteProjectorAugmentation.reconstructState_eq_pseudoState_add_corrections]
  rw [FiniteProjectorAugmentation.IsProjectorDual] at hdual
  simp_rw [hdual]
  simp [FiniteProjectorAugmentation.partialWaveCorrection]

omit [Fintype State] in
/--
`DFT-PAW-PROJECTOR-LEM-003`: if every all-electron partial wave equals its pseudo counterpart, the
finite-rank PAW transformation is the identity.

This is the zero-correction case of the finite-rank definition.
-/
lemma FiniteProjectorAugmentation.transformation_eq_one_of_partialWave_eq
    [DecidableEq State]
    (data : FiniteProjectorAugmentation State Channel)
    (hpartial : ∀ channel,
      data.allElectronPartialWave channel = data.pseudoPartialWave channel) :
    data.transformation = 1 := by
  simp [FiniteProjectorAugmentation.transformation,
    FiniteProjectorAugmentation.correctionMatrix,
    FiniteProjectorAugmentation.partialWaveCorrection, hpartial]

end ProjectKoios.DensityFunctionalTheory.PAW

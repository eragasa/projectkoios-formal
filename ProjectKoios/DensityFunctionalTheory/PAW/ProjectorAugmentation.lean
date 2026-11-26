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

Finite-coordinate partial waves and projectors define the projector augmented-wave reconstruction
map and its exact action on pseudo states.

## i. Overview

This module specializes the abstract finite PAW transformation to the finite-rank construction built
from supplied all-electron partial waves `φᵢ`, pseudo partial waves `φ̃ᵢ`, and projector vectors
`p̃ᵢ`. For each finite augmentation channel, define

`Δφᵢ = φᵢ - φ̃ᵢ`,

`T = I + ∑ i, |Δφᵢ⟩⟨p̃ᵢ|`.

The reconstructed state satisfies

`T ψ̃ = ψ̃ + ∑ i, ⟨p̃ᵢ|ψ̃⟩ Δφᵢ`.

`State` indexes coordinates in one finite complex state space, and `Channel` indexes augmentation
triples. Kets are functions `State → ℂ`; the bra associated with a projector is represented by
`star projector`. `Matrix.vecMulVec ket bra` represents `|ket⟩⟨bra|`. These are active
reconstruction conventions rather than passive coordinate changes.

Projector duality, `⟨p̃ᵢ|φ̃ⱼ⟩ = δᵢⱼ`, is an explicit independent hypothesis. No
resolution-of-identity or partial-wave completeness condition is assumed. Consequently the module
proves Blöchl's finite-rank transformation and reconstructed-state formulas and their direct finite
consequences, but not the explicit overlap expansion, spatial augmentation formulas, density
reconstruction, or energy-functional identities.

## ii. Key results

- `FiniteProjectorAugmentation`: supplied all-electron waves, pseudo waves, and projectors.
- `FiniteProjectorAugmentation.transformation`: the finite-rank PAW transformation.
- `FiniteProjectorAugmentation.IsProjectorDual`: projector and pseudo-partial-wave duality.
- `FiniteProjectorAugmentation.reconstructState_eq_pseudoState_add_corrections`: exact reconstructed
  state formula.
- `FiniteProjectorAugmentation.reconstructState_pseudoPartialWave`: partial-wave mapping under
  projector duality.

## iii. Table of contents

- A. Proof schematic
- B. Augmentation data and finite-rank transformation
- C. Projector duality
- D. Reconstruction identities

## iv. References

- P. E. Blöchl, “Projector Augmented-Wave Method,” *Physical Review B* 50 (1994), DOI
  `10.1103/PhysRevB.50.17953`, Section II.A, equations (6)--(9). Proposed citekey: `Blochl1994`.

The inspected PDF SHA-256 is
`a74d1f7c884153880c8c98b36a354b0d3af1c20777231e33d6b7965ad86589f6`. The equations were checked
against rendered page images; OCR was used only for discovery. The References-owned canonical
identity remains unresolved.

## A. Proof schematic

```mermaid
flowchart TD
    data["DFT-PAW-PROJECTOR-DEF-001<br/>augmentation data"]
    correction["DFT-PAW-PROJECTOR-DEF-002<br/>partial-wave correction"]
    amplitude["DFT-PAW-PROJECTOR-DEF-003<br/>projector amplitude"]
    matrix["DFT-PAW-PROJECTOR-DEF-004<br/>correction matrix"]
    transform["DFT-PAW-PROJECTOR-DEF-005<br/>PAW transformation"]
    duality["DFT-PAW-PROJECTOR-DEF-006<br/>projector duality"]
    action["DFT-PAW-PROJECTOR-LEM-001<br/>correction action"]
    reconstruction["DFT-PAW-PROJECTOR-THM-001<br/>state reconstruction"]
    partialWave["DFT-PAW-PROJECTOR-LEM-002<br/>partial-wave mapping"]
    identity["DFT-PAW-PROJECTOR-LEM-003<br/>zero-correction identity"]

    data --> correction
    data --> amplitude
    correction --> matrix
    amplitude --> action
    matrix --> action
    matrix --> transform
    transform --> reconstruction
    action --> reconstruction
    duality --> partialWave
    reconstruction --> partialWave
    correction --> identity
```
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

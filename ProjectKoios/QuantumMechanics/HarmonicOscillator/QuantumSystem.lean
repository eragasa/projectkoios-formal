/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.HarmonicOscillator.Continuum
public import Physlib.QuantumMechanics.QuantumSystem.Basic

/-!
# One-dimensional harmonic-oscillator quantum system

This module packages the closure of Physlib's one-dimensional continuum harmonic-oscillator
Hamiltonian as a self-adjoint `QuantumSystem`.

## i. Overview

`ProjectKoios.QuantumMechanics.HarmonicOscillator.hamiltonian_isEssentiallySelfAdjoint_one` proves
that the adopted Schwartz-core Hamiltonian is essentially self-adjoint. Physlib's
`QuantumSystem.mkESA` therefore packages its closure as the Hamiltonian of a quantum system.

This step fixes the self-adjoint operator associated with the core. It does not itself select a
spectral representation or bind time evolution. The downstream
`ProjectKoios.QuantumMechanics.HarmonicOscillator.SpectralEvolution` module selects the adopted
Cayley spectral measure and applies the generic physical convention
`U(t) = exp(-i t H / ℏ)`.

## ii. Key results

- `oneDimensionalQuantumSystem`
- `oneDimensionalQuantumSystem_hamiltonian_eq_closure`
- `oneDimensionalQuantumSystem_hamiltonian_isSelfAdjoint`

## iii. Table of contents

- A. Proof schematic
- B. Quantum-system packaging

## iv. References

The packaging constructor is reused from Physlib revision
`101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`, specifically
`Physlib.QuantumMechanics.QuantumSystem.Basic`.

## A. Proof schematic

```mermaid
flowchart LR
    core["Physlib one-dimensional<br/>Schwartz-core Hamiltonian"]
    esa["QHO-CONTINUUM-LEM-009<br/>essential self-adjointness"]
    closure["operator closure"]
    system["QHO-SYSTEM-DEF-001<br/>QuantumSystem.mkESA"]

    core --> esa
    esa --> closure
    closure --> system
```
-/

@[expose] public section

noncomputable section

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

open _root_.QuantumMechanics

/-! ## B. Quantum-system packaging -/

/-- The quantum system obtained by closing Physlib's essentially self-adjoint one-dimensional
continuum harmonic-oscillator Hamiltonian.

Project Koios ID: `QHO-SYSTEM-DEF-001`. -/
noncomputable def oneDimensionalQuantumSystem
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) : QuantumSystem :=
  QuantumSystem.mkESA (hamiltonian_isEssentiallySelfAdjoint_one Q)

/-- The Hamiltonian packaged by `oneDimensionalQuantumSystem` is exactly the closure of the adopted
Schwartz-core oscillator Hamiltonian.

Project Koios ID: `QHO-SYSTEM-LEM-001`. -/
lemma oneDimensionalQuantumSystem_hamiltonian_eq_closure
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    (oneDimensionalQuantumSystem Q).ℋ = Q.hamiltonian.closure := rfl

/-- The Hamiltonian of `oneDimensionalQuantumSystem` is self-adjoint.

Project Koios ID: `QHO-SYSTEM-LEM-002`. -/
lemma oneDimensionalQuantumSystem_hamiltonian_isSelfAdjoint
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    IsSelfAdjoint (oneDimensionalQuantumSystem Q).ℋ :=
  (oneDimensionalQuantumSystem Q).ℋ_self_adjoint

end ProjectKoios.QuantumMechanics.HarmonicOscillator

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.Evolution.Schrodinger
public import ProjectKoios.QuantumMechanics.HarmonicOscillator.QuantumSystem
public import PhyslibAlpha.ProbabilisticTheory.HilbertSpace.Unbounded.CayleySpectralData.SpecTheorem

/-!
# One-dimensional oscillator spectral measure and evolution

This module binds the unconditionally essentially self-adjoint one-dimensional continuum
harmonic-oscillator Hamiltonian to PhyslibAlpha's domain-aware unbounded spectral theorem and the
Project Koios physical Schrödinger convention.

## i. Overview

The selected spectral measure is exactly PhyslibAlpha's Cayley-transform spectral measure for the
self-adjoint closure of Physlib's Schwartz-core oscillator Hamiltonian. The physical evolution is

`U(t) = exp(-i t H̄ / ℏ)`,

implemented by passing `-t / ℏ` to the Alpha group `exp(i s H̄)`. Here `H̄` is the same closure
packaged as `(oneDimensionalQuantumSystem Q).ℋ`.

No alternative spectral theorem, functional calculus, or strong-group structure is introduced.

## ii. Key declarations

- `oneDimensionalSpectralMeasure`
- `oneDimensionalSpectralTheorem`
- `oneDimensionalQuantumSystem_spectralTheorem`
- `oneDimensionalTimeEvolution`
- `oneDimensionalTimeEvolution_hasDerivAt`
- `oneDimensionalTimeEvolution_mem_hamiltonian_domain`
- `oneDimensionalTimeEvolution_commutes_hamiltonian`

## iii. Proof schematic

```mermaid
flowchart LR
    core["Schwartz-core oscillator H"]
    esa["QHO-CONTINUUM-LEM-009<br/>H essentially self-adjoint"]
    closure["self-adjoint closure H̄"]
    spectral["QHO-SPECTRAL-LEM-001<br/>domain-aware Cayley spectral theorem"]
    alpha["PhyslibAlpha exp(i s H̄)"]
    physical["QHO-EVOLUTION-DEF-001<br/>U(t)=exp(-itH̄/ℏ)"]
    stone["derivative, domain invariance,<br/>and commutation"]

    core --> esa
    esa --> closure
    closure --> spectral
    spectral --> alpha
    alpha --> physical
    physical --> stone
```

## iv. Source identity and boundaries

The adopted dependency revision is Physlib commit
`101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`. The concrete construction reuses:

- `unboundedSpectralTheorem_of_essentiallySelfAdjoint` and `cayleyRealSpectralMeasure` from
  `PhyslibAlpha/ProbabilisticTheory/HilbertSpace/Unbounded/CayleySpectralData/SpecTheorem.lean`;
- the strong Stone derivative and invariance results from `Flow/Stone.lean` and
  `Flow/StoneInvariance.lean`; and
- Physlib's concrete positive `Constants.ℏ` through the Project Koios convention adapter.

The declarations establish exact formal spectral and evolution statements for the adopted
one-dimensional oscillator operator. They do not supply a spectral eigenfunction expansion,
numerical propagator, measured time unit, or physical-model validation.
-/

@[expose] public section

noncomputable section

namespace ProjectKoios.QuantumMechanics.HarmonicOscillator

open _root_.QuantumMechanics
open PhyslibAlpha.ProbabilisticTheory
open _root_.ProjectKoios.QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem

/-! ## A. Domain-aware spectral theorem -/

/-- PhyslibAlpha's Cayley-transform spectral measure for the self-adjoint closure of the
one-dimensional continuum oscillator Hamiltonian.

Project Koios ID: `QHO-SPECTRAL-DEF-001`. -/
noncomputable def oneDimensionalSpectralMeasure
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    QuantumMechanics.WOTSpectralMeasure ℝ Q.HS :=
  QuantumMechanics.cayleyRealSpectralMeasure Q.hamiltonian.closure
    (hamiltonian_isEssentiallySelfAdjoint_one Q)

/-- The selected Cayley spectral measure resolves the closed one-dimensional oscillator
Hamiltonian and identifies its domain with the finite second spectral-moment vectors.

Project Koios ID: `QHO-SPECTRAL-LEM-001`. -/
lemma oneDimensionalSpectralTheorem
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem Q.hamiltonian.closure
      (oneDimensionalSpectralMeasure Q) := by
  unfold oneDimensionalSpectralMeasure
  exact QuantumMechanics.unboundedSpectralTheorem_of_essentiallySelfAdjoint
    Q.hamiltonian (hamiltonian_isEssentiallySelfAdjoint_one Q)

/-- Membership in the closed oscillator Hamiltonian domain is equivalent to finiteness of the
second moment of the selected spectral measure.

Project Koios ID: `QHO-SPECTRAL-LEM-002`. -/
lemma oneDimensionalSpectralTheorem_mem_domain_iff
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (x : Q.HS) :
    x ∈ Q.hamiltonian.closure.domain ↔
      x ∈ QuantumMechanics.spectralSquareMomentDomain (oneDimensionalSpectralMeasure Q) := by
  exact (oneDimensionalSpectralTheorem Q).mem_domain_iff x

/-- The selected spectral measure weakly reconstructs the closed oscillator Hamiltonian on its
exact domain.

Project Koios ID: `QHO-SPECTRAL-LEM-003`. -/
lemma oneDimensionalSpectralTheorem_reconstruction
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    QuantumMechanics.IsWeakSpectralResolution Q.hamiltonian.closure
      (oneDimensionalSpectralMeasure Q) :=
  (oneDimensionalSpectralTheorem Q).reconstruction_of

/-- The selected spectral theorem is a spectral theorem for the Hamiltonian of the packaged
one-dimensional quantum system.

Project Koios ID: `QHO-SPECTRAL-LEM-004`. -/
lemma oneDimensionalQuantumSystem_spectralTheorem
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    QuantumMechanics.DomainAwareSelfAdjointSpectralTheorem
      (oneDimensionalQuantumSystem Q).ℋ (oneDimensionalSpectralMeasure Q) := by
  rw [oneDimensionalQuantumSystem_hamiltonian_eq_closure]
  exact oneDimensionalSpectralTheorem Q

/-! ## B. Convention-fixed physical evolution -/

/-- Physical time evolution `exp(-i t H̄ / ℏ)` for the closed one-dimensional oscillator
Hamiltonian.

Project Koios ID: `QHO-EVOLUTION-DEF-001`. -/
noncomputable def oneDimensionalTimeEvolution
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (t : ℝ) : Q.HS →WOT[ℂ] Q.HS :=
  schrodingerEvolution (oneDimensionalSpectralTheorem Q) t

/-- Oscillator time evolution is the identity at zero.

Project Koios ID: `QHO-EVOLUTION-LEM-001`. -/
@[simp]
lemma oneDimensionalTimeEvolution_zero
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) :
    oneDimensionalTimeEvolution Q 0 = 1 := by
  exact schrodingerEvolution_zero (oneDimensionalSpectralTheorem Q)

/-- Oscillator time evolution obeys the additive group law.

Project Koios ID: `QHO-EVOLUTION-LEM-002`. -/
lemma oneDimensionalTimeEvolution_add
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (t s : ℝ) :
    oneDimensionalTimeEvolution Q (t + s) =
      oneDimensionalTimeEvolution Q t * oneDimensionalTimeEvolution Q s := by
  exact schrodingerEvolution_add (oneDimensionalSpectralTheorem Q) t s

/-- Oscillator time evolution is unitary at every time.

Project Koios ID: `QHO-EVOLUTION-LEM-003`. -/
lemma oneDimensionalTimeEvolution_mem_unitary
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (t : ℝ) :
    oneDimensionalTimeEvolution Q t ∈ unitary (Q.HS →WOT[ℂ] Q.HS) := by
  exact schrodingerEvolution_mem_unitary (oneDimensionalSpectralTheorem Q) t

/-- Every oscillator time-evolution orbit is strongly continuous.

Project Koios ID: `QHO-EVOLUTION-LEM-004`. -/
lemma oneDimensionalTimeEvolution_continuous_apply
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (x : Q.HS) :
    Continuous (fun t => oneDimensionalTimeEvolution Q t x) := by
  exact schrodingerEvolution_continuous_apply (oneDimensionalSpectralTheorem Q) x

/-- The adjoint of oscillator evolution at time `t` is evolution at time `-t`.

Project Koios ID: `QHO-EVOLUTION-LEM-005`. -/
lemma oneDimensionalTimeEvolution_star
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (t : ℝ) :
    star (oneDimensionalTimeEvolution Q t) = oneDimensionalTimeEvolution Q (-t) := by
  exact schrodingerEvolution_star (oneDimensionalSpectralTheorem Q) t

/-- On the closed Hamiltonian domain, the oscillator orbit derivative at zero is
`(-i/ℏ) H̄ x`.

Project Koios ID: `QHO-EVOLUTION-LEM-006`. -/
lemma oneDimensionalTimeEvolution_hasDerivAt_zero
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (x : Q.hamiltonian.closure.domain) :
    HasDerivAt (fun t : ℝ => oneDimensionalTimeEvolution Q t (x : Q.HS))
      ((-Complex.I / (Constants.ℏ : ℂ)) • Q.hamiltonian.closure x) 0 := by
  exact schrodingerEvolution_hasDerivAt_zero (oneDimensionalSpectralTheorem Q) x

/-- On the closed Hamiltonian domain, the oscillator orbit derivative at time `t` is the evolved
vector `(-i/ℏ) H̄ x`.

Project Koios ID: `QHO-EVOLUTION-LEM-007`. -/
lemma oneDimensionalTimeEvolution_hasDerivAt
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (x : Q.hamiltonian.closure.domain) (t : ℝ) :
    HasDerivAt (fun s : ℝ => oneDimensionalTimeEvolution Q s (x : Q.HS))
      (oneDimensionalTimeEvolution Q t
        ((-Complex.I / (Constants.ℏ : ℂ)) • Q.hamiltonian.closure x)) t := by
  exact schrodingerEvolution_hasDerivAt (oneDimensionalSpectralTheorem Q) x t

/-- Oscillator time evolution preserves the closed Hamiltonian domain.

Project Koios ID: `QHO-EVOLUTION-LEM-008`. -/
lemma oneDimensionalTimeEvolution_mem_hamiltonian_domain
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (x : Q.hamiltonian.closure.domain) (t : ℝ) :
    oneDimensionalTimeEvolution Q t (x : Q.HS) ∈ Q.hamiltonian.closure.domain := by
  exact schrodingerEvolution_mem_domain (oneDimensionalSpectralTheorem Q) x t

/-- The closed oscillator Hamiltonian commutes with physical time evolution on its domain.

Project Koios ID: `QHO-EVOLUTION-LEM-009`. -/
lemma oneDimensionalTimeEvolution_commutes_hamiltonian
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1)
    (x : Q.hamiltonian.closure.domain) (t : ℝ) :
    Q.hamiltonian.closure
        ⟨oneDimensionalTimeEvolution Q t (x : Q.HS),
          oneDimensionalTimeEvolution_mem_hamiltonian_domain Q x t⟩ =
      oneDimensionalTimeEvolution Q t (Q.hamiltonian.closure x) := by
  exact schrodingerEvolution_commutes (oneDimensionalSpectralTheorem Q) x t

/-- The concrete oscillator evolution is exactly the convention-fixed Schrödinger evolution
of the packaged quantum-system Hamiltonian.

Project Koios ID: `QHO-EVOLUTION-LEM-010`. -/
lemma oneDimensionalTimeEvolution_eq_quantumSystem_schrodingerEvolution
    (Q : _root_.QuantumMechanics.HarmonicOscillator 1) (t : ℝ) :
    oneDimensionalTimeEvolution Q t =
      schrodingerEvolution (oneDimensionalQuantumSystem_spectralTheorem Q) t := by
  rfl

end ProjectKoios.QuantumMechanics.HarmonicOscillator

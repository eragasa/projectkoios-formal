/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.QuantumMechanics.Operator.Schrodinger
public import Physlib.QuantumMechanics.Hydrogen.Basic

/-!
# Singular Coulomb Hamiltonian bridge

This module combines Project Koios's general Schrödinger symmetry theorem with Physlib's dense-domain
analysis for the unregularized hydrogenic potential `V(x) = -k / ‖x‖`.

## i. Overview

Physlib's `HydrogenAtom` reuses `SpaceDQuantumSystem` and supplies two facts specific to the singular
Coulomb multiplier:

- the potential is almost-everywhere strongly measurable; and
- the Hamiltonian domain contains a dense submodule of polynomially bounded Schwartz maps in every
  dimension.

The first fact makes the real maximal multiplication operator self-adjoint and hence makes the
kinetic-plus-potential sum symmetric. The second gives the common dense domain needed for
closability. Together they prove Physlib's `LinearPMap.IsUnbounded` predicate for the unregularized
hydrogenic Hamiltonian.

This result covers symmetry, dense-definedness, and closability only. It does not identify the exact
operator domain, prove essential self-adjointness or self-adjointness, package a `QuantumSystem`, or
establish the hydrogen spectrum. In particular, Physlib's dimension-dependent
essential-self-adjointness statements remain TODOs at the adopted revision.

## ii. Key results

- `HydrogenAtom.hamiltonianOperator_isSymmetric`
- `HydrogenAtom.hamiltonianOperator_isUnbounded`

## iii. Table of contents

- A. Proof schematic
- B. Singular Coulomb Hamiltonian

## iv. References

The hydrogenic carrier, potential, measurability proof, and dense polynomially bounded Schwartz
submodule are reused from Physlib revision `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`, module
`Physlib.QuantumMechanics.Hydrogen.Basic`. The two DOI references listed by that upstream module are
not independently used here as authority for a stronger mathematical or physical claim.

## A. Proof schematic

```mermaid
flowchart TD
    coulomb["Physlib HydrogenAtom<br/>V(x) = -k / ‖x‖"]
    measurable["potential_AESM"]
    dense["hamiltonianOperator_hasDenseDomain<br/>dense polynomially bounded Schwartz core"]
    generic["QM-SCHRODINGER-LEM-006<br/>measurable real potential gives symmetry"]
    symmetric["QM-HYDROGEN-LEM-001<br/>Hamiltonian symmetric"]
    closable["QM-HYDROGEN-LEM-002<br/>Hamiltonian densely defined and closable"]

    coulomb --> measurable
    coulomb --> dense
    measurable --> generic
    generic --> symmetric
    symmetric --> closable
    dense --> closable
```
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics.HydrogenAtom

open _root_.QuantumMechanics

variable {d : ℕ}

/-! ## B. Singular Coulomb Hamiltonian -/

/-- The unregularized Physlib hydrogenic Hamiltonian is symmetric on its intersection domain.

Project Koios ID: `QM-HYDROGEN-LEM-001`. -/
lemma hamiltonianOperator_isSymmetric (H : _root_.QuantumMechanics.HydrogenAtom d) :
    H.hamiltonianOperator.IsSymmetric :=
  ProjectKoios.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_isSymmetric
    H.potential_AESM

/-- The unregularized Physlib hydrogenic Hamiltonian is densely defined and closable in every
spatial dimension. Physlib calls this conjunction `IsUnbounded`; no essential-self-adjointness
claim follows.

Project Koios ID: `QM-HYDROGEN-LEM-002`. -/
lemma hamiltonianOperator_isUnbounded (H : _root_.QuantumMechanics.HydrogenAtom d) :
    H.hamiltonianOperator.IsUnbounded :=
  (hamiltonianOperator_isSymmetric H).isUnbounded_iff_hasDenseDomain.mpr
    H.hamiltonianOperator_hasDenseDomain

end ProjectKoios.QuantumMechanics.HydrogenAtom

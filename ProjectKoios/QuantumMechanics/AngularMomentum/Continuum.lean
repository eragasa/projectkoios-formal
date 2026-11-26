/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-27
-/
module

public import Physlib.QuantumMechanics.Operators.AngularMomentum.DimThree

/-!
# Three-dimensional continuum orbital angular momentum

This module provides a thin Project Koios binding to Physlib's three-dimensional orbital angular
momentum operators. The Cartesian components and their square act on `SpaceDHilbertSpace 3` with
the common invariant Schwartz domain. The binding records their domains, range invariance,
symmetry, dense closability in Physlib's `IsUnbounded` terminology, and the domain-evaluated
Cartesian commutation laws.

The operators here are the upstream Physlib operators, not new closed or self-adjoint realizations.
Symmetry and closability do not imply essential self-adjointness, select closures, or justify a
spectral decomposition. Coordinate order is Physlib's right-handed `x = 0`, `y = 1`, `z = 2`, and
the physical commutator contains Physlib's positive constant `Constants.ℏ`.
-/

@[expose] public section

noncomputable section

open scoped BigOperators

namespace ProjectKoios.QuantumMechanics.AngularMomentum

open _root_.QuantumMechanics
open _root_.QuantumMechanics.SpaceDHilbertSpace

/-- `QM-ANGULAR-CONTINUUM-DEF-001`: Physlib's Cartesian orbital-angular-momentum component on
three-dimensional configuration-space `L²`, with Schwartz domain. -/
def orbitalAngularMomentumComponent (i : Fin 3) :=
  _root_.QuantumMechanics.angularMomentumDimThreeOperator i

/-- `QM-ANGULAR-CONTINUUM-DEF-002`: Physlib's orbital-angular-momentum square on
three-dimensional configuration-space `L²`, with Schwartz domain. -/
def orbitalAngularMomentumSquared :=
  _root_.QuantumMechanics.angularMomentumSqOperator (d := 3)

/-- `QM-ANGULAR-CONTINUUM-LEM-001`: every Cartesian component has exactly the common Schwartz
domain. -/
lemma orbitalAngularMomentumComponent_domain (i : Fin 3) :
    (orbitalAngularMomentumComponent i).domain = SchwartzSubmodule 3 := by
  rfl

/-- `QM-ANGULAR-CONTINUUM-LEM-002`: every Cartesian component maps its Schwartz domain back into
that domain. -/
lemma orbitalAngularMomentumComponent_range (i : Fin 3) (ψ : SchwartzSubmodule 3) :
    orbitalAngularMomentumComponent i ψ ∈ SchwartzSubmodule 3 := by
  exact angularMomentumDimThreeOperator_range i ψ

/-- `QM-ANGULAR-CONTINUUM-LEM-003`: every Cartesian component is symmetric on the Schwartz
domain. -/
lemma orbitalAngularMomentumComponent_isSymmetric (i : Fin 3) :
    (orbitalAngularMomentumComponent i).IsSymmetric := by
  exact angularMomentumDimThreeOperator_isSymmetric i

/-- `QM-ANGULAR-CONTINUUM-LEM-004`: in Physlib terminology, every Cartesian component is densely
defined and closable. -/
lemma orbitalAngularMomentumComponent_isUnbounded (i : Fin 3) :
    (orbitalAngularMomentumComponent i).IsUnbounded := by
  exact angularMomentumDimThreeOperator_isUnbounded i

/-- `QM-ANGULAR-CONTINUUM-LEM-005`: the squared orbital-angular-momentum operator has exactly the
Schwartz domain. -/
lemma orbitalAngularMomentumSquared_domain :
    orbitalAngularMomentumSquared.domain = SchwartzSubmodule 3 := by
  rfl

/-- `QM-ANGULAR-CONTINUUM-LEM-006`: the squared operator preserves its Schwartz domain. -/
lemma orbitalAngularMomentumSquared_range (ψ : SchwartzSubmodule 3) :
    orbitalAngularMomentumSquared ψ ∈ SchwartzSubmodule 3 := by
  exact angularMomentumSqOperator_range ψ

/-- `QM-ANGULAR-CONTINUUM-LEM-007`: the squared operator is symmetric on the Schwartz domain. -/
lemma orbitalAngularMomentumSquared_isSymmetric : orbitalAngularMomentumSquared.IsSymmetric := by
  exact angularMomentumSqOperator_isSymmetric

/-- `QM-ANGULAR-CONTINUUM-LEM-008`: in Physlib terminology, the squared operator is densely
defined and closable. -/
lemma orbitalAngularMomentumSquared_isUnbounded : orbitalAngularMomentumSquared.IsUnbounded := by
  exact angularMomentumSqOperator_isUnbounded

/-- `QM-ANGULAR-CONTINUUM-LEM-009`: the Cartesian components satisfy
`[Lᵢ,Lⱼ]ψ = iℏ ∑ₖ εᵢⱼₖ Lₖψ` on their common invariant Schwartz domain. -/
lemma orbitalAngularMomentumComponent_commutation
    (i j : Fin 3) (ψ : SchwartzSubmodule 3) :
    orbitalAngularMomentumComponent i
        ⟨orbitalAngularMomentumComponent j ψ, angularMomentumDimThreeOperator_range j ψ⟩ -
      orbitalAngularMomentumComponent j
        ⟨orbitalAngularMomentumComponent i ψ, angularMomentumDimThreeOperator_range i ψ⟩ =
      (Complex.I * Constants.ℏ) • ∑ k : Fin 3,
        (leviCivitaSymbol ![i, j, k] : ℂ) • orbitalAngularMomentumComponent k ψ := by
  exact angularMomentumDimThreeOperator_commutation i j ψ

/-- `QM-ANGULAR-CONTINUUM-LEM-010`: orbital angular momentum squared commutes with every Cartesian
component on the common invariant Schwartz domain. -/
lemma orbitalAngularMomentumSquared_commutation
    (i : Fin 3) (ψ : SchwartzSubmodule 3) :
    orbitalAngularMomentumSquared
        ⟨orbitalAngularMomentumComponent i ψ, angularMomentumDimThreeOperator_range i ψ⟩ -
      orbitalAngularMomentumComponent i
        ⟨orbitalAngularMomentumSquared ψ, angularMomentumSqOperator_range ψ⟩ = 0 := by
  exact angularMomentumSqOperator_commutation_dimThree i ψ

end ProjectKoios.QuantumMechanics.AngularMomentum

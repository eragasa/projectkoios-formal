/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-26
-/
module

public import Mathlib.Basic.Complex.Basic
public import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Source-neutral finite-basis orbital expansion

This module owns the finite algebra that reconstructs complex scalar orbital amplitudes from a
finite basis and a coefficient table. It is independent of density-functional theory: the same
expansion can be used for any finite-basis quantum model.

For basis labels `μ`, orbital labels `i`, and positions `r`, the convention is
`ψᵢ(r) = ∑ μ, C μ i * χ μ r`. Coefficients multiply basis-function values on the left. Since the
scalar field is `ℂ`, this order is algebraically commutative, but it is fixed explicitly so later
matrix and publication crosswalks do not infer a convention.

The position carrier is arbitrary and purely pointwise. No measure, spatial dimension,
normalization, orthogonality, completeness, kinetic operator, Hamiltonian, eigenproblem, density,
or physical interpretation is asserted. In particular, this module does not own Kohn--Sham or PAW
semantics.

## Dependency role

The Kohn--Sham layer may map `orbitalAmplitude` into its pointwise orbital-density API. A later PAW
layer may act on coefficient or basis representations, but must state its transformation convention
separately. Generic frame projectors and right-unitary frame algebra are not duplicated here; the
repository already contains such algebra in a separate established declaration family whose future
shared ownership requires explicit review.
-/

open scoped BigOperators

@[expose] public section

namespace ProjectKoios.QuantumMechanics.FiniteDimensional

/--
`QM-ORBITAL-EXPANSION-DEF-001`: data for complex scalar orbitals expanded in a finite basis.

The `Fintype Basis` parameter makes the reconstructed sum finite. The orbital and position carriers
may remain arbitrary. Neither field includes normalization or orthogonality evidence.
-/
structure FiniteBasisOrbitalExpansion
    (Basis Orbital Position : Type*) [Fintype Basis] where
  /-- Pointwise value `χ μ r` of one basis function. -/
  basisFunction : Basis → Position → ℂ
  /-- Coefficient `C μ i` of basis function `μ` in orbital `i`. -/
  coefficient : Basis → Orbital → ℂ

variable {Basis Orbital Position : Type*} [Fintype Basis]

/--
`QM-ORBITAL-EXPANSION-DEF-002`: reconstruct one orbital amplitude as
`ψᵢ(r) = ∑ μ, C μ i * χ μ r`.

This is a finite algebraic sum. It does not claim that the basis spans a function space or that the
result satisfies an eigenvalue equation.
-/
def FiniteBasisOrbitalExpansion.orbitalAmplitude
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (orbital : Orbital) (position : Position) : ℂ :=
  ∑ basis, expansion.coefficient basis orbital * expansion.basisFunction basis position

/--
`QM-ORBITAL-EXPANSION-DEF-003`: retain the basis functions while replacing the coefficient table.

This construction supports exact coefficient-linearity lemmas without changing the basis
convention or position carrier.
-/
def FiniteBasisOrbitalExpansion.withCoefficient
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (coefficient : Basis → Orbital → ℂ) :
    FiniteBasisOrbitalExpansion Basis Orbital Position where
  basisFunction := expansion.basisFunction
  coefficient := coefficient

/--
`QM-ORBITAL-EXPANSION-LEM-001`: zero coefficients reconstruct the zero orbital amplitude.

The proof unfolds the finite sum and uses only the zero laws of `ℂ`.
-/
lemma FiniteBasisOrbitalExpansion.orbitalAmplitude_withCoefficient_zero
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (orbital : Orbital) (position : Position) :
    (expansion.withCoefficient 0).orbitalAmplitude orbital position = 0 := by
  simp [FiniteBasisOrbitalExpansion.withCoefficient,
    FiniteBasisOrbitalExpansion.orbitalAmplitude]

/--
`QM-ORBITAL-EXPANSION-LEM-002`: reconstruction is additive in the coefficient table when the basis
functions are fixed.

This is pointwise coefficient linearity only; it does not assert linear independence of the basis or
uniqueness of the coefficient table.
-/
lemma FiniteBasisOrbitalExpansion.orbitalAmplitude_withCoefficient_add
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (coefficient₁ coefficient₂ : Basis → Orbital → ℂ)
    (orbital : Orbital) (position : Position) :
    (expansion.withCoefficient (coefficient₁ + coefficient₂)).orbitalAmplitude orbital position =
      (expansion.withCoefficient coefficient₁).orbitalAmplitude orbital position +
        (expansion.withCoefficient coefficient₂).orbitalAmplitude orbital position := by
  -- Distribute each coefficient sum through multiplication by the fixed basis value, then split
  -- the finite sum. No basis property is used.
  simp only [FiniteBasisOrbitalExpansion.withCoefficient,
    FiniteBasisOrbitalExpansion.orbitalAmplitude, Pi.add_apply, add_mul,
    Finset.sum_add_distrib]

end ProjectKoios.QuantumMechanics.FiniteDimensional

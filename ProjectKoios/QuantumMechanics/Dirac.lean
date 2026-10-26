/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.QuantumMechanics.State
public import Mathlib.Analysis.InnerProductSpace.Adjoint
public import Mathlib.Analysis.InnerProductSpace.Dual

/-!
# Typed ket, bra, bracket, and rank-one operators

This module gives source-neutral named definitions for ordinary Hilbert-space Dirac objects.
A ket is the underlying vector. A bra is a bounded complex-linear functional. The map from a
ket to its Riesz bra is conjugate-linear because Mathlib's inner product is conjugate-linear
in its first argument and linear in its second argument.

The definitions remain named and authoritative; this module deliberately does not introduce
decorative parser notation. Generalized kets for continuous spectra do not inhabit the `Ket`
type below. They require a separately specified rigged Hilbert space and a test-space dual.

## Equations implemented

For vectors `ψ`, `φ`, `χ`, and `ω`:

- Riesz bra evaluation: `braOfKet ψ φ = ⟪ψ, φ⟫_ℂ`.
- Conjugate scaling: `braOfKet (z • ψ) = conj z • braOfKet ψ`.
- Bracket: `bracket ψ φ = ⟪ψ, φ⟫_ℂ`.
- Outer-product action: `outerProduct ψ φ χ = ⟪φ, χ⟫_ℂ • ψ`.
- Rank-one composition:
  `(outerProduct ψ φ) ∘L (outerProduct χ ω) = bracket φ χ • outerProduct ψ ω`.
- For normalized `ψ`, `pureStateProjector ψ` fixes `ψ`, is idempotent, and, on a complete
  Hilbert space, is self-adjoint.

## Source status

These are source-neutral inner-product-space results. A textbook crosswalk and exact
page/equation citations remain deferred until governed source admission and equation-locator
evidence are available. No local PDF or protected archive expression was used to author this
module.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics

open ContinuousLinearMap
open InnerProductSpace

variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]

/-- `QM-DIRAC-DEF-001`: an ordinary ket is a vector in the declared complex inner-product
space. This abbreviation does not include generalized eigenkets from a rigged Hilbert-space
dual. -/
-- Keep ordinary kets definitionally equal to vectors so existing Mathlib operator APIs apply
-- without wrapper coercions or duplicated algebraic instances.
abbrev Ket (V : Type*) := V

/-- `QM-DIRAC-DEF-002`: an ordinary bra is a bounded complex-linear functional on the ket
space. -/
-- A bra is linear in the vector on which it is evaluated. Conjugate-linearity appears in
-- `braOfKet` as a function of the vector used to construct the bra.
abbrev Bra (V : Type*) [NormedAddCommGroup V] [NormedSpace ℂ V] := StrongDual ℂ V

/-- `QM-DIRAC-DEF-003`: the Riesz bra induced by an ordinary ket. As a function of `ψ`, this
construction is conjugate-linear. -/
noncomputable def braOfKet (ψ : Ket V) : Bra V :=
  innerSL ℂ ψ

/-- `QM-DIRAC-DEF-004`: the bracket obtained by evaluating the Riesz bra of `ψ` at `φ`. -/
noncomputable def bracket (ψ φ : Ket V) : ℂ :=
  braOfKet ψ φ

/-- `QM-DIRAC-DEF-005`: the bounded rank-one operator corresponding to an outer product. -/
noncomputable def outerProduct (ψ φ : Ket V) : V →L[ℂ] V :=
  -- Reuse Mathlib's bounded rank-one operator rather than creating a parallel implementation.
  rankOne ℂ ψ φ

/-- `QM-DIRAC-DEF-006`: the rank-one operator associated with a normalized state-vector
representative. -/
noncomputable def pureStateProjector (ψ : NormalizedStateVector V) : V →L[ℂ] V :=
  outerProduct ψ.vector ψ.vector

/-- `QM-DIRAC-LEM-001`: evaluating a Riesz bra is the complex inner product, with Mathlib's
conjugate-linear-first convention. -/
lemma braOfKet_apply (ψ φ : Ket V) :
    braOfKet ψ φ = ⟪ψ, φ⟫_ℂ := by
  rfl

/-- `QM-DIRAC-LEM-002`: the ket-to-bra map conjugates complex scalar multiplication. -/
lemma braOfKet_smul (z : ℂ) (ψ : Ket V) :
    braOfKet (z • ψ) = starRingEnd ℂ z • braOfKet ψ := by
  -- `starRingEnd ℂ` is complex conjugation; writing it explicitly fixes the scalar convention.
  ext φ
  simp [braOfKet]

/-- `QM-DIRAC-LEM-003`: the named bracket agrees with the complex inner product. -/
lemma bracket_eq_inner (ψ φ : Ket V) :
    bracket ψ φ = ⟪ψ, φ⟫_ℂ := by
  rfl

/-- `QM-DIRAC-LEM-004`: an outer product sends `χ` to the bracket coefficient times its
left ket. -/
lemma outerProduct_apply (ψ φ χ : Ket V) :
    outerProduct ψ φ χ = bracket φ χ • ψ := by
  rfl

/-- `QM-DIRAC-LEM-005`: composition of compatible rank-one outer products contracts the
middle bra-ket pair. -/
lemma outerProduct_comp_outerProduct (ψ φ χ ω : Ket V) :
    outerProduct ψ φ ∘L outerProduct χ ω =
      bracket φ χ • outerProduct ψ ω := by
  rw [bracket_eq_inner]
  exact InnerProductSpace.rankOne_comp_rankOne (𝕜 := ℂ) ψ φ χ ω

/-- `QM-DIRAC-LEM-006`: a normalized rank-one projector fixes its defining state vector. -/
lemma pureStateProjector_apply_vector (ψ : NormalizedStateVector V) :
    pureStateProjector ψ ψ.vector = ψ.vector := by
  simp [pureStateProjector, outerProduct, ψ.norm_eq_one]

/-- `QM-DIRAC-THM-001`: a normalized rank-one projector is idempotent. -/
theorem pureStateProjector_idempotent (ψ : NormalizedStateVector V) :
    pureStateProjector ψ ∘L pureStateProjector ψ = pureStateProjector ψ := by
  -- The only substantive hypothesis needed by Mathlib's rank-one result is unit norm.
  simpa [pureStateProjector, outerProduct, IsIdempotentElem, mul_def] using
    (InnerProductSpace.isIdempotentElem_rankOne_self (𝕜 := ℂ) ψ.norm_eq_one)

/-- `QM-DIRAC-THM-002`: on a complete complex inner-product space, a normalized rank-one
projector is self-adjoint. -/
theorem pureStateProjector_selfAdjoint [CompleteSpace V]
    (ψ : NormalizedStateVector V) :
    IsSelfAdjoint (pureStateProjector ψ) := by
  -- Adjoint existence for every bounded operator uses completeness. The second component of
  -- `IsStarProjection` is self-adjointness; idempotence is its first component.
  exact (InnerProductSpace.isStarProjection_rankOne_self (𝕜 := ℂ)
    ψ.norm_eq_one).2

end ProjectKoios.QuantumMechanics

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-10-20
-/
module

public import ProjectKoios.QuantumMechanics.Dirac
public import Mathlib.Topology.Algebra.Module.LocallyConvex

/-!
# Rigged Hilbert-space core

This module defines the topological embedding data needed before generalized eigenkets can be
represented. A `RiggedHilbertSpaceCore Φ H` records a Hausdorff locally convex complex test space
`Φ`, a complete complex Hilbert space `H`, and a continuous injective map `Φ → H` with dense range.
It therefore supports the two convention-sensitive embeddings of Hilbert vectors into continuous
test-space functionals.

This core deliberately does **not** assert nuclearity, identify a concrete Schwartz space, define an
unbounded operator, prove invariance of `Φ` under an operator, or assert a spectral expansion.
Those require additional structures and proofs. In particular, membership in a test-space dual is
not by itself an eigenvalue equation or a physical completeness statement.

Mathlib's inner product is conjugate-linear in its first argument and linear in its second. Hence:

- `hilbertToGeneralizedBra R ψ` is the linear functional `φ ↦ ⟪ψ, R.inclusion φ⟫_ℂ` and depends
  conjugate-linearly on `ψ`;
- `hilbertToGeneralizedKet R ψ` is the conjugate-linear functional
  `φ ↦ ⟪R.inclusion φ, ψ⟫_ℂ` and depends linearly on `ψ`.

## Equations implemented

For `φ : Φ`, `ψ : H`, and `z : ℂ`:

- generalized-bra evaluation: `Bψ(φ) = ⟪ψ, iφ⟫_ℂ`;
- generalized-ket evaluation: `Kψ(φ) = ⟪iφ, ψ⟫_ℂ`;
- conjugate scaling of generalized bras: `B(zψ) = conj(z) • Bψ`;
- linear scaling of generalized kets: `K(zψ) = z • Kψ`;
- conjugate pairing: `Kψ(φ) = conj(Bψ(φ))`;
- both Hilbert-to-dual assignments are injective because the test-space image is dense.

## Source status

These are source-neutral functional-analytic foundations. No claim of textbook fidelity, a
particular physical test space, nuclearity, generalized spectral completeness, or applicability to
a concrete Hamiltonian is made. No local PDF or protected archive expression was used to author
this module.
-/

@[expose] public section

namespace ProjectKoios.QuantumMechanics

open ContinuousLinearMap
open InnerProductSpace

variable {Φ H : Type*}
  -- Mathlib expresses local convexity over an ordered scalar field, so the locally convex
  -- topology is recorded over `ℝ` while `Φ` retains its compatible complex-module structure.
  [TopologicalSpace Φ] [AddCommGroup Φ] [Module ℝ Φ] [Module ℂ Φ]
  [IsScalarTower ℝ ℂ Φ] [IsTopologicalAddGroup Φ] [ContinuousSMul ℂ Φ]
  [LocallyConvexSpace ℝ Φ] [T2Space Φ]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/-- `QM-RIGGED-DEF-001`: the continuous dense test-space embedding underlying a rigged
Hilbert-space construction. Nuclearity and operator-domain data are intentionally not fields of
this core. -/
structure RiggedHilbertSpaceCore (Φ H : Type*)
    [TopologicalSpace Φ] [AddCommGroup Φ] [Module ℝ Φ] [Module ℂ Φ]
    [IsScalarTower ℝ ℂ Φ] [IsTopologicalAddGroup Φ] [ContinuousSMul ℂ Φ]
    [LocallyConvexSpace ℝ Φ] [T2Space Φ]
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H] where
  -- The test-space topology is finer in the only direction needed here: inclusion into the
  -- Hilbert space is continuous. Injectivity and density are recorded separately and explicitly.
  inclusion : Φ →L[ℂ] H
  inclusion_injective : Function.Injective inclusion
  inclusion_denseRange : DenseRange inclusion

/-- `QM-RIGGED-DEF-002`: continuous linear functionals on the test space, used here as
generalized bras under the declared inner-product convention. -/
abbrev GeneralizedBra (Φ : Type*) [TopologicalSpace Φ] [AddCommGroup Φ] [Module ℂ Φ] :=
  StrongDual ℂ Φ

/-- `QM-RIGGED-DEF-003`: continuous conjugate-linear functionals on the test space, used here as
generalized kets under the declared inner-product convention. -/
abbrev GeneralizedKet (Φ : Type*) [TopologicalSpace Φ] [AddCommGroup Φ] [Module ℂ Φ] :=
  Φ →L⋆[ℂ] ℂ

/-- `QM-RIGGED-DEF-004`: the generalized bra induced by a Hilbert-space vector. -/
noncomputable def hilbertToGeneralizedBra
    (R : RiggedHilbertSpaceCore Φ H) (ψ : H) : GeneralizedBra Φ :=
  -- First include the test vector into `H`, then evaluate the ordinary Riesz bra.
  (innerSL ℂ ψ).comp R.inclusion

/-- `QM-RIGGED-DEF-005`: the generalized ket induced by a Hilbert-space vector. -/
noncomputable def hilbertToGeneralizedKet
    (R : RiggedHilbertSpaceCore Φ H) (ψ : H) : GeneralizedKet Φ :=
  -- Flipping the inner product makes the test-vector argument conjugate-linear, matching the
  -- generalized-ket orientation used by the declared convention.
  (innerSLFlip ℂ ψ).comp R.inclusion

/-- `QM-RIGGED-LEM-001`: evaluation of the generalized bra induced by a Hilbert vector. -/
lemma hilbertToGeneralizedBra_apply
    (R : RiggedHilbertSpaceCore Φ H) (ψ : H) (φ : Φ) :
    hilbertToGeneralizedBra R ψ φ = ⟪ψ, R.inclusion φ⟫_ℂ := by
  rfl

/-- `QM-RIGGED-LEM-002`: evaluation of the generalized ket induced by a Hilbert vector. -/
lemma hilbertToGeneralizedKet_apply
    (R : RiggedHilbertSpaceCore Φ H) (ψ : H) (φ : Φ) :
    hilbertToGeneralizedKet R ψ φ = ⟪R.inclusion φ, ψ⟫_ℂ := by
  rfl

/-- `QM-RIGGED-LEM-003`: the Hilbert-to-generalized-bra assignment is conjugate-linear. -/
lemma hilbertToGeneralizedBra_smul
    (R : RiggedHilbertSpaceCore Φ H) (z : ℂ) (ψ : H) :
    hilbertToGeneralizedBra R (z • ψ) =
      starRingEnd ℂ z • hilbertToGeneralizedBra R ψ := by
  ext φ
  simp [hilbertToGeneralizedBra]

/-- `QM-RIGGED-LEM-004`: the Hilbert-to-generalized-ket assignment is complex-linear. -/
lemma hilbertToGeneralizedKet_smul
    (R : RiggedHilbertSpaceCore Φ H) (z : ℂ) (ψ : H) :
    hilbertToGeneralizedKet R (z • ψ) =
      z • hilbertToGeneralizedKet R ψ := by
  ext φ
  simp [hilbertToGeneralizedKet]

/-- `QM-RIGGED-LEM-005`: generalized ket and bra evaluations are complex conjugates. -/
lemma hilbertToGeneralizedKet_eq_star_bra
    (R : RiggedHilbertSpaceCore Φ H) (ψ : H) (φ : Φ) :
    hilbertToGeneralizedKet R ψ φ =
      starRingEnd ℂ (hilbertToGeneralizedBra R ψ φ) := by
  simp [hilbertToGeneralizedBra_apply, hilbertToGeneralizedKet_apply, inner_conj_symm]

/-- `QM-RIGGED-THM-001`: density of the test-space image makes the Hilbert-to-generalized-bra
assignment injective. -/
theorem hilbertToGeneralizedBra_injective
    (R : RiggedHilbertSpaceCore Φ H) :
    Function.Injective (hilbertToGeneralizedBra R) := by
  intro ψ χ h
  -- Equality in the test-space dual first gives equality only on the included dense image.
  have hcomp :
      (⇑(innerSL ℂ ψ)) ∘ ⇑R.inclusion =
        (⇑(innerSL ℂ χ)) ∘ ⇑R.inclusion := by
    funext φ
    exact DFunLike.congr_fun h φ
  -- Continuous scalar-valued maps agreeing on a dense range agree on all of `H`.
  have hall := R.inclusion_denseRange.equalizer
    (innerSL ℂ ψ).continuous (innerSL ℂ χ).continuous hcomp
  -- Nondegeneracy of the inner product then recovers equality of the Hilbert vectors.
  exact ext_inner_right ℂ fun y => congrFun hall y

/-- `QM-RIGGED-THM-002`: density of the test-space image makes the Hilbert-to-generalized-ket
assignment injective. -/
theorem hilbertToGeneralizedKet_injective
    (R : RiggedHilbertSpaceCore Φ H) :
    Function.Injective (hilbertToGeneralizedKet R) := by
  intro ψ χ h
  -- Repeat the density argument with the conjugate-linear test-space functional orientation.
  have hcomp :
      (⇑(innerSLFlip ℂ ψ)) ∘ ⇑R.inclusion =
        (⇑(innerSLFlip ℂ χ)) ∘ ⇑R.inclusion := by
    funext φ
    exact DFunLike.congr_fun h φ
  -- Here the Hilbert vector occupies the second inner-product argument, so use left extensionality.
  have hall := R.inclusion_denseRange.equalizer
    (innerSLFlip ℂ ψ).continuous (innerSLFlip ℂ χ).continuous hcomp
  exact ext_inner_left ℂ fun y => congrFun hall y

end ProjectKoios.QuantumMechanics

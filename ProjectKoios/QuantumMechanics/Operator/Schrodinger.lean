/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import Physlib.QuantumMechanics.SpaceDQuantumSystem

/-!
# Continuum Schrödinger operators on a Schwartz core

This module supplies missing domain and symmetry results for Physlib's single-particle
`SpaceDQuantumSystem`. It introduces no Hamiltonian or Hilbert-space representation of its own.

## i. Overview

The adopted continuum convention is:

- configuration space `Space d` with Lebesgue volume;
- Hilbert space `SpaceDHilbertSpace d`, the complex `L²` space modulo almost-everywhere equality;
- positive mass `Q.m`;
- kinetic operator `(2m)⁻¹ p²`, where each momentum component is `-iℏ ∂ᵢ` on the Schwartz
  submodule;
- maximal multiplication operator for the real potential `Q.potential`; and
- Hamiltonian `Q.kineticOperator + Q.potentialOperator` with intersection domain.

For a potential of temperate growth, the maximal potential domain contains every Schwartz vector.
Consequently the Hamiltonian domain is exactly the Schwartz submodule. The kinetic term, potential
term, and their sum are symmetric there, so the Hamiltonian is densely defined and closable.

Temperate growth requires a smooth potential with polynomially controlled derivatives, so the
exact-Schwartz-domain specialization does not cover singular Coulomb potentials. The separate
`Operator.Hydrogen` bridge instead combines the general measurable-potential symmetry result with
Physlib's singular dense-domain theorem. No self-adjointness, essential self-adjointness, spectral
theorem, eigenstate existence, or physical applicability claim is made here.

## ii. Key results

- `momentumSqOperator_isSymmetric`
- `SpaceDQuantumSystem.kineticOperator_isSymmetric`
- `SpaceDQuantumSystem.hamiltonianOperator_domain_eq_schwartz_of_potential_domain_ge`
- `SpaceDQuantumSystem.hamiltonianOperator_domain_eq_schwartz`
- `SpaceDQuantumSystem.hamiltonianOperator_isSymmetric`
- `SpaceDQuantumSystem.hamiltonianOperator_isUnbounded_of_potential_domain_ge`
- `SpaceDQuantumSystem.hamiltonianOperator_isUnbounded`
- `SpaceDQuantumSystem.hamiltonianOperator_apply_schwartz_ae`

## iii. Table of contents

- A. Proof schematic
- B. Momentum-squared and kinetic symmetry
- C. Hamiltonian domain and symmetry
- D. Action on Schwartz wavefunctions

## iv. References

The carrier, kinetic operator, maximal multiplication potential, and Hamiltonian are reused from
Physlib revision `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`, especially
`Physlib.QuantumMechanics.SpaceDQuantumSystem`,
`Physlib.QuantumMechanics.Operators.Momentum`, and
`Physlib.QuantumMechanics.Operators.Multiplication`.

## A. Proof schematic

```mermaid
flowchart TD
    momentum["Physlib momentum components<br/>symmetric on Schwartz space"]
    invariant["momentum preserves<br/>the Schwartz domain"]
    componentSq["QM-SCHRODINGER-LEM-001<br/>component square symmetric"]
    momentumSq["QM-SCHRODINGER-LEM-002<br/>summed momentum square symmetric"]
    kinetic["QM-SCHRODINGER-LEM-003<br/>kinetic operator symmetric"]
    temperate["temperate real potential"]
    potential["Physlib maximal multiplication operator<br/>self-adjoint; Schwartz included in domain"]
    domain["QM-SCHRODINGER-LEM-004/005<br/>Hamiltonian domain = Schwartz"]
    hsymm["QM-SCHRODINGER-LEM-006<br/>Hamiltonian symmetric"]
    closable["QM-SCHRODINGER-LEM-007/008<br/>Hamiltonian densely defined and closable"]
    coreAction["QM-SCHRODINGER-LEM-009/010/011<br/>kinetic, potential, and Hamiltonian action"]

    momentum --> componentSq
    invariant --> componentSq
    componentSq --> momentumSq
    momentumSq --> kinetic
    temperate --> potential
    kinetic --> hsymm
    potential --> hsymm
    potential --> domain
    domain --> closable
    hsymm --> closable
    kinetic --> coreAction
    potential --> coreAction
```
-/

@[expose] public section

open scoped LinearPMap

namespace ProjectKoios.QuantumMechanics

open InnerProductSpace MeasureTheory
open _root_.QuantumMechanics
open _root_.QuantumMechanics.SpaceDHilbertSpace
open SchwartzMap SchwartzSubmodule

variable {d : ℕ}

/-! ## B. Momentum-squared and kinetic symmetry -/

/-- The restricted square of one Physlib momentum component is symmetric on the invariant Schwartz
domain.

Project Koios ID: `QM-SCHRODINGER-LEM-001`. -/
lemma momentumComponentSq_isSymmetric (i : Fin d) :
    ((𝓟 i).comp (𝓟 i) (momentumOperator_range i)).IsSymmetric := by
  intro x y
  let px : (𝓟 i).domain :=
    ⟨𝓟 i ⟨x, x.2⟩, momentumOperator_range i ⟨x, x.2⟩⟩
  let py : (𝓟 i).domain :=
    ⟨𝓟 i ⟨y, y.2⟩, momentumOperator_range i ⟨y, y.2⟩⟩
  change ⟪𝓟 i px, (y : SpaceDHilbertSpace d)⟫_ℂ =
    ⟪(x : SpaceDHilbertSpace d), 𝓟 i py⟫_ℂ
  calc
    _ = ⟪(px : SpaceDHilbertSpace d), 𝓟 i ⟨y, y.2⟩⟫_ℂ :=
      momentumOperator_isSymmetric i px ⟨y, y.2⟩
    _ = _ := momentumOperator_isSymmetric i ⟨x, x.2⟩ py

/-- The Physlib momentum-squared operator, the finite sum of restricted component squares, is
symmetric on the Schwartz submodule.

Project Koios ID: `QM-SCHRODINGER-LEM-002`. -/
lemma momentumSqOperator_isSymmetric :
    (momentumSqOperator (d := d)).IsSymmetric := by
  rw [momentumSqOperator_eq]
  exact LinearPMap.IsSymmetric.sum momentumComponentSq_isSymmetric

namespace SpaceDQuantumSystem

/-- The Physlib kinetic operator `(2m)⁻¹p²` is symmetric on its Schwartz domain.

Project Koios ID: `QM-SCHRODINGER-LEM-003`. -/
lemma kineticOperator_isSymmetric
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d} :
    Q.kineticOperator.IsSymmetric := by
  rw [_root_.QuantumMechanics.SpaceDQuantumSystem.kineticOperator_eq]
  exact momentumSqOperator_isSymmetric.real_smul ((2 * Q.m)⁻¹)

/-! ## C. Hamiltonian domain and symmetry -/

/-- If the maximal potential domain contains the Schwartz submodule, then the domain of Physlib's
kinetic-plus-potential Hamiltonian is exactly the Schwartz submodule.

Project Koios ID: `QM-SCHRODINGER-LEM-004`. -/
lemma hamiltonianOperator_domain_eq_schwartz_of_potential_domain_ge
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (hdom : SchwartzSubmodule d ≤ Q.potentialOperator.domain) :
    Q.hamiltonianOperator.domain = SchwartzSubmodule d := by
  rw [_root_.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_eq,
    LinearPMap.add_domain,
    _root_.QuantumMechanics.SpaceDQuantumSystem.kineticOperator_eq,
    LinearPMap.smul_domain, momentumSqOperator_domain_eq]
  exact inf_eq_left.mpr hdom

/-- A temperate potential makes the domain of Physlib's kinetic-plus-potential Hamiltonian exactly
the Schwartz submodule.

Project Koios ID: `QM-SCHRODINGER-LEM-005`. -/
lemma hamiltonianOperator_domain_eq_schwartz
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (hV : Q.potential.HasTemperateGrowth) :
    Q.hamiltonianOperator.domain = SchwartzSubmodule d :=
  hamiltonianOperator_domain_eq_schwartz_of_potential_domain_ge
    (_root_.QuantumMechanics.SpaceDQuantumSystem.potentialOperator_domain_ge hV)

private lemma temperatePotential_aestronglyMeasurable
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (hV : Q.potential.HasTemperateGrowth) :
    AEStronglyMeasurable Q.potential volume :=
  hV.1.continuous.aestronglyMeasurable

private lemma potentialOperator_isSymmetric
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (hmeas : AEStronglyMeasurable Q.potential volume) :
    Q.potentialOperator.IsSymmetric := by
  have hsa : IsSelfAdjoint Q.potentialOperator :=
    @_root_.QuantumMechanics.SpaceDQuantumSystem.potentialOperator_isSelfAdjoint d Q hmeas
  exact LinearPMap.IsSelfAdjoint.isSymmetric hsa

/-- For an almost-everywhere strongly measurable real potential, Physlib's
kinetic-plus-potential Hamiltonian is symmetric on its intersection domain.

Project Koios ID: `QM-SCHRODINGER-LEM-006`. -/
lemma hamiltonianOperator_isSymmetric
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (hmeas : AEStronglyMeasurable Q.potential volume) :
    Q.hamiltonianOperator.IsSymmetric := by
  rw [_root_.QuantumMechanics.SpaceDQuantumSystem.hamiltonianOperator_eq]
  exact kineticOperator_isSymmetric.add (potentialOperator_isSymmetric hmeas)

/-- A measurable real potential whose maximal multiplication domain contains the Schwartz
submodule gives a densely defined closable Hamiltonian. Physlib calls this conjunction
`IsUnbounded`; it does not assert failure of boundedness.

Project Koios ID: `QM-SCHRODINGER-LEM-007`. -/
lemma hamiltonianOperator_isUnbounded_of_potential_domain_ge
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (hmeas : AEStronglyMeasurable Q.potential volume)
    (hdom : SchwartzSubmodule d ≤ Q.potentialOperator.domain) :
    Q.hamiltonianOperator.IsUnbounded := by
  apply (hamiltonianOperator_isSymmetric hmeas).isUnbounded_iff_hasDenseDomain.mpr
  rw [LinearPMap.hasDenseDomain_def,
    hamiltonianOperator_domain_eq_schwartz_of_potential_domain_ge hdom]
  exact SchwartzSubmodule.dense d volume

/-- For a real potential of temperate growth, Physlib's Hamiltonian is densely defined and
closable on the exact Schwartz domain.

Project Koios ID: `QM-SCHRODINGER-LEM-008`. -/
lemma hamiltonianOperator_isUnbounded
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (hV : Q.potential.HasTemperateGrowth) :
    Q.hamiltonianOperator.IsUnbounded :=
  hamiltonianOperator_isUnbounded_of_potential_domain_ge
    (temperatePotential_aestronglyMeasurable hV)
    (_root_.QuantumMechanics.SpaceDQuantumSystem.potentialOperator_domain_ge hV)

/-! ## D. Action on Schwartz wavefunctions -/

/-- On a Schwartz wavefunction in its domain, the Physlib kinetic operator acts as the finite sum
of twice-applied momentum components with coefficient `(2m)⁻¹`.

Project Koios ID: `QM-SCHRODINGER-LEM-009`. -/
lemma kineticOperator_apply_schwartz
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (f : 𝓢(Space d, ℂ))
    (h : (schwartzEquiv volume f : Q.HS) ∈ Q.kineticOperator.domain) :
    Q.kineticOperator ⟨schwartzEquiv volume f, h⟩ =
      schwartzEquiv volume (((2 * Q.m)⁻¹ : ℝ) • ∑ i, 𝐩 i (𝐩 i f)) := by
  have h1 : Q.kineticOperator ⟨schwartzEquiv volume f, h⟩ =
      (2 * Q.m)⁻¹ • momentumSqOperator ⟨schwartzEquiv volume f, h⟩ :=
    LinearPMap.smul_apply _ _ _
  rw [h1]
  erw [LinearPMap.sum_apply]
  rw [RCLike.real_smul_eq_coe_smul (K := ℂ), RCLike.real_smul_eq_coe_smul (K := ℂ), map_smul,
    map_sum, Submodule.coe_smul, Submodule.coe_sum]
  congr 1
  refine Finset.sum_congr rfl fun i _ => ?_
  have hr : ∀ x : (𝓟 i).domain, 𝓟 i x ∈ (𝓟 i).domain := momentumOperator_range i
  have key : ∀ hi, ((𝓟 i).comp (𝓟 i) hr) ⟨(schwartzEquiv volume f : Q.HS), hi⟩ =
      schwartzEquiv volume (𝐩 i (𝐩 i f)) := fun hi => by
    have hi' : (schwartzEquiv volume f : Q.HS) ∈ (𝓟 i).domain := hi
    have hpi : (⟨𝓟 i ⟨(schwartzEquiv volume f : Q.HS), hi'⟩, hr _⟩ : (𝓟 i).domain) =
        ⟨(schwartzEquiv volume (𝐩 i f) : Q.HS), (schwartzEquiv volume (𝐩 i f)).2⟩ := by
      apply Subtype.ext
      show 𝓟 i (schwartzEquiv volume f) = (schwartzEquiv volume (𝐩 i f) : Q.HS)
      rw [momentumOperator_apply, LinearEquiv.symm_apply_apply]
    show 𝓟 i ⟨𝓟 i ⟨(schwartzEquiv volume f : Q.HS), hi'⟩, hr _⟩ = _
    rw [hpi]
    show 𝓟 i (schwartzEquiv volume (𝐩 i f)) = _
    rw [momentumOperator_apply, LinearEquiv.symm_apply_apply]
  exact key _

/-- On a Schwartz wavefunction in the maximal potential domain, the Physlib potential operator acts
almost everywhere by pointwise multiplication by the real scalar potential.

Project Koios ID: `QM-SCHRODINGER-LEM-010`. -/
lemma potentialOperator_apply_schwartz_ae
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (f : 𝓢(Space d, ℂ))
    (h : (schwartzEquiv volume f : Q.HS) ∈ Q.potentialOperator.domain) :
    ⇑(Q.potentialOperator ⟨schwartzEquiv volume f, h⟩) =ᵐ[volume]
      fun x => (Q.potential x : ℂ) * f x := by
  have h1 : ⇑(Q.potentialOperator ⟨schwartzEquiv volume f, h⟩) =ᵐ[volume]
      (Complex.ofReal ∘ Q.potential) • ⇑(schwartzEquiv volume f : Q.HS) :=
    mulOperator_apply_ae _
  filter_upwards [h1, schwartzEquiv_coe_ae (μ := volume) f] with x hx1 hx2
  rw [hx1]
  simp [hx2]

/-- On a Schwartz wavefunction in its intersection domain, the Physlib Hamiltonian acts almost
everywhere as `(2m)⁻¹ ∑ᵢ pᵢ² + V` with the upstream momentum convention.

Project Koios ID: `QM-SCHRODINGER-LEM-011`. -/
lemma hamiltonianOperator_apply_schwartz_ae
    {Q : _root_.QuantumMechanics.SpaceDQuantumSystem d}
    (f : 𝓢(Space d, ℂ))
    (h : (schwartzEquiv volume f : Q.HS) ∈ Q.hamiltonianOperator.domain) :
    ⇑(Q.hamiltonianOperator ⟨schwartzEquiv volume f, h⟩) =ᵐ[volume]
      fun x => (((2 * Q.m)⁻¹ : ℝ) : ℂ) * (∑ i, 𝐩 i (𝐩 i f) x) +
        (Q.potential x : ℂ) * f x := by
  have hk := (h : (schwartzEquiv volume f : Q.HS) ∈
    Q.kineticOperator.domain ⊓ Q.potentialOperator.domain).1
  have hp := (h : (schwartzEquiv volume f : Q.HS) ∈
    Q.kineticOperator.domain ⊓ Q.potentialOperator.domain).2
  have hadd : Q.hamiltonianOperator ⟨schwartzEquiv volume f, h⟩ =
      Q.kineticOperator ⟨schwartzEquiv volume f, hk⟩ +
        Q.potentialOperator ⟨schwartzEquiv volume f, hp⟩ :=
    LinearPMap.add_apply _ _ _
  rw [hadd, kineticOperator_apply_schwartz]
  have hkin := schwartzEquiv_coe_ae (μ := volume)
    (((2 * Q.m)⁻¹ : ℝ) • ∑ i, 𝐩 i (𝐩 i f))
  have haddCoe := MeasureTheory.Lp.coeFn_add
    (schwartzEquiv volume (((2 * Q.m)⁻¹ : ℝ) • ∑ i, 𝐩 i (𝐩 i f)) : Q.HS)
    (Q.potentialOperator ⟨schwartzEquiv volume f, hp⟩)
  filter_upwards [hkin, haddCoe, potentialOperator_apply_schwartz_ae f hp]
    with x hxkin hxadd hxpot
  rw [hxadd, Pi.add_apply, hxkin, hxpot]
  simp only [smul_apply, Complex.real_smul, FunLike.coe_sum, Finset.sum_apply]

end SpaceDQuantumSystem
end ProjectKoios.QuantumMechanics

/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.KohnSham.FunctionalDecomposition
public import Mathlib.Basic.Complex.Basic
public import Mathlib.Algebra.Order.BigOperators.Group.Finset

/-!
# Finite occupied-orbital density reconstruction

This module defines pointwise real densities from finite families of complex scalar orbitals.  The
unit-occupation density is the finite-index adaptation of [Kohn1965], Section II.A, equation (2.9),
`n(r) = ∑ᵢ |ψᵢ(r)|²`.  A separate weighted definition accepts explicit real occupation weights and
proves nonnegativity only under an explicit nonnegativity hypothesis.

The coordinate type and finite orbital index are arbitrary.  No measure, spatial dimension,
normalization integral, orthogonality, particle-number sum, occupation upper bound, kinetic
operator, eigenvalue equation, spin multiplicity, noninteracting representability, or
self-consistency claim is encoded here.  In particular, these auxiliary orbitals are not identified
with interacting natural orbitals.

## Conventions and dependency role

* Orbitals are complex scalar amplitudes `Orbital → Position → ℂ`.  `Position` is only a pointwise
  evaluation carrier; it is not assumed to be Euclidean space or a measure space.
* `Complex.normSq` fixes the density convention as the exact real quantity
  `re(ψ)² + im(ψ)²`.  No square root or floating norm enters the definitions.
* `occupiedDensity` sums every member of the explicit finite index exactly once.  This is how the
  source's occupied-index range is represented; no additional spin factor is inserted.
* `occupationWeightedDensity` is deliberately more permissive than a physical occupation model.
  Its weights are arbitrary reals, and nonnegativity is obtained only when a separate hypothesis
  states that every supplied weight is nonnegative.
* Orthonormality and normalization are absent because they require an inner product or measure not
  owned by this pointwise module.  A later finite-basis or continuum realization must add those
  structures explicitly.

The pointwise density API is downstream of the functional decomposition but upstream of any
kinetic-energy, eigenproblem, or PAW representation.

## Reference

* [Kohn1965] W. Kohn and L. J. Sham, “Self-Consistent Equations Including Exchange and
  Correlation Effects,” *Physical Review* 140, A1133--A1138 (1965), DOI:
  `10.1103/PhysRev.140.A1133`; cited statement location: Section II.A, equation (2.9), with the
  paper's spin convention replaced here by an explicit arbitrary finite occupied-orbital index.
-/

open scoped BigOperators

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.KohnSham

/--
`DFT-KS-ORBITAL-DEF-001`: a finite indexed family of complex scalar orbital amplitudes.

Finiteness is supplied at uses of density reconstruction rather than stored in the structure.
-/
structure FiniteOrbitalFamily (Orbital Position : Type*) where
  /-- Complex scalar amplitude of one orbital at one position. -/
  amplitude : Orbital → Position → ℂ

variable {Orbital Position : Type*}

/-- `DFT-KS-ORBITAL-DEF-002`: pointwise density contribution `|ψᵢ(r)|²` of one orbital. -/
def FiniteOrbitalFamily.orbitalDensity
    (family : FiniteOrbitalFamily Orbital Position) (orbital : Orbital)
    (position : Position) : ℝ :=
  Complex.normSq (family.amplitude orbital position)

/--
`DFT-KS-ORBITAL-DEF-003`: pointwise density reconstructed with supplied real occupation weights.

The definition imposes no occupation bounds or particle-number sum; later consumers must state
those conditions explicitly.
-/
def FiniteOrbitalFamily.occupationWeightedDensity [Fintype Orbital]
    (family : FiniteOrbitalFamily Orbital Position) (occupation : Orbital → ℝ)
    (position : Position) : ℝ :=
  ∑ orbital, occupation orbital * family.orbitalDensity orbital position

/--
`DFT-KS-ORBITAL-DEF-004`: unit-occupation density `∑ᵢ |ψᵢ(r)|²`.

This is the finite-index scalar-orbital adaptation of [Kohn1965], Section II.A, equation (2.9).
The source's spin convention is not inferred; the supplied finite index is exactly the set summed.
-/
def FiniteOrbitalFamily.occupiedDensity [Fintype Orbital]
    (family : FiniteOrbitalFamily Orbital Position) (position : Position) : ℝ :=
  ∑ orbital, family.orbitalDensity orbital position

/-- `DFT-KS-ORBITAL-LEM-001`: every single-orbital pointwise density is nonnegative. -/
lemma FiniteOrbitalFamily.orbitalDensity_nonneg
    (family : FiniteOrbitalFamily Orbital Position) (orbital : Orbital)
    (position : Position) :
    0 ≤ family.orbitalDensity orbital position :=
  Complex.normSq_nonneg _

/--
`DFT-KS-ORBITAL-LEM-002`: nonnegative occupation weights give a nonnegative pointwise density.
-/
lemma FiniteOrbitalFamily.occupationWeightedDensity_nonneg [Fintype Orbital]
    (family : FiniteOrbitalFamily Orbital Position) (occupation : Orbital → ℝ)
    (hoccupation : ∀ orbital, 0 ≤ occupation orbital) (position : Position) :
    0 ≤ family.occupationWeightedDensity occupation position := by
  -- Expand the density into its finite summands.  Each summand is a product of an explicitly
  -- nonnegative occupation and the squared modulus of one orbital amplitude.
  rw [FiniteOrbitalFamily.occupationWeightedDensity]
  exact Finset.sum_nonneg fun orbital _ =>
    mul_nonneg (hoccupation orbital) (family.orbitalDensity_nonneg orbital position)

/-- `DFT-KS-ORBITAL-LEM-003`: the unit-occupation density is pointwise nonnegative. -/
lemma FiniteOrbitalFamily.occupiedDensity_nonneg [Fintype Orbital]
    (family : FiniteOrbitalFamily Orbital Position) (position : Position) :
    0 ≤ family.occupiedDensity position := by
  -- The unit-occupation density is a finite sum of squared complex moduli.
  rw [FiniteOrbitalFamily.occupiedDensity]
  exact Finset.sum_nonneg fun orbital _ => family.orbitalDensity_nonneg orbital position

/-- `DFT-KS-ORBITAL-LEM-004`: unit weights recover the occupied-orbital density. -/
lemma FiniteOrbitalFamily.occupationWeightedDensity_one [Fintype Orbital]
    (family : FiniteOrbitalFamily Orbital Position) (position : Position) :
    family.occupationWeightedDensity (fun _ => 1) position =
      family.occupiedDensity position := by
  -- Pointwise multiplication by the constant occupation one disappears in every summand.
  simp [FiniteOrbitalFamily.occupationWeightedDensity, FiniteOrbitalFamily.occupiedDensity]

/-- `DFT-KS-ORBITAL-LEM-005`: zero weights give zero pointwise density. -/
lemma FiniteOrbitalFamily.occupationWeightedDensity_zero [Fintype Orbital]
    (family : FiniteOrbitalFamily Orbital Position) (position : Position) :
    family.occupationWeightedDensity (fun _ => 0) position = 0 := by
  -- Every weighted summand vanishes before the finite sum is taken.
  simp [FiniteOrbitalFamily.occupationWeightedDensity]

/-- `DFT-KS-ORBITAL-LEM-006`: weighted density is additive in the occupation weights. -/
lemma FiniteOrbitalFamily.occupationWeightedDensity_add [Fintype Orbital]
    (family : FiniteOrbitalFamily Orbital Position) (occupation₁ occupation₂ : Orbital → ℝ)
    (position : Position) :
    family.occupationWeightedDensity (occupation₁ + occupation₂) position =
      family.occupationWeightedDensity occupation₁ position +
        family.occupationWeightedDensity occupation₂ position := by
  -- Distribute the pointwise sum of weights through multiplication and then split the finite sum.
  simp only [FiniteOrbitalFamily.occupationWeightedDensity, Pi.add_apply, add_mul,
    Finset.sum_add_distrib]

end ProjectKoios.DensityFunctionalTheory.KohnSham

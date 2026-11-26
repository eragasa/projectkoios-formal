/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-26
-/
module

public import ProjectKoios.DensityFunctionalTheory.KohnSham.OccupiedOrbitals
public import ProjectKoios.QuantumMechanics.FiniteDimensional.OrbitalExpansion

/-!
# Finite-basis binding for scalar Kohn--Sham orbital density

This module is the thin semantic bridge between two previously separate APIs:

* `QuantumMechanics.FiniteDimensional.FiniteBasisOrbitalExpansion` reconstructs complex scalar
  amplitudes from finite basis functions and coefficients without DFT meaning;
* `KohnSham.FiniteOrbitalFamily` turns supplied scalar amplitudes into unit-occupation or
  occupation-weighted pointwise densities.

For basis labels `μ`, orbital labels `i`, and positions `r`, the combined convention is

`ψᵢ(r) = ∑ μ, C μ i * χ μ r`,

`ρ(r) = ∑ i, ‖ψᵢ(r)‖²`.

The main theorem exposes the fully expanded finite formula. Its proof is definitional: it verifies
that the source-neutral amplitude reconstruction is connected to the established Kohn--Sham density
convention without changing conjugation, coefficient order, orbital indexing, or occupation
semantics.

## Source and adaptation boundary

Kohn and Sham, “Self-Consistent Equations Including Exchange and Correlation Effects,”
Physical Review 140 (1965), DOI `10.1103/PhysRev.140.A1133`, Section II.A, equation (2.9), gives the
occupied-orbital density as a sum of orbital modulus squares. The present theorem cites that equation
only for the second line above. The finite basis expansion in the first line is source-neutral
representation algebra and is not attributed to Kohn and Sham.

The inspected scan was checked against the rendered page image; OCR was used only for discovery.
Proposed citekey: `Kohn1965`. The References-owned canonical identity remains unresolved.

## Explicit limitations

This module assumes finite basis and orbital index types supplied by `Fintype`. It does not infer:

* basis completeness, linear independence, normalization, or spatial integration;
* orbital normalization, mutual orthogonality, occupation bounds, or a particle-number sum;
* noninteracting representability or existence of Kohn--Sham orbitals;
* a Hamiltonian, overlap matrix, eigenvalue equation, functional derivative, or self-consistency;
* a finite-basis discretization error bound, numerical implementation, or PAW transformation.

Consequently, the result is an exact bridge between supplied finite data, not a theorem that a
continuum Kohn--Sham solution admits this representation.
-/

open scoped BigOperators

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.KohnSham

open ProjectKoios.QuantumMechanics.FiniteDimensional

variable {Basis Orbital Position : Type*} [Fintype Basis] [Fintype Orbital]

/--
`DFT-KS-BASIS-DEF-001`: view a finite-basis expansion as the scalar orbital family used by the
Kohn--Sham density API.

This construction copies only the reconstructed amplitude function. It adds no normalization,
orthogonality, occupancy, or representability evidence.
-/
def finiteBasisOrbitalFamily
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position) :
    FiniteOrbitalFamily Orbital Position where
  amplitude := expansion.orbitalAmplitude

/--
`DFT-KS-BASIS-DEF-002`: occupation-weighted density of reconstructed finite-basis orbitals.

The real occupation function is supplied explicitly and remains unconstrained, exactly as in
`FiniteOrbitalFamily.occupationWeightedDensity`.
-/
def finiteBasisOccupationWeightedDensity
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (occupation : Orbital → ℝ) (position : Position) : ℝ :=
  (finiteBasisOrbitalFamily expansion).occupationWeightedDensity occupation position

/--
`DFT-KS-BASIS-DEF-003`: unit-occupation density of reconstructed finite-basis orbitals.

Each index in the finite orbital carrier contributes once. Any physical spin or occupation
multiplicity must therefore already be encoded in the chosen index set or replaced by the weighted
definition above.
-/
def finiteBasisOccupiedDensity
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (position : Position) : ℝ :=
  (finiteBasisOrbitalFamily expansion).occupiedDensity position

/--
`DFT-KS-BASIS-LEM-001`: expand the occupation-weighted density into the supplied coefficients and
basis-function values.

This is the weighted finite analogue of the source-facing unit-occupation theorem below.
-/
lemma finiteBasisOccupationWeightedDensity_eq_sum_normSq
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (occupation : Orbital → ℝ) (position : Position) :
    finiteBasisOccupationWeightedDensity expansion occupation position =
      ∑ orbital, occupation orbital * Complex.normSq
        (∑ basis, expansion.coefficient basis orbital * expansion.basisFunction basis position) := by
  rfl

/--
`DFT-KS-BASIS-THM-001`: exact finite-basis expansion of the unit-occupation scalar orbital density.

Source locator: Kohn and Sham (1965), DOI `10.1103/PhysRev.140.A1133`, Section II.A, equation (2.9),
for `ρ(r) = ∑ᵢ |ψᵢ(r)|²`. Lean substitutes the separately defined source-neutral finite expansion
`ψᵢ(r) = ∑μ C μ i * χ μ r` and represents `|z|²` by `Complex.normSq z`.

The equality is exact for the supplied finite data. It does not assert that the basis or orbitals
exist for a continuum Kohn--Sham problem, nor that they are normalized, orthogonal, occupied
according to a physical filling rule, or self-consistent.
-/
theorem finiteBasisOccupiedDensity_eq_sum_normSq
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (position : Position) :
    finiteBasisOccupiedDensity expansion position =
      ∑ orbital, Complex.normSq
        (∑ basis, expansion.coefficient basis orbital * expansion.basisFunction basis position) := by
  -- Both sides unfold to the same finite sum. Keeping this theorem named makes the representation
  -- boundary and source crosswalk auditable even though no additional mathematical hypothesis is
  -- needed for the definitional composition.
  rfl

/--
`DFT-KS-BASIS-LEM-002`: nonnegative occupations give a nonnegative reconstructed finite-basis
density at every supplied position.
-/
lemma finiteBasisOccupationWeightedDensity_nonneg
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (occupation : Orbital → ℝ) (hoccupation : ∀ orbital, 0 ≤ occupation orbital)
    (position : Position) :
    0 ≤ finiteBasisOccupationWeightedDensity expansion occupation position := by
  exact FiniteOrbitalFamily.occupationWeightedDensity_nonneg
    (finiteBasisOrbitalFamily expansion) occupation hoccupation position

/--
`DFT-KS-BASIS-LEM-003`: the reconstructed unit-occupation finite-basis density is pointwise
nonnegative.
-/
lemma finiteBasisOccupiedDensity_nonneg
    (expansion : FiniteBasisOrbitalExpansion Basis Orbital Position)
    (position : Position) :
    0 ≤ finiteBasisOccupiedDensity expansion position := by
  exact FiniteOrbitalFamily.occupiedDensity_nonneg (finiteBasisOrbitalFamily expansion) position

end ProjectKoios.DensityFunctionalTheory.KohnSham

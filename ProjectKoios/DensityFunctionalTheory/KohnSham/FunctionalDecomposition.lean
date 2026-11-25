/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.Foundations.ConstrainedSearch
import Mathlib.Tactic.Ring

/-!
# Abstract scalar Kohn--Sham functional decomposition

This module introduces supplied scalar density functionals for the interacting universal internal
energy, noninteracting kinetic energy, and Hartree energy.  The exchange--correlation term is defined
as the exact remainder, and the reconstructed internal and total energies are proved equal to their
supplied universal forms.

The decomposition combines [Kohn1965], Section II.A, equations (2.1)--(2.2): equation (2.1)
separates the external and classical electrostatic contributions, while equation (2.2) writes the
remaining universal term as a noninteracting kinetic functional plus exchange--correlation energy.
This abstract module records the modern combined identity
`F = Tₛ + E_H + E_xc`.  It does not formalize the local approximation in equation (2.3).  The
paper's “Note added in proof” motivates a later exact functional-derivative layer, but no derivative
or self-consistent one-particle equation is imported here.

Because `exchangeCorrelationEnergy` is a remainder definition, the reconstruction theorem is exact
algebra.  It does not prove noninteracting representability, existence of orbitals, differentiability,
a functional derivative, an effective potential, or a self-consistent solution.

## Conventions and dependency role

* Every functional in this file is real-valued and is evaluated on the same explicit density
  carrier.  No domain coercion or equality between interacting- and noninteracting-representable
  density sets is inferred.
* `universalInternalEnergy` excludes the external-potential term.  `universalTotalEnergy` and
  `reconstructedTotalEnergy` add one supplied external-density contribution only after the internal
  decomposition has been fixed.
* The Hartree functional is supplied rather than constructed.  Consequently, this module neither
  chooses a Coulomb normalization nor proves Hartree positivity or finiteness.
* `kohnShamFunctionalDataOfVariationalModel` is the narrow bridge from the preceding Levy--Lieb
  layer: only its universal term is fixed to the constrained-search infimum.  The two auxiliary
  Kohn--Sham functionals remain independent inputs and therefore carry no hidden existence claim.

This module is intended to precede orbital realization, finite-basis matrices, and PAW.  Those
layers should import these declarations rather than redefine the functional bookkeeping.

## Reference

* [Kohn1965] W. Kohn and L. J. Sham, “Self-Consistent Equations Including Exchange and
  Correlation Effects,” *Physical Review* 140, A1133--A1138 (1965), DOI:
  `10.1103/PhysRev.140.A1133`; cited statement locations: Section II.A, equations (2.1)--(2.3),
  with equation (2.3) retained only as an excluded approximation boundary, and the “Note added in
  proof” on page A1138 retained only as future exact functional-derivative context.
-/

@[expose] public section

namespace ProjectKoios.DensityFunctionalTheory.KohnSham

/--
`DFT-KS-FUNCTIONAL-DEF-001`: supplied scalar density functionals entering an exact Kohn--Sham
remainder decomposition.

No field asserts that the noninteracting kinetic or Hartree functional is representable by a
continuum operator or orbital family.
-/
structure ScalarKohnShamFunctionalData (Density : Type*) where
  /-- Interacting universal internal-energy functional. -/
  universalInternalEnergy : Density → ℝ
  /-- Supplied noninteracting kinetic-energy functional. -/
  noninteractingKineticEnergy : Density → ℝ
  /-- Supplied classical Hartree-energy functional. -/
  hartreeEnergy : Density → ℝ

variable {Density : Type*}

/--
`DFT-KS-FUNCTIONAL-DEF-002`: exchange--correlation energy as the exact remainder after subtracting
noninteracting kinetic and Hartree terms.

This adapts the exact decomposition in [Kohn1965], Section II.A, equations (2.1)--(2.2).  It is not
the local approximation of equation (2.3).
-/
def ScalarKohnShamFunctionalData.exchangeCorrelationEnergy
    (data : ScalarKohnShamFunctionalData Density) (density : Density) : ℝ :=
  data.universalInternalEnergy density - data.noninteractingKineticEnergy density -
    data.hartreeEnergy density

/--
`DFT-KS-FUNCTIONAL-DEF-003`: internal energy reconstructed from the three Kohn--Sham terms.

The summation order is fixed as `Tₛ + E_H + E_xc`.  Over `ℝ` the later reconstruction proof is
independent of association, but writing the order explicitly keeps the source crosswalk readable.
-/
def ScalarKohnShamFunctionalData.reconstructedInternalEnergy
    (data : ScalarKohnShamFunctionalData Density) (density : Density) : ℝ :=
  data.noninteractingKineticEnergy density + data.hartreeEnergy density +
    data.exchangeCorrelationEnergy density

/--
`DFT-KS-FUNCTIONAL-DEF-004`: universal internal plus supplied external-density energy.

`externalEnergy` is a functional of the already selected density.  This definition does not infer
that it arises from a spatial integral or from any particular scalar-potential carrier.
-/
def ScalarKohnShamFunctionalData.universalTotalEnergy
    (data : ScalarKohnShamFunctionalData Density) (externalEnergy : Density → ℝ)
    (density : Density) : ℝ :=
  data.universalInternalEnergy density + externalEnergy density

/--
`DFT-KS-FUNCTIONAL-DEF-005`: reconstructed Kohn--Sham internal plus external-density energy.

Using the same external term as `universalTotalEnergy` isolates the internal functional
bookkeeping; the equality lemma below introduces no separate external-potential assumption.
-/
def ScalarKohnShamFunctionalData.reconstructedTotalEnergy
    (data : ScalarKohnShamFunctionalData Density) (externalEnergy : Density → ℝ)
    (density : Density) : ℝ :=
  data.reconstructedInternalEnergy density + externalEnergy density

/--
`DFT-KS-FUNCTIONAL-THM-001`: the exact remainder reconstructs the supplied interacting universal
internal energy.

This is the abstract algebraic form of the exact decomposition obtained by combining
[Kohn1965], Section II.A, equations (2.1)--(2.2).  The theorem follows from the remainder definition;
it makes no existence, differentiability, orbital, or approximation claim.
-/
theorem ScalarKohnShamFunctionalData.reconstructedInternalEnergy_eq_universalInternalEnergy
    (data : ScalarKohnShamFunctionalData Density) (density : Density) :
    data.reconstructedInternalEnergy density = data.universalInternalEnergy density := by
  -- First expose the exact remainder.  The goal then contains only addition and subtraction in ℝ;
  -- no variational, analytic, or orbital fact participates in this reconstruction.
  simp only [ScalarKohnShamFunctionalData.reconstructedInternalEnergy,
    ScalarKohnShamFunctionalData.exchangeCorrelationEnergy]
  -- Cancel the supplied `Tₛ` and `E_H` terms by exact ring normalization.
  ring

/--
`DFT-KS-FUNCTIONAL-LEM-001`: exact internal reconstruction persists after adding an external term.

This is a supporting congruence result, not an Euler--Lagrange or energy-minimization theorem.
-/
lemma ScalarKohnShamFunctionalData.reconstructedTotalEnergy_eq_universalTotalEnergy
    (data : ScalarKohnShamFunctionalData Density) (externalEnergy : Density → ℝ)
    (density : Density) :
    data.reconstructedTotalEnergy externalEnergy density =
      data.universalTotalEnergy externalEnergy density := by
  -- Both total-energy expressions use the same external term, so the internal reconstruction
  -- theorem is the only substantive rewrite required.
  rw [ScalarKohnShamFunctionalData.reconstructedTotalEnergy,
    ScalarKohnShamFunctionalData.universalTotalEnergy,
    data.reconstructedInternalEnergy_eq_universalInternalEnergy]

/--
`DFT-KS-FUNCTIONAL-DEF-006`: instantiate the universal term with the constrained-search energy of
an abstract variational density model.

The noninteracting kinetic and Hartree functionals remain explicit supplied inputs.
-/
noncomputable def kohnShamFunctionalDataOfVariationalModel
    {State Potential : Type*}
    (model : Foundations.VariationalDensityModel State Density Potential)
    (noninteractingKineticEnergy hartreeEnergy : model.RepresentableDensity → ℝ) :
    ScalarKohnShamFunctionalData model.RepresentableDensity where
  universalInternalEnergy := model.constrainedSearchEnergy
  noninteractingKineticEnergy := noninteractingKineticEnergy
  hartreeEnergy := hartreeEnergy

/--
`DFT-KS-FUNCTIONAL-LEM-002`: the constrained-search specialization reconstructs the supplied
constrained-search energy exactly.
-/
lemma kohnShamFunctionalDataOfVariationalModel_reconstructedInternalEnergy
    {State Potential : Type*}
    (model : Foundations.VariationalDensityModel State Density Potential)
    (noninteractingKineticEnergy hartreeEnergy : model.RepresentableDensity → ℝ)
    (density : model.RepresentableDensity) :
    ScalarKohnShamFunctionalData.reconstructedInternalEnergy
        (kohnShamFunctionalDataOfVariationalModel model
          noninteractingKineticEnergy hartreeEnergy) density =
      model.constrainedSearchEnergy density := by
  -- Specialization changes only the name of the universal term.  The generic exact-remainder
  -- theorem supplies the result without adding a noninteracting-representability assumption.
  exact ScalarKohnShamFunctionalData.reconstructedInternalEnergy_eq_universalInternalEnergy
    (kohnShamFunctionalDataOfVariationalModel model
      noninteractingKineticEnergy hartreeEnergy) density

end ProjectKoios.DensityFunctionalTheory.KohnSham

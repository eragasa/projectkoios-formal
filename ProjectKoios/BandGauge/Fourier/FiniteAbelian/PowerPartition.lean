/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Formal proof completed: 2026-11-03
-/
module

public import ProjectKoios.BandGauge.Fourier.FiniteAbelian.LatticeLeastSquares

/-!
# Exact onsite and nononsite Frobenius-power partition

This module partitions the explicit entrywise Frobenius power of a matrix-valued coefficient field
into the coefficient at the additive identity and the direct sum over every nonidentity coefficient.
For periodic-lattice hopping coefficients these are the exact onsite and nononsite powers.

The nononsite quantity is defined as a direct sum of nonnegative exact terms, not as subtraction of
two separately rounded totals.  The theorem therefore specifies the mathematical partition expected
of a runtime implementation, but it does not certify binary64 summation, array classification,
serialized values, or any scientific locality threshold.
-/

@[expose] public section

open scoped BigOperators

namespace ProjectKoios.BandGauge.Fourier.FiniteAbelian

variable {G m n : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]
  [Fintype m] [Fintype n]

/-- `BG-FOURIER-FINITE-DEF-003`: entrywise squared Frobenius power at the additive-identity
coefficient.  For a periodic-lattice hopping field this is the exact onsite power. -/
noncomputable def finiteMatrixFrobeniusOnsitePower
    (coefficients : G → Matrix m n ℂ) : ℝ :=
  ∑ i, ∑ j, ‖coefficients 0 i j‖ ^ 2

/-- `BG-FOURIER-FINITE-DEF-004`: direct entrywise squared Frobenius power over every nonidentity
coefficient.  For a periodic-lattice hopping field this is the exact nononsite power. -/
noncomputable def finiteMatrixFrobeniusNononsitePower
    (coefficients : G → Matrix m n ℂ) : ℝ :=
  ∑ displacement ∈ (Finset.univ.erase 0 : Finset G),
    ∑ i, ∑ j, ‖coefficients displacement i j‖ ^ 2

/-- `BG-FOURIER-FINITE-LEM-005`: directly summed nononsite Frobenius power is nonnegative. -/
lemma finiteMatrixFrobeniusNononsitePower_nonneg
    (coefficients : G → Matrix m n ℂ) :
    0 ≤ finiteMatrixFrobeniusNononsitePower coefficients := by
  rw [finiteMatrixFrobeniusNononsitePower]
  exact Finset.sum_nonneg fun _ _ =>
    Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => sq_nonneg _

/-- `BG-FOURIER-FINITE-THM-006`: exact total matrix Frobenius power is onsite power plus the direct
nononsite power. -/
theorem finiteMatrixFrobeniusPower_eq_onsite_add_nononsite
    (coefficients : G → Matrix m n ℂ) :
    finiteMatrixFrobeniusPower coefficients =
      finiteMatrixFrobeniusOnsitePower coefficients +
        finiteMatrixFrobeniusNononsitePower coefficients := by
  rw [finiteMatrixFrobeniusPower, finiteMatrixFrobeniusOnsitePower,
    finiteMatrixFrobeniusNononsitePower]
  symm
  exact Finset.add_sum_erase (Finset.univ : Finset G)
    (fun displacement => ∑ i, ∑ j, ‖coefficients displacement i j‖ ^ 2)
    (Finset.mem_univ 0)

/-- `BG-FOURIER-LATTICE-THM-006`: exact onsite/nononsite Frobenius-power partition on an arbitrary
finite periodic reciprocal-lattice quotient and at arbitrary finite matrix rank. -/
theorem finitePeriodicLatticeMatrixFrobeniusPower_eq_onsite_add_nononsite
    {Dimension : Type*} [Fintype Dimension] [DecidableEq Dimension]
    (lattice : FinitePeriodicReciprocalLattice Dimension)
    (coefficients : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ) :
    finiteMatrixFrobeniusPower coefficients =
      finiteMatrixFrobeniusOnsitePower coefficients +
        finiteMatrixFrobeniusNononsitePower coefficients :=
  finiteMatrixFrobeniusPower_eq_onsite_add_nononsite coefficients

/-- `BG-FOURIER-LATTICE-THM-007`: arbitrary-rank periodic one-dimensional specialization of the
exact onsite/nononsite Frobenius-power partition. -/
theorem finitePeriodicLatticeMatrixFrobeniusPower_eq_onsite_add_nononsite_oneDimensional
    (lattice : FinitePeriodicReciprocalLattice1D)
    (coefficients : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ) :
    finiteMatrixFrobeniusPower coefficients =
      finiteMatrixFrobeniusOnsitePower coefficients +
        finiteMatrixFrobeniusNononsitePower coefficients :=
  finitePeriodicLatticeMatrixFrobeniusPower_eq_onsite_add_nononsite lattice coefficients

/-- `BG-FOURIER-LATTICE-THM-008`: arbitrary-rank periodic two-dimensional specialization of the
exact onsite/nononsite Frobenius-power partition, independent of reciprocal-basis orthogonality. -/
theorem finitePeriodicLatticeMatrixFrobeniusPower_eq_onsite_add_nononsite_twoDimensional
    (lattice : FinitePeriodicReciprocalLattice2D)
    (coefficients : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ) :
    finiteMatrixFrobeniusPower coefficients =
      finiteMatrixFrobeniusOnsitePower coefficients +
        finiteMatrixFrobeniusNononsitePower coefficients :=
  finitePeriodicLatticeMatrixFrobeniusPower_eq_onsite_add_nononsite lattice coefficients

/-- `BG-FOURIER-LATTICE-THM-009`: arbitrary-rank periodic three-dimensional specialization of the
exact onsite/nononsite Frobenius-power partition, independent of reciprocal-basis orthogonality. -/
theorem finitePeriodicLatticeMatrixFrobeniusPower_eq_onsite_add_nononsite_threeDimensional
    (lattice : FinitePeriodicReciprocalLattice3D)
    (coefficients : FinitePeriodicLatticeMesh lattice → Matrix m m ℂ) :
    finiteMatrixFrobeniusPower coefficients =
      finiteMatrixFrobeniusOnsitePower coefficients +
        finiteMatrixFrobeniusNononsitePower coefficients :=
  finitePeriodicLatticeMatrixFrobeniusPower_eq_onsite_add_nononsite lattice coefficients

end ProjectKoios.BandGauge.Fourier.FiniteAbelian

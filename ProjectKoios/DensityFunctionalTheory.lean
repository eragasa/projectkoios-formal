/-
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-/
module

public import ProjectKoios.DensityFunctionalTheory.Foundations.HohenbergKohn
public import ProjectKoios.DensityFunctionalTheory.Foundations.ConstrainedSearch
public import ProjectKoios.DensityFunctionalTheory.KohnSham.FunctionalDecomposition
public import ProjectKoios.DensityFunctionalTheory.KohnSham.OccupiedOrbitals
public import ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumDensity
public import ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumSpinDensity
public import ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisDensity
public import ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisSpinDensity
public import ProjectKoios.DensityFunctionalTheory.PAW.FiniteTransformation
public import ProjectKoios.DensityFunctionalTheory.PAW.ProjectorAugmentation

/-!
Narrow root for implemented density-functional, Kohn--Sham, and finite PAW algebra.

This root re-exports only the current abstract scalar variational, constrained-search, exact
functional remainder, pointwise and representative-safe `L¹` continuum orbital densities, the
thin continuum spinor-to-scalar particle-density binding, finite-basis scalar and spin-density
convergence bindings, exact finite PAW transformation, and finite-rank projector-augmentation layers. It
does not expose a continuum solver, self-consistency loop, approximation functional, runtime
finite-basis implementation, PAW dataset, or augmentation implementation.
-/

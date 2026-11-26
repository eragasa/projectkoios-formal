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
public import ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisDensity

/-!
Narrow root for the implemented scalar density-functional foundations and Kohn--Sham bookkeeping.

This root re-exports only the current abstract variational, constrained-search, exact functional
remainder, pointwise orbital-density, and finite-basis density-binding layers. It does not expose a
continuum solver, self-consistency loop, approximation functional, operator discretization, runtime
finite-basis implementation, or PAW API.
-/

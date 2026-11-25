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

/-!
Narrow root for the implemented scalar density-functional foundations and Kohn--Sham bookkeeping.

This root re-exports only the current abstract variational, constrained-search, exact functional
remainder, and finite pointwise orbital-density layers.  It does not expose a continuum solver,
self-consistency loop, approximation functional, finite-basis implementation, or PAW API.
-/

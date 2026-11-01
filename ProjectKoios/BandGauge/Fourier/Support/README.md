<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-->

# Fourier support inventories

This family owns exact finite support and inventory semantics.

- `CenteredEvenMesh.lean`: positive-even centered inventories, deletion of the negative Nyquist representative, full-versus-removed reconstruction, removed-block power, and symmetric ordinary support.
- `MetricShell.lean`: complete finite metric shells, attained radii, tie retention, conditional inversion/symmetry closure, no-skipped-shell theorems, and exact square, triangular, simple-cubic, and normalized FCC integer indices.
- `RadiusGrowth.lean`: addition and inversion laws for complete shells under explicit subadditivity and inversion-invariance hypotheses on a nonnegative radius.

Completeness is relative to the supplied exact inventory and hypotheses. `RadiusGrowth.lean` uses the
complete inventory `Finset.univ`; it does not assert that the existing squared lattice-shell indices
satisfy its triangle hypothesis. These modules authenticate no external mesh, serialized inventory,
NumPy indexing convention, source-defined hopping range, or physical units.

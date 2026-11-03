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
- `LatticeRadius.lean`: explicit Euclidean realizations of the square, triangular, simple-cubic, and normalized FCC integer coordinates; exact radius-squared/index identities; inversion invariance; triangle inequalities; elementwise `R_A + 2 R_U` bounds; and complete set-valued shell inclusions.

Completeness is relative to the supplied exact inventory and hypotheses. `LatticeRadius.lean` closes
the triangle-hypothesis gap for the infinite integer-coordinate formulas, but it does not identify a
finite character group with centered integer representatives. A finite-quotient application must
separately handle wraparound and prove compatibility of its selected quotient radius. These modules
authenticate no external mesh, serialized inventory, NumPy indexing convention, source-defined
hopping range, or physical units.

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
- `CyclicQuotientRadius.lean`: the exact quotient-seminorm radius on complex Fourier characters of `ZMod n`, with inversion invariance, modular triangle inequality, and conservative bounds from arbitrary integer representatives.

Completeness is relative to the supplied exact inventory and hypotheses. `LatticeRadius.lean` closes
the triangle-hypothesis gap for the infinite integer-coordinate formulas.
`CyclicQuotientRadius.lean` separately handles the one-dimensional cyclic seam without pretending
that a raw centered-representative map is additive. It does not prove equality with a selected
centered representative or bind multidimensional product quotients to the square, triangular,
simple-cubic, or FCC radii. These modules authenticate no external mesh, serialized inventory,
NumPy indexing convention, source-defined hopping range, or physical units.

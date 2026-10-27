<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-20
-->

# Computational-owner source crosswalk

This crosswalk records immutable computational source constants that have explicit Lean
representations. It does not make the owner implementation a formal dependency, verify
runtime execution, or transfer scientific authority into this repository.

## PhysKit `FccBainCoordinateBridge3D`

- Owner repository: `projectkoios-physkit`
- Immutable commit: `7157dcedd0d220673d443c1c025e35a6fd1ffa7a`
- Immutable tree: `49889a01edcee57742efca568ef4ee68c9dd2bfa`
- Source path:
  `src/python/projectkoios/physkit/periodic/lattice/bain/bridge.py`
- Source locators: class declaration line 16; `n_F = U n_B` convention line 25;
  fixed matrices lines 42--49; determinant property lines 68--70; integer maps lines 72--80
- Source-byte SHA-256:
  `8bc4e9f0c957899a9b9c14ab75ece4aa8c82945ecb6524f0c1ecbb10067b8072`
- Lean module:
  `ProjectKoios/Crosswalks/PhysKit/FccBainCoordinateBridge.lean`

| Source contract | Lean declarations | Checked conclusion |
|---|---|---|
| fixed matrix `bain_to_fcc_matrix` in `n_F = U n_B` | `PKF-PHYSKIT-DEF-002` | exact integer constant only |
| fixed declared inverse `fcc_to_bain_matrix` | `PKF-PHYSKIT-DEF-003` | exact integer constant only |
| matrices are exact inverses | `PKF-PHYSKIT-THM-001/002` | both integer matrix products equal identity |
| determinant is one | `PKF-PHYSKIT-THM-003` | exact determinant over `ℤ` |
| unimodularity preserves finite periodic quotient coordinates | `PKF-PHYSKIT-DEF-004--007`, `PKF-PHYSKIT-THM-004/005` | for every positive `n`, the induced maps over `ZMod n` are mutual inverses and the Bain-to-FCC map is bijective |

The source uses row arrays multiplied by matrix transposes. The Lean definitions use the
equivalent column-coordinate convention `U *ᵥ x` and `V *ᵥ x`.

The crosswalk does **not** establish:

- that a live or serialized PhysKit object contains these constants;
- that arbitrary `numpy.int64` batch operations avoid overflow;
- that independently supplied lattices use these basis conventions;
- that the bridge has a particular physical or material interpretation; or
- any scientific-validation, release, or publication conclusion.

A later runtime-binding certificate, if separately approved, must bind an immutable
PhysKit record to these exact constants without reclassifying the mathematical theorem as
a Python-execution proof.

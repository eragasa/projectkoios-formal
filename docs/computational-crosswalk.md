<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-20
-->

# PhysKit FCC--Bain crosswalk

This record binds immutable PhysKit constants to exact Lean declarations. It does not verify Python execution or transfer scientific authority.

## Source

One immutable PhysKit file supplies the constants.

- Repository: `projectkoios-physkit`
- Commit: `7157dcedd0d220673d443c1c025e35a6fd1ffa7a`
- Tree: `49889a01edcee57742efca568ef4ee68c9dd2bfa`
- Path: `src/python/projectkoios/physkit/periodic/lattice/bain/bridge.py`
- Locators: class line 16; convention line 25; matrices lines 42--49; determinant lines 68--70; integer maps lines 72--80
- SHA-256: `8bc4e9f0c957899a9b9c14ab75ece4aa8c82945ecb6524f0c1ecbb10067b8072`
- Lean module: `ProjectKoios/Crosswalks/PhysKit/FccBainCoordinateBridge.lean`

## Mapping

The mapping is exact and finite.

| Source contract | Lean declarations | Conclusion |
|---|---|---|
| `bain_to_fcc_matrix` in `n_F = U n_B` | `PKF-PHYSKIT-DEF-002` | exact integer matrix |
| `fcc_to_bain_matrix` | `PKF-PHYSKIT-DEF-003` | exact integer matrix |
| two-sided inverse | `PKF-PHYSKIT-THM-001/002` | both products equal identity |
| determinant one | `PKF-PHYSKIT-THM-003` | exact determinant over `ℤ` |
| finite quotient map | `PKF-PHYSKIT-DEF-004--007`, `PKF-PHYSKIT-THM-004/005` | mutual inverses and bijection over `ZMod n` for positive `n` |

PhysKit uses row arrays with transposed matrices. Lean uses the equivalent column convention `U *ᵥ x`.

## Exclusions

The bridge has no runtime or scientific authority.

- No live-object or serialized-object binding.
- No `numpy.int64` overflow proof.
- No proof that external lattices use these bases.
- No crystallographic, material, release, or publication conclusion.

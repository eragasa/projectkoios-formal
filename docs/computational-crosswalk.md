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
| general lattice-quotient admission | `SS-QUOTIENT-DEF-001--008`, `SS-QUOTIENT-LEM-001--004`, `SS-QUOTIENT-THM-001--006` | `det B ≠ 0` proves `ℤ³/Bℤ³` finite; `A B = B C` proves well-definedness; a separately admitted integer inverse proves bijectivity |
| diagonal mixed-modulus admission | `PKF-PHYSKIT-QUOTIENT-DEF-001--004`, `PKF-PHYSKIT-QUOTIENT-LEM-001--004`, `PKF-PHYSKIT-QUOTIENT-THM-001--008` | the quotient is finite for positive periods; the selected map is admitted exactly when `N₂=N₃` and `N₁∣N₂`; every positive cubic quotient is admitted |

PhysKit uses row arrays with transposed matrices. Lean uses the equivalent column convention `U *ᵥ x`.

## Periodic3D rank-N Bain applicability request

A read-only KSD inspection used repository `ksdft2effmass`, branch
`work/periodic23-rank2-ragasa-metric-extension`, HEAD
`0bef3dc574648ac60e4014962da75077ded3b4b2`, tree
`d957c541e73f78a312107ddb62cf3eb9fff8514f`. The worktree had 124 dirty-status entries when this
crosswalk was recorded. The directly relevant path
`calculations/periodic3d_rankN_bain_path/geometry-common-state-space.md` was untracked, with
inspected-byte SHA-256 `6b9c019b86b0a66d6581742e76d6ef6f6d21a8b50ce442ea366b59f58c45b9fd`.
It states the same matrices, requires a proof for every finite mixed quotient, and leaves unsupported
noncubic quotients unresolved. Because the file is untracked, its bytes are provisional and not
reproducible from the recorded commit. The immutable matrix authority remains the PhysKit source
above.

The new exact admission theorem discharges the abstract arithmetic obligation only. A calculation
still has to bind its actual positive periods and common-cell convention to the theorem. No KSD
execution, array, mesh convergence result, or scientific conclusion is checked here.

## Exclusions

The bridge has no runtime or scientific authority.

- No live-object or serialized-object binding.
- No `numpy.int64` overflow proof.
- No proof that external lattices use these bases.
- No crystallographic, material, release, or publication conclusion.

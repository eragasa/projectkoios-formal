# Vogl `sp³s⋆` exact-algebra scope

This note maps the audited Vogl control to reusable Lean algebra. Source identity is in `docs/source-audit.md`; declarations are in `docs/theorem-manifest.md`.

## Proved scope

The implementation covers exact structural algebra.

- Tetrahedral sign matrix: `H Hᵀ = 4I`.
- Normalized transform `U = H/2`: symmetry, orthogonality, involution, and dot-product preservation.
- Orthonormal `sp³` hybrid rows and tetrahedral pairwise dot product `-1/3`.
- Five-orbital `s⋆` identity extension and ten-orbital two-sublattice extension.
- Four normalized bond-phase structure factors, unit total squared modulus, and Gamma value.
- Reduced-wavevector phase convention `(π/2)q`.
- Hermitian block matrix `[[D_A,T],[Tᴴ,D_C]]` with the declared structural zeros.

## Basis

The basis convention is fixed explicitly.

- One-sublattice order: `(s,pₓ,pᵧ,p_z,s⋆)`.
- `H/2` acts on `(s,pₓ,pᵧ,p_z)`.
- `s⋆` is fixed, not treated as a fifth tetrahedral direction.
- The ten-orbital basis is anion and cation copies of the same order.

## Parameters

`VoglSp3sStarParameters` contains 13 abstract real slots: six onsite and seven transfer parameters. No empirical row is instantiated. Hermiticity follows from exact block construction.

## Dependencies

The implementation uses pinned Mathlib finite-matrix, block, adjoint, Hermitian, norm, and complex-exponential APIs. Physlib is not required.

## Exclusions

No numerical or material claim is encoded.

- No accepted Table 1 values.
- No NumPy or JSON execution.
- No floating-point, spectrum, parameter-accuracy, DFT, Wannier, silicon, novelty, or publication claim.

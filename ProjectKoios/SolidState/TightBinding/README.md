# Solid-state tight-binding formalization

This directory owns exact finite-dimensional algebra used by solid-state tight-binding
models. It is independent of publication namespaces and computational-runtime ownership.

Implemented modules:

- `TetrahedralSp3.lean` — the normalized four-by-four tetrahedral Hadamard transform,
  dot-product preservation, involution, orthonormal hybrid rows, and tetrahedral sign
  geometry;
- `TetrahedralSp3sStar.lean` — the five-orbital extension that leaves `s⋆` unchanged and
  the block-diagonal ten-orbital two-sublattice extension;
- `TetrahedralStructureFactors.lean` — exact bond-phase structure factors, their unit
  squared-modulus sum rule, the reduced-wavevector convention, and the Gamma-point value;
- `VoglSp3sStar.lean` — an abstract 13-real-parameter nearest-neighbor hopping block,
  structural zeros, and the exact Hermitian ten-orbital block construction.

The formal basis is the disjoint union of anion and cation copies of
`(s, pₓ, pᵧ, p_z, s⋆)`. The `sp³` transform acts only on the first four orbitals; `s⋆` is
an independent scalar channel.

These modules do not contain the accepted Vogl Table 1 values and do not prove parameter
accuracy, numerical eigenspectra, Python behavior, empirical adequacy, density-functional
results, Wannier results, or silicon validation. They certify only the exact propositions
listed in `docs/theorem-manifest.md`. See
`docs/SolidState/TightBinding/vogl-sp3s-star-formalization.md` for the source and scope
crosswalk.

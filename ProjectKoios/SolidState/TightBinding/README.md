# Solid-state tight-binding formalization

This directory owns publication-independent exact finite tight-binding algebra.

- `TetrahedralSp3.lean`: normalized tetrahedral Hadamard transform and sign geometry.
- `TetrahedralSp3sStar.lean`: five-orbital and two-sublattice extensions.
- `TetrahedralStructureFactors.lean`: bond phases, structure factors, sum rule, and Gamma value.
- `VoglSp3sStar.lean`: abstract parameter slots, structural zeros, and Hermitian ten-orbital assembly.

## Boundaries

The model remains abstract and parameter-free.

- Basis order is anion/cation copies of `(s, pₓ, pᵧ, p_z, s⋆)`.
- No accepted empirical values are encoded.
- The modules do not certify spectra, Python behavior, parameter accuracy, DFT or Wannier results, silicon adequacy, novelty, or publication status.
- See `docs/SolidState/TightBinding/vogl-sp3s-star-formalization.md` for the source crosswalk.

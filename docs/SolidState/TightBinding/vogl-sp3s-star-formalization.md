# Vogl `sp³s⋆` exact-algebra formalization note

## Scope

This note crosswalks the calculation-owned Vogl development control to reusable exact
Lean algebra. The source identity and byte hashes are recorded in
[`../../source-audit.md`](../../source-audit.md). The authoritative declaration inventory
is [`../../theorem-manifest.md`](../../theorem-manifest.md).

The formal slice proves:

1. for the tetrahedral sign matrix `H`, `H Hᵀ = 4 I`;
2. `U = H/2` is symmetric, orthogonal, involutive, and dot-product preserving;
3. its rows are orthonormal `sp³` hybrid coordinate vectors;
4. the four normalized tetrahedral bond directions have pairwise dot product `-1/3`;
5. extending `U` by the identity on `s⋆` preserves those algebraic properties;
6. applying that five-orbital extension independently on both sublattices yields an
   orthogonal ten-orbital transform;
7. the four `1/4`-normalized Hadamard combinations of unit bond phases obey
   `Σμ |gμ|² = 1` and equal `(1,0,0,0)` at Gamma;
8. the reduced-wavevector convention `k=(2π/a_L)q` corresponds to tetrahedral phase
   argument `(π/2)q`; and
9. the abstract ten-orbital block matrix `[[D_A,T],[Tᴴ,D_C]]` is Hermitian, including
   the published structural zero pattern.

## Basis and `s⋆` interpretation

On one sublattice the atomic-orbital order is `(s,pₓ,pᵧ,p_z,s⋆)`. The tetrahedral
Hadamard transform acts on the first four coordinates. The `s⋆` channel is not treated as
a fifth tetrahedral direction; it is fixed by the five-by-five extension

```text
U₅ = diag(H/2, 1).
```

The ten-orbital basis is a disjoint union of anion and cation copies of that five-orbital
basis. The corresponding transform is `diag(U₅,U₅)`. The same index type is used by the
Vogl Hamiltonian, avoiding an implicit ordering conversion inside the formal statements.

## Parameter and Hamiltonian boundary

`VoglSp3sStarParameters` has 13 abstract real fields matching the six onsite and seven
transfer slots used by the nearest-neighbor model. `voglSp3sStarHopping` fixes the exact
five-by-five placement, directional signs, and three structural zeros. No particular
parameter row is instantiated.

Hermiticity follows from exact block construction, not from a runtime equality check:
real diagonal onsite blocks are Hermitian and the lower-left block is defined as the
conjugate transpose of the upper-right block.

## Library search and ownership

The implementation reuses pinned Mathlib declarations for finite matrices, dot products,
block matrices, conjugate transpose, Hermitian matrices, complex squared norm, and the
unit norm of `exp(i x)`. The bounded Physlib evaluation recorded in
[`../../dependency-audit.md`](../../dependency-audit.md) was reviewed, but Physlib is not
adopted because Mathlib already supplies the required generic algebra.

The explicit tetrahedral matrices and the 13-slot Vogl record are local model conventions,
not proposed replacements for generic Mathlib or Physlib APIs.

## Nonclaims

The formal slice does not encode or certify the accepted Vogl Table 1 transcription. It
does not execute or verify NumPy, parse JSON, prove floating-point rounding properties,
calculate eigenvalues, validate silicon, compare against DFT or Wannier results, establish
parameter accuracy, or support a novelty or publication-status claim. A future exact data
certificate would require its own immutable schema, parser boundary, and separately
reviewed theorem statements.

# Dependency and toolchain audit

## Selected harness toolchain

- Lean: `leanprover/lean4:v4.35.0` (`lean-toolchain`)
- Mathlib input revision: `56a005855ea17e0b0958f73ec801ae140b0a1679` (`lakefile.toml`)
- Resolved direct and transitive revisions: tracked in `lake-manifest.json`

Before selection, `elan 4.2.3` and only local toolchain `leanprover/lean4:v4.33.0` were present; no project toolchain was active. The Physlib probe installed Lean 4.35.0. The selected Mathlib commit itself declares Lean 4.35.0.

No floating branch or tag is used as this package's durable direct dependency input. Generated `.lake/` state is ignored; the manifest is not ignored.

## Mathlib matrix spectral API selection

The canonical finite spectral bridge reuses the pinned Mathlib declarations
`Matrix.IsHermitian.eigenvalues`, `Matrix.IsHermitian.eigenvectorUnitary`, and
`Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary` from
`Mathlib.Analysis.Matrix.Spectrum`. Their exact relevant signature supplies real
finite-dimensional eigenvalues, a `Matrix.unitaryGroup` eigenvector matrix, and the
identity `U† A U = diagonal (ofReal ∘ eigenvalues)` for a Hermitian square matrix.
This matches the repository's required orientation after rewriting matrix `star` as
conjugate transpose. The construction is noncomputable and uses Mathlib's exact spectral
theorem; it is not an eigensolver implementation or numerical certificate. Eigenvalue
ordering is intentionally unused by the symmetric two-state loss.

No matching Mathlib Pauli-coordinate basis API was found. Physlib has Pauli-matrix APIs,
but Physlib is not adopted and importing it solely for the elementary rank-two identity
would violate the current dependency boundary. The local coordinate definitions therefore
encode only the required standard `2 × 2` convention and are proved directly.

## Mathlib tetrahedral and block-matrix API selection

The solid-state tight-binding slice reuses the pinned Mathlib matrix notation and finite
matrix multiplication, `Matrix.fromBlocks`, `Matrix.fromBlocks_multiply`, `Matrix.IsHermitian.fromBlocks`, complex conjugate transpose,
`Complex.normSq`, and `Complex.norm_exp_I_mul_ofReal`. These declarations directly support
the required finite transforms, bond-phase norm identity, and Hermitian block assembly.
The explicit four-by-four and five-by-five transforms are model conventions rather than
missing generic library structures, so they remain local definitions with direct finite
proofs.

The previously evaluated Physlib orthogonal-matrix helper could express part of the
change-of-basis argument, but Physlib remains unadopted and would add no required theorem
to this bounded slice. No dependency pin changed.

## Bounded Physlib evaluation (not adopted)

Evaluated immutable Physlib revision:

- repository: `https://github.com/leanprover-community/physlib.git`
- revision: `adc97f054083132000567cb09ff8f7b1f073400d`
- declared toolchain at that revision: Lean 4.35.0
- its manifest resolves Mathlib to `56a005855ea17e0b0958f73ec801ae140b0a1679`, matching this harness

A temporary project required both repositories by those full revisions. `lake update` resolved the expected commits. The full cache retrieval was too slow and timed out after 30 minutes, so it is not evidence of a full Physlib build. A narrower source check then succeeded:

```console
lake build Physlib.Mathematics.ForMathlib.OrthogonalMatrix Probe
# Build completed successfully (1030 jobs).
```

`Probe` imported `Physlib.Mathematics.ForMathlib.OrthogonalMatrix`, resolved and displayed `Matrix.dotProduct_mulVec_orthogonal`, and compiled a kernel-checked smoke theorem. Its axiom report said it did not depend on any axioms.

**Conclusion:** this immutable Physlib revision is checked compatible only for the selected toolchain, dependency resolution, and that narrow imported module. The umbrella import, all Physlib targets, linters, and scientific suitability were not checked. Physlib is therefore **not adopted** as a dependency and no broader compatibility claim is made.

### Prospective narrow Bloch bridge

At the evaluated revision, `Physlib.CondensedMatter.Crystal` supplies a finitely generated
abelian direct-space translation group, a finite nonempty unit cell, sites, and the
translation action. `Physlib/CondensedMatter/BandTheory/Basic.lean` is only a documented
namespace home; it does not define or prove Bloch--Floquet decomposition, reciprocal
lattices, Brillouin tori, Bloch Hamiltonians, band projectors, or global frames. A separate
upstream-tree check found the same single-file BandTheory surface; that check is not a
compatibility or dependency pin.

`ProjectKoios.BandGauge.Bloch.PeriodicRankTwoBlochSampleData` is therefore a local abstract
interface, not a replacement proof of Bloch's theorem. A future Physlib dependency may
supply its direct-space crystal component through a narrow adapter, after an immutable
revision passes the full selected-toolchain build and relevant lint checks. No Physlib
import or durable dependency is added by the current work.

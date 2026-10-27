# Dependency audit

This audit records the selected immutable toolchain and the rejected optional dependency.

## Selected toolchain

The repository uses one pinned Lean and Mathlib pair.

- Lean: `leanprover/lean4:v4.35.0`
- Mathlib: `56a005855ea17e0b0958f73ec801ae140b0a1679`
- Transitive revisions: `lake-manifest.json`
- Generated state: `.lake/`, ignored

No floating dependency is used.

## Mathlib selections

Current modules reuse the following APIs.

- Finite Hermitian spectra: `Matrix.IsHermitian.eigenvalues`, `eigenvectorUnitary`, and `conjStarAlgAut_star_eigenvectorUnitary` from `Mathlib.Analysis.Matrix.Spectrum`.
- Matrix and block algebra: finite multiplication, `Matrix.fromBlocks`, conjugate transpose, Hermitian predicates, `Complex.normSq`, and complex exponential norm identities.
- Fourier algebra: finite additive characters, orthogonality, and Pontryagin duality.
- Quantum partial operators: Mathlib `LinearPMap`, formal adjoints, maximal adjoints, closedness, and closability APIs.

The spectral construction is exact and noncomputable. It is not an eigensolver or numerical certificate. Local Pauli and tetrahedral matrices encode model conventions absent from the inspected generic APIs.

## Physlib probe

Physlib was evaluated but not adopted.

- Repository: `https://github.com/leanprover-community/physlib.git`
- Revision: `adc97f054083132000567cb09ff8f7b1f073400d`
- Lean: 4.35.0
- Resolved Mathlib: `56a005855ea17e0b0958f73ec801ae140b0a1679`

The full cache retrieval timed out after 30 minutes. The narrow probe passed:

```console
lake build Physlib.Mathematics.ForMathlib.OrthogonalMatrix Probe
# Build completed successfully (1030 jobs).
```

`Probe` imported the orthogonal-matrix helper and compiled an axiom-free smoke theorem.

## Conclusion

The narrow probe did not justify dependency adoption.

- Compatibility evidence covers only the selected revision, toolchain, dependency resolution, and narrow imported module.
- The umbrella import, full build, linters, and scientific suitability were not checked.
- Mathlib supplies the finite APIs required by current modules.
- Physlib remains unadopted.
- Its current BandTheory surface does not provide Bloch--Floquet decomposition or the reciprocal-space structures needed here.

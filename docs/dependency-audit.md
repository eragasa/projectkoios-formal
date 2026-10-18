# Dependency and toolchain audit

## Selected harness toolchain

- Lean: `leanprover/lean4:v4.35.0` (`lean-toolchain`)
- Mathlib input revision: `56a005855ea17e0b0958f73ec801ae140b0a1679` (`lakefile.toml`)
- Resolved direct and transitive revisions: tracked in `lake-manifest.json`

Before selection, `elan 4.2.3` and only local toolchain `leanprover/lean4:v4.33.0` were present; no project toolchain was active. The Physlib probe installed Lean 4.35.0. The selected Mathlib commit itself declares Lean 4.35.0.

No floating branch or tag is used as this package's durable direct dependency input. Generated `.lake/` state is ignored; the manifest is not ignored.

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

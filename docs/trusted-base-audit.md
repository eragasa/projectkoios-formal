# Trusted-base audit

This file defines the trust boundary and records selected historical audit results.

## Trusted base

The trusted base is explicit and small.

- Lean 4.35.0 kernel and `lean-toolchain`.
- Mathlib and transitive revisions in `lake-manifest.json`.
- Repository Lean declarations under `ProjectKoios/`.
- Audit scripts as evidence producers, not logical axioms.

Physlib is not a dependency.

## Policy

Formal status requires visible assumptions and admissions checks.

- No repository scientific axioms.
- No hidden `sorry`, `admit`, or equivalent admissions.
- No `proved` status without a named `#print axioms` report.
- Report classical axioms exactly.
- Document soundness boundaries for reflection, native computation, generated code, or external solvers.
- Treat builds as compilation evidence only.

## Required gates

Every promotion tree passes the same gate set.

| Layer | Check |
|---|---|
| Pins | `./scripts/check-pins.py` |
| Build | one cached or incremental `lake build` per exact candidate tree |
| Admissions and audit coverage | `./scripts/audit.sh` |
| Named axioms | `ProjectKoios/Audit.lean` |
| Manifest | compare declarations with `docs/theorem-manifest.md` |
| Crosswalk | compare source revision, statement, and assumptions |

## Build reuse

Build evidence is keyed by exact tree and dependency identity.

- Identify evidence by source tree, `lean-toolchain`, and `lake-manifest.json`.
- Reuse `.lake` and immutable dependency materialization.
- Prefer one persistent clean integration worktree.
- Run `lake update` only for dependency changes.
- Compile affected modules during development.
- Run the full build once for the promotion tree.
- Reuse the result after unchanged staging, commit, or byte-identical merge.
- Rebuild only after identity changes, failure/interruption, or loss of trusted evidence.

## Publication-facing gate

Record:

1. fully qualified declaration;
2. exact Lean type;
3. immutable source and locator;
4. assumption delta;
5. direct proof dependencies;
6. axiom report;
7. pin and build results; and
8. external certificate or numerical obligations.

## Historical tranche records

These records preserve earlier promotion evidence.

### PIAB1D, 2026-10-21

The PIAB1D tranche passed its declared gates.

- `lake build`: passed, 3,126 jobs.
- `./scripts/audit.sh`: passed; it found no scanned `sorry`, `admit`, or repository-owned `axiom` marker.
- New finite-dimensional, finite-difference, exponential-mode, scalar-twisted/PBC, doubled-cycle odd-extension, and PIAB1D reports used only `propext`, `Classical.choice`, and `Quot.sound`.
- Exact `Matrix.mulVec` results bind no NumPy/SciPy arrays, binary64 values, JSON, or retained calculation.
- Canonical Dirichlet, periodic, and twisted modes prove no continuum completeness, universal mode nonzero/distinctness, or Bloch--Floquet theorem. Scalar real-space twisting is not reciprocal-fiber sewing.

### Symbolic finite barrier, 2026-10-21

The barrier tranche passed its declared gates.

- `lake build`: passed, 3,129 jobs.
- `./scripts/check-pins.py` passed: Mathlib was `56a005855ea17e0b0958f73ec801ae140b0a1679`, and all nine resolved revisions were commit IDs.
- `./scripts/audit.sh` and `git diff --check` passed; the scan found no `sorry`, `admit`, or repository-owned `axiom` marker.
- Forty-four constant-region, transfer-matrix, finite-barrier, and interface-matching declarations had unique manifest rows.
- Thirty named reports used only `propext`, `Classical.choice`, and `Quot.sound`.
- The symbolic results do not solve constrained left-incident scattering amplitudes, assign flux probabilities, certify numerical transmission/reflection, take an infinite-barrier limit, bind runtime arrays, or establish continuum convergence.

### Two-band projection-support counterexample, 2026-10-20

Historical artifacts preserved in the original dirty worktree show exact module and audit
compilation under Lean 4.35.0 and pinned Mathlib revision
`56a005855ea17e0b0958f73ec801ae140b0a1679`.

- Dirty worktree base commit: `26603110e9d64cd51c9101eff68060307f258a18`.
- Preserved dirty-state patch SHA-256: `1385c7a92ab645f72eec8634defa640ecbb5f0083d7f70f3a75e3f0ee271e57e`.
- `LaurentObstruction.lean` SHA-256: `30ade56110a43ea1f884b992b821dc0e127772a86324e65bb4d975cba25b59ff`; compiled `.olean` SHA-256: `b1327d646a3307a55ef18f03da189b83a0bd23a88a2872641f226faed3da796a`.
- `SpectralProjectionRange.lean` SHA-256: `6cb39a3825085cde2294ab8f594e62912f3ed9d9b72c16211f472599675b47d9`; compiled `.olean` SHA-256: `e8c373622847113788c5ab308aafb9d96d8f52466bc4f37adaa4192ebbf450dd`.
- The corresponding `ProjectKoios/Audit.olean` SHA-256 is `5496e256802b7de24d528fede735866973713b1ef8ccd43b8a3b19addf86d5ac`; its trace records all eight named projection reports.
- `BG-PROJECTION-THM-001` through `BG-PROJECTION-THM-008` report only `propext`, `Classical.choice`, and `Quot.sound`.

These historical artifacts establish compilation of the preserved source bytes, not freshness
of the current reconciliation tree or a full promotion build. A current exact-tree build,
pin check, audit, manifest check, and crosswalk review remain required before promotion. The
results prove only the exact analytic counterexample; they do not establish numerical,
material, runtime-evidence, localization-rate, universal-projection, release, or publication
claims.

### Finite product gauge--locality separation, 2026-11-01

The source-neutral product-mesh tranche passed its declared Lean gates.

- `lake build`: passed, 3,883 jobs.
- `./scripts/check-pins.py`: passed against Mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679` and immutable dependency revisions.
- `./scripts/audit.sh`: passed with 847 proved theorem/lemma rows and 851 unique named axiom reports; the scan found no repository-owned admitted declaration marker.
- The new module defines six witness objects (`BG-FOURIER-DEF-059`--`064`) and proves 26 declarations (`BG-FOURIER-THM-134`--`159`), including generic finite-product results and explicit `Fin 2` and `Fin 3` specializations.
- All 26 new named reports use only `propext`, `Classical.choice`, and `Quot.sound`.
- `ProjectKoios/BandGauge/Fourier/ProductGaugeLocalitySeparation.lean` has SHA-256 `709237449b6ddbcb6fce3e2ab83bc9b09ffe2cb392ecff6f0f23ea9e5f2a21a9`.
- The exact finite identities do not authenticate an external torus coordinate or gauge, a runtime mesh or comparator, quadrature, finite-mesh approximation, physical hopping range, finite-to-continuum convergence, or scientific adequacy.

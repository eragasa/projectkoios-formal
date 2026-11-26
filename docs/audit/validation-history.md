# Validation history

These records preserve superseded or tranche-specific validation evidence. They establish only the
checks stated for the recorded source bytes, toolchain, and dependency identity. They are not
current-tree validation and do not establish scientific validity or publication authority.

## Record inventory

| Record | Historical tranche |
|---|---|
| [`AUD-HIST-001`](#aud-hist-001) | PIAB1D, 2026-10-21 |
| [`AUD-HIST-002`](#aud-hist-002) | Symbolic finite barrier, 2026-10-21 |
| [`AUD-HIST-003`](#aud-hist-003) | Two-band projection-support counterexample, 2026-10-20 |
| [`AUD-HIST-004`](#aud-hist-004) | Finite product gauge--locality separation, 2026-11-01 |
| [`AUD-HIST-005`](#aud-hist-005) | Hermitian Hoffman--Wielandt and RMS compression, 2026-11-04 |

<a id="aud-hist-001"></a>

## `AUD-HIST-001` — PIAB1D, 2026-10-21

The PIAB1D tranche passed its declared gates.

- `lake build`: passed, 3,126 jobs.
- `./scripts/audit.sh`: passed; it found no scanned `sorry`, `admit`, or repository-owned `axiom` marker.
- New finite-dimensional, finite-difference, exponential-mode, scalar-twisted/PBC, doubled-cycle odd-extension, and PIAB1D reports used only `propext`, `Classical.choice`, and `Quot.sound`.
- Exact `Matrix.mulVec` results bind no NumPy/SciPy arrays, binary64 values, JSON, or retained calculation.
- Canonical Dirichlet, periodic, and twisted modes prove no continuum completeness, universal mode nonzero/distinctness, or Bloch--Floquet theorem. Scalar real-space twisting is not reciprocal-fiber sewing.


<a id="aud-hist-002"></a>

## `AUD-HIST-002` — Symbolic finite barrier, 2026-10-21

The barrier tranche passed its declared gates.

- `lake build`: passed, 3,129 jobs.
- `./scripts/check-pins.py` passed: Mathlib was `56a005855ea17e0b0958f73ec801ae140b0a1679`, and all nine resolved revisions were commit IDs.
- `./scripts/audit.sh` and `git diff --check` passed; the scan found no `sorry`, `admit`, or repository-owned `axiom` marker.
- Forty-four constant-region, transfer-matrix, finite-barrier, and interface-matching declarations had unique manifest rows.
- Thirty named reports used only `propext`, `Classical.choice`, and `Quot.sound`.
- The symbolic results do not solve constrained left-incident scattering amplitudes, assign flux probabilities, certify numerical transmission/reflection, take an infinite-barrier limit, bind runtime arrays, or establish continuum convergence.


<a id="aud-hist-003"></a>

## `AUD-HIST-003` — Two-band projection-support counterexample, 2026-10-20

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


<a id="aud-hist-004"></a>

## `AUD-HIST-004` — Finite product gauge--locality separation, 2026-11-01

The source-neutral product-mesh tranche passed its declared Lean gates.

- `lake build`: passed, 3,883 jobs.
- `./scripts/check-pins.py`: passed against Mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679` and immutable dependency revisions.
- `./scripts/audit.sh`: passed with 847 proved theorem/lemma rows and 851 unique named axiom reports; the scan found no repository-owned admitted declaration marker.
- The new module defines six witness objects (`BG-FOURIER-DEF-059`--`064`) and proves 26 declarations (`BG-FOURIER-THM-134`--`159`), including generic finite-product results and explicit `Fin 2` and `Fin 3` specializations.
- All 26 new named reports use only `propext`, `Classical.choice`, and `Quot.sound`.
- At that historical tranche, `ProjectKoios/BandGauge/Fourier/ProductGaugeLocalitySeparation.lean` had SHA-256 `709237449b6ddbcb6fce3e2ab83bc9b09ffe2cb392ecff6f0f23ea9e5f2a21a9`; the later hierarchy migration is recorded separately and does not rewrite this historical byte identity.
- The exact finite identities do not authenticate an external torus coordinate or gauge, a runtime mesh or comparator, quadrature, finite-mesh approximation, physical hopping range, finite-to-continuum convergence, or scientific adequacy.


<a id="aud-hist-005"></a>

## `AUD-HIST-005` — Hermitian Hoffman--Wielandt and RMS compression, 2026-11-04

The source-neutral ordered-spectrum RMS tranche passed its declared affected-target gates and landed
on `main` at immutable commit `9192f3b123613a5d21ae899a1e8b5364a4fca65a`, tree
`875704b55631bf5136d6cb453a83c9f73bfea29e`.

- The new foundation and projection modules, their direct dependency modules, and `ProjectKoios.Audit` built successfully under Lean 4.35.0 and pinned Mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679`.
- `./scripts/audit.sh` passed; the scan found no repository-owned `sorry`, `admit`, or `axiom` marker.
- Audit coverage passed with 1,086 proved theorem/lemma rows and 1,090 unique named axiom reports.
- All ten new named reports use only `propext`, `Classical.choice`, and `Quot.sound`.
- Fresh-context read-only review found no blocking mathematical, normalization, norm-instance, audit, manifest, or documentation issue after correction of the pre-integration board status.
- The exact results prove an unnormalized ordered-eigenvalue square-sum bound, its nonzero-dimension RMS normalization, and exact-frame compression transfer. They do not authenticate external matrices, frames, eigensolver ordering or degeneracy handling, runtime norm evaluation, scientific applicability, or numerical evidence.

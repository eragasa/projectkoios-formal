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

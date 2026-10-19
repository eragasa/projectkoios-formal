# Trusted-base audit

## Current trusted base

The startup harness relies on:

- the Lean 4.35.0 kernel and toolchain named by `lean-toolchain`;
- Mathlib and its transitive dependencies at revisions resolved by `lake-manifest.json`;
- repository-owned Lean declarations under `ProjectKoios/`; and
- local audit scripts whose outputs are evidence about source text and named declarations, not extensions of the kernel.

Physlib is not a dependency. Its bounded compatibility probe is documented separately and does not enlarge the current trusted base.

## Repository policy

- Do not introduce a repository-owned axiom to represent a scientific claim.
- Do not hide `sorry`, `admit`, or equivalent admissions.
- Do not classify a declaration as proved until `#print axioms` has been recorded for it.
- If a declaration uses classical principles provided by Lean or Mathlib, report the actual axiom output rather than calling the proof constructive.
- Generated code, reflection, native computation, or an external solver requires a documented soundness boundary before supporting a publication-facing theorem.
- A clean build demonstrates elaboration and compilation only; it does not establish source fidelity or scientific validity.

## Required audit layers

| Layer | Required check | What it establishes |
|---|---|---|
| Dependency identity | `./scripts/check-pins.py` | declared Mathlib and resolved Lake revisions are immutable commit IDs |
| Build | `lake build` | repository targets elaborate and compile with the selected toolchain |
| Text admission scan | `./scripts/audit.sh` | repository-owned Lean sources contain no scanned admission markers |
| Named axiom report | `#print axioms` in `ProjectKoios/Audit.lean` | dependencies of the named declarations as reported by Lean |
| Manifest review | compare `docs/theorem-manifest.md` with Lean sources | reported theorem status matches declarations that actually exist |
| Crosswalk review | compare source revision, statement, and assumptions | formal declaration has not silently changed the publication claim |

## Publication-facing gate

Before a scientific declaration is marked proved, the audit must record:

1. its fully qualified Lean name;
2. its exact Lean type;
3. its source statement and immutable source identity;
4. assumption differences;
5. direct proof dependencies;
6. `#print axioms` output;
7. the successful pin and build checks; and
8. any external certificate or numerical obligations that remain outside the proof.

The rational rank-two checker reduces exact decidable propositions inside Lean; its soundness theorems remain kernel checked. Runtime parsing and field-to-certificate bindings are not trusted implicitly.

Current proof IDs and statuses are listed only in `theorem-manifest.md`. No listed theorem instantiates concrete publication model data, constitutes a concrete checked scientific certificate, validates a scientific model, or authorizes a release.

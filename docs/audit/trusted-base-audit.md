# Trusted-base audit

This file defines the trust boundary and records current validation evidence. Superseded and
tranche-specific evidence is preserved in [`validation-history.md`](validation-history.md).

## Trusted base

The trusted base is explicit and versioned.

- Lean 4.36.0 kernel and `lean-toolchain`.
- Mathlib revision `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`.
- Physlib package revision `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd`, exposing the
  `Physlib`, `PhyslibAlpha`, and `QuantumInfo` Lean libraries.
- All resolved transitive revisions in `lake-manifest.json`.
- Repository Lean declarations under `ProjectKoios/`.
- Audit scripts as evidence producers, not logical axioms.

## Policy

Formal status requires visible assumptions and admissions checks.

- No repository scientific axioms.
- No hidden `sorry`, `admit`, or equivalent admissions.
- No `proved` status without a named `#print axioms` report.
- Report classical axioms exactly.
- Document soundness boundaries for reflection, native computation, generated code, or external solvers.
- Treat builds as compilation evidence only.

## Required gates

Validation is proportional to the changed trust surface.

| Layer | Check |
|---|---|
| Pins | `./scripts/check-pins.py` |
| Affected Lean targets | compile every changed module, its bounded affected consumers, and the smallest relevant audit target; not required for documentation-only changes unless a formal-status or reproducibility claim must be replayed |
| Repository-wide build | `lake build` only for toolchain/dependency, Lake/package, namespace-root, unbounded shared-foundation, ambiguous targeted-coverage, release/publication, or explicit-request gates |
| Admissions and audit coverage | `./scripts/audit.sh` for Lean changes and any changed formal-status claim |
| Named axioms | `ProjectKoios/Audit.lean` for new or changed proved declarations |
| Manifest | compare changed declarations with `docs/theorem-manifest.md` |
| Crosswalk | compare changed source revision, statement, and assumptions |
| Generated state | confirm build products remain ignored and untracked |

## Build reuse

Targeted and repository-wide evidence have different scopes and must be labeled honestly.

- Identify evidence by source tree, `lean-toolchain`, and `lake-manifest.json`.
- Reuse `.lake` and immutable dependency materialization.
- Prefer one persistent clean integration worktree.
- Run `lake update` only for dependency changes.
- Compile every changed module and its bounded affected consumers during development or promotion.
- Do not require a repository-wide build merely because an otherwise bounded source tree changed.
- Except when freezing a release or publication snapshot, when toolchain and dependency identity are unchanged, combine prior repository-wide evidence with exact affected-target and audit checks for descendant trees. A frozen release or publication snapshot requires a repository-wide build of that exact tree.
- Escalate to a full build when the affected set cannot be bounded reliably, targeted validation fails, a release/publication snapshot is frozen, or an operator/reviewer requests it.
- Reuse results after unchanged staging, commit, or byte-identical merge.
- Never report affected-target compilation as a full repository build.

## Publication-facing gate

Record:

1. fully qualified declaration;
2. exact Lean type;
3. immutable source and locator;
4. assumption delta;
5. direct proof dependencies;
6. axiom report;
7. pin and validation results, distinguishing targeted compilation from repository-wide builds; and
8. external certificate or numerical obligations.

## Current Physlib-backed formalization evidence

The adopted pins are identified above. Targeted, repository-wide, audit, and generated-document
evidence have distinct scopes and are not interchangeable.

Evidence context at the recorded validation runs:

- branch: `review/conjugate-linear-coordinate-algebra`;
- committed base at the start of the validated development tree:
  `526fbc11772411fab273e662b3b6e4f2eff3b5f4`;
- validation-tree status: an uncommitted descendant with broad formal and documentation changes, so
  the affected-target rows below are bounded development evidence rather than an immutable
  release-tree attestation;
- `lean-toolchain` SHA-256:
  `582a63f8f9c5128067b688778c1051cf1464c3ca9d57b9325025c051c29b774a`;
- `lake-manifest.json` SHA-256:
  `4854285512498c87dc59f0e4d675212f0afcb7b8b65eafc91fbf47a5bbd667c5`; and
- `lakefile.toml` SHA-256:
  `b7cd33fa996f803dffae8d96218c8b5e4d71a511bc7487a697984f5208531298`.

The command row and stated scope, not the phrase “current formal source tree,” determine what each
record establishes. A release or publication snapshot still requires immutable exact-tree evidence.

| Evidence ID | Source tree | Command or target | Result and scope |
|---|---|---|---|
| <a id="aud-val-001"></a>`AUD-VAL-001` | current formal source tree | `lake build ProjectKoios.QuantumMechanics.Operator.Schrodinger`; `...Operator.Hydrogen` | passed, 6,622 and 6,634 jobs; affected operator targets only |
| <a id="aud-val-002"></a>`AUD-VAL-002` | current formal source tree | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.Continuum` | passed at 6,692, 6,696, and 6,708 jobs as the bounded bridge grew; affected oscillator target only |
| <a id="aud-val-003"></a>`AUD-VAL-003` | current formal source tree | `lake build ProjectKoios.QuantumMechanics.Fourier.IntegralInjectivity` | passed, 5,897 jobs; affected Fourier target only |
| <a id="aud-val-004"></a>`AUD-VAL-004` | current formal source tree | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.QuantumSystem` | passed, 6,712 jobs; affected packaging target only |
| <a id="aud-val-005"></a>`AUD-VAL-005` | current formal source tree | `lake build ProjectKoios.QuantumMechanics.Evolution.Schrodinger` | passed, 5,668 jobs; affected evolution target only |
| <a id="aud-val-006"></a>`AUD-VAL-006` | current formal source tree | continuum-density target and bounded audit target | passed, 6,538 and 8,630 jobs |
| <a id="aud-val-007"></a>`AUD-VAL-007` | current formal source tree | finite QuantumInfo target/root, `ProjectKoios.QuantumMechanics`, and audit target | passed, 6,672, 7,298, and 8,858 jobs |
| <a id="aud-val-008"></a>`AUD-VAL-008` | current formal source tree | angular-momentum target/root, `ProjectKoios.QuantumMechanics`, and audit target | passed, 7,428, 7,972, and 8,982 jobs |
| <a id="aud-val-009"></a>`AUD-VAL-009` | exact convention-root integration tree | repository-wide `lake build` | passed, 8,555 jobs; this is not a full build of later descendant trees |
| <a id="aud-val-010"></a>`AUD-VAL-010` | current dependency identity | `python3 scripts/check-pins.py` | passed with 10 immutable resolved revisions |
| <a id="aud-val-011"></a>`AUD-VAL-011` | current formal source tree | `python3 scripts/check-audit-coverage.py` | passed with 1,285 proved theorem/lemma rows and 1,289 unique named axiom reports |
| <a id="aud-val-012"></a>`AUD-VAL-012` | formal working tree at the recorded run | `bash scripts/audit.sh` | passed; the later audit-document reorganization is documentation-only |
| <a id="aud-val-013"></a>`AUD-VAL-013` | current dossier tree at the recorded run | whole-repository proof-compendium rebuild | passed for 371 dossiers, one source-defined schematic, and 85 labeled generated inventory fallbacks |
| <a id="aud-val-014"></a>`AUD-VAL-014` | newly audited declaration set | named `#print axioms` reports | only `propext`, `Classical.choice`, and `Quot.sound` |
| <a id="aud-val-015"></a>`AUD-VAL-015` | current documentation descendant, 2026-11-27 | `git diff --check`; local Markdown path and anchor checks | passed; zero broken local Markdown paths and zero broken checked anchors after the audit split |

The repository-wide result `AUD-VAL-009` may be combined with descendant affected-target evidence
only under the build-reuse policy above. It must not be represented as a full build of the final
descendant working tree. Historical tranche evidence is recorded separately in
[`validation-history.md`](validation-history.md).

The results prove representative-safe continuum-density identities; finite quantum-information
bindings; continuum orbital-angular-momentum domain, symmetry, closability, and commutator
statements; and domain, action, symmetry, dense-definedness, and closability statements for the
adopted Physlib Schrödinger operators, including the unregularized hydrogenic potential. The
oscillator's general essential-self-adjointness result remains conditional on an explicit
`d`-dimensional eigenstate dense-span premise, while the dimension-one Hamiltonian is
unconditionally essentially self-adjoint through direct pointwise Fourier-integral injectivity.
Its closure is packaged as a self-adjoint Physlib `QuantumSystem`, bound to PhyslibAlpha's concrete
Cayley-transform domain-aware spectral measure, and evolved through the physical convention
`U(t)=exp(-itH/ℏ)` with all-time domain-vector derivatives, domain invariance, and generator
commutation. These results do not provide an oscillator spectral eigenfunction expansion, an exact
singular Coulomb domain, a continuum or DFT spin-orbit Hamiltonian, or physical applicability.

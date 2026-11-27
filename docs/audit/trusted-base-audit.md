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
| <a id="aud-val-011"></a>`AUD-VAL-011` | current formal source tree | `python3 scripts/check-audit-coverage.py` | passed with 1,351 proved theorem/lemma rows and 1,355 unique named axiom reports |
| <a id="aud-val-012"></a>`AUD-VAL-012` | formal working tree at the recorded run | `bash scripts/audit.sh` | passed; the later audit-document reorganization is documentation-only |
| <a id="aud-val-013"></a>`AUD-VAL-013` | current dossier tree at the recorded run | whole-repository proof-compendium rebuild | passed for 371 dossiers, one source-defined schematic, and 85 labeled generated inventory fallbacks |
| <a id="aud-val-014"></a>`AUD-VAL-014` | newly audited declaration set | named `#print axioms` reports | only `propext`, `Classical.choice`, and `Quot.sound` |
| <a id="aud-val-015"></a>`AUD-VAL-015` | current documentation descendant, 2026-11-27 | `git diff --check`; local Markdown path and anchor checks | passed; zero broken local Markdown paths and zero broken checked anchors after the audit split |
| <a id="aud-val-016"></a>`AUD-VAL-016` | current formal source tree with induced `SO(3)` spin covariance | `lake build ProjectKoios.QuantumMechanics.FiniteDimensional.SpinSO3Covariance`; `...FiniteDimensional`; `ProjectKoios.QuantumMechanics`; `ProjectKoios.Audit` | passed with 7,244, 7,258, 8,394, and 9,328 jobs respectively; affected module, aggregate, quantum-mechanics root, and audit target |
| <a id="aud-val-017"></a>`AUD-VAL-017` | `QM-SPIN-SO3-LEM-001` through `LEM-012` | named `#print axioms` reports | only `propext`, `Classical.choice`, and `Quot.sound` |
| <a id="aud-val-018"></a>`AUD-VAL-018` | current formal source tree with induced `SO(3)` spin covariance | `bash scripts/audit.sh` | passed; no repository-owned `sorry`, `admit`, or `axiom` marker, complete manifest/axiom-report coverage, and successful replay of `ProjectKoios/Audit.lean` |
| <a id="aud-val-019"></a>`AUD-VAL-019` | current induced-`SO(3)` documentation descendant | `git diff --check`; repository-local Markdown path and checked-anchor scan | passed; zero whitespace errors, zero broken local Markdown paths, and zero broken checked Markdown anchors |
| <a id="aud-val-020"></a>`AUD-VAL-020` | current finite global-collinearity source tree | `lake build ProjectKoios.QuantumMechanics.FiniteDimensional.SpinGlobalCollinearity`; `...FiniteDimensional` | passed with 7,246 and 7,260 jobs; affected module and finite-dimensional aggregate |
| <a id="aud-val-021"></a>`AUD-VAL-021` | current representative-safe continuum spin-density source tree | `lake build ProjectKoios.QuantumMechanics.SpinDensity.Continuum`; `...SpinDensity`; `ProjectKoios.QuantumMechanics`; `ProjectKoios.Audit` | passed with 7,248, 7,250, 8,400, and 9,332 jobs; affected module, narrow root, quantum-mechanics root, and audit target |
| <a id="aud-val-022"></a>`AUD-VAL-022` | `QM-SPIN-GLOBAL-COLLINEAR-LEM-001` through `LEM-009` and `QM-SPIN-DENSITY-CONTINUUM-LEM-001` through `LEM-025` | named `#print axioms` reports | only `propext`, `Classical.choice`, and `Quot.sound` |
| <a id="aud-val-023"></a>`AUD-VAL-023` | current finite/global and continuum spin-density source tree | `bash scripts/audit.sh` | passed; no repository-owned `sorry`, `admit`, or `axiom` marker, complete manifest/axiom-report coverage, and successful replay of `ProjectKoios/Audit.lean` |
| <a id="aud-val-024"></a>`AUD-VAL-024` | current finite/global and continuum spin-density documentation descendant | `git diff --check`; repository-local Markdown path and checked-anchor scan | passed; zero whitespace errors, zero broken local Markdown paths, and zero broken checked Markdown anchors |
| <a id="aud-val-025"></a>`AUD-VAL-025` | current continuum spinor-to-scalar Kohn--Sham binding tree | `lake build ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumSpinDensity`; `ProjectKoios.DensityFunctionalTheory`; `ProjectKoios.Audit` | passed with 7,554, 7,566, and 9,334 jobs; affected module, density-functional root, and audit target |
| <a id="aud-val-026"></a>`AUD-VAL-026` | `DFT-KS-SPIN-CONTINUUM-LEM-001` through `LEM-006` | named `#print axioms` reports | only `propext`, `Classical.choice`, and `Quot.sound` |
| <a id="aud-val-027"></a>`AUD-VAL-027` | exact current continuum spin-density and Kohn--Sham binding tree | repository-wide `lake build` | passed with 9,365 jobs; exact full-tree build required because the density-functional namespace root changed |
| <a id="aud-val-028"></a>`AUD-VAL-028` | exact current continuum spin-density and Kohn--Sham binding tree | `bash scripts/audit.sh` | passed; no repository-owned `sorry`, `admit`, or `axiom` marker, complete manifest/axiom-report coverage, and successful replay of `ProjectKoios/Audit.lean` |
| <a id="aud-val-029"></a>`AUD-VAL-029` | current continuum spin-density and Kohn--Sham documentation descendant | `git diff --check`; repository-local Markdown path and checked-anchor scan | passed; zero whitespace errors, zero broken local Markdown paths, and zero broken checked Markdown anchors |
| <a id="aud-val-030"></a>`AUD-VAL-030` | current proof-document and spin-density schematic tree | whole-repository proof-compendium rebuild; direct Mermaid rendering of the four new source-defined schematics | passed for 371 dossiers, one dossier-owning source-defined schematic, 85 generated inventory fallbacks, and all four new source-defined Mermaid blocks; output remained under `/tmp` |
| <a id="aud-val-031"></a>`AUD-VAL-031` | current finite/continuum spin-density separation tree | `lake build ProjectKoios.QuantumMechanics.FiniteDimensional.SpinorDensityMatrix`; `...FiniteDimensional`; `...SpinDensity.Continuum`; `...KohnSham.ContinuumSpinDensity`; `ProjectKoios.Audit` | passed with 5,501, 7,322, 7,310, 7,556, and 9,336 jobs; decoupled finite pointwise module, finite aggregate, continuum lift, DFT binding, and audit target |
| <a id="aud-val-032"></a>`AUD-VAL-032` | `QM-SPIN-DENSITY-FINITE-LEM-001` through `LEM-006`, `QM-SPIN-DENSITY-CONTINUUM-LEM-026` through `LEM-029`, and `DFT-KS-SPIN-CONTINUUM-LEM-007` through `LEM-010` | named `#print axioms` reports | only `propext`, `Classical.choice`, and `Quot.sound` |
| <a id="aud-val-033"></a>`AUD-VAL-033` | exact current finite/continuum spin-density separation tree | repository-wide `lake build` | passed with 9,367 jobs; exact full-tree build required because the finite-dimensional namespace root changed |
| <a id="aud-val-034"></a>`AUD-VAL-034` | exact current finite/continuum spin-density separation tree | `bash scripts/audit.sh` | passed; no repository-owned `sorry`, `admit`, or `axiom` marker, complete manifest/axiom-report coverage, and successful replay of `ProjectKoios/Audit.lean` |
| <a id="aud-val-035"></a>`AUD-VAL-035` | current finite/continuum separation documentation and schematic descendant | `git diff --check`; repository-local Markdown path and checked-anchor scan; direct Mermaid rendering | passed with zero whitespace errors, zero broken local Markdown paths, zero broken checked anchors, all five current spin-density schematics rendered under `/tmp`, and all three Mermaid blocks in `docs/roadmap.md` and `docs/module-layout.md` rendered under `/tmp` |
| <a id="aud-val-036"></a>`AUD-VAL-036` | current finite and representative-safe continuum density-stability descendant | `lake build ProjectKoios.QuantumMechanics.FiniteDimensional.SpinorDensityMatrix ProjectKoios.QuantumMechanics.SpinDensity.Continuum ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumSpinDensity`; `lake build ProjectKoios.Audit` | passed with 7,556 and 9,336 jobs; affected finite algebra, continuum Hölder stability, bounded DFT consumer, and audit target only |
| <a id="aud-val-037"></a>`AUD-VAL-037` | `QM-SPIN-DENSITY-FINITE-LEM-007` and `QM-SPIN-DENSITY-CONTINUUM-LEM-030` through `LEM-035` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,358 proved theorem/lemma rows and 1,362 unique named reports |
| <a id="aud-val-038"></a>`AUD-VAL-038` | current finite and continuum density-stability descendant | `bash scripts/audit.sh`; `git diff --check` | passed; no repository-owned `sorry`, `admit`, or `axiom` marker, complete manifest/axiom-report coverage, successful audit replay, and zero whitespace errors |
| <a id="aud-val-039"></a>`AUD-VAL-039` | current full-matrix and fixed-occupation density-error/convergence descendant | `lake build ProjectKoios.QuantumMechanics.SpinDensity.Continuum ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumSpinDensity`; `lake build ProjectKoios.QuantumMechanics.SpinDensity.Continuum ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumSpinDensity ProjectKoios.Audit` | passed with 7,556 and 9,336 jobs; affected continuum module, bounded DFT consumer, and audit target only |
| <a id="aud-val-040"></a>`AUD-VAL-040` | `QM-SPIN-DENSITY-CONTINUUM-LEM-036` through `LEM-049` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,372 proved theorem/lemma rows and 1,376 unique named reports |
| <a id="aud-val-041"></a>`AUD-VAL-041` | current full-matrix and fixed-occupation density-error/convergence descendant | `bash scripts/audit.sh`; `git diff --check` | passed; no repository-owned `sorry`, `admit`, or `axiom` marker, complete manifest/axiom-report coverage, successful audit replay, and zero whitespace errors |
| <a id="aud-val-042"></a>`AUD-VAL-042` | current explicit continuum-spinor finite-basis reconstruction tree | `lake build ProjectKoios.QuantumMechanics.SpinDensity.FiniteBasis ProjectKoios.QuantumMechanics.SpinDensity ProjectKoios.QuantumMechanics ProjectKoios.Audit` | passed with 9,358 jobs; new module, changed narrow root, quantum-mechanics aggregate, and audit target |
| <a id="aud-val-043"></a>`AUD-VAL-043` | `QM-SPIN-DENSITY-BASIS-LEM-001` through `LEM-005` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,377 proved theorem/lemma rows and 1,381 unique named reports |
| <a id="aud-val-044"></a>`AUD-VAL-044` | exact current explicit continuum-spinor finite-basis reconstruction tree | repository-wide `lake build` | passed with 9,369 jobs; exact full-tree build required because the `SpinDensity` namespace root changed |
| <a id="aud-val-045"></a>`AUD-VAL-045` | current explicit continuum-spinor finite-basis reconstruction tree and documentation descendant | `bash scripts/audit.sh`; `git diff --check`; repository-owned Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/axiom-report coverage, successful audit replay, zero whitespace errors, and matching 178/178 Lean support-file inventory |
| <a id="aud-val-046"></a>`AUD-VAL-046` | current continuum-spinor projection/completeness-contract descendant | `lake build ProjectKoios.QuantumMechanics.SpinDensity.FiniteBasis ProjectKoios.QuantumMechanics.SpinDensity ProjectKoios.QuantumMechanics ProjectKoios.Audit` | passed with 9,358 jobs; affected finite-basis module, bounded consumers, and audit target; namespace-root and dependency identity unchanged from `AUD-VAL-044` |
| <a id="aud-val-047"></a>`AUD-VAL-047` | `QM-SPIN-DENSITY-BASIS-LEM-006` through `LEM-009` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,381 proved theorem/lemma rows and 1,385 unique named reports |
| <a id="aud-val-048"></a>`AUD-VAL-048` | current continuum-spinor projection/completeness-contract descendant | `bash scripts/audit.sh`; `git diff --check` | passed; no repository-owned admission marker, complete manifest/axiom-report coverage, successful audit replay, and zero whitespace errors |
| <a id="aud-val-049"></a>`AUD-VAL-049` | current countable-Hilbert-basis spin-density reconstruction tree | `lake build ProjectKoios.QuantumMechanics.SpinDensity.HilbertBasis ProjectKoios.QuantumMechanics.SpinDensity ProjectKoios.QuantumMechanics ProjectKoios.Audit` | passed with 9,360 jobs; new Hilbert-basis adapter, changed narrow root, bounded aggregate consumers, and audit target |
| <a id="aud-val-050"></a>`AUD-VAL-050` | `QM-SPIN-DENSITY-HILBERT-LEM-001` through `LEM-007` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,388 proved theorem/lemma rows and 1,392 unique named reports |
| <a id="aud-val-051"></a>`AUD-VAL-051` | countable-Hilbert-basis spin-density reconstruction formal tree before a documentation-only wording correction | repository-wide `lake build` | passed with 9,371 jobs; full-tree build required because the `SpinDensity` namespace root changed; the subsequent wording-only descendant did not alter declarations or imports |
| <a id="aud-val-052"></a>`AUD-VAL-052` | current countable-Hilbert-basis spin-density reconstruction documentation descendant | `bash scripts/audit.sh`; `git diff --check`; repository-owned Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/axiom-report coverage, successful audit replay, zero whitespace errors, and matching 179/179 Lean support-file inventory |
| <a id="aud-val-053"></a>`AUD-VAL-053` | current one-dimensional oscillator/Hermite Hilbert-basis and spin-density binding tree | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.HilbertBasis ProjectKoios.QuantumMechanics.SpinDensity.OscillatorBasis ProjectKoios.QuantumMechanics.HarmonicOscillator ProjectKoios.QuantumMechanics.SpinDensity ProjectKoios.QuantumMechanics ProjectKoios.Audit` | passed with 9,364 jobs; two new modules, changed harmonic-oscillator and spin-density roots, bounded aggregate consumers, and audit target |
| <a id="aud-val-054"></a>`AUD-VAL-054` | `QHO-HILBERT-LEM-001` through `LEM-003` and `QM-SPIN-DENSITY-OSCILLATOR-LEM-001` through `LEM-004` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,395 proved theorem/lemma rows and 1,399 unique named reports |
| <a id="aud-val-055"></a>`AUD-VAL-055` | exact current one-dimensional oscillator/Hermite Hilbert-basis and spin-density binding tree | repository-wide `lake build` | passed with 9,375 jobs; exact full-tree build required because the harmonic-oscillator and spin-density namespace roots changed |
| <a id="aud-val-056"></a>`AUD-VAL-056` | current one-dimensional oscillator/Hermite Hilbert-basis and spin-density binding documentation descendant | `bash scripts/audit.sh`; `git diff --check`; repository-owned Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/axiom-report coverage, successful audit replay, zero whitespace errors, and matching 181/181 Lean support-file inventory |
| <a id="aud-val-057"></a>`AUD-VAL-057` | current finite-basis scalar Kohn--Sham spinor-density convergence tree | `lake build ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisSpinDensity ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | passed with 9,348 jobs; new DFT convergence module, changed density-functional root, and audit target |
| <a id="aud-val-058"></a>`AUD-VAL-058` | `DFT-KS-SPIN-BASIS-LEM-001` through `LEM-010` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,405 proved theorem/lemma rows and 1,409 unique named reports |
| <a id="aud-val-059"></a>`AUD-VAL-059` | exact current finite-basis scalar Kohn--Sham spinor-density convergence tree | repository-wide `lake build` | passed with 9,377 jobs; exact full-tree build required because the density-functional namespace root changed |
| <a id="aud-val-060"></a>`AUD-VAL-060` | current finite-basis scalar Kohn--Sham spinor-density convergence tree and documentation descendant | `bash scripts/audit.sh`; `git diff --check`; repository-owned Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/axiom-report coverage, successful audit replay, zero whitespace errors, and matching 182/182 Lean support-file inventory |
| <a id="aud-val-061"></a>`AUD-VAL-061` | uncommitted quantitative Hilbert truncation descendant based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.SpinDensity.HilbertBasis ProjectKoios.QuantumMechanics.SpinDensity.OscillatorBasis ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisSpinDensity ProjectKoios.QuantumMechanics ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | passed with 9,368 jobs; two changed mathematical modules, bounded consumers, and audit target; targeted evidence only, reusing `AUD-VAL-059` full-build evidence with unchanged roots, toolchain, and dependencies |
| <a id="aud-val-062"></a>`AUD-VAL-062` | `QM-SPIN-DENSITY-HILBERT-LEM-008` through `LEM-015` and `DFT-KS-SPIN-BASIS-LEM-011` through `LEM-016` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | only `propext`, `Classical.choice`, and `Quot.sound` in all 14 new reports; coverage passed with 1,419 proved rows and 1,423 unique named reports |
| <a id="aud-val-063"></a>`AUD-VAL-063` | same quantitative truncation source tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, successful audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 182/182 Lean support files |
| <a id="aud-val-064"></a>`AUD-VAL-064` | quantitative Hilbert and DFT module schematics and changed documentation | direct `mmdc` rendering using installed Chrome; local Markdown path and explicit audit-anchor scan | both new source-defined schematics rendered, all checked local paths and explicit audit anchors passed; generated `.mmd`, `.svg`, configuration, and logs remain under `/tmp` |
| <a id="aud-val-065"></a>`AUD-VAL-065` | uncommitted weighted coefficient-moment rate descendant based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.SpinDensity.HilbertBasis ProjectKoios.QuantumMechanics.SpinDensity.OscillatorBasis ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisSpinDensity ProjectKoios.QuantumMechanics ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | passed with 9,368 jobs; changed mathematical modules, bounded consumers, and audit target only; roots, toolchain, and dependency identity unchanged, reusing `AUD-VAL-059` full-build evidence rather than claiming a new full build |
| <a id="aud-val-066"></a>`AUD-VAL-066` | `QM-SPIN-DENSITY-HILBERT-LEM-016` through `LEM-022` and `DFT-KS-SPIN-BASIS-LEM-017/018` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | all 9 new reports use only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,428 proved rows and 1,432 unique named reports |
| <a id="aud-val-067"></a>`AUD-VAL-067` | same weighted moment-rate source tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 182/182 Lean support files |
| <a id="aud-val-068"></a>`AUD-VAL-068` | weighted moment-rate module schematics and changed documentation | direct `mmdc` rendering with installed Chrome; local Markdown path and explicit audit-anchor scan | both updated source-defined schematics rendered; checked local paths and explicit audit anchors passed; generated diagrams/configuration/logs remain under `/tmp` |
| <a id="aud-val-069"></a>`AUD-VAL-069` | uncommitted oscillator selected-closure-domain rate descendant based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.HilbertBasis ProjectKoios.QuantumMechanics.SpinDensity.OscillatorBasis ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisSpinDensity ProjectKoios.QuantumMechanics.HarmonicOscillator ProjectKoios.QuantumMechanics.SpinDensity ProjectKoios.QuantumMechanics ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | passed with 9,368 jobs; three changed mathematical modules, bounded aggregate consumers, and audit target only; roots/toolchain/dependency identity unchanged, reusing `AUD-VAL-059` full-build evidence |
| <a id="aud-val-070"></a>`AUD-VAL-070` | `QHO-HILBERT-LEM-004` through `LEM-012`, `QM-SPIN-DENSITY-OSCILLATOR-LEM-005` through `LEM-008`, and `DFT-KS-SPIN-BASIS-LEM-019` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | all 14 new reports use only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,442 proved rows and 1,446 unique named reports |
| <a id="aud-val-071"></a>`AUD-VAL-071` | same oscillator closure-domain source tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 182/182 Lean support files |
| <a id="aud-val-072"></a>`AUD-VAL-072` | oscillator closure-domain module schematics and changed documentation | direct `mmdc` rendering with installed Chrome; local Markdown path and explicit audit-anchor scan | all three source-defined schematics rendered; checked local paths and explicit audit anchors passed; generated diagrams/configuration/logs remain under `/tmp` |
| <a id="aud-val-073"></a>`AUD-VAL-073` | uncommitted oscillator graph-norm/energy-expectation descendant based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.HilbertBasis ProjectKoios.QuantumMechanics.SpinDensity.OscillatorBasis ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisSpinDensity ProjectKoios.QuantumMechanics.HarmonicOscillator ProjectKoios.QuantumMechanics.SpinDensity ProjectKoios.QuantumMechanics ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | passed with 9,368 jobs after schematic-label fixes; two changed mathematical modules, bounded consumers, and audit target only; roots/toolchain/dependency identity unchanged, reusing `AUD-VAL-059` full-build evidence |
| <a id="aud-val-074"></a>`AUD-VAL-074` | `QHO-HILBERT-LEM-013` through `LEM-023` and `QM-SPIN-DENSITY-OSCILLATOR-LEM-009` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | all 12 new reports use only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,454 proved rows and 1,458 unique named reports |
| <a id="aud-val-075"></a>`AUD-VAL-075` | same oscillator graph/energy source tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 182/182 Lean support files |
| <a id="aud-val-076"></a>`AUD-VAL-076` | oscillator graph/energy source schematics and changed documentation | direct `mmdc` rendering with installed Chrome; local Markdown path and explicit audit-anchor scan | both updated source-defined schematics rendered after replacing a reserved Mermaid node identifier; checked local paths and explicit audit anchors passed; generated diagrams/configuration/logs remain under `/tmp` |
| <a id="aud-val-077"></a>`AUD-VAL-077` | uncommitted quantitative oscillator energy descendant based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.HilbertBasis ProjectKoios.QuantumMechanics.SpinDensity.OscillatorBasis ProjectKoios.DensityFunctionalTheory.KohnSham.FiniteBasisSpinDensity ProjectKoios.QuantumMechanics.HarmonicOscillator ProjectKoios.QuantumMechanics.SpinDensity ProjectKoios.QuantumMechanics ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | passed with 9,368 jobs; changed oscillator module, bounded consumers, and audit target only; namespace roots/toolchain/dependency identity unchanged, reusing `AUD-VAL-059` full-build evidence |
| <a id="aud-val-078"></a>`AUD-VAL-078` | `QHO-HILBERT-LEM-024` through `LEM-034` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | all 11 new reports use only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,465 proved rows and 1,469 unique named reports |
| <a id="aud-val-079"></a>`AUD-VAL-079` | same quantitative oscillator energy source tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 182/182 Lean support files |
| <a id="aud-val-080"></a>`AUD-VAL-080` | quantitative oscillator energy schematic and changed documentation | direct `mmdc` rendering with installed Chrome; local Markdown path and explicit audit-anchor scan | updated source-defined schematic rendered; checked local paths and explicit audit anchors passed; generated diagrams/configuration/logs remain under `/tmp` |
| <a id="aud-val-081"></a>`AUD-VAL-081` | uncommitted finite oscillator spectral-compression tree based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteSpectralCompression ProjectKoios.QuantumMechanics.HarmonicOscillator ProjectKoios.QuantumMechanics ProjectKoios.Audit` | passed with 9,368 jobs; new module, changed oscillator root, bounded quantum-mechanics consumer, and audit target |
| <a id="aud-val-082"></a>`AUD-VAL-082` | `QHO-FINITE-SPECTRAL-LEM-001` through `LEM-008` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | all 8 new reports use only `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,473 proved rows and 1,477 unique named reports |
| <a id="aud-val-083"></a>`AUD-VAL-083` | exact current finite oscillator spectral-compression formal source tree | repository-wide `lake build` | passed with 9,379 jobs; exact full-tree build required because the harmonic-oscillator namespace root changed; toolchain and dependency identity unchanged |
| <a id="aud-val-084"></a>`AUD-VAL-084` | same finite spectral-compression tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 183/183 Lean support files |
| <a id="aud-val-085"></a>`AUD-VAL-085` | finite spectral-compression source schematic and updated module-layout diagram/documentation | direct `mmdc` rendering with installed Chrome; local Markdown path and explicit audit-anchor scan | both schematic blocks rendered; checked local paths and explicit audit anchors passed; generated diagrams/configuration/logs remain under `/tmp` |
| <a id="aud-val-086"></a>`AUD-VAL-086` | uncommitted finite oscillator residual tree based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteSpectralResidual ProjectKoios.QuantumMechanics.HarmonicOscillator ProjectKoios.QuantumMechanics ProjectKoios.Audit` | passed with 9,370 jobs; new module, changed oscillator root, bounded quantum-mechanics consumer, and audit target |
| <a id="aud-val-087"></a>`AUD-VAL-087` | `QHO-FINITE-RESIDUAL-LEM-001` through `LEM-011` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | all 11 new reports use exactly `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,484 proved rows and 1,488 unique named reports |
| <a id="aud-val-088"></a>`AUD-VAL-088` | exact current finite oscillator residual formal source tree | repository-wide `lake build` | passed with 9,381 jobs; exact full-tree build required because the harmonic-oscillator namespace root changed; toolchain and dependency identity unchanged |
| <a id="aud-val-089"></a>`AUD-VAL-089` | same finite oscillator residual tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 184 Lean support files / 184 checklist entries |
| <a id="aud-val-090"></a>`AUD-VAL-090` | finite residual source schematic and updated module-layout diagram/documentation | direct `mmdc` rendering with installed Chrome; local Markdown path and explicit audit-anchor scan | both schematic blocks rendered; checked local paths and explicit audit anchors passed; generated diagrams/configuration/logs remain under `/tmp` |
| <a id="aud-val-091"></a>`AUD-VAL-091` | uncommitted exact-data residual-certificate tree based at `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`; source hashes below | `lake build ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteSpectralResidual ProjectKoios.QuantumMechanics.HarmonicOscillator.FiniteResidualCertificate ProjectKoios.QuantumMechanics.HarmonicOscillator ProjectKoios.QuantumMechanics ProjectKoios.Audit` | passed with 9,372 jobs; both changed mathematical modules, oscillator root, bounded quantum-mechanics consumer, and audit target |
| <a id="aud-val-092"></a>`AUD-VAL-092` | `QHO-FINITE-RESIDUAL-LEM-012` and `QHO-RESIDUAL-CERT-LEM-001` through `LEM-017` | named `#print axioms` reports; `python3 scripts/check-audit-coverage.py` | all 18 new reports use exactly `propext`, `Classical.choice`, and `Quot.sound`; coverage passed with 1,502 proved rows and 1,506 unique named reports; no native-computation proof primitive added |
| <a id="aud-val-093"></a>`AUD-VAL-093` | exact current residual-certificate formal source tree | repository-wide `lake build` | passed with 9,383 jobs; full-tree gate required by the changed harmonic-oscillator namespace root; toolchain and dependency identity unchanged |
| <a id="aud-val-094"></a>`AUD-VAL-094` | same exact-data residual-certificate tree | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `git diff --check`; Lean file/checklist count | passed; no repository-owned admission marker, complete manifest/report coverage, audit replay, 10 immutable dependency revisions, zero whitespace errors, and matching 185 Lean support files / 185 checklist entries |
| <a id="aud-val-095"></a>`AUD-VAL-095` | exact-data checker fixtures, both changed source schematics, module-layout diagram, and documentation | six exact `#eval` checker cases and computed fixture mass/budget; fixture proofs via `decide +kernel`; direct `mmdc` rendering; local Markdown path/audit-anchor scan | execution returned mass/budget `(6, 99/2)` and `[true, false, false, false, false, true]` for the six cases; acceptance/rejection proofs are kernel-checked, not inferred from execution; all three schematic blocks rendered and checked paths/anchors passed; artifacts remain under `/tmp` |
| <a id="aud-val-096"></a>`AUD-VAL-096` | pinned oscillator reuse audit; Mathlib `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`, Physlib package `101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd` | source/declaration inspection plus `lake build PhyslibAlpha.QuantumMechanics.HarmonicOscillator.Vacuum PhyslibAlpha.QuantumMechanics.QuantumHarmonicOscillator` | bounded dependency API build passed with 6,723 jobs; public Schwartz ladder/vacuum APIs verified; sequence-module compilation does not imply public exports or continuum identification; no owner-source mutation, pin change, repository-wide build, or API adoption |
| <a id="aud-val-097"></a>`AUD-VAL-097` | temporary `QhoReuseProbe.lean` and `QhoAlphaExportsProbe.lean`, reproduced and hashed in the oscillator reuse map | `lake env lean /tmp/QhoReuseProbe.lean`; `lake env lean /tmp/QhoAlphaExportsProbe.lean`; three named axiom reports | canonical closure identity and eigenstate basis checks passed; legacy Hermite coefficient-map candidate kernel-checked; all three reports use only `propext`, `Classical.choice`, and `Quot.sound`; export inspection confirms examined raw-sequence names are private; no repository declaration or manifest row promoted |
| <a id="aud-val-098"></a>`AUD-VAL-098` | documentation-only oscillator reuse map and linked records | local Markdown path/audit-anchor checks; embedded probe/hash comparison; `python3 scripts/check-pins.py`; `python3 scripts/check-audit-coverage.py`; `git diff --check`; 14 oscillator/root/audit source-baseline comparisons | passed; pins unchanged, 1,502 proved rows / 1,506 reports unchanged, all 14 scoped Lean sources byte-identical; reuses full-build evidence `AUD-VAL-093` rather than implying a new full build; no publication/scientific authority follows |
| <a id="aud-val-099"></a>`AUD-VAL-099` | documentation-only wave for `SpinDensity/FiniteBasis`, `FiniteDimensional/SpinorDensityMatrix`, `FiniteDimensional/SpinSO3Covariance`, and `KohnSham/ContinuumSpinDensity`; source hashes below | module/declaration review; comparison against pre-edit copies after stripping nested/line comments and normalizing whitespace; attached declaration-ID comparison | non-comment Lean code unchanged in all four modules; all 52 public declaration IDs preserved; required overview/key-results/contents/references sections and lettered section structure checked; no namespace/import/proposition/proof migration |
| <a id="aud-val-100"></a>`AUD-VAL-100` | the four source-defined proof schematics | direct `mmdc` rendering with installed Chrome; mathematical dependency/assumption rereview | all four compact, portrait-oriented diagrams rendered; fixed real weights, conditional componentwise convergence, supplied projection completeness, nonnegative-weight positivity, component-norm-square normalization, and occupation-sum hypotheses remain explicit; no generated diagrams tracked |
| <a id="aud-val-101"></a>`AUD-VAL-101` | same documentation wave, based at uncommitted HEAD `bdbb0b3d7843a7080f84df4735b30887aba5e6a4` | `lake build ProjectKoios.QuantumMechanics.SpinDensity.FiniteBasis ProjectKoios.QuantumMechanics.FiniteDimensional.SpinorDensityMatrix ProjectKoios.QuantumMechanics.FiniteDimensional.SpinSO3Covariance ProjectKoios.DensityFunctionalTheory.KohnSham.ContinuumSpinDensity ProjectKoios.QuantumMechanics ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | affected-target build passed with 9,374 jobs; changed modules, bounded quantum-mechanics/DFT consumers, and audit target; not a new repository-wide build |
| <a id="aud-val-102"></a>`AUD-VAL-102` | same documentation wave and task records | `bash scripts/audit.sh`; pin and coverage checks; 38 existing named lemma reports; local Markdown path/audit-anchor, whitespace, and checklist checks | passed; 1,502 proved rows / 1,506 reports unchanged; all 38 scoped public lemma reports use exactly `propext`, `Classical.choice`, and `Quot.sound`; 10 immutable revisions unchanged; task progress 4/185, not whole-repository documentation completion; temporary artifacts remain under `/tmp` |
| <a id="aud-val-103"></a>`AUD-VAL-103` | aggregate uncommitted milestone based at HEAD `bdbb0b3d7843a7080f84df4735b30887aba5e6a4`: 20 modified tracked paths and 15 untracked files | all-candidate scope/diff, declaration/API, import, provenance, documentation, and assumption review; comparison with pre-review copies | 271 new manifest declarations (217 proved lemmas, 54 other declarations) match the public source surface; existing manifest identities/kinds/statuses preserved; 184 local modules have no missing imports or cycles; documentation-only corrections in nine source modules preserve non-comment code in all 19 candidate Lean files |
| <a id="aud-val-104"></a>`AUD-VAL-104` | same aggregate milestone; all 19 candidate Lean source hashes below | `lake build ProjectKoios.QuantumMechanics ProjectKoios.DensityFunctionalTheory ProjectKoios.Audit` | affected-target build passed with 9,374 jobs; changed modules, bounded quantum-mechanics/DFT consumers, and audit target; reuses repository-wide evidence `AUD-VAL-093` with unchanged toolchain/dependencies rather than claiming another full build or immutable release tree |
| <a id="aud-val-105"></a>`AUD-VAL-105` | same aggregate milestone | `bash scripts/audit.sh`; `python3 scripts/check-pins.py`; `python3 scripts/check-audit-coverage.py`; actual named-report inspection | passed; no repository-owned admission markers; 1,502 proved rows and 1,506 unique replayed named reports; all 217 new lemma reports use exactly `propext`, `Classical.choice`, and `Quot.sound`; 10 immutable revisions unchanged, with matching clean tracked-source/detached checkouts (untracked/ignored build state excluded) |
| <a id="aud-val-106"></a>`AUD-VAL-106` | same 35-path milestone and bounded documentation descendants | 13 new substantive-module schematics and 3 documentation diagrams rendered with `mmdc`; 80 local Markdown path/anchor checks plus source-hash, whitespace, checklist, credential-pattern, generated-state, and local Git-scope checks | passed; all 35 paths are expected text sources/documents, with no symlinks, binary/generated candidate files, or credential-pattern matches; 185 Lean support files/checklist entries and 4 completed task entries retained; nothing staged, committed, fetched, or pushed; cached upstream comparison has 13 existing outgoing commits, not a fresh remote or server-policy attestation |

Bounded source identity for `AUD-VAL-061` through `AUD-VAL-064` (SHA-256):

- `ProjectKoios/QuantumMechanics/SpinDensity/HilbertBasis.lean`:
  `0bd749953e29e483f9bcc2fd5b45c44056b3a13c7a055d9004d601e07d82a008`;
- `ProjectKoios/DensityFunctionalTheory/KohnSham/FiniteBasisSpinDensity.lean`:
  `0fff4806ef20e27f52a3e0fe22829fc5a31fd7913d433580c12746330b495861`;
- `ProjectKoios/Audit.lean`:
  `c78fc3fca8b1e3867084172ee6aa1fb6ec07ff63f14c143192da754ab9d7e840`.

The `AUD-VAL-061` through `AUD-VAL-064` runs retain the `lean-toolchain` and `lake-manifest.json`
hashes recorded above. They are not a new repository-wide build, immutable release attestation,
computed tail certificate, convergence-rate bound, energy-convergence result, or publication/scientific
validation.

Bounded source identity for `AUD-VAL-065` through `AUD-VAL-068` (SHA-256):

- `ProjectKoios/QuantumMechanics/SpinDensity/HilbertBasis.lean`:
  `876cdb9e13847fbd836ece097a2cc92d2fb56af3ee6911b15e72c2dfafed5be3`;
- `ProjectKoios/DensityFunctionalTheory/KohnSham/FiniteBasisSpinDensity.lean`:
  `d4e9098196e18e125e7f6b9d8828d29c0853b4abae84cdbe50fa67d8f40399a9`;
- `ProjectKoios/Audit.lean`:
  `02414f3d49659be5b4f09da5cab67d3cba7b72e2abb88effac0248684ece81b0`.

These moment-rate runs retain the same toolchain and manifest hashes. They supersede the earlier
bounded module validation only for this descendant's changed surface. They establish conditional
cutoff rates under an explicit summable global moment contract, not a derived operator-domain
regularity condition, numerical moment/tail certificate, energy convergence, release attestation,
or publication/scientific validation. In particular, a total `tsum` upper bound without summability
is deliberately insufficient for the moment contract.

Bounded source identity for `AUD-VAL-069` through `AUD-VAL-072` (SHA-256):

- `ProjectKoios/QuantumMechanics/HarmonicOscillator/HilbertBasis.lean`:
  `1c4aa182ff34060806e25a6ac9a09ab11ad2a1c83e1a759895d5dbf2b6375f10`;
- `ProjectKoios/QuantumMechanics/SpinDensity/OscillatorBasis.lean`:
  `b524aaa545b977a21abbbc201db1feb5aba3f21b8438a012911f52e8419b02a8`;
- `ProjectKoios/DensityFunctionalTheory/KohnSham/FiniteBasisSpinDensity.lean`:
  `233ae5da002575a3a727feb8140581c62e9b7df357b4ba6c5b664ba6cfc824a2`;
- `ProjectKoios/Audit.lean`:
  `7122f9738fa1c051590ee988e2dfb01ab15c8ea7fe3dd16e376c6d30782a9e77`.

These domain-rate runs retain the same toolchain/manifest hashes and supersede earlier bounded
validation only for this changed descendant surface. The selected operator is exactly
`Q.hamiltonian.closure`, already packaged by `oneDimensionalQuantumSystem`. The `p=2` global moment
is now derived from actual closure-domain membership and `‖H̄ψ‖²`, not assumed as independent
regularity. This does not characterize the closure domain conversely, identify the chosen Cayley
spectral measure with the Hilbert eigenbasis, bound an energy expectation, prove energy convergence,
certify numerical Hamiltonian norms, or establish scientific/publication authority. The affected-target
run is not a new full repository build.

Bounded source identity for `AUD-VAL-073` through `AUD-VAL-076` (SHA-256):

- `ProjectKoios/QuantumMechanics/HarmonicOscillator/HilbertBasis.lean`:
  `896fd446c793293f5307760df6765f32df966a35f4f6c80b634beb4cadca091c`;
- `ProjectKoios/QuantumMechanics/SpinDensity/OscillatorBasis.lean`:
  `f99bfd019f422c3cc2f91e843cd84277158f1fb22ce0e404e0125cb372d6880f`;
- `ProjectKoios/Audit.lean`:
  `313acd15511caf00463261939a7bae9fd27022d82b52c4bbeb4ed5197b773f91`.

These graph/energy runs retain the same toolchain and manifest hashes and supersede earlier bounded
module validation only on this changed descendant surface. They now establish explicit sum
Hamiltonian graph-norm convergence and analytic oscillator energy-expectation convergence using
Physlib's existing `LinearPMap.expectedValue`. Quadratic-value convergence requires an actual
selected-closure-domain target; Rayleigh convergence additionally requires a nonzero target, and
normalized-state convergence to the target's unscaled energy value requires unit target norm.
Early partial sums may vanish, and unit normalization is proved only eventually for nonzero targets.
These results do not follow from density `L¹` convergence alone, identify a Kohn--Sham eigenbasis,
prove convergence of a Kohn--Sham total-energy functional, certify numerical energy data, or grant
publication/scientific authority. This is targeted descendant evidence, not a new full build.

Bounded source identity for `AUD-VAL-077` through `AUD-VAL-080` (SHA-256):

- `ProjectKoios/QuantumMechanics/HarmonicOscillator/HilbertBasis.lean`:
  `8d60f446ea6637e26472b258fcc9d760f9d0b118a8605ba0163ff9fe2c889cc2`;
- `ProjectKoios/Audit.lean`:
  `07bc9f14a94e7ad3318de322594530a86f3651a85cb60129a9a2721d26b086ab`.

These quantitative-energy runs retain the same toolchain and manifest hashes and supersede earlier
bounded module validation only for this changed descendant surface. The discarded first energy
moment is genuinely summable and equals the nonnegative raw quadratic-energy deficit; comparison
with the second energy moment gives `‖H̄ψ‖²/E_N`. The normalized absolute-error bound requires a
unit selected-closure-domain target and retained squared norm `r ≥ m > 0`, and includes the explicit
normalization contribution `‖H̄ψ‖ |1-r|`. Sufficient raw and normalized tolerance-cutoff conditions
are checked analytically. No normalized-energy monotonicity theorem, Kohn--Sham total-energy
convergence, numerical cutoff-selection routine, Hamiltonian-norm/energy certificate, or
scientific/publication authority follows. This remains targeted evidence, not a new full build.

Bounded changed-source identity for `AUD-VAL-081` through `AUD-VAL-085` (SHA-256):

- `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteSpectralCompression.lean`:
  `1ba20a912150d01b6f6376aa457ad0d0b0adb4e1995a5bc43f2cbefa341648ea`;
- `ProjectKoios/QuantumMechanics/HarmonicOscillator.lean`:
  `a936f7f9a8ba351189dbde7f97bc250f6ee118748a5b116332ce416b9f155db6`;
- `ProjectKoios/Audit.lean`:
  `369cceb328106d61c523e4864b31dc15c3f4c9ece81927d3e8a56821c0130774`.

These runs retain the same toolchain and manifest hashes. `AUD-VAL-083` supplies a new repository-wide
build for this formal source tree, while `AUD-VAL-081` separately records affected-target evidence.
The new embedding uses Euclidean complex coefficients and has an explicit lift into exactly
`Q.hamiltonian.closure.domain`; intertwining, adjoint compression, quadratic-energy equality, and
the `K+1`-term partial-sum crosswalk reuse the existing real diagonal Hamiltonian at scale `ℏω₀`.
They do not treat the whole continuum operator as bounded, infer a full-space resolution of identity,
identify a finite ladder-product reconstruction with the direct diagonal Hamiltonian, authenticate
sampled grids or floating-point matrices, verify numerical eigensolvers, or establish publication
or scientific-validation authority. The tree remains uncommitted, not an immutable release snapshot.

Bounded changed-source identity for `AUD-VAL-086` through `AUD-VAL-090` (SHA-256):

- `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteSpectralResidual.lean`:
  `57162443786a204b76c2a841973e45d1955fc575b3b273b29d024026c0109493`;
- `ProjectKoios/QuantumMechanics/HarmonicOscillator.lean`:
  `18def4d99e4e09ff5b14c326763a122512ae4d961bd8eb4016a59c5c4a18ad37`;
- `ProjectKoios/Audit.lean`:
  `22e8e9922add265b1bacb4258d3298f893cd72dc5f0664bef20be729ee88a036`.

These runs retain the same toolchain and manifest hashes. `AUD-VAL-088` supplies a new repository-wide
build for this formal source tree, separately from affected-target evidence `AUD-VAL-086`.
The exact finite residual transports through the same selected-closure-domain embedding with no
norm loss. Retained-energy proximity requires unit coefficient norm; use of a tolerance requires an
independently proved residual upper bound. The off-eigenstate estimate requires a positive gap from
the trial energy to every other retained energy and is homogeneous, without a normalization premise.
It controls the component orthogonal to the selected eigenstate span, not distance to a phase-fixed
vector. No omitted continuum tail, sampled/grid identification, residual-data checker, numerical
solver validation, or publication/scientific authority is supplied. Source-neutral finite diagonal
norm comparison and finite minimum selection do not identify the continuum spectral measure. The
tree remains uncommitted; this is not an immutable release snapshot.

Bounded changed-source identity for `AUD-VAL-091` through `AUD-VAL-095` (SHA-256):

- `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteResidualCertificate.lean`:
  `ea493dc852497986f8de684b87fc82c5ca673eede130734f8b3ca4062e6505d4`;
- `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteSpectralResidual.lean`:
  `3d6fc2dd4def65efc558d4ffe4249c7e4c6c8a9fbd07bb1d598f9ea5fc2b75e8`;
- `ProjectKoios/QuantumMechanics/HarmonicOscillator.lean`:
  `01a05c2678624d12e2da566892b12c0ef64d97030eeebeece8f4085a86bc773e`;
- `ProjectKoios/Audit.lean`:
  `d3534048cee68008b3275c8ecfaddedeb2d199e78206d28c86d182bb57abaa5b`.

These runs retain the same toolchain and manifest hashes. `AUD-VAL-093` is the new repository-wide
build for this formal source tree; `AUD-VAL-091` separately records affected-target evidence.
The checker consumes exact rational components and computes mass `S` and a conservative endpoint
squared-residual budget, instead of trusting a claimed normalization or solver-reported norm.
Acceptance plus separately proved containment of actual `ℏω₀` in the proposed interval yields a
unit continuum image after Mathlib normalization, continuum residual at most `sqrt (B/S)`, and some
retained exact energy within that tolerance of the trial energy. Acceptance alone does not prove
the physical-scale enclosure or model compatibility. The rich fixture has mass `6` and endpoint
budget `99/2`; a second accepted fixture covers `K=0`, non-unit complex mass, zero budget, and a
degenerate interval. Four rejected variants cover zero mass, underbudget, reversed endpoints, and
negative budget. Their proofs use `decide +kernel`, while separate executable checks merely confirm
runtime behavior on those exact fixtures. No physical oscillator is instantiated by the fixtures.
No runtime parser, float/solver-data binding, scale-enclosure producer, gap checker, general
direct-matrix schema implementation, omitted continuum-tail estimate, solver verification,
publication authority, or scientific validation follows. The tree remains uncommitted and is not an
immutable release snapshot.

`AUD-VAL-096` through `AUD-VAL-098` record a subsequent documentation-only upstream-reuse audit;
see [the oscillator map](../api-maps/harmonic-oscillator.md) for exact source locators, scope,
reproducible probes, and SHA-256 values. It preserves the preceding formal source tree, namespace
roots, toolchain/manifest identity, declaration IDs, and theorem status. It does not replace
Physlib's domain handling with another framework: the continuum Hamiltonian/eigenstates already
come from Physlib, the selected spectral/evolution machinery comes from Alpha, and public Alpha
Schwartz ladder/vacuum APIs are checked candidates for future work. The real legacy Hermite
polynomial overlap is recorded with a checked temporary coefficient-map identity, not migrated or
promoted. The inspected raw-sequence names' private export status is a reuse limitation, not a
reason to reference private implementation names. The dependency API build is separate from the
prior repository-wide Formal build, and no immutable release or new scientific claim is created.

Bounded changed-source identity for `AUD-VAL-099` through `AUD-VAL-102` (SHA-256):

- `ProjectKoios/QuantumMechanics/SpinDensity/FiniteBasis.lean`:
  `8e94e574704d8b1dcf15f44f6f3c997137a410c4071d7f18a5068ad5eaaaa150`;
- `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinorDensityMatrix.lean`:
  `90a5f88d38e8c53d42d1b0e0519faf03af46c257bb5d90e1aa1fa1a171bac6c7`;
- `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinSO3Covariance.lean`:
  `523223c3d88cc680994c4ccd8623641be0eb39afa84c555cefd274e6e80252bf`;
- `ProjectKoios/DensityFunctionalTheory/KohnSham/ContinuumSpinDensity.lean`:
  `f1e551c2a15560653cbf2bedcc76247c4996f63eb99eed7566b946dc08a6240f`.

The wave retains the same `lean-toolchain` SHA-256
`582a63f8f9c5128067b688778c1051cf1464c3ca9d57b9325025c051c29b774a` and `lake-manifest.json` SHA-256
`4854285512498c87dc59f0e4d675212f0afcb7b8b65eafc91fbf47a5bbd667c5`.
Module/declaration documentation was completed without changing mathematical code, imports,
namespaces, stable IDs, theorem status, or assumptions. The four module checklist entries were
closed only after declaration review, schematic rendering, bounded compilation, and audit checks.
The diagrams distinguish supplied projection completeness from idempotence, positivity from
Hermiticity under real weights, and component-norm-square normalization from an unqualified
function-space norm. Scalar density integrals depend on orbital norm-square integral identities,
not on the matrix trace bridge alone. No normalization, particle number, completeness, or scientific
applicability is newly inferred. The legacy Hermite reuse refactor and unrelated documentation
migration remain deferred. Existing full-build evidence `AUD-VAL-093` is reused with this targeted,
documentation-only descendant evidence; this is not a new full build or an immutable release tree.

Bounded aggregate-review source identity for `AUD-VAL-103` through `AUD-VAL-106` (SHA-256):

| Candidate Lean source | SHA-256 |
|---|---|
| `ProjectKoios/Audit.lean` | `d3534048cee68008b3275c8ecfaddedeb2d199e78206d28c86d182bb57abaa5b` |
| `ProjectKoios/DensityFunctionalTheory.lean` | `40d1204027523c74bbf4071c48e770b5ffcf9330a150edff55ddbc105ab8f63f` |
| `ProjectKoios/QuantumMechanics.lean` | `b4c40267a4c69c39b19fc4fce27e91a0c4f714a116afc90add70574d2aef8838` |
| `ProjectKoios/QuantumMechanics/FiniteDimensional.lean` | `b9e535ca6c50049c077120ddd66ffb2d3489f038edbaae8f485c0816c0b83795` |
| `ProjectKoios/QuantumMechanics/HarmonicOscillator.lean` | `01a05c2678624d12e2da566892b12c0ef64d97030eeebeece8f4085a86bc773e` |
| `ProjectKoios/DensityFunctionalTheory/KohnSham/ContinuumSpinDensity.lean` | `f1e551c2a15560653cbf2bedcc76247c4996f63eb99eed7566b946dc08a6240f` |
| `ProjectKoios/DensityFunctionalTheory/KohnSham/FiniteBasisSpinDensity.lean` | `23d1ca0065a2396b1d86f91cced60af97519e32b05138bd6675349c318e4983c` |
| `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinGlobalCollinearity.lean` | `a57407064b2b7e6b335de55c733add2c0a95b73e81c354ba93b00c80b5d33f0f` |
| `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinSO3Covariance.lean` | `523223c3d88cc680994c4ccd8623641be0eb39afa84c555cefd274e6e80252bf` |
| `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinorDensityMatrix.lean` | `90a5f88d38e8c53d42d1b0e0519faf03af46c257bb5d90e1aa1fa1a171bac6c7` |
| `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteResidualCertificate.lean` | `a4cc0a01418b88374b1394466d53e16299f3c2b346fdef5094e72133a7c9341b` |
| `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteSpectralCompression.lean` | `9c72ad59eb86041e2a01f1605b4ec49f15a642e5e6236fed387b5912d1b1e71c` |
| `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteSpectralResidual.lean` | `183130a93b86752f61f8f88dafbfa0d9fa7f790513d3088e491c5e01fdde528b` |
| `ProjectKoios/QuantumMechanics/HarmonicOscillator/HilbertBasis.lean` | `328f1a61671ed3a446205a21b3ec8ccc7a053eb117ae58d4d9812fbeec191bf0` |
| `ProjectKoios/QuantumMechanics/SpinDensity.lean` | `92d6267fa5b1fd36b0ff59aea3e5979f7fcd802e1819d9d8fa0b60c404afc1c4` |
| `ProjectKoios/QuantumMechanics/SpinDensity/Continuum.lean` | `bed2dcec79082c8aa72c272436707e3c3d42f2a08c64b7e57423498621a4f48a` |
| `ProjectKoios/QuantumMechanics/SpinDensity/FiniteBasis.lean` | `8e94e574704d8b1dcf15f44f6f3c997137a410c4071d7f18a5068ad5eaaaa150` |
| `ProjectKoios/QuantumMechanics/SpinDensity/HilbertBasis.lean` | `f848f01717e0e3f7850edfd0076293773a862e34e9443758a97414700e892e9b` |
| `ProjectKoios/QuantumMechanics/SpinDensity/OscillatorBasis.lean` | `36aafdaf319f7c6c83f578acdeaa0e7e444438280ac582b1afc1270affc90b6a` |

The aggregate review retains the toolchain and manifest hashes recorded above. It corrects a
missing contents entry/duplicated schematic letter, makes schematic assumptions explicit, and
reduces wide layouts; it changes no declaration, import, namespace, mathematical proposition,
proof body, or stable ID. The audit summary now distinguishes an eigenfunction Hilbert basis from
its still-open identification with the selected Cayley spectral measure. The formal, exact-data,
numerical, scientific, and publication boundaries remain unchanged. The Hermite reuse refactor
and broader documentation migration remain deferred. Logs, comparisons, diagrams, and the
35-path candidate inventory remain under `/tmp`; they are development evidence, not immutable
release artifacts. No commit or push is authorized or performed by this review. Local cached
upstream `c210b1d81511b318f23b7438e33d2a78871f0a1c` has 13 existing commits behind HEAD; a normal
push after one further commit would include all 14, subject to fresh remote state and server
requirements that have not been verified. No repository-local CI workflow or active default-path
pre-commit/pre-push hook was found; this does not establish the absence of server-side checks.

The repository-wide results `AUD-VAL-009` and `AUD-VAL-027` remain historical and must not be
represented as full builds of their later descendants. `AUD-VAL-033` is the repository-wide result
for the exact current source tree at its recorded run. Historical tranche evidence is recorded separately in
[`validation-history.md`](validation-history.md).

The results prove representative-safe scalar and spin-density identities; finite quantum-information
bindings; continuum orbital-angular-momentum domain, symmetry, closability, and commutator
statements; and domain, action, symmetry, dense-definedness, and closability statements for the
adopted Physlib Schrödinger operators, including the unregularized hydrogenic potential. The
oscillator's general essential-self-adjointness result remains conditional on an explicit
`d`-dimensional eigenstate dense-span premise, while the dimension-one Hamiltonian is
unconditionally essentially self-adjoint through direct pointwise Fourier-integral injectivity.
Its closure is packaged as a self-adjoint Physlib `QuantumSystem`, bound to PhyslibAlpha's concrete
Cayley-transform domain-aware spectral measure, and evolved through the physical convention
`U(t)=exp(-itH/ℏ)` with all-time domain-vector derivatives, domain invariance, and generator
commutation. The oscillator eigenfunction Hilbert basis is not yet identified with that selected
spectral measure. These results do not determine an exact singular Coulomb domain, a continuum or
DFT spin-orbit Hamiltonian, or physical applicability.

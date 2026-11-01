# Project Koios Formal

This repository is the Lean verification sidecar for Project Koios.

- Maintainer: Eugene Joseph M. Ragasa
- License: Apache-2.0

- Package: `ProjectKoiosFormal`
- Harness namespace: `ProjectKoios.Formal`
- Initial scientific namespace: `ProjectKoios.BandGauge`

## Authority

Each evidence class has a separate authority boundary.

- `docs/theorem-manifest.md` is the declaration and proof-status ledger.
- Lean proves only encoded propositions under explicit assumptions.
- Checked certificates prove only their checker conclusions.
- Numerical and runtime evidence remain external unless an explicit exact bridge binds them.
- Compilation does not establish source fidelity, scientific validity, novelty, release, or publication status.

## Layout

Semantic directories separate reusable mathematics from crosswalks.

- `ProjectKoios/BandGauge/`: reusable band-gauge mathematics, including the exact two-band projection-support counterexample, and thin paper crosswalks.
- `ProjectKoios/QuantumMechanics/`: source-neutral quantum mathematics and controlled models.
- `ProjectKoios/SolidState/`: finite-lattice and tight-binding algebra.
- `ProjectKoios/Crosswalks/`: narrow immutable-source constant bridges.
- `docs/`: policy, provenance, manifests, crosswalks, and plans.
- `proofs/`: one human-readable dossier per publication-facing statement.
- `papers/`: non-authoritative working syntheses.

See `docs/README.md` for the documentation index.

## Validation checks

Use affected-target validation for ordinary changes. For a Lean change, compile every changed module,
its bounded affected consumers, and the smallest relevant audit target; then run the applicable pin,
admission/axiom-coverage, manifest/crosswalk, and generated-state checks. Documentation-only changes
use their applicable document checks unless they alter a formal-status, dependency, axiom, or
reproducibility claim that requires replay.

```console
./scripts/check-pins.py
./scripts/audit.sh
```

A repository-wide `lake build` is an escalation gate for dependency/toolchain, Lake/package,
namespace-root, unbounded shared-foundation, ambiguous targeted-coverage, explicit-request, and
release/publication-snapshot cases. A frozen release or publication snapshot requires a
repository-wide build of that exact tree. See `AGENTS.md` and `docs/agent-workflow.md` for the complete
policy, and never report targeted compilation as a full build.

Optional dependency-graph generation is non-gating and reuses an already validated Audit artifact:

```console
./scripts/declaration-dependency-graph.sh
```

The graph script never builds or refreshes compiled Lake artifacts; it writes only ignored graph
outputs under `.lake/build/audit/`.

- Reuse `.lake` and immutable dependency materialization.
- Run `lake update` only for intentional dependency changes.
- Do not rebuild after staging, committing, or merging a byte-identical tree.
- Keep `lake-manifest.json` tracked and `.lake/` ignored.

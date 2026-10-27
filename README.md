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

- `ProjectKoios/BandGauge/`: reusable band-gauge mathematics and thin paper crosswalks.
- `ProjectKoios/QuantumMechanics/`: source-neutral quantum mathematics and controlled models.
- `ProjectKoios/SolidState/`: finite-lattice and tight-binding algebra.
- `ProjectKoios/Crosswalks/`: narrow immutable-source constant bridges.
- `docs/`: policy, provenance, manifests, crosswalks, and plans.
- `proofs/`: one human-readable dossier per publication-facing statement.
- `papers/`: non-authoritative working syntheses.

See `docs/README.md` for the documentation index.

## Promotion checks

Run once for each exact candidate tree.

```console
./scripts/check-pins.py
lake build
./scripts/audit.sh
```

- Reuse `.lake` and immutable dependency materialization.
- Run `lake update` only for intentional dependency changes.
- Do not rebuild after staging, committing, or merging a byte-identical tree.
- Keep `lake-manifest.json` tracked and `.lake/` ignored.

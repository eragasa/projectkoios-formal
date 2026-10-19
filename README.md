# Project Koios Formal

Minimal Lean/Lake harness for reusable Project Koios formalization.

- Lake package: `ProjectKoiosFormal`
- harness namespace: `ProjectKoios.Formal`
- initial scientific namespace: `ProjectKoios.BandGauge`

The tree contains a non-scientific smoke theorem, proved reusable foundations, partial conditional Ragasa2026A rank-two field, spectral, correlation-harmonic, and optimized admissible-set geometry bridges, and metadata-only placeholders for the other publication modules. Exact IDs and statuses live only in [`docs/theorem-manifest.md`](docs/theorem-manifest.md). It contains **no proved scientific theorem, checked scientific certificate, numerical result, release, or scientific validation claim**.

## Authority boundaries

1. **Exact formal proof:** a proposition and proof term accepted by the pinned Lean kernel. Only declarations listed as proved in `docs/theorem-manifest.md` have this status.
2. **Exact checked certificate:** external data checked by a specified exact Lean verifier whose soundness boundary is explicit. No such certificate exists here yet.
3. **Numerical evidence:** sampled or floating-point output. It may motivate a statement but does not discharge a Lean proposition by itself.
4. **Calculator/runtime authority:** external programs own their execution and outputs. Their success is neither a kernel proof nor scientific validation.

## Documentation

Start with [`docs/README.md`](docs/README.md). It indexes the authority and evidence contract, source/dependency audits, conventions, theorem planning, trusted-base policy, certificate vocabulary, and gated roadmap.

Human-readable, statement-specific proof explanations and prior-art records live under [`proofs/`](proofs/README.md), one LaTeX dossier per publication-facing declaration; the current dossiers are drafts. A compiled dossier is supplementary explanation; Lean and the theorem manifest remain authoritative for proof status.

An umbrella [`Ragasa claim-family formalization working paper`](papers/ragasa-formalization-working-paper.tex) supplies the cross-claim narrative and status matrix. It is an incomplete synthesis, not a proof authority, source-publication replacement, release, or claim that all families are already formalized; see [`papers/README.md`](papers/README.md).

The folders under `ProjectKoios/BandGauge/` reserve narrow ownership boundaries for foundations, geometry, Fourier analysis, projection, special functions, and thin paper crosswalks. A folder README does not establish a Lean API or a completed theorem; implemented modules must be listed in the theorem manifest.

## Checks

```console
lake update
./scripts/check-pins.py
lake build
./scripts/audit.sh
```

`lake-manifest.json` is tracked; `.lake/` is ignored. Documentation additions must not change theorem totals unless corresponding Lean declarations and audits exist.

# Project Koios Formal

Minimal Lean/Lake harness for reusable Project Koios formalization.

- Lake package: `ProjectKoiosFormal`
- harness namespace: `ProjectKoios.Formal`
- initial scientific namespace: `ProjectKoios.BandGauge`

The startup tree contains one non-scientific smoke theorem and metadata-only placeholders. It contains **no formalized publication theorem and no scientific validation claim**.

## Authority boundaries

1. **Exact formal proof:** a proposition and proof term accepted by the pinned Lean kernel. Only declarations listed as proved in `docs/theorem-manifest.md` have this status.
2. **Exact checked certificate:** external data checked by a specified exact Lean verifier whose soundness boundary is explicit. No such certificate exists here yet.
3. **Numerical evidence:** sampled or floating-point output. It may motivate a statement but does not discharge a Lean proposition by itself.
4. **Calculator/runtime authority:** external programs own their execution and outputs. Their success is neither a kernel proof nor scientific validation.

## Checks

```console
lake update
./scripts/check-pins.py
lake build
./scripts/audit.sh
```

`lake-manifest.json` is tracked; `.lake/` is ignored. See `docs/` for the theorem manifest, source audit, dependency audit, and publication crosswalk.

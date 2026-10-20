# Authority boundaries

| Class | What may establish it | What it may establish here | Current count |
|---|---|---|---|
| Exact formal proof | proposition and proof term checked by the pinned Lean kernel | only that proposition under its explicit assumptions | see `theorem-manifest.md`; no paper-specific instantiation |
| Exact checked certificate | exact certificate data plus a specified Lean checker and a proved connection to the target proposition | only the checker theorem's conclusion | zero |
| Numerical evidence/certificate | sampled, finite-precision, interval, or other external computation with provenance | bounded computational evidence as declared; not automatically a Lean proof | referenced externally only |
| Calculator/runtime authority | external implementation and execution environment | operational output under that runtime's contract | none owned here |

The acceptance requirements in [`BandGauge/publication-evidence-contract.md`](BandGauge/publication-evidence-contract.md) determine whether a future compact artifact is eligible for binding. Specifying that contract creates no artifact, checker result, formal theorem, or scientific authority. In particular, reusable mathematics may allow arbitrary positive weights while the concrete evidence contract rejects undocumented or post-hoc evaluation weights.

A publication label such as “theorem,” “proof,” or “exact certificate” records the source author's mathematical status. It does not become a Lean theorem until the statement and proof are encoded and audited. Floating-point margins do not become exact merely by being serialized. Conversely, a clean software build establishes compilation, not scientific correctness or validation.

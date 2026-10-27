# Authority boundaries

Each evidence class supports only its declared conclusion.

| Class | Established by | Scope |
|---|---|---|
| Exact formal proof | proposition and proof term checked by the pinned Lean kernel | encoded proposition under explicit assumptions |
| Exact checked certificate | exact data, checker, and soundness theorem | checker theorem's conclusion |
| Numerical evidence | external computation with fixed provenance and error contract | declared finite or bounded computational result |
| Runtime authority | implementation and execution environment | output under that runtime contract |

## Rules

Authority never transfers implicitly between classes.

- `docs/theorem-manifest.md` owns proof status.
- `docs/BandGauge/publication-evidence-contract.md` governs future package eligibility.
- A requirements document is not an artifact or checker result.
- Publication prose is not Lean proof.
- Floating-point serialization does not create exact data.
- A successful build establishes compilation only.

# Certificate vocabulary

A certificate is identified by its checker and conclusion.

## Classes

Each class has a distinct conclusion.

| Class | Current status | Boundary |
|---|---|---|
| Dependency lock | available | identifies revisions; does not prove suitability |
| Source snapshot | available in `source-audit.md` | identifies bytes; does not transfer ownership |
| Build record | commands documented | proves compilation only |
| Theorem inventory | available in `theorem-manifest.md` | planned entries are not theorems |
| Axiom report | available for named declarations | covers only named declarations |
| Publication crosswalk | available | does not prove mapped source claims |
| Rank-two scalar checkers | implemented | no runtime parser or publication-data binding |
| Finite Pareto checks | implemented | no external table or coverage binding |
| Evidence acceptance contract | specified as `PKF-BG-EVIDENCE-CONTRACT/1` | not a production schema or artifact |
| Exact analytic source certificate | one Paper A construction | not runtime or material evidence |
| Runtime scientific certificate | none | requires retained exact data and a bound checker result |

## Lifecycle

A concrete certificate progresses through:

1. proposed;
2. specified;
3. implemented;
4. checked; and
5. crosswalked.

Only checked and crosswalked states support claims about a particular certificate. Neither state implies scientific acceptance beyond the encoded conclusion.

## Current state

Reusable infrastructure exists without a runtime publication binding.

- Rank-two and finite-Pareto checkers are reusable infrastructure.
- Paper A has one exact analytic construction encoded directly in Lean.
- No runtime publication package or parser binding exists.
- Generated builds, large numerical outputs, caches, and private source artifacts are not retained here.
- Any future retained package must satisfy `docs/BandGauge/publication-evidence-contract.md`.

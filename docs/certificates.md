# Certificate vocabulary

A certificate is identified by its checker and conclusion.

## Classes

Each class has a distinct conclusion.

| Class | Current status | Boundary |
|---|---|---|
| Dependency lock | available | identifies revisions; does not prove suitability |
| Source snapshot | available in `audit/source-audit.md` | identifies bytes; does not transfer ownership |
| Build record | commands documented | proves compilation only |
| Theorem inventory | available in `theorem-manifest.md` | planned entries are not theorems |
| Axiom report | available for named declarations | covers only named declarations |
| Publication crosswalk | available | does not prove mapped source claims |
| Rank-two scalar checkers | implemented | no runtime parser or publication-data binding |
| Finite Pareto checks | implemented | no external table or coverage binding |
| Exact-data oscillator residual checker | implemented; synthetic fixtures kernel-checked | normalized residual and retained-energy tolerance `sqrt (B/S)` conditional on separately proved physical-scale enclosure; no runtime parser, float/solver-data binding, enclosure producer, or gap checker |
| Three-way interval decisions | implemented | no parser, enclosure-production, or external inventory binding |
| Evidence acceptance contract | specified as `PKF-BG-EVIDENCE-CONTRACT/1` | not a production schema or artifact |
| Exact direct-matrix synthetic pilot | source-neutral [v1 and v2 schemas](../specification/certificates/exact-direct-matrix/index.md) independently reviewed, corrected, focused-rereviewed, and frozen; v1 retained only and v2 unimplemented | exact rational Hermitian-pair fixtures only; no owner or runtime evidence |
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

- Rank-two, finite-Pareto, and three-way interval-decision checkers are reusable infrastructure.
- Threshold overlap remains unresolved; it is not a decisive acceptance or rejection.
- Paper A has one exact analytic construction encoded directly in Lean.
- No runtime publication package or parser binding exists.
- Oscillator finite/continuum residual transport, retained-level proximity for unit coefficients,
  and positive-gap orthogonal-component bounds are proved analytic implications for the exact
  retained matrix. Those lemmas alone do not check numerical residual reports or gap data.
- `HarmonicOscillator/FiniteResidualCertificate.lean` now checks exact rational real/imaginary
  coefficient data, ordered scale endpoints, computed positive mass `S`, and a conservative endpoint
  squared-residual budget against `B`. Acceptance plus a separately proved enclosure of actual
  `ℏω₀` guarantees a unit normalized continuum image, residual at most `sqrt (B/S)`, and proximity
  to some retained exact energy. Acceptance alone does not establish that enclosure or physical-model
  compatibility. The synthetic accepted/rejected fixtures use `decide +kernel`, not native computation
  as logical evidence. No runtime parser, floating-point ingestion, solver-data binding, enclosure
  producer, or gap checker is implemented; this does not implement the general direct-matrix schemas.
- Generated builds, large numerical outputs, caches, and private source artifacts are not retained here.
- Any future retained package must satisfy `docs/BandGauge/publication-evidence-contract.md`.

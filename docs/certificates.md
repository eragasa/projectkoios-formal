# Certificate vocabulary

“Certificate” is qualified by its checker and conclusion. The word alone must not imply a formal mathematical proof or scientific validation.

## Repository certificate classes

| Class | Required contents | Current availability | Nonclaim |
|---|---|---|---|
| Dependency lock record | toolchain plus direct and transitive immutable revisions | available through `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json` | does not prove API suitability or scientific correctness |
| Source snapshot record | owner repository, local branch, immutable commit, relative paths, and byte hashes | available in `source-audit.md` | does not copy or own source content |
| Build record | exact commands, tool versions, and success/failure result | reproducible commands documented; generated logs are not retained as an evidence package | does not prove scientific theorems beyond compiled declarations |
| Theorem inventory | fully qualified declarations and honest proof status | startup inventory available | planned or metadata entries are not theorems |
| Axiom report | `#print axioms` output for named declarations | available for startup declarations | says nothing about declarations not audited |
| Publication crosswalk | source statement location, assumptions, and Lean declaration/status | available at metadata level | does not formalize the statement |
| Exact rank-two scalar checkers | rational scalar inputs, exact-center or interval-center checks, and soundness theorems for witness, containment, and separation | implemented in `BandGauge/Certificates/RankTwoSeparation.lean` and `RankTwoSeparationEnclosure.lean` | does not bind scalars to publication matrices or runtime bytes |
| Exact finite Pareto checks | total finite exact objective table, executable dominance and threshold checks, executable nondominated mask, and soundness/completeness bridges | implemented in `BandGauge/Certificates/FinitePareto.lean` | does not parse external tables, prove external coverage, or resolve interval-overlapping comparisons |
| Publication-evidence acceptance contract | immutable identity, a-priori or certified-optimized weight derivation, explicit support semantics, finite coverage, alignment, objective, and fail-closed requirements | specified as `PKF-BG-EVIDENCE-CONTRACT/1` in [`BandGauge/publication-evidence-contract.md`](BandGauge/publication-evidence-contract.md) | a requirements document is not a production schema, parser, retained artifact, or accepted certificate |
| Exact analytic source certificate | exact source construction encoded directly in Lean, checker, soundness bridge, and immutable source crosswalk | one Paper A two-observation certificate, `BG-RAGASA2026A-DEF-022` through `BG-RAGASA2026A-DEF-024` and `BG-RAGASA2026A-THM-029` through `BG-RAGASA2026A-THM-034` | does not imply runtime evidence, four-state-parent validation, material validation, or a continuum claim |
| Runtime scientific certificate | exact retained data, parser/checker, soundness theorem, and bound input identity | none | the analytic source certificate, generic scalar checker, and numerical output are not silently promoted to this class |

## Certificate lifecycle

A future concrete runtime scientific certificate moves through these states:

1. **proposed** — data and target proposition are described;
2. **specified** — exact encoding, parser, checker, and rejection behavior are fixed;
3. **implemented** — checker exists but has not passed the complete audit;
4. **checked** — a bound certificate passes the pinned checker;
5. **crosswalked** — the checked result is linked to a reviewed theorem and source claim.

Only the final two states may support a claim about a particular certificate, and neither implies scientific acceptance beyond the encoded conclusion. The rank-two scalar and finite-Pareto checkers are implemented infrastructure. Paper A's exact analytic construction is encoded directly rather than parsed, and its checked certificate count is one: the field-derived power and `μmax`, thresholds, witness, and source rectangle are proved and bound in Lean. The enclosure checker handles the algebraic center through `BG-CERT-THM-009`, which proves `7/10 < 1 / √2 < 71/100`. No runtime publication package or parser binding exists; a calculated result still needs exact identity and retained-data bindings.

## Retention policy

Do not commit generated build state, large numerical outputs, runtime caches, or private source artifacts. A retained certificate package, if later authorized, should contain only the exact compact inputs, identities, checksums, checker coordinates, audit output, and readable status needed to reproduce its bounded conclusion. It must satisfy the acceptance and fail-closed rules in [`BandGauge/publication-evidence-contract.md`](BandGauge/publication-evidence-contract.md); in particular, undocumented or post-hoc evaluation weights are ineligible.

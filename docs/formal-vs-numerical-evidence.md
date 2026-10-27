# Formal proof and numerical evidence

Formal proof, certificate checking, numerical evidence, and calculator execution are separate authority channels. A workflow may connect them only through an explicit proposition and checker boundary.

## Evidence classes

| Evidence | Owned conclusion | Does not establish by itself |
|---|---|---|
| Lean proof term | the encoded proposition under its encoded assumptions | source fidelity, physical applicability, numerical convergence, or publication acceptance |
| Exact certificate checked in Lean | the checker theorem's conclusion for the parsed exact certificate | correctness of unbound external files or floating-point calculations |
| Interval/rational external certificate | the external verifier's stated bound, when provenance and checker semantics are fixed | a Lean theorem unless the result is imported through a proved exact boundary |
| Floating-point or sampled result | behavior on the declared finite computation and tolerances | exact equality, continuum extrema, universal behavior, or theorem proof |
| Runtime/calculator output | output of the declared implementation and environment | kernel acceptance or scientific validation |
| Publication prose proof | the source author's mathematical argument | a declaration checked by this repository's Lean kernel |

## Permitted bridge pattern

A future numerical-to-formal bridge must identify:

1. an exact Lean proposition to discharge;
2. an exact certificate data model;
3. a parser whose accepted bytes or values are unambiguous;
4. a checker implemented in or connected soundly to Lean;
5. a theorem relating checker success to the proposition;
6. the bound external input by digest and provenance; and
7. any rounding, interval, discretization, or model assumptions.

Without all seven items, numerical output remains external evidence.

## Current publication boundary

The source publications contain analytic paper proofs, finite-mesh development calculations, retained precursor records, and proposed future certificate workflows. Their statuses remain those recorded by the owner source. This repository currently imports none of their numerical records and checks no scientific certificate.

Current formal implications:

- `BG-THM-002` — an exact common-set member implies zero admissible-set distance.
- `BG-THM-003` — a supplied strictly positive global lower bound implies disjointness.
- `BG-THM-007` — one candidate satisfying both loss budgets forces zero distance.
- `BG-THM-008` — a supplied positive separation certificate excludes joint adequacy.
- `BG-THM-009` — the supplied reduced operator-loss quadratic is bounded below by its irreducible floor.
- `BG-THM-010` — a squared operator budget below that floor makes the reduced sublevel set empty.
- `BG-THM-011` — a supplied scalar correlation bound implies normalized magnitude at most one.
- `BG-THM-012` — the normalized-correlation bound makes the irreducible floor nonnegative.
- `BG-THM-013` — the reduced aligned-operator squared loss is nonnegative under the scalar bounds.
- `BG-THM-014` — the reduced spectral squared loss is nonnegative for nonnegative curvature.
- `BG-THM-015/016` — square-root real losses recover the corresponding squared formulas.
- `BG-THM-017/018` — nonnegative real-loss budgets are equivalent to squared-loss budgets.
- `BG-THM-019/021` — the spectral and aligned-operator sublevel conditions have explicit ellipse forms.
- `BG-THM-020` — a nonnegative operator-radius radicand is recovered by squaring its radius.
- `BG-THM-022/024/025` — the full ellipses intersect exactly under the scaled-center compatibility bound.
- `BG-THM-023` — strict scaled center separation makes the full ellipses disjoint.
- `BG-THM-026` — the exact full-plane criterion transfers to the reduced real-loss admissible sets.
- `BG-THM-027/028` — the full-ellipse distance formula is a universal lower bound and is attained.
- `BG-THM-029` — the full-ellipse admissible-set distance equals the closed formula.
- `BG-THM-030` — the exact distance transfers to the reduced real-loss admissible sets.
- `BG-THM-031/032` — supplied full-ellipse containment makes restriction to the declared candidate rectangle leave each ellipse unchanged.
- `BG-THM-033/034` — under those containment premises, the rectangle-restricted ellipses retain the exact intersection criterion and distance formula.
- `BG-BLOCH-THM-001` — a supplied sewn operator field preserves a supplied sewn section.
- `BG-BLOCH-THM-002` — a supplied sewing-compatible unitary alignment preserves operator covariance.
- `BG-BLOCH-THM-003/004` — half-trace centering makes the abstract retained Bloch matrix and its finite sampled field pointwise traceless.
- `BG-BLOCH-THM-005/006` — supplied unitary conjugation preserves pointwise tracelessness and weighted Frobenius power.
- `BG-BLOCH-THM-007/008` — two supplied unitary fields of one sampled centered parent have common power and correlation magnitude at most that power.
- `BG-RAGASA2026A-THM-001/002/003` — under the exact conditional Paper A contract, the globally real-rotated candidate and momentum-dependently aligned comparison fields are traceless, have common power, and satisfy `|bφ| ≤ κ`.
- `BG-RAGASA2026A-THM-004` — under the same contract and `0 < κ`, the exact finite operator matrix residual equals the reduced scalar aligned-operator loss.
- `BG-RAGASA2026A-THM-005/006/007` — a supplied exact real unitary diagonalization witness yields centered spectral deviations, equality of spectral and parent Frobenius power, and the reduced scalar spectral loss.
- `BG-RAGASA2026A-THM-018/019/020` — the finite-dimensional Hermitian spectral theorem constructs that exact decomposition canonically, so no external eigensolver output is trusted implicitly; this noncomputable existence result supplies no numerical eigenvalue certificate.
- `BG-RAGASA2026A-THM-008` through `BG-RAGASA2026A-THM-017` — exact Pauli coordinates, canonically extracted from the Hermitian traceless fields, yield the source second harmonic, its exact continuous maximum and canonical half-open maximizing angle, `|bmax/κ| ≤ 1`, and the finite matrix loss centered at `μmax`; no numerical coefficient extraction or degeneracy decision is trusted implicitly.
- `BG-RAGASA2026A-THM-021` through `BG-RAGASA2026A-THM-026` — the actual canonical Paper A losses inherit the proved ellipse intersection and exact-distance formulas; candidate-rectangle results require explicit full-ellipse containment, whose concrete numerical verification remains external.
- `BG-CERT-THM-001` through `BG-CERT-THM-004` — an exact rational-center Boolean checker implies a positive-scale spectral witness, full-ellipse containment, and strict separation in real geometry.
- `BG-CERT-THM-005` through `BG-CERT-THM-008` — a rational-enclosure checker proves the same conclusions uniformly for every real center in its checked interval.
- `BG-CERT-THM-009` — exact real arithmetic proves `7/10 < 1 / √2 < 71/100` without floating-point evidence.
- `BG-CERT-THM-013` through `BG-CERT-THM-016` — an exact rational joint-enclosure checker proves one positive-scale witness, containment, and strict separation uniformly for every real `(κ, μ)` in its checked box.
- `BG-RAGASA2026A-THM-027/028` — after explicit exact `κ` binding and either exact rational `μ` equality or proved rational enclosure of the canonical finite fields, acceptance implies a spectral pass and operator incompatibility in the candidate rectangle.
- `BG-RAGASA2026A-THM-035` — explicit field-derived bounds on both `κ` and `μmax` bind the joint checker to the canonical finite fields.
- `BG-RAGASA2026A-THM-029` through `BG-RAGASA2026A-THM-034` and `BG-RAGASA2026A-THM-036/037` — the source's exact two-observation construction has uniform weight `1/2`, parent power one, `μmax = 1 / √2`, an accepted exact rational enclosure certificate, zero spectral loss at `(0,1)`, disjoint pass sets, the exact positive admissible-set distance, and the separation-resolution corollary in the source rectangle; the `[1,1]` curvature interval regression recovers the same certificate conclusion through the joint bridge. This is an analytic source instance, not runtime evidence or four-state-parent validation.
- `BG-HILBERT-THM-001` — two nonnegative-radius Hilbert balls intersect exactly when their center distance is at most the radius sum.
- `BG-HILBERT-THM-002/003/004` — the center-gap formula is a universal lower bound, is attained, and equals the real admissible-set distance.
- `BG-HILBERT-THM-005/006` — the finite weighted rank-two Frobenius residual is nonnegative and its real correlation satisfies Cauchy–Schwarz.
- `BG-HILBERT-THM-007/008` — pointwise unitary conjugation preserves weighted Frobenius power, and equal power `κ` bounds correlation magnitude by `κ`.
- `BG-HILBERT-THM-009/010` — weighted Frobenius power obeys real polarization, and pointwise traceless fields are orthogonal to the identity field.
- `BG-HILBERT-THM-011/012/013` — the abstract finite operator matrix residual expands exactly, specializes to the common-power quadratic, and equals the existing reduced scalar aligned-operator loss.
- `BG-HILBERT-THM-014/015` — the abstract centered two-state spectral residual expands exactly and equals the existing reduced scalar spectral loss when its weighted power is `κ`.

These theorems define conditional loss sublevel sets, an exact scalar-checker boundary, and one exact source-specific analytic construction. They do not parse runtime output, validate a calculated four-state-parent result, or establish a numerical/material claim. A future runtime certificate package must bind immutable computational data to the checker inputs and discharge field-derived `κ` and `μmax` obligations independently.

## Prohibited status transfers

Do not infer that:

- a plot proves a global bound;
- an optimizer failure proves infeasibility;
- a finite grid proves a continuum extremum;
- binary64 agreement proves exact equality;
- serialization makes approximate data exact;
- a retained result for one experiment transfers to another;
- a Lean build validates a calculator; or
- a Lean theorem validates a material model.

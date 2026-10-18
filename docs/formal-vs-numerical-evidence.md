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

These theorems do not define the scientific loss sublevel sets, produce a runtime witness, or validate a numerical lower bound. An exact checked certificate must connect runtime output to their hypotheses.

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

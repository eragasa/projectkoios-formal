# Formal and numerical evidence

Formal proof, certificate checking, numerical evidence, and runtime execution are separate authority channels.

## Evidence classes

Each class supports only the listed conclusion.

| Evidence | Establishes | Does not establish by itself |
|---|---|---|
| Lean proof | encoded proposition under explicit assumptions | source fidelity, applicability, convergence, publication status |
| Lean-checked exact certificate | checker theorem's conclusion | correctness of unbound files or floating calculations |
| External interval/rational certificate | external verifier's declared bound | Lean theorem without a proved bridge |
| Floating or sampled result | behavior of the declared finite computation | exact equality, continuum behavior, universal claim |
| Runtime output | output under the runtime contract | kernel proof or scientific validation |
| Publication proof | source author's argument | Lean-checked declaration |

## Numerical-to-formal bridge

A bridge requires:

1. exact Lean proposition;
2. exact certificate model;
3. unambiguous parser;
4. checker;
5. checker-soundness theorem;
6. bound input identity and provenance; and
7. rounding, interval, discretization, and model assumptions.

Without all items, numerical output remains external evidence.

## Current boundary

The repository currently stops before runtime scientific evidence.

- Exact declarations and their limits are listed in `theorem-manifest.md`.
- Source mappings are listed in `publication-crosswalk.md`.
- Generic scalar and finite-Pareto checkers exist.
- Paper A has one exact analytic construction encoded directly in Lean.
- No runtime scientific package is parsed or checked.
- No calculated four-state-parent result or material claim is formalized.

## Prohibited transfers

Do not infer that:

- a plot proves a global bound;
- optimizer failure proves infeasibility;
- a finite grid proves a continuum extremum;
- binary64 agreement proves exact equality;
- serialization makes approximate data exact;
- one experiment's result transfers to another;
- a Lean build validates a runtime; or
- a Lean theorem validates a material model.

# Ragasa2026B paper and proof plan

This plan defines the unimplemented Paper B program.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

This is a proposed program. The Paper B Lean namespace is a zero-statement metadata placeholder.

## Source

The plan uses one immutable publication directory.

- Repository: `ksdft2effmass`
- Branch: `work/paper-3-higher-rank-extension`
- Commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`
- Path: `docs/publications/papers/Ragasa2026b/v2`

Version 2 states that it preserves the relevant version 1 mathematics and scope. Exact hashes and dirty-state limits are in `docs/source-audit.md`.

## Thesis

Spectral projection can turn a finite-range parent into a nonlocal reduced model. The cost of controlling that nonlocality depends on dimension, amplitude, symmetry, and the admissible complete-shell hierarchy.

## Required analytic claims

Seven claim families define the analytic scope.

- Explicit destruction of finite hopping support by spectral projection.
- Multidimensional flat-parent residual/locality identity.
- Shell-resolved Fourier coefficients.
- Factorial or constrained-series tail bound.
- Monotonicity and a small-amplitude dimension law.
- Bond-orbit comparator.
- Complete-shell tail certificate.

Each theorem must retain its exact dimension, parent, amplitude, support, symmetry, and convergence hypotheses.

## Finite decision object

For each declared shell--scale decision `d`, retain:

\[
C(d)=N_{\mathrm{blocks}}(d),\qquad
H(d)=\varepsilon_H(d),\qquad
E(d)=\varepsilon_E(d),\qquad
\text{admissible}(d).
\]

The decisive object is the complete finite table over all admissible decisions.

- Dominance is weak-all and strict-any.
- Threshold feasibility is `E ≤ τ_E` and `H ≤ τ_H`.
- Minimum feasible cost is relative to the complete declared table.
- A common witness must satisfy both channels at one decision.
- Dropped, failed, or silently filtered cases invalidate exhaustiveness.

## Attainability and support boundaries

Keep the following objects distinct:

1. sampled attainable decisions;
2. sampled nondominated decisions;
3. componentwise envelopes whose coordinates may come from different decisions;
4. triangulated or smoothed visualizations; and
5. a continuum Pareto frontier.

Exhaustive finite enumeration establishes only the first two for the declared inventory. Plot interpolation, convexification, and tessellation do not establish attainability or a continuum result.

Support inventories must be finite, inversion closed, symmetry complete, and nested where claimed. Equal-radius ties must not be split, and discrete shell costs must not be presented as continuous. Evaluation weights must be fixed a priori or by a separately certified rule. Graphene- and silicon-inspired controls remain inspired comparators unless independently bound to material parameters.

## Formal support

Implemented reusable support:

- finite Fourier reconstruction and residual tails;
- matrix Frobenius Parseval;
- finite dominance, efficiency, feasibility, and minimum-cost theorems;
- exact finite Pareto checkers;
- source-neutral complete finite metric shells with nesting, tie retention, conditional inversion and
  symmetry closure, attained-radius enumeration, no-skipped-shell semantics, and exact square,
  triangular, simple-cubic, and normalized FCC reduced-coordinate indices; and
- rank-two spectral/operator loss geometry.

Missing support:

- source-specific spectral projection and support-destruction theorem;
- special-function coefficient and tail theorems;
- owner-specific external inventory, symmetry-action, cap, and physical-range bindings;
- exact objective-table schema and external coverage proof; and
- retained production evidence.

## Certificate requirements

A publication package must include:

1. frozen case and decision enumeration;
2. exact or outward-rounded objectives;
3. explicit failed-case dispositions;
4. strict parser and schema;
5. producer and independent verifier;
6. retained hashes and provenance;
7. exact coverage proof for the declared decision space; and
8. Lean-checked Pareto and threshold conclusions.

Plots and interpolated landscapes are derived views, not the decision record.

## Work order

The work starts with statement and support conventions.

1. Freeze the exact paper statements and support convention.
2. Formalize projection-induced nonlocality in a reusable module.
3. Prove the source coefficient and tail bounds.
4. Freeze the owner-side exhaustive table schema.
5. Independently verify one retained table.
6. Add a thin Paper B bridge and dossiers.

## Nonclaims

No current declaration proves the Paper B thesis, a concrete minimum shell, a complete runtime table, continuum convergence, material applicability, novelty, release, or publication readiness.

# Ragasa2026B paper and proof plan

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19

## Status

This document records a proposed scientific, computational, and formalization program for
Ragasa2026B. It is not publication prose, a Lean theorem declaration, a retained objective
table, a checked Pareto certificate, publication authorization, or a claim that the paper
is complete.

The Paper B Lean namespace remains a zero-statement metadata placeholder. Declaration
status is controlled by
[`../../../theorem-manifest.md`](../../../theorem-manifest.md).

## Source identity

The crosswalked owner source is:

- repository: `ksdft2effmass`;
- branch: `work/paper-3-higher-rank-extension`;
- commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`;
- path: `docs/publications/papers/Ragasa2026b/v2`.

Version 2 states that it preserves the relevant version 1 mathematics and scope. Exact
source hashes and later dirty-state limitations are recorded in
[`../../../source-audit.md`](../../../source-audit.md).

## Proposed paper thesis

> Spectral projection can transform a finite-range parent into a nonlocal reduced model.
> The representation cost required to control this nonlocality depends on dimension,
> amplitude, symmetry, and the admissible complete-shell hierarchy.

Paper B should explain why locality is lost and quantify the finite support required to
recover declared operator and spectral tolerances.

## Analytic scope

The publication-facing analytic claim family comprises:

- an explicit example in which spectral projection destroys finite hopping support;
- a multidimensional flat-parent residual/locality identity;
- shell-resolved Fourier coefficients;
- a factorial or constrained-series Fourier-tail bound;
- monotonicity and a small-amplitude dimension law;
- a bond-orbit flat-parent comparator; and
- a complete-shell tail certificate.

Each statement must retain its exact dimension, flat-parent, amplitude, support, symmetry,
and convergence hypotheses.

## Finite decision object

For each attainable shell–scale decision `d`, retain

\[
  C(d)=N_{\mathrm{blocks}}(d),
  \qquad
  H(d)=\varepsilon_H(d),
  \qquad
  E(d)=\varepsilon_E(d).
\]

The primary sampled object is the finite set

\[
  \{(C(d),H(d),E(d)):d\in D\},
\]

not a continuum surface fitted through it.

Use minimization dominance:

\[
  d_1\prec d_2
\]

when `d₁` weakly improves all declared objectives and strictly improves at least one.
The nondominated mask must refer to attainable decisions, not independently minimized
coordinate envelopes.

## Attainability and visualization boundary

The paper must keep distinct:

1. a sampled attainable decision;
2. a sampled nondominated decision;
3. a componentwise lower envelope whose coordinates may come from different decisions;
4. a triangulated visualization; and
5. a continuum Pareto frontier.

Exhaustive finite enumeration establishes only the first two for the declared inventory.
Plot triangulation does not establish interpolation, convexity, attainability, or a
continuum result.

Discrete support shells also produce genuine stepped behavior. Shell indices must not be
smoothed into a continuous representation cost.

## Scientific evidence required

A retained Paper B result requires:

1. immutable definitions of every parent/control model;
2. a frozen finite scale inventory;
3. complete inversion- and symmetry-closed shell inventories;
4. construction and withheld momentum meshes;
5. objective values for every declared decision;
6. an independently checked nondominated mask;
7. mesh, scale-grid, and shell-cap refinement;
8. resolution rules for claimed dimension or model differences; and
9. provenance and outward-rounded uncertainty where exact evaluation is unavailable.

Square and simple-cubic systems may be exact mathematical controls. Graphene- and
silicon-inspired controls remain inspired controls unless an independent material
parameter binding is established.

## Semantically organized proof dependencies

Proofs are organized by mathematical meaning, not under a Paper B theorem hierarchy:

| Semantic module family | Required content |
|---|---|
| `Projection/` | spectral projection, retained compression, and explicit finite-support loss examples |
| `Fourier/` | multidimensional conventions, coefficient support, Parseval, truncation, and complete shells |
| `SpecialFunctions/` | Jacobi–Anger/Bessel identities and analytic tail estimates where source-required |
| `Hilbert/` | Frobenius residual/locality identities and exact normalizations |
| `Geometry/` | threshold-admissible sets where metric geometry is needed |
| `Decision/` | finite dominance, Pareto efficiency, threshold feasibility, and minimum cost |
| `Certificates/` | interval objective tables, exhaustive coverage, and Pareto-mask soundness |

Paper B should consume these results through a source crosswalk or thin instantiation. A
Fourier, projection, or finite-order theorem must not be duplicated or renamed merely to
make it Paper B-specific.

## Required theorem families

### Projection and locality

Prove, under the exact source hypotheses, that the selected spectral projection may have
nonzero Fourier coefficients beyond the finite support of the parent.

### Residual/locality identity

Prove the exact equality between the declared operator residual and omitted Fourier or
hopping weight with all normalization factors explicit.

### Shell coefficients and tail bound

Derive the shell-resolved coefficient formula and its stated factorial or constrained
series tail. Preserve convergence and shell-cap premises.

### Dimension law

Prove the small-amplitude dimension dependence only on the declared orthogonal
flat-parent family. Do not generalize it to arbitrary lattices or materials.

### Complete-shell properties

Prove that each support inventory is finite, inversion closed, symmetry complete, and
nested where nesting is claimed. Equal-radius ties must not be split.

### Finite Pareto classification

For a finite decision set, prove:

- dominance is irreflexive and transitive;
- every nonempty finite set has a nondominated element;
- the calculated nondominated mask is sound and complete;
- duplicate objective vectors do not dominate one another; and
- any reported minimum-cost feasible decision is attained.

### Interval certificate

Prove that accepted outward-rounded intervals certify every comparison used by the
nondominated mask. Overlapping intervals must yield unresolved comparisons rather than
optimistic dominance.

## Relationship to Papers A and C

Paper A supplies the conceptual distinction between spectral and operator fidelity, but
Paper B must not inherit Paper A's scientific status automatically.

Paper B studies projection-induced locality and dimension. Paper C studies how a
higher-rank admissible gauge can change that locality. Paper C may use Paper B's analytic
laws as baselines, but the two papers should not present the same finite decision table as
independent evidence.

## Proposed manuscript structure

1. **Problem:** finite-range parents need not yield finite-range projected models.
2. **Analytic construction:** projection and exact Fourier structure.
3. **Tail theory:** shell coefficients, bounds, monotonicity, and dimension law.
4. **Finite decisions:** shell/scale inventories and attainable objectives.
5. **Results:** exact comparators, discrete Pareto sets, and refinement.
6. **Interpretation:** representation cost and dimensionality.
7. **Limitations:** finite meshes, inspired controls, bounded inventories, and no
   continuum conclusion from plots.

Recommended figures are:

- exact or certified tail decay by shell;
- predicted versus observed tail bounds;
- minimum support versus tolerance;
- discrete shell-transition staircases;
- attainable nondominated points without interpolated authority; and
- refinement stability across meshes and shell caps.

## Publication-readiness criteria

Ragasa2026B is ready for a scientific-result claim only when:

1. analytic comparators and finite decision definitions are frozen;
2. every sampled decision is covered by the retained objective table;
3. the nondominated mask is independently verified;
4. complete-shell and refinement rules are satisfied prospectively;
5. visualization is not treated as additional attainable evidence;
6. inspired controls are not presented as material parametrizations; and
7. analytic proof, finite numerical evidence, continuum status, and scientific
   interpretation are reported separately.

The current metadata placeholder and inspected development plots establish none of these
publication results by themselves.

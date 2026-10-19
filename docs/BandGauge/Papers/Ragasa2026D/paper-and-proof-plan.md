# Proposed Ragasa2026D paper and proof plan

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19

## Status

Ragasa2026D is a proposed research direction only. No audited owner-publication source,
canonical source key, approved title, Lean namespace, paper-specific theorem, numerical
artifact, submission, or publication status exists in this repository.

This document must not be used to create a Paper D placeholder or claim a source identity.
That requires an owner-approved protocol at an immutable revision and a separate source
audit. The authoritative declaration ledger remains
[`../../../theorem-manifest.md`](../../../theorem-manifest.md).

## Proposed paper thesis

> A finite-support Wannier or tight-binding model should be selected by simultaneous
> spectral and aligned-operator fidelity to a retained first-principles reference, not by
> visual band agreement alone.

Paper D would apply the reusable compatibility, locality, alignment, and certificate
machinery developed independently of any paper namespace.

## Three-level architecture

### First-principles oracle

\[
  O_A(k)=H_{\mathrm{oracle}}(k).
\]

This may eventually be a DFT or other first-principles operator interface, with frozen
calculation inputs and provenance.

### Retained spectral bridge

For a retained frame `Q(k)`,

\[
  O_B(k)=Q(k)^\dagger O_A(k)Q(k).
\]

The bridge must contain more than sorted eigenvalues. It requires retained subspaces or
projectors, gauge/sewing data, eigenpair residuals, and a degeneracy-aware comparison
contract.

### Local model

For alignment `U(k)` and support `S`,

\[
  O_C^{U,S}(k)
  =\sum_{R\in S}e^{ik\cdot R}T_U(R).
\]

The same `O_C`, `U`, and `S` must satisfy the spectral and operator thresholds.
Separate channel optima do not form a common witness.

## Minimum-cost decision

For a frozen finite candidate set `D`, define

\[
  F(\tau_E,\tau_O)
  =\{d\in D:L_E(d)\le\tau_E\land L_O(d)\le\tau_O\}
\]

and, when nonempty,

\[
  C^*(\tau_E,\tau_O)
  =\min_{d\in F(\tau_E,\tau_O)}C(d).
\]

Potential decision coordinates include retained rank, energy window, disentanglement
choice, alignment family, localization settings, and Fourier support. Exhaustiveness is
always relative to the declared finite inventory.

## Error budget

Paper D must preserve separate error channels:

\[
  e_{\mathrm{eig}},
  \quad e_{\mathrm{subspace}},
  \quad e_{\mathrm{align}},
  \quad e_{\mathrm{interp}},
  \quad e_{\mathrm{trunc}}.
\]

A conservative end-to-end decomposition should derive the final operator and spectral
bounds without treating correlated errors as independent.

At degeneracies and crossings, compare spectral clusters, projectors, or eigenvalue
multisets. Do not rely on undocumented individual eigenvector labels.

## Initial scope

The first application should use one controlled, equal-rank, isolated composite manifold.
Do not begin with the hardest unequal-rank or disentangled case.

The initial evidence package should include:

1. frozen oracle inputs and dependency revisions;
2. frozen retained eigenpair and projector exports;
3. frozen Wannier inputs and outputs if Wannier90 is used;
4. construction and withheld momentum meshes;
5. a complete candidate-support inventory;
6. alignment, sewing, and group-integrity diagnostics;
7. outward-rounded objective intervals;
8. an independent verifier;
9. canonical provenance and digests; and
10. one no-overwrite retained package.

Wannier90 may produce a witness. It is not a Lean dependency, a member of the formal
trusted base, or proof of the witness contract merely because it converged.

## Semantically organized proof dependencies

No reusable proof should be placed under a Paper D hierarchy. Paper D would consume:

| Semantic module family | Required content |
|---|---|
| `Projection/` | approximate compression, eigenpair residuals, projector/subspace perturbation, leakage |
| `Bloch/` | sewing-compatible retained fields, alignments, and difference operators |
| `Alignment/` | equal-rank unitary alignment and later unequal-rank isometric compression |
| `Fourier/` | interpolation, support truncation, Hermitian reconstruction, and locality tails |
| `Hilbert/` | operator and spectral loss bridges with exact normalizations |
| `Geometry/` | common-witness admissible sets and separation diagnostics |
| `Decision/` | finite feasibility, minimum cost, robustness, and empty-set classification |
| `Certificates/` | interval residuals, coverage, objective tables, and checked selection |

A future Paper D namespace should contain only source-specific contracts and thin
instantiations after the owner source exists.

## Required theorem families

### Approximate retained compression

For approximate retained frame `Q` and diagonal or block spectral data `D`, check

\[
  Q^\dagger Q\approx I
\]

and define residual

\[
  R=O_AQ-QD.
\]

Prove a reviewed residual-to-compression bound and retain every norm convention.

### Subspace validity

Under an explicit spectral gap, prove or import a suitable projector/subspace
perturbation theorem. When there is no isolating gap, report the bridge as unresolved or
use a larger reviewed cluster.

### Alignment legitimacy

For equal rank, prove unitary/isometric group membership, sewing compatibility, and
well-typed subtraction. For unequal rank, use isometric compression and explicit leakage;
do not call it unitary gauge equivalence.

### End-to-end error decomposition

Prove the exact algebraic decomposition from oracle bridge through alignment,
interpolation, and truncation, followed by conservative norm inequalities.

### Spectral consequence

Use finite Hermitian perturbation bounds to connect the checked operator residual to
ordered-eigenvalue or cluster bounds without claiming a floating-point eigensolver is part
of Lean.

### Finite selection

Prove finite feasibility, minimum-cost attainment, tolerance monotonicity, and an
exhaustive empty-intersection classification for the frozen candidate set.

### Certificate soundness

Prove that accepted interval residuals, coverage, and objective comparisons imply the
reported finite decision. Parsing, canonical serialization, and digest checking remain
part of the explicit software/evidence boundary.

## Scientifically useful outcomes

A strong Paper D should establish at least one nontrivial outcome:

- visually accurate bands with inadequate aligned-operator fidelity;
- rejection of a cheaper model that passes only the spectral tolerance;
- a stable minimum-cost jointly adequate support;
- a measurable benefit from an admissible momentum-dependent gauge; or
- a stable difference operator that identifies omitted physical structure.

A failed local optimizer is not evidence of infeasibility. Negative conclusions require
exhaustive finite enumeration or another reviewed global certificate.

## Proposed manuscript structure

1. **Problem:** band agreement alone does not certify an operator-faithful local model.
2. **Oracle/bridge/local architecture:** retained projectors, gauges, and support.
3. **Certificate method:** residuals, error budget, finite decisions, and verifier.
4. **Computational instance:** frozen first-principles and Wannier witnesses.
5. **Joint-fidelity result:** feasible set, minimum support, robustness, or certified
   failure for the declared hierarchy.
6. **Difference-operator interpretation:** stable omitted structure where justified.
7. **Limitations:** finite meshes, bounded candidate inventory, external oracle, and no
   automatic material validation.

Recommended figures are:

- the `O_A → O_B → O_C` pipeline;
- eigenpair/subspace/alignment/truncation error budget;
- spectral-versus-operator objective scatter;
- the minimum-cost map `(τ_E,τ_O) ↦ C*`;
- withheld-mesh and support-refinement stability; and
- an interpretable difference-operator diagnostic when stable.

## Publication-readiness criteria

Paper D cannot enter publication status until:

1. an owner-approved source protocol and immutable revision exist;
2. the oracle, bridge, and local-model contracts are frozen;
3. tolerances are justified prospectively;
4. the finite candidate inventory and cost are complete;
5. the independent verifier accepts a retained evidence package;
6. degeneracy, unequal-rank, leakage, and sewing conditions are handled explicitly;
7. finite-mesh conclusions remain finite-mesh conclusions; and
8. formal certification is not confused with physical or predictive validation.

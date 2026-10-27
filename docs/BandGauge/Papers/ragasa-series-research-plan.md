# Ragasa paper-series research plan

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19

## Status and authority boundary

This document records a proposed division of scientific questions, evidence, and formal
work across Ragasa2026A–D. It is a research plan, not a theorem inventory, publication
source, numerical result, authorization to execute or publish, or claim that any paper is
complete.

Ragasa2026A–C already have owner-repository source paths recorded in
[`../../publication-crosswalk.md`](../../publication-crosswalk.md). Ragasa2026D does not.
No Paper D Lean namespace, source key, or publication status should be created until an
owner-approved source location and immutable revision exist.

Formal declaration status is reported only in
[`../../theorem-manifest.md`](../../theorem-manifest.md). Canonical bibliographic identity
remains owned by `projectkoios-references`.

## Semantic proof organization

The paper sequence is a scientific narrative and crosswalk, not the module or proof
architecture. A theorem belongs where its mathematical object and hypotheses belong,
regardless of which papers consume it. Paper namespaces may provide only thin,
source-faithful definitions or instantiations that cannot be stated honestly without the
paper contract.

New theorem families should be organized semantically:

1. `Foundations/` — finite matrix, group-action, special-orthogonal, and elementary
   optimization facts;
2. `Bloch/` — periodic fields, sewing, covariance, and aligned differences;
3. `Projection/` — ambient compression, retained projectors, spectral isolation,
   subspace residuals, and leakage;
4. `Alignment/` — finite-rank gauge actions, exact recovery, global/pointwise alignment,
   and reviewed Procrustes or Kabsch results;
5. `Fourier/` — finite Fourier transforms, Hermitian coefficient pairing, support,
   truncation, Parseval identities, and locality tails;
6. `Hilbert/` and `Geometry/` — Frobenius/spectral losses, admissible sets, compatibility,
   and metric separation;
7. `Decision/` — finite dominance, Pareto efficiency, threshold feasibility,
   minimum-cost selection, and empty-set classification;
8. `SpecialFunctions/` — analytic coefficient and tail estimates after conventions are
   fixed; and
9. `Certificates/` — exact or interval checkers, exhaustive coverage, and objective-mask
   soundness.

Theorem IDs and proof dossiers should follow those semantic families. New reusable
results should not receive `Ragasa2026A/B/C/D` IDs merely because one paper motivated
them. A paper crosswalk can cite the same semantic theorem from several papers.
Existing established IDs and propositions remain immutable; this rule governs new work
and any separately reviewed extraction of reusable prerequisites.

## Series architecture

The proposed division is:

| Paper | Primary question | Principal geometry |
|---|---|---|
| Ragasa2026A | Are spectral and operator fidelity compatible? | loss-space geometry |
| Ragasa2026B | Why does reduction generate nonlocality, and how does dimension affect it? | Fourier/support geometry |
| Ragasa2026C | How much gauge expressivity is required to recover a local multiband model? | alignment/gauge geometry |
| Ragasa2026D | Can the framework select a practical model from first-principles data? | certified oracle-to-local reduction |

The intended dependency is

\[
  \boxed{\text{A: compatibility}}
  \Longrightarrow
  \boxed{\text{B: locality}}
  \Longrightarrow
  \boxed{\text{C: gauge expressivity}}
  \Longrightarrow
  \boxed{\text{D: first-principles selection}}.
\]

This is a conceptual dependency, not a claim that later papers inherit the scientific or
formal status of earlier ones.

# Ragasa2026A — compatibility geometry

## Proposed thesis

> Spectral fidelity and aligned-operator fidelity define distinct admissible sets. Even
> in an exactly solvable rank-two reduction, a candidate can satisfy a spectral tolerance
> while remaining positively separated from every operator-faithful candidate.

The detailed plan is
[`Ragasa2026A/paper-and-proof-plan.md`](Ragasa2026A/paper-and-proof-plan.md), with the
complete diagnostic study in
[`Ragasa2026A/diagnostic-usefulness-study-plan.md`](Ragasa2026A/diagnostic-usefulness-study-plan.md).
The latter now audits all 46 registry entries against immutable producer fields; its
calibration, fault-injection, sensitivity, ablation, cost, and held-out phases remain
prospective.

The central decision is

\[
  \exists(\lambda,\phi):
  \quad L_E(\lambda,\phi)\le\tau_E,
  \qquad L_O(\lambda,\phi)\le\tau_O.
\]

## Publication-facing scientific scope

Ragasa2026A should present:

- exact reduction of the weighted spectral and Frobenius losses;
- exact second-harmonic correlation optimization;
- the canonical maximizing-angle convention;
- the two admissible-region geometries;
- exact intersection and separation formulas; and
- an exact or interval-certified spectral witness with positive operator separation.

The scientific point is not merely that two ellipses can be disjoint. It is that
optimization of retained eigenvalue agreement need not produce an operator-faithful
representation after the declared admissible alignment.

## Evidence required

A publishable result requires at least one immutable concrete instantiation containing:

1. frozen matrix or field data;
2. strict-positive weights fixed by an a-priori or certified optimized quadrature rule,
   plus the reference energy;
3. exact or outward-rounded bounds on `κ` and `μmax`;
4. a fixed candidate domain;
5. independently justified positive thresholds;
6. a checked positive spectral witness; and
7. a checked positive lower bound on operator separation.

A parameter region or perturbation-stability result is preferable to an isolated
one-point example. Cross-paper evidence acceptance is governed by
[`../publication-evidence-contract.md`](../publication-evidence-contract.md); arbitrary
or post-hoc evaluation weights are not eligible.

## Remaining high-value proof work

- smooth threshold-continuum result;
- operator-residual/hopping-weight identity;
- transported-frame covariance and attainment;
- persistence of strict separation under structured field perturbations beyond the
  checked scalar `(κ, μmax)` box; and
- binding a concrete immutable artifact to the generic certificate checker.

The current Paper A Lean layer supplies conditional exact mathematics and one checked
source-specific analytic certificate for the two-observation construction, including its
exact positive admissible-set distance and separation-resolution corollary. The joint
rational enclosure bridge supports simultaneous uncertainty in `κ` and `μmax`, with the
exact construction as a degenerate-`κ` regression. It supplies no
retained runtime certificate, calculated four-state-parent result, material validation, or
publication completion.

## Proposed positioning

**Exact compatibility geometry for spectral and operator fidelity in rank-two periodic
reductions.**

# Ragasa2026B — projection-induced locality and dimension

## Proposed thesis

> Spectral projection can convert a finite-range parent into a nonlocal reduced model,
> with support requirements governed by dimension, amplitude, symmetry, and the permitted
> complete-shell hierarchy.

Paper B should explain the origin and dimensional scaling of locality loss rather than
primarily studying higher-rank alignment expressivity. The detailed plan is
[`Ragasa2026B/paper-and-proof-plan.md`](Ragasa2026B/paper-and-proof-plan.md).

## Publication-facing scientific scope

Ragasa2026B should present:

- exact examples in which spectral projection destroys finite hopping support;
- multidimensional residual-to-locality identities;
- shell-resolved Fourier coefficients;
- analytic or factorial tail bounds;
- small-amplitude dimension laws;
- symmetry-complete support truncation; and
- finite shell–scale attainable decision sets.

Its central finite sampled object is

\[
  (N_{\mathrm{blocks}},\varepsilon_H,\varepsilon_E).
\]

## Attainability boundary

The paper must distinguish:

- a finite attainable nondominated set;
- a componentwise envelope assembled from different decisions;
- a rendered triangulation; and
- a continuum Pareto surface.

Only exhaustive enumeration of the declared finite inventory establishes the first.
Interpolation, convexification, or plot tessellation must not be promoted to attainability.

## Evidence required

1. exact analytic D2/D3 comparators;
2. frozen scale, shell, and momentum inventories;
3. objective values for every declared decision;
4. a checked nondominated mask;
5. mesh, scale-grid, and shell-cap refinement;
6. explicit treatment of discrete shell transitions; and
7. comparison between analytic tail predictions and finite sampled decisions.

Square and simple-cubic controls may be exact mathematical models. Graphene- and
silicon-inspired controls remain inspired comparators unless a separate material
calibration is established.

## Remaining proof work

- finite and, where source-justified, continuum multidimensional Fourier conventions;
- complete-shell and inversion-closure lemmas;
- projection-induced support-loss result;
- residual/tail identity;
- analytic tail bound and dimension-law corollary;
- finite weak-all/strict-any dominance;
- Pareto-mask soundness and completeness;
- interval-certified objective tables; and
- finite minimum-cost attainment.

## Proposed positioning

**Dimension-dependent nonlocality and support cost in spectrally projected lattice
models.**

# Ragasa2026C — higher-rank gauge expressivity

## Proposed thesis

> In composite-band reductions, locality depends not only on retained support but on the
> expressivity of the admissible gauge alignment. Global conjugation cannot alter
> unitary-invariant hopping tails, while sufficiently expressive momentum-dependent
> alignment can recover a compact reference representation.

The detailed scientific and proof plan is
[`Ragasa2026C/paper-and-proof-plan.md`](Ragasa2026C/paper-and-proof-plan.md).

## Relationship to Paper B

Paper B asks how projection creates and scales nonlocality. Paper C asks how much of that
nonlocality can be removed by an admissible higher-rank gauge. Paper C may use Paper B's
rank-two or low-rank locality laws as comparators but must not relabel them as new
higher-rank evidence.

## Publication-facing scientific scope

Ragasa2026C should present:

- retained rank `r ≥ 3`;
- noncommuting internal gauge circuits;
- identity, global, restricted, pointwise, and known-inverse alignment roles;
- exact fixed-reference alignment/locality decomposition;
- global-conjugation invariance of unitary-invariant hopping tails;
- rank/depth dependence of restricted alignment; and
- the normalized D1/D2/D3 `SO(r)` ladder.

The proposed shared core is

\[
  d\in\{1,2,3\},
  \qquad r\in\{3,4,8\},
  \qquad L\in\{1,2,4\},
\]

with the existing `r=16` and `L=8` cases retained as additional D1 scaling controls.

## Evidence required

Paper C needs independently verified findings about:

- minimum support versus rank;
- minimum support versus noncommuting depth;
- dimension dependence at normalized attack strength;
- restricted-alignment expressivity gaps;
- spectral/operator discordance; and
- persistence under construction, withheld-mesh, and refinement checks.

Exact equivalence and inverse recovery are controls, not empirical discoveries.

## Proposed positioning

**Gauge expressivity, operator fidelity, and hopping locality in composite-band
Hamiltonians.**

# Ragasa2026D — first-principles application

## Status

Ragasa2026D is a proposed direction only. No audited publication source, accepted title,
Lean placeholder, or paper-specific claim exists. The following design must remain
planning material until the owner repository creates and approves a source protocol. Its
detailed planning-only document is
[`Ragasa2026D/paper-and-proof-plan.md`](Ragasa2026D/paper-and-proof-plan.md).

## Proposed thesis

> A finite-support Wannier or tight-binding model should be selected by simultaneous
> spectral and aligned-operator fidelity to a retained first-principles reference, not by
> band plots alone.

## Operator architecture

The intended structure is

\[
  O_A\longrightarrow O_B\longrightarrow O_C,
\]

where

- `O_A` is a first-principles oracle operator;
- `O_B` is a retained spectral/projector bridge with gauge and sewing data; and
- `O_C` is a support-truncated local model aligned to `O_B`.

A candidate decision must use the same local model, support, and admissible alignment for
both fidelity channels.

## Minimum-cost decision

For a frozen finite inventory `D`, define

\[
  C^*(\tau_E,\tau_O)
  =\min\{C(d):d\in D,\ L_E(d)\le\tau_E,\ L_O(d)\le\tau_O\}.
\]

Potential decision coordinates include retained rank, energy window, disentanglement
choice, alignment family, localization controls, and Fourier support. Exhaustiveness may
be claimed only for the declared finite inventory.

## Required error budget

Keep separate:

\[
  e_{\mathrm{eig}},\quad
  e_{\mathrm{subspace}},\quad
  e_{\mathrm{align}},\quad
  e_{\mathrm{interp}},\quad
  e_{\mathrm{trunc}}.
\]

The total bound must state exactly how these terms compose. Sorted eigenvalues alone do
not supply the retained projector, gauge, or aligned operator needed for subtraction.

## Required proof work

- approximate frame-isometry checking;
- eigenpair residual-to-compression bounds;
- gap-dependent retained-projector/subspace perturbation;
- degeneracy-aware spectral-cluster comparison;
- equal-rank unitary alignment;
- later, unequal-rank isometric compression and explicit leakage;
- fixed-reference alignment/interpolation/truncation decomposition;
- finite minimum-cost selection; and
- interval-certificate and exhaustive-coverage soundness.

## Required computational evidence

The first application should use one controlled equal-rank isolated composite manifold,
not begin with the hardest disentanglement case. It requires:

1. frozen first-principles inputs and dependency revisions;
2. frozen eigenpair and projector exports;
3. frozen Wannier inputs and outputs;
4. construction and withheld momentum meshes;
5. a complete candidate-support inventory;
6. alignment and sewing diagnostics;
7. outward-rounded objective intervals;
8. independent verification;
9. one retained evidence package; and
10. scientific interpretation reported separately from certificate status.

Wannier90 may construct a witness but is neither a Lean dependency nor part of the formal
trusted base.

## Scientifically useful outcomes

A strong Paper D should demonstrate at least one of:

- visually accurate bands with inadequate aligned-operator fidelity;
- rejection of a smaller model that passes only the spectral threshold;
- a stable minimum-cost jointly adequate support;
- a measurable benefit from an admissible momentum-dependent gauge; or
- a stable difference operator that identifies omitted structure.

## Proposed positioning

**Certified joint-fidelity selection of Wannier tight-binding Hamiltonians from
first-principles calculations.**

# Shared formal infrastructure

Formal dependencies are organized by semantics, not by principal paper:

| Semantic family | Reusable content | Example paper consumers |
|---|---|---|
| `Geometry/` and `Hilbert/` | admissible sets, exact loss geometry, weighted Frobenius and spectral losses | A, C, D |
| `Projection/` | exact and approximate compression, retained projectors, isolation, leakage | B, C, D |
| `Alignment/` and `Bloch/` | gauge actions, sewing, aligned difference, exact and fitted recovery | A, C, D |
| `Fourier/` and `SpecialFunctions/` | inversion, Parseval, complete support shells, truncation, analytic tails | A, B, C, D |
| `Decision/` | finite dominance, Pareto masks, threshold feasibility, minimum cost | B, C, D |
| `Certificates/` | interval arithmetic, coverage, masks, and source-data binding | A, B, C, D |

Publication modules should remain thin, source-faithful consumers. They may introduce
paper-specific data structures or exact hypothesis bundles, but must not duplicate a
reusable proof merely to give it a paper label. Existing theorem IDs and propositions
must not be silently generalized, moved, or renamed to serve later papers.

# Recommended execution order

1. Bind one immutable Ragasa2026A runtime result to the existing exact checker; the
   separate analytic two-observation certificate is already checked.
2. Apply the implemented reusable finite Pareto and Fourier-tail layers to Paper B.
3. Retain one immutable Paper B bounded objective table and checked nondominated mask.
4. Complete Paper C's fail-closed D1 calculator and independent evidence contract in its
   owner repository.
5. Execute the normalized D1/D2/D3 `SO(r)` program after source review.
6. Add the common `τ_E`/`τ_O` decision layer as a separately reviewed extension.
7. Define Ragasa2026D only after a concrete owner protocol and first-principles target
   exist.

# Publication-readiness boundary

No paper is ready merely because its generic Lean theorems compile. For each paper report
separately:

- source fidelity;
- formal proof status;
- checked-certificate status;
- numerical evidence status;
- scientific applicability;
- novelty assessment; and
- publication status.

Analytic construction guarantees are not empirical findings. Finite-mesh results are not
continuum results. Inspired controls are not material parametrizations. Passing software
tests is not independent scientific verification.

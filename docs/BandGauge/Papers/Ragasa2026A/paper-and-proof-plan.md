# Ragasa2026A paper and proof plan

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19

## Status

This document records a proposed scientific, computational, and formalization program for
Ragasa2026A. It is not publication prose, a new theorem declaration, a checked
runtime publication certificate, numerical evidence, publication authorization, or a
claim that the paper is complete.

The authoritative declaration ledger is
[`../../../theorem-manifest.md`](../../../theorem-manifest.md). Current Paper A Lean
modules contain conditional source-specific instantiations and one exact checked analytic
two-observation construction; the generic proofs they consume remain owned by semantic
foundational modules. The construction is not runtime evidence or four-state-parent
validation.

## Source identity

The crosswalked owner source is:

- repository: `ksdft2effmass`;
- branch: `work/paper-3-higher-rank-extension`;
- commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`;
- path: `docs/publications/papers/Ragasa2026a/v3`.

The detailed file hashes and dirty-state limitations are recorded in
[`../../../source-audit.md`](../../../source-audit.md). Later dirty manuscript changes are
not part of this plan's source authority.

## Proposed paper thesis

> Spectral fidelity and aligned-operator fidelity define distinct admissible sets. In a
> controlled rank-two periodic reduction, a candidate may satisfy the spectral tolerance
> while remaining positively separated from every operator-faithful candidate.

The central feasibility question is

\[
  \exists(\lambda,\phi):
  \quad L_E(\lambda,\phi)\le\tau_E,
  \qquad L_O(\lambda,\phi)\le\tau_O.
\]

The paper should explain this incompatibility geometrically and bind at least one
immutable computational instance to an exact or conservative interval certificate.

## Mathematical setting

The publication-facing setting is the source's rank-two retained problem with:

- strict-positive normalized coordinate weights, kept general in the reusable theorem but
  determined a priori for every concrete publication instance;
- one global standard real rotation;
- momentum-dependent comparison alignment;
- weighted finite Frobenius loss with coefficient `αᵢ/(2E_ref²)`;
- weighted spectral loss on the same observations;
- a declared positive candidate domain; and
- the source's canonical angle convention in `[-π/2,π/2)`.

These hypotheses must not be strengthened, weakened, or generalized silently. The
immutable source leaves the general raw objective weights parametrized, so they remain
formal theorem inputs rather than eligible concrete evidence until a derivation rule is
frozen. The paper's constructed two-observation false positive is already equally
weighted and therefore has an a-priori `uniform-counting` specialization.

## Main analytic narrative

### Exact matrix-to-scalar bridge

The finite matrix residuals reduce to two scalar losses after exact centering,
normalization, and correlation extraction. The bridge must retain the source's Frobenius
norm and exact coefficients.

### Correlation harmonic

For the declared rank-two rotation, prove

\[
  b_\phi=b_0+c\cos(2\phi)+d\sin(2\phi),
\]

with

\[
  b_{\max}=b_0+\sqrt{c^2+d^2}.
\]

Use the canonical maximizing angle in `[-π/2,π/2)`. Do not claim uniqueness when
`c=d=0`.

### Admissible-set geometry

The spectral and optimized operator sublevel sets become explicit weighted ellipses in
the candidate coordinates. The principal exact results are:

- sublevel-set identities;
- nonemptiness conditions;
- exact full-plane intersection criterion;
- exact full-plane distance;
- candidate-rectangle transfer under explicit full-ellipse containment; and
- strict separation excluding a common witness.

### Certificate bridge

A successful exact rational or outward-rounded interval certificate must imply:

1. a positive-scale spectral witness in the declared candidate rectangle;
2. containment hypotheses required by the rectangle transfer; and
3. positive separation from the optimized operator pass set.

A generic or synthetic accepted certificate is not a checked publication certificate. The
source's exact two-observation analytic construction is now encoded and checked by
`BG-RAGASA2026A-DEF-022` through `BG-RAGASA2026A-DEF-025`,
`BG-RAGASA2026A-THM-029` through `BG-RAGASA2026A-THM-034`, and
`BG-RAGASA2026A-THM-036/037`, including the exact positive admissible-set distance and
resolution corollary. `BG-RAGASA2026A-THM-035` additionally binds simultaneous rational
intervals for field-derived `κ` and `μmax`; the exact construction regression-tests it at
`κ ∈ [1,1]`. These results remain distinct from a retained runtime package or a calculated
four-state-parent result.

## Computational scientific result still required

Beyond the checked analytic construction, the paper needs at least one immutable
source-bound computational instance containing:

1. frozen matrices or exact field-derived summaries;
2. frozen strict-positive weights derived by an accepted a-priori or certified optimized
   quadrature rule, plus the reference energy;
3. exact or outward-rounded bounds for `κ` and `μmax`;
4. a fixed candidate rectangle;
5. independently justified positive `τ_E` and `τ_O`;
6. a checked positive spectral witness; and
7. a checked positive lower bound on operator separation.

A robust open parameter region or interval perturbation result is preferable to a single
finely tuned point. Concrete weight, mesh, support, alignment, artifact-identity, and
fail-closed requirements are specified by
[`../../publication-evidence-contract.md`](../../publication-evidence-contract.md).
Weights tuned against the reported Paper A losses are not admissible evaluation weights.

The study of every premise, alignment, Fourier, spectral, decision, stability, and
evidence diagnostic is specified in
[`diagnostic-usefulness-study-plan.md`](diagnostic-usefulness-study-plan.md). Its
immutable producer-field audit is complete; the remaining prospective phases require
mathematical support, analytic calibration, controlled fault injection,
sensitivity analysis, predictive-value testing, redundancy ablation, cost accounting, and
a held-out confirmation inventory before any diagnostic is promoted as useful.

## Semantically organized proof dependencies

The paper label does not determine proof ownership. New reusable proofs belong in the
following semantic families:

| Semantic module family | Required content |
|---|---|
| `Foundations/` | rank-two real rotations, Pauli decomposition, second-harmonic optimization |
| `Bloch/` | sewing-compatible operator fields and admissible alignment pullback |
| `Hilbert/` | weighted Frobenius algebra, spectral residuals, polarization, unitary invariance |
| `Geometry/` | admissible sets, ellipse intersection, exact distance, rectangle transfer |
| `Fourier/` | later residual-to-hopping identities under reviewed finite or continuum conventions |
| `Certificates/` | rational and interval checks plus binding to immutable source summaries |

The existing `ProjectKoios.BandGauge.Papers.Ragasa2026A` declarations are thin
source-specific field and loss instantiations. Future reusable theorems should not receive
Paper A IDs merely because this paper first needs them. Existing theorem IDs and exact
propositions remain immutable.

## Remaining proof work

The highest-value unresolved theorem families are:

1. persistence of positive separation under structured field perturbations beyond the
   checked scalar `(κ, μmax)` box;
2. the source's smooth monotone threshold-continuum result;
3. the operator-residual/nonlocal-hopping identity under exact Fourier hypotheses;
4. transported-frame covariance and attainment with explicit regularity premises; and
5. runtime-data binding from an immutable artifact to the existing certificate checker.

The last item is a runtime checked-certificate boundary, not a proof that the
computational model is physically valid.

## Proposed manuscript structure

1. **Problem:** spectral and operator fidelity are distinct requirements.
2. **Rank-two reduction:** fields, rotations, weights, and exact losses.
3. **Harmonic optimization:** canonical maximizing angle and correlation bound.
4. **Compatibility geometry:** intersection, separation, and exact distance.
5. **Concrete certificate:** immutable inputs, rational intervals, witness, and lower
   bound.
6. **Interpretation:** what spectral success does and does not imply.
7. **Limitations:** rank two, finite observations, declared alignment family, and no
   automatic material validation.

Recommended figures are:

- the two admissible regions and their exact center/radius parameters;
- the compatibility/separation phase boundary;
- a certified witness and closest-set geometry;
- sensitivity of the separation margin to interval uncertainty; and
- where applicable, operator residual versus induced hopping weight.

## Publication-readiness criteria

Ragasa2026A is ready for a concrete scientific-result claim only when:

1. the source instance and thresholds are frozen at immutable revisions;
2. all strict-positive weight, domain, and containment assumptions are checked;
3. uncertainty is represented conservatively rather than as floating-point equality;
4. the certificate is accepted by a reviewed checker and independently reproduced;
5. no rank-two, finite-observation, or alignment-family conclusion is generalized beyond
   its hypotheses; and
6. formal proof, numerical evidence, scientific applicability, novelty, and publication
   status are reported separately.

The existing Lean theorems establish the exact source-specific analytic construction but
do not by themselves establish a runtime computational result, four-state-parent result,
material claim, or publication completion.

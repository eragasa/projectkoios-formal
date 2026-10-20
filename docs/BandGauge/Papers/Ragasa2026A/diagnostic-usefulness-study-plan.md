# Ragasa2026A diagnostic usefulness study plan

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19
**Producer-field audit completed:** 2026-10-20

## Status

This is a prospective study plan for the diagnostics used or promised by Ragasa2026A.
The immutable producer-field availability audit below is complete for the stated owner
commit; calibration, usefulness, ablation, cost, and held-out studies remain prospective.
This document is not a numerical result, retained evidence package, theorem inventory,
authorization to run a protected confirmatory calculation, or claim that any diagnostic
is useful.

The source basis is the immutable Paper A v3 claim-and-commitment inventory at owner
revision `99a46cb59d0c6f27ada7d709f194996ef9619d9f`, especially contracts M01–M15,
analytic results A01–A12, development results N01–N23, and verification commitments
V01–V10. Exact source identities and limitations are recorded in
[`../../../source-audit.md`](../../../source-audit.md).

The purpose is to determine, for every diagnostic:

1. what mathematical proposition it checks or estimates;
2. which scientific or computational failure it can detect;
3. whether it is necessary, redundant, explanatory, or misleading;
4. how stable it is under mesh, parameter, and roundoff perturbations;
5. whether it predicts or certifies a downstream adequacy decision; and
6. whether its information value justifies its computational and reporting cost.

## Primary decision being supported

The diagnostics should support, but must not be confused with, the final representation
decision. For candidate representation and cutoff `R_c`, the two principal questions are:

\[
  \varepsilon_H(R_c)\le\tau_H,
  \qquad
  \varepsilon_E(R_c)\le\tau_E.
\]

The same truncated representation must be used in both channels. Diagnostics may:

- establish that these quantities are meaningful;
- certify an upper or lower bound;
- explain a failure;
- predict a useful cutoff before full evaluation; or
- check implementation integrity.

A diagnostic is not automatically useful merely because it can be computed accurately.

## Diagnostic roles

Every diagnostic will be assigned exactly one primary role and any number of secondary
roles:

- **premise gate** — checks a condition required before downstream quantities are valid;
- **identity check** — checks an exact algebraic or transform identity;
- **certified bound** — gives a proved implication for a target quantity;
- **decision diagnostic** — directly enters a declared pass/fail or minimum-cost rule;
- **explanatory diagnostic** — helps attribute a result but does not certify it;
- **stability diagnostic** — measures sensitivity to discretization or implementation;
- **evidence-integrity diagnostic** — checks coverage, provenance, or independent
  reconstruction; or
- **presentation-only quantity** — may aid visualization but carries no decision authority.

A quantity must not move from explanatory to certified status without a theorem or
checked certificate establishing the implication.

# Diagnostic registry

The identifiers below are planning identifiers, not Lean theorem IDs.

## A. State-space and premise diagnostics

| ID | Diagnostic | Mathematical role | Intended failure detection |
|---|---|---|---|
| A-DIAG-P01 | minimum second-to-third spectral gap | premise for an isolated rank-two retained subspace | loss of external isolation or invalid rank-two interpretation |
| A-DIAG-P02 | minimum adjacent-frame overlap singular value | full-rank premise for neighbor Procrustes transport | near-singular or discontinuous sampled frame transport |
| A-DIAG-P03 | frame orthonormality defect `||F†F-I||` | isometry identity check | eigensolver, transport, or normalization corruption |
| A-DIAG-P04 | retained eigenpair/subspace residual | checks that the retained frame represents the declared parent eigenspace | wrong eigenvectors, ordering errors, or stale parent data |
| A-DIAG-P05 | retained-projector reconstruction defect | gauge-invariant subspace check | frame-dependent agreement hiding subspace disagreement |
| A-DIAG-P06 | endpoint holonomy before closure | explanatory transport diagnostic | accumulated reciprocal-boundary frame mismatch |
| A-DIAG-P07 | periodic-closure/sewing residual after closure | premise and identity check | failed distributed closure or boundary convention error |
| A-DIAG-P08 | Hermiticity defect of parent, retained, aligned, and reconstructed fields | exact structural identity check | transform signs, asymmetric truncation, or corrupted blocks |

Closure phases are sewing diagnostics only. They have no topological interpretation in
this study.

## B. Alignment and operator diagnostics

| ID | Diagnostic | Mathematical role | Intended use |
|---|---|---|---|
| A-DIAG-A01 | harmonic coefficients `(b0,c,d)` | sufficient statistics for global `SO(2)` correlation | exact optimizer reconstruction and degeneracy detection |
| A-DIAG-A02 | canonical maximizing angle | selected global alignment witness | reproducible optimizer with half-open interval convention |
| A-DIAG-A03 | `μmax` or maximized normalized correlation | controls the irreducible aligned residual | analytic comparison of gauge mismatch |
| A-DIAG-A04 | minimum aligned Frobenius residual | principal operator-alignment loss | operator fidelity and incompatibility |
| A-DIAG-A05 | irreducible operator floor | certified lower bound over the allowed global family | early exclusion of impossible operator thresholds |
| A-DIAG-A06 | onsite-block mismatch | separates local block disagreement from non-onsite power | attribution of exact-spectrum joint threshold |
| A-DIAG-A07 | excess non-onsite power | comparison-versus-reference locality cost | explanatory representation inefficiency |
| A-DIAG-A08 | transported-frame covariance defect | invariance/contract check | basis-coordinate dependence caused by inconsistent transport |
| A-DIAG-A09 | residual–tail deformation and cross term | tests departure from the flat-family equality | explains how parent dispersion changes the residual/locality relation |

For the flat analytic family, A-DIAG-A04/A05/A07 have exact relationships. For the
non-flat dispersive family, those equalities must not be assumed; their deformation is a
study object.

## C. Fourier and locality diagnostics

| ID | Diagnostic | Mathematical role | Intended failure detection or explanation |
|---|---|---|---|
| A-DIAG-F01 | conjugate-pairing defect `T(-R)-T(R)†` | Hermitian Fourier identity | sign, indexing, or support-pairing errors |
| A-DIAG-F02 | complete finite-transform reconstruction defect | discrete Fourier inversion check | normalization, representative, or phase convention errors |
| A-DIAG-F03 | Parseval defect | power-conservation identity | transform normalization or omitted-coefficient errors |
| A-DIAG-F04 | cyclic Nyquist conversion power | conversion-specific integrity check | centered-cyclic to ordinary-lattice mishandling |
| A-DIAG-F05 | non-onsite Fourier power | locality summary | redistribution of weight outside `R=0` |
| A-DIAG-F06 | omitted tail power at cutoff `R_c` | exact `L²` truncation quantity under Parseval | locality cost and analytic tail comparison |
| A-DIAG-F07 | retained block count and maximum support radius | representation cost | model complexity accounting |
| A-DIAG-F08 | interpolation matrix error | sampling/reconstruction channel | insufficient construction mesh |
| A-DIAG-F09 | deliberate truncation matrix error | support-reduction channel | insufficient cutoff at fixed interpolation |
| A-DIAG-F10 | total matrix error | end-to-end channel relative to the declared reference | combined interpolation and truncation consequence |

Interpolation, truncation, and total errors remain separate. Their scalar norms must not be
added as though the matrix errors were independent.

## D. Spectral and decision diagnostics

| ID | Diagnostic | Mathematical role | Intended use |
|---|---|---|---|
| A-DIAG-S01 | complete-field band-equivalence defect | exact gauge-equivalence check before truncation | attack/alignment or eigenvalue calculation errors |
| A-DIAG-S02 | truncated sorted-band error | primary spectral consequence | spectral tolerance decision |
| A-DIAG-S03 | Frobenius perturbation upper bound | certified upper bound for sorted-band error | verification and conservative screening |
| A-DIAG-S04 | Weyl saturation ratio | bound tightness diagnostic | determines whether the operator bound is informative |
| A-DIAG-S05 | first-passing Hamiltonian cutoff | finite decision under `τ_H` | operator-cost selection |
| A-DIAG-S06 | first-passing band cutoff | finite decision under `τ_E` | spectral-cost selection |
| A-DIAG-S07 | cutoff inflation between reference and comparison | representation-efficiency consequence | headline locality-cost comparison |
| A-DIAG-S08 | joint/common-witness cutoff | same-model two-channel decision | prevents combining separate best cutoffs |
| A-DIAG-S09 | prevalence of positive cutoff inflation over the frozen grid | bounded aggregate consequence | distinguishes a persistent sampled effect from one endpoint |
| A-DIAG-S10 | Hamiltonian-versus-band cutoff agreement | cross-channel comparison, not substitution | identifies when the two accuracy criteria happen to select the same cost |

A first-passing cutoff does not follow from monotonicity unless monotonicity is proved for
the exact diagnostic. The study must detect pass/fail re-entry at larger cutoffs and state
whether the decision means “first pass” or “all subsequent declared cutoffs pass.”

## E. Stability and evidence-integrity diagnostics

| ID | Diagnostic | Mathematical role | Intended use |
|---|---|---|---|
| A-DIAG-R01 | momentum-refinement change | discretization stability | identify mesh-sensitive objectives or decisions |
| A-DIAG-R02 | threshold-adjacent margin | decision robustness | distinguish resolved passes/failures from borderline cases |
| A-DIAG-R03 | predecessor-fails/selected-passes check | local cutoff minimality check | off-by-one and selection errors |
| A-DIAG-R04 | parent-scale and amplitude sensitivity | bounded parameter robustness | determine whether conclusions persist beyond one endpoint |
| A-DIAG-R05 | coordinate-disjoint evaluation check | construction/evaluation separation | accidental reuse of construction points |
| A-DIAG-R06 | independent truncation reconstruction difference | independent-control-flow integrity | shared producer logic or serialization defects |
| A-DIAG-R07 | schema, coverage, and digest checks | evidence integrity | omitted cases, mutated inputs, or malformed records |
| A-DIAG-R08 | dependency and environment identity | provenance | nonreproducible or unbound numerical output |
| A-DIAG-R09 | amplitude-interpolant validation error | method-admission diagnostic | rejects an amplitude interpolant that fails the prospective target |

Evidence-integrity diagnostics can establish that the declared calculation was performed
as recorded. They do not establish physical applicability.

## Source-result coverage map

The registry covers the Paper A claim inventory as follows:

| Source result | Registry coverage |
|---|---|
| N01 | complete band equivalence, A-DIAG-S01 |
| N02 | analytic minimum and joint thresholds, A-DIAG-A03–A06 |
| N03 | non-onsite power and finite tail, A-DIAG-F05/F06 |
| N04 | flat momentum refinement, A-DIAG-R01 |
| N05 | rejected amplitude interpolant, A-DIAG-R09 |
| N06 | sampled isolation and overlap qualification, A-DIAG-P01/P02 |
| N07 | dispersive complete bands and thresholds, A-DIAG-S01 and A-DIAG-A04/A05 |
| N08 | dispersive non-onsite power, A-DIAG-F05 |
| N09 | non-flat momentum refinement, A-DIAG-R01/R02 |
| N10 | sampled mismatch and excess-power persistence, A-DIAG-A04/A07 and A-DIAG-R04 |
| N11 | flat-identity deformation and cross term, A-DIAG-A09 |
| N12 | cutoff-specific band errors, A-DIAG-S02 and A-DIAG-F09/F10 |
| N13–N14 | first-passing cutoffs and inflation, A-DIAG-S05–S07 |
| N15 | prevalence of positive sampled inflation, A-DIAG-S09 |
| N16 | matrix-versus-band decision agreement, A-DIAG-S10 |
| N17 | cyclic conversion and interpolation, A-DIAG-F04/F08 |
| N18 | deliberate truncation decay, A-DIAG-F09 |
| N19 | perturbation-bound validity and saturation, A-DIAG-S03/S04 |
| N20 | refinement and threshold adjacency, A-DIAG-R01–R03 |
| N21 | independent truncation reconstruction, A-DIAG-R06 |
| N22 | frame, sewing, and transform closure, A-DIAG-P03/P06–P08 and A-DIAG-F01–F03 |
| N23 | separate retained scalar precursor; comparator for A-DIAG-R06–R08 only, not active rank-two evidence |

Contracts M02–M04 and M14–M15 motivate the premise registry; M07, A01–A03, and A10
motivate the alignment registry; M09–M13 and A07–A12 motivate the Fourier, spectral, and
decision registries; V01–V10 motivate the evidence-integrity registry. This crosswalk does
not upgrade any development result to retained evidence.

## Immutable producer-field audit

The following audit reads owner repository `ksdft2effmass`, branch
`work/paper-3-higher-rank-extension`, commit
`99a46cb59d0c6f27ada7d709f194996ef9619d9f` through immutable `git show` objects. The
currently checked-out owner worktree is on another branch and is substantially dirty; none
of those later tracked or untracked bytes are evidence for this table.

The abbreviated source paths are:

- `records.py` = `python/src/ksdft2effmass/analysis/model_adequacy/`
  `band_equivalence_locality/records.py`;
- `refinement_records.py` = the sibling reusable refinement-record module;
- `alignment.py`, `calculation.py`, and `fourier.py` = sibling reusable producer modules;
- `nonflat_results.py` and `serialization.py` = Paper A development-experiment modules
  below `experiments/model-adequacy/periodic1d/`
  `band-equivalence-versus-hopping-locality/src/band_equivalence_hopping_locality/`.

Classification is deliberately about producer availability, not scientific usefulness:

- **implemented** — the producer or verifier computes and stores a matching named field;
- **derived** — the diagnostic is deterministically recoverable from stored fields but has
  no matching named field;
- **hard-coded** — the reported diagnostic value is only a literal or frozen constant,
  rather than a computed output;
- **missing** — the immutable output does not store enough information for the diagnostic;
- **ambiguous** — fields exist, but their scope or semantics do not match the registry
  entry closely enough for an unqualified mapping.

No registry item is classified solely as hard-coded. Frozen meshes, tolerances, and
parameter grids are inputs to several computed diagnostics, not substitutes for their
values. Totals are 31 implemented, eight derived, four missing, and three ambiguous.
These statuses do not imply retained execution, schema validity, numerical verification,
formal checking, or scientific applicability.

### State-space and premise producer fields

| ID | Classification | Immutable producer field or derivation | Audit note |
|---|---|---|---|
| A-DIAG-P01 | implemented | `PointDiagnostic.minimum_sampled_external_gap` (`records.py:66`); `continuous_external_gap_lower_bound` at line 67 | Sampled and analytic-lower-bound channels remain distinct. |
| A-DIAG-P02 | implemented | `PointDiagnostic.minimum_sampled_transport_singular_value` (`records.py:76`) | `minimum_seed_overlap` is separately stored at line 68. |
| A-DIAG-P03 | implemented | `PointDiagnostic.maximum_frame_orthonormality_defect` (`records.py:71`) | Maximum sampled defect, not a continuum statement. |
| A-DIAG-P04 | implemented | `maximum_eigensystem_reconstruction_defect` and `maximum_parent_retained_reconstruction_defect` (`records.py:70,73`) | Two stored reconstruction channels cover eigensystem and retained-parent consistency. |
| A-DIAG-P05 | implemented | `maximum_projector_reconstruction_defect` (`records.py:72`) | Gauge-invariant projector check is explicit. |
| A-DIAG-P06 | implemented | `maximum_absolute_closure_holonomy_phases` and `maximum_closure_holonomy_unitarity_defect` (`records.py:84–85`) | Phases are sewing diagnostics only. |
| A-DIAG-P07 | implemented | `maximum_periodic_frame_closure_defect` (`records.py:75`) | Post-closure residual is distinct from the pre-closure holonomy. |
| A-DIAG-P08 | ambiguous | `maximum_parent_hermiticity_defect` and reference/comparison ordinary Fourier Hermiticity defects (`records.py:69,110–111`) | No single field resolves all four requested parent, retained, aligned, and reconstructed stages. |

### Alignment and operator producer fields

| ID | Classification | Immutable producer field or derivation | Audit note |
|---|---|---|---|
| A-DIAG-A01 | missing | no output field; `alignment.py:204–210` computes offset, cosine, and sine coefficients only as transient locals | The optimizer uses the coefficients, but a retained result cannot reconstruct or audit them directly. |
| A-DIAG-A02 | implemented | `restricted_global_rotation_angle` and `restricted_global_rotation_degenerate` (`records.py:91–92`) | Stores the selected angle and its degeneracy disposition. |
| A-DIAG-A03 | implemented | `finite_mesh_maximum_correlation`, `analytic_flat_correlation`, and `analytic_correlation_remainder_bound` (`records.py:94–96`) | Finite and analytic channels are explicitly separate. |
| A-DIAG-A04 | implemented | `minimum_operator_threshold` and `restricted_global_rotation_residual` (`records.py:98,103`) | The producer stores both names for the aligned residual quantity. |
| A-DIAG-A05 | derived | square `minimum_operator_threshold`; normalized form is `normalized_squared_operator_residual` (`records.py:102`) | There is no separately named unnormalized irreducible-floor field. |
| A-DIAG-A06 | missing | no onsite-block difference field; only `reference_onsite_power` and `comparison_onsite_power` (`records.py:116–117`) | A difference of scalar powers is not the onsite-block mismatch norm. |
| A-DIAG-A07 | implemented | `excess_nonzero_hopping_weight` and normalized counterpart (`records.py:120–121`) | Direct locality-cost output. |
| A-DIAG-A08 | implemented | `maximum_covariant_defect` (`records.py:88`) | Stored maximum sampled covariance discrepancy. |
| A-DIAG-A09 | ambiguous | `flat_identity_departure` and `flat_residual_tail_identity_defect` (`records.py:122,125`) | Departure is stored, but deformation and cross term are not separately exposed. |

### Fourier and locality producer fields

| ID | Classification | Immutable producer field or derivation | Audit note |
|---|---|---|---|
| A-DIAG-F01 | implemented | reference/comparison twisted-Nyquist and ordinary Hermiticity defects (`records.py:108–111`) | Cyclic Nyquist and ordinary conjugate pairing remain separate. |
| A-DIAG-F02 | implemented | reference/comparison Fourier reconstruction defects (`records.py:104–105`); parent reconstruction at line 74 | Complete finite-transform reconstruction is explicit. |
| A-DIAG-F03 | implemented | reference/comparison Parseval defects (`records.py:106–107`) and per-shell truncation Parseval defects (`records.py:37–38`) | Both complete and truncation identities are stored. |
| A-DIAG-F04 | implemented | `reference_nyquist_power` and `comparison_nyquist_power` (`records.py:123–124`) | Conversion power is not treated as spectral error. |
| A-DIAG-F05 | implemented | `reference_nononsite_power` and `comparison_nononsite_power` (`records.py:118–119`) | Direct locality summaries. |
| A-DIAG-F06 | implemented | per-shell reference/comparison omitted and total-omitted powers (`records.py:33–36`) | Ordinary omission and Nyquist-inclusive total omission are distinct. |
| A-DIAG-F07 | implemented | `ShellDiagnostic.retained_blocks` and `shell_index` (`records.py:25–26`) | In this 1-D producer the shell index is the declared integer support radius. |
| A-DIAG-F08 | implemented | `PointDiagnostic.reference_interpolation` and `comparison_interpolation` (`records.py:112–113`) | Each is an `ErrorChannels` record with matrix and band components. |
| A-DIAG-F09 | implemented | per-shell `reference_truncation` and `comparison_truncation` (`records.py:27–28`) | Deliberate truncation is isolated from total error. |
| A-DIAG-F10 | implemented | per-shell `reference_total` and `comparison_total` (`records.py:29–30`) | Total errors remain matrix-valued computations summarized by separate norms. |

### Spectral and decision producer fields

| ID | Classification | Immutable producer field or derivation | Audit note |
|---|---|---|---|
| A-DIAG-S01 | implemented | `PointDiagnostic.maximum_direct_band_defect` (`records.py:87`) | Complete-field sampled equivalence check. |
| A-DIAG-S02 | implemented | `ErrorChannels.maximum_band` nested in every shell truncation and total channel (`records.py:17,27–30`) | Sorted-band maximum and RMS remain separate. |
| A-DIAG-S03 | implemented | `ErrorChannels.maximum_hamiltonian` (`records.py:15`), computed as the maximum normalized Frobenius error in `fourier.py:60–72` | It supplies the recorded perturbation upper-bound value; the theorem is external to the producer. |
| A-DIAG-S04 | derived | `maximum_band / maximum_hamiltonian` from the selected `ErrorChannels` record | Zero-denominator disposition must remain explicit. |
| A-DIAG-S05 | implemented | reference/comparison Hamiltonian shell fields in `FirstPassingDecision` (`records.py:48–49`) | Passing and preceding errors are also stored. |
| A-DIAG-S06 | implemented | reference/comparison band shell fields in `FirstPassingDecision` (`records.py:46–47`) | Passing and preceding errors are also stored. |
| A-DIAG-S07 | derived | comparison first-passing shell minus reference first-passing shell | Must be derived separately for matrix and band channels. |
| A-DIAG-S08 | derived | first shell in `shell_diagnostics` satisfying both declared channel thresholds | It must be scanned from the common shell ledger; taking separate minima is not valid without monotonicity. |
| A-DIAG-S09 | derived | count positive S07 values over the complete frozen point inventory | No aggregate prevalence field is stored. |
| A-DIAG-S10 | derived | equality comparison of Hamiltonian and band first-passing shell fields | Agreement is a comparison, not authority to substitute one channel for the other. |

### Stability and evidence-integrity producer fields

| ID | Classification | Immutable producer field or derivation | Audit note |
|---|---|---|---|
| A-DIAG-R01 | implemented | change and stability fields in `BandEquivalenceLocalityRefinementPair` (`refinement_records.py:16–33`) | Includes objective, reconstruction, Parseval, final-outcome, and first-passing stability. |
| A-DIAG-R02 | derived | tolerance minus passing/preceding errors in `FirstPassingDecision` (`records.py:45,50–57`) | The signed margin is not stored by name. |
| A-DIAG-R03 | implemented | passing and preceding error fields (`records.py:50–57`) plus explicit verifier comparisons in `calculation.py:1287–1355` | Verifier checks selected pass and predecessor failure. |
| A-DIAG-R04 | derived | compare `PointDiagnostic` outputs across stored `parent_scale` and `amplitude` (`records.py:64–65`) and midpoint records | No one aggregate sensitivity field covers both axes. |
| A-DIAG-R05 | implemented | `CaseDiagnostic.construction_evaluation_minimum_separation` (`records.py:215`) | Direct coordinate-disjointness output. |
| A-DIAG-R06 | missing | no independent truncation-reconstruction result or verifier field in the immutable tree | `records.py:238–240` independently probes the parent and complete-field band relation, not every declared truncation cutoff. |
| A-DIAG-R07 | ambiguous | `serialization.py:74–173` supplies strict schema IDs and SHA-256 bindings for the smooth-continuum records only | At the audited commit, non-flat and truncation schemas and a complete coverage manifest are absent from the immutable tree despite broader manuscript wording. |
| A-DIAG-R08 | missing | no dependency-lock, executable, platform, or environment identity field in the audited Paper A result records | Repository lockfiles are not retained execution identity. |
| A-DIAG-R09 | implemented | `SmoothFourStateAmplitudeValidationResult.maximum_*_defect`, failure count, and disposition (`nonflat_results.py:348–354`) | Validation rejects the interpolant when the prospective targets fail. |

# Mathematical support plan

## M1. Premise and frame theory

Develop reusable semantic results in `Projection/`, `Bloch/`, and `Alignment/`:

1. an exact retained-subspace/isometry contract;
2. isolation-gap conditions for a rank-two spectral cluster;
3. invertible adjacent overlap implies a unique polar/Procrustes factor under the
   reviewed hypotheses;
4. transported-frame orthonormality;
5. endpoint closure and sewing preservation;
6. projector invariance under internal gauge; and
7. gauge-invariant versus frame-dependent diagnostic classification.

For approximate eigensolver data, residual and gap estimates should yield a conservative
projector/subspace bound. That extension is separate from the existing exact
noncomputable spectral decomposition.

## M2. Alignment theory

Reuse or extend semantic results in `Foundations/`, `Hilbert/`, and `Geometry/`:

1. exact second-harmonic form of the global `SO(2)` correlation;
2. canonical maximizing-angle attainment;
3. degeneracy behavior when the harmonic amplitude vanishes;
4. exact aligned Frobenius residual expansion;
5. the irreducible operator floor;
6. transported-frame covariance; and
7. robustness of the floor and maximizing correlation under interval uncertainty.

This layer identifies which alignment diagnostics are exact sufficient statistics and
which are merely numerical summaries.

## M3. Fourier/locality theory

Develop reusable results in `Fourier/`:

1. finite transform inversion with the source exponent and normalization;
2. centered-cyclic representative and Nyquist semantics;
3. Hermitian conjugate pairing;
4. Parseval for matrix Frobenius power;
5. exact full-minus-truncated tail identity;
6. preservation of Hermiticity under conjugate-closed truncation;
7. decomposition of interpolation, truncation, and total matrix errors; and
8. constant-basis covariance versus momentum-dependent convolution.

For the flat family, prove the residual/non-onsite-power identity and the separation into
non-onsite and onsite mismatch. For non-flat parents, do not assert equality; derive any
valid remainder or cross-term identity explicitly.

## M4. Spectral consequence theory

Use finite Hermitian perturbation results to prove

\[
  \max_j |\lambda_j(A)-\lambda_j(B)|
  \le \lVert A-B\rVert_2
  \le \lVert A-B\rVert_F.
\]

Record the normalization used by the reported band error. Prove only implications that
hold at degeneracy; do not attach physical meaning to individual eigenvector labels.

Study which matrix-error summaries provide valid upper bounds for the chosen maximum or
RMS spectral diagnostic. A tightness ratio is explanatory; the upper bound itself is the
certified object.

## M5. Finite decision theory

Develop reusable results in `Decision/`:

1. exact definition of first pass over a finite ordered cutoff inventory;
2. existence and uniqueness conditions for a selected cutoff;
3. distinction between first pass and persistent pass;
4. common-witness selection for simultaneous matrix and band criteria;
5. minimum-cost attainment on a finite inventory;
6. threshold-margin robustness; and
7. unresolved status when the support cap is exhausted.

No convexity, KKT condition, or continuum interpolation is required for these finite
results.

## M6. Certificate theory

Develop checker soundness in `Certificates/` for:

- premise gates and signed margins;
- exact identity residual intervals;
- objective intervals;
- threshold-adjacent decisions;
- complete cutoff, amplitude, parent-scale, and momentum coverage; and
- independent reconstruction agreement.

An interval overlapping zero or a threshold is unresolved unless the relevant exact
identity is established symbolically.

# Computational usefulness test plan

## C0. Freeze before evaluation

Before computing usefulness scores, freeze:

- diagnostic formulas, units, and normalization;
- which diagnostics are premise gates versus explanatory quantities;
- parent-scale and attack-amplitude inventories;
- construction and disjoint evaluation meshes;
- cutoff inventory and prospective expansion rule;
- numerical tolerances and equality policy;
- injected fault families;
- usefulness criteria; and
- development versus held-out evaluation cases.

Changing these after observing results creates a new study version.

## C1. Analytic flat-family calibration

Use the flat family because several target values are known analytically:

- exact complete spectral equivalence;
- `μmax=J₀(2a)`;
- exact global residual/non-onsite-power identity;
- exact joint-threshold decomposition;
- known Fourier/Bessel coefficient structure.

For each diagnostic, measure:

1. absolute and relative numerical error against analytic truth;
2. convergence with momentum mesh;
3. validity of every claimed upper or lower bound;
4. bound slack;
5. threshold-decision agreement; and
6. roundoff plateau.

This phase validates meaning and implementation. It does not establish usefulness for
dispersive parents.

## C2. Controlled dispersive study

Use the declared four-state parent over a prospectively frozen grid of:

- parent dispersion scales;
- attack amplitudes;
- momentum levels;
- cutoffs; and
- independently shifted evaluation meshes.

Retain every decision, including failures and unresolved cases. Measure:

- gap and overlap margins;
- frame and sewing defects;
- alignment residual and correlation;
- non-onsite and omitted-tail power;
- interpolation, truncation, and total errors;
- band errors and Weyl slack;
- first and persistent passing cutoffs; and
- reference/comparison cutoff inflation.

The objective is to determine which diagnostics continue to explain or bound the actual
cutoff decisions after the flat identities no longer hold exactly.

## C3. One-fault-at-a-time injection

Construct development-only corrupted cases with known faults:

1. eigenvector phase/sign discontinuity;
2. retained-state permutation;
3. near-singular adjacent overlap;
4. wrong endpoint closure;
5. incorrect Fourier exponent sign;
6. incorrect transform normalization;
7. centered-index or Nyquist mishandling;
8. missing conjugate hopping block;
9. asymmetric support truncation;
10. wrong rank or energy normalization;
11. stale alignment applied to a different parent;
12. reuse of construction points as the evaluation mesh;
13. omitted cutoff or amplitude records; and
14. mutated serialized inputs or digests.

For each fault, record:

- diagnostics expected to fail;
- diagnostics actually failing;
- earliest pipeline stage detecting it;
- any downstream false pass; and
- whether another diagnostic already detects the same fault more cheaply.

A premise-gate usefulness claim requires reliable detection of its target fault before
downstream scientific output is admitted.

## C4. Perturbation and sensitivity study

Apply bounded perturbations separately to:

- parent entries;
- eigenpair residuals;
- frame coordinates;
- alignment angle;
- Fourier blocks;
- thresholds; and
- interval widths.

For deterministic bounded perturbations, compute worst observed response and compare it
to proved Lipschitz or perturbation bounds where available. For randomized roundoff/noise
stress, freeze the distribution, seed family, and sample count; treat the result as a
software stress test, not exact evidence.

Diagnostics that change discontinuously near a legitimate degeneracy or threshold must
report a margin or unresolved state rather than a bare Boolean.

## C5. Predictive usefulness

The principal prediction targets are:

- `ε_H(R_c)`;
- `ε_E(R_c)`;
- first-passing and persistent-passing cutoffs;
- cutoff inflation; and
- whether the finite hierarchy is jointly adequate.

Evaluate each non-gate diagnostic by:

1. **coverage:** how often a claimed bound actually contains the target; certified bounds
   require complete coverage;
2. **slack:** ratio or difference between the bound and target;
3. **decision agreement:** agreement with the full declared cutoff evaluation;
4. **early-exclusion value:** fraction of candidates safely rejected without full
   evaluation;
5. **ranking value:** ability to order candidate supports without reversing certified
   comparisons;
6. **stability:** decision invariance under required refinement; and
7. **incremental value:** improvement after diagnostics with the same role are already
   included.

Empirical correlation alone does not make a diagnostic a certificate.

## C6. Redundancy and ablation

Evaluate nested diagnostic sets:

1. premise gates only;
2. premise gates plus exact identities;
3. plus alignment summaries;
4. plus Fourier-tail summaries;
5. plus matrix perturbation bounds;
6. plus full spectral evaluation; and
7. plus evidence-integrity checks.

A diagnostic is redundant for the primary decision if removing it changes neither valid
case admission, failure localization, certified bounds, decisions, nor interpretation
across the frozen test inventory. It may still be retained as a cheap independent audit.

Do not remove diagnostics solely because they are correlated: two diagnostics based on
independent identities may provide valuable defense against common implementation faults.

## C7. Computational-cost accounting

For each diagnostic record:

- asymptotic operation count where meaningful;
- measured time and peak memory;
- required source arrays;
- whether it forces eigenvalue recomputation;
- whether it can be streamed;
- serialization size; and
- independent-verifier cost.

Report information value relative to cost, but never remove a theorem-premise gate because
it is inconvenient.

## C8. Held-out confirmation

After development and classification, freeze a held-out inventory not used to tune
thresholds or diagnostic definitions. Re-run:

- all premise gates;
- retained diagnostic subset;
- full target objectives;
- independent verifier; and
- decision comparison.

This remains development evidence until a separately authorized retained calculation is
executed under frozen version/run/package identities.

# Diagnostic usefulness classification

Each diagnostic receives one final classification:

- **mandatory gate** — required to make downstream results meaningful;
- **mandatory identity audit** — checks a distinct exact implementation invariant;
- **certified decision bound** — proved and sufficiently resolved for screening or
  selection;
- **useful explanatory diagnostic** — stable and adds distinct attribution, without
  certification authority;
- **supplementary/redundant audit** — correct and inexpensive but not independently
  informative for the main decision;
- **development-only stress diagnostic** — useful for implementation testing but not
  publication evidence; or
- **remove/redefine** — unstable, ambiguous, duplicative without audit value, or liable to
  misleading interpretation.

The classification record must cite mathematical support, frozen computational tests,
failure cases, cost, and residual limitations.

# Prospective acceptance criteria

A diagnostic is retained in the primary paper only if at least one of the following is
shown prospectively:

1. it checks a unique theorem premise;
2. it detects a declared failure not reliably caught by cheaper retained diagnostics;
3. it supplies a mathematically valid and practically resolved bound;
4. it changes or robustly predicts the joint adequacy decision;
5. it provides stable, nonredundant scientific attribution; or
6. it is necessary for independent evidence integrity.

It is demoted to the supplement when it is useful mainly for audit completeness. It is
removed or redefined when it lacks a precise mathematical interpretation, is unstable
under required refinement, or encourages a stronger conclusion than it supports.

# Planned outputs

The study should produce:

1. a versioned diagnostic registry with formulas, units, and roles;
2. a theorem-to-diagnostic support matrix;
3. a fault-to-diagnostic detection matrix;
4. analytic flat-family calibration tables;
5. dispersive sensitivity and refinement tables;
6. bound coverage and slack summaries;
7. cutoff-decision and ablation comparisons;
8. computational cost accounting;
9. a final retain/demote/remove classification; and
10. a compact paper-facing diagnostic table separated from the complete audit ledger.

None of these outputs should be called retained publication evidence until the owner
repository freezes and executes the corresponding evidence lifecycle under separate
authorization.

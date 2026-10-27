# Ragasa2026C paper and proof plan

This plan defines the unimplemented Paper C program.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

This is a proposed program. `ProjectKoios.BandGauge.Papers.Ragasa2026C` is a zero-statement metadata placeholder.

## Sources

Publication source:

- Repository: `ksdft2effmass`
- Branch: `work/paper-3-higher-rank-extension`
- Commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`
- Path: `docs/publications/papers/Ragasa2026c/v1`

Later planning source:

- Branch: `work/paper-3-d1-calculator`
- Commit: `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`
- Path: `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex`
- SHA-256: `160b61b2c2dc87e7628524c710c779f8e3b2c547f0a2d228615300aa06bdce0b`

The later worktree was dirty: the protocol and sibling README had uncommitted science edits, while the inspected Python implementation matched the immutable commit. The committed protocol remains the stable planning source and does not replace the publication source.

## Thesis

Spectral agreement alone does not establish an operator-faithful local reduced Hamiltonian. Required support depends on gauge expressivity, retained rank, gauge complexity, and spatial dimension.

The operational question is:

\[
\min C(d)\quad\text{subject to}\quad L_E(d)\le\tau_E,\;L_O(d)\le\tau_O.
\]

The paper requires computed, independently verified rank/depth/dimension findings. Analytic controls alone are insufficient.

## Model hierarchy

The hierarchy separates projector, gauge, and alignment effects.

### P0 constant-projector control

Use a shared constant retained projector and a diagonal retained field `D_r(k)`. This isolates alignment and Fourier/locality behavior from projector transport.

### G0 exact inverse recovery

Use the exact pointwise inverse of the imposed gauge as a control. For full-rank overlap in P0, the polar factor must recover that inverse.

### Alignment ladder

Compare:

1. identity;
2. one global fitted unitary;
3. pointwise complete-unitary polar/Procrustes alignment;
4. the exact inverse construction control when defined; and
5. a later structured finite-depth restricted family under a separately frozen protocol.

All methods must use the same parent field, retained rank, sampling, Fourier convention, support rule, and loss normalization. Alignment families have separate attainable sets; the known inverse is a construction oracle, not an attainable fitted decision.

The inspected source generates attacks in `SO(r)` but fits some channels over `U(r)`. A genuine `SO(r)` experiment requires a separately reviewed special-orthogonal Procrustes or Kabsch selector, determinant-`+1` checks, uniqueness conditions, and fail-closed degeneracy handling. It must not silently relabel a unitary solver.

## Dimension ladder

Each dimension requires native owner-side evidence. The proposed shared core is `r ∈ {3, 4, 8}` and gauge-circuit depth `L ∈ {1, 2, 4}`.

- **D1:** orientation, exact recovery, finite Fourier conversion, truncation, and regression controls. Existing `r = 16` and `L = 8` cases remain scaling controls.
- **D2:** orthogonal square lattice, complete inversion-symmetric shells, and axis-exchange controls.
- **D3:** simple-cubic lattice, complete shells, and permutation controls.

D2/D3 claims require native owner-side cases; they cannot be inferred from D1.

Do not compare shell indices directly across dimensions. Compare retained block count, physical support radius, normalized omitted weight, and both loss channels. Freeze an attack-strength normalization such as generator power, maximum generator norm, or integrated gauge gradient before inspection so dimension does not change perturbation strength silently.

## Required records

Each case must retain:

- stable case identity and full input definition;
- dimension, rank, depth, mesh, seed, and gauge family;
- source and target frames/projectors;
- overlap singular values and isolation gaps;
- alignment matrices and unitarity residuals;
- transport and endpoint-sewing diagnostics;
- raw and aligned operator fields;
- Fourier coefficients and support masks;
- per-channel untruncated references;
- truncation residuals and normalized losses;
- failure disposition for every declared case; and
- software, dependency, and platform provenance.

The protocol requires equal raw sample and aggregate weights. A different weighting rule requires a new source review and theorem specialization.

## Diagnostics

Required invariants include:

- projector and frame consistency;
- unitarity of each alignment;
- singular-gap or isolation conditions;
- exact P0/G0 recovery where expected;
- forward/inverse Fourier reconstruction;
- zero omitted tail at full support;
- monotonicity under nested support; and
- endpoint sewing or explicit failure.

Channel-specific truncation losses must use each channel's own untruncated field. Cross-channel normalization changes the scientific question.

For the publication operator decision, also retain the fixed-reference decomposition

\[
O_C-O_B=e_{\mathrm{trunc}}+e_{\mathrm{interp}}+e_{\mathrm{align}}.
\]

Channel-relative truncation measures compressibility, while the fixed-reference total prevents a moving reference from hiding alignment error. For one momentum-independent unitary, Fourier conversion and truncation commute with conjugation, so unitary-invariant locality tails cannot distinguish identity from global alignment; that is an analytic control, not an empirical discovery.

## Decision layer

For each rank, depth, dimension, and alignment method, determine the first common support satisfying both thresholds. Separate spectral and operator first-passing supports do not form a common witness.

The current D1 protocol does not yet freeze this common-threshold result contract. Empty outcomes must distinguish unavailable alignment, failure of each individual channel, disjoint individually nonempty channels, and exhaustion of only the declared bounded hierarchy.

Exact equivalence, fixed-unitary invariance, P0/G0 recovery, and inverse recovery are controls. They must not be reported as empirical rank, depth, or dimension findings.

## Formal support

Implemented reusable support:

- finite-rank sewing and alignment covariance;
- fixed-unitary Fourier equivariance;
- finite Fourier inversion, Parseval, and residual tails;
- weighted Frobenius and operator-loss algebra;
- finite Pareto and threshold semantics; and
- exact checkers for finite objective tables.

Missing or unbound:

- owner schema and strict serializer;
- exact alignment-family completeness statement;
- interval objective certificates;
- external case-coverage proof;
- retained D1/D2/D3 evidence; and
- paper-specific Lean declarations.

## Production gate

Before evidence can be promoted, the owner implementation must:

1. freeze schemas and canonical serialization;
2. reject unknown fields and nonfinite values;
3. preserve every declared case and failure;
4. separate producer and verifier;
5. retain hashes and exact provenance;
6. verify analytic controls independently; and
7. bind exact or outward-rounded certificate data to a precise Lean proposition.

Schema-free development summaries are not production evidence.

## Nonclaims

No current declaration proves a rank/depth/dimension result, a first common cutoff, D2/D3 behavior, runtime correctness, material applicability, novelty, release, or publication readiness.

# Ragasa2026C paper and proof plan

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19

## Status

This document records a proposed scientific, computational, and formalization program for
Ragasa2026C. It is not publication prose, a theorem declaration, a checked certificate,
a numerical result, an authorization to execute or publish, or a claim that the paper is
complete.

The authoritative Lean declaration ledger remains
[`../../../theorem-manifest.md`](../../../theorem-manifest.md). The paper namespace
`ProjectKoios.BandGauge.Papers.Ragasa2026C` remains a zero-statement metadata placeholder.

## Source identities and limitations

The publication source currently crosswalked by this repository remains:

- owner repository: `ksdft2effmass`;
- branch: `work/paper-3-higher-rank-extension`;
- commit: `99a46cb59d0c6f27ada7d709f194996ef9619d9f`;
- publication path: `docs/publications/papers/Ragasa2026c/v1`.

A later read-only planning inspection used:

- branch: `work/paper-3-d1-calculator`;
- commit: `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`;
- protocol path:
  `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex`;
- protocol SHA-256 at that commit:
  `160b61b2c2dc87e7628524c710c779f8e3b2c547f0a2d228615300aa06bdce0b`.

The later owner worktree was dirty: the protocol and sibling README had uncommitted
science-only edits, while the inspected Python implementation matched the immutable
commit. The committed protocol is therefore the stable planning source. The later
inspection does not replace the publication source revision already recorded in the
paper placeholder.

## Proposed paper thesis

The proposed central claim family is:

> Spectral agreement alone is insufficient to establish an operator-faithful local
> reduced Hamiltonian. The tight-binding support required for joint spectral and operator
> fidelity depends on admissible gauge expressivity, retained rank, gauge complexity, and
> spatial dimension.

The operational question is:

\[
  \text{What is the least expensive local representation satisfying}
  \quad L_E\le\tau_E\quad\text{and}\quad L_O\le\tau_O?
\]

The analytic constructions, exact recovery channels, and formal proofs support this
question. They are not by themselves the principal scientific result. The paper requires
computed, independently verified rank/depth/dimension findings.

## Operator architecture

The current source does not use `O_A`, `O_B`, and `O_C` labels. The following is an
explicit planning interpretation of its equations.

### Ambient oracle

\[
  O_A(k)=H_p(k),
\]

acting on an ambient space of dimension `2r`.

### Retained spectral reference

For retained frame `F(k)`,

\[
  O_B(k)=F(k)^\dagger O_A(k)F(k)=K_{\mathrm{ret}}(k).
\]

The D1 P0/G0 specialization uses the diagonal field `D_r(k)`.

### Gauge-attacked representation

For internal gauge `G(k)`,

\[
  O_G(k)=G(k)^\dagger O_B(k)G(k).
\]

This has the same untruncated spectrum and retained projector as the reference.

### Aligned local model

For admissible right action `U(k)` and retained Fourier support `S`,

\[
  \widehat O_U(k)=U(k)^\dagger O_G(k)U(k),
\]

\[
  O_C^{U,S}(k)=\operatorname{Trunc}_S\!\left(\widehat O_U\right)(k).
\]

The local tight-binding-type model is the support-truncated reconstruction, not merely the
untruncated gauge attack.

## Central error decomposition

The fixed-reference operator difference is

\[
  \Delta_{U,S}=O_C^{U,S}-O_B.
\]

It decomposes as

\[
  O_C^{U,S}-O_B
  =
  \underbrace{O_C^{U,S}-\widehat O_U}_{\text{locality/truncation}}
  +
  \underbrace{\widehat O_U-O_B}_{\text{alignment/representation}}.
\]

With a finite-mesh full interpolant, retain the further split

\[
  O_C-O_B
  =e_{\mathrm{trunc}}+e_{\mathrm{interp}}+e_{\mathrm{align}}.
\]

The current protocol's channel-relative total error measures interpolation plus
truncation relative to each channel's own untruncated field. It is a compressibility
measure. The later `τ_O` decision must use the fixed-reference total above so that global
alignment residual is not hidden by a moving reference.

## Alignment hierarchy

The current source channels have these scientific roles:

1. identity/no-alignment baseline;
2. one global fitted alignment;
3. pointwise complete fitted alignment;
4. known inverse-gauge construction oracle; and
5. later restricted-circuit fitted alignment.

Each alignment family has its own attainable decision set. They are not pooled into one
Pareto set. The known inverse is not an attainable fitted decision.

### Real-gauge program

The proposed first scientific ladder is

\[
  d=1\ \mathrm{SO}(r)
  \longrightarrow
  d=2\ \mathrm{SO}(r)
  \longrightarrow
  d=3\ \mathrm{SO}(r),
\]

initially with constant projector P0 and shared core

\[
  r\in\{3,4,8\},
  \qquad
  L\in\{1,2,4\}.
\]

The existing `r=16` and `L=8` cases remain additional D1 scaling controls.

The source currently generates attacks in `SO(r)` but fits the global and pointwise
channels over `U(r)`. A genuine `SO(r)` expressivity experiment requires separately
reviewed special-orthogonal Procrustes/Kabsch selection, determinant `+1` checks,
uniqueness conditions, and fail-closed degeneracy handling. This must be an explicit
protocol amendment or new version, not a silent relabeling of the unitary solver.

## Dimension controls

### D1

D1 establishes orientation, exact recovery, finite Fourier conversion, truncation,
refinement, and the evidence pipeline.

### D2

The first D2 control should use an orthogonal square lattice and require:

- active wavevectors spanning both reciprocal directions;
- at least one mixed harmonic;
- `x` and `y` sewing/link families;
- two primitive closures and the `xy` plaquette;
- complete inversion-closed Euclidean support shells.

### D3

The first D3 control should use a simple-cubic lattice and require:

- active wavevectors spanning all three directions;
- mixed harmonics;
- `x`, `y`, and `z` sewing/link families;
- three primitive closures and `xy`, `xz`, and `yz` plaquettes;
- complete inversion-closed three-dimensional shells;
- streamed computation within a prospective resource gate.

### Cross-dimensional fairness

Do not compare shell indices across dimensions. Report retained block count, physical
support radius, normalized omitted weight, operator error, and spectral error.

The attack must be normalized prospectively across dimensions. A reviewed design must
hold fixed an interpretable quantity such as total generator power, maximum generator
norm, or integrated squared gauge gradient. Otherwise increasing dimension also
silently increases perturbation strength.

Evaluation weights must likewise be determined before inspecting candidate fidelity.
The immutable D1 protocol already makes equal raw sample and aggregate weights mandatory,
so the immediate Paper C program uses exact uniform counting. A later nonuniform mesh
would require a separately reviewed geometric, moment-exact, or certified optimized
quadrature rule. Weights optimized directly against candidate losses are design variables
and must not replace the fixed evaluation measure.

## Analytic results for the paper

The main paper should emphasize a small number of explanatory propositions.

### Retained-subspace construction

Prove frame isometry, projector identities, exact parent compression, parent-spectrum
union, and the declared exterior-isolation bound.

### Gauge equivalence

Prove projector preservation, Hermiticity, and untruncated spectral preservation under
the internal gauge.

### Exact recovery

Prove that the known inverse recovers the reference frame and operator exactly, and that
the full-rank pointwise overlap in P0 has polar factor equal to that inverse.

### Alignment/locality decomposition

Prove the fixed-reference decomposition separating alignment, interpolation, and
truncation errors.

### Global-conjugation invariance

For momentum-independent unitary `U`, prove

\[
  T_{U^\dagger H U}(R)=U^\dagger T_H(R)U
\]

and that support truncation commutes with this conjugation. Consequently block Frobenius
norms, omitted Frobenius weight, channel-relative truncation error, and corresponding
spectral errors are unchanged.

This explains why identity and global-alignment locality fronts coincide under the
source's unitary-invariant channel-relative objectives. It is an analytic result, not a
numerical discovery. The fixed-reference alignment residual must remain separate.

### Spectral consequence

Use the finite Hermitian perturbation bound

\[
  \max_i|\lambda_i(A)-\lambda_i(B)|
  \le\lVert A-B\rVert_2
  \le\lVert A-B\rVert_F.
\]

## Computational findings required for a paper

The paper is not complete unless independently verified calculations answer questions
such as:

1. How does minimum support vary with retained rank?
2. How does it vary with noncommuting gauge-circuit depth?
3. How does it change from D1 to D2 to D3 at fixed normalized attack strength?
4. How much alignment expressivity is required before joint fidelity becomes attainable?
5. Which models are spectrally accurate but operator-inaccurate?
6. Which sampled Pareto branches persist under construction and withheld-mesh refinement?
7. Does a restricted alignment family leave a reproducible positive fidelity gap?

The exact source identities and inverse-recovery channels are controls. They must not be
reported as empirical discoveries.

## Fidelity decision layer

For every attainable decision `d`, retain

\[
  E(d)=L_E(d),
  \qquad
  O(d)=L_O(d),
  \qquad
  C(d)=\text{retained representation cost}.
\]

For independently justified positive tolerances,

\[
  F(\tau_E,\tau_O)
  =\{d:E(d)\le\tau_E\land O(d)\le\tau_O\}.
\]

If this set is nonempty, report

\[
  C^*(\tau_E,\tau_O)
  =\min_{d\in F(\tau_E,\tau_O)}C(d).
\]

Prospective tie-breaking should prefer threshold margin, alignment simplicity,
refinement stability, and difference-operator stability in a declared order.

If the set is empty, distinguish unavailable alignment, empty spectral channel, empty
operator channel, disjoint individually nonempty channels, and exhaustion of only the
declared bounded hierarchy. Where defined, report

\[
  \tau_O^{\mathrm{req}}(\tau_E)
  =\min\{O(d):E(d)\le\tau_E\}.
\]

This is a requirement diagnostic, not permission to alter frozen thresholds after
inspection.

The current D1 protocol does not yet contain this common-threshold decision. It belongs
in a separately reviewed protocol version or companion experiment.

## Semantically organized proof dependencies

The detailed reusable proof program is maintained in
[`../../higher-rank-composite-band-formalization-plan.md`](../../higher-rank-composite-band-formalization-plan.md).
Paper C is a consumer of that program, not its module hierarchy. Reusable theorems should
be placed according to mathematical meaning:

| Semantic module family | Required content |
|---|---|
| `Foundations/` | special-orthogonal and Givens algebra |
| `Projection/` | ambient compression, retained projectors, and exterior isolation |
| `Bloch/` | sewing, covariance, and aligned-difference fields |
| `Alignment/` | gauge action, exact recovery, and reviewed global/pointwise `SO(r)` alignment |
| `Fourier/` | finite inversion, Hermitian pairing, Parseval, support, and truncation tails |
| `Hilbert/` and `Geometry/` | fixed-reference losses, perturbation bridges, and admissible sets |
| `Decision/` | finite dominance, Pareto masks, common thresholds, and minimum cost |
| `Certificates/` | interval objective tables, exhaustive coverage, and mask soundness |

The dependency order is:

1. ambient compression and exterior isolation;
2. special-orthogonal Givens membership;
3. projector and untruncated spectrum preservation;
4. aligned-difference typing, Hermiticity, and sewing;
5. exact inverse and pointwise recovery;
6. global-conjugation/Fourier/truncation commutation;
7. finite Fourier inversion, Hermitian pairing, Parseval, and tail identities;
8. fixed-reference error decomposition;
9. Hermitian spectral perturbation bounds;
10. exact finite sampled dominance and Pareto-mask correctness;
11. common-threshold and minimum-cost results for the later decision layer; and
12. interval and exhaustive-coverage certificate soundness.

Paper-specific declarations should be limited to exact source contracts or thin
instantiations. Standard group, spectral, Fourier, norm, and finite-order facts are
supporting mathematics, not paper novelty.

## Computational implementation prerequisites

Before retained D1 evidence, the owner implementation must at minimum:

- reject failed alignment integrity before downstream calculation;
- represent explicit alignment-integrity and oracle-integrity failure dispositions;
- gate represented Hermiticity and Fourier inventory identities;
- check the parent-to-retained compression identity;
- retain signed margins for analytic isolation and attack-angle controls;
- replace hard-coded evaluation-noninfluence assertions by a checkable record;
- implement source claim-resolution outputs;
- provide strict schemas and canonical serialization;
- bind the a-priori weight rule and explicit support semantic class;
- provide an independent direct-formula verifier; and
- bind provenance, digests, resources, and no-overwrite retained evidence.

The schema-free development calculator and replaceable local summaries do not satisfy
these retained-evidence obligations.

The scientific protocol and the implementation/evidence contract should be separate
sibling documents. Removing software detail from the scientific protocol must not delete
the evidence contract. The formal sidecar's acceptance requirements are frozen in
[`../../publication-evidence-contract.md`](../../publication-evidence-contract.md); that
document does not replace the owner repository's production schema.

## Proposed manuscript structure

1. **Motivation:** spectral equivalence does not imply operator-faithful locality.
2. **Operator architecture:** ambient parent, retained reference, gauge attack, aligned
   local model.
3. **Analytic propositions:** exact equivalence, fixed-reference decomposition, global
   invariance, exact recovery, and spectral perturbation.
4. **Experimental design:** D1/D2/D3 `SO(r)` rank/depth ladder and alignment hierarchy.
5. **Results:** per-family fronts, minimum-support maps, rank/depth/dimension trends, and
   refinement.
6. **Interpretation:** spectral, operator, gauge, and locality expressivity remain
   distinct.
7. **Limitations:** synthetic controls, finite meshes, trivial global bundles, and no
   material validation.

Recommended primary figures are:

- the `O_A → O_B → O_C` pipeline;
- the alignment-expressivity hierarchy;
- minimum-support maps `(τ_E,τ_O) ↦ C*`;
- normalized D1/D2/D3 rank/depth comparisons;
- spectral-versus-operator scatter highlighting discordant models; and
- construction/withheld/refinement stability.

Long proofs, convention tables, shell inventories, certificate formats, and Lean
crosswalks belong in appendices or formal supplements.

## Later DFT/Wannier90 extension

Only after the analytic synthetic pipeline is qualified should a later protocol replace
the analytic retained reference by low-eigenpair and Wannier90-produced witnesses:

```text
DFT oracle O_A
  -> retained eigenpairs/projector and Wannier gauge O_B
  -> support-truncated tight-binding O_C.
```

The upstream bridge then requires eigenpair residual, retained-rank, subspace,
disentanglement, gauge, sewing, and withheld spectral reconstruction checks. Wannier90
produces witnesses; successful convergence is not itself proof of the required fidelity.

## Publication readiness criteria

Ragasa2026C is ready for a scientific-result claim only when:

1. the scientific protocol and evidence contract are frozen at immutable revisions;
2. the `SO(r)` versus `U(r)` alignment-family choice is explicit;
3. the relevant dimension ladder is independently verified;
4. retained objective tables and Pareto masks have complete provenance;
5. the reported rank/depth/dimension effects pass prospective resolution and refinement
   rules;
6. analytic construction guarantees are not mislabeled as empirical findings;
7. finite-mesh conclusions are not promoted to continuum statements; and
8. formal, numerical, source-fidelity, and scientific-validation statuses are reported
   separately.

The Lean formalization may support these claims but does not by itself make the paper
publishable or validate a material model.

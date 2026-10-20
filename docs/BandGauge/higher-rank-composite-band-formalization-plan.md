# Higher-rank composite-band formalization plan

## Status and source boundary

This is a planning document, not a theorem inventory, numerical result, or scientific
validation claim. Existing declaration status remains exclusive to
[`../theorem-manifest.md`](../theorem-manifest.md).

The source inspected for this plan is:

- repository: `ksdft2effmass`;
- branch: `work/paper-3-d1-calculator`;
- immutable commit: `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`;
- path:
  `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex`.

The inspected owner worktree is dirty. Its protocol and sibling README have uncommitted
science-only edits, while the Python implementation is byte-identical to the immutable
commit. Consequently the immutable committed protocol, not the dirty file, is the only
stable source identity recorded here. Later source edits require a new audit.

The source protocol does **not** use `O_A`, `O_B`, and `O_C` labels, and it does not define
a `τ_E`/`τ_O` common-admissible-set decision. The operator labels below are an explicit
planning interpretation of the source equations, not a quotation or source claim.

## Source-defined multi-band experiment

For retained rank `r ≥ 3`, the source uses an ambient space of dimension `2r`, a retained
frame `F(k)`, a retained operator `K_ret(k)`, an exterior operator `D_ext(k)`, and an
ambient unitary `W(k)`. It defines

\[
  F(k)=W(k)E_r,
\]

\[
  H_p(k)=W(k)
  \begin{pmatrix}
  K_{\mathrm{ret}}(k)&0\\
  0&D_{\mathrm{ext}}(k)
  \end{pmatrix}
  W(k)^\dagger,
\]

with exact identities

\[
  F^\dagger F=I_r,
  \qquad
  P=FF^\dagger,
  \qquad
  F^\dagger H_pF=K_{\mathrm{ret}}.
\]

An internal gauge `G(k) ∈ U(r)` gives the attacked frame and represented operator

\[
  C(k)=F(k)G(k),
  \qquad
  H_C(k)=G(k)^\dagger K_{\mathrm{ret}}(k)G(k).
\]

The projector and untruncated spectrum remain exactly unchanged:

\[
  CC^\dagger=P,
  \qquad
  \operatorname{spec}H_C=\operatorname{spec}K_{\mathrm{ret}}.
\]

A declared right action `U(k)` aligns candidate coordinates:

\[
  \widehat F_U(k)=C(k)U(k),
  \qquad
  \widehat H_U(k)=U(k)^\dagger H_C(k)U(k).
\]

Alignment is applied before Fourier conversion and truncation.

## Interpretive oracle/bridge/local-model decomposition

The requested three-object design can be layered over the source without changing its
mathematics:

```text
O_A = H_p                         ambient parent/oracle operator
  │ compression through F
  ▼
O_B = F† H_p F = K_ret            retained spectral reference
  │ internal gauge G and admissible recovery U
  ▼
Ō_U = U† G† O_B G U               aligned represented field
  │ finite Fourier transform and support truncation S
  ▼
O_C(U,S)                          local tight-binding-type approximation
```

Thus the tight-binding-type object is not merely the untruncated gauge attack. It is the
support-restricted Fourier reconstruction of an aligned represented field. The exact
source special case uses `K_ret = D_r`, a diagonal retained field with exact support
`|R| ≤ 2` before the nonlinear gauge attack.

For an independently constructed local model rather than a truncation of the source
field, the state-space, rank, basis, sewing, and alignment contract must be supplied
again. Rank mismatch is not unitary gauge equivalence and belongs to a separate isometric
compression and leakage design.

## Alignment families in the source

The committed D1 P0/G0 protocol compares four source-defined channels:

1. **identity:** no alignment;
2. **one global Procrustes unitary:** selected on the final construction mesh and reused;
3. **pointwise complete-unitary Procrustes alignment:** reconstructed independently at
   every construction point; and
4. **known inverse-gauge oracle:** the analytic inverse of the generating attack, used as
   a construction control rather than an attainable fitted decision.

The exact P0 construction makes the pointwise Procrustes and analytic inverse channels
coincide analytically. They remain separate numerical consistency channels. A future
restricted-circuit fit is explicitly outside D1 v1.

These alignment families must remain separate feasible sets. Their support-error points
must not be pooled into one Pareto set.

## Source-defined scientific question

The present Paper 3 protocol asks how retained rank, noncommuting gauge-circuit depth,
alignment family, and later spatial dimension change:

- frame and operator recovery;
- gauge-induced hopping tails;
- errors from deliberate support truncation;
- sampled support--operator-error--spectral-error Pareto membership;
- mesh refinement behavior; and
- finite rank/depth trends.

It does so while the untruncated retained spectrum and projector are exactly equivalent by
construction. This isolates representation and locality effects from parent-model error.

The source does not currently ask whether spectral and operator admissible sets intersect
at `τ_E` and `τ_O`. A later threshold-decision layer may query the resulting objective
table, but it is a new reviewed extension and must not be attributed to D1 v1.

## Finite Fourier and error channels

For the declared finite construction mesh, the source defines complete discrete hopping
blocks and support-truncated reconstructions. For every alignment channel and support it
keeps separate

\[
  e_{\mathrm{interp}}=H_{\mathrm{full}}-H_{\mathrm{direct}},
\]

\[
  e_{\mathrm{trunc}}=H_{\mathrm{truncated}}-H_{\mathrm{full}},
\]

\[
  e_{\mathrm{total}}=H_{\mathrm{truncated}}-H_{\mathrm{direct}},
\]

with the exact decomposition

\[
  e_{\mathrm{total}}=e_{\mathrm{interp}}+e_{\mathrm{trunc}}.
\]

The finite transform, finite aliasing/interpolation error, and deliberate support
truncation are distinct. A finite mesh does not establish continuum Fourier decay.

For each fixed rank, depth, and applicable alignment family, every declared support gives
an attainable objective point

\[
  \bigl(
    |\Omega_S|,
    \varepsilon_H^{\mathrm{total}}(S),
    \varepsilon_E^{\mathrm{total}}(S)
  \bigr).
\]

Weak improvement in every coordinate and strict improvement in at least one defines the
source sampled-Pareto rule. Plot triangulation is not interpolation or a continuum front.

## Optional later fidelity decision

After the D1 objective table is correctly produced and verified, a separately reviewed
decision layer may define

\[
  \varepsilon_E(d)\le\tau_E,
  \qquad
  \varepsilon_O(d)\le\tau_O
\]

for the **same** attainable decision `d`, followed by minimum support cost. That layer
would support nonempty-intersection selection, empty-intersection diagnosis, and
requirement curves. Its tolerances require independent scientific authority; they are not
present D1 controls.

## Wannier90 boundary

The D1 source supplies analytic frames and explicitly does not execute Wannier90. Its
purpose is to isolate parent construction, gauge attack, alignment, Fourier conversion,
and truncation before algorithm-selected localization is introduced.

A later protocol may replace the analytic retained frame by a low-eigenpair or
Wannier90-produced retained frame. That future extension would need separate certificates
for:

- eigenpair residuals and retained-subspace identity;
- disentanglement and rank;
- gauge matrices and sewing;
- oracle-to-retained reconstruction;
- full Wannier Fourier reconstruction; and
- support truncation.

Wannier90 would remain an external witness producer, not a Lean dependency or trusted
runtime.

## Proof program

### 1. Parent and retained-subspace construction

Prove the frame-isometry, projector, rank, compression, parent-spectrum union, and
exterior-isolation implications of the declared block construction. Keep exact analytic
construction separate from approximate numerical eigenpair residuals.

### 2. Internal gauge equivalence

Prove that a unitary internal gauge preserves the retained projector and untruncated
spectrum, and that the represented field has the source conjugation orientation.

### 3. Aligned difference semantics

For a supplied admissible alignment, define

\[
  \Delta_U(k)=K_{\mathrm{ret}}(k)-U(k)^\dagger H_C(k)U(k).
\]

Prove that the difference is well typed, Hermitian, and sewn under the corresponding
source hypotheses. This is the reusable operator-comparison layer.

### 4. Exact recovery controls

For the P0 construction, prove that the known inverse gauge recovers both the reference
frame and retained operator. Under the required full-rank overlap hypothesis, prove the
pointwise polar/Procrustes recovery statement with the exact right-action orientation.
The numerical SVD remains external.

### 5. Finite Fourier and truncation

Freeze the source finite index group, centered representatives, signs, normalization, and
inverse. Prove inversion, conjugate/Hermitian pairing, Parseval, nested-support tail
monotonicity, and the full-minus-truncated tail identity.

### 6. Error decomposition and spectral bounds

Prove the interpolation/truncation/total matrix identity and the selected finite Hermitian
perturbation inequalities

\[
  \max_i|\lambda_i(A)-\lambda_i(B)|
  \le \|A-B\|_2
  \le \|A-B\|_F.
\]

### 7. Finite sampled Pareto classification

Formalize exact weak-all/strict-any dominance, nondominance, per-channel separation, and
soundness/completeness of a claimed finite nondominated mask. Prove explicitly that a
componentwise envelope need not be attainable.

### 8. Exact certificate boundary

A future compact certificate should bind every declared rank, depth, construction mesh,
alignment disposition, support, withheld-mesh objective, refinement diagnostic, and
Pareto flag. It must satisfy
[`publication-evidence-contract.md`](publication-evidence-contract.md), including an
a-priori or certified optimized quadrature rule, explicit support semantics, canonical
artifact identity, and fail-closed rejection behavior. Outward-rounded rational intervals
certify floating results; threshold overlap remains unresolved.

## Repository placement

No new broad source tree is required.

| Concern | Intended owner |
|---|---|
| sewing-compatible pullback and aligned difference | `ProjectKoios/BandGauge/Bloch/` |
| retained compression and reconstruction | `ProjectKoios/BandGauge/Projection/` |
| finite transform, support, Parseval, and truncation | `ProjectKoios/BandGauge/Fourier/` |
| admissible losses and finite Pareto statements | `ProjectKoios/BandGauge/Geometry/` |
| exact interval, coverage, and Pareto-mask checkers | `ProjectKoios/BandGauge/Certificates/` |
| Paper 3 bindings | a thin future Paper 3 module under `ProjectKoios/BandGauge/Papers/` |

The calculator, independent verifier, serializers, schemas, Wannier90 invocation, and
production evidence packages belong to the owner computational repository. The formal
acceptance requirements are frozen here, but they are not the owner's machine-readable
schema. This repository may check only compact exact certificates through an explicit
soundness boundary.

## Staged implementation

1. Freeze exact Lean statements against the committed D1 source, not its dirty worktree.
2. Add aligned-difference closure and exact internal-gauge recovery results.
3. Add only the finite Fourier identities required by D1.
4. Audit the owner calculator against the committed protocol before binding any output.
5. Formalize the exact finite Pareto rule and certificate coverage.
6. Bind one immutable, independently verified D1 result only after the owner serializer,
   schema, verifier, and retained-evidence route exist.
7. Add `τ_E`/`τ_O`, approximate eigenpair, unequal-rank, Wannier90, or continuum layers
   only through separately reviewed protocols.

## Nonclaims

This plan does not establish that:

- the current development calculator satisfies the full committed protocol;
- a schema-free development summary is retained scientific evidence;
- the finite mesh controls the continuum Brillouin zone;
- a successful alignment is unique outside the declared full-rank family;
- the analytic D1 frames validate Wannier90 behavior;
- a sampled Pareto set is a continuous frontier; or
- proposed tolerances are scientifically justified.

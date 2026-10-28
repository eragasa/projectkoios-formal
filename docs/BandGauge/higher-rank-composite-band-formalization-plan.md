# Higher-rank composite-band formalization plan

This plan translates one immutable owner protocol into reusable formal layers. It is not a theorem, numerical result, or scientific validation claim.

## Source

The plan uses one immutable protocol revision.

- Repository: `ksdft2effmass`
- Branch: `work/paper-3-d1-calculator`
- Commit: `8bafdeeb6b0c75bcd7a2984d0c283a8e64fb0fd8`
- Path: `experiments/periodic-reduction/higher-rank-composite-band-alignment-and-locality/experimental-protocol.tex`

The owner worktree was dirty: the protocol and sibling README had uncommitted science edits, while the Python implementation matched the immutable commit. Only the committed protocol is a stable source.

The source does not use the labels `O_A`, `O_B`, `O_C` or define a common `τ_E`/`τ_O` decision. Those labels are planning interpretations.

## Source experiment

For retained rank `r ≥ 3`, ambient dimension `2r`, frame `F(k)`, retained operator `K_ret(k)`, exterior block `D_ext(k)`, and ambient unitary `W(k)`, the protocol defines

\[
F(k)=W(k)E_r,
\qquad
H_p(k)=W(k)
\begin{pmatrix}K_{\mathrm{ret}}(k)&0\\0&D_{\mathrm{ext}}(k)\end{pmatrix}
W(k)^\dagger.
\]

It requires

\[
F^\dagger F=I_r,
\qquad
P=FF^\dagger,
\qquad
F^\dagger H_pF=K_{\mathrm{ret}}.
\]

An internal gauge `G(k) ∈ U(r)` gives

\[
C(k)=F(k)G(k),
\qquad
H_C(k)=G(k)^\dagger K_{\mathrm{ret}}(k)G(k).
\]

Then `CC† = P` and the untruncated spectrum is unchanged. A right action `U(k)` aligns the candidate:

\[
\widehat F_U(k)=C(k)U(k),
\qquad
\widehat H_U(k)=U(k)^\dagger H_C(k)U(k).
\]

Alignment precedes Fourier conversion and support truncation.

## Planning decomposition

The labels below are an explicit planning interpretation.

```text
O_A = H_p                          ambient parent
  │ compression through F
  ▼
O_B = F† H_p F = K_ret             retained reference
  │ internal gauge G and recovery U
  ▼
Ō_U = U† G† O_B G U                aligned represented field
  │ finite Fourier transform and support S
  ▼
O_C(U,S)                           local approximation
```

`O_C` is the support-restricted Fourier reconstruction, not the untruncated attacked field. The exact P0 source case uses diagonal `K_ret = D_r` with support `|R| ≤ 2` before the nonlinear gauge attack.

An independently constructed local model must separately supply state-space, rank, basis, sewing, and alignment contracts. Rank mismatch is isometric compression with leakage, not unitary gauge equivalence.

## Alignment classes

The committed D1 P0/G0 protocol compares:

- identity;
- one global Procrustes unitary selected on the construction mesh and reused;
- pointwise complete-unitary Procrustes alignment; and
- the known inverse gauge as a construction control, not an attainable fitted decision.

In P0 the pointwise Procrustes and inverse channels coincide analytically but remain separate numerical consistency channels. A structured finite-depth restricted-circuit fit is future work outside D1 v1.

The formal layer encodes singleton, identity, global-unitary, and complete pointwise-unitary families explicitly. Feasibility transfers from a smaller family to a larger family only through a proved inclusion. Explicit nonidentity constant and two-point unitary witnesses show that converse transfer fails in general. Structured restricted-circuit families and their Pareto sets remain separate future contracts.

## Reusable theorem layers

Four layers separate finite algebra from owner evidence.

### Frame and projector algebra

This layer fixes the retained subspace.

- `F†F = I` implies `P = FF†` is a projector.
- Right-unitary frame action preserves `P`.
- Compression transforms by conjugation.

### Alignment and loss

This layer fixes gauge action and comparison.

- Right-action convention and covariance.
- Frobenius loss invariance under one common unitary.
- Fixed-unitary Fourier equivariance.
- Explicit noncommutation boundary for momentum-dependent gauges.

### Fourier and truncation

This layer fixes finite representation cost.

- Finite inversion and Parseval.
- Matrix Frobenius residual-tail identity.
- Complete support masks and nested-support monotonicity.
- Hermitian pairing for negation-closed supports.

### Decision layer

This layer selects one common passing model.

- One common support must satisfy both spectral and operator thresholds.
- First-passing and minimum-cost statements are relative to a complete declared finite family.
- Missing or failed cases remain explicit.

The source D1 protocol does not define this `τ_E`/`τ_O` common-threshold question. It is a later reviewed decision layer whose tolerances need independent scientific authority.

## Finite error and attainability boundary

For each alignment channel and support, keep

\[
e_{\mathrm{interp}}=H_{\mathrm{full}}-H_{\mathrm{direct}},\qquad
e_{\mathrm{trunc}}=H_{\mathrm{truncated}}-H_{\mathrm{full}},
\]

and

\[
e_{\mathrm{total}}=H_{\mathrm{truncated}}-H_{\mathrm{direct}}
=e_{\mathrm{interp}}+e_{\mathrm{trunc}}.
\]

Finite aliasing or interpolation and deliberate support truncation are distinct. A finite mesh does not establish continuum Fourier decay.

Each declared support gives one attainable cost/operator/spectral objective point. Weak-all and strict-any dominance applies only to the complete declared finite table. A componentwise envelope, plot interpolation, or triangulation need not be attainable and is not a continuum Pareto front.

## Implemented support

Current reusable modules cover finite sewing, reference-minus-aligned-candidate operator differences and their sewing closure, rectangular complex frames, ambient projectors, compression/reconstruction, right-unitary retained-coordinate covariance, explicit identity/global/complete alignment-family semantics and strict-separation witnesses, finite Fourier algebra, weighted Frobenius losses, fixed-unitary equivariance, exact character-phase mode shifts, scalar-conjugation triviality, pointwise-unitary coefficient-change and Frobenius boundaries, finite decisions, reduction bases, spin-independent projection, spin Pauli residuals, folding, and route identities.

They do not bind the owner protocol's runtime arrays or prove its case coverage.

## Missing obligations

Eight obligations remain outside current proofs.

1. Source-faithful binding of owner frame arrays to the exact finite-frame and projector API.
2. Exact contracts for the structured local alignment family.
3. Endpoint sewing and polar-conditioning hypotheses.
4. Complete support hierarchy for D1/D2/D3.
5. Strict owner schema and canonical serialization.
6. Independent verifier and retained evidence.
7. Exact or outward-rounded objective certificates.
8. Thin paper-specific bridge after the reusable layer is stable.

Wannier90 is absent from D1. A later owner protocol using it must separately check retained rank, eigenpair and subspace residuals, gauge, sewing, disentanglement, and withheld reconstruction. It remains an external witness producer, not a Lean dependency or trusted runtime.

## Formalization order

Work proceeds from abstract frames to retained evidence. The first two reusable algebra steps are implemented; owner-specific binding remains external.

1. Freeze the finite-rank frame API and right action. *(implemented source-neutrally)*
2. Prove projector and compression covariance. *(implemented source-neutrally)*
3. Encode identity, global-unitary, and complete pointwise-unitary alignment families. *(implemented source-neutrally; structured restricted-circuit families remain open)*
4. Connect aligned fields to finite Fourier truncation.
5. Add common-threshold decision semantics.
6. Freeze the owner certificate schema.
7. Verify one retained case family independently.
8. Add source-specific instantiations and dossiers.

## Nonclaims

This plan does not establish continuum regularity, topology, Chern integrality, phase unwrapping, Wannier obstruction, Wannier90 behavior, runtime correctness, rank/depth/dimension findings, material applicability, or publication readiness.

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

### Later implementation-oriented inspection

A later read-only inspection examined the broader mathematical implementation graph at KSD commit `4835e7bf9161729cc8f0537bcc13db083896a6ae`, tree `fd641fb8a4efe7a5ef4d5da9c49f126e1e03e355`, on branch `work/monograph-current-library-capabilities` in `/Users/eugene/repos/ksdft2effmass`. The checkout had 112 short-status entries, although the specifically cited frame, alignment, Fourier, gauge, Wilson-loop, Wannier90, and defect-oracle implementation paths were clean relative to that commit.

That later inspection broadens the proof backlog but does not replace the immutable protocol source above. It supports no claim about dirty sibling files, runtime execution, applicability, numerical evidence, or scientific validity. Exact blob hashes and inspected paths are recorded in `docs/source-audit.md`.

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

Current canonical reusable modules cover finite sewing, reference-minus-aligned-candidate operator differences and their sewing closure, rectangular complex frames, ambient projectors, compression/reconstruction, right-unitary retained-coordinate covariance, exact finite-rank analytic-parent gap and ordering controls, exact right-unitary gauge construction and recovery, explicit identity/global/complete alignment-family semantics and strict-separation witnesses, finite Fourier algebra, weighted Frobenius losses, fixed-unitary equivariance, exact character-phase mode shifts, scalar-conjugation triviality, pointwise-unitary coefficient-change and Frobenius boundaries, finite decisions, reduction bases, spin-independent projection, spin Pauli residuals, folding, route identities, pointwise gauge convolution, support-radius growth, and exact source-neutral integer lattice shell radii.

The current exact layer also includes neighbor, sequential, and periodic-seam transport structures from supplied polar witnesses, exact known-gauge recovery, uniqueness, and conditional seam-closure controls, and the orthonormal-frame principal-value bridge `E_frame=2∑(1-σᵢ)`, `E_projector=2∑(1-σᵢ²)`, with `E_frame≤E_projector≤2E_frame`. Matrix-`L2Operator` bounds now control retained compression mismatch by frame mismatch and ambient projector-sandwich mismatch by projector mismatch, while an exact reproduction residual characterizes invariant closure when the frame is exactly orthonormal. The fixed-subspace bridge remains conditional on an exact ambient-compression binding, the supplied-shell results retain caller-supplied exact radii and cutoffs, and no runtime SVD, mesh, transport loop, orthonormality, leakage, or seam closure is authenticated.

These source-neutral results do not bind the owner protocol's runtime arrays or prove its case coverage.

## Missing obligations

The remaining obligations divide into exact mathematics, owner-specific representation bindings, and evidence contracts.

### Exact reusable mathematics

1. Periodic closure distribution and polar-transport perturbation stability under an explicit lower principal-value bound; supplied-witness neighbor/sequential/seam transport and exact known-gauge uniqueness and conditional seam closure are implemented, while rank-deficient completion remains explicit and external.
2. The mixed operator/Frobenius compression estimate and any quantitative leakage bounds beyond the implemented exact reproduction residual, algebraic zero criterion, orthonormal-frame invariant-range criterion, matrix-`L2Operator` frame mismatch, and separate projector-sandwich mismatch bounds.
3. General-rank Hermitian spectral perturbation, keeping maximum-eigenvalue and root-mean-square bounds distinct.
4. Quantitative gauge-convolution and omitted-power bounds for gauges without finite Fourier support.
5. Exact twist-gauge conjugacy and quotient-seam consistency where finite periodic operators use distributed or seam-localized phases.

### Owner-specific bindings

7. Source-faithful binding of owner frame, projector, operator, mesh, basis, unit, energy-reference, matrix-axis, and gauge-action data to the exact APIs.
8. An exact bridge from KSD's centered `fft`/`fftshift`, origin phase, positive reconstruction phase, tensor-axis order, and negative-Nyquist convention to the finite-character transform.
9. Product-quotient character/radius and complete D1/D2/D3 support-hierarchy authentication.
10. Exact contracts for any structured local alignment family.

### Evidence boundary

11. A strict proposition-specific owner schema and canonical serialization using exact rational or outward-rounded data rather than promoted binary64 values.
12. An independent verifier, retained complete objective inventory, and fail-closed exact checker.
13. A thin paper-specific bridge only after the reusable layer and owner binding are stable.

Wannier90 is absent from D1. A later owner protocol using it must separately distinguish square unitary matrices, rectangular isometries, and disentanglement maps, and must authenticate retained rank, eigenpair and subspace residuals, action side, Fourier normalization, `_u.mat`/`_hr.dat` conventions, gauge, sewing, degeneracy weights, and withheld reconstruction. It remains an external witness producer, not a Lean dependency or trusted runtime.

## Formalization order

Work proceeds from abstract frames to retained evidence. Basic frame, covariance, alignment-family, Fourier, and decision algebra is implemented source-neutrally; owner-specific binding remains external.

1. Freeze the finite-rank frame API and right action. *(implemented source-neutrally)*
2. Prove projector and compression covariance. *(implemented source-neutrally)*
3. Encode identity, global-unitary, and complete pointwise-unitary alignment families. *(implemented source-neutrally; structured restricted-circuit families remain open)*
4. Connect exact aligned fields to finite Fourier truncation and support growth. *(implemented source-neutrally)*
5. Add common-threshold decision semantics. *(implemented source-neutrally for supplied finite inventories)*
6. Integrate independently reviewed cyclic-radius and character-gauge/fixed-subspace exact slices. *(implemented source-neutrally in the current milestone)*
7. Prove polar transport and the principal-angle frame/projector bridge. *(implemented source-neutrally for supplied exact polar witnesses, including principal values in `[0,1]` and factor-two frame/projector error bounds; closure distribution and perturbative stability remain open)*
8. Extend the implemented matrix-`L2Operator` approximate-compression/projector-mismatch slice to the mixed Frobenius target, then prove general-rank spectral-error transfer.
9. Prove the owner-specific centered-FFT/product-quotient representation bridge.
10. Add closure-distribution/lower-principal-value transport stability when its consumer contract is selected.
11. Freeze the owner certificate schema.
12. Verify one retained case family independently.
13. Add source-specific instantiations and dossiers.

## Nonclaims

This plan does not establish continuum regularity, topology, Chern integrality, phase unwrapping, Wannier obstruction, Wannier90 behavior, runtime correctness, rank/depth/dimension findings, material applicability, or publication readiness.

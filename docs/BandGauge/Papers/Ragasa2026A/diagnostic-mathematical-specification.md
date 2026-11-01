<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-20
-->

# Ragasa2026A diagnostic mathematical specification

## Status and boundary

This document answers one question: **what mathematical object does each `A-DIAG-*`
entry measure?** It proposes precise semantic definitions for review and later owner-side
schema binding. Canonical names and proposed immutable Python record signatures are in
[`diagnostic-python-interface-recommendation.md`](diagnostic-python-interface-recommendation.md). It is not a retained runtime schema, numerical result, scientific
validation, or claim that every diagnostic is useful.

The definitions are based on Paper A at immutable owner revision
`99a46cb59d0c6f27ada7d709f194996ef9619d9f`. Where the current registry wording is
ambiguous or mathematically unsafe, the specification says so rather than inventing an
unreviewed equivalence.

## Lean-support boundary

Lean support is intentionally limited to diagnostics that carry theorem or decision
authority. The exact rank-two unnormalized Frobenius spectral bound is
`BG-FOUNDATION-THM-012`; the existence, uniqueness, and common-witness meaning of a
first-passing cutoff are `BG-DECISION-THM-014--016`. Existing modules already cover the
alignment harmonic, finite Fourier identities, residual-tail identity, and abstract
finite feasibility logic.

The remaining entries are measurements, software-integrity checks, provenance fields, or
empirical study outputs. They require tested producers, retained data, and independent
reconstruction rather than one Lean theorem per registry row. None of the formal results
binds the owner runtime or validates a numerical artifact.

## Common notation

Let:

- `K` be the finite construction momentum set with frozen positive weights
  `w_k`, where `∑_{k∈K} w_k = 1`;
- `Q` be the coordinate-disjoint finite evaluation set;
- `H_p(k) ∈ Herm(m)` be the parent field;
- `F(k) ∈ ℂ^{m×2}` be the retained frame;
- `P(k) = F(k)F(k)†` be its projector;
- `H(k) = F(k)†H_p(k)F(k) ∈ Herm(2)` be the retained reference field;
- `D(k) ∈ Herm(2)` be the comparison field in the declared common fiber;
- `X₀(k) = X(k) - tr(X(k))I₂/2` denote trace centering;
- `E_ref > 0` be the frozen reference energy; and
- `R(φ) ∈ SO(2)` be the declared global real rotation.

For rank-two matrix fields define

\[
 \langle X,Y\rangle_w
 =\sum_{k\in K}\frac{w_k}{2E_{\rm ref}^2}
   \operatorname{Re}\operatorname{tr}[X(k)^\dagger Y(k)],
 \qquad
 \|X\|_w^2=\langle X,X\rangle_w.
\]

For one matrix use

\[
 \|A\|_{F,*}=\frac{\|A\|_F}{\sqrt2 E_{\rm ref}},
 \qquad
 \|A\|_{F,E}=\frac{\|A\|_F}{E_{\rm ref}}.
\]

The first is the paper's per-retained-state power normalization. The second is the
**unnormalized Frobenius perturbation bound in energy units**. They must not be
interchanged.

For any finite inventory `S`, `max ∅`, `min ∅`, a zero denominator, a failed premise, or
an interval-overlapping comparison returns `unresolved` or `not-applicable`; it does not
silently return zero.

# P. State-space and premise measurements

## A-DIAG-P01 — external isolation gap

For a retained spectral cluster `C(k)` and complementary spectrum `C(k)^c`, measure

\[
 g_{\rm ext}=\min_{k\in K}\min_{\lambda\in C(k),\,\nu\in C(k)^c}|\lambda-\nu|.
\]

If the retained cluster is exactly the two lowest eigenvalues, this reduces to

\[
 g_{\rm ext}=\min_{k\in K}[\lambda_3(k)-\lambda_2(k)].
\]

It measures sampled spectral isolation, not smoothness or continuum isolation.

## A-DIAG-P02 — adjacent-frame overlap rank margin

For every oriented transport or closure link `ℓ=(k,k')`, with any required sewing map
`S_ℓ`, define

\[
 M_\ell=F(k)^\dagger S_\ell F(k'),
 \qquad
 s_{\rm link}=\min_{\ell}\sigma_{\min}(M_\ell).
\]

This measures the worst sampled rank margin for the Procrustes/polar transport step.

## A-DIAG-P03 — frame orthonormality defect

\[
 d_{\rm orth}=\max_{k\in K}\|F(k)^\dagger F(k)-I_2\|_F.
\]

It measures violation of the frame-isometry identity.

## A-DIAG-P04 — retained eigenspace residual

A direct common-fiber definition is

\[
 d_{\rm eig}=\max_{k\in K}
 \frac{\|H_p(k)F(k)-F(k)H(k)\|_F}{E_{\rm ref}}.
\]

If a diagonal retained eigenvalue matrix `Λ(k)` is declared, replace `H(k)` by `Λ(k)`.
This measures failure of the retained frame to span an invariant parent subspace. It is
not the same quantity as P03 or P05.

## A-DIAG-P05 — retained-projector reconstruction defect

Given the independently declared retained spectral projector `P_spec(k)`, measure

\[
 d_P=\max_{k\in K}\|F(k)F(k)^\dagger-P_{\rm spec}(k)\|_F.
\]

This removes internal rank-two gauge dependence.

## A-DIAG-P06 — pre-closure holonomy

Let `U_ℓ = polar(M_ℓ)` be the unitary link factor along an oriented reciprocal cycle `C`.
Measure

\[
 W_C=\prod_{\ell\in C}^{\rightarrow}U_\ell,
 \qquad
 d_{W}=\|W_C^\dagger W_C-I\|_F,
 \qquad
 \vartheta_C=\operatorname{sort}(\arg\operatorname{spec}W_C).
\]

The phases measure accumulated sampled sewing mismatch before closure. They are not a
standalone topological invariant.

## A-DIAG-P07 — post-closure sewing residual

For the closed frame `F_cl` and declared reciprocal sewing map `S_G`, measure

\[
 d_{\rm sew}=\max_{k,G}
 \|F_{\rm cl}(k+G)-S_G(k)F_{\rm cl}(k)\|_F.
\]

Any convention with an additional reviewed right-unitary factor must state it explicitly.

## A-DIAG-P08 — stage-resolved Hermiticity defects

For each stage `X` in `{parent, retained, aligned, reconstructed}`, measure separately

\[
 d_{\rm Herm}(X)=\max_x\frac{\|X(x)-X(x)^\dagger\|_F}{E_{\rm ref}}.
\]

There is no mathematically useful single maximum unless the stage label attaining it is
also retained.

# A. Alignment and operator measurements

Define the common centered power

\[
 \kappa=\|H_0\|_w^2,
\]

and the restricted correlation harmonic

\[
 b(\phi)=\langle R(\phi)^\dagger H_0R(\phi),D_0\rangle_w
 =b_0+c\cos(2\phi)+d\sin(2\phi).
\]

## A-DIAG-A01 — harmonic coefficients

A three-evaluation definition is

\[
 b_0=\frac{b(\pi/4)+b(-\pi/4)}2,
 \quad
 c=b(0)-b_0,
 \quad
 d=\frac{b(\pi/4)-b(-\pi/4)}2.
\]

The diagnostic is the ordered triple `(b₀,c,d)` together with its normalization and
rounding enclosure.

## A-DIAG-A02 — canonical maximizing angle

If `c²+d²>0`, define

\[
 \phi_*=\frac12\operatorname{atan2}(d,c)
 \pmod\pi,
 \qquad \phi_*\in[-\pi/2,\pi/2).
\]

If `c=d=0`, report `degenerate`; selecting zero is a serialization convention, not a
unique optimizer.

## A-DIAG-A03 — maximized normalized correlation

\[
 b_{\max}=b_0+\sqrt{c^2+d^2},
 \qquad
 \mu_{\max}=\frac{b_{\max}}{\kappa},
 \qquad \kappa>0.
\]

It measures the best normalized correlation allowed by the declared global `SO(2)`
family, not unrestricted pointwise gauge equivalence.

## A-DIAG-A04 — minimum aligned Frobenius residual

With a nonnegative scale `λ`, measure

\[
 \varepsilon_O
 =\min_{\phi\in[-\pi/2,\pi/2),\,\lambda\ge0}
   \|D_0-\lambda R(\phi)^\dagger H_0R(\phi)\|_w.
\]

Under common power, `κ>0`, and `μ_max≥0`,

\[
 \lambda_*=\mu_{\max},
 \qquad
 \varepsilon_O^2=\kappa(1-\mu_{\max}^2).
\]

## A-DIAG-A05 — irreducible operator floor

The floor is the squared optimum

\[
 f_O=\varepsilon_O^2=\kappa(1-\mu_{\max}^2)
\]

under the preceding hypotheses. It is a derived certificate quantity, not independent
numerical evidence from A03/A04.

## A-DIAG-A06 — aligned onsite-block mismatch

First freeze the full aligned approximant, including any allowed scalar channel, for
example

\[
 \widehat H_*(k)=s_*I_2+\lambda_*R(\phi_*)^\dagger H_0(k)R(\phi_*).
\]

Then define

\[
 d_{0}=\|T_D(0)-T_{\widehat H_*}(0)\|_{F,*}.
\]

The shift rule and centering convention are part of the diagnostic. This is a block
difference. The scalar
`|‖T_D(0)‖²-‖T_H(0)‖²|` is a different quantity and must not be substituted.

## A-DIAG-A07 — signed non-onsite power difference

\[
 \Delta P_{\ne0}
 =\sum_{R\ne0}\left(
   \|T_D(R)\|_{F,*}^2-\|T_H(R)\|_{F,*}^2
 \right).
\]

It measures comparison-minus-reference redistribution. It is not necessarily positive.

## A-DIAG-A08 — transported-frame covariance defect

For a reviewed frame-coordinate change `W(k)` and the independently transformed field
`X^W(k)`, measure

\[
 d_{\rm cov}(X;W)=\max_{k\in K}
 \frac{\|X^W(k)-W(k)^\dagger X(k)W(k)\|_F}{E_{\rm ref}}.
\]

Every participating frame, sewing map, and alignment witness must be transformed by the
same declared convention.

## A-DIAG-A09 — dispersive residual-tail decomposition

Let

\[
 A_R=R(\phi_*)^\dagger T_H(R)R(\phi_*),
 \qquad
 \delta T_R=T_D(R)-\lambda_*A_R.
\]

For non-onsite modes define separately

\[
 D_{\ne0}=\sum_{R\ne0}\|\delta T_R\|_{F,*}^2,
 \qquad
 C_{\ne0}=2\lambda_*\sum_{R\ne0}
 \langle A_R,\delta T_R\rangle_{F,*},
\]

and

\[
 S_{\ne0}=(\lambda_*^2-1)
 \sum_{R\ne0}\|T_H(R)\|_{F,*}^2,
\]

where `⟨A,B⟩_{F,*}=Re tr(A†B)/(2E_ref²)`. Unitary invariance gives

\[
 \Delta P_{\ne0}=D_{\ne0}+C_{\ne0}+S_{\ne0}.
\]

The four diagnostics are `(D_{≠0}, C_{≠0}, S_{≠0},
|ΔP_{≠0}-D_{≠0}-C_{≠0}-S_{≠0}|)`. The cross term uses the aligned reference block and
includes the fitted scale; the separate scale-power term is required unless `λ_*=1`.
Reporting only a combined departure can hide cancellation.

# F. Fourier and locality measurements

For a finite uniform group of size `N`, fix the convention

\[
 T_X(R)=\frac1N\sum_{k\in K}e^{-i k\cdot R}X(k),
 \qquad
 X_K(k)=\sum_R e^{i k\cdot R}T_X(R).
\]

Let `S(R_c)` be the exact declared retained support and

\[
 X_{R_c}(q)=\sum_{R\in S(R_c)}e^{iq\cdot R}T_X(R).
\]

## A-DIAG-F01 — conjugate-pairing defect

\[
 d_{\rm pair}=\max_R
 \frac{\|T_X(-R)-T_X(R)^\dagger\|_F}{E_{\rm ref}}.
\]

The `-R` operation is group negation; an even-mesh Nyquist representative must use its
cyclic equivalence class.

## A-DIAG-F02 — complete reconstruction defect

\[
 d_{\rm inv}=\max_{k\in K}
 \frac{\|X_K(k)-X(k)\|_F}{E_{\rm ref}}.
\]

## A-DIAG-F03 — Parseval defect

\[
 d_{\rm Parseval}
 =\left|
   \frac1N\sum_{k\in K}\|X(k)\|_{F,*}^2
   -\sum_R\|T_X(R)\|_{F,*}^2
  \right|.
\]

The normalization must change if the transform convention changes.

## A-DIAG-F04 — cyclic Nyquist conversion power

For the set `Y_N` of centered representatives affected by ordinary-lattice conversion,

\[
 P_{\rm Nyq}=\sum_{R\in Y_N}\|T_X(R)\|_{F,*}^2.
\]

This is `not-applicable` when no such conversion is performed.

## A-DIAG-F05 — non-onsite Fourier power

\[
 P_{\ne0}(X)=\sum_{R\ne0}\|T_X(R)\|_{F,*}^2.
\]

It measures coefficient-space power away from the onsite block, not spectral error.

## A-DIAG-F06 — omitted tail power

\[
 P_{\rm tail}(X;R_c)=\sum_{R\notin S(R_c)}\|T_X(R)\|_{F,*}^2.
\]

Under the declared uniform Parseval hypotheses, this equals the mean-square matrix
truncation residual on the complete finite mesh.

## A-DIAG-F07 — representation cost

Report the pair

\[
 C_{\rm blocks}=|S(R_c)|,
 \qquad
 C_{\rm radius}=\max_{R\in S(R_c)}\rho(R),
\]

where `ρ` is the frozen physical or lattice metric. These are separate objectives.

## A-DIAG-F08 — interpolation matrix error

With `X_dir(q)` evaluated directly from the declared parent/reduction and `X_K(q)` the
complete finite interpolant,

\[
 e_{\rm interp}^{\max}
 =\max_{q\in Q}\frac{\|X_K(q)-X_{\rm dir}(q)\|_F}{E_{\rm ref}},
\]

with RMS reported separately.

## A-DIAG-F09 — deliberate truncation matrix error

\[
 e_{\rm trunc}^{\max}(R_c)
 =\max_{q\in Q}\frac{\|X_{R_c}(q)-X_K(q)\|_F}{E_{\rm ref}}.
\]

## A-DIAG-F10 — total matrix error

\[
 e_{\rm total}^{\max}(R_c)
 =\max_{q\in Q}\frac{\|X_{R_c}(q)-X_{\rm dir}(q)\|_F}{E_{\rm ref}}.
\]

Pointwise matrix errors satisfy

\[
 X_{R_c}-X_{\rm dir}=(X_{R_c}-X_K)+(X_K-X_{\rm dir}),
\]

but their scalar norms are not additive.

# S. Spectral and decision measurements

Let `λ_j(A)` denote increasingly sorted Hermitian eigenvalues.

## A-DIAG-S01 — complete-field band-equivalence defect

\[
 e_{\rm complete}^{\rm band}
 =\max_{q\in Q}\max_{j=1,2}
 \frac{|\lambda_j(H_K(q))-\lambda_j(D_K(q))|}{E_{\rm ref}}.
\]

This compares eigenvalue multisets and remains meaningful at degeneracy.

## A-DIAG-S02 — truncated sorted-band error

For representation `X`,

\[
 e_E^X(R_c)=\max_{q\in Q}\max_{j=1,2}
 \frac{|\lambda_j(X_{R_c}(q))-\lambda_j(X_{\rm dir}(q))|}{E_{\rm ref}}.
\]

An RMS version is a separate diagnostic.

## A-DIAG-S03 — valid Frobenius perturbation bound

For `Δ_X(q)=X_{R_c}(q)-X_dir(q)`, define

\[
 B_F^X(R_c)=\max_{q\in Q}\frac{\|\Delta_X(q)\|_F}{E_{\rm ref}}.
\]

Then Weyl's inequality gives

\[
 e_E^X(R_c)
 \le \max_q\frac{\|\Delta_X(q)\|_2}{E_{\rm ref}}
 \le B_F^X(R_c).
\]

The rank-normalized value `‖Δ‖_F/(√2E_ref)` is not a general upper bound.

## A-DIAG-S04 — Weyl saturation ratio

When `B_F^X(R_c)>0`,

\[
 s_{\rm Weyl}^X(R_c)=\frac{e_E^X(R_c)}{B_F^X(R_c)}\in[0,1].
\]

If the denominator is zero, report exact zero agreement or `unresolved`; do not divide.

## A-DIAG-S05 — first-passing matrix cutoff

For a frozen ordered finite inventory `C`,

\[
 R_H^X=\min\{R_c\in C:e_{\rm total}^{X,\max}(R_c)\le\tau_H\}.
\]

If the set is empty, report `cap-exhausted`, not infinity or the largest cutoff.

## A-DIAG-S06 — first-passing band cutoff

\[
 R_E^X=\min\{R_c\in C:e_E^X(R_c)\le\tau_E\}.
\]

## A-DIAG-S07 — signed cutoff difference

For a fixed channel `Z∈{H,E}`,

\[
 \Delta R_Z=R_Z^{\rm comparison}-R_Z^{\rm reference}.
\]

Use “inflation” only after proving or observing `ΔR_Z>0` for the declared case.

## A-DIAG-S08 — joint/common-witness cutoff

For one representation `X`,

\[
 R_{\rm joint}^X
 =\min\{R_c\in C:
 e_{\rm total}^{X,\max}(R_c)\le\tau_H
 \ \land\ e_E^X(R_c)\le\tau_E\}.
\]

Both inequalities use the same support and reconstructed field.

## A-DIAG-S09 — weighted sampled prevalence

For a prospectively frozen case inventory `J` with a-priori weights `ω_j>0`,
`∑_jω_j=1`,

\[
 p_+=\sum_{j\in J}\omega_j\mathbf1[\Delta R(j)>0].
\]

This is a finite weighted proportion, not a continuum probability.

## A-DIAG-S10 — channel agreement

Report either

\[
 a_X=\mathbf1[R_H^X=R_E^X]
\]

or the signed difference `R_H^X-R_E^X`; do not let agreement replace either channel.

# R. Stability and evidence-integrity measurements

## A-DIAG-R01 — momentum-refinement change

For nested levels `N<N'` and scalar diagnostic `d`,

\[
 \Delta_N d=|d_{N'}-d_N|.
\]

For fields use a declared common-grid or projector comparison. Also report whether every
finite decision disposition changed.

## A-DIAG-R02 — threshold-adjacent margin

For an error `e` and tolerance `τ`, use the signed margin

\[
 m=\tau-e.
\]

Positive means pass, negative means fail, and an interval enclosure containing zero is
unresolved.

## A-DIAG-R03 — exact first-pass audit

For selected `R_*`, check the conjunction

\[
 e(R_*)\le\tau
 \quad\land\quad
 \forall R\in C,\ R<R_*\Rightarrow e(R)>\tau.
\]

Checking only the immediate predecessor is insufficient when pass/fail can re-enter.

## A-DIAG-R04 — finite parameter sensitivity

For a frozen parameter inventory `P` and diagnostic `d`, report a declared modulus such as

\[
 \operatorname{range}_P(d)=\max_{p\in P}d(p)-\min_{p\in P}d(p)
\]

and the complete decision-change mask. This proves nothing between sampled parameters.

## A-DIAG-R05 — construction/evaluation separation

With the frozen torus metric `dist_T`,

\[
 s_{KQ}=\min_{k\in K,q\in Q}\operatorname{dist}_T(k,q).
\]

Strict positivity proves coordinate disjointness only.

## A-DIAG-R06 — independent reconstruction difference

For every declared case `j` and cutoff `R_c`, independently reconstruct the matrix and
sorted-band target channels and report

\[
 d_{\rm independent}^{H}
 =\max_{j,R_c,q}\frac{\|X^{\rm producer}_{j,R_c}(q)
   -X^{\rm verifier}_{j,R_c}(q)\|_F}{E_{\rm ref}},
\]

\[
 d_{\rm independent}^{E}
 =\max_{j,R_c,q,n}\frac{|\lambda_n(X^{\rm producer}_{j,R_c}(q))
   -\lambda_n(X^{\rm verifier}_{j,R_c}(q))|}{E_{\rm ref}}.
\]

The verifier must reconstruct from serialized inputs without calling producer control
flow. Retain the exact case/cutoff coverage set and report the two channel discrepancies
separately; do not take a maximum across quantities with different units or semantics.

## A-DIAG-R07 — evidence-integrity gates

This is not one scalar. It is the fail-closed tuple

\[
 (g_{\rm schema},g_{\rm coverage},g_{\rm digest},g_{\rm source},g_{\rm witness}),
 \qquad g_i\in\{\text{pass},\text{fail}\}.
\]

Acceptance is the logical conjunction of all required gates. Coverage means equality
between expected and observed identity sets, not merely a record count.

## A-DIAG-R08 — dependency and environment identity

This is immutable provenance data, not a floating-point measurement. At minimum retain
hashes or exact identities for source revision, lockfile, executable, schema, method,
platform, and numerical backend. Equality is byte/identifier equality under the frozen
contract.

## A-DIAG-R09 — amplitude-interpolant validation error

For proposed interpolant `\widehat d(a)` and coordinate-disjoint validation amplitudes
`A_val`, measure

\[
 e_{\rm amp}=\max_{a\in A_{\rm val}}|\widehat d(a)-d(a)|
\]

for every target diagnostic and decision margin. If no interpolant is admitted, this is
`not-applicable` and should not appear in the primary result table.

# Minimal paper-facing set

The 46-entry registry is an audit and development inventory, not a sensible main-text
result table. A minimal decision-facing set is:

1. premise gates `P01`, `P02`, `P04`, `P07`, and stage-resolved `P08`;
2. alignment quantities `A03` and `A04`;
3. channel quantities `F06`, `F08`, `F09`, and `F10`;
4. spectral and joint decisions `S02`, corrected `S03`, and `S08`;
5. robustness/evidence gates `R01`, `R02`, `R06`, `R07`, and `R08`.

The remaining diagnostics are derived explanations, method-specific checks, or supporting
identity audits suitable for the supplement and machine-readable evidence ledger.

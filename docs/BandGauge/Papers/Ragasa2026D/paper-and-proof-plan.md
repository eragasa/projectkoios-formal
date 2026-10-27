# Proposed Ragasa2026D paper and proof plan

This document records a proposed direction without a source identity.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

Ragasa2026D is a proposed direction only. No audited owner source, canonical source key, approved title, Lean namespace, paper theorem, retained artifact, submission, or publication status exists.

Do not create a Paper D placeholder until an owner-approved protocol has an immutable revision and a separate source audit.

## Thesis

Select a finite-support Wannier or tight-binding model by simultaneous spectral and aligned-operator fidelity to a retained first-principles reference, not by visual band agreement alone.

## Three-level architecture

The proposed calculation separates oracle, retained bridge, and local model.

### A. First-principles oracle

The oracle remains an external calculation with frozen provenance.

\[
O_A(k)=H_{\mathrm{oracle}}(k).
\]

Required provenance includes calculation inputs, code and dependency versions, pseudopotentials or equivalent model data, basis and coordinate conventions, and retained hashes.

### B. Retained spectral bridge

For retained frame `Q(k)`,

\[
O_B(k)=Q(k)^\dagger O_A(k)Q(k).
\]

The bridge requires retained subspaces or projectors, gauge/sewing data, eigenpair residuals, isolation diagnostics, and degeneracy-aware comparison. Sorted eigenvalues alone are insufficient.

### C. Local model

For alignment `U(k)` and support `S`,

\[
O_C^{U,S}(k)=\sum_{R\in S}e^{ik\cdot R}T_U(R).
\]

The same `O_C`, `U`, and `S` must satisfy both spectral and operator thresholds. Separate channel optima are not a common witness.

## Required comparisons

All channels must compare one common model.

- Oracle-to-retained spectral agreement.
- Retained-projector and overlap quality.
- Alignment unitarity, conditioning, and endpoint sewing.
- Full and truncated Fourier reconstruction.
- Complete-shell support coverage.
- Spectral and operator losses on the same normalized reference.
- Minimum common support over a complete declared decision set.

Candidate coordinates may include retained rank, energy window, disentanglement choice, alignment family, localization settings, and Fourier support. Any exhaustiveness or infeasibility conclusion is relative to the frozen finite inventory.

## Error and evidence boundaries

Keep the eigenpair, subspace, alignment, interpolation, and truncation errors separate:

\[
e_{\mathrm{eig}},\quad e_{\mathrm{subspace}},\quad e_{\mathrm{align}},\quad e_{\mathrm{interp}},\quad e_{\mathrm{trunc}}.
\]

The final bound must state how these terms compose without treating correlated errors as independent. Degeneracies require clusters, projectors, or eigenvalue multisets rather than undocumented individual eigenvector labels.

The first application should use an equal-rank isolated composite manifold. Unequal-rank comparisons require isometric compression and explicit leakage; they are not unitary gauge equivalence. A failed local optimizer is not evidence of infeasibility: a negative finite claim needs exhaustive enumeration or another reviewed global certificate.

Wannier90 may produce a witness. Convergence does not prove the witness contract, and Wannier90 is not part of Lean's trusted base.

## Candidate systems

A first case should be small enough for complete provenance and independent replay. Candidate classes include a controlled plane-wave model, a simple insulator with an isolated retained manifold, or a validated tight-binding oracle used only as a staged control.

No material is selected by this document.

## Formal support

Reusable finite Fourier, fixed-unitary equivariance, weighted Frobenius, finite decision, certificate, folding, and gauge-loop algebra already exists. Paper D still requires source-specific oracle, retained-subspace, alignment, support, and evidence contracts.

Continuum topology, Chern integrality, phase unwrapping, general Wannier obstruction, and Wannier90 execution remain outside current formal claims.

## Entry gate

Work may begin only after:

1. owner-approved immutable protocol;
2. selected scientific system and question;
3. frozen basis, gauge, support, and loss conventions;
4. production and independent verification design;
5. exact certificate boundary; and
6. explicit implementation authorization.

## Nonclaims

This plan does not establish a first-principles result, a Wannier model, a material conclusion, runtime correctness, novelty, release, or publication readiness.

# Harmonic-oscillator formalization

This directory formalizes the exact mathematics needed to interpret truncation-induced distortion in
a reduced one-dimensional quantum harmonic oscillator. It does not treat a numerical calculation as
a theorem and does not claim continuum convergence, floating-point correctness, or physical
applicability.

## Source identity inspected

The computational crosswalk was selected from the read-only KSD worktree:

- repository: `ksdft2effmass`;
- worktree: `/Users/eugene/worktrees/ksdft2effmass-source-package-ownership-cleanup`;
- branch: `work/source-package-ownership-cleanup`;
- commit: `2229777163882c3452b950b8b21db86c7ea43511`;
- dirty-state limitation at inspection: clean;
- source paths:
  - `python/src/ksdft2effmass/operators/ladder_operators.py`;
  - `python/src/ksdft2effmass/operators/finite_differences.py`;
  - `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/model.py`;
  - `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/comparison.py`;
  - `calculations/research-monograph/harmonic-oscillator/protocol.md`.

That commit is local-only. The crosswalk identifies reviewed source bytes; it is not a durable remote
publication identity and does not authorize mutation of the KSD repository.

## Equations implemented

### Hermite analytical target

`HermiteEigenfunction.lean` defines the physicists' Hermite polynomials by

\[
H_0=1,\qquad H_{n+1}=2xH_n-H_n',
\]

proves

\[
H_n''-2xH_n'+2nH_n=0,
\]

and defines the unnormalized Hermite--Gaussian function

\[
\psi_n(x)=H_n(x)e^{-x^2/2}.
\]

For the dimensionless differential expression

\[
\mathcal Hf=-\frac12f''+\frac{x^2}{2}f,
\]

Lean proves pointwise

\[
\mathcal H\psi_n=\left(n+\frac12\right)\psi_n.
\]

A nonzero constant normalization factor does not change this eigenvalue equation. This tranche does
not yet prove the standard normalization integral or orthogonality in `L²(ℝ)`.

### Finite ladder algebra

`FiniteLadder.lean` defines the retained annihilation and creation matrices on
`|0⟩,…,|K⟩`, the direct number matrix, and the direct diagonal energy matrix. Lean proves

\[
a_K^\mathsf{T}a_K=N_K
\]

and the finite commutator defect

\[
[a_K,a_K^\mathsf{T}]
=I-(K+1)|K\rangle\langle K|.
\]

The direct energy matrix is formed from exact number labels, matching the computational source's
choice not to reconstruct reported reference energies through products of binary64 square roots.

### Truncation distortion

`TruncationDistortion.lean` proves the generic compression defect. For a finite injection `J`,

\[
J^\mathsf{T}(AB)J-
 (J^\mathsf{T}AJ)(J^\mathsf{T}BJ)
=
J^\mathsf{T}A(I-JJ^\mathsf{T})BJ.
\]

Thus compression is not multiplicative; the missing term passes through the omitted complement.
For the retained QHO ladder matrices, reconstructing the Hamiltonian after truncation gives

\[
\frac{E}{2}(a_Ka_K^\mathsf{T}+a_K^\mathsf{T}a_K)
=
H_K-\frac{E(K+1)}2|K\rangle\langle K|.
\]

For nonzero energy scale this reconstructed matrix is provably unequal to the direct Hermite-energy
reference matrix. The distortion is confined to the highest retained coordinate in this exact model.

### Supporting finite comparison algebra

- `FiniteComparison.lean` proves the exact Gram-normalization implication `JᵀJ=I`, preservation of
  real symmetry by pullback, and the squared Frobenius diagonal/off-diagonal decomposition.
- `FiniteDifference.lean` proves symmetry of the centered finite-difference stencil, sampled real
  diagonal potential, and their finite Hamiltonian sum.

These support later certificate and source-binding work. They do not prove second-order convergence.

## Source and authority status

- The Hermite and matrix results are source-neutral mathematical proofs checked by Lean and pinned
  Mathlib.
- The KSD paths establish a computational crosswalk only. No Python execution or retained JSON is
  imported into Lean.
- The present Hermite function is unnormalized. No `L²` orthogonality, completeness, or spectral
  theorem is claimed.
- No theorem identifies SciPy evaluation, NumPy arrays, grid parameters, binary64 values, SHA-256
  records, or a retained calculation result with these exact objects.
- Finite-box boundary error, finite-difference error, truncation error, map conditioning, and
  floating-point error remain separate obligations.

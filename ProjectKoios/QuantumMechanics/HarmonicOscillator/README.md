# Harmonic-oscillator formalization

This directory owns exact QHO mathematics used to analyze finite truncation. It does not certify a numerical calculation or physical model.

## Source crosswalk

The computational source was inspected read-only.

- Repository: `ksdft2effmass`
- Branch: `work/source-package-ownership-cleanup`
- Commit: `2229777163882c3452b950b8b21db86c7ea43511`
- Dirty state: clean
- Paths: `python/src/ksdft2effmass/operators/ladder_operators.py`, `python/src/ksdft2effmass/operators/finite_differences.py`, `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/model.py`, `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/comparison.py`, and `calculations/research-monograph/harmonic-oscillator/protocol.md`

The commit was local-only at inspection. It identifies reviewed bytes but is not a durable remote publication identity.

## Modules

Five modules separate analytic, finite, and comparison results.

- `HermiteEigenfunction.lean`: physicists' Hermite recurrence, differential equation, Hermite--Gaussian function, and pointwise eigenvalue equation
  \[
  \left(-\tfrac12\,d^2/dx^2+x^2/2\right)\psi_n=(n+1/2)\psi_n.
  \]
- `FiniteLadder.lean`: finite creation, annihilation, direct number, and direct energy matrices, including
  \[
  a_K^\mathsf T a_K=N_K,\qquad [a_K,a_K^\mathsf T]=I-(K+1)|K\rangle\langle K|.
  \]
  The direct energy uses exact number labels rather than products of binary64 square roots.
- `TruncationDistortion.lean`: compression nonmultiplicativity,
  \[
  J^\mathsf T(AB)J-(J^\mathsf TAJ)(J^\mathsf TBJ)=J^\mathsf TA(I-JJ^\mathsf T)BJ,
  \]
  and the retained-ladder boundary defect
  \[
  \tfrac E2(a_Ka_K^\mathsf T+a_K^\mathsf Ta_K)=H_K-\tfrac{E(K+1)}2|K\rangle\langle K|.
  \]
  For nonzero `E`, this reconstructed matrix differs from the direct energy reference only at the highest retained coordinate.
- `FiniteComparison.lean`: Gram isometry, symmetric pullback, and Frobenius diagonal/off-diagonal decomposition.
- `FiniteDifference.lean`: centered stencil, sampled diagonal potential, and finite Hamiltonian symmetry.

## Boundaries

The formal layer excludes numerical and continuum validation.

- The Hermite function is unnormalized; no `L²` normalization, orthogonality, completeness, or spectral theorem is proved.
- No theorem binds SciPy, NumPy, binary64 data, hashes, grids, or retained artifacts to these exact objects.
- Finite-box, discretization, truncation, conditioning, and floating-point errors remain separate obligations.

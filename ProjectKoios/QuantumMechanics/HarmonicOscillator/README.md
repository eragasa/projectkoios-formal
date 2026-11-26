# Harmonic-oscillator formalization

This directory owns exact QHO mathematics spanning the adopted Physlib continuum operator and local finite-truncation analysis. It does not certify a numerical calculation or physical model.

## Source crosswalk

The computational source was inspected read-only.

- Repository: `ksdft2effmass`
- Branch: `work/source-package-ownership-cleanup`
- Commit: `2229777163882c3452b950b8b21db86c7ea43511`
- Dirty state: clean
- Paths: `python/src/ksdft2effmass/operators/ladder_operators.py`, `python/src/ksdft2effmass/operators/finite_differences.py`, `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/model.py`, `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/comparison.py`, and `calculations/research-monograph/harmonic-oscillator/protocol.md`

The commit was local-only at inspection. It identifies reviewed bytes but is not a durable remote publication identity.

## Modules

Eight modules separate continuum, quantum-system, spectral-evolution, analytic, finite, and
comparison results.

- `Continuum.lean`: mirrored Physlib continuum Hamiltonian bridge proving the exact Schwartz domain,
  symmetry, dense closability, and essential self-adjointness conditional on density of the supplied
  Cartesian eigenstates; it also identifies Physlib's legacy and Cartesian one-dimensional Hilbert
  carriers and eigenstates, and uses Project Koios pointwise Fourier-integral injectivity to prove
  unconditional one-dimensional density and essential self-adjointness.
- `QuantumSystem.lean`: packages the closure of the one-dimensional Schwartz-core Hamiltonian as a
  self-adjoint Physlib `QuantumSystem` using `QuantumSystem.mkESA`.
- `SpectralEvolution.lean`: selects PhyslibAlpha's domain-aware Cayley spectral measure for that
  closure, identifies it explicitly as a spectral theorem for the packaged quantum-system
  Hamiltonian, and constructs physical `U(t)=exp(-itH̄/ℏ)`, with strong continuity, all-time Stone
  derivatives, domain invariance, and Hamiltonian commutation.
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

The formal layer excludes numerical and physical-model validation.

- The local `HermiteEigenfunction.lean` function is unnormalized; no theorem identifies it with the
  normalized Physlib continuum eigenstates.
- The continuum bridge proves the required eigenstate dense-span premise and essential
  self-adjointness for `d = 1`, and the closure is packaged as a self-adjoint quantum-system
  Hamiltonian; its concrete domain-aware Cayley spectral measure and physical
  `U(t)=exp(-itH̄/ℏ)` evolution are now bound. Arbitrary-dimensional completeness and evolution,
  spectral eigenfunction expansion, continuum measurement semantics, and numerical propagation
  remain open.
- No theorem binds SciPy, NumPy, binary64 data, hashes, grids, or retained artifacts to these exact objects.
- Finite-box, discretization, truncation, conditioning, and floating-point errors remain separate obligations.

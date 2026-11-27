# Harmonic-oscillator formalization

This directory owns exact QHO mathematics spanning the adopted Physlib continuum operator and local finite-truncation analysis. It does not certify a numerical calculation or physical model.

## Upstream integration

The continuum chain already uses Physlib's `HarmonicOscillator`, `Q.eigenstate`, and exactly
`Q.hamiltonian.closure`; it is not a competing oscillator model. Physlib's partial-operator domains
and Alpha's domain-aware spectral theory are reused. Alpha also provides compatible Schwartz-space
ladder/vacuum APIs; these are candidates for future bindings, not new adoptions in this pass.

The [pinned reuse audit](../../../docs/api-maps/harmonic-oscillator.md) records the actual APIs,
local bridge responsibilities, and remaining gaps. It identifies genuine legacy Hermite-polynomial
overlap with Physlib and a kernel-checked coefficient-map candidate without changing stable IDs or
public definitions. The raw Alpha sequence module's inspected advertised names are private at this
pin; do not access private names or treat sequence algebra as a continuum-domain identification.

## Source crosswalk

The computational source was inspected read-only.

- Repository: `ksdft2effmass`
- Branch: `work/source-package-ownership-cleanup`
- Commit: `2229777163882c3452b950b8b21db86c7ea43511`
- Dirty state: clean
- Paths: `python/src/ksdft2effmass/operators/ladder_operators.py`, `python/src/ksdft2effmass/operators/finite_differences.py`, `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/model.py`, `python/src/ksdft2effmass/analysis/model_systems/harmonic_oscillator/comparison.py`, and `calculations/research-monograph/harmonic-oscillator/protocol.md`

The commit was local-only at inspection. It identifies reviewed bytes but is not a durable remote publication identity.

## Modules

Twelve modules separate continuum, Hilbert-basis, exact finite spectral compression and residuals,
rational residual checking, quantum-system, spectral-evolution, analytic, finite, and comparison results.

- `Continuum.lean`: mirrored Physlib continuum Hamiltonian bridge proving the exact Schwartz domain,
  symmetry, dense closability, and essential self-adjointness conditional on density of the supplied
  Cartesian eigenstates; it also identifies Physlib's legacy and Cartesian one-dimensional Hilbert
  carriers and eigenstates, and uses Project Koios pointwise Fourier-integral injectivity to prove
  unconditional one-dimensional density and essential self-adjointness.
- `HilbertBasis.lean`: combines Physlib eigenstate orthonormality with the proved dense span to
  package the natural-number-indexed Cartesian eigenstates as a Mathlib countable `HilbertBasis`.
  It also transfers the eigenstate equation to the selected Hamiltonian closure, proves the
  Hamiltonian-coordinate and energy-squared Parseval identities on that domain, and derives a
  summable global `(k+1)²` coefficient moment bounded by `4‖H̄ψ‖²/(ℏω₀)²`. Domain-valued partial
  sums converge in the explicit sum graph norm, giving convergence of Physlib quadratic energy
  values, Rayleigh quotients for nonzero targets, and normalized energy expectations for unit-norm
  domain targets. Nonzero targets have eventually nonzero partial sums; early cutoffs may vanish.
  The discarded raw energy is exactly the omitted `E_k |c_k|²` tail and is at most `‖H̄ψ‖²/E_N`.
  Normalized energy-error bounds and sufficient cutoff conditions additionally keep the retained
  squared-norm lower bound `m>0` and the normalization defect explicit.
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
- `FiniteSpectralCompression.lean`: finite Euclidean coefficients embed isometrically in the
  selected continuum closure domain; the existing real diagonal Hamiltonian, complexified at scale
  `ℏω₀`, satisfies exact intertwining and adjoint compression and has the same quadratic energy as
  the continuum image. First-`K+1` Hilbert coefficients give the same domain partial sums used for
  the orbital, density, graph-norm, and energy approximation results. This is the direct diagonal
  Hamiltonian, not a finite ladder-product reconstruction or sampled-grid matrix.
- `FiniteSpectralResidual.lean`: exact finite/continuum eigenpair residual transport and norm
  equality for the existing retained matrix. Unit coefficients yield proximity to some retained
  energy, including use of an independently proved residual upper bound. An explicit positive gap
  from the trial energy to every other retained level bounds the component orthogonal to a selected
  eigenstate. This is a phase-independent span estimate, not a phase-fixed vector error, omitted
  continuum-tail estimate, numerical residual checker, or eigensolver validation.
- `FiniteResidualCertificate.lean`: executable exact rational coefficient/endpoint checker. It
  computes coefficient mass `S` and a conservative endpoint squared-residual budget and checks it
  against `B`. Acceptance plus a separately proved enclosure of actual `ℏω₀` yields unit continuum
  norm after exact Mathlib normalization, residual at most `sqrt (B/S)`, and proximity to some
  retained exact energy. Kernel-checked fixtures cover non-unit complex data, zero-budget/minimal
  cutoff acceptance, and rejection of zero mass, insufficient/negative budgets, and reversed
  intervals. No physical-scale enclosure producer, runtime parser, solver-data binding, or gap
  checker is provided; the synthetic fixtures do not instantiate a physical oscillator.
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
  a spectral-measure eigenfunction-expansion theorem, continuum measurement semantics, and
  numerical propagation remain open. The Hilbert-basis partial sums now support a separate
  representative-safe spin-density convergence binding. On the actual closure domain, the derived
  coefficient moment gives inverse-linear orbital/density error and inverse-square particle-number
  deficit bounds. These rate bounds alone are not energy-expectation identities. Separate graph-norm
  results establish oscillator energy-expectation convergence with the stated domain/nonzero/unit
  hypotheses, not a converse domain theorem, numerical energy certificate, or convergence of a
  Kohn--Sham total-energy functional.
- No theorem binds SciPy, NumPy, binary64 data, hashes, grids, or retained artifacts to these exact objects.
- Numerical finite-box, discretization, conditioning, and floating-point errors remain separate
  from the exact Hilbert-coefficient truncation bounds and spectral-compression identities.

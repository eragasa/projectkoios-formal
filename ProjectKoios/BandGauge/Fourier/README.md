<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-19
-->

# BandGauge Fourier analysis

This directory owns exact finite Fourier, support, truncation, Parseval, fixed-unitary equivariance, pointwise-gauge boundary, and normalized finite product-torus factorization results.

The declaration surface is deliberately divided into five ownership families. Declarations are not
re-exported through a flat compatibility namespace.

- `FiniteAbelian/`: convention-neutral reconstruction followed by the explicit finite-abelian
  transform, inversion, Parseval, Hermitian pairing, matrix-Frobenius identities, exact finite
  matrix-product convolution, exact equal-weight least-squares optimality of support truncation, and
  a finite-periodic reciprocal-lattice matrix layer with arbitrary finite dimension/rank and named
  1-D, 2-D, and 3-D specializations.
- `Gauge/`: fixed-unitary equivariance, pointwise-gauge boundaries, exact pointwise-unitary
  triple convolution, finite-support and complete-shell radius inclusions, and finite witnesses
  separating ordered-band equality from Fourier locality.
- `Support/`: centered-even mesh inventories, negative-Nyquist removal, complete metric-shell
  semantics over supplied finite inventories, and complete-shell growth under explicitly supplied
  radius hypotheses.
- `Torus/`: normalized finite products of unit additive circles and exact normalized sine-phase
  `J₀` evaluations.
- `Residual/`: deliberate-truncation residual channels, exact power/root-mean-square tails, maximum
  bounds, and the constant/uniform rank-two weighted bridge.

Each family has its own README and imports only the lower-level families it requires. The complete
old-name to hierarchical-name crosswalk is
[`docs/migrations/fourier-domain-hierarchy.md`](../../../docs/migrations/fourier-domain-hierarchy.md).

## Boundaries

Every specialization must freeze its convention.

- Every specialization must state sign, normalization, index group, support rule, and finite or continuum domain.
- Character multiplication of a vector field shifts mode labels; it is not scalar-operator conjugation.
- Scalar rank-one operator conjugation is pointwise trivial and is not a gauge-locality effect.
- A momentum-dependent higher-rank gauge obeys an exact finite triple-convolution law, with coefficient support contained in `(-S_U + S_A) + S_U`; for a supplied inversion-invariant subadditive nonnegative radius and complete character inventory, this implies the shell bound `R_A + 2 R_U`. Both statements are inclusions, not support equality or physical range. The two-point and binary product-mesh witnesses separately prove that exact pointwise ordered-band equality can coexist with zero-mode-truncation noncommutation and strictly positive omitted Fourier power.
- The Fourier residual bridge does not identify a runtime interpolant, coefficient array, or support inventory with its exact inputs.
- Exact finite-abelian least-squares optimality concerns a complete uniform inventory and an exact supported coefficient class. The lattice layer records reciprocal geometry separately from the product of cyclic quotients, so orthogonal or nonorthogonal bases do not change character orthogonality. Neither layer certifies runtime periods or basis vectors, a selected gauge, a NumPy solve, numerical full rank, conditioning, binary64 route agreement, or a runtime threshold.
- Negative-Nyquist removal is a singleton projection, not a representation-preserving equivalence: the full reconstruction differs by the explicit deleted term away from any separately established equality set.
- The normalized negative-Nyquist power is independent of later range selection by construction. It is not an off-mesh error and is not the ordinary omitted-coefficient tail.
- `CenteredEvenMesh` does not identify the exact centered-index equivalence with NumPy `fft`, `fftshift`, binary64 arrays, serialized bytes, or a retained KSD execution.
- Matrix root-mean-square results use the explicit entrywise Frobenius power and do not silently substitute the ambient matrix norm.
- The maximum-tail bound uses the ambient norm on a complex normed space. It does not imply an entrywise matrix-Frobenius maximum bound without a separate representation bridge.
- Uniform weights do not replace nonuniform quadrature.
- Concrete weights and supports must satisfy `docs/BandGauge/publication-evidence-contract.md`.
- A complete metric shell is exact only relative to its supplied inventory, radius, cutoff, and invariance hypotheses. The support-growth result uses `Finset.univ`; it does not authenticate an external incomplete inventory, turn a metric radius into a source-defined hopping range, or prove external orbit coverage.
- The square, triangular, simple-cubic, and FCC shell indices use exact dimensionless reduced integer coordinates. They are squared-radius indices and are not silently treated as instances of the support-growth theorem's triangle hypothesis; lattice constants, physical units, basis connectivity, and material interpretation remain external.
- The normalized product-torus carrier is explicitly `Dimension → UnitAddCircle`, with `Dimension` finite and the product of standard unit-circle Haar measures. It does not infer endpoint identification, coordinate scaling, phase convention, or measure from external notation.
- The normalized-circle Bessel bridge fixes `UnitAddCircle`, standard Haar mass one, the coordinate `sin(2πx)`, positive phase, and no extra `2π` in the real amplitude. It does not identify an external coordinate or runtime phase with these exact inputs, authenticate quadrature or a finite mesh, establish finite-to-continuum convergence, or certify a KSD analytic comparator.
- The modules do not identify a generic finite group with a publication mesh or certify Wannier90, runtime arrays, continuum convergence, or physical locality.
- Physlib revision `adc97f054083132000567cb09ff8f7b1f073400d` was inspected but remains unadopted and unnecessary for this layer.

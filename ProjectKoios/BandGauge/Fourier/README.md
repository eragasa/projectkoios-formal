<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-19
-->

# BandGauge Fourier analysis

This directory owns exact finite Fourier, support, truncation, Parseval, fixed-unitary equivariance, pointwise-gauge boundary, and normalized finite product-torus factorization results.

- `FiniteReconstruction.lean`: reconstruction with an explicit caller-supplied kernel, support truncation, and exact tail decomposition; it selects no Fourier convention.
- `CenteredEvenMesh.lean`: positive even centered integer inventories, exact deletion of the negative Nyquist representative, full-versus-removed reconstruction, normalized deleted-block power, and symmetric ordinary support below half the mesh size.
- `MetricShellSupport.lean`: complete finite metric shells, exact attained-radius inventories, tie retention, conditional inversion/symmetry closure, no-skipped-shell theorems, and square, triangular, simple-cubic, and normalized FCC integer shell indices.
- `NormalizedProductTorus.lean`: the explicit finite product of unit additive circles with normalized product Haar measure, factorization of coordinate-separable complex averages, exponential factorization for additive phases, and equal-factor power laws with 2-D square and 3-D cube corollaries.
- `NormalizedCircleBessel.lean`: the standard period-one sine coordinate, positive-sign sine phase, normalized one-circle `J₀` identity, arbitrary finite product power, and exact 2-D square, 3-D cube, and 3-D `2a/3` scaling corollaries.
- `FiniteAbelianTransform.lean`: conjugated-character forward transform with normalization `1 / |G|` and finite inversion.
- `FiniteParseval.lean`: inner-product and power Parseval identities; reconstructed residual power equals `|G|` times omitted coefficient power.
- `HermitianPairing.lean`: negative-mode pairing and Hermitian reconstruction.
- `MatrixFrobenius.lean`: entrywise matrix Parseval and the analogous exact Frobenius residual-tail equality.
- `ResidualChannels.lean`: identifies the deliberate-truncation channel with the exact Fourier residual, proves its Hilbert and explicit matrix-Frobenius power and root-mean-square tail equalities, and bounds its pointwise and finite-maximum ambient norms by the omitted coefficient one-norm tail.
- `RankTwoWeightedBridge.lean`: constant weight `weight / (2 Eref²)` and the uniform specialization in which `|G|` cancels.
- `UnitaryEquivariance.lean`: Frobenius invariance and Fourier commutation for one fixed finite-rank unitary.
- `PointwiseGauge.lean`: character-phase mode shifts, trivial scalar-operator conjugation, pointwise matrix conjugation, coefficient separation, and pointwise Frobenius invariance.
- `GaugeTruncationCounterexample.lean`: an exact rank-two, two-point witness in which a pointwise swap gauge creates a nonzero odd Fourier mode and fails to commute with zero-mode support truncation.

## Boundaries

Every specialization must freeze its convention.

- Every specialization must state sign, normalization, index group, support rule, and finite or continuum domain.
- Character multiplication of a vector field shifts mode labels; it is not scalar-operator conjugation.
- Scalar rank-one operator conjugation is pointwise trivial and is not a gauge-locality effect.
- A momentum-dependent higher-rank gauge that changes the field changes at least one coefficient. The explicit two-point witness proves that such a gauge need not commute with zero-mode support truncation, but it does not provide a general convolution or support formula.
- The Fourier residual bridge does not identify a runtime interpolant, coefficient array, or support inventory with its exact inputs.
- Negative-Nyquist removal is a singleton projection, not a representation-preserving equivalence: the full reconstruction differs by the explicit deleted term away from any separately established equality set.
- The normalized negative-Nyquist power is independent of later range selection by construction. It is not an off-mesh error and is not the ordinary omitted-coefficient tail.
- `CenteredEvenMesh` does not identify the exact centered-index equivalence with NumPy `fft`, `fftshift`, binary64 arrays, serialized bytes, or a retained KSD execution.
- Matrix root-mean-square results use the explicit entrywise Frobenius power and do not silently substitute the ambient matrix norm.
- The maximum-tail bound uses the ambient norm on a complex normed space. It does not imply an entrywise matrix-Frobenius maximum bound without a separate representation bridge.
- Uniform weights do not replace nonuniform quadrature.
- Concrete weights and supports must satisfy `docs/BandGauge/publication-evidence-contract.md`.
- A complete metric shell is exact only relative to its supplied inventory, radius, cutoff, and invariance hypotheses. It does not authenticate a serialized inventory, turn a metric radius into a source-defined hopping range, or prove external orbit coverage.
- The square, triangular, simple-cubic, and FCC shell indices use exact dimensionless reduced integer coordinates; lattice constants, physical units, basis connectivity, and material interpretation remain external.
- The normalized product-torus carrier is explicitly `Dimension → UnitAddCircle`, with `Dimension` finite and the product of standard unit-circle Haar measures. It does not infer endpoint identification, coordinate scaling, phase convention, or measure from external notation.
- The normalized-circle Bessel bridge fixes `UnitAddCircle`, standard Haar mass one, the coordinate `sin(2πx)`, positive phase, and no extra `2π` in the real amplitude. It does not identify an external coordinate or runtime phase with these exact inputs, authenticate quadrature or a finite mesh, establish finite-to-continuum convergence, or certify a KSD analytic comparator.
- The modules do not identify a generic finite group with a publication mesh or certify Wannier90, runtime arrays, continuum convergence, or physical locality.
- Physlib revision `adc97f054083132000567cb09ff8f7b1f073400d` was inspected but remains unadopted and unnecessary for this layer.

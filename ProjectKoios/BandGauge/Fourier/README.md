<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-19
-->

# BandGauge Fourier analysis

This directory owns exact finite Fourier, support, truncation, Parseval, fixed-unitary equivariance, and pointwise-gauge boundary results.

- `FiniteReconstruction.lean`: reconstruction with an explicit caller-supplied kernel, support truncation, and exact tail decomposition; it selects no Fourier convention.
- `FiniteAbelianTransform.lean`: conjugated-character forward transform with normalization `1 / |G|` and finite inversion.
- `FiniteParseval.lean`: inner-product and power Parseval identities; reconstructed residual power equals `|G|` times omitted coefficient power.
- `HermitianPairing.lean`: negative-mode pairing and Hermitian reconstruction.
- `MatrixFrobenius.lean`: entrywise matrix Parseval and the analogous exact Frobenius residual-tail equality.
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
- Uniform weights do not replace nonuniform quadrature.
- Concrete weights and supports must satisfy `docs/BandGauge/publication-evidence-contract.md`.
- The modules do not identify a generic finite group with a publication mesh or certify Wannier90, runtime arrays, continuum convergence, or physical locality.
- Physlib revision `adc97f054083132000567cb09ff8f7b1f073400d` was inspected but remains unadopted and unnecessary for this layer.

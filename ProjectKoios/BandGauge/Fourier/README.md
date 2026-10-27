<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
Initial document completed: 2026-10-19
-->

# BandGauge Fourier analysis

This directory owns exact finite Fourier, support, truncation, Parseval, and fixed-unitary equivariance results.

- `FiniteReconstruction.lean`: reconstruction with an explicit caller-supplied kernel, support truncation, and exact tail decomposition; it selects no Fourier convention.
- `FiniteAbelianTransform.lean`: conjugated-character forward transform with normalization `1 / |G|` and finite inversion.
- `FiniteParseval.lean`: inner-product and power Parseval identities; reconstructed residual power equals `|G|` times omitted coefficient power.
- `HermitianPairing.lean`: negative-mode pairing and Hermitian reconstruction.
- `MatrixFrobenius.lean`: entrywise matrix Parseval and the analogous exact Frobenius residual-tail equality.
- `RankTwoWeightedBridge.lean`: constant weight `weight / (2 Eref²)` and the uniform specialization in which `|G|` cancels.
- `UnitaryEquivariance.lean`: Frobenius invariance and Fourier commutation for one fixed finite-rank unitary.

## Boundaries

Every specialization must freeze its convention.

- Every specialization must state sign, normalization, index group, support rule, and finite or continuum domain.
- A momentum-dependent gauge generally mixes Fourier modes; fixed-unitary results do not cover it.
- Uniform weights do not replace nonuniform quadrature.
- Concrete weights and supports must satisfy `docs/BandGauge/publication-evidence-contract.md`.
- The modules do not identify a generic finite group with a publication mesh or certify Wannier90, runtime arrays, continuum convergence, or physical locality.
- Physlib revision `adc97f054083132000567cb09ff8f7b1f073400d` was inspected but remains unadopted and unnecessary for this layer.

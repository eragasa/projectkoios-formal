<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-->

# Finite-abelian Fourier core

This family owns the exact algebra shared by the higher Fourier families.

- `Reconstruction.lean`: caller-supplied kernels, support truncation, and retained/omitted decomposition.
- `Transform.lean`: the conjugated-character forward transform with normalization `1 / |G|` and finite inversion.
- `Parseval.lean`: inner-product and power Parseval identities and exact residual power.
- `HermitianPairing.lean`: negative-mode pairing and Hermitian reconstruction.
- `MatrixFrobenius.lean`: entrywise matrix Parseval and the exact Frobenius residual tail.
- `Convolution.lean`: exact finite matrix-product convolution and finite-support addition.

The modules choose no runtime mesh, FFT implementation, serialized coefficient array, or physical
locality interpretation.

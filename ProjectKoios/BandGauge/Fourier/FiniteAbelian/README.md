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
- `Convolution.lean`: exact coefficient-support monotonicity, finite matrix-product convolution, and finite-support addition.
- `LeastSquares.lean`: coefficient-space Pythagorean splitting, exact momentum-space reconstruction-error decomposition, and equal-weight least-squares optimality and uniqueness of Fourier truncation over a declared supported class.
- `LatticeLeastSquares.lean`: finite quotients of reciprocal lattices, arbitrary-rank matrix Frobenius least squares, and explicit periodic 1-D, 2-D, and 3-D specializations. Reciprocal-basis geometry is recorded separately from the quotient group and may be orthogonal or nonorthogonal.
- `PowerPartition.lean`: exact onsite/nononsite entrywise Frobenius-power partition, direct nononsite nonnegativity, and arbitrary-rank periodic 1-D, 2-D, and 3-D specializations.

The modules choose no runtime mesh, FFT implementation, serialized coefficient array, design-matrix
rank, numerical least-squares solver, binary64 summation or route-agreement claim, or physical
locality interpretation.  In particular, the exact power partition specifies a direct finite sum; it
does not certify subtraction of separately rounded runtime totals.

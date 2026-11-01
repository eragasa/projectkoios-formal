<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-->

# Fourier residual channels

This family owns exact consequences of deliberate Fourier truncation.

- `Channels.lean`: identification of the deliberate-truncation channel, Hilbert and explicit matrix-Frobenius power/root-mean-square tails, and pointwise and finite-maximum ambient-norm bounds.
- `RankTwoWeightedBridge.lean`: the constant weight `weight / (2 Eref²)` and uniform specialization in which `|G|` cancels.

The family does not identify exact inputs with runtime interpolants, quadrature weights, coefficient
arrays, support inventories, thresholds, or scientific error budgets.

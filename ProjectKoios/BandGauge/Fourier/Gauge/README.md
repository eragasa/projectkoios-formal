<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-->

# Fourier gauge actions

This family owns exact gauge-action results at the Fourier boundary.

- `UnitaryEquivariance.lean`: Frobenius invariance and Fourier commutation for one fixed finite-rank unitary.
- `PointwiseGauge.lean`: character-phase mode shifts, scalar-conjugation triviality, pointwise conjugation, coefficient separation, and pointwise Frobenius invariance.
- `PointwiseConvolution.lean`: conjugate-transpose mode reversal, the exact pointwise-unitary triple-convolution law, and its finite-support inclusion.
- `TruncationCounterexample.lean`: a rank-two two-point witness where a pointwise swap gauge creates a nonzero odd mode and does not commute with zero-mode truncation.
- `ProductLocalitySeparation.lean`: the finite-dimensional binary-product lift, with exact ordered-band equality, truncation noncommutation, positive omitted Frobenius power, and 2-D/3-D corollaries.

Fixed-unitary equivariance alone does not cover momentum-dependent gauges; the triple-convolution
law describes their exact finite coefficient mixing. Its support result is an inclusion relative to
declared finite supports, not a physical hopping-range, continuum-decay, runtime gauge-recovery,
convergence, or scientific-adequacy claim.

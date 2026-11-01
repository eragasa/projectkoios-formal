<!--
Copyright (c) 2026 Eugene Joseph M. Ragasa.
SPDX-License-Identifier: Apache-2.0
Author: Eugene Joseph M. Ragasa
-->

# Normalized product-torus analysis

This family owns exact normalized integration on finite products of unit additive circles.

- `NormalizedProduct.lean`: product Haar probability measure, coordinate-separable complex-average factorization, additive-phase exponential factorization, equal-factor powers, and 2-D/3-D corollaries.
- `NormalizedCircleBessel.lean`: the period-one coordinate `sin (2πx)`, positive phase, normalized one-circle `J₀` identity, arbitrary finite product power, and exact 2-D/3-D scaling corollaries.

The convention has Haar mass one and no extra `2π` in the real amplitude. These modules do not bind
external coordinates, quadrature, finite meshes, convergence, or runtime analytic comparators.

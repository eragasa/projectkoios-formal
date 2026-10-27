# Exact certificates

This directory owns exact certificate schemas, Boolean checkers, and checker-soundness theorems.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

- `RankTwoSeparation.lean`: exact rational-center witness, containment, and separation checks.
- `RankTwoSeparationEnclosure.lean`: rational center intervals and the exact bound `7/10 < 1 / √2 < 71/100`.
- `RankTwoSeparationBox.lean`: uniform checks over positive-curvature and correlation intervals.
- `FinitePareto.lean`: exact dominance, threshold, and nondominated-mask checks for complete finite tables.

## Boundaries

The checkers have narrow formal authority.

- Checkers fail when a declared validity clause fails.
- Field-to-certificate bindings remain explicit theorem obligations.
- These modules do not parse runtime files or certify eigensolvers, external coverage, publication data, or scientific models.
- A generic accepted certificate is not a publication certificate.

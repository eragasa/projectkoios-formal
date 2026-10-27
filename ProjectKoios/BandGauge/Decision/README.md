# Finite decision layer

This directory owns finite multiobjective decision semantics.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

- `FinitePareto.lean`: weak-all/strict-any dominance, efficient decisions, threshold feasibility, threshold relaxation, minimum-cost attainment, and two-channel outcome classification.

## Boundaries

The finite inventory remains explicit.

- Exhaustiveness is relative to the declared finite decision type.
- The module owns no paper-specific tables, plots, interpolation, convexification, KKT assumptions, runtime serialization, or numerical evidence.
- `docs/theorem-manifest.md` is the declaration ledger.

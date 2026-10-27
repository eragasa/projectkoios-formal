# Finite decision layer

This directory owns finite multiobjective decision semantics.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

- `FinitePareto.lean`: weak-all/strict-any dominance, efficient decisions, threshold feasibility, threshold relaxation, minimum-cost attainment, and two-channel outcome classification.
- `FiniteCutoff.lean`: first-passing existence and uniqueness after checking every earlier declared cutoff, without monotonicity, and joint passage at one common cutoff.

## Boundaries

The finite inventory remains explicit.

- Exhaustiveness is relative to the supplied finite inventory and does not establish external inventory coverage.
- The module owns no paper-specific tables, plots, interpolation, convexification, KKT assumptions, runtime serialization, or numerical evidence.
- `docs/theorem-manifest.md` is the declaration ledger.

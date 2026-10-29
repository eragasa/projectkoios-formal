# Finite decision layer

This directory owns finite multiobjective decision semantics.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

- `FinitePareto.lean`: weak-all/strict-any dominance, efficient decisions, threshold feasibility, threshold relaxation, minimum-cost attainment, and two-channel outcome classification.
- `FiniteCutoff.lean`: first-passing existence and uniqueness after checking every earlier declared cutoff, without monotonicity, and joint passage at one common cutoff.
- `FiniteCompatibility.lean`: finite model/candidate inventories, central common-candidate spectral--operator compatibility using an alignment infimum, stronger same-alignment witness/channel conformance, explicit model embeddings, exact set separation, and first-compatible-class selection.

## Boundaries

The finite inventory remains explicit.

- Exhaustiveness is relative to the supplied finite inventory and does not establish external inventory coverage.
- Central compatibility means literal intersection through one common candidate, a nonempty declared alignment family, and an alignment-infimum operator criterion; zero set distance is not promoted to intersection.
- Raw alignment-infimum passage is not a conformant operator witness without explicit attainment and mandatory-channel acceptance; the stronger witness-compatible predicate records that distinction.
- Applications may bundle support, intermediate-field, sign-convention, and evaluation-inventory data into the alignment carrier when those choices must remain common across channels.
- Model-class transfer requires an explicit conformant embedding; nominal nesting alone transfers nothing.
- The module owns no paper-specific tables, plots, interpolation, convexification, KKT assumptions, runtime serialization, or numerical evidence.
- `docs/theorem-manifest.md` is the declaration ledger.

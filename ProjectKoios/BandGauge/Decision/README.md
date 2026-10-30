# Finite decision layer

This directory owns finite multiobjective decision semantics.

- Author: Eugene Joseph M. Ragasa
- License: Apache-2.0
- Initial document completed: 2026-10-19

- `FinitePareto.lean`: weak-all/strict-any dominance, efficient decisions, threshold feasibility, threshold relaxation, minimum-cost attainment, and two-channel outcome classification.
- `FiniteCutoff.lean`: first-passing existence and uniqueness after checking every earlier declared cutoff, without monotonicity, and joint passage at one common cutoff.
- `FiniteCompatibility.lean`: finite model/candidate inventories, central common-candidate spectral--operator compatibility using an alignment infimum, stronger same-alignment witness/channel conformance, explicit model embeddings, attained exact set separation with finite-inventory zero/positive converse theorems, and first-compatible-class selection.
- `AlignedOperatorBudget.lean`: exact finite-maximum aligned-operator loss, same-alignment perturbation stability and budget headroom, and an explicit adapter from concrete finite operator data to the generic compatibility schema.
- `OperatorChannels.lean`: precise separation of exact upper-bounded error channels from nonnumeric structural requirements, with one tagged adapter into the generic compatibility schema.
- `FiniteAlignmentAttainment.lean`: exact minimizer existence for nonempty finite alignment families, concrete budget-witness extraction, and conditional equivalence between central and witness compatibility when attaining alignments separately pass all mandatory channels.

## Boundaries

The finite inventory remains explicit.

- Exhaustiveness is relative to the supplied finite inventory and does not establish external inventory coverage.
- Central compatibility means literal intersection through one common candidate, a nonempty declared alignment family, and an alignment-infimum operator criterion. Zero set distance is equivalent to intersection only after both central admissible sets are known nonempty; finite inventory supplies compactness but not nonemptiness.
- Raw alignment-infimum passage is not a conformant operator witness without explicit attainment and mandatory-channel acceptance; the stronger witness-compatible predicate records that distinction.
- Applications may bundle support, intermediate-field, sign-convention, and evaluation-inventory data into the alignment carrier when those choices must remain common across channels. The concrete adapter projects that carrier to the exact pointwise unitary field used by the operator loss without discarding the other common data.
- Finite aligned-loss stability compares two reference/candidate pairs under one common alignment. It supplies no comparison between different gauges.
- Error-channel passage means exactly an `ENNReal` error value below its own channel-specific upper budget. Structural requirements are separately typed nonnumeric propositions; joint passage uses one common candidate and alignment. Empty inventories remain vacuous and prove no external coverage.
- A nonempty finite alignment family supplies mathematical attainment, not runtime optimizer correctness. Finiteness does not imply mandatory-channel passage; the channel-conformance premise remains separate.
- Model-class transfer requires an explicit conformant embedding; nominal nesting alone transfers nothing.
- The module owns no paper-specific tables, plots, interpolation, convexification, KKT assumptions, runtime serialization, or numerical evidence.
- `docs/theorem-manifest.md` is the declaration ledger.

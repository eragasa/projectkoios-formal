# Finite decision layer

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19

This semantic module family owns finite multiobjective comparison, Pareto efficiency,
coordinatewise threshold feasibility, minimum-cost attainment, robustness, and explicit
empty-feasibility classification.

`FinitePareto.lean` currently provides weak-all/strict-any minimization dominance,
existence of an efficient weak improver in a finite decision type, Pareto sufficiency for
coordinatewise threshold feasibility, feasibility monotonicity under relaxed thresholds,
minimum-cost attainment, minimum-cost antitonicity under relaxation, and an exhaustive
logical classification of empty inventory, individual-channel emptiness, disjoint
nonempty channels, and joint feasibility.

`FiniteCutoff.lean` provides `BG-DECISION-DEF-010/011` and
`BG-DECISION-THM-014--016`: a first-passing cutoff passes and every earlier declared
cutoff fails, exists whenever the finite ordered inventory contains a passing member, is
unique, and requires one common cutoff for both channels. No monotonicity assumption is
used.

It does not own paper-specific objective tables, plotted surfaces, interpolation,
convexification, KKT assumptions, runtime serialization, or numerical evidence. A result
is exhaustive only for its declared finite decision type.

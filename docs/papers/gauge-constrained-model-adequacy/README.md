# Gauge-constrained model adequacy

This directory contains a Formal-owned working paper on alignment-family-relative operator adequacy, Fourier locality, and exact finite decisions. It is not a submitted paper, publication, novelty determination, scientific-validation record, runtime certificate, or owner of numerical evidence.

## Proposed question

How does the declared alignment family change a finite model-adequacy decision, and which conclusions survive fixed or pointwise unitary changes of representation?

The current checked foundation supports three connected statements:

1. feasibility transfers from a smaller alignment family to a larger family through explicit inclusion, while reverse transfer fails in general;
2. one fixed unitary commutes with the finite Fourier and truncation constructions formalized here, while pointwise unitary conjugation may change Fourier coefficients even though it preserves pointwise Frobenius power; and
3. exact admissible-set, interval, and first-passing logic can classify a declared finite inventory without promoting threshold overlap or incomplete coverage to a decisive result.

The explicit two-point rank-two gauge--truncation counterexample and the finite root-mean-square and maximum Fourier-tail results are proved in the pinned Formal snapshot.

## Mathematical authority

The authority order is:

1. Lean declarations and proof terms under `ProjectKoios/`;
2. declaration identity and status in `docs/theorem-manifest.md`;
3. statement-level explanations under `proofs/`;
4. synthesis in this working paper.

Prospective external manuscripts and research notes may motivate work but do not determine theorem statements or status here. Later exported prose must identify the exact Formal commit and declaration IDs from which it was derived.

## Layout

- `manuscript.tex` — composition root, abstract, and status warning;
- `chapters/01-proof-architecture.tex` — question, authority, status axes, and dependency structure;
- `chapters/02-finite-dimensional-operator-foundations.tex` — representation-neutral finite frames, projectors, compression, and reconstruction;
- `chapters/03-bloch-alignment-and-fourier-locality.tex` — momentum-indexed frames, aligned differences, alignment families, gauge actions, and Fourier locality;
- `chapters/04-reduction-and-decision-structure.tex` — admissibility, certificates, perturbation, and finite decisions;
- `chapters/05-mechanization-status-and-open-obligations.tex` — checked families, publication gaps, and proposed theorem work.

## Snapshot boundary

The current theorem basis is Formal merge commit `b56d6b8e7005515220e6c9bf42851acccb023178`, tree `a94b113d3300ff8e692f295da82945f48fb7d6ed`. The paper must be refreshed or explicitly marked historical after theorem statements, toolchain pins, or manifest status change.

## Required work before publication assessment

- verify every manuscript claim against its exact declaration and proof dossier;
- render unproved mathematical statements and proposed theorem tasks in red until a matching checked declaration exists;
- keep the proved two-point gauge--truncation counterexample pinned to its exact declarations and scope;
- add a declaration-to-section crosswalk;
- write the mathematical arguments rather than only inventorying theorem families;
- follow each displayed theorem proof with ordinary scholarly prose explaining its role in the paper, without formulaic significance headings;
- complete prior-art and novelty review;
- add an independently checked bibliography;
- obtain independent mathematical and artifact review; and
- decide whether a frozen finite case study belongs in the paper.

## Local build

Compile into a temporary directory:

```bash
mkdir -p /tmp/projectkoios-gauge-adequacy-paper
latexmk -pdf \
  -output-directory=/tmp/projectkoios-gauge-adequacy-paper \
  docs/papers/gauge-constrained-model-adequacy/manuscript.tex
```

A successful LaTeX build establishes formatting only. It does not check Lean or establish scientific authority.

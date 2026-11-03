# Compatibility of spectral and operator reductions

This directory contains a Formal-owned proof companion for the central model-adequacy
problem stated in the ICMSEP extended abstract: whether spectral and aligned-operator
criteria admit one common Hamiltonian within each class of a declared model hierarchy.
Its mathematical presentation is intended to be publication quality, while its proofs,
assumptions, crosswalks, and reproducibility appendices remain more detailed than a
final narrative article.

The companion is not itself a submission, publication, novelty determination,
scientific-validation record, runtime certificate, or owner of numerical evidence.
Those statuses require separate evidence and authorization.

## Mathematical question

For each candidate model class `M_j`, spectral and operator losses define admissible
sets `A_E,j` and `A_H,j`. The primary exact question is whether

```text
A_E,j ∩ A_H,j ≠ ∅,
```

so that one candidate satisfies both criteria. If the sets are disjoint, their distance
may quantify the obstruction under explicit metric and attainment hypotheses. Repeating
the joint decision over a finite ordered hierarchy identifies the first tested class
that admits a common endpoint.

Alignment families, Fourier locality, and truncation are supporting parts of the
operator-admissibility criterion. They are not substitutes for the spectral–operator
intersection problem. The checked foundation supports:

1. finite retained-space, compression, reconstruction, and alignment identities;
2. explicit separation of identity, global-unitary, and pointwise-unitary alignment
   families;
3. fixed-unitary Fourier equivariance and an exact pointwise-gauge/truncation
   counterexample;
4. an exact interpolation–truncation–total residual identity with pointwise, maximum,
   and root-mean-square triangle bounds;
5. finite root-mean-square and maximum Fourier-tail control for the deliberate-
   truncation leg;
6. exact admissible-set geometries, certificate soundness, and three-way interval
   decisions; and
7. first-passing selection over one declared finite inventory;
8. a generic finite compatibility schema separating central infimum-based compatibility
   from stronger common-alignment witness compatibility, with finite central admissible
   sets, attained separation under nonemptiness, zero/positive distance converses,
   explicit conformant model embeddings, and first-compatible selection;
9. exact finite-rank analytic-parent gap controls and arbitrary-dimensional right-unitary
   gauge construction;
10. pointwise-gauge Fourier convolution, support inclusion, and complete-shell
    `R_A + 2 R_U` bounds with source-neutral integer-lattice radii;
11. exact finite-support Fourier least squares and direct onsite/nononsite Frobenius-power
    partitioning; and
12. an exact two-band example in which spectral projection destroys finite Fourier support.

The current theorem basis packages the generic exact finite logic but does not instantiate
the complete ICMSEP study as one proposition-specific Lean theorem, and it contains no
retained bulk-silicon runtime certificate.

## Editorial architecture

The mathematical narrative comes first. The six numbered chapters develop the central
spectral–operator compatibility problem, operator foundations, alignment and Fourier
analysis, finite-rank gauge and locality controls, admissible-set and certificate logic,
and the remaining end-to-end formal obligations. Code-facing material is kept in
appendices:

- `appendices/A-formal-declaration-crosswalk.tex` records declaration IDs, Lean names,
  module locations, proof-dossier locations, and mechanization status;
- `appendices/B-provenance-and-reproducibility.tex` records the immutable Formal
  snapshot, the motivating ICMSEP source identity, hashes, authority hierarchy, audit
  boundary, and export requirements; and
- `appendices/C-notation-bridges.tex` records notation and sign bridges to inspected
  research sources; and
- `appendices/D-seven-paper-error-channel-crosswalk.tex` records the source-qualified
  development and evidence boundary of the residual-channel program across
  `Ragasa2026a` through `Ragasa2026g`;
- `references.bib` contains the external background bibliography; and
- `citation-audit.md` records each included source's persistent identity, inspected
  metadata surface, use, and authority boundary.

The main text may state that a result is exact or machine checked when that fact matters
to the argument, but repository mechanics, source paths, hashes, audit commands, and
workflow checklists belong in the appendices.

## Narrative proof policy

The companion is organized by mathematical argument, not by Lean declaration or proof-dossier
file. A chapter may combine supporting definitions and lemmas into one continuous proof arc,
provided that it preserves the exact hypotheses and identifies the principal checked declarations.
Small implementation lemmas need not become separate publication subsections.

The companion owns the extended publication-quality exposition. Statement-level dossiers remain
concise audit records containing the exact proposition, assumptions, dependency outline, Lean
realization, and proof-status boundary. Appendix A maps the narrative results to their stable Lean
IDs and dossiers, so the main chapters need not duplicate repository-level metadata or reproduce
one standalone dossier per paragraph of mathematics.

## Authority

The authority order is:

1. Lean declarations and proof terms under `ProjectKoios/`;
2. declaration identity and status in `docs/theorem-manifest.md`;
3. statement-level explanations under `proofs/`;
4. synthesis in this proof companion.

The ICMSEP extended abstract owns the motivating scientific problem statement, not the
exact Lean propositions or their proof status. Any shortened publication derived from
this companion must preserve the common-candidate quantifier, exact hypotheses, operand
conventions, declaration identities, and nonclaims recorded here.

## Snapshot boundary

The current theorem basis is Formal checkpoint commit
`1d703892a4363b87937648697a7835676394196b`, tree
`0744b8432a0cb1c7a264ba582dae1989fd1574c9`. Appendix B records the central module
hashes at that exact source state. The companion must be refreshed or explicitly marked
historical after relevant theorem statements, toolchain pins, or manifest status change.

The motivating ICMSEP source and the separate seven-paper error-channel source snapshot
are pinned in Appendix B. Their scientific, evidence, and publication statuses do not
transfer into Formal proof status.

## Remaining publication-facing work

- instantiate the generic finite compatibility schema with proposition-specific spectral
  and operator losses only after their source contracts are frozen, including concrete
  nonemptiness evidence when the finite separation converses are invoked;
- bind a concrete model hierarchy through reviewed conformant embeddings and a complete
  declared inventory;
- keep the cyclic-quotient-radius, character-gauge locality, supplied-shell, and fixed-subspace
  representation results outside this companion until an explicit reviewed refresh advances its
  pinned theorem basis; their integration into later Formal source does not retroactively change
  this companion's pin;
- prove polar neighbor transport and periodic closure, principal-angle identities,
  approximate fixed-subspace compression bounds, and general-rank spectral perturbation
  bounds;
- authenticate any KSD centered-FFT, quotient-coordinate, basis, frame, normalization,
  and array-ordering bridge before claiming runtime applicability;
- complete prior-art and novelty review;
- obtain independent review of the provenance-audited background bibliography;
- obtain independent mathematical and artifact review; and
- decide whether a frozen finite case study belongs in this companion or in a later
  application paper.

These tasks concern completeness and publication readiness. They do not downgrade the
proof status of declarations already checked in Lean.

## Local build

Compile into a temporary directory:

```bash
mkdir -p /tmp/projectkoios-spectral-operator-compatibility
latexmk -pdf \
  -output-directory=/tmp/projectkoios-spectral-operator-compatibility \
  docs/papers/gauge-constrained-model-adequacy/manuscript.tex
```

A successful LaTeX build establishes formatting only. It does not check Lean, numerical
execution, physical applicability, or scientific authority.

# Formal proof companions

These directories contain non-authoritative, Formal-owned proof companions. Their prose and mathematical presentation are intended to be publication quality, while their detailed proofs, assumptions, crosswalks, and reproducibility appendices remain more extensive than a final narrative publication. Exact propositions and proof terms remain in Lean source, declaration identity and status remain in `docs/theorem-manifest.md`, and statement-level explanations remain in `proofs/`.

## Current companions

- [`gauge-constrained-model-adequacy/`](gauge-constrained-model-adequacy/) — detailed proof companion on compatibility of spectral and aligned-operator reductions, with alignment families, three-channel residual calculus, Fourier locality, admissible-set geometry, and exact finite decisions as supporting layers.

## Requirements

Each companion must:

- identify its immutable Formal source revision;
- preserve declaration IDs, hypotheses, operand conventions, and nonclaims;
- distinguish checked results from proposed theorem work;
- distinguish proof from runtime evidence, applicability, novelty, and publication status;
- cite external sources only after source review;
- disclose absent independent review; and
- compile outside the repository without tracking generated output.

Prospective external manuscripts may receive bounded editorial exports from these companions. A final publication may shorten and reorganize the narrative, but it does not control theorem identity or status in this repository.

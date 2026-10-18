# Working papers

This tree contains human-readable working manuscripts that synthesize formalization status across multiple statements. A working paper is not a proof authority, owner-publication replacement, bibliography registry, release, submission, or scientific-validation claim.

The umbrella manuscript [`ragasa-formalization-working-paper.tex`](ragasa-formalization-working-paper.tex) covers the formalization program for the currently audited Ragasa2026A–C claim families. “Covers” means that every audited family has a visible status and boundary, not that every source claim is already restated or proved. Exact source prose remains in the owner repository; exact proof status remains in `docs/theorem-manifest.md`; one-statement mathematical explanations remain in `proofs/`.

The working paper must:

- preserve immutable owner-source locators and dirty-state limitations;
- distinguish analytic claims, contracts, numerical evidence, and nonclaims;
- link each formal result to its stable statement ID and individual proof dossier;
- describe standard mathematical ingredients as standard;
- present any contribution as methodological, computational, or applied unless a separate novelty review supports more;
- disclose AI assistance, trusted-base limits, and absent expert review; and
- remain visibly incomplete wherever claims, citations, certificates, or scientific instantiations are unresolved.

Compile into a temporary directory. Do not commit PDFs, logs, auxiliary files, or generated bibliography output.

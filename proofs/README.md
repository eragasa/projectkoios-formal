# Proof dossiers

This directory contains one human-readable LaTeX dossier per publication-facing Lean statement. Dossiers explain proofs; they do not replace Lean, the theorem manifest, source authority, or expert review.

## Purpose

A dossier makes one proof reviewable without changing its authority.

- Preserve the exact statement, assumptions, sources, readable argument, Lean realization, and audit result.
- Expose AI and automation use.
- Separate kernel checking from source fidelity, scientific interpretation, novelty, and publication status.
- Support later rechecking without claiming permanent software executability.

The maintainer operates and reviews this process as a computational materials scientist, not as an independent expert mathematician or theoretical physicist. AI-generated material remains untrusted until checked by Lean and reviewed against the stated sources and assumptions.

## File rule

Each dossier mirrors its Lean module path and uses one statement ID.

```text
ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean
proofs/BandGauge/Geometry/BG-THM-002-common-witness.tex
```

- Use one dossier for one publication-facing declaration.
- Do not create dossiers for planning IDs, searches, or unsourced generalizations.
- Keep helper-lemma documentation in Lean unless a separate source claim warrants a dossier.
- Update the existing dossier when only the proof changes.
- Create a new declaration and ID when the proposition changes.
- Treat `template.tex` as a template, not a claim.

The directory tree is the dossier index. `docs/theorem-manifest.md` is the status index.

## Required contents

A dossier records:

1. statement ID, status, module, and declaration;
2. exact mathematical statement;
3. immutable source identity and locator;
4. assumptions, conventions, and source-to-Lean delta;
5. statement-specific prior art and contribution boundary;
6. proof structure and readable proof or explicit gap;
7. Lean dependencies and realization summary;
8. trusted-base and `#print axioms` results;
9. AI, automation, toolchain, maintainer-context, and independent-review status;
10. numerical, certificate, and external-evidence boundaries;
11. unresolved questions; and
12. review history.

Headers record Eugene Joseph M. Ragasa as author, `Apache-2.0`, and the initial completion date. Exposition changes do not rewrite that date. Historical metadata requires an auditable backfill.

## Prior art

Use the relations defined in `docs/reference-crosswalk-policy.md`:

- `formalizes`
- `adapts`
- `depends-on`
- `compares-with`
- `background-only`

`projectkoios-references` owns canonical literature identity and bibliography metadata. Mark unresolved identity as unresolved; do not mint a local canonical identity or bibliography.

For witness/separation work, the metric facts, feasible-set language, witness/infeasibility distinction, and validated lower-bound methods carry no local priority claim. The stated contribution is their source-traceable integration into a threshold-defined joint spectral and restricted aligned-operator decision procedure. A bounded terminology search does not establish novelty or priority.

## Authority

Dossiers remain explanatory documents.

- Lean and `docs/theorem-manifest.md` determine formal proof status.
- Dossier compilation proves nothing.
- A proved proposition does not establish physical applicability, valid numerical evidence, novelty, complete citation coverage, or publication readiness.
- Current dossiers are drafts unless a separate release record states otherwise.

## Build

Compile outside the repository.

```console
out="$(mktemp -d /tmp/projectkoios-proof.XXXXXX)"
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir="$out" proofs/path/to/dossier.tex
rm -rf "$out"
```

Do not commit generated PDFs, logs, auxiliary files, or bibliography output.

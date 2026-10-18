# Per-proof LaTeX dossiers

This tree contains one human-readable LaTeX dossier per publication-facing formal statement. It is not a monolithic claims document, a second Lean source tree, a bibliography registry, or independent proof authority.

## Maintainer perspective and purpose

I am not a research mathematician or theoretical physicist. My primary training and practice are in computational materials science, with some graduate mathematics training. I can work through a proof and reach a partial, practical understanding, but doing so may require hours of effort. I do not claim that this amounts to independent expert mathematical review. These dossiers are intended to make comprehension possible rather than conceal the work behind compressed formal code or unexplained automation.

The proofs pursued here are purpose-driven. They address exact mathematical questions that arise in the computational and scientific work I need to evaluate; they are not an attempt to develop a comprehensive theory or to claim novelty for standard mathematics. The long-term goal is durable recheckability: preserve an exact statement, its assumptions, its sources, a human-readable argument, and a kernel-checked Lean realization so that the result can be checked again rather than accepted from memory or authority. This is an aspiration to durable verification, not a literal guarantee that software, dependencies, or file formats will remain executable forever.

Substantial parts of proof discovery, draft arguments, explanatory prose, and Lean implementations are AI-generated or AI-assisted. AI output is untrusted assistance, not mathematical or scientific authority. My role is predominantly computational: I build and operate the process, select questions arising from the scientific work, preserve source and toolchain provenance, run Lean and the repository audits, read the resulting arguments as far as I am able, and add the computational and scientific context in which the statements matter. I do not claim to derive every proof independently or to provide expert mathematical validation.

In the age of AI, the problem I am trying to address is how to build machinery through which untrusted generated material becomes an exact, inspectable statement with a proof term checked against an explicit trusted base, while provenance, assumptions, and remaining uncertainty stay visible. This repository is my attempt to build that machinery and then comprehend what comes out of it. Otherwise, I would be operating software without understanding what it asserts or why; avoiding that outcome is why I went down this rabbit hole.

For each proof, the corresponding dossier must record the actual automation and toolchain provenance, the exact statement Lean checked, the axiom report, what I was able to read or contextualize, whether independent expert review occurred, and what remains uncertain. It must not relabel my operation of the process as expert human proof review. My practical understanding is valuable to me, but it does not replace kernel checking, source fidelity, attribution, or independent expert review.

Attribution is a continuing best-effort obligation. I have attempted to credit the origins, precedents, and methods on which these proofs rely, while recognizing that searches can miss prior work and AI-generated attributions can be wrong. Candidate references must therefore remain visibly unresolved until checked through the repository's reference-authority process. Corrections and stronger primary sources should be recorded rather than hidden.

## Value for scientific papers

These dossiers are intended to support papers that make exact mathematical claims, especially claims that are central, reusable, or easy to misstate. A completed dossier can:

- give readers a machine-checkable result rather than asking them to trust AI-generated prose;
- expose the exact assumptions, conventions, and scope of the theorem;
- prevent a checked theorem from being confused with numerical evidence or a broader physical conclusion;
- provide a readable mathematical argument for readers who do not use Lean;
- disclose how AI and other automation contributed; and
- allow later papers to reuse an exact result rather than repeat an informal argument.

Lean proves the encoded proposition under its explicit dependencies. It does not establish that the proposition is the correct physical model, that its hypotheses hold for a material or computation, that numerical evidence is valid, that the result is novel, that the citations are complete, or that the scientific interpretation is sound. Those remain separate scientific, historical, and review obligations.

For the witness/separation work, the contribution is methodological rather than theorem novelty. The metric facts, feasible-set language, witness/infeasibility distinction, and validated lower-bound machinery are established ingredients. This project integrates them into a threshold-defined decision procedure for joint spectral and restricted aligned-operator adequacy with precise certificates and scope limitations. The classical facts carry no priority claim. A bounded terminology search establishes no priority.

For a publication-facing result, the preferred package is:

1. a concise statement in the paper that does not exceed the Lean theorem;
2. the exact Lean declaration and an immutable repository revision;
3. a corresponding per-proof LaTeX dossier as supplementary material;
4. the Lean version, Mathlib revision, build result, and axiom report;
5. an explicit boundary between formal proof, checked certificates, numerical evidence, and physical interpretation;
6. an AI-assistance disclosure consistent with the venue's policy; and
7. when separately authorized, an archived reviewed release with a persistent identifier.

Use this machinery for substantive publication claims, not every internal helper lemma. The current foundational theorems formalize generic decision logic. They do not instantiate the paper's loss functions or establish a scientific result.

Current draft dossiers:

- [`BG-THM-001-feasible-pair-upper-bound.tex`](BandGauge/Geometry/BG-THM-001-feasible-pair-upper-bound.tex);
- [`BG-THM-002-common-witness.tex`](BandGauge/Geometry/BG-THM-002-common-witness.tex);
- [`BG-THM-003-certified-separation.tex`](BandGauge/Geometry/BG-THM-003-certified-separation.tex); and
- [`BG-THM-004-compact-attainment-positive-distance.tex`](BandGauge/Geometry/BG-THM-004-compact-attainment-positive-distance.tex).

Each dossier records its statement ID and the status listed in `docs/theorem-manifest.md`. The files remain draft and unreleased; accepted literature identities, the real-valued bridge, and scientific instantiation remain unresolved. `template.tex` remains a template, not a claim.

## Organizing principle

A dossier is keyed by one Project Koios Formal statement ID and mirrors the owning Lean module path. For example:

```text
ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean
proofs/BandGauge/Geometry/BG-THM-002-common-witness.tex
```

Use one dossier for one publication-facing Lean declaration. Do not create dossiers for broad planning families such as `BG-PLAN-001`, search attempts, or unsourced generalizations. Internal helper lemmas normally remain documented by Lean source unless they carry an independently sourced claim that warrants a dossier.

A changed proof of the same exact statement updates the existing dossier. Once a proved statement has an ID, do not change that proposition under the same ID. If a different result is needed, create a new Lean declaration with a new ID and build on the earlier theorem.

## Lifecycle

Every dossier begins with exactly one statement ID and one formal status matching `docs/theorem-manifest.md`.

A dossier may be drafted once there is an exact declaration, an owning module and namespace, an immutable owner-source locator, an assumption-delta review, and a decision about applicable prior-art relationships. Draft formatting does not alter theorem status. A proved theorem is not thereby released, paper-specific, scientifically validated, novel, or publication-ready.
## Required dossier sections

Each dossier must contain:

1. statement ID, status, module, and declaration;
2. exact mathematical statement;
3. immutable source provenance and source locator;
4. assumptions, conventions, and source-to-Lean delta;
5. statement-specific prior art and a novelty/contribution boundary;
6. a proof schematic showing the argument's dependency and implication structure;
7. a human-readable mathematical proof or an explicit proof gap;
8. the Lean realization and library dependencies without duplicating the full Lean file;
9. trusted-base and `#print axioms` results;
10. AI/automation and toolchain provenance, maintainer comprehension/context notes, and independent-review status;
11. numerical, certificate, and external-evidence boundaries;
12. unresolved questions; and
13. review and revision history.

The proof schematic should expose the inputs, definitions, principal reductions, imported lemmas, critical implications, conclusion, and any branch that remains an external or numerical obligation. It should let a reader see the proof's shape before reading either prose or Lean.

The dossier must distinguish the mathematical proof from Lean implementation notes. It may quote the final Lean declaration signature, but it must not duplicate long tactic scripts or exploratory proof bodies.

## Prior-art rules

Prior art belongs to the particular statement, not to an undifferentiated project bibliography. Use only the closed relation vocabulary from `docs/reference-crosswalk-policy.md`:

- `formalizes`;
- `adapts`;
- `depends-on`;
- `compares-with`; and
- `background-only`.

`projectkoios-references` owns canonical literature identity, citekeys, bibliography metadata, and bibliography rendering. A dossier records References-owned canonical and authority IDs plus exact locators. Titles, authors, DOI values, and rendered citations are non-authoritative display fields.

If identity is unresolved, label the entry unresolved and retain only approved candidate or observation IDs. Do not mint a Formal-owned literature identity or commit an independent `.bib` file here.

A citation attachment does not establish originality, correctness, scientific support, or proof completion. State whether a source directly supplies the claim, supplies a method, is only comparison/background, or requires a derived step.

## Relationship to other repository surfaces

- `docs/` owns policy, planning, source audits, manifests, and crosswalks.
- `ProjectKoios/` owns accepted Lean definitions and proofs.
- `proofs/` explains one accepted statement and proof at a time.
- `papers/` supplies cross-statement working narratives and status matrices without replacing individual dossiers or Lean authority.
- Future replayable experiments, if approved, belong in a separately audited probe/test surface rather than in dossiers.

The Lean declaration and kernel check are authoritative for formal proof status. The dossier is an auditable human explanation and attribution record; compiling its LaTeX does not prove its claim.

## Building a dossier

Compile outside the repository tree so generated artifacts are not retained:

```console
out="$(mktemp -d /tmp/projectkoios-proof.XXXXXX)"
latexmk -pdf -interaction=nonstopmode -halt-on-error \
  -outdir="$out" proofs/path/to/dossier.tex
rm -rf "$out"
```

Do not commit PDFs, auxiliary files, logs, or generated bibliography output. A LaTeX build check is separate from the Lean build and axiom audit.

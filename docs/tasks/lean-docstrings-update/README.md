# Lean docstring update task

## Goal

Bring every repository-owned Lean module into conformance with
[`docs/lean-code-standards.md`](../../lean-code-standards.md), using a Lean-native analogue of NumPy
docstrings for module documentation and public mathematical declarations.

This is a documentation migration. It must not change declaration names, propositions, proof terms,
stable IDs, imports, theorem status, or scientific claims unless a separate reviewed change requires
that modification.

## Baseline

Baseline inventory taken when this task was created:

- 155 repository-owned `.lean` files, including the Lake package root and Lean support script;
- 150 files containing a module docstring marker (`/-!`);
- 142 files containing at least one declaration docstring marker (`/--`); and
- 0 files containing a source-defined `## Proof schematic` Mermaid block.

These counts measure marker presence only. They do not establish compliance with the new standard.
Import-only namespace roots may correctly contain no declaration docstrings. The live checklist now
contains 159 entries after adding the `Operator/SelfAdjoint.lean`, `Operator/Schrodinger.lean`,
`Operator/Hydrogen.lean`, and `HarmonicOscillator/Continuum.lean` modules; this does not rewrite the
task-creation baseline above.

`ProjectKoios/DensityFunctionalTheory/PAW/ProjectorAugmentation.lean` now contains the first pilot
source-defined proof schematic. Its module checklist item remains open until the complete module and
declaration documentation review is finished.

The five files without a module docstring marker at task creation are:

- `ProjectKoios/Audit.lean`;
- `ProjectKoios/BandGauge/Bloch/AlignedDifferenceBounds.lean`;
- `ProjectKoios/SolidState.lean`;
- `ProjectKoios/SolidState/FiniteLattice.lean`; and
- `scripts/DeclarationDependencyGraph.lean`.

## Checklist semantics

The complete module inventory is in [`checklist.md`](checklist.md). Check a module only after all
applicable work below is complete:

1. Review or add the module docstring using the Physlib-compatible title, one-line summary,
   `Overview`, `Key results`, `Table of contents`, `References`, and lettered-section structure.
2. For a substantive module that owns mathematical declarations, add one lettered `Proof schematic`
   Mermaid block to the module docstring and list it in the table of contents. Apply this by module
   role and dependency structure, not by the historical choice between Lean's `theorem` and `lemma`
   keywords. Show conceptual mathematical dependencies rather than tactic execution or dossier
   presentation order.
3. Review every public, mathematically meaningful definition, structure, abbreviation, lemma, and
   theorem in the module.
4. Ensure each reviewed declaration begins with a one-sentence physics or mathematical role and
   records its stable ID in a separate Project Koios metadata sentence.
5. Confirm that supporting results are presented as `lemma` prospectively and reserve `theorem` for
   principal literature-facing results; preserve established declarations unless a separate
   migration is authorized.
6. Add only applicable semantic sections: mathematical statement, parameters, assumptions,
   conclusion or value, conventions, source, scope, see also, and examples.
7. Preserve exact source locators and state the adaptation boundary for source-bound mathematics.
8. Replace vague disclaimers with concrete formal scope and genuinely absent hypotheses.
9. Keep source-neutral algebra free of downstream scientific semantics unless the declaration is an
   explicit binding.
10. Preserve public structure-field docstrings.
11. Review long proofs for meaningful extraction rather than merely reducing line count.
12. Compile the changed module and its bounded affected consumers.
13. Run `git diff --check` and confirm that no declaration statement, stable ID, manifest status, or
    axiom report changed unintentionally.

For import-only roots and audit drivers, apply the module-level requirements and document their
organizational or audit role; do not invent declaration documentation where no declaration exists.

## Declaration-presentation decision

Adopted strategy: **preserve the local legacy presentation during this migration**.

- Do not bulk-change established local `theorem` declarations, `THM` IDs, dossier paths, manifest
  rows, crosswalks, or provenance solely for Physlib compatibility.
- Apply the desired `lemma`-by-default discipline to new declarations prospectively.
- Physlib and PhyslibAlpha integration is local and namespace-mirrored; no upstream port is part of
  this task.
- If external adaptation is later reopened, it must be separately scoped and must not alter the
  local stable IDs or presentation implicitly.
- Revisit historical local reclassification only as a separate explicitly reviewed migration.

This decision keeps the docstring migration documentation-only and prevents presentation churn from
obscuring semantic review.

## Migration order

Use bounded waves rather than one repository-wide rewrite:

1. **Pilot:** one source-bound scientific module, one source-neutral algebra module, and one
   import-only or audit module.
2. **Recent DFT and finite-dimensional quantum mechanics:** establish examples for source locators,
   assumptions, conventions, and formal-scope language.
3. **Remaining QuantumMechanics, SolidState, and Crosswalks modules.**
4. **BandGauge foundations and Fourier modules.**
5. **Remaining BandGauge alignment, decision, certificate, projection, paper-binding, and bridge
   modules.**
6. **Final consistency review:** terminology, headings, links, source formatting, and stale
   boilerplate.

Each wave should be reviewed and validated before beginning the next. A checked module must remain
compilable as part of its ordinary affected target set.

## Completion criteria

The task is complete when:

- every item in `checklist.md` is checked;
- all public mathematical declarations satisfy the prospective documentation standard;
- every substantive module that owns mathematical declarations has a source-defined Mermaid proof
  schematic that renders in the whole-repository compendium;
- import-only and audit modules have accurate module-level documentation;
- exact source locators and adaptation boundaries remain truthful;
- targeted compilation evidence exists for every changed wave;
- repository audit and coverage checks still pass; and
- a final consistency review finds no generic boilerplate, hidden assumptions, or documentation that
  overstates formal or scientific status.

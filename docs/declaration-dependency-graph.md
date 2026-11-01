# Declaration dependency graph

The declaration dependency graph is a read-only audit view of the compiled Lean environment. It
answers which repository declarations directly occur in the type or value of each declaration in
the authoritative declaration table of [`theorem-manifest.md`](theorem-manifest.md).

It is not an additional proof registry, a workflow engine, or scientific evidence. The compiled
Lean environment and declaration manifest remain authoritative.

## Generate the graph

From the repository root, run:

```console
scripts/declaration-dependency-graph.sh
```

The script requires an already existing, validated
`.lake/build/lib/lean/ProjectKoios/Audit.olean`; it never invokes `lake build`, `lake update`, or any
other command that creates or refreshes compiled Lake artifacts or dependency materialization. It
verifies that every manifest declaration is present in that compiled environment, rejects duplicate
statement IDs or declaration names, and writes only ignored generated graph outputs under
`.lake/build/audit/`:

- `declaration-dependencies.json` — complete machine-readable graph using schema
  `PKF-DECLARATION-DEPENDENCY-GRAPH/1`;
- `declaration-dependencies.dot` — Graphviz view restricted to registered manifest declarations;
- `declaration-dependencies-full.dot` — full Graphviz view including generated and unregistered
  repository dependencies;
- `module-dependencies.dot` — readable cross-module aggregation with declaration counts and collapsed
  edge multiplicities;
- `quantum-mechanics-dependencies.dot` — declaration-level view restricted to the current quantum
  modules; and
- corresponding SVG views when Graphviz `dot` is available.

Generated graph files must not be committed or treated as immutable evidence. The script does not
prove that the existing Audit artifact is fresh for the working tree; freshness comes from separately
retained validation evidence for the exact Lean sources and dependency identities. A retained audit
must identify that evidence, the repository revision, Lean toolchain, Mathlib pin, command, and
graph-schema identity.

## Nodes and edges

Registered nodes carry their stable ID, exact Lean declaration, presentation kind, defining module,
transitive axiom report, and directly used external modules. Definitions are blue, lemmas are
yellow, and theorems are green in the DOT output.

An edge

```text
A -> B  [direct-kernel-dependency]
```

means that `B` occurs directly among the constants used by the compiled type or value of `A`. The
registered DOT file retains edges whose source and target are both registered declarations. The JSON and
full DOT outputs additionally expose:

- gray generated children such as structure constructors, projections, and recursors; and
- red repository declarations used by registered declarations but not represented by a manifest
  row or recognized as a generated child.

A red node is a review prompt, not automatically an error. It may identify missing inventory
coverage, an intentionally unnumbered support declaration, or a compiler-generated declaration not
recognized by the conservative parent rule.

## Uses

The graph supports:

- direct and transitive change-impact analysis;
- detection of inappropriate dependency direction between source-neutral and paper-specific code;
- identification of highly reused definitions and lemmas;
- review of axiom propagation and unregistered dependencies;
- comparison of author-facing `DEF`/`LEM`/`THM` presentation with actual use; and
- reconstruction of the exact formal dependency spine of a publication-facing result.

## Roadmap overlay

Actual kernel dependencies and intended future work must remain visually distinct. The goal spine
in [`roadmap.md`](roadmap.md) uses solid descriptions of implemented/current layers and dashed
planning arrows for intended work. A planned arrow does not mean that a Lean declaration, proof,
source crosswalk, numerical certificate, or scientific validation exists.

The roadmap may be compared with this generated graph to ask what is missing between the current
formal frontier and a stated target. Roadmap status must never be imported into the kernel graph as
though it were a proof dependency.

## Limitations

The graph does not record tactic scripts, discarded proof-search attempts, source fidelity,
literature priority, numerical execution, physical applicability, or scientific validity. A direct
kernel edge also does not explain why a dependency is mathematically important. Those meanings
remain in proof dossiers, source crosswalks, evidence contracts, and reviewed prose.

# Certificate vocabulary

“Certificate” is qualified by its checker and conclusion. The word alone must not imply a formal mathematical proof or scientific validation.

## Repository certificate classes

| Class | Required contents | Current availability | Nonclaim |
|---|---|---|---|
| Dependency lock record | toolchain plus direct and transitive immutable revisions | available through `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json` | does not prove API suitability or scientific correctness |
| Source snapshot record | owner repository, local branch, immutable commit, relative paths, and byte hashes | available in `source-audit.md` | does not copy or own source content |
| Build record | exact commands, tool versions, and success/failure result | reproducible commands documented; generated logs are not retained as an evidence package | does not prove scientific theorems beyond compiled declarations |
| Theorem inventory | fully qualified declarations and honest proof status | startup inventory available | planned or metadata entries are not theorems |
| Axiom report | `#print axioms` output for named declarations | available for startup declarations | says nothing about declarations not audited |
| Publication crosswalk | source statement location, assumptions, and Lean declaration/status | available at metadata level | does not formalize the statement |
| Exact scientific certificate | exact data, parser/checker, soundness theorem, and bound input identity | none | numerical output is not silently promoted to this class |

## Certificate lifecycle

A future exact scientific certificate moves through these states:

1. **proposed** — data and target proposition are described;
2. **specified** — exact encoding, parser, checker, and rejection behavior are fixed;
3. **implemented** — checker exists but has not passed the complete audit;
4. **checked** — a bound certificate passes the pinned checker;
5. **crosswalked** — the checked result is linked to a reviewed theorem and source claim.

Only the final two states may support a claim about a particular certificate, and neither implies scientific acceptance beyond the encoded conclusion.

## Retention policy

Do not commit generated build state, large numerical outputs, runtime caches, or private source artifacts. A retained certificate package, if later authorized, should contain only the exact compact inputs, identities, checksums, checker coordinates, audit output, and readable status needed to reproduce its bounded conclusion.

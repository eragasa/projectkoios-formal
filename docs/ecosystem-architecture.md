# Ecosystem architecture

`projectkoios-formal` is a verification sidecar, not a runtime layer.

## Ownership

Formal owns:

- Lean definitions and proofs;
- immutable proof dependencies;
- theorem and axiom inventories;
- exact certificate checkers; and
- source-to-formalization crosswalks.

Formal does not own:

- scientific execution or external runtime behavior;
- owner-publication prose;
- external numerical evidence; or
- scientific acceptance.

## Dependency direction

Formal consumes identities and exact certificates without entering runtime dependency graphs.

```text
owner sources ──read-only identity──→ Formal
runtime repositories ──optional exact certificate──→ Formal
Formal ──theorem and audit record──→ review
```

- Evidence flow is not a source-code import.
- Runtime repositories do not acquire Lean as a transitive dependency.
- Owner sources remain read-only and unvendored.
- Root modules remain narrow.

## Executable verification boundary for computational peers

The same boundary applies to `ksdft2effmass`, `projectkoios-physkit`, and the
`projectkoios.numerics` and `projectkoios.optimization` packages owned by
`projectkoios-optimization`.

Each computational owner repository owns its own runtime abstractions, nominal abstract
classes, immutable records, numerical algorithms, serializers, and validation. This
repository must not become the provider of a production Python superclass that those
packages subclass. Cross-repository subclassing would turn the formal sidecar into a
runtime compatibility layer, couple owner APIs to formal-repository releases, and still
would not prove that a Python instance satisfies a Lean hypothesis.

This repository may instead provide executable verification through:

1. a versioned, machine-readable certificate contract;
2. exact or outward-interval certificate data types on the Lean side;
3. a parser and fail-closed checker;
4. soundness theorems stating what checker acceptance implies;
5. frozen conformance fixtures and checker invocation documentation; and
6. machine-checkable contract-version and immutable-revision identities.

An owner repository may provide an optional export adapter that translates its native
records into canonical certificate bytes. The adapter remains owner code and need not
inherit from a class in this repository. Its output is accepted only after schema,
identity, coverage, support, weight, witness, interval, and objective checks. A shared
runtime ABC, if ever necessary, belongs in a separately governed neutral package and
requires an explicit dependency and ownership decision; it must not be introduced as a
convenience facade here.

The intended owner-specific roles are:

- `projectkoios.physkit` supplies reusable computational-physics representations,
  unit-aware quantities, finite-domain constructions, and numerical evidence for their
  declared contracts;
- `projectkoios.numerics` supplies reusable transforms, decompositions, numerical
  geometry, diagnostics, and capability-local numerical backends;
- `projectkoios.optimization` supplies reusable alignment, selection, fitting,
  constrained-minimization, assignment, search, and optimization evidence;
- `ksdft2effmass` composes those capabilities into scientific calculations and owns
  campaign-specific interpretation, thresholds, and retained evidence; and
- `projectkoios-formal` checks explicitly exported mathematical claims without assuming
  authority over the producing implementation.

A development or publication-verification job may pin an immutable
`projectkoios-formal` revision, produce and independently reconstruct a compact
certificate, and invoke its checker. That job is an offline verification lane, not a
production runtime import. Passing it establishes only the checker's proved conclusion
under the encoded premises; it does not establish physical applicability, empirical
adequacy, software independence, scientific acceptance, or publication status.

## Bridge types

Four bridge types keep responsibilities separate.

1. **Source crosswalk:** repository, commit, path, locator, and byte identity.
2. **Mathematical instantiation:** explicit hypotheses connect a reusable theorem to an owner result.
3. **Exact certificate:** exact data passes a checker with a soundness theorem.
4. **External obligation:** numerical or runtime evidence remains outside Lean.

JSON, CSV, plots, logs, and binary64 values are not formal inputs without an explicit exact bridge.

## Module growth

A new consumer-oriented namespace requires:

- a selected statement or reusable definition;
- owner and source identity;
- reviewed dependency direction;
- justification for its location; and
- classification as reusable mathematics, certificate checker, or thin crosswalk.

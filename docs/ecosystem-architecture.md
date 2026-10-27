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

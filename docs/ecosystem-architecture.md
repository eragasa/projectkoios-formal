# Ecosystem architecture

`projectkoios-formal` is a horizontal formalization hub for the Project Koios ecosystem. It is not an additional runtime layer inserted between computational repositories.

## Peer relationship

Repositories such as `physkit`, `projectkoios-optimization`, and `ksdft2effmass` remain peers with their own authority and dependency boundaries. Their exact ownership is defined by their own instructions and authoritative source documents, not by this repository.

This repository owns:

- reusable Lean definitions and proofs selected for Project Koios;
- immutable dependency coordinates for those proofs;
- theorem and axiom inventories;
- exact certificate checkers, if separately specified and implemented; and
- source-to-formalization crosswalks.

It does not own:

- production scientific execution;
- Python, C, C++, Quantum ESPRESSO, VASP, or Wannier90 runtime behavior;
- owner-repository publication prose;
- numerical evidence merely referenced by a theorem; or
- scientific acceptance of a model or calculation.

## Dependency rule

The default relationship is a parallel specification sidecar:

```text
owner publications/specifications ──read-only identity──→ projectkoios-formal
computational repositories         ──optional exact certificate──→ projectkoios-formal
projectkoios-formal                ──theorem/audit record──→ human and repository review
```

The arrows describe evidence flow, not source-code imports. In particular:

- computational runtimes do not acquire Lean as a transitive execution dependency;
- this repository does not import Python/C implementation trees as proof authority;
- owner repositories are inspected read-only rather than vendored;
- no cross-repository circular dependency is introduced; and
- a future Lean consumer may depend directly on this Lake package only after its supported import surface is reviewed.

## Cross-repository bridges

A bridge must use one of these explicit forms:

1. **Source crosswalk** — repository, local branch, immutable commit, relative path, statement location, and cited-byte identity.
2. **Mathematical instantiation** — an owner-specific result follows from a reusable Lean theorem after all assumptions are supplied explicitly.
3. **Exact certificate boundary** — compact exact data is parsed and checked by a specified checker with a soundness theorem.
4. **External obligation** — numerical or runtime evidence remains outside Lean and is named as an unresolved or separately verified premise.

JSON, CSV, plots, logs, or binary64 values do not become formal inputs merely because they can be read by a program.

## Module-growth rule

Do not create broad `PhysKit`, `Optimization`, or KSD module trees speculatively. A new consumer-oriented namespace or directory requires:

- one selected formal statement or reusable definition;
- a documented owner and source identity;
- a reviewed dependency direction;
- a reason it does not belong in an existing foundational module; and
- an explicit decision about whether it is reusable mathematics, a certificate checker, or a thin crosswalk.

This keeps both Lake imports and ecosystem dependencies shallow. Root modules remain narrow and do not re-export every downstream area.

## Scientific boundary

A theorem in this repository can establish only its encoded conclusion under its encoded assumptions. It does not validate the implementation that motivated the theorem, the numerical data used in a publication, or a material model unless those claims are separately represented and discharged through an explicit checked boundary.

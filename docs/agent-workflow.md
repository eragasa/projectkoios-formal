# Agent workflow for Lean work

This document describes a bounded workflow for Pi or another coding agent assisting with Lean. An agent is a development tool, not part of Lean's logical trusted base and not an authority for scientific claims.

## Instruction surface

`AGENTS.md` is the repository instruction surface. Do not add competing `SYSTEM.md`, skill, or compatibility instruction files merely to restate it. Session-level tools or skills may assist the work, but repository policy and the pinned Lean kernel remain authoritative.

## Required workflow

### 1. Establish identity

Before editing:

- inspect the current branch, commit, worktree, and uncommitted changes;
- read `AGENTS.md` and the applicable documentation;
- inventory the active Lean/Lake toolchain and immutable dependency pins; and
- resolve owner-source branch, commit, paths, and dirty-state limitations read-only.

### 2. Select the statement

Before proof search:

- cite the exact source statement;
- freeze scalar field, rank, dimension, domain, conventions, and assumptions;
- record any proposed assumption delta;
- choose the owning foundational module; and
- add or update a statement-level manifest entry only after review.

Do not begin with a generalized theorem merely because it appears mathematically natural.

### 3. Search existing libraries

Inspect the pinned Mathlib revision and, only when relevant, a compatible immutable Physlib revision. Record candidate declarations and why they fit or fail. Do not create a compatibility facade or duplicate a library definition to avoid a small amount of namespace work.

### 4. Develop against actual goals

Use compiler or language-server goal output rather than guessing proof states. Prefer the smallest affected check while iterating, followed by the complete repository gates.

Typical local loop:

```console
lake env lean path/to/AffectedModule.lean
lake build
```

The first command is appropriate only for an actual module path with its imports available. A language-server integration may be used when separately installed and reviewed; its suggestions remain untrusted until Lean accepts the resulting term.

Do not introduce a `sorry`, `admit`, or repository-owned scientific axiom as a planning convenience. Keep an unencoded theorem in documentation metadata until an exact statement and admissible proof-development plan are ready.

### 5. Close the audit loop

Before reporting completion:

- run `./scripts/check-pins.py`;
- run `lake build`;
- run `./scripts/audit.sh`;
- record `#print axioms` for each new publication-facing declaration;
- update the theorem manifest and source crosswalk; and
- report residual assumptions, numerical obligations, and generated state.

Compiler success establishes only that Lean accepted the encoded declarations.

## Agent-tooling evaluation

Candidate Lean skills, LSP bridges, MCP servers, proof-search wrappers, or multi-agent workflows require a read-only evaluation before adoption. Record:

1. authoritative repository and maintainer;
2. immutable revision and license;
3. supported Lean, Lake, and Mathlib versions;
4. commands executed and files/network data accessed;
5. whether it modifies prompts, source, build state, or Git state;
6. whether it can transmit unpublished source or credentials;
7. the smallest compatibility probe; and
8. limitations of the evidence.

A third-party search result or AI description is not dependency identity or compatibility evidence. Tooling should normally remain user-level unless repository-owned configuration is necessary and separately reviewed. Operator-recorded repositories awaiting possible later evaluation are listed in [`agent-tooling-candidates.md`](agent-tooling-candidates.md); appearance there does not imply adoption.

## Prohibited shortcuts

- treating generated tactics as proof before Lean checks them;
- hiding admissions behind generated files or macros;
- changing theorem assumptions to make automation succeed;
- importing numerical outputs as exact facts without a checker theorem;
- granting an agent permission to mutate owner repositories;
- adding daemons, telemetry, credentials, or broad workflow machinery; or
- claiming theorem completion from a successful harness build.

## Handoff record

An agent handoff should state changed paths, exact checks and results, theorem/axiom status, source identity, residual assumptions, and any protected next action. Human authorization permits the named operation; it does not transfer responsibility for technical or scientific correctness to the operator.

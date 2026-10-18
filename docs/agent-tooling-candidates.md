# Deferred agent-tooling candidates

The operator requested that the following repositories be remembered for possible later use in the Project Koios Formal development environment. This is a deferred candidate list, not an evaluation, dependency declaration, installation instruction, compatibility claim, or adoption decision.

| Candidate repository | Mutable locator supplied by operator | Current status |
|---|---|---|
| `leanprover/skills` | <https://github.com/leanprover/skills> | recorded only; repository identity, license, contents, revisions, and compatibility not yet evaluated |
| `cameronfreer/lean4-skills` | <https://github.com/cameronfreer/lean4-skills> | recorded only; repository identity, license, contents, revisions, and compatibility not yet evaluated |

Recorded on 2026-10-18 for later review. A GitHub URL names a mutable location; it is not an immutable pin.

## Before any adoption

A later, separately authorized read-only evaluation must:

1. resolve each repository's authoritative owner and an immutable commit;
2. inspect its license, instructions, scripts, dependencies, and supported agent environments;
3. determine whether it supports Pi directly or assumes Claude Code, Codex, another harness, or an MCP/LSP service;
4. inventory commands, network access, subprocesses, prompt injection surfaces, source mutations, and Git mutations;
5. check Lean, Lake, Mathlib, and operating-system compatibility where claimed;
6. compare overlap and conflicts between the two candidates;
7. decide whether any useful capability belongs at user level rather than in this repository;
8. run the smallest isolated compatibility probe; and
9. report limitations without treating tool success as proof or scientific validation.

## Present non-adoption boundary

For the current repository:

- neither candidate is installed, vendored, pinned, or required;
- neither candidate is part of the Lake dependency graph or logical trusted base;
- no repository-owned skill, MCP, LSP, daemon, or agent configuration is created from these links;
- `AGENTS.md` remains the repository instruction surface; and
- theorem selection, proof review, and the existing pin/build/axiom audits do not depend on either candidate.

Revisit this list only when agent-tooling evaluation is explicitly selected as work. Formalization work may continue without it.

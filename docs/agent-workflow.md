# Agent workflow

Agents are development tools, not part of Lean's trusted base or scientific authority.

## Instruction surface

`AGENTS.md` is the repository instruction file. Do not add competing instruction files.

## Workflow

Development follows six bounded stages.

### 1. Establish identity

Record the working context before editing.

- Branch, commit, worktree, and dirty state.
- Lean/Lake versions and dependency pins.
- Relevant repository policy.
- Owner-source repository, commit, path, locator, and dirty-state limits.

### 2. Select the statement

Freeze the claim before proof search.

- Exact source statement and locator.
- Scalars, rank, dimension, domain, conventions, and assumptions.
- Source-to-Lean assumption delta.
- Owning semantic module.
- Proposed declaration ID and manifest entry.

Do not generalize a sourced claim for convenience.

### 3. Search libraries

Inspect the pinned Mathlib revision and Physlib only when relevant.

- Record candidate declarations and fit.
- Reuse library APIs when adequate.
- Do not add compatibility facades or duplicate definitions.

### 4. Develop

Use the smallest affected check.

```console
lake env lean path/to/AffectedModule.lean
```

- Use compiler or language-server goals, not guessed proof states.
- Reuse `.lake` and pinned dependencies.
- Prefer one persistent clean integration worktree for sequential topics.
- Create another worktree only for concurrent isolation.
- Run `lake update` only for an intentional dependency change.
- Do not add `sorry`, `admit`, or scientific axioms.

### 5. Promote

Run the complete gate once for the exact candidate tree.

- `./scripts/check-pins.py`
- one cached or incremental `lake build`
- `./scripts/audit.sh`
- named `#print axioms` reports
- manifest and crosswalk review
- residual-obligation report

Reuse the result after staging, commit, or a byte-identical merge. Rebuild only after a source-tree, toolchain, or manifest change; a failed or interrupted build; or loss of trusted evidence.

## Tool adoption

Before adopting an agent tool, record:

- owner, immutable revision, and license;
- supported toolchains;
- commands, files, network access, and mutations;
- secret or unpublished-source exposure;
- isolated compatibility probe; and
- limitations.

## Prohibited shortcuts

Shortcuts must not cross the trust boundary.

- Treating generated tactics as proof before Lean accepts them.
- Hiding admissions in generated files or macros.
- Changing assumptions to satisfy automation.
- Treating numerical output as exact without a checker.
- Mutating owner repositories.
- Adding daemons, telemetry, credentials, or broad workflow machinery.
- Claiming theorem or scientific completion from a successful build.

### 6. Handoff

Report changed paths, checks, theorem and axiom status, source identity, residual assumptions, and protected next actions.

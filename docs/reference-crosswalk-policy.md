# Reference crosswalk policy

Project Koios Formal needs durable theorem-to-literature traceability, but it must not create a second bibliography or citation registry. This repository owns the formal side of a crosswalk; `projectkoios-references` owns canonical literature identity and bibliographic projection. `projectkoios` owns durable cross-repository architecture decisions, while `projectkoios-bootstrap` owns the operational repository map and coordination routing.

## Ownership boundary

Project Koios Formal owns:

- stable identities for its formal statements and definitions;
- the revision or digest of the exact statement being crosswalked;
- the declared relationship between a formal statement and a source;
- precise theorem, equation, section, appendix, or page locators; and
- evidence identifiers needed to bind a particular observed source version.

`projectkoios-references` owns:

- canonical work identity and identity-resolution decisions;
- citekeys, aliases, DOI and other external identifiers;
- title, author, year, edition, and venue metadata;
- bibliography rendering;
- canonical asset and rights authority;
- bindings and related projections; and
- duplicate and migration handling.

`projectkoios-ingestion` owns:

- extraction and source-document identities;
- verification journals;
- publication and replay state; and
- Ingestion-owned evidence produced by those processes.

This repository must not independently canonicalize a work, copy a PDF, mint a replacement literature identity, or use a citekey, DOI, title, or filesystem path as its authoritative join key. A typed crosswalk link may reference an Ingestion-owned identifier without transferring its state or authority into this repository.

## Minimal durable crosswalk record

| Field | Authority and meaning |
|---|---|
| `formal_statement_id` | Stable Project Koios Formal identity for one theorem or definition. A planning ID is not automatically a statement ID. |
| `formal_statement_revision` | Exact commit or statement digest binding the formal text that was reviewed. |
| `canonical_reference_id` | References-owned replay-accepted identity of the form `canonical-reference:sha256:…`; the primary literature join key. |
| `reference_authority_id` | Exact identity decision or `identity_projection_id` used to resolve the reference. |
| `source_locator` | Structured locator kind and value: theorem, proposition, lemma, equation, section, appendix, page, or page range, with edition/version when needed. |
| `relation` | Closed Project Koios Formal relation describing why the reference is attached. |
| `evidence_ids` | Typed References-owned asset/binding identifiers and/or Ingestion-owned source-document, extraction, verification-journal, publication, or replay identifiers binding the cited version or bytes when required. Referencing an ID does not transfer ownership of its state. |

Optional display fields may include the current citekey, DOI, title, authors, year, or rendered citation. They are non-authoritative, regenerable projections and must not be used as cross-repository keys.

## Relation vocabulary

| Relation | Meaning | Nonclaim |
|---|---|---|
| `formalizes` | The Lean statement is intended to encode the cited source statement after an explicit assumption-delta review. | Does not imply the Lean proof establishes every surrounding publication claim. |
| `adapts` | The formal statement deliberately specializes, restructures, or otherwise changes the source statement, with the delta recorded. | Must not be presented as a verbatim formalization. |
| `depends-on` | The proof or definition uses a cited mathematical result as background authority or motivation. | Attachment alone does not discharge the result in Lean. |
| `compares-with` | The formal result is compared with a cited result without claiming derivation or equivalence. | Does not imply agreement, validation, or priority. |
| `background-only` | The reference supplies context but no proof obligation or source statement. | Must not be counted as evidence for theorem completion. |

Adding or changing relation values requires review; free-form relation names would make crosswalk meaning ambiguous.

## Source locators

A locator must identify both its kind and value. Examples of kinds are `theorem`, `proposition`, `equation`, `section`, `appendix`, `page`, and `page-range`. If page or numbering semantics depend on an edition, version, preprint revision, or rendered artifact, that identity must be explicit through the reference/evidence fields.

Repository-relative owner-source paths and byte hashes remain governed by `source-audit.md` and `publication-crosswalk.md`. Private absolute paths must not be persisted.

## Unresolved identity

If References has not resolved a work:

- record candidate or source-observation IDs and `identity_status = unresolved` in planning material;
- do not mint a Project Koios Formal canonical literature identity;
- do not use a guessed DOI, citekey, title, or author/year tuple as the join key; and
- block any crosswalk status that requires a resolved canonical identity.

## Crosswalk lifecycle

1. **Candidate** — literature relevance is proposed; identity may be unresolved.
2. **Resolved** — References supplies canonical and authority identities.
3. **Located** — exact source locator and version are recorded.
4. **Statement-bound** — locator is bound to an exact formal statement revision and relation.
5. **Audited** — source wording, assumption delta, relation, and identifiers are reviewed together.

Only an audited record may be treated as a completed theorem-to-literature crosswalk. This status does not establish that the theorem is proved; proof status remains owned by `theorem-manifest.md`.

## Current status

No accepted theorem-to-external-literature crosswalk record has been created because References-owned canonical identities remain unavailable. The publication crosswalk now binds several owner-manuscript statements to generic foundations and a conditional Paper A algebraic bridge, while Paper B and Paper C namespace entries remain metadata placeholders. Governed literature records should begin only when accepted References-owned identities are available.

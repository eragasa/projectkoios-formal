# Reference crosswalk policy

Formal owns theorem-to-literature links; `projectkoios-references` owns canonical bibliography identity.

## Ownership

Formal owns:

- formal statement ID and revision;
- relation to the source;
- exact theorem, equation, section, appendix, or page locator; and
- evidence IDs binding the reviewed source version.

References owns:

- canonical work identity and resolution;
- citekeys, aliases, DOI, title, author, edition, venue, and year;
- bibliography rendering, assets, rights, and duplicate handling.

Ingestion owns extraction identities, verification journals, replay, and publication state. Referencing an external ID does not transfer its authority.

## Durable record

Each audited link carries the following fields.

| Field | Meaning |
|---|---|
| `formal_statement_id` | stable Formal declaration ID |
| `formal_statement_revision` | exact commit or statement digest |
| `canonical_reference_id` | References-owned canonical identity |
| `reference_authority_id` | identity decision or projection ID |
| `source_locator` | typed exact locator and version |
| `relation` | closed relation value |
| `evidence_ids` | typed References or Ingestion evidence identities |

Display metadata is optional and non-authoritative. Do not use a DOI, citekey, title, or path as the cross-repository key.

## Relations

Relations use a closed vocabulary.

| Relation | Meaning |
|---|---|
| `formalizes` | encodes the source statement after assumption review |
| `adapts` | deliberately changes the source statement with a recorded delta |
| `depends-on` | uses the cited mathematics as authority or motivation |
| `compares-with` | compares without claiming derivation or equivalence |
| `background-only` | supplies context only |

New relation values require review.

## Lifecycle

A crosswalk advances through five states.

1. Candidate.
2. Resolved by References.
3. Located in an exact source version.
4. Bound to a formal statement revision and relation.
5. Audited with its assumption delta and evidence IDs.

Only an audited record is a completed literature crosswalk. Crosswalk status does not imply proof status.

## Unresolved identity

Unresolved literature remains explicitly unresolved.

- Record approved candidate or observation IDs and `identity_status = unresolved`.
- Do not mint a Formal-owned literature identity.
- Block any status requiring canonical identity.
- Do not persist private absolute paths.

No accepted external-literature crosswalk currently exists because canonical References identities remain unavailable.

# Citation and bibliography audit

Audit date: 2026-10-29.

## Scope and authority

This audit covers the external background bibliography used by the Formal-owned proof
companion. It does not assess novelty, establish priority, validate a scientific model,
or replace the immutable owner-source records in Appendix B. Exact propositions and
proof status remain controlled by Lean source and the theorem manifest. The bibliography
supplies context for established Bloch/Wannier constructions, alignment, interval
analysis, Lean 4, and Mathlib.

A DOI is used as the persistent publication locator where available. Bibliographic
metadata was checked against Crossref and, where noted, the publisher, the official
Mathlib citation page, or a versioned arXiv record. Publisher access restrictions do not
change the recorded DOI; this repository stores metadata and citations, not publisher
article bytes.

## Audited entries

| BibTeX key | Use in the companion | Persistent identity | Metadata/content inspected | Disposition |
|---|---|---|---|---|
| `Bloch1929` | Historical background for momentum-indexed Bloch descriptions | DOI `10.1007/BF01339455` | Crossref work record: author, title, journal, volume, issue, pages, year | included as background; not a source for a Lean theorem |
| `Wannier1937` | Historical origin of real-space Wannier representation | DOI `10.1103/PhysRev.52.191` | Crossref and APS metadata: author, title, journal, volume, issue, pages, date | included as background; no localization theorem is imported |
| `SouzaMarzariVanderbilt2001` | Disentanglement and composite-band construction context | DOI `10.1103/PhysRevB.65.035109` | Crossref and APS bibliographic metadata and title-level scope | included for construction context only |
| `MarzariEtAl2012` | Review of Wannier gauge freedom, localization, interpolation, and applications | DOI `10.1103/RevModPhys.84.1419` | Crossref and APS metadata plus review scope | included as review background; not treated as formal authority |
| `Schonemann1966` | Classical orthogonal Procrustes alignment background | DOI `10.1007/BF02289451` | Springer page and Crossref record; abstract states the constrained least-squares problem and rank-deficient scope | included with an explicit statement that Formal assumes an alignment rather than certifying its numerical construction |
| `Panati2007` | Analytic/topological hypotheses behind smooth periodic Bloch frames | DOI `10.1007/s00023-007-0326-8`; arXiv `math-ph/0601034` | Crossref plus arXiv v1 abstract and journal reference | included to delimit continuum claims from the finite theory |
| `BrouderEtAl2007` | Exponential localization and its topological hypotheses | DOI `10.1103/PhysRevLett.98.046402`; arXiv `cond-mat/0606726v2` | Crossref plus versioned arXiv abstract and journal reference | included to delimit, not assert, localization and obstruction results |
| `MooreKearfottCloud2009` | General interval-analysis background for enclosure decisions | DOI `10.1137/1.9780898717716`; ISBN `978-0-89871-669-6` | Crossref monograph record: authors, title, publisher, year, ISBN | included as background; the three-way checker soundness remains owned by the cited Lean declarations |
| `DeMouraUllrich2021` | Lean 4 system context | DOI `10.1007/978-3-030-79876-5_37` | Springer chapter and Crossref record: authors, title, proceedings, pages, year | included for prover context; exact toolchain identity remains Appendix B data |
| `MathlibCommunity2020` | Mathlib library context | DOI `10.1145/3372885.3373824` | official Mathlib citation page and Crossref proceedings record | included for library context; the immutable Mathlib revision remains the dependency authority |

## Citation-gap decisions

- Exact finite identities proved in Lean are cross-referenced to declaration IDs and
  proof dossiers rather than attributed to external literature.
- The motivating ICMSEP problem and the seven-paper development remain bound to the
  repository commits, blobs, and hashes in Appendix B rather than being recast as
  published bibliography entries.
- Standard additive, matrix, metric, and finite-Fourier manipulations are not padded with
  citations when their exact statements are already machine checked.
- Continuum localization, Bloch-bundle topology, and Wannier obstruction are cited only
  at the boundary where the companion explains that its finite results do not establish
  them.
- This bibliography is sufficient for the present background claims but is not a
  prior-art search, novelty opinion, or comprehensive literature review.

## Revisit triggers

Re-audit the affected entry and citation placement if its DOI metadata changes, the
companion adds a new external mathematical claim, a publication extraction relies on a
background result more strongly than this companion does, or an independent reviewer
requests a primary-source replacement or additional literature coverage.

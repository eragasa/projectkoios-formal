# Formalization conventions

Every theorem family must state the conventions relevant to its claim.

## Required record

Record every convention that affects a proposition.

| Topic | Record explicitly | Never infer |
|---|---|---|
| Scalars | field and order assumptions | real-to-complex generalization |
| Dimension | spatial dimension, rank, finiteness | arbitrary rank or dimension |
| Momentum | mesh, interval, torus, endpoints, measure | endpoint identification |
| Weights | normalized counting, geometric, moment, or certified optimized rule | post-hoc evaluation weights |
| Fourier | sign, normalization, group, inversion, finite/continuum domain | interchange of conventions |
| Operators | spaces, basis/frame, adjoint, norm | matrix/operator identity without a map |
| Support | indices, metric, shells, closure, finite/decaying semantics | physical range from coordinate cutoff |
| Gauge | group, action, global/pointwise dependence | larger alignment family |
| Spectrum | multiplicity, ordering, gaps, retained subspace | canonical eigenvectors at degeneracy |
| Parameters | domains, positivity, compactness, units | bounded conclusions from unbounded formulas |
| Evidence | equality, bound, tolerance, or external obligation | approximate-to-exact promotion |

## Declaration IDs

IDs classify declarations without changing status.

- `DEF`: definition, abbreviation, structure, or construction.
- `LEM`: supporting identity or intermediate result.
- `THM`: principal theorem.
- Existing IDs are append-only; a changed proposition receives a new ID.

## Comparison discipline

Before comparing operators, identify:

1. state spaces;
2. basis or frame maps;
3. gauge or alignment action;
4. energy reference and units; and
5. lattice and reciprocal coordinates.

Projection, disentanglement, basis change, Fourier conversion, and truncation are different operations.

## Certificates

Certificate inputs remain exact and explicit.

- Exact scalar certificates use rational data and comparisons before real coercion.
- Algebraic values require proved rational enclosures.
- Square-root bounds require squared inequalities and nonnegativity.
- Certificate acceptance does not bind fields, thresholds, or runtime data automatically.
- Concrete weights and supports must satisfy `BandGauge/publication-evidence-contract.md`.

## Freeze rule

A convention is frozen only after:

1. immutable source identity and locator;
2. source-to-Lean review;
3. recorded assumption delta;
4. manifest entry; and
5. dependent crosswalk updates.

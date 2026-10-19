# Formalization conventions

This document is a pre-encoding contract. It does not freeze one mathematical convention for every theorem. Instead, it lists the choices that each future definition and statement must expose before review.

## Convention record required for every theorem family

| Topic | Required record | No implicit default |
|---|---|---|
| Scalars | real or complex field and any ordered-field requirements | a real model must not be silently generalized to a complex one |
| Dimension and rank | spatial dimension, retained rank, and finiteness assumptions | a fixed rank or dimension must not be renamed as arbitrary |
| Momentum domain | finite cyclic mesh, interval representative, torus, or product torus | endpoint identification and measure are never inferred from notation alone |
| Fourier transform | sign, normalization, index group, inversion rule, and finite/continuum setting | discrete and continuum transforms are not interchangeable |
| Matrices and operators | domain, codomain, basis/frame, adjoint, and matrix norm | a represented matrix is not identified with an abstract operator without a map |
| Support and locality | index set, metric, shell rule, conjugate closure, and finite versus decaying support | coordinate cutoff is not physical range unless established |
| Gauge/alignment | admissible group, pointwise or global action, and real or complex family | unrestricted alignment must not replace a source-restricted family |
| Spectral ordering | multiplicity, ordering, gap, and retained-subspace assumptions | eigenvectors are not canonical at degeneracy |
| Parameters | domains, positivity, compactness, bounds, and units | formulas derived on an unconstrained domain do not imply bounded-domain conclusions |
| Error/evidence | exact equality, inequality, numerical tolerance, or external obligation | approximate equality is not rewritten as exact equality |

## Source-specific records already observed

The publication crosswalk identifies source conventions that future encodings must preserve, including rank-two real-rotation families, positive splitting parameters, finite global alignment families, normalized torus integrals, complete metric shells, and the D1 continuum Fourier convention. These observations are traceability notes, not repository-wide defaults.

For Ragasa2026A v3, the source records reduced momentum `q = k/G = ka₀/(2π)` and a negative-exponent forward Fourier transform. It also reduces the correlation-maximizing angle to `[-π/2, π/2)`; `BG-FOUNDATION-DEF-006` and `BG-RAGASA2026A-DEF-012` implement that exact half-open convention by replacing the complex-argument upper endpoint with the equivalent lower endpoint. The degenerate harmonic still has no unique reported angle. A future Fourier statement must restate the exact domain and normalization rather than relying on this prose summary.

## Equality and transport discipline

Before subtracting or comparing operators, a statement must identify:

1. the state spaces;
2. the basis or frame maps;
3. the gauge/alignment action;
4. the energy reference and units; and
5. the lattice and reciprocal-coordinate convention.

Projection, disentanglement, basis transformation, Fourier conversion, and truncation remain different operations. A proof about one operation must not be relabeled as a result about another.

## How a convention becomes frozen

A convention is frozen for a theorem family only when:

1. its owner-source location and revision are cited;
2. the proposed Lean definition is reviewed against that source;
3. any generalization or specialization is recorded as an assumption delta;
4. the theorem manifest names the declaration and status; and
5. dependent crosswalk rows point to that exact declaration.

No convention in this document authorizes theorem implementation by itself.

# Planned module layout

The directories under `ProjectKoios/BandGauge/` currently contain documentation only unless an existing `.lean` file is explicitly listed in the theorem manifest. Their presence reserves cohesive ownership boundaries; it does not announce implemented APIs.

| Directory | Intended ownership | Explicit exclusions |
|---|---|---|
| `Foundations/` | finite index types, support vocabulary, state-space/frame/gauge definitions, and small reusable algebra | paper-specific thresholds and numerical records |
| `Geometry/` | admissible-set geometry, alignment losses, rank-two finite-dimensional consequences | unreviewed generalization to arbitrary rank or scalar field |
| `Fourier/` | discrete Fourier conventions and locality first; continuum analysis later | calculator execution and sampled evidence |
| `Projection/` | spectral projection and finite-support consequences | conflating projection with gauge change, disentanglement, or truncation |
| `SpecialFunctions/` | later Jacobi–Anger, Bessel, and shell-tail infrastructure | premature dependencies before finite/continuum foundations are fixed |
| `Papers/` | thin source crosswalks and eventual theorem instantiations | duplicated foundational proofs and ownership of publication prose |

## Dependency direction

The intended direction is:

```text
Foundations ──→ Geometry
      ├───────→ Fourier
      └───────→ Projection

Foundations + Fourier ──→ later SpecialFunctions
reviewed foundational modules ──→ Papers
```

Actual imports must remain narrower than this sketch. No root module should become a catch-all re-export merely because a directory exists.

## Naming and promotion

A documentation folder becomes a Lean module family only after:

1. an exact theorem or definition is selected;
2. existing library APIs are inventoried;
3. ownership and import direction are reviewed; and
4. the theorem manifest receives a statement-level entry.

Placeholder README files are not supported import surfaces.

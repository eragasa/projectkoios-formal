# Exact finite Fourier least-squares crosswalk

## Scope

This crosswalk records the KSD motivation for the source-neutral exact declarations
`BG-FOURIER-FINITE-LEM-003/004` and `BG-FOURIER-FINITE-THM-004/005`. It does not bind a
runtime array or calculation artifact to a Lean value and does not validate a numerical fit.

## Inspected owner source

- Repository: `ksdft2effmass`
- Inspected worktree: `/private/tmp/ksdft2effmass-periodic1d-rank1-first-pass-certificate`
- Branch: `work/periodic1d-rank1-first-pass-certificate`
- Commit: `ca052e6571ea10dfbfc3f51be47ffdb08e5313d0`
- Tree: `447d0634ab6fa09782d50afa899f45e38c156809`
- Dirty-state limitation: the worktree had 20 status entries from the bounded certificate prototype
  and scope documentation. The four paths below were clean at the recorded commit and were
  inspected from that immutable source identity.

| SHA-256 | Owner-repository path | Relevance |
|---|---|---|
| `f350d69c246be13c3d31a81fa0983e34c036bb9f8839079d6db7587eab99e659` | `python/src/ksdft2effmass/analysis/hopping_fits.py` | runtime least-squares fitting route |
| `8f7244046d772716ed7f5c60022385c2c7b9a99d841489971a00783ae2bcaf7e` | `python/src/ksdft2effmass/solidstate/hopping_transforms.py` | runtime Fourier-transform route and centered convention |
| `f93c074ab0e97c448cee02ba5ea955fe4c1c85373fea7b4cce67b66295ed15ce` | `python/src/ksdft2effmass/periodic1d/fourier_locality/analysis.py` | comparison of direct and transform-mediated routes |
| `f0040494d5b57062d9d9c974952f591f3b5d220c59a02d3cfe1c4d55d10c707c` | `calculations/periodic1d/rank1/fourier-locality/numerical-control-decision.md` | owner-side control and interpretation boundary |

The local planning inventory `/tmp/ksdft2effmass-mathematics-validation-pivot.md` had SHA-256
`20166a105e83d9623f0e7d6e16c01dfd06d7f2792e21ee9fbbda7b27822d7c01`. It selected the theorem
family but is not an owner-repository source or durable evidence artifact.

## Exact Formal result

For a finite abelian group `G`, complex Hilbert space `V`, exact field `field : G → V`, exact
character support `S`, normalized coefficient field `c`, and any exact candidate `d` supported on
`S`, Formal proves

```text
error(d) = error(truncate S c)
         + |G| * coefficientPower(truncate S c - d).
```

It follows that truncation minimizes the unnormalized equal-weight momentum-space squared Hilbert
error over the declared supported coefficient class. Equality holds exactly when `d` is the
truncated exact coefficient field.

## Boundary

The theorem does not establish that:

- a NumPy least-squares solver returned this exact minimizer;
- a runtime design matrix represents the complete uniform character inventory or has numerical full
  rank;
- binary64 transform and direct-fit coefficients agree;
- conditioning, tolerance selection, serialization, or a retained artifact is valid;
- any support threshold passes; or
- a scientific conclusion follows.

A later owner-specific applicability bridge would need to identify the exact group, character
inventory, sign, normalization, support, weights, coefficient carrier, and runtime-to-exact value
boundary before applying the theorem to a KSD execution.

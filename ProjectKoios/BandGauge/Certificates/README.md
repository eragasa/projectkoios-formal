# Exact certificates

**Author:** Eugene Joseph M. Ragasa
**License:** Apache License, Version 2.0 (`Apache-2.0`)
**Initial document completed:** 2026-10-19

This directory owns narrow, kernel-checked certificate formats and proof-producing
checkers for reusable band-gauge mathematics.

`RankTwoSeparation.lean` defines an exact rational certificate for a positive-scale
spectral witness, full-ellipse containment, and strict spectral/operator separation. Its
Boolean checker uses exact rational comparisons and returns `false` when any declared
validity clause fails; accepted certificates are transported to real ellipse statements by
proved theorems. The checked lower scale is strictly positive, so the whole encoded
candidate rectangle respects the source's positive splitting-scale domain.

`RankTwoSeparationEnclosure.lean` replaces exact rational-center equality by checked
rational lower and upper bounds. Its conclusions hold uniformly for every real center in
the interval. The module also proves the exact enclosure
`7/10 < 1 / √2 < 71/100`, without floating-point input.

`FinitePareto.lean` supplies executable exact dominance and threshold checks and an exact
nondominated mask for a total finite objective table. Its proved bridges establish
Boolean soundness and completeness for the supplied table. It does not parse runtime
output, prove that an external inventory was covered, or resolve interval-overlapping
comparisons.

These modules do not parse runtime files, bind values to concrete publication matrices,
certify numerical eigensolver output, or validate a scientific model. The enclosure
bridge still requires proofs that the field-derived `μmax` lies in the checked interval.
Those obligations must be supplied explicitly. A generic or synthetic accepted
certificate is not a publication certificate.

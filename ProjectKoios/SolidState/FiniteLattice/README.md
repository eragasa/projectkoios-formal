# Finite-lattice algebra

`Folding.lean` defines normalized finite-character folding matrices, their orbital-block and
unit-modulus-phase variants, translation-invariant block supercells, Bloch fibers, and exact block
diagonalization. The one-dimensional cyclic specialization uses `G = ZMod N`.

`RouteCommutativity.lean` proves exact identities for coordinate pullback, scalar energy-reference
removal, defect subtraction, folding, map composition, Hermiticity, and two-state spin lifting.

These modules do not bind Python arrays, binary64 Fourier matrices, hopping truncations, twist
representatives, tolerances, spectra, or retained calculation evidence.

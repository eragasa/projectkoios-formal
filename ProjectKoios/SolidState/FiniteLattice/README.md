# Finite-lattice algebra

`Folding.lean` defines normalized finite-character folding matrices, their orbital-block and
unit-modulus-phase variants, translation-invariant block supercells, Bloch fibers, and exact block
diagonalization. The one-dimensional cyclic specialization uses `G = ZMod N`.

`RouteCommutativity.lean` proves exact identities for coordinate pullback, scalar energy-reference
removal, defect subtraction, folding, map composition, Hermiticity, and two-state spin lifting.

`GaugeLoops.lean` proves endpoint covariance of ordered link products, closed-loop conjugation,
commutative loop and plaquette invariance, invariance of complex Bargmann products and principal
phases under pointwise unit-modulus state phases, and conjugation/determinant invariance of finite
matrix Wilson products under pointwise unitary frame changes.

`ProjectorBargmann.lean` proves that finite rank-one state outer products are Hermitian, become
idempotent projectors under an explicit unit-norm premise, and are invariant under pointwise
unit-modulus phases. It factors their ordered products and identifies the product trace exactly
with the corresponding Bargmann loop product, including equality and gauge invariance of the
principal phases.

These modules do not bind Python arrays, binary64 Fourier or overlap matrices, hopping truncations,
twist representatives, loop orientations, boundary sewing, tolerances, spectra, or retained
calculation evidence. They do not infer normalization from runtime data or establish Chern
integrality, continuum topology, a Wannier obstruction, Wannier90 execution, numerical-mesh
validity, or physical applicability.

# BandGauge publication crosswalks

This folder owns thin manuscript-specific metadata and reviewed conditional theorem instantiations. Reusable mathematics belongs in foundational BandGauge modules rather than being copied into paper modules.

`Ragasa2026A/RankTwoFields.lean` owns the exact conditional definitions of
`D_{i,φ}`, `Bᵢ`, and `bφ`, both supplied and canonical exact finite spectral
diagonalizations, and ten proved algebraic bridge statements. Its contract keeps
the source's strict-positive normalized-weight premise, one global standard real
rotation, and momentum-dependent comparison alignment.

`Ragasa2026A/CorrelationHarmonic.lean` owns exact Pauli coordinates, including their
canonical extraction from the Hermitian traceless fields, and proves
`bφ = b₀ + c cos(2φ) + d sin(2φ)`, its exact continuous maximum, attainment by a
canonical angle in `[-π/2, π/2)`, the bound on the maximized normalized correlation,
and the finite matrix-loss bridge centered at `μmax`.
No uniqueness is claimed in the degenerate case.

`Ragasa2026A/OptimizedLossGeometry.lean` specializes the reusable full-plane and
candidate-rectangle ellipse intersection and distance theorems to the canonical spectral
field and continuously optimized operator field. Rectangle results retain explicit
full-ellipse containment premises.

`Ragasa2026A.lean` records the aggregate status: twenty-six formal statements, zero proved
scientific theorems, and zero checked certificates. The spectral and Pauli decompositions
are now canonically obtained from the finite Hermitian matrices using exact noncomputable
mathematics; the generic supplied spectral-witness interface also remains available.
Concrete matrix data remain external. No floating-point eigensolver, continuity, or
construction from a periodic potential is claimed. Binding
to concrete publication data remains open.

`Ragasa2026B.lean` and `Ragasa2026C.lean` remain metadata-only placeholders. Generic
foundational clauses linked from the crosswalk remain owned and counted in their
foundational modules. Compilation alone is not evidence of a scientific result or
complete publication formalization.

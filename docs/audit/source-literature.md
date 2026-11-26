# Literature and primary-source records

External literature and primary-source acquisition records, including candidate and provisional identity limits. These records identify inspected sources and limitations; they do not transfer ownership, theorem status, scientific validity, or publication authority.

<a id="aud-src-001"></a>

## `AUD-SRC-001` — External literature candidate: noncollinear spin-density matrices

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-001` |
| Status | `candidate` |
| Source class | Literature and primary-source inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

A read-only literature inspection on 2026-11-25 identified the following preferred statement source
for a future density-functional binding:

- Carsten A. Ullrich, “Density-functional theory for systems with noncollinear spin:
  orbital-dependent exchange-correlation functionals and their application to the Hubbard dimer,”
  *Physical Review B* **98**, 035140 (2018),
  [DOI `10.1103/PhysRevB.98.035140`](https://doi.org/10.1103/PhysRevB.98.035140);
- immutable inspected manuscript: [`arXiv:1805.06417v1`](https://arxiv.org/abs/1805.06417v1);
- inspected PDF SHA-256: `d59bd57f77549e0fd24970f3234b652c1ad0be93cac6c76e4f68a136881647f5`;
- inspected PDF size: `2481695` bytes; and
- exact locators: Section II.A, manuscript page 2, equations (3)--(9), especially
  `mᵢ(r) = tr{σᵢ n(r)}` in equation (4) and
  `n(r) = (1/2) ∑ⱼ σⱼ mⱼ(r)` in equation (5), together with the preceding paragraph distinguishing
  a fixed global spin direction from a spatially varying noncollinear magnetization.

Crossref publisher metadata confirms the journal title, author, volume, article number, publication
date, and DOI.  The inspected arXiv bytes, rather than a transient publisher rendering, supply the
exact locator evidence.  Ullrich's statement concerns a pointwise Hermitian `2 × 2` spin-density
matrix.  The current Lean decomposition instead concerns arbitrary finite orbital blocks and does
not encode position dependence, positivity, representability, occupations, density-functional
semantics, or a common spatial spin axis.  Therefore a future physical density declaration may
`adapt` this source only with those deltas recorded; the current source-neutral Pauli declarations
remain unbound supporting algebra.

The global-spin-rotation convention was inspected separately:

- F. G. Eich and E. K. U. Gross, “Transverse Spin-Gradient Functional for Noncollinear
  Spin-Density-Functional Theory,” *Physical Review Letters* **111**, 156401 (2013),
  [DOI `10.1103/PhysRevLett.111.156401`](https://doi.org/10.1103/PhysRevLett.111.156401);
- immutable inspected manuscript: [`arXiv:1212.3658v2`](https://arxiv.org/abs/1212.3658v2);
- inspected PDF SHA-256: `3ecb788ad1c424c7dd6374a9676e420cb5eb8294c3ea1dda821276b8ead3147c`;
- inspected PDF size: `4440982` bytes; and
- exact locator: manuscript page 2, paragraph immediately preceding equation (9), which states
  the global internal-spin transformation `Φ(r) ↦ U Φ(r)` for `U ∈ SU(2)` and the corresponding
  magnetization-vector transformation `m(r) ↦ R m(r)`.

`SpinFrameRotation.lean` adopts the first transformation only to fix the active matrix-conjugation
order.  It does not yet construct the corresponding `SO(3)` matrix `R`, bind a spin-density field,
or formalize exchange-correlation rotational invariance or the zero-torque theorem.

Foundational background was also inspected read-only:

- U. von Barth and L. Hedin, “A local exchange-correlation potential for the spin polarized case.
  I,” *Journal of Physics C: Solid State Physics* **5**, 1629--1642 (1972),
  [DOI `10.1088/0022-3719/5/13/012`](https://doi.org/10.1088/0022-3719/5/13/012);
- inspected PDF SHA-256: `ebaa63df16bb4189c38195d365b0fb6d95fce58c35ceae1043cd7cc0a581af50`;
- inspected PDF size: `737669` bytes; and
- exact locators: Section 2, equation (2.3) and page 1631 for the Hermitian spin-density matrix;
  Section 3, page 1632 for the local coordinate system whose `z` axis follows the local spin; and
  the Appendix, page 1641, for the Cartesian Pauli spin-vector operator.

These works do not yet have replay-derived References-owned canonical identities or evidence IDs
in the local `projectkoios-references` checkout at commit
`0fac430c715939a77c1be66c46ad0bbebb49447b`.  An operator-requested `Ullrich2018` BibLaTeX entry
and same-basename local candidate PDF have now been added there, but import and filename agreement
do not themselves establish canonical identity under that repository's authority model.
Accordingly this section records candidate identity and exact-locator evidence only.  It is not a
completed literature crosswalk, and DOI strings are not being used as cross-repository keys.

<a id="aud-src-020"></a>

## `AUD-SRC-020` — Complex-unitary right-Procrustes inspection

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-020` |
| Status | `current` |
| Source class | Literature and primary-source inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The exact right-action objective and polar-witness result were selected after a bounded literature,
consumer-contract, and pinned-Mathlib inspection.

### Mathematical source

- Nicholas J. Higham, *Functions of Matrices: Theory and Computation*, SIAM, 2008,
  ISBN `978-0-898716-46-7`, Chapter 8, Theorem 8.6;
- chapter DOI: `10.1137/1.9780898717778.ch8`;
- author-maintained book metadata:
  `https://nhigham.com/functions-of-matrices-theory-and-computation/`; and
- author-maintained explanatory background, “What is the Polar Decomposition?”, 2020-07-28:
  `https://nhigham.com/2020/07/28/what-is-the-polar-decomposition/`.

Higham's convention is adapted, not silently copied: the Formal objective is explicitly
`minimize ‖candidate * gauge - reference‖_F²` with a right-acting complex unitary and cross matrix
`candidateᴴ * reference`. The real special-orthogonal determinant constraint and generalized
metric/indefinite polar decompositions are outside this module.

### Consumer contracts

The `projectkoios-optimization` contract was inspected read-only at immutable commit
`ef608716ae9f515f56406dd517c1a8b7487d3391`. Its current exact source locators were:

| SHA-256 | Owner-repository path |
|---|---|
| `7f76acfef497f4b8e0f012705c1da4861458c7b6625c95463e496ee61c5e5dc5` | `src/python/projectkoios/optimization/alignment/procrustes.py` |
| `355681584b1bf81088dd664e17b4a2e039c1d96acb22d1740f3588c3e6d01411` | `src/python/projectkoios/optimization/alignment/numpy/procrustes.py` |

The KSD immutable dependency pin was
`7ac5376bcb97e29f6927dda4d4ef714ed2e32140`; the pinned optimization contract source had SHA-256
`ad08a703628d3742fb3ee8086acf2720a48fe8c94b58b0a2e4a1cb0c5dd118e7`. KSD was inspected
read-only at local commit `4835e7bf9161729cc8f0537bcc13db083896a6ae`, three commits ahead of remote
`5aaff25b784c7d1bc079a3030a73be387dc11a0f`, in an otherwise dirty worktree. The cited paths were
unmodified and were read from immutable `HEAD` blobs:

| SHA-256 | Owner-repository path |
|---|---|
| `e0deceebb75d84304eb02f80d1734afc0cd36be611dbd741d63298e96de33240` | `python/src/ksdft2effmass/solid_state/band_frames.py` |
| `3e5124fe785cfc75d5a2bb80030e6bccf9c4bcb82ed540de9c2a4e32b57400ea` | `python/src/ksdft2effmass/solid_state/frame_alignment.py` |

These consumers use ordinary complex-unitary right action and cross matrix
`candidate_frame.magnitude.conj().T @ reference_frame.magnitude`. No overlap metric, Gram metric,
metric-unitary constraint, or complex-oblique gauge contract was found in the audited paths.
Rank-deficient runtime policy deliberately withholds an arbitrary null-space unitary completion.

### Mathlib feasibility and authority boundary

The original API search used Mathlib commit
`56a005855ea17e0b0958f73ec801ae140b0a1679`; the migrated implementation compiles against selected
Mathlib commit `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`. It uses matrix spectral decomposition,
positive-semidefinite/positive-definite eigenvalue signs, cyclic trace identities, the finite unitary
group, and the scoped Frobenius norm. No ready-made polar-decomposition declaration was found in the
original search. Formal therefore accepts an exact factorization witness
`candidateᴴ * reference = minimizer * positiveFactor`; it does not claim unconditional construction
of that witness from an external matrix.

The Lean result authenticates no NumPy SVD, binary64 matrix, floating numerical rank, tolerance,
runtime orthonormality check, optimizer branch, null-space completion, serialization, retained
artifact, or certificate. A positive-semidefinite witness proves mathematical global minimality.
Uniqueness requires an explicit positive-definite factor and is not inferred in the rank-deficient
case. The checked runtime-certificate count remains zero.

### Finite-mesh extension

`ProjectKoios/BandGauge/Alignment/FiniteMeshProcrustes.lean` is a source-neutral exact extension of
the same selected objective, not a new external scientific claim. It sums the local squared
objectives with equal weight, accepts one exact polar witness at every finite mesh point, and proves
pointwise and summed minimality. Equality with the summed minimum forces field equality only when
every local positive factor is positive definite. The exact known-inverse theorem is conditional on
pointwise frame equality and is labeled as a control rather than universal ground truth.

The matrix-unitary bridge does not assume a direct matrix-to-isometry coercion. It maps the matrix
to a Euclidean continuous linear map, proves the two unitary identities using conjugate-transpose/
adjoint compatibility, and then applies Mathlib's unitary linear-isometry equivalence. The bridge
places identity, constant, and arbitrary matrix-unitary fields into the already declared identity,
global, and complete alignment families. It authenticates no external mesh, runtime polar factor,
SVD, numerical rank, tolerance, optimizer, or serialized evidence.

### Later typed gauge-identity inspection

A later KSD handoff was inspected read-only at immutable local commit
`b47e455ba92a4b3a3b21e24cc087f7d9b7e088ee`, tree
`d3ab5b5c38bd36fdeb9bf8169c32a81a2c130d37`, on branch
`work/periodic23-rank2-ragasa-metric-extension`. The checkout was twelve commits ahead of its
configured `origin/main` and dirty in unrelated 2-D/3-D calculation, documentation, and analysis
paths. The cited paths below were unmodified and were read from immutable commit blobs:

| SHA-256 | Owner-repository path |
|---|---|
| `ccebe25afba837f40b91c7c4c9006be49fcd24a2f355e2db63edd1886233e662` | `python/src/ksdft2effmass/gauge_alignment/base.py` |
| `77f7400da43f6cd59e4b97e63a50700b7a1f7f08895c156c92d3e29ed28a451b` | `docs/architecture/v3/ksdft2effmass/scientific-operation-taxonomy.md` |
| `929b0388236cf3ad56bdbdb3ca9e3b034ee511656a9e63de5209fb00dab327ea` | `docs/architecture/v3/ksdft2effmass/periodic1d/rank2/gauge_alignment/index.md` |
| `254f8e2f54d1c8a7cb11322d742597053dbf550f12d6cc672c665235e6b12a4d` | `docs/architecture/v3/ksdft2effmass/periodic1d/rank2/gauge_alignment/scientifics.md` |
| `1fa5f00f3826d6c9d6a1a8abefa10d5d477d67564724638f1b83c9db67929c0b` | `docs/architecture/v3/ksdft2effmass/periodic1d/rank2/gauge_alignment/numerics.md` |
| `1c35738d7963f366f11fe2065ce494ef71202a0aae4e55bfc8903670d9f8e1e5` | `docs/architecture/v3/ksdft2effmass/periodic1d/rankN/band_alignment/composite/index.md` |
| `3ae8ade99c1ee47f0d203121996041307ae3446017918f197a16ca3c9de89845` | `docs/architecture/v3/ksdft2effmass/periodic1d/rankN/band_alignment/composite/scientifics.md` |
| `848835dfb799d3338b226fe4f910022094462b5283b3e03b5272401224e7fc35` | `docs/architecture/v3/ksdft2effmass/periodic1d/rankN/band_alignment/composite/numerics.md` |
| `319385f51815c6c7c949be734ef1cc823acc29798dff044f6ae80f5d59bd8927` | `docs/research/proofs/formal/theorem-catalog/PRF-05.md` |

A follow-up rank-one specialization was inspected at child commit
`b07897216f6d28aa77d4615e9e20ca812701e223`, tree
`b943efc9ab42cc0eaa5db312611997ade50209db`. The same unrelated dirty-state limitation applied;
the cited paths were again read from immutable commit blobs:

| SHA-256 | Owner-repository path |
|---|---|
| `c56aaf43e2ba0738acde6444141e653eea0257140ecc208cf32c34a8c171a94f` | `doc/sphinx/api/gauge-alignment.rst` |
| `63b44e09ff112e4986e7740f2fea4f8d7ebc7e94a3154bb5e4831f8b5ceb4fa7` | `docs/architecture/v3/ksdft2effmass/periodic1d/fourier_locality/index.md` |
| `18fc04099ca947745cc643554aeba23f6db6368e33a9eb64fabb86caf6b6d6fd` | `docs/architecture/v3/ksdft2effmass/scientific-operation-taxonomy.md` |
| `9f36c799d700369576e8eee1a9877ecfc877d4f9aa6cdb8d234f54cce09163d9` | `python/src/ksdft2effmass/periodic1d/rank1/alignment/analysis.py` |
| `871677b2b1c9b40d9ebfa4a730d8b02104c5fa39f5ea8b152fab22a0ac6b3903` | `python/src/ksdft2effmass/periodic1d/rank1/alignment/result.py` |
| `03e6382cae653df7b81717cd59781a457860abe35bd49f15c0ad5656a05423c6` | `python/tests/ksdft2effmass/periodic1d/rank1/test__rank1_capabilities.py` |

The follow-up derives the rank-one label `U(1)` from the same typed unitary-family identity while
retaining operator-trivial applicability. This agrees with the existing exact scalar boundary
`BG-FOURIER-THM-049`: unitary phase membership exists, but conjugation of a scalar represented
operator is trivial and does not create duplicate operator-locality channels.

The convention correction was then inspected at child commit
`9e1629a5656816c5e9b36b399c8691ca038e12c2`, tree
`25c4f9e739c67e5c8014ccbbcb7e7251eb9c2b4a`. The checkout was fourteen commits ahead of its
configured `origin/main` and remained dirty in unrelated calculation and model-adequacy paths; all
cited bytes were read from the immutable commit rather than the working tree:

| SHA-256 | Owner-repository path |
|---|---|
| `d16399f1b2003c27570312dc573fd01d412bcd0b48eba0fd007d61bd9c033d0d` | `doc/sphinx/api/gauge-alignment.rst` |
| `66ced572c5b921ea6923454614926f2445c68741e1905548f659aab4d6f195e6` | `docs/architecture/v3/ksdft2effmass/periodic1d/rank2/gauge_alignment/index.md` |
| `adb13c507f25e6e946a6e6661f70c261084e34deaad9204be8ad365433cb4db7` | `docs/architecture/v3/ksdft2effmass/periodic1d/rank2/gauge_alignment/scientifics.md` |
| `de8af777830306ff436f272c1de93fdc58654157120cdd48406bd47856362a38` | `docs/architecture/v3/ksdft2effmass/periodic1d/rankN/band_alignment/composite/index.md` |
| `7996734eb2288f837233f7963fd4a47631cd589fd32b047b6997b2bff52cce37` | `docs/architecture/v3/ksdft2effmass/periodic1d/rankN/band_alignment/composite/scientifics.md` |
| `84f89678dd50b23a01cec6cf30044520c8dc5d185dbf1b690f9456bedd7e3031` | `docs/architecture/v3/ksdft2effmass/scientific-operation-taxonomy.md` |
| `58978f7d9cc6befeba106e5fe249404cf85636cd40258b2ab5b8f4ec56c92a83` | `python/src/ksdft2effmass/gauge_alignment/base.py` |
| `266db3fa86a20074e6e8271c3c019e815859672809b82bd2e2ab6e4fe711f313` | `python/src/ksdft2effmass/periodic1d/rank2/gauge_alignment/analysis.py` |
| `3f5a2b7b791e9dbfe3bf2b139df564f93775725d5d2343127135ead14198f054` | `python/src/ksdft2effmass/periodic1d/rank2/gauge_alignment/result.py` |
| `f8f699a0c1d98f820f3b516a35b1f08bf74070581ac1918703f43cb673768c70` | `python/src/ksdft2effmass/periodic1d/rankN/band_alignment/composite/result/gauge_alignment.py` |
| `60d64f5147902ad77e5dd37ce99aaddcc39d4e4227bed67aa1242d9ed82029ff` | `python/src/ksdft2effmass/periodic1d/rankN/gauge_alignment/request.py` |
| `3e0bd8aebe06908b8841ddef327fc1d6b9bf36a1ed4a269c5ecb906106effaea` | `python/tests/ksdft2effmass/periodic1d/rank2/gauge_alignment/test__Periodic1DRank2GaugeAlignmentAnalyzer.py` |
| `6c7eabc9879f8062921cdb211792968b9fb0f1ce9d423fa545321122a59e1e54` | `python/tests/ksdft2effmass/periodic1d/rankN/band_alignment/composite/test__Periodic1DRankNAlignmentAnalyzer.py` |
| `f4d07deffb2e41eb8348371fc24c2f11959437020cf52e196604efeaf644e63d` | `python/tests/ksdft2effmass/test__GaugeAlignment__ownership.py` |

This correction freezes `GaugeAlignmentInnerProductConvention.EUCLIDEAN` without embedding frame
orthonormality in the label. Concrete frame and request contracts retain frame-validity ownership.
It also records that the current `Ambient × Retained` column frames admit retained-space right
actions, and that future metric-aware work must distinguish the coordinate-endomorphism law
`U⁻¹ H U` from the compressed sesquilinear-form law `Uᴴ H U` before defining an operator
transformation or objective. These owner boundaries agree with the bounded Formal layer.

The initial handoff separates the unitary group family, finite represented dimension, left/right
action label, a then-named Euclidean-orthonormal inner-product convention, ordered sample domain,
and global-versus-pointwise constraint. Formal maps these to a closed family vocabulary, a
type-derived finite cardinality, a separate action-side vocabulary, an explicit Euclidean-metric
convention that does not assert frame orthonormality, the existing sample type, and the existing
global/complete alignment families. The current column-frame equation
is already `F ↦ F U`, and `BG-ALIGNMENT-THM-005` proves the resulting compression law
`H ↦ Uᴴ H U`.

Two boundaries remain explicit. First, a retained-space left action is not conformable with the
current `Ambient × Retained` column-frame carrier without a separately typed row-frame convention;
an ambient left action would be a different operation. Second, for a nonorthonormal basis,
`Uᴴ M U = M` defines metric isometry, but a coordinate endomorphism generally transforms by
`U⁻¹ H U`, whereas a compressed sesquilinear-form matrix transforms by `Uᴴ H U`. The inspected
KSD sources now require that future contract to choose its represented object and adjoint, but they
do not choose one or define a metric-aware objective. Formal therefore records only the exact
metric-isometry predicate and does not claim a metric-aware alignment implementation, optimizer,
certificate, locality result, or scientific acceptance.

<a id="aud-src-030"></a>

## `AUD-SRC-030` — Scalar DFT and PAW primary-source acquisition

| Field | Value |
|---|---|
| Record ID | `AUD-SRC-030` |
| Status | `provisional` |
| Source class | Literature and primary-source inspection |
| Authority | Inspected identity, bytes, locators, and stated limitations only |

The initial scalar DFT authority set was acquired on `2026-11-25` for the planned
Hohenberg--Kohn, Levy--Lieb, Kohn--Sham, orbital, and PAW sequence.  The inspected References
checkout was `/Users/eugene/repos/projectkoios-references`, branch `master`, commit
`0fac430c715939a77c1be66c46ad0bbebb49447b`; `bibliography/references.bib` was modified during
this acquisition.  The PDF files below are ignored local candidate assets.  Their matching
`AuthorYYYY.pdf` names, PDF headers, sizes, and hashes are observations only: they are not replay-
derived canonical References identities or asset authorizations.

| Proposed citekey | Source and acquisition locator | Local candidate observation | Formal use status |
|---|---|---|---|
| `Hohenberg1964` | P. Hohenberg and W. Kohn, “Inhomogeneous Electron Gas,” DOI `10.1103/PhysRev.136.B864`; institutional copy retrieved from `http://metal.elte.hu/~groma/mater_phys/PhysRev.136.B864.pdf` | `Hohenberg1964.pdf`; 838879 bytes; SHA-256 `d241218df9578242dd461101f369c4a7d3ed58388567897a53f2e885a1be8a97`; PDF 1.4, 8 pages | Part I §1, equations (5)--(8), is cited directly in the relevant `.lean` module and declaration docstrings for the abstract nondegenerate variational core; the adaptation does not formalize the paper's continuum hypotheses |
| `Kohn1965` | W. Kohn and L. J. Sham, “Self-Consistent Equations Including Exchange and Correlation Effects,” DOI `10.1103/PhysRev.140.A1133`; institutional copy retrieved from `http://www.lptms.universite-paris-saclay.fr/nicolas_pavloff/files/2010/03/PhysRev.140.A11331.pdf` | `Kohn1965.pdf`; 989990 bytes; SHA-256 `71df6859ee7cb1619b34d6ab87d82516735ae48a6213cc1a6f608eb81810b779`; PDF 1.3, 6 pages; image-scan equations checked against rendered page images rather than accepted from OCR alone | Section II.A, equations (2.1)--(2.2), are cited directly in `FunctionalDecomposition.lean` for the exact remainder identity; equation (2.3) is recorded only as an excluded LDA boundary; equation (2.9) is cited directly in `OccupiedOrbitals.lean` for finite pointwise density reconstruction and in `FiniteBasisDensity.lean` only for the density sum after substitution of a separately source-neutral finite basis expansion; no basis-discretization authority, functional derivative, orbital existence, effective-operator, self-consistency, or approximation claim is imported |
| `Levy1979` | M. Levy, “Universal Variational Functionals of Electron Densities, First-Order Density Matrices, and Natural Spin-Orbitals and Solution of the V-Representability Problem,” DOI `10.1073/pnas.76.12.6062`; open full text retrieved through Europe PMC, PMCID `PMC411802` | `Levy1979.pdf`; 731350 bytes; SHA-256 `996fbf157f4aefe65e946e87c21135b58d6d60903733d155a673461efb806cf4`; PDF 1.3, 4 pages | equation (5), Theorems I/II, equations (6)--(7), and proofs (8)--(21) are cited directly in `ConstrainedSearch.lean` for the abstract representable-density infimum and outer variational results; continuum state-space and attainment claims are not imported |
| `Blochl1994` | P. E. Blöchl, “Projector Augmented-Wave Method,” DOI `10.1103/PhysRevB.50.17953`; institutional copy retrieved from `https://users.wfu.edu/natalie/s11phy752/lecturenote/BlochlPhysRevB.50.17953.pdf` | `Blochl1994.pdf`; 5118150 bytes; SHA-256 `a74d1f7c884153880c8c98b36a354b0d3af1c20777231e33d6b7965ad86589f6`; PDF 1.3, 27 pages; central image-scan equations checked against rendered page images rather than accepted from OCR alone | Section II.A equations (8)--(9), Section II.B equation (11), and Section IV.A equation (30) are cited in `PAW/FiniteTransformation.lean` for supplied finite state reconstruction, operator congruence, and overlap; Section II.A equations (6)--(9) are cited in `PAW/ProjectorAugmentation.lean` for projector amplitudes, duality, the finite-rank transformation, and its reconstructed-state action; completeness and the explicit overlap expansion remain separate obligations |
| `Lieb1983` | E. H. Lieb, “Density Functionals for Coulomb Systems,” DOI `10.1002/qua.560240302`; operator-supplied publisher PDF copied read-only from `$HOME/Downloads/Lieb1983` after title and embedded DOI verification | `Lieb1983.pdf`; 1650444 bytes; SHA-256 `962140e96a0a7d189f9c1f72e37231d9457500b67b6f62e7c08322aedb1d5563`; PDF 1.3, 35 pages | Section 3, equations (3.14)--(3.15), is cited directly in `ConstrainedSearch.lean` for the infimum/domain distinction and ground-energy identity; Theorem 3.3 is named only as a separate continuum attainment result not proved by the abstract module |
| `Kresse1999` | G. Kresse and D. Joubert, “From Ultrasoft Pseudopotentials to the Projector Augmented-Wave Method,” DOI `10.1103/PhysRevB.59.1758`; operator-supplied publisher article copied read-only from `$HOME/Downloads/kresse1999.pdf` after title, author, abstract, and article-page verification | `Kresse1999.pdf`; 289506 bytes; SHA-256 `e4cd6772b96ab2318904aeaa99a0f9ac253f5d4c29719bc78be3505ed1621b28`; PDF 1.1, 18 extracted article pages | Section III.A equations (38)--(40) and the generalized Kohn--Sham equation displayed in Section III.D immediately after equation (51) are cited directly in `PAW/FiniteTransformation.lean`; the Lean theorem supplies and explicitly assumes finite transformation invertibility, and imports no ultrasoft linearization, force, dataset, numerical, or scientific-equivalence claim |

The earlier APS and Wiley access failures were not used as source substitutes.  Search results that
only cited these works, non-authoritative document-sharing pages, later reviews, and unrelated
theses were not retained.  Bibliography entries were added for all six works, but those entries and
the six local candidate files do not
establish accepted References identities, canonical citekeys, rights clearance, or publication
authority.

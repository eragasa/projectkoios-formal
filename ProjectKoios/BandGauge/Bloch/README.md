# BandGauge Bloch sewing

This folder owns pointwise reciprocal-boundary sewing contracts for complex Hilbert
fibers. It does not yet own continuous, measurable, Sobolev, or `L²` section spaces.

`Sewing.lean` owns:

- `BG-BLOCH-DEF-001` — unitary sewing data with identity and cocycle laws; status `implemented`.
- `BG-BLOCH-DEF-002` — sewn Bloch section predicate; status `implemented`.
- `BG-BLOCH-DEF-003` — sewn operator-field predicate; status `implemented`.
- `BG-BLOCH-DEF-004` — sewing-compatible unitary alignment predicate; status `implemented`.
- `BG-BLOCH-DEF-005` — aligned operator pullback; status `implemented`.
- `BG-BLOCH-THM-001` — sewn operators preserve sewn sections; status `proved`.
- `BG-BLOCH-THM-002` — sewing-compatible alignment preserves operator covariance; status `proved`.

`PeriodicRankTwo.lean` owns:

- `BG-BLOCH-DEF-006` — the standard complex retained rank-two fiber; status `implemented`.
- `BG-BLOCH-DEF-007` — matrix entries of an operator on that fiber; status `implemented`.
- `BG-BLOCH-DEF-008` — an abstract sewn rank-two Hamiltonian with a finite weighted
  sample; status `implemented`.
- `BG-BLOCH-DEF-009/010` — trace-centered Bloch matrices and their sampled field;
  status `implemented`.
- `BG-BLOCH-DEF-011` — pointwise unitary conjugation `U† D U`; status `implemented`.
- `BG-BLOCH-THM-003/004` — centering makes the retained and sampled matrices traceless;
  status `proved`.
- `BG-BLOCH-THM-005/006` — unitary conjugation preserves tracelessness and weighted
  Frobenius power; status `proved`.
- `BG-BLOCH-THM-007/008` — two unitary alignments of one centered parent field have
  common power and correlation magnitude at most that power; status `proved`.
- `BG-BLOCH-THM-009--011` — trace centering, finite sampling, and pointwise unitary
  conjugation preserve Hermiticity; status `proved`.

The sewing convention is explicit: `transport g k` maps fiber coordinates at `k` to
fiber coordinates at `g • k`. The periodic rank-two structure is an interface, not a
proof of Bloch--Floquet decomposition from a periodic potential. Physlib currently
provides a prospective direct-space crystal layer but no Bloch theorem to instantiate
this interface. The current layer remains pointwise. A future Hilbert space of operator
fields must choose regularity and measure contracts explicitly; pointwise boundary
sewing cannot be inferred from an `L²` equivalence class.

`docs/theorem-manifest.md` is the authoritative declaration ledger.

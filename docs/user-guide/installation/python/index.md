# Python and uv environment

Python is non-authoritative support tooling for the planned exact-direct-matrix pilot. It may generate deterministic synthetic fixtures, apply mutations, inspect records, report diagnostics, and orchestrate independent commands. It may not decide the authoritative theorem result or substitute for either native conformance route.

## Qualified host tools

| Tool | Qualified identity |
|---|---|
| Python | CPython 3.14.6 |
| Executable | `/opt/homebrew/opt/python@3.14/bin/python3.14` |
| Architecture | ARM64 |
| uv | 0.11.25 |

A dedicated package-empty virtual environment was created outside tracked source. `uv pip freeze` and Python distribution discovery both reported no installed distributions, so the qualified support route is standard-library-only.

The Mojo packaging environment is separate and has its own hash-locked wheel graph. Do not merge it with pilot Python tooling.

## Qualified support probe

The external capability probe used only `hashlib`, `pathlib`, and `sys`. Two independent runs produced byte-identical 2 MiB fixtures and byte-identical one-byte mutations.

Expected digests:

```text
fixture  91d3beb88a9b2f778a6c44a1c53b63d3c79931845a9aef84b3fb414610bd1938
mutation d450c92a9f4180a16d8fdb4194ad9d7518a50bdb021361c36e025f7773ac8ae4
```

Exact environment and probe commands are frozen in the external Gate 0 command registry. The probe is capability evidence only; it is not an implementation fixture generator and is not certificate evidence.

## Environment policy

- Create virtual environments outside tracked source or under an ignored path.
- Do not install packages into the system interpreter.
- Use the package-empty standard-library route unless a later dependency is separately justified, hash-locked, license-reviewed, and authorized.
- Retain the Python executable digest, `uv --version`, platform tags, package inventory, and fixture hashes.
- Keep Mojo's packaging environment separate even though both use `uv`.
- Do not add a pilot `pyproject.toml`, lockfile, generator, or orchestration package without separate implementation authorization.

## Permitted future responsibilities

Python may:

- generate schema-valid exact rational fixtures deterministically;
- generate malformed and adversarial mutations;
- invoke Lean, Rust, and Mojo as separate processes;
- compare byte-level outputs and produce diagnostics;
- verify retained artifact hashes; and
- package inspection-only reports.

Python must not:

- provide parsing, rational arithmetic, matrix arithmetic, or semantic intermediates to Rust or Mojo;
- supply the digest implementation used by either native route;
- turn NumPy, SciPy, an eigensolver, FFT, Wannier90, or floating-point output into exact formal evidence;
- resolve a Rust/Mojo disagreement;
- claim Lean theorem execution; or
- promote a fixture or conformance record to scientific evidence.

No implementation fixture corpus, mutation suite, or orchestration package exists. Those commands remain `UNFROZEN` until separately authorized source is created and the commands pass locally.

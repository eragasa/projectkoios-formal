#!/usr/bin/env python3
"""Check that declared and resolved Lake revisions are immutable commit IDs."""

from __future__ import annotations

import json
import re
import tomllib
from pathlib import Path

HEX_REVISION = re.compile(r"[0-9a-f]{40}")
EXPECTED_MATHLIB = "fc4f59e577feb1a4956671bc04ac18aaaf8cd842"
EXPECTED_PHYSLIB = "101e93cf91f0304f5ab9bfbfdec6cebcc031f7cd"

lakefile = tomllib.loads(Path("lakefile.toml").read_text(encoding="utf-8"))
requirements = {item["name"]: item for item in lakefile.get("require", [])}
expected_direct = {
    "mathlib": EXPECTED_MATHLIB,
    "Physlib": EXPECTED_PHYSLIB,
}
for name, expected in expected_direct.items():
    revision = requirements[name]["rev"]
    assert revision == expected
    assert HEX_REVISION.fullmatch(revision)

manifest = json.loads(Path("lake-manifest.json").read_text(encoding="utf-8"))
resolved = {item["name"]: item["rev"] for item in manifest["packages"]}
for name, expected in expected_direct.items():
    assert resolved[name] == expected
for name, revision in resolved.items():
    assert HEX_REVISION.fullmatch(revision), f"non-immutable resolved revision: {name}={revision}"

print(
    "pin check passed: "
    f"mathlib={EXPECTED_MATHLIB}; Physlib={EXPECTED_PHYSLIB}; "
    f"{len(resolved)} resolved revisions are commit IDs"
)

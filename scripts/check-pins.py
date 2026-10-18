#!/usr/bin/env python3
"""Check that declared and resolved Lake revisions are immutable commit IDs."""

from __future__ import annotations

import json
import re
import tomllib
from pathlib import Path

HEX_REVISION = re.compile(r"[0-9a-f]{40}")
EXPECTED_MATHLIB = "56a005855ea17e0b0958f73ec801ae140b0a1679"

lakefile = tomllib.loads(Path("lakefile.toml").read_text(encoding="utf-8"))
requirements = {item["name"]: item for item in lakefile.get("require", [])}
mathlib_revision = requirements["mathlib"]["rev"]
assert mathlib_revision == EXPECTED_MATHLIB
assert HEX_REVISION.fullmatch(mathlib_revision)

manifest = json.loads(Path("lake-manifest.json").read_text(encoding="utf-8"))
resolved = {item["name"]: item["rev"] for item in manifest["packages"]}
assert resolved["mathlib"] == EXPECTED_MATHLIB
for name, revision in resolved.items():
    assert HEX_REVISION.fullmatch(revision), f"non-immutable resolved revision: {name}={revision}"

print(f"pin check passed: mathlib={EXPECTED_MATHLIB}; {len(resolved)} resolved revisions are commit IDs")

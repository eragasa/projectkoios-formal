#!/usr/bin/env python3
"""Check that every proved manifest declaration has a named axiom report."""

from __future__ import annotations

import re
import sys
from collections import Counter
from pathlib import Path

MANIFEST_PATH = Path("docs/theorem-manifest.md")
AUDIT_PATH = Path("ProjectKoios/Audit.lean")

MANIFEST_ROW = re.compile(
    r"^\| `(?P<id>[^`]+-(?:LEM|THM)-\d{3})` "
    r"\| `(?P<name>[^`]+)` \| (?P<kind>theorem|lemma) "
    r"\| (?P<status>[^|]+) \|"
)
AXIOM_REPORT = re.compile(r"^#print axioms (?P<name>\S+)\s*$")

manifest_lines = MANIFEST_PATH.read_text(encoding="utf-8").splitlines()
proved_rows: list[tuple[str, str]] = []
malformed_proved_rows: list[tuple[int, str]] = []

for line_number, line in enumerate(manifest_lines, start=1):
    if "| proved; no admissions |" not in line:
        continue
    match = MANIFEST_ROW.match(line)
    if match is None:
        malformed_proved_rows.append((line_number, line))
        continue
    proved_rows.append((match.group("id"), match.group("name")))

report_names = [
    match.group("name")
    for line in AUDIT_PATH.read_text(encoding="utf-8").splitlines()
    if (match := AXIOM_REPORT.match(line)) is not None
]

manifest_id_counts = Counter(identifier for identifier, _ in proved_rows)
manifest_name_counts = Counter(name for _, name in proved_rows)
report_name_counts = Counter(report_names)

errors: list[str] = []
if malformed_proved_rows:
    errors.append("malformed proved manifest rows:")
    errors.extend(f"  {line_number}: {line}" for line_number, line in malformed_proved_rows)

for label, counts in (
    ("proved manifest IDs", manifest_id_counts),
    ("proved manifest declaration names", manifest_name_counts),
    ("axiom report targets", report_name_counts),
):
    duplicates = sorted(name for name, count in counts.items() if count != 1)
    if duplicates:
        errors.append(f"duplicate {label}:")
        errors.extend(f"  {name}" for name in duplicates)

reported = set(report_names)
missing = [(identifier, name) for identifier, name in proved_rows if name not in reported]
if missing:
    errors.append("proved declarations without named #print axioms reports:")
    errors.extend(f"  {identifier}: {name}" for identifier, name in missing)

if errors:
    print("audit coverage check failed", file=sys.stderr)
    print("\n".join(errors), file=sys.stderr)
    raise SystemExit(1)

print(
    "audit coverage check passed: "
    f"{len(proved_rows)} proved theorem/lemma rows; "
    f"{len(report_names)} unique named axiom reports"
)

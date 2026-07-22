#!/usr/bin/env python3
"""Atomically upsert one sanitized realtime scenario outcome row."""

from __future__ import annotations

import argparse
import csv
import json
import os
import tempfile
from pathlib import Path


FIELDNAMES = (
    "scenario",
    "operation",
    "channel",
    "environment",
    "run_label",
    "result",
    "session_id",
    "transport_id",
    "recording_id",
    "request_summary",
    "tool_calls",
    "authority_outcome",
    "caller_visible_result",
    "writes",
    "cleanup",
    "gaps",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Replace or append one scenario/channel row in last-runs.csv."
    )
    parser.add_argument("--csv", required=True, dest="csv_path")
    parser.add_argument("--scenario", required=True)
    parser.add_argument("--operation", required=True)
    parser.add_argument("--channel", required=True, choices=("phone", "browser-chat"))
    parser.add_argument("--environment", required=True, choices=("dev",))
    parser.add_argument("--run-label", required=True)
    parser.add_argument("--result", required=True, choices=("Pass", "Fail", "Blocked"))
    parser.add_argument("--session-id", required=True)
    parser.add_argument("--transport-id", required=True)
    parser.add_argument("--recording-id", required=True)
    parser.add_argument("--request-summary", required=True)
    parser.add_argument("--tool-calls", required=True)
    parser.add_argument("--authority-outcome", required=True)
    parser.add_argument("--caller-visible-result", required=True)
    parser.add_argument("--writes", required=True)
    parser.add_argument("--cleanup", required=True)
    parser.add_argument("--gaps", required=True)
    return parser.parse_args()


def normalize_key(row: dict[str, str]) -> tuple[str, str]:
    return (row["scenario"].strip().casefold(), row["channel"].strip().casefold())


def validated_row(args: argparse.Namespace) -> dict[str, str]:
    row = {
        field: str(getattr(args, field)).strip()
        for field in FIELDNAMES
    }
    for field, value in row.items():
        if not value:
            raise ValueError(f"Missing non-empty CSV value: {field}")
        if "\n" in value or "\r" in value:
            raise ValueError(f"CSV value must be one line: {field}")
    return row


def read_rows(csv_path: Path) -> list[dict[str, str]]:
    if not csv_path.is_file():
        raise FileNotFoundError(f"Canonical latest-run CSV does not exist: {csv_path}")
    with csv_path.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if tuple(reader.fieldnames or ()) != FIELDNAMES:
            raise ValueError(
                "Unexpected latest-run CSV header; refusing to rewrite canonical data"
            )
        rows = list(reader)
    for index, row in enumerate(rows, start=2):
        if set(row) != set(FIELDNAMES) or any(row[field] is None for field in FIELDNAMES):
            raise ValueError(f"Malformed latest-run CSV row at line {index}")
    return rows


def write_rows(csv_path: Path, rows: list[dict[str, str]]) -> None:
    temp_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            newline="",
            dir=csv_path.parent,
            prefix=f".{csv_path.name}.",
            suffix=".tmp",
            delete=False,
        ) as handle:
            temp_path = Path(handle.name)
            csv.writer(handle, lineterminator="\n").writerow(FIELDNAMES)
            writer = csv.DictWriter(
                handle,
                fieldnames=FIELDNAMES,
                quoting=csv.QUOTE_ALL,
                lineterminator="\n",
            )
            writer.writerows(rows)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temp_path, csv_path)
        temp_path = None
    finally:
        if temp_path is not None:
            temp_path.unlink(missing_ok=True)


def main() -> None:
    args = parse_args()
    csv_path = Path(args.csv_path).resolve()
    new_row = validated_row(args)
    new_key = normalize_key(new_row)
    existing_rows = read_rows(csv_path)

    output_rows: list[dict[str, str]] = []
    replaced = False
    for existing in existing_rows:
        if normalize_key(existing) != new_key:
            output_rows.append(existing)
            continue
        if not replaced:
            output_rows.append(new_row)
            replaced = True

    if not replaced:
        output_rows.append(new_row)

    write_rows(csv_path, output_rows)
    print(
        json.dumps(
            {
                "action": "replaced" if replaced else "appended",
                "scenario": new_row["scenario"],
                "channel": new_row["channel"],
                "rowCount": len(output_rows),
                "csv": str(csv_path),
            }
        )
    )


if __name__ == "__main__":
    main()

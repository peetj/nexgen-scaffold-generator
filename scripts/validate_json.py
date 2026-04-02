#!/usr/bin/env python3
import json
import sys
from pathlib import Path

try:
    from jsonschema import Draft202012Validator
except ImportError as exc:
    print("Error: jsonschema package is required. Install with: pip install jsonschema")
    raise SystemExit(1) from exc


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: validate_json.py schema.json scaffold.json")
        return 1

    schema_path = Path(sys.argv[1])
    data_path = Path(sys.argv[2])

    try:
        schema = json.loads(schema_path.read_text(encoding="utf-8"))
        data = json.loads(data_path.read_text(encoding="utf-8"))
    except Exception as exc:
        print(f"Error reading JSON: {exc}")
        return 1

    validator = Draft202012Validator(schema)
    errors = sorted(validator.iter_errors(data), key=lambda e: list(e.path))
    if errors:
        print(f"Validation failed for: {data_path}")
        for error in errors:
            path = ".".join(str(p) for p in error.path) or "<root>"
            print(f"- {path}: {error.message}")
        return 1

    print(f"Validation passed: {data_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

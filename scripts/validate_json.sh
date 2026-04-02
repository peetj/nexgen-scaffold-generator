#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 path/to/scaffold.json"
  exit 1
fi

JSON_FILE="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCHEMA_FILE="$ROOT_DIR/scaffold.schema.json"

if [ ! -f "$JSON_FILE" ]; then
  echo "Error: JSON file not found: $JSON_FILE"
  exit 1
fi

python3 "$SCRIPT_DIR/validate_json.py" "$SCHEMA_FILE" "$JSON_FILE"

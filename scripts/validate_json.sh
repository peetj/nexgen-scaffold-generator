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

PYTHON_CMD=""

if command -v python3 >/dev/null 2>&1; then
  PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
  if python -c "import sys; raise SystemExit(0 if sys.version_info.major == 3 else 1)"; then
    PYTHON_CMD="python"
  fi
fi

if [ -z "$PYTHON_CMD" ]; then
  echo "Error: Python 3 is required but was not found."
  exit 1
fi

"$PYTHON_CMD" "$SCRIPT_DIR/validate_json.py" "$SCHEMA_FILE" "$JSON_FILE"

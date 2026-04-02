#!/usr/bin/env bash

set -euo pipefail

missing=0

if command -v jq >/dev/null 2>&1; then
  echo "Found jq: $(command -v jq)"
  jq --version
else
  echo "Missing jq"
  missing=1
fi

PYTHON_CMD=""

if command -v python3 >/dev/null 2>&1; then
  PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
  if python -c "import sys; raise SystemExit(0 if sys.version_info.major == 3 else 1)"; then
    PYTHON_CMD="python"
  fi
fi

if [ -n "$PYTHON_CMD" ]; then
  echo "Found Python 3 via: $PYTHON_CMD"
  $PYTHON_CMD --version
else
  echo "Missing Python 3"
  missing=1
fi

if [ "$missing" -ne 0 ]; then
  echo
  echo "One or more dependencies are missing."
  exit 1
fi

echo
echo "Setup check passed."

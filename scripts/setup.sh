#!/usr/bin/env bash
set -euo pipefail

echo "Checking dependencies..."

missing=0
for cmd in jq python3; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing: $cmd"
    missing=1
  else
    echo "Found: $cmd"
  fi
done

python3 - <<'PY'
import importlib.util
mods = ["jsonschema"]
missing = [m for m in mods if importlib.util.find_spec(m) is None]
if missing:
    print("Missing Python packages:", ", ".join(missing))
    print("Install with: pip install jsonschema")
    raise SystemExit(1)
print("Found Python package: jsonschema")
PY

echo "All required dependencies are available."

#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required but not installed."
  exit 1
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 path/to/scaffold.json"
  exit 1
fi

JSON_FILE="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$JSON_FILE" ]; then
  echo "Error: JSON file not found: $JSON_FILE"
  exit 1
fi

"$SCRIPT_DIR/validate_json.sh" "$JSON_FILE"

create_files() {
  local target_path="$1"
  local files_json="$2"

  echo "$files_json" | jq -c '.[]? // empty' | while IFS= read -r file_obj; do
    local file_name
    file_name=$(echo "$file_obj" | jq -r '.name')

    local file_path="$target_path/$file_name"
    mkdir -p "$(dirname "$file_path")"

    if echo "$file_obj" | jq -e 'has("content")' >/dev/null; then
      echo "$file_obj" | jq -r '.content' > "$file_path"
    else
      : > "$file_path"
    fi

    if echo "$file_obj" | jq -e '.chmod == "+x"' >/dev/null; then
      chmod +x "$file_path"
    fi

    echo "Created file: $file_path"
  done
}

create_node() {
  local base_path="$1"
  local node_json="$2"

  local node_name
  node_name=$(echo "$node_json" | jq -r '.name')

  local current_path="$base_path/$node_name"
  mkdir -p "$current_path"
  echo "Created directory: $current_path"

  local files_json
  files_json=$(echo "$node_json" | jq -c '.files // []')
  create_files "$current_path" "$files_json"

  echo "$node_json" | jq -c '.dirs[]? // empty' | while IFS= read -r child_dir; do
    create_node "$current_path" "$child_dir"
  done
}

ROOT_NAME=$(jq -r '.name' "$JSON_FILE")
ROOT_PATH="./$ROOT_NAME"

mkdir -p "$ROOT_PATH"
echo "Created root directory: $ROOT_PATH"

ROOT_FILES=$(jq -c '.files // []' "$JSON_FILE")
create_files "$ROOT_PATH" "$ROOT_FILES"

jq -c '.dirs[]? // empty' "$JSON_FILE" | while IFS= read -r root_dir; do
  create_node "$ROOT_PATH" "$root_dir"
done

echo "Done."

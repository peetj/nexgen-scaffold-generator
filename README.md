# nexgen-scaffold-generator

Reusable project scaffold generator for creating GitHub-ready project skeletons from a JSON definition.

## What it does

- Validates a scaffold JSON file against a JSON Schema
- Creates folders and files from that scaffold definition
- Supports optional starter file content
- Supports optional executable bit for script files

## Locked scaffold format

At the root and for every directory:

```json
{
  "name": "project-name",
  "files": [],
  "dirs": []
}
```

For files:

```json
{
  "name": "README.md",
  "content": "# My Project\n",
  "chmod": "+x"
}
```

### Rules

- `name` is required everywhere
- `files` is always an array of file objects
- `dirs` is always an array of directory objects
- `content` is optional
- `chmod` is optional and currently supports only `"+x"`

## Quick start

### 1. Check dependencies

```bash
./scripts/setup.sh
```

### 2. Validate a scaffold file

```bash
./scripts/validate_json.sh examples/simple-project.json
```

### 3. Generate the project

```bash
./scripts/create_from_json.sh examples/simple-project.json
```

Generated projects are created in the current working directory.

## Repo layout

- `scaffold.schema.json` - schema for scaffold JSON files
- `scripts/` - generator and validation scripts
- `examples/` - example scaffold definitions
- `docs/` - human-readable format and design notes
- `tests/` - sample valid and invalid definitions

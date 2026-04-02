# Scaffold JSON format

## Root and directory objects

Both the root object and nested directory objects use the same structure:

```json
{
  "name": "project-name-or-directory-name",
  "files": [],
  "dirs": []
}
```

## File objects

```json
{
  "name": "README.md",
  "content": "# Project\n",
  "chmod": "+x"
}
```

## Notes

- `name` is required
- `files` and `dirs` are optional
- `content` is optional
- `chmod` is optional and currently supports only `+x`
- files must always be objects, not strings

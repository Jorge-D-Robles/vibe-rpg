---
name: gdscript-linter
description: Check GDScript code for syntax errors and style violations. Uses `gdlint` (from gdtoolkit) or `godot --check-only` if available.
---

# GDScript Linter Skill

This skill helps ensure your GDScript code is error-free before running the game.

## Prerequisites

- **gdtoolkit** (recommended): Install with `pip install gdtoolkit`. This provides `gdlint`.
- **Godot CLI**: The `godot` command should be in your PATH.

## Workflow

1. **Identify Need:** When modifying or writing new GDScript files.
2. **Run Linter:** Execute the `lint.sh` script on the file.
3. **Fix Errors:** The tool reports line numbers and error descriptions.

## Tool Usage

```bash
./.gemini/skills/gdscript-linter/scripts/lint.sh res://scripts/player.gd
```

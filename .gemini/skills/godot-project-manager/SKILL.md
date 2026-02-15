---
name: godot-project-manager
description: Manage Godot project settings (project.godot). Use this skill to read or modify project configuration, such as display settings, input maps, and autoloads.
---

# Godot Project Manager Skill

This skill allows you to safely read and modify the `project.godot` file, which contains the project's configuration.

## Workflow

1. **Identify Need:** When a user asks to change a project setting (e.g., "change window size to 1280x720", "enable physics interpolation").
2. **Read Current State (Optional):** Check the existing value to confirm if a change is needed.
3. **Modify Setting:** Use the `manage_project.py` script to update the value.

## Tool Usage

### Reading a Setting

```bash
python3 .gemini/skills/godot-project-manager/scripts/manage_project.py get "display/window/size/viewport_width"
```

### Writing a Setting

```bash
python3 .gemini/skills/godot-project-manager/scripts/manage_project.py set "display/window/size/viewport_width" 1280
```

### Adding an Autoload (Singleton)

Godot autoloads are stored in the `[autoload]` section.

```bash
python3 .gemini/skills/godot-project-manager/scripts/manage_project.py set "autoload" "MySingleton" "*res://scripts/my_singleton.gd"
```

## Notes

- Section names in `project.godot` are like `[application]`, `[display]`, etc.
- Keys can be nested with slashes in the editor (e.g., `display/window/size/viewport_width`), but in the file, they might be flattened or grouped under a section. The script handles the standard `section/key` format or tries to infer the section from the first part of the key if not explicitly provided.
- Ideally, provide the full path key as seen in the Project Settings dialog.

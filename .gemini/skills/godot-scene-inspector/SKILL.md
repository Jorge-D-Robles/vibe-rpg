---
name: godot-scene-inspector
description: Analyze Godot scene files (.tscn) to understand the node hierarchy, attached scripts, and resources. Use this to verify scene structure or debug references.
---

# Godot Scene Inspector Skill

This skill parses `.tscn` files to reveal the scene's node hierarchy and resource dependencies.

## Workflow

1. **Identify Need:** When you need to know the name, type, or parent of nodes in a scene (e.g., "What is the path to the player node?", "Does the Main scene have a HUD?").
2. **Inspect Scene:** Run the `inspect_scene.py` script on a `.tscn` file.
3. **Interpret Output:** The script outputs a tree view of nodes and a list of external resources.

## Tool Usage

```bash
python3 .gemini/skills/godot-scene-inspector/scripts/inspect_scene.py res://scenes/main.tscn
```

(Note: You can use relative paths or `res://` paths if the script is run from project root).

## output Format

```text
Resources:
[1] res://icon.svg (Texture2D)
[2] res://player.gd (Script)

Nodes:
Main (Node2D) script=res://player.gd
  Player (CharacterBody2D)
    Sprite2D (Sprite2D) texture=res://icon.svg
    CollisionShape2D (CollisionShape2D)
```

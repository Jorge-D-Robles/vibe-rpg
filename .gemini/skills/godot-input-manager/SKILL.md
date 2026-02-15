---
name: godot-input-manager
description: Configure input actions in the project.godot file. Use this skill to define keyboard, mouse, and gamepad bindings for player controls.
---

# Godot Input Manager Skill

This skill manages the `[input]` section of `project.godot`, allowing the agent to define and modify input actions without the editor.

## Godot 4 Input Map Format

Input actions in `project.godot` look like this:

```ini
[input]

move_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":65,"key_label":0,"unicode":97,"location":0,"echo":false,"script":null)
]
}
```

This is verbose. The script simplifies it.

## Tool Usage

### Add an input action

```bash
python3 .gemini/skills/godot-input-manager/scripts/manage_inputs.py add \
  --project godot-gemini-plugin/project.godot \
  --action "move_left" \
  --key "A"
```

```bash
python3 .gemini/skills/godot-input-manager/scripts/manage_inputs.py add \
  --project godot-gemini-plugin/project.godot \
  --action "jump" \
  --key "Space"
```

### Add gamepad input

```bash
python3 .gemini/skills/godot-input-manager/scripts/manage_inputs.py add \
  --project godot-gemini-plugin/project.godot \
  --action "move_left" \
  --joyaxis "0:-1"
```

### List all input actions

```bash
python3 .gemini/skills/godot-input-manager/scripts/manage_inputs.py list \
  --project godot-gemini-plugin/project.godot
```

### Common Presets

Use `--preset` for quick setup:

```bash
python3 .gemini/skills/godot-input-manager/scripts/manage_inputs.py preset \
  --project godot-gemini-plugin/project.godot \
  --type "platformer"
```

Available presets: `platformer`, `topdown`, `fps`, `menu`

## Key Name Reference

| Key Name | Physical Key |
|----------|-------------|
| `A`-`Z` | Letter keys |
| `0`-`9` | Number keys |
| `Space` | Space bar |
| `Escape` | Escape |
| `Enter` | Enter/Return |
| `Tab` | Tab |
| `Shift` | Shift |
| `Ctrl` | Control |
| `Alt` | Alt |
| `Up`, `Down`, `Left`, `Right` | Arrow keys |
| `F1`-`F12` | Function keys |
| `MouseLeft`, `MouseRight`, `MouseMiddle` | Mouse buttons |

## Gamepad Axis Reference

| Axis | Description |
|------|-------------|
| `0:-1` | Left stick left |
| `0:1` | Left stick right |
| `1:-1` | Left stick up |
| `1:1` | Left stick down |
| `2:-1` | Right stick left |
| `2:1` | Right stick right |
| `3:-1` | Right stick up |
| `3:1` | Right stick down |

## Gamepad Button Reference

| Button | Description |
|--------|-------------|
| `0` | A / Cross |
| `1` | B / Circle |
| `2` | X / Square |
| `3` | Y / Triangle |
| `4` | LB / L1 |
| `5` | RB / R1 |
| `6` | LT / L2 |
| `7` | RT / R2 |
| `10` | Left Stick Click |
| `11` | Right Stick Click |
| `12` | D-pad Up |
| `13` | D-pad Down |
| `14` | D-pad Left |
| `15` | D-pad Right |

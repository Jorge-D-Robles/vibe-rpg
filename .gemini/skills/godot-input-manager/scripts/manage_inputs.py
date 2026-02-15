#!/usr/bin/env python3
"""
Godot Input Manager - Manages input actions in project.godot.

Usage:
  manage_inputs.py add --project <path> --action <name> --key <KeyName>
  manage_inputs.py add --project <path> --action <name> --joybutton <index>
  manage_inputs.py add --project <path> --action <name> --joyaxis <axis:direction>
  manage_inputs.py add --project <path> --action <name> --mouse <button>
  manage_inputs.py list --project <path>
  manage_inputs.py preset --project <path> --type <preset_name>
"""

import argparse
import os
import sys
import re


# Physical keycode mapping (Godot 4's physical_keycode values)
KEY_MAP = {
    'A': 65, 'B': 66, 'C': 67, 'D': 68, 'E': 69, 'F': 70, 'G': 71,
    'H': 72, 'I': 73, 'J': 74, 'K': 75, 'L': 76, 'M': 77, 'N': 78,
    'O': 79, 'P': 80, 'Q': 81, 'R': 82, 'S': 83, 'T': 84, 'U': 85,
    'V': 86, 'W': 87, 'X': 88, 'Y': 89, 'Z': 90,
    '0': 48, '1': 49, '2': 50, '3': 51, '4': 52,
    '5': 53, '6': 54, '7': 55, '8': 56, '9': 57,
    'Space': 32, 'Escape': 4194305, 'Enter': 4194309, 'Tab': 4194306,
    'Backspace': 4194308, 'Delete': 4194312,
    'Up': 4194320, 'Down': 4194322, 'Left': 4194319, 'Right': 4194321,
    'Shift': 4194325, 'Ctrl': 4194326, 'Alt': 4194328,
    'F1': 4194332, 'F2': 4194333, 'F3': 4194334, 'F4': 4194335,
    'F5': 4194336, 'F6': 4194337, 'F7': 4194338, 'F8': 4194339,
    'F9': 4194340, 'F10': 4194341, 'F11': 4194342, 'F12': 4194343,
}

MOUSE_MAP = {
    'MouseLeft': 1,
    'MouseRight': 2,
    'MouseMiddle': 3,
}

# Presets for common game types
PRESETS = {
    'platformer': {
        'move_left': [('key', 'A'), ('key', 'Left')],
        'move_right': [('key', 'D'), ('key', 'Right')],
        'jump': [('key', 'Space'), ('key', 'W'), ('key', 'Up')],
        'crouch': [('key', 'S'), ('key', 'Down')],
        'attack': [('mouse', 'MouseLeft')],
        'interact': [('key', 'E')],
        'pause': [('key', 'Escape')],
    },
    'topdown': {
        'move_left': [('key', 'A'), ('key', 'Left')],
        'move_right': [('key', 'D'), ('key', 'Right')],
        'move_up': [('key', 'W'), ('key', 'Up')],
        'move_down': [('key', 'S'), ('key', 'Down')],
        'attack': [('mouse', 'MouseLeft')],
        'interact': [('key', 'E')],
        'dodge': [('key', 'Space')],
        'pause': [('key', 'Escape')],
    },
    'fps': {
        'move_forward': [('key', 'W')],
        'move_backward': [('key', 'S')],
        'move_left': [('key', 'A')],
        'move_right': [('key', 'D')],
        'jump': [('key', 'Space')],
        'crouch': [('key', 'Ctrl')],
        'sprint': [('key', 'Shift')],
        'shoot': [('mouse', 'MouseLeft')],
        'aim': [('mouse', 'MouseRight')],
        'reload': [('key', 'R')],
        'interact': [('key', 'E')],
        'pause': [('key', 'Escape')],
    },
    'menu': {
        'ui_accept': [('key', 'Enter'), ('key', 'Space')],
        'ui_cancel': [('key', 'Escape')],
        'ui_up': [('key', 'Up'), ('key', 'W')],
        'ui_down': [('key', 'Down'), ('key', 'S')],
        'ui_left': [('key', 'Left'), ('key', 'A')],
        'ui_right': [('key', 'Right'), ('key', 'D')],
    }
}


def make_key_event(key_name):
    """Generate a Godot InputEventKey object string."""
    if key_name not in KEY_MAP:
        print(f"Warning: Unknown key '{key_name}'. Using keycode 0.", file=sys.stderr)
        keycode = 0
    else:
        keycode = KEY_MAP[key_name]

    return (
        f'Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",'
        f'"device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,'
        f'"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,'
        f'"physical_keycode":{keycode},"key_label":0,"unicode":0,"location":0,'
        f'"echo":false,"script":null)'
    )


def make_mouse_event(button_name):
    """Generate a Godot InputEventMouseButton object string."""
    if button_name not in MOUSE_MAP:
        print(f"Warning: Unknown mouse button '{button_name}'.", file=sys.stderr)
        button_idx = 1
    else:
        button_idx = MOUSE_MAP[button_name]

    return (
        f'Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"",'
        f'"device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,'
        f'"ctrl_pressed":false,"meta_pressed":false,"button_mask":0,'
        f'"position":Vector2(0, 0),"global_position":Vector2(0, 0),'
        f'"factor":1.0,"button_index":{button_idx},"canceled":false,'
        f'"pressed":false,"double_click":false,"script":null)'
    )


def make_joybutton_event(button_index):
    """Generate a Godot InputEventJoypadButton object string."""
    return (
        f'Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"",'
        f'"device":-1,"button_index":{button_index},"pressure":0.0,'
        f'"pressed":false,"script":null)'
    )


def make_joyaxis_event(axis_spec):
    """Generate a Godot InputEventJoypadMotion object string.
    axis_spec format: 'axis:direction' e.g. '0:-1' for left stick left
    """
    parts = axis_spec.split(":")
    axis = int(parts[0])
    direction = float(parts[1])
    return (
        f'Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"",'
        f'"device":-1,"axis":{axis},"axis_value":{direction},"script":null)'
    )


def make_action_value(events_list):
    """Create the full value string for an input action."""
    events_str = ", ".join(events_list)
    return f'{{\n"deadzone": 0.2,\n"events": [{events_str}\n]\n}}'


def read_project_file(filepath):
    """Read the project.godot file."""
    with open(filepath, 'r') as f:
        return f.read()


def write_project_file(filepath, content):
    """Write the project.godot file."""
    with open(filepath, 'w') as f:
        f.write(content)


def ensure_input_section(content):
    """Ensure [input] section exists."""
    if '[input]' not in content:
        content = content.rstrip() + '\n\n[input]\n\n'
    return content


def add_action(filepath, action_name, events):
    """Add or update an input action."""
    content = read_project_file(filepath)
    content = ensure_input_section(content)

    # Check if action already exists
    pattern = re.compile(rf'^{re.escape(action_name)}\s*=\s*\{{.*?\}}', re.MULTILINE | re.DOTALL)
    match = pattern.search(content)

    action_value = make_action_value(events)
    action_line = f'{action_name}={action_value}\n'

    if match:
        # Replace existing
        content = content[:match.start()] + action_line + content[match.end():]
        print(f"Updated action: {action_name}")
    else:
        # Add after [input] section header
        input_idx = content.index('[input]')
        # Find end of the section header line
        newline_after = content.index('\n', input_idx)
        # Insert after the blank line following [input]
        insert_pos = newline_after + 1
        # Skip any blank lines right after [input]
        while insert_pos < len(content) and content[insert_pos] == '\n':
            insert_pos += 1
        content = content[:insert_pos] + action_line + content[insert_pos:]
        print(f"Added action: {action_name}")

    write_project_file(filepath, content)


def list_actions(filepath):
    """List all input actions."""
    content = read_project_file(filepath)
    if '[input]' not in content:
        print("No [input] section found.")
        return

    # Extract the [input] section
    input_start = content.index('[input]')
    # Find the next section or end of file
    next_section = re.search(r'\n\[(?!input\])', content[input_start + 7:])
    if next_section:
        input_section = content[input_start:input_start + 7 + next_section.start()]
    else:
        input_section = content[input_start:]

    # Find action names
    actions = re.findall(r'^(\w+)\s*=', input_section, re.MULTILINE)
    if actions:
        print("Input Actions:")
        for a in actions:
            print(f"  - {a}")
    else:
        print("No input actions defined.")


def apply_preset(filepath, preset_name):
    """Apply a preset input configuration."""
    if preset_name not in PRESETS:
        print(f"Error: Unknown preset '{preset_name}'. Available: {', '.join(PRESETS.keys())}")
        sys.exit(1)

    preset = PRESETS[preset_name]
    print(f"Applying preset: {preset_name}")

    for action_name, bindings in preset.items():
        events = []
        for btype, bvalue in bindings:
            if btype == 'key':
                events.append(make_key_event(bvalue))
            elif btype == 'mouse':
                events.append(make_mouse_event(bvalue))
            elif btype == 'joybutton':
                events.append(make_joybutton_event(int(bvalue)))
            elif btype == 'joyaxis':
                events.append(make_joyaxis_event(bvalue))
        add_action(filepath, action_name, events)


def main():
    parser = argparse.ArgumentParser(description='Manage Godot input actions')
    subparsers = parser.add_subparsers(dest='command')

    # Add command
    add_parser = subparsers.add_parser('add', help='Add an input action')
    add_parser.add_argument('--project', required=True, help='Path to project.godot')
    add_parser.add_argument('--action', required=True, help='Action name')
    add_parser.add_argument('--key', help='Key name (e.g., Space, A, Up)')
    add_parser.add_argument('--mouse', help='Mouse button (MouseLeft, MouseRight, MouseMiddle)')
    add_parser.add_argument('--joybutton', type=int, help='Joypad button index')
    add_parser.add_argument('--joyaxis', help='Joypad axis as axis:direction (e.g., 0:-1)')

    # List command
    list_parser = subparsers.add_parser('list', help='List input actions')
    list_parser.add_argument('--project', required=True, help='Path to project.godot')

    # Preset command
    preset_parser = subparsers.add_parser('preset', help='Apply input preset')
    preset_parser.add_argument('--project', required=True, help='Path to project.godot')
    preset_parser.add_argument('--type', required=True, help='Preset type: platformer, topdown, fps, menu')

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    if args.command == 'list':
        list_actions(args.project)
    elif args.command == 'preset':
        apply_preset(args.project, args.type)
    elif args.command == 'add':
        events = []
        if args.key:
            events.append(make_key_event(args.key))
        if args.mouse:
            events.append(make_mouse_event(args.mouse))
        if args.joybutton is not None:
            events.append(make_joybutton_event(args.joybutton))
        if args.joyaxis:
            events.append(make_joyaxis_event(args.joyaxis))

        if not events:
            print("Error: Must specify at least one of --key, --mouse, --joybutton, --joyaxis")
            sys.exit(1)

        add_action(args.project, args.action, events)


if __name__ == "__main__":
    main()

import sys
import os
import re

def parse_project_file(filepath):
    """
    Parses project.godot preserving line structure for safe editing.
    Returns a list of lines.
    """
    with open(filepath, 'r') as f:
        return f.readlines()

def find_key_location(lines, full_key):
    """
    Finds the line index where the key is defined.
    The key might be split between section and property.
    e.g. full_key='display/window/size/viewport_width'
    could be under [display] as window/size/viewport_width=...
    """
    current_section = ""

    for i, line in enumerate(lines):
        line = line.strip()
        if line.startswith("[") and line.endswith("]"):
            current_section = line[1:-1]
        elif "=" in line:
            key_part, _ = line.split("=", 1)
            key_part = key_part.strip()

            # Construct candidate full keys
            # 1. section/key_part
            candidate1 = f"{current_section}/{key_part}" if current_section else key_part

            # Handle cases where section might be empty or key_part has slashes
            if candidate1 == full_key:
                return i

            # Godot 4 quirk: sometimes sections have slashes like [dotnet/project]

    return -1

def get_value(lines, full_key):
    idx = find_key_location(lines, full_key)
    if idx != -1:
        line = lines[idx]
        _, value = line.split("=", 1)
        return value.strip().strip('"')
    return None

def set_value(lines, full_key, new_value):
    idx = find_key_location(lines, full_key)
    if idx != -1:
        line = lines[idx]
        key_part, _ = line.split("=", 1)
        # Preserve indentation if any? Usually none in project.godot
        # Reconstruct line
        # Check if we need quotes for the value
        # existing value might guide us, or we just quote strings
        if isinstance(new_value, str) and not new_value.startswith('"') and not new_value in ['true', 'false', 'null'] and not new_value.isdigit():
             new_value = f'"{new_value}"'

        lines[idx] = f"{key_part}={new_value}\n"
        return True, lines
    return False, lines

def main():
    if len(sys.argv) < 3:
        print("Usage: manage_project.py [get|set] [key] [value]")
        sys.exit(1)

    project_file = "project.godot"
    # Try to find project.godot
    if not os.path.exists(project_file):
        # check parent
        if os.path.exists("../project.godot"):
            project_file = "../project.godot"
        elif os.path.exists("godot-gemini-plugin/project.godot"):
            project_file = "godot-gemini-plugin/project.godot"

    if not os.path.exists(project_file):
        print("Error: project.godot not found.")
        sys.exit(1)

    lines = parse_project_file(project_file)
    action = sys.argv[1]
    key = sys.argv[2]

    if action == 'get':
        val = get_value(lines, key)
        if val is not None:
            print(val)
        else:
            print(f"Key '{key}' not found.")
            sys.exit(1)

    elif action == 'set':
        if len(sys.argv) < 4:
            print("Usage: set [key] [value]")
            sys.exit(1)
        value = sys.argv[3]
        success, new_lines = set_value(lines, key, value)
        if success:
            with open(project_file, 'w') as f:
                f.writelines(new_lines)
            print(f"Updated {key}")
        else:
            print(f"Key '{key}' not found. Adding new keys is not supported in this version.")
            sys.exit(1)

if __name__ == "__main__":
    main()

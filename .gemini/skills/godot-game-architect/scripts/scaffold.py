#!/usr/bin/env python3
"""
Scaffold a Godot project structure based on game type.
Creates all necessary directories and placeholder files.
"""

import argparse
import os
import sys

COMMON_DIRS = [
    "scenes",
    "scripts/autoloads",
    "scripts/components",
    "scripts/ui",
    "assets/sprites",
    "assets/audio/sfx",
    "assets/audio/music",
    "assets/fonts",
    "assets/shaders",
    "themes",
    "levels",
]

GAME_TYPE_DIRS = {
    "platformer": [
        "scripts/player",
        "scripts/player/states",
        "scripts/enemies",
    ],
    "topdown": [
        "scripts/player",
        "scripts/enemies",
        "scripts/npc",
        "scripts/inventory",
    ],
    "fps": [
        "scripts/player",
        "scripts/weapons",
        "scripts/enemies",
    ],
    "puzzle": [
        "scripts/puzzle",
        "scripts/levels",
    ],
}

AUTOLOAD_STUBS = {
    "events.gd": 'extends Node\n\n# Global signal bus — add game-specific signals here\nsignal player_died\nsignal score_changed(score: int)\nsignal level_completed(level: String)\n',
    "scene_manager.gd": '# See gdscript-patterns/patterns/scene_manager.gd for full implementation\nextends Node\n\nfunc change_scene(path: String) -> void:\n\tget_tree().change_scene_to_file(path)\n',
    "audio_manager.gd": '# See gdscript-patterns/patterns/audio_manager.gd for full implementation\nextends Node\n',
    "save_manager.gd": '# See gdscript-patterns/patterns/save_load.gd for full implementation\nextends Node\n',
    "game_manager.gd": 'extends Node\n\nvar score: int = 0\nvar current_level: int = 1\nvar is_game_over: bool = false\n\n\nfunc reset() -> void:\n\tscore = 0\n\tcurrent_level = 1\n\tis_game_over = false\n',
}

COMPONENT_STUBS = {
    "health_component.gd": '# See gdscript-patterns/patterns/health_component.gd for full implementation\nextends Node\nclass_name HealthComponent\n\nsignal health_changed(current: float, maximum: float)\nsignal died\n\n@export var max_health: float = 100.0\nvar current_health: float\n\nfunc _ready() -> void:\n\tcurrent_health = max_health\n\nfunc take_damage(amount: float) -> void:\n\tcurrent_health = max(current_health - amount, 0)\n\thealth_changed.emit(current_health, max_health)\n\tif current_health <= 0:\n\t\tdied.emit()\n\nfunc heal(amount: float) -> void:\n\tcurrent_health = min(current_health + amount, max_health)\n\thealth_changed.emit(current_health, max_health)\n',
}


def create_project(project_path, game_type, game_name):
    """Create the full project scaffold."""

    if not os.path.exists(project_path):
        print(f"Error: Project path '{project_path}' does not exist.")
        sys.exit(1)

    # Create common directories
    all_dirs = COMMON_DIRS + GAME_TYPE_DIRS.get(game_type, [])
    for d in all_dirs:
        full_path = os.path.join(project_path, d)
        os.makedirs(full_path, exist_ok=True)
        print(f"  📁 {d}")

    # Create autoload stubs
    autoload_dir = os.path.join(project_path, "scripts", "autoloads")
    for filename, content in AUTOLOAD_STUBS.items():
        filepath = os.path.join(autoload_dir, filename)
        if not os.path.exists(filepath):
            with open(filepath, 'w') as f:
                f.write(content)
            print(f"  📄 scripts/autoloads/{filename}")

    # Create component stubs
    comp_dir = os.path.join(project_path, "scripts", "components")
    for filename, content in COMPONENT_STUBS.items():
        filepath = os.path.join(comp_dir, filename)
        if not os.path.exists(filepath):
            with open(filepath, 'w') as f:
                f.write(content)
            print(f"  📄 scripts/components/{filename}")

    # Create .gdignore in assets subdirs to prevent Godot from importing everything
    # Actually, we WANT Godot to import assets. Skip this.

    print(f"\n✅ Project '{game_name}' scaffolded as '{game_type}' in {project_path}")
    print(f"\nNext steps:")
    print(f"  1. Set up input actions (use godot-input-manager skill)")
    print(f"  2. Create main scenes (use godot-scene-builder skill)")
    print(f"  3. Write game scripts (use gdscript-patterns skill)")
    print(f"  4. Configure autoloads in project.godot")


def main():
    parser = argparse.ArgumentParser(description='Scaffold a Godot project')
    parser.add_argument('--project', required=True, help='Path to the Godot project directory')
    parser.add_argument('--type', required=True, choices=['platformer', 'topdown', 'fps', 'puzzle'],
                       help='Game type')
    parser.add_argument('--name', default='My Game', help='Game name')
    args = parser.parse_args()

    print(f"🎮 Scaffolding '{args.name}' ({args.type})...\n")
    create_project(args.project, args.type, args.name)


if __name__ == "__main__":
    main()

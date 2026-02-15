#!/usr/bin/env python3
"""Set up standard collision layer names in project.godot."""

import argparse
import os
import sys

LAYER_NAMES_2D = {
    "2d_physics/layer_1": "World",
    "2d_physics/layer_2": "Player",
    "2d_physics/layer_3": "Enemies",
    "2d_physics/layer_4": "Projectiles",
    "2d_physics/layer_5": "Hitboxes",
    "2d_physics/layer_6": "Hurtboxes",
    "2d_physics/layer_7": "Interactables",
    "2d_physics/layer_8": "Collectibles",
    "2d_physics/layer_9": "Triggers",
    "2d_physics/layer_10": "Hazards",
}

LAYER_NAMES_3D = {
    "3d_physics/layer_1": "World",
    "3d_physics/layer_2": "Player",
    "3d_physics/layer_3": "Enemies",
    "3d_physics/layer_4": "Projectiles",
    "3d_physics/layer_5": "Hitboxes",
    "3d_physics/layer_6": "Hurtboxes",
    "3d_physics/layer_7": "Interactables",
    "3d_physics/layer_8": "Items",
    "3d_physics/layer_9": "Triggers",
    "3d_physics/layer_10": "Vehicles",
}


def setup_layers(project_path, game_type):
    with open(project_path, 'r') as f:
        content = f.read()

    layers = LAYER_NAMES_2D if game_type == "2d" else LAYER_NAMES_3D

    # Check if [layer_names] section exists
    if "[layer_names]" not in content:
        content = content.rstrip() + "\n\n[layer_names]\n\n"

    # Find insertion point (after [layer_names])
    idx = content.index("[layer_names]")
    newline = content.index("\n", idx)
    insert_pos = newline + 1

    # Build the layer names block
    lines = []
    for key, name in layers.items():
        line = f'{key}="{name}"'
        if line not in content:
            lines.append(line)

    if lines:
        block = "\n".join(lines) + "\n"
        content = content[:insert_pos] + "\n" + block + content[insert_pos:]

        with open(project_path, 'w') as f:
            f.write(content)
        print(f"Added {len(lines)} layer names to {project_path}")
    else:
        print("All layer names already present.")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--project', required=True)
    parser.add_argument('--type', required=True, choices=['2d', '3d'])
    args = parser.parse_args()

    if not os.path.exists(args.project):
        print(f"Error: {args.project} not found.")
        sys.exit(1)

    setup_layers(args.project, args.type)


if __name__ == "__main__":
    main()

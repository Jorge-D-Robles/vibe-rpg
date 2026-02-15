---
name: gdscript-patterns
description: A reference library of production-ready GDScript patterns for Godot 4. Use this skill to look up correct implementations for player controllers, state machines, singletons, UI systems, enemy AI, and more. This is the agent's "cookbook" for writing correct Godot code.
---

# GDScript Patterns Library

This skill is a **reference-only** library. It contains battle-tested GDScript patterns the agent should use when generating code. Before writing any GDScript, consult the relevant pattern file.

## Available Patterns

### Core Game Mechanics
- `patterns/player_2d_platformer.gd` — CharacterBody2D platformer controller with gravity, jump, coyote time
- `patterns/player_2d_topdown.gd` — CharacterBody2D top-down 8-directional movement
- `patterns/player_3d_fps.gd` — CharacterBody3D first-person controller with mouse look
- `patterns/camera_follow.gd` — Smooth camera that follows a target
- `patterns/state_machine.gd` — Generic finite state machine
- `patterns/health_component.gd` — Reusable health/damage component

### Systems
- `patterns/scene_manager.gd` — Autoload for scene transitions with fade
- `patterns/audio_manager.gd` — Autoload for playing SFX and music
- `patterns/save_load.gd` — Save/load system using JSON
- `patterns/signal_bus.gd` — Global signal bus (event bus pattern)

### UI
- `patterns/main_menu.gd` — Main menu with Play/Settings/Quit
- `patterns/pause_menu.gd` — In-game pause menu
- `patterns/hud.gd` — Basic HUD with health bar, score, etc.
- `patterns/dialog_system.gd` — Simple dialog/text box system

### AI & Enemies
- `patterns/enemy_basic.gd` — Basic enemy with patrol and chase
- `patterns/spawner.gd` — Enemy wave spawner

### Utility
- `patterns/hitbox_hurtbox.gd` — Hitbox/hurtbox system for combat
- `patterns/interactable.gd` — Interactable object pattern (press E to interact)
- `patterns/collectible.gd` — Pickup/collectible item

## How to Use

1. Identify what kind of code is needed.
2. Read the relevant pattern file: `view_file .gemini/skills/gdscript-patterns/patterns/<pattern>.gd`
3. Adapt the pattern to the specific game requirements.
4. Never copy blindly — always adjust node paths, signal names, and game-specific logic.

## Godot 4 GDScript Style Guide

- Use `@export` for inspector-visible variables.
- Use `@onready` for node references.
- Use `snake_case` for variables and functions.
- Use `PascalCase` for classes and nodes.
- Use type hints everywhere: `var speed: float = 200.0`
- Prefer `move_and_slide()` over manual position changes for physics bodies.
- Use `StringName` or `&"name"` for signal names and input actions when possible.
- Always call `super()` in overridden `_ready()`, `_process()`, etc. if extending a custom class.
- Use `class_name` to register scripts as types.

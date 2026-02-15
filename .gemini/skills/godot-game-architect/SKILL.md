---
name: godot-game-architect
description: Plan the complete file and scene structure for a new Godot game. Use this skill FIRST when starting a new game to define the project layout, scene hierarchy, autoloads, and folder organization before writing any code.
---

# Godot Game Architect Skill

This is the **planning skill** — use it as the FIRST step when creating a new game. It defines the project structure, scene breakdown, and file organization.

## Workflow

1. **Determine Game Type:** What kind of game? (platformer, top-down RPG, FPS, puzzle, etc.)
2. **Choose Template:** Load the appropriate template from `templates/`.
3. **Customize:** Adjust the template to fit the specific game requirements.
4. **Create Structure:** Use the output to create all folders and placeholder files.

## Project Structure Template

Every Godot game should follow this standard layout:

```
project.godot
default_bus_layout.tres

scenes/
  main_menu.tscn
  game.tscn
  game_over.tscn

scripts/
  autoloads/
    scene_manager.gd
    audio_manager.gd
    events.gd
    save_manager.gd
    game_manager.gd
  player/
    player.gd
    player_states/
  enemies/
    enemy_base.gd
  ui/
    hud.gd
    main_menu.gd
    pause_menu.gd
  components/
    health_component.gd
    hitbox.gd
    hurtbox.gd

assets/
  sprites/
  audio/
    sfx/
    music/
  fonts/
  shaders/

themes/
  main_theme.tres

levels/
  level_1.tscn
  level_2.tscn
```

## Autoload (Singleton) Setup

Every game should have these autoloads configured in `project.godot`:

| Name | Script | Purpose |
|------|--------|---------|
| `Events` | `res://scripts/autoloads/events.gd` | Global signal bus |
| `SceneManager` | `res://scripts/autoloads/scene_manager.gd` | Scene transitions with fade |
| `AudioManager` | `res://scripts/autoloads/audio_manager.gd` | SFX and music playback |
| `SaveManager` | `res://scripts/autoloads/save_manager.gd` | Save/load system |
| `GameManager` | `res://scripts/autoloads/game_manager.gd` | Game state (score, lives, level) |

## Game Type Templates

### Platformer
```
Required scenes: main_menu, game_world, levels
Key systems: player_controller, camera_follow, enemies, collectibles
Physics: 2D, gravity-based
Input preset: platformer
Node types: CharacterBody2D (player), StaticBody2D (platforms), Area2D (collectibles, hazards)
```

### Top-Down RPG
```
Required scenes: main_menu, overworld, battle, dialog, inventory
Key systems: player_topdown, npc_dialog, inventory, save_load
Physics: 2D, no gravity
Input preset: topdown
Node types: CharacterBody2D (player/NPCs), Area2D (triggers), TileMapLayer (world)
```

### FPS
```
Required scenes: main_menu, level, game_over
Key systems: fps_controller, weapon_system, enemy_ai, health
Physics: 3D, ray-based shooting
Input preset: fps
Node types: CharacterBody3D (player), MeshInstance3D (world), RayCast3D (shooting)
```

### Puzzle
```
Required scenes: main_menu, level_select, level, level_complete
Key systems: grid_system, level_loader, score, undo
Physics: minimal
Input preset: menu (click-based)
Node types: Control (UI), Sprite2D (pieces), Area2D (slots)
```

## Scaffold Script

To create the full folder structure:

```bash
python3 .gemini/skills/godot-game-architect/scripts/scaffold.py \
  --project godot-gemini-plugin \
  --type platformer \
  --name "My Awesome Game"
```

## Scene Graph Planning

Before building scenes, plan the node hierarchy on paper/text:

```
World (Node2D)
├── TileMapLayer (ground, platforms)
├── Player (CharacterBody2D)
│   ├── Sprite2D
│   ├── CollisionShape2D
│   ├── AnimationPlayer
│   ├── Camera2D
│   ├── HealthComponent (Node)
│   └── Hurtbox (Area2D)
│       └── CollisionShape2D
├── Enemies (Node2D)
│   └── Slime (CharacterBody2D) [instanced]
├── Collectibles (Node2D)
│   └── Coin (Area2D) [instanced]
├── HUD (CanvasLayer)
│   └── HUDControl (Control)
└── PauseLayer (CanvasLayer)
    └── PauseMenu (Control)
```

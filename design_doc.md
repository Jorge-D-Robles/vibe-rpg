# Design Document: Godot Game Development Agent System

## 1. Objective

Create a **nearly autonomous** system of specialized agents capable of generating complete Godot games from scratch — including project scaffolding, scene construction, GDScript code, visual effects, audio, physics, UI, and export — by leveraging a comprehensive skill suite and RAG-powered documentation retrieval.

## 2. Architecture Overview

The system has three pillars:
- **16 Programming Skills**: A modular library of `gemini` CLI skills covering every aspect of Godot game development.
- **RAG System**: A documentation-aware sub-agent for retrieving Godot 4 API information from `godot-docs`.
- **Editor Integration**: A Godot 4.3 plugin (`godot-gemini-plugin/`) with an in-editor chat interface.
- **Multi-Agent Orchestration**: The system supports spawning parallel headless sub-agents via the CLI (`gemini --prompt`) for concurrent task execution (e.g., one agent builds the UI while another writes physics code).

## 3. Operations & Intelligence

### 3.1 Training & Instructions (`gemini.md`)
The system behavior is governed by `gemini.md` at the project root. This file contains the 7-step autonomous pipeline and must be internalized by any agent (Master or Sub-agent) before work begins.

### 3.2 External Asset Source
The system is configured to pull sprites from:
- `/Users/robles/Documents/fantasy_sprites`
- **Primary Theme**: Time Fantasy (and its sub-packs).

## 4. Autonomous Game Creation Pipeline

When asked to create a game, the agent follows this pipeline:

```
1. PLAN        → godot-game-architect    (scaffold dirs, plan scene graph)
2. CONFIGURE   → godot-project-manager   (set project settings, display, features)
                  godot-input-manager     (define all input actions)
                  godot-physics-setup     (name collision layers, assign masks)
                  godot-audio-manager     (create audio bus layout)
3. BUILD       → godot-scene-builder     (create .tscn scene files)
                  godot-resource-creator  (create .tres resources: themes, materials, etc.)
                  godot-shader-writer     (write .gdshader visual effects)
                  godot-animation-builder (define AnimationPlayer tracks or Tweens)
4. CODE        → gdscript-patterns       (reference correct patterns for game mechanics)
                  godot-node-reference    (choose the right node types)
                  godot-rag              (look up Godot 4 API when unsure)
5. UI          → godot-ui-builder        (build menus, HUDs, settings screens)
6. VERIFY      → gdscript-linter         (lint all GDScript files)
                  godot-scene-inspector   (verify scene tree & resource references)
7. EXPORT      → godot-export-manager    (configure build presets, export)
```

## 4. Skill Inventory (16 Skills)

### 4.1 Planning & Architecture

| Skill | Description | Key Files |
|---|---|---|
| `godot-game-architect` | Scaffold full project structure from a game type template (platformer, topdown, FPS, puzzle). Creates all directories and autoload stubs. | `scripts/scaffold.py` |
| `godot-node-reference` | Decision-tree reference for choosing the right Godot 4 nodes (2D, 3D, UI, grouping). | `SKILL.md` (reference only) |

### 4.2 Project Configuration

| Skill | Description | Key Files |
|---|---|---|
| `godot-project-manager` | Read/write `project.godot` settings programmatically. | `scripts/manage_project.py` |
| `godot-input-manager` | Define input actions with keyboard, mouse, and gamepad bindings. Includes presets (platformer, topdown, FPS, menu). | `scripts/manage_inputs.py` |
| `godot-physics-setup` | Configure and name collision layers/masks using a standard convention. | `scripts/setup_layers.py` |
| `godot-audio-manager` | Set up audio bus layouts (Master/SFX/Music/UI) and audio playback patterns. | `SKILL.md` (reference + templates) |

### 4.3 Scene & Resource Construction

| Skill | Description | Key Files |
|---|---|---|
| `godot-scene-builder` | Generate valid `.tscn` files from CLI or by direct text construction. Full format reference with 2D, 3D, and UI examples. | `scripts/build_scene.py` |
| `godot-scene-inspector` | Parse existing `.tscn` files and output node trees with scripts and resources. | `scripts/inspect_scene.py` |
| `godot-resource-creator` | Create `.tres` files: Themes, Environments, StyleBoxFlat, ShaderMaterial, PhysicsMaterial, AudioBusLayout. | `SKILL.md` (templates) |
| `godot-animation-builder` | AnimationPlayer track format reference + Tween code patterns for procedural effects. | `SKILL.md` (reference) |

### 4.4 Code Generation

| Skill | Description | Key Files |
|---|---|---|
| `gdscript-patterns` | **19 production-ready GDScript patterns** covering the full game development lifecycle. | `patterns/*.gd` |
| `godot-rag` | Search official Godot 4 documentation (`.rst` files from `godot-docs`). | `scripts/search_docs.sh` |
| `godot-shader-writer` | Write Godot shaders with 6 ready-made templates (outline, dissolve, water, flash, toon, fresnel). | `templates/*.gdshader` |

### 4.5 UI & Polish

| Skill | Description | Key Files |
|---|---|---|
| `godot-ui-builder` | Anchor presets, container types, size flags, theme overrides, and responsive layout patterns. | `SKILL.md` (reference) |

### 4.6 Quality & Export

| Skill | Description | Key Files |
|---|---|---|
| `gdscript-linter` | Static analysis using `gdlint` or `godot --check-only`. | `scripts/lint.sh` |
| `godot-export-manager` | Export preset templates for Web, Windows, and macOS. | `SKILL.md` (templates) |

## 5. GDScript Patterns Library (19 Patterns)

| Category | Pattern | File |
|---|---|---|
| **Player** | 2D Platformer (coyote time, jump buffer) | `player_2d_platformer.gd` |
| | 2D Top-Down (8-dir, acceleration) | `player_2d_topdown.gd` |
| | 3D FPS (mouse look, sprint) | `player_3d_fps.gd` |
| **Systems** | Scene Manager (fade transitions) | `scene_manager.gd` |
| | Audio Manager (SFX pool, crossfade) | `audio_manager.gd` |
| | Save/Load (JSON, multi-slot) | `save_load.gd` |
| | Signal Bus (global event bus) | `signal_bus.gd` |
| | State Machine (FSM) | `state_machine.gd` |
| **Components** | Health Component (damage, heal, i-frames) | `health_component.gd` |
| | Hitbox / Hurtbox (combat) | `hitbox_hurtbox.gd` |
| | Camera Follow (smooth, shake) | `camera_follow.gd` |
| **Enemies** | Basic Enemy (patrol, chase, attack) | `enemy_basic.gd` |
| | Wave Spawner | `spawner.gd` |
| **UI** | Main Menu | `main_menu.gd` |
| | Pause Menu (PROCESS_MODE_ALWAYS) | `pause_menu.gd` |
| | HUD (health bar, score, notifications) | `hud.gd` |
| | Dialog System (typewriter effect) | `dialog_system.gd` |
| **Items** | Interactable (press E) | `interactable.gd` |
| | Collectible (bob, pickup effect) | `collectible.gd` |

## 6. Shader Templates (6 Shaders)

| Shader | Type | File |
|---|---|---|
| Sprite Outline | `canvas_item` | `outline_2d.gdshader` |
| Dissolve/Disintegrate | `canvas_item` | `dissolve_2d.gdshader` |
| Water Surface | `canvas_item` | `water_2d.gdshader` |
| Hit Flash (white) | `canvas_item` | `flash_white.gdshader` |
| Toon/Cel Shading | `spatial` | `toon_3d.gdshader` |
| Fresnel Rim Glow | `spatial` | `fresnel_glow.gdshader` |

## 7. Implementation Status

### Phase 1: Foundation ✅
- [x] RAG sub-agent with documentation search
- [x] Basic project/scene manipulation scripts
- [x] Godot Plugin for editor-agent collaboration

### Phase 2: Autonomous Development ✅
- [x] 16 comprehensive skills covering the full game dev lifecycle
- [x] 19 GDScript patterns for common game mechanics
- [x] 6 shader templates for visual effects
- [x] Project scaffolding for 4 game types
- [x] Input presets for platformer, top-down, FPS, and menu

### Phase 3: Advanced Intelligence (Planned)
- [ ] Visual scene analysis (feeding screenshots to Gemini)
- [ ] Real-time debugging via Godot debugger protocol
- [ ] Automated testing suite for generated games
- [ ] Asset generation pipeline (procedural sprites, sounds)
- [ ] Multi-version Godot support (3.x / 4.x)

---
name: godot-node-reference
description: Quick reference for which Godot 4 nodes to use for which purpose. Consult this BEFORE creating scenes or writing code to pick the right node types.
---

# Godot 4 Node Reference

A decision-making guide for choosing the right node types.

## 2D Game Nodes

| Purpose | Node | Notes |
|---------|------|-------|
| Player/NPC (physics) | `CharacterBody2D` | Use `move_and_slide()` |
| Static wall/floor | `StaticBody2D` | Doesn't move |
| Physics object | `RigidBody2D` | Affected by gravity/forces |
| Trigger zone | `Area2D` | Detects overlaps, no physics |
| Sprite | `Sprite2D` | Single texture |
| Animated sprite | `AnimatedSprite2D` | Frame-by-frame animation |
| Tilemap | `TileMapLayer` | Godot 4.3+ (replaces `TileMap`) |
| Camera | `Camera2D` | Follows player |
| Collision shape | `CollisionShape2D` | Required child of physics bodies |
| Light | `PointLight2D` / `DirectionalLight2D` | 2D lighting |
| Particles | `GPUParticles2D` | Effects (fire, dust, etc.) |
| Path following | `Path2D` + `PathFollow2D` | Moving platforms, paths |
| Line drawing | `Line2D` | Trails, lasers |
| Navigation | `NavigationRegion2D` + `NavigationAgent2D` | AI pathfinding |
| Audio | `AudioStreamPlayer2D` | Positional audio |
| Parallax background | `ParallaxBackground` + `ParallaxLayer` | Scrolling backgrounds |
| Ray | `RayCast2D` | Line-of-sight, ground detection |

## 3D Game Nodes

| Purpose | Node | Notes |
|---------|------|-------|
| Player/NPC (physics) | `CharacterBody3D` | Use `move_and_slide()` |
| Static geometry | `StaticBody3D` | Walls, floor |
| Physics object | `RigidBody3D` | Thrown objects, debris |
| Trigger zone | `Area3D` | Detection volumes |
| Mesh | `MeshInstance3D` | Visual geometry |
| Camera | `Camera3D` | Player view |
| Collision | `CollisionShape3D` | Required for physics bodies |
| Light | `DirectionalLight3D` / `OmniLight3D` / `SpotLight3D` | Lighting |
| Particles | `GPUParticles3D` | 3D effects |
| Navigation | `NavigationRegion3D` + `NavigationAgent3D` | AI pathfinding |
| Audio | `AudioStreamPlayer3D` | 3D positional audio |
| Environment | `WorldEnvironment` | Sky, fog, tonemap, glow |
| CSG shapes | `CSGBox3D`, `CSGSphere3D`, etc. | Quick prototyping |
| Skeleton | `Skeleton3D` + `BoneAttachment3D` | Character rigging |
| Animation | `AnimationPlayer` / `AnimationTree` | Skeletal/property animation |
| Vehicle | `VehicleBody3D` + `VehicleWheel3D` | Cars |
| Ray | `RayCast3D` | Shooting, ground detection |

## UI Nodes

| Purpose | Node | Notes |
|---------|------|-------|
| Root container | `Control` | Base for all UI |
| Text | `Label` / `RichTextLabel` | Display text |
| Button | `Button` | Clickable |
| Input field | `LineEdit` / `TextEdit` | Text input |
| Checkbox | `CheckBox` / `CheckButton` | Toggle |
| Slider | `HSlider` / `VSlider` | Range input |
| Progress bar | `ProgressBar` / `TextureProgressBar` | Health bars |
| Dropdown | `OptionButton` | Selection list |
| Tab container | `TabContainer` | Tabs |
| Vertical layout | `VBoxContainer` | Stack children vertically |
| Horizontal layout | `HBoxContainer` | Stack children horizontally |
| Grid layout | `GridContainer` | Grid of children |
| Scroll | `ScrollContainer` | Scrollable area |
| Margin | `MarginContainer` | Adds padding |
| Panel | `PanelContainer` | Styled background |
| Color picker | `ColorPickerButton` | Color selection |
| Popup | `Popup` / `PopupMenu` | Floating panels |
| Tree/list | `Tree` / `ItemList` | Data lists |
| Canvas layer | `CanvasLayer` | Render above/below game (UI overlay) |

## Grouping / Organization

| Purpose | Node | Notes |
|---------|------|-------|
| Empty parent (2D) | `Node2D` | Groups 2D children |
| Empty parent (3D) | `Node3D` | Groups 3D children |
| Empty parent (logic) | `Node` | Scripts only, no transform |
| Position marker | `Marker2D` / `Marker3D` | Spawn points, positions |
| Timer | `Timer` | Delayed/repeated actions |

## Decision Tree

```
Need physics?
  ├─ Player/NPC → CharacterBody2D/3D
  ├─ Wall/Floor → StaticBody2D/3D
  ├─ Thrown object → RigidBody2D/3D
  └─ Trigger only → Area2D/3D

Need visuals?
  ├─ 2D → Sprite2D / AnimatedSprite2D
  ├─ 3D → MeshInstance3D
  └─ Particles → GPUParticles2D/3D

Need UI?
  └─ Start with Control, use containers for layout

Need audio?
  ├─ Positional → AudioStreamPlayer2D/3D
  └─ Global (music) → AudioStreamPlayer
```

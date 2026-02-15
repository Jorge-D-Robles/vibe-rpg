---
name: godot-physics-setup
description: Configure collision layers, physics materials, and collision masks for Godot 4. Use this when setting up which objects can collide with which.
---

# Godot Physics Setup Skill

Manages collision layer/mask assignments and provides a standardized collision layer naming convention.

## Standard Collision Layer Convention

Godot has 32 collision layers. Adopt this convention for consistency:

### 2D Games
| Layer | Name | Used By |
|-------|------|---------|
| 1 | World | Ground, walls, platforms, static geometry |
| 2 | Player | Player CharacterBody2D |
| 3 | Enemies | Enemy CharacterBody2D |
| 4 | Projectiles | Bullets, arrows, thrown objects |
| 5 | Hitboxes | Attack hitboxes (Area2D) |
| 6 | Hurtboxes | Damage receivers (Area2D) |
| 7 | Interactables | Chests, doors, NPCs (Area2D) |
| 8 | Collectibles | Coins, pickups (Area2D) |
| 9 | Triggers | Invisible trigger zones |
| 10 | Hazards | Spikes, lava, etc. |

### 3D Games
| Layer | Name | Used By |
|-------|------|---------|
| 1 | World | Static geometry |
| 2 | Player | Player body |
| 3 | Enemies | Enemy bodies |
| 4 | Projectiles | Bullets |
| 5 | Hitboxes | Melee/attack areas |
| 6 | Hurtboxes | Damage receivers |
| 7 | Interactables | Doors, items |
| 8 | Items | Pickups |
| 9 | Triggers | Volume triggers |
| 10 | Vehicles | Cars, ships |

## Layer/Mask Logic

- **Layer** = "I AM on this layer" (what this object is)
- **Mask** = "I DETECT objects on these layers" (what this object collides with)

### Common Configurations

| Object | Layer | Mask | Explanation |
|--------|-------|------|-------------|
| Player | 2 | 1, 3, 10 | Is player, collides with world, enemies, hazards |
| Enemy | 3 | 1, 2 | Is enemy, collides with world and player |
| Player bullet | 4 | 1, 3 | Is projectile, hits world and enemies |
| Enemy bullet | 4 | 1, 2 | Is projectile, hits world and player |
| Coin | 8 | - | Is collectible, detected by player's Area2D |
| Player pickup zone | - | 8 | Detects collectibles |
| Hitbox (player attack) | 5 | - | Is a hitbox |
| Hurtbox (enemy) | 6 | 5 | Is a hurtbox, detects hitboxes |

## Setting Layers in project.godot

Layer names can be defined in project settings:

```ini
[layer_names]

2d_physics/layer_1="World"
2d_physics/layer_2="Player"
2d_physics/layer_3="Enemies"
2d_physics/layer_4="Projectiles"
2d_physics/layer_5="Hitboxes"
2d_physics/layer_6="Hurtboxes"
2d_physics/layer_7="Interactables"
2d_physics/layer_8="Collectibles"
2d_physics/layer_9="Triggers"
2d_physics/layer_10="Hazards"
```

## Setting in .tscn Files

In scene files, layers/masks are set as bitmasks:

```
collision_layer = 2    # Layer 2 only (binary: 10)
collision_mask = 5     # Layers 1 and 3 (binary: 101)
```

Bitmask calculation: Layer N = 2^(N-1)
- Layer 1 = 1
- Layer 2 = 2
- Layer 3 = 4
- Layers 1+3 = 1+4 = 5
- Layers 1+2+3 = 1+2+4 = 7

## Tool Usage

```bash
python3 .gemini/skills/godot-physics-setup/scripts/setup_layers.py \
  --project godot-gemini-plugin/project.godot \
  --type 2d
```

This writes the standard layer names into `project.godot`.

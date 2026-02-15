---
name: godot-animation-builder
description: Create Godot animation resources programmatically. Build AnimationPlayer tracks for sprite animations, property animations, and tweens — all without the Godot editor.
---

# Godot Animation Builder Skill

Creates `.tres` animation resources and generates AnimationPlayer configuration in `.tscn` files.

## Animation in Godot 4

There are two animation systems:
1. **AnimationPlayer** — timeline-based, node property keyframes
2. **Tweens** — code-based, dynamic, great for procedural effects

### When to Use What

| Use Case | System |
|----------|--------|
| Sprite frame animations (idle, run, jump) | AnimatedSprite2D or AnimationPlayer |
| Complex cutscenes / sequences | AnimationPlayer |
| Simple property transitions (fade, scale) | Tween (in code) |
| UI animations (buttons, panels) | Tween (in code) |
| Looping ambient effects | AnimationPlayer |
| One-shot reactions (hit flash, bounce) | Tween (in code) |

## AnimationPlayer in .tscn Format

Inside a `.tscn` file, animations are defined as sub-resources:

```
[sub_resource type="Animation" id="anim_idle"]
resource_name = "idle"
length = 0.8
loop_mode = 1
step = 0.1
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Sprite2D:frame")
tracks/0/interp = 1
tracks/0/update = 1
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.2, 0.4, 0.6),
"transitions": PackedFloat32Array(1, 1, 1, 1),
"update": 1,
"values": [0, 1, 2, 3]
}

[sub_resource type="Animation" id="anim_run"]
resource_name = "run"
length = 0.6
loop_mode = 1
step = 0.1
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Sprite2D:frame")
tracks/0/interp = 1
tracks/0/update = 1
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.1, 0.2, 0.3, 0.4, 0.5),
"transitions": PackedFloat32Array(1, 1, 1, 1, 1, 1),
"update": 1,
"values": [4, 5, 6, 7, 8, 9]
}

[sub_resource type="AnimationLibrary" id="anim_lib"]
_data = {
"idle": SubResource("anim_idle"),
"run": SubResource("anim_run"),
}

[node name="AnimationPlayer" type="AnimationPlayer" parent="Player"]
libraries = {
"": SubResource("anim_lib")
}
```

### Track Types

| Type | Value | Use |
|------|-------|-----|
| `value` | Property values | Sprite frame, position, color |
| `method` | Method calls | Call functions at specific times |
| `bezier` | Smooth curves | Camera motion, easing |
| `audio` | Audio playback | Sound effects synced to animation |

### Loop Modes

| Mode | Value | Description |
|------|-------|-------------|
| None | 0 | Play once |
| Linear | 1 | Loop |
| Ping-pong | 2 | Loop back and forth |

### Update Modes (for value tracks)

| Mode | Value | Description |
|------|-------|-------------|
| Continuous | 0 | Interpolate between keyframes |
| Discrete | 1 | Snap to keyframe values (use for sprite frames) |
| Capture | 2 | Capture initial value, interpolate to first keyframe |

## Tween Patterns (Code)

### Fade In
```gdscript
var tween = create_tween()
modulate.a = 0.0
tween.tween_property(self, "modulate:a", 1.0, 0.5)
```

### Bounce on Collect
```gdscript
var tween = create_tween()
tween.tween_property(self, "scale", Vector2(1.3, 0.7), 0.1)
tween.tween_property(self, "scale", Vector2(0.8, 1.2), 0.1)
tween.tween_property(self, "scale", Vector2.ONE, 0.15)
```

### Slide In from Side
```gdscript
var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
position.x = -200
tween.tween_property(self, "position:x", target_x, 0.4)
```

### Shake
```gdscript
var tween = create_tween()
for i in 6:
    tween.tween_property(self, "position", original_pos + Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.04)
tween.tween_property(self, "position", original_pos, 0.04)
```

### Parallel + Sequential
```gdscript
var tween = create_tween().set_parallel(true)
tween.tween_property(self, "position:y", target_y, 0.3)
tween.tween_property(self, "modulate:a", 0.0, 0.3)
tween.chain().tween_callback(queue_free)  # After both complete
```

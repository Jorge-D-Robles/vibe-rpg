---
name: godot-scene-builder
description: Programmatically create and modify Godot scene (.tscn) files from scratch. Use this skill when you need to build scene trees, add nodes, attach scripts, or wire up resources — all without the Godot editor.
---

# Godot Scene Builder Skill

This is the **most critical skill** for autonomous game creation. It allows the agent to generate valid `.tscn` files that Godot can open and run.

## Godot 4 `.tscn` Format Reference

A `.tscn` file is a text-based scene format. The structure is:

```
[gd_scene load_steps=<N> format=3 uid="uid://..."]

[ext_resource type="<Type>" path="<res://path>" id="<unique_id>"]
...

[sub_resource type="<Type>" id="<unique_id>"]
<property>=<value>
...

[node name="<Name>" type="<NodeType>"]
<property>=<value>

[node name="<Child>" type="<NodeType>" parent="."]
<property>=<value>

[node name="<GrandChild>" type="<NodeType>" parent="Child"]
<property>=<value>

[connection signal="<signal_name>" from="<NodePath>" to="<NodePath>" method="<method_name>"]
```

### Key Rules

1. **`load_steps`** = total number of `ext_resource` + `sub_resource` sections + 1.
2. **`format=3`** for Godot 4.x.
3. **Root node** has NO `parent` attribute.
4. **Direct children of root** have `parent="."`.
5. **Deeper children** use the node path relative to root: `parent="Player"`, `parent="Player/Sprite2D"`.
6. **`ext_resource`** references external files (.gd, .png, .tres, etc.).
7. **`sub_resource`** defines inline resources (shapes, materials, etc.).
8. **IDs** are strings like `"1_abc"`, `"2_xyz"` — they must be unique within the file.
9. **`[connection]`** sections go at the END of the file, after all nodes.

## Tool Usage

### Creating a new scene

```bash
python3 .gemini/skills/godot-scene-builder/scripts/build_scene.py \
  --output "res://scenes/main.tscn" \
  --root "Main:Node2D" \
  --nodes "Player:CharacterBody2D:." "Sprite:Sprite2D:Player" "CollisionShape:CollisionShape2D:Player" \
  --scripts "Player=res://scripts/player.gd" \
  --connections "Player:body_entered:Main:_on_player_body_entered"
```

### Manual Construction (Preferred for Complex Scenes)

For complex scenes, it is better to write the `.tscn` content directly. Use this reference:

#### 2D Platformer Scene Example
```
[gd_scene load_steps=4 format=3]

[ext_resource type="Script" path="res://scripts/player.gd" id="1_player_script"]
[ext_resource type="Texture2D" path="res://assets/player.png" id="2_player_tex"]

[sub_resource type="RectangleShape2D" id="sub_1"]
size = Vector2(32, 64)

[node name="World" type="Node2D"]

[node name="Player" type="CharacterBody2D" parent="."]
script = ExtResource("1_player_script")

[node name="Sprite2D" type="Sprite2D" parent="Player"]
texture = ExtResource("2_player_tex")

[node name="CollisionShape2D" type="CollisionShape2D" parent="Player"]
shape = SubResource("sub_1")

[node name="Camera2D" type="Camera2D" parent="Player"]
position_smoothing_enabled = true

[connection signal="body_entered" from="Player" to="." method="_on_player_body_entered"]
```

#### 3D Scene Example
```
[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scripts/player_3d.gd" id="1_script"]

[sub_resource type="BoxShape3D" id="sub_1"]
size = Vector3(1, 2, 1)

[node name="World" type="Node3D"]

[node name="Player" type="CharacterBody3D" parent="."]
script = ExtResource("1_script")

[node name="MeshInstance3D" type="MeshInstance3D" parent="Player"]
mesh = BoxMesh.new()

[node name="CollisionShape3D" type="CollisionShape3D" parent="Player"]
shape = SubResource("sub_1")

[node name="Camera3D" type="Camera3D" parent="Player"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.5, 3)

[node name="DirectionalLight3D" type="DirectionalLight3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 0.707, 0.707, 0, -0.707, 0.707, 0, 10, 0)
```

#### UI Scene Example
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/main_menu.gd" id="1_script"]

[node name="MainMenu" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1_script")

[node name="VBoxContainer" type="VBoxContainer" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -100.0
offset_top = -75.0
offset_right = 100.0
offset_bottom = 75.0

[node name="Title" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "My Game"
horizontal_alignment = 1

[node name="PlayButton" type="Button" parent="VBoxContainer"]
layout_mode = 2
text = "Play"

[node name="QuitButton" type="Button" parent="VBoxContainer"]
layout_mode = 2
text = "Quit"

[connection signal="pressed" from="VBoxContainer/PlayButton" to="." method="_on_play_pressed"]
[connection signal="pressed" from="VBoxContainer/QuitButton" to="." method="_on_quit_pressed"]
```

## Common Sub-Resources

| Type | Common Properties |
|---|---|
| `RectangleShape2D` | `size = Vector2(w, h)` |
| `CircleShape2D` | `radius = 16.0` |
| `CapsuleShape2D` | `radius = 16.0`, `height = 64.0` |
| `BoxShape3D` | `size = Vector3(x, y, z)` |
| `CapsuleShape3D` | `radius = 0.5`, `height = 2.0` |
| `SphereShape3D` | `radius = 0.5` |
| `BoxMesh` | `size = Vector3(1, 1, 1)` |
| `SphereMesh` | `radius = 0.5`, `height = 1.0` |
| `PlaneMesh` | `size = Vector2(10, 10)` |
| `StyleBoxFlat` | `bg_color = Color(r, g, b, a)` |
| `GradientTexture2D` | `gradient = ...` |

## Tips

- Always count `load_steps` correctly or Godot may fail to open the scene.
- Use descriptive IDs like `"1_player_script"` for readability.
- Signal connections MUST reference valid node paths and method names.
- The method connected to a signal must exist in the target node's script.
- When creating scenes manually (writing the .tscn text directly), this is often more reliable than using the script for complex hierarchies.

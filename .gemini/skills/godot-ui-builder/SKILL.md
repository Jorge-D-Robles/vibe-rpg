---
name: godot-ui-builder
description: Build Godot UI layouts and themes. Contains references for Control node anchoring, container layout, theme overrides, and responsive design patterns.
---

# Godot UI Builder Skill

Comprehensive reference for building user interfaces in Godot 4.

## UI Architecture

```
CanvasLayer (layer=10, above game)
└── Control (full-screen root)
    ├── MarginContainer (padding)
    │   └── VBoxContainer (vertical stack)
    │       ├── Label (text)
    │       ├── Button (interactive)
    │       └── ...
    └── ...
```

## Anchor Presets

Anchors control how a Control positions/resizes relative to its parent.

| Preset | Value | Description |
|--------|-------|-------------|
| Top Left | 0 | Fixed to top-left |
| Top Right | 1 | Fixed to top-right |
| Bottom Right | 2 | Fixed to bottom-right |
| Bottom Left | 3 | Fixed to bottom-left |
| Center Left | 4 | Centered on left |
| Center Top | 5 | Centered on top |
| Center Right | 6 | Centered on right |
| Center Bottom | 7 | Centered on bottom |
| Center | 8 | Centered |
| Left Wide | 9 | Full height, left side |
| Top Wide | 10 | Full width, top |
| Right Wide | 11 | Full height, right side |
| Bottom Wide | 12 | Full width, bottom |
| VCenter Wide | 13 | Full width, vertically centered |
| HCenter Wide | 14 | Full height, horizontally centered |
| Full Rect | 15 | Fill entire parent |

### In .tscn file:
```
anchors_preset = 15    # Full Rect
anchor_left = 0.0
anchor_top = 0.0
anchor_right = 1.0
anchor_bottom = 1.0
```

## Container Types

| Container | Purpose | Key Properties |
|-----------|---------|----------------|
| `VBoxContainer` | Stack vertically | `separation` |
| `HBoxContainer` | Stack horizontally | `separation` |
| `GridContainer` | N-column grid | `columns` |
| `MarginContainer` | Add padding | Margin overrides |
| `PanelContainer` | Background panel | Theme StyleBox |
| `ScrollContainer` | Scrollable area | |
| `TabContainer` | Tabbed views | |
| `CenterContainer` | Center single child | |
| `AspectRatioContainer` | Maintain aspect ratio | `ratio` |
| `FlowContainer` | Wrap overflow | Like CSS flexbox wrap |

## Common UI Patterns

### Health Bar
```
TextureProgressBar
  ├── under_texture = "health_bar_bg.png"
  ├── progress_texture = "health_bar_fill.png"
  └── value = 100  (0-100)

OR with ProgressBar:
  ├── min_value = 0
  ├── max_value = 100
  └── value = 75
```

### Responsive Layout (adapts to screen size)
```
Control (anchors_preset = 15, Full Rect)
└── MarginContainer (margin 20px all sides)
    └── VBoxContainer
        ├── HBoxContainer (top bar)
        │   ├── Label (title, size_flags_horizontal = SIZE_EXPAND_FILL)
        │   └── Button (settings)
        ├── HSeparator
        └── ScrollContainer (size_flags_vertical = SIZE_EXPAND_FILL)
            └── VBoxContainer (content)
```

### Settings Menu Pattern
```gdscript
extends Control

@onready var volume_slider: HSlider = %VolumeSlider
@onready var fullscreen_check: CheckBox = %FullscreenCheck
@onready var resolution_option: OptionButton = %ResolutionOption

func _ready() -> void:
    # Populate resolution options
    resolution_option.add_item("1920x1080")
    resolution_option.add_item("1280x720")
    resolution_option.add_item("960x540")

    volume_slider.value_changed.connect(_on_volume_changed)
    fullscreen_check.toggled.connect(_on_fullscreen_toggled)
    resolution_option.item_selected.connect(_on_resolution_selected)

func _on_volume_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func _on_fullscreen_toggled(enabled: bool) -> void:
    if enabled:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index: int) -> void:
    var resolutions = [Vector2i(1920, 1080), Vector2i(1280, 720), Vector2i(960, 540)]
    DisplayServer.window_set_size(resolutions[index])
```

## Theme Overrides in .tscn

```
[node name="Title" type="Label" parent="VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 48
theme_override_colors/font_color = Color(1, 0.9, 0.3, 1)
text = "Game Title"
horizontal_alignment = 1
```

## Size Flags

Control how children behave inside containers:

| Flag | Value | Description |
|------|-------|-------------|
| SIZE_SHRINK_BEGIN | 0 | Align to start |
| SIZE_FILL | 1 | Fill available space |
| SIZE_EXPAND | 2 | Request extra space |
| SIZE_EXPAND_FILL | 3 | Expand + Fill |
| SIZE_SHRINK_CENTER | 4 | Center |
| SIZE_SHRINK_END | 8 | Align to end |

In .tscn: `size_flags_horizontal = 3` means EXPAND_FILL.

---
name: godot-shader-writer
description: Write Godot shaders for visual effects. Contains templates for common shader types (2D effects, 3D materials, post-processing, particles) and a Godot Shading Language reference.
---

# Godot Shader Writer Skill

Write shaders in Godot's shading language for visual effects and materials.

## Shader Types

Godot uses `shader_type` to declare shader purpose:
- `canvas_item` — 2D sprites, UI elements
- `spatial` — 3D meshes
- `particles` — GPU particle behavior
- `fog` — Volumetric fog
- `sky` — Sky rendering

## Template Usage

Templates are in `templates/`. Read the relevant one, adapt it, and write to a `.gdshader` file or embed inline in a `.tres` resource.

## Available Templates
- `templates/outline_2d.gdshader` — 2D sprite outline
- `templates/dissolve_2d.gdshader` — Dissolve/disintegrate effect
- `templates/water_2d.gdshader` — Simple 2D water surface
- `templates/flash_white.gdshader` — Hit flash (white overlay)
- `templates/toon_3d.gdshader` — Basic toon/cel shading
- `templates/fresnel_glow.gdshader` — 3D edge glow/rim lighting

## Shading Language Quick Reference

### Variables
```glsl
uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform vec4 color : source_color = vec4(1.0);
uniform sampler2D noise_tex : hint_default_white;
```

### Built-in Variables (canvas_item)
| Variable | Type | Description |
|----------|------|-------------|
| `VERTEX` | vec2 | Vertex position |
| `UV` | vec2 | Texture coordinates |
| `COLOR` | vec4 | Per-vertex color |
| `TEXTURE` | sampler2D | Main texture |
| `TIME` | float | Elapsed time |
| `SCREEN_UV` | vec2 | Screen UV (fragment only) |
| `SCREEN_TEXTURE` | sampler2D | Screen contents |

### Built-in Variables (spatial)
| Variable | Type | Description |
|----------|------|-------------|
| `VERTEX` | vec3 | Vertex position |
| `NORMAL` | vec3 | Normal vector |
| `UV` | vec2 | Texture coordinates |
| `ALBEDO` | vec3 | Base color (fragment) |
| `METALLIC` | float | Metallic (fragment) |
| `ROUGHNESS` | float | Roughness (fragment) |
| `EMISSION` | vec3 | Emission color |
| `ALPHA` | float | Opacity |
| `MODEL_MATRIX` | mat4 | Object transform |
| `VIEW_MATRIX` | mat4 | Camera transform |
| `TIME` | float | Elapsed time |

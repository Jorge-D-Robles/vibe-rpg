---
name: godot-export-manager
description: Configure and manage Godot export presets for building the game to different platforms (Windows, macOS, Linux, Web, Android).
---

# Godot Export Manager Skill

Manages `export_presets.cfg` to configure game builds for distribution.

## Export Presets File

Godot stores export configuration in `export_presets.cfg` at the project root. This file defines which platforms to build for and their settings.

## Creating export_presets.cfg

### Web (HTML5) — Easiest to test and share

```ini
[preset.0]

name="Web"
platform="Web"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="build/web/index.html"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false

[preset.0.options]

custom_template/debug=""
custom_template/release=""
variant/extensions_support=false
vram_texture_compression/for_desktop=true
vram_texture_compression/for_mobile=false
html/export_icon=true
html/custom_html_shell=""
html/head_include=""
html/canvas_resize_policy=2
html/focus_canvas_on_start=true
html/experimental_virtual_keyboard=false
progressive_web_app/enabled=false
```

### Windows Desktop

```ini
[preset.1]

name="Windows"
platform="Windows Desktop"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="build/windows/game.exe"

[preset.1.options]

custom_template/debug=""
custom_template/release=""
binary_format/embed_pck=true
texture_format/bptc=true
texture_format/s3tc=true
texture_format/etc=false
texture_format/etc2=false
codesign/enable=false
application/modify_resources=true
application/icon=""
application/console_wrapper=true
```

### macOS

```ini
[preset.2]

name="macOS"
platform="macOS"
runnable=true
export_path="build/macos/game.dmg"

[preset.2.options]

custom_template/debug=""
custom_template/release=""
binary_format/architecture="universal"
application/short_version="1.0"
application/version="1.0"
application/icon=""
codesign/codesign=1
notarization/notarization=0
```

## Build Commands

Export from the command line (requires Godot in PATH):

```bash
# Export for web
godot --headless --export-release "Web" build/web/index.html

# Export for Windows
godot --headless --export-release "Windows" build/windows/game.exe

# Export debug build (faster, for testing)
godot --headless --export-debug "Web" build/web/index.html
```

## Tips

- **Web export** is the easiest way to share a game — just upload the files to any web server or itch.io.
- Export templates must be installed in Godot first (Editor → Manage Export Templates).
- For CI/CD, use the official [Godot Docker images](https://hub.docker.com/r/barichello/godot-ci/).
- The `export_path` should be relative to the project root.
- Create a `build/` directory and add it to `.gitignore`.

---
name: godot-audio-manager
description: Set up audio bus layouts and manage audio resources for a Godot game. Covers bus configuration, audio import settings, and the audio manager autoload.
---

# Godot Audio Manager Skill

Sets up the audio infrastructure for a Godot game.

## Audio Bus Layout

Godot uses an audio bus system (like a mixing board). The default file is `res://default_bus_layout.tres`.

### Standard Bus Setup

```
Master (always exists)
├── SFX (sound effects)
├── Music (background music)
└── UI (menu clicks, notifications)
```

### Creating the Bus Layout File

Save as `default_bus_layout.tres` in project root:

```
[gd_resource type="AudioBusLayout" format=3]

[resource]
bus/1/name = &"SFX"
bus/1/solo = false
bus/1/mute = false
bus/1/bypass_fx = false
bus/1/volume_db = 0.0
bus/1/send = &"Master"
bus/2/name = &"Music"
bus/2/solo = false
bus/2/mute = false
bus/2/bypass_fx = false
bus/2/volume_db = -3.0
bus/2/send = &"Master"
bus/3/name = &"UI"
bus/3/solo = false
bus/3/mute = false
bus/3/bypass_fx = false
bus/3/volume_db = 0.0
bus/3/send = &"Master"
```

### Configuring in project.godot

Add to `[audio]` section:

```ini
[audio]
buses/default_bus_layout="res://default_bus_layout.tres"
```

## Audio File Guidelines

| Format | Use For | Notes |
|--------|---------|-------|
| `.ogg` | Music | Good compression, streaming |
| `.wav` | SFX | Low latency, no decompression |
| `.mp3` | Music (alt) | Good compression |

### Import Settings (in `.import` files)

- **SFX**: `loop=false`
- **Music**: `loop=true`, `loop_offset=0.0`
- Short SFX (<5 seconds): Keep in memory
- Long music: Stream from disk

## Playing Audio in Code

### Simple (AudioStreamPlayer node)
```gdscript
@onready var jump_sfx: AudioStreamPlayer = $JumpSFX
jump_sfx.play()
```

### Using AudioManager Autoload
```gdscript
# Preload and play
var jump_sound = preload("res://assets/audio/sfx/jump.wav")
AudioManager.play_sfx(jump_sound)

# With random pitch for variety
AudioManager.play_sfx_random_pitch(jump_sound, 0.9, 1.1)

# Play music with crossfade
var bgm = preload("res://assets/audio/music/level1.ogg")
AudioManager.play_music(bgm, 1.5)
```

### Volume Settings Menu
```gdscript
# Get current volume
var sfx_vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

# Set volume (in dB, range: -80 to 0)
AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -10.0)

# Mute a bus
AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)

# Convert linear slider (0-1) to dB
func linear_to_db(value: float) -> float:
    if value <= 0:
        return -80.0
    return 20.0 * log(value) / log(10.0)
```

## Full Implementation

See `gdscript-patterns/patterns/audio_manager.gd` for the complete autoload script with:
- SFX pooling (prevents audio cutoffs)
- Music cross-fading
- Positional 2D audio
- Random pitch variations
- Bus volume control

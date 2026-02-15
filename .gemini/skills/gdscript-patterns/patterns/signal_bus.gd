## Global Signal Bus (Event Bus Pattern)
## Add this as an autoload named "Events".
## Decouples game systems by providing a central place for signals.

extends Node

# Player signals
signal player_died
signal player_respawned
signal player_health_changed(current: float, maximum: float)

# Score / Progression
signal score_changed(new_score: int)
signal level_completed(level_name: String)
signal checkpoint_reached(checkpoint_id: String)

# Enemy signals
signal enemy_killed(enemy_type: String, position: Vector2)
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)

# Items / Inventory
signal item_collected(item_name: String, quantity: int)
signal item_used(item_name: String)
signal currency_changed(new_amount: int)

# UI signals
signal dialog_started(dialog_id: String)
signal dialog_ended(dialog_id: String)
signal notification_requested(message: String, duration: float)

# Game state
signal game_paused
signal game_resumed
signal game_over
signal game_started


# ============ Usage Examples ============
# Emitting (from enemy death script):
#   Events.enemy_killed.emit("slime", global_position)
#
# Connecting (from HUD script):
#   func _ready():
#       Events.score_changed.connect(_on_score_changed)
#       Events.player_health_changed.connect(_on_health_changed)
#
# Adding custom signals:
#   Just add more `signal` declarations above for your specific game needs.
#   This pattern means no node needs to know about any other node;
#   they all just talk through Events.

## Health Component
## Attach to any Node2D/Node3D. Used by players, enemies, destructibles.
## Connect signals to react to damage, healing, and death.

extends Node
class_name HealthComponent

signal health_changed(new_health: float, max_health: float)
signal died
signal damage_taken(amount: float)
signal healed(amount: float)

@export var max_health: float = 100.0
@export var invincibility_time: float = 0.0  # Set > 0 for i-frames

var current_health: float
var is_invincible: bool = false
var _invincibility_timer: float = 0.0


func _ready() -> void:
	current_health = max_health


func _process(delta: float) -> void:
	if is_invincible:
		_invincibility_timer -= delta
		if _invincibility_timer <= 0.0:
			is_invincible = false


func take_damage(amount: float) -> void:
	if is_invincible:
		return
	if current_health <= 0:
		return

	current_health = max(current_health - amount, 0.0)
	damage_taken.emit(amount)
	health_changed.emit(current_health, max_health)

	if invincibility_time > 0.0:
		is_invincible = true
		_invincibility_timer = invincibility_time

	if current_health <= 0:
		died.emit()


func heal(amount: float) -> void:
	if current_health <= 0:
		return

	current_health = min(current_health + amount, max_health)
	healed.emit(amount)
	health_changed.emit(current_health, max_health)


func get_health_percent() -> float:
	return current_health / max_health if max_health > 0 else 0.0

## Camera Follow (2D)
## Attach to a Camera2D node that is NOT a child of the player.
## This provides smoothed following with optional look-ahead and screen shake.

extends Camera2D

@export var target_path: NodePath
@export var follow_speed: float = 5.0
@export var look_ahead_factor: float = 50.0
@export var look_ahead_speed: float = 3.0

var _target: Node2D = null
var _shake_amount: float = 0.0
var _shake_timer: float = 0.0
var _look_ahead: Vector2 = Vector2.ZERO


func _ready() -> void:
	if target_path:
		_target = get_node(target_path)


func set_target(node: Node2D) -> void:
	_target = node


func _process(delta: float) -> void:
	if not _target:
		return

	# Smooth follow
	var target_pos: Vector2 = _target.global_position

	# Look-ahead based on target velocity
	if _target is CharacterBody2D:
		var vel: Vector2 = (_target as CharacterBody2D).velocity.normalized()
		_look_ahead = _look_ahead.lerp(vel * look_ahead_factor, look_ahead_speed * delta)
		target_pos += _look_ahead

	global_position = global_position.lerp(target_pos, follow_speed * delta)

	# Screen shake
	if _shake_timer > 0:
		_shake_timer -= delta
		offset = Vector2(
			randf_range(-_shake_amount, _shake_amount),
			randf_range(-_shake_amount, _shake_amount)
		)
		_shake_amount = lerp(_shake_amount, 0.0, 5.0 * delta)
	else:
		offset = Vector2.ZERO


func shake(amount: float = 5.0, duration: float = 0.3) -> void:
	"""Call this to trigger screen shake (e.g., on hit, explosion)."""
	_shake_amount = amount
	_shake_timer = duration

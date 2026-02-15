## Collectible Item
extends Area2D

signal collected(item_name: String, value: int)

@export var item_name: String = "coin"
@export var value: int = 1
@export var bob_height: float = 4.0
@export var bob_speed: float = 3.0

var _start_y: float = 0.0
var _time: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_start_y = position.y
	body_entered.connect(_on_body_entered)
	_time = randf() * TAU


func _process(delta: float) -> void:
	_time += delta
	position.y = _start_y + sin(_time * bob_speed) * bob_height


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	collected.emit(item_name, value)
	if has_node("/root/Events"):
		get_node("/root/Events").item_collected.emit(item_name, value)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(queue_free)
	set_deferred("monitoring", false)

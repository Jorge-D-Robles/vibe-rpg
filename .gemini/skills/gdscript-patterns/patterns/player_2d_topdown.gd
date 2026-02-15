## 2D Top-Down Player Controller
## Attach to a CharacterBody2D node with a Sprite2D and CollisionShape2D as children.

extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0

@onready var sprite: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		_update_facing(input_vector)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()


func _update_facing(direction: Vector2) -> void:
	if direction.x != 0:
		sprite.flip_h = direction.x < 0

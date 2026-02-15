## 2D Platformer Player Controller
## Attach to a CharacterBody2D node with a Sprite2D, CollisionShape2D, and AnimationPlayer as children.

extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity_scale: float = 1.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

	# Coyote time
	if is_on_floor():
		coyote_timer = coyote_time
	elif was_on_floor:
		coyote_timer -= delta

	# Jump buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# Jump execution
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_force
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# Variable jump height (release to fall faster)
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

	# Horizontal movement
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * speed
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 0.2)

	was_on_floor = is_on_floor()
	move_and_slide()

	_update_animation(direction)


func _update_animation(direction: float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			anim_player.play("jump")
		else:
			anim_player.play("fall")
	elif direction != 0:
		anim_player.play("run")
	else:
		anim_player.play("idle")

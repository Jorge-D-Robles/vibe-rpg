## Basic Enemy with Patrol and Chase AI
## Attach to a CharacterBody2D with:
##   - Sprite2D
##   - CollisionShape2D
##   - RayCast2D (optional, for wall detection)
##   - Area2D "DetectionZone" with CollisionShape2D (for player detection)
##   - NavigationAgent2D (optional, for pathfinding)

extends CharacterBody2D

enum State { IDLE, PATROL, CHASE, ATTACK, DEAD }

@export var speed: float = 80.0
@export var chase_speed: float = 130.0
@export var patrol_distance: float = 100.0
@export var attack_range: float = 30.0
@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 1.0

var current_state: State = State.PATROL
var target: Node2D = null
var patrol_start: Vector2
var patrol_direction: float = 1.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _attack_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_zone: Area2D = $DetectionZone


func _ready() -> void:
	patrol_start = global_position
	detection_zone.body_entered.connect(_on_detection_body_entered)
	detection_zone.body_exited.connect(_on_detection_body_exited)


func _physics_process(delta: float) -> void:
	# Gravity (for platformers; remove for top-down)
	if not is_on_floor():
		velocity.y += gravity * delta

	_attack_timer -= delta

	match current_state:
		State.IDLE:
			velocity.x = 0
		State.PATROL:
			_patrol(delta)
		State.CHASE:
			_chase(delta)
		State.ATTACK:
			_attack(delta)
		State.DEAD:
			velocity = Vector2.ZERO
			return

	move_and_slide()
	_update_sprite()


func _patrol(_delta: float) -> void:
	velocity.x = patrol_direction * speed

	# Check if reached patrol boundary
	if abs(global_position.x - patrol_start.x) > patrol_distance:
		patrol_direction *= -1.0

	# Check for walls
	if is_on_wall():
		patrol_direction *= -1.0


func _chase(_delta: float) -> void:
	if not is_instance_valid(target):
		current_state = State.PATROL
		return

	var direction: float = sign(target.global_position.x - global_position.x)
	velocity.x = direction * chase_speed

	# Check if close enough to attack
	var dist: float = global_position.distance_to(target.global_position)
	if dist <= attack_range:
		current_state = State.ATTACK


func _attack(_delta: float) -> void:
	velocity.x = 0

	if not is_instance_valid(target):
		current_state = State.PATROL
		return

	var dist: float = global_position.distance_to(target.global_position)
	if dist > attack_range * 1.5:
		current_state = State.CHASE
		return

	if _attack_timer <= 0:
		_perform_attack()
		_attack_timer = attack_cooldown


func _perform_attack() -> void:
	if not is_instance_valid(target):
		return
	# Look for a HealthComponent on the target
	var health := target.get_node_or_null("HealthComponent")
	if health and health.has_method("take_damage"):
		health.take_damage(attack_damage)


func _update_sprite() -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0


func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		current_state = State.CHASE


func _on_detection_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		current_state = State.PATROL


func die() -> void:
	current_state = State.DEAD
	# Emit to signal bus if available
	if has_node("/root/Events"):
		get_node("/root/Events").enemy_killed.emit("basic", global_position)
	# Death animation / cleanup
	var tween := create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

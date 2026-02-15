## Enemy Wave Spawner
## Attach to a Node2D. Will spawn enemies at defined positions.

extends Node2D

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal all_waves_completed

@export var enemy_scene: PackedScene
@export var spawn_points: Array[Marker2D] = []
@export var enemies_per_wave: Array[int] = [3, 5, 8, 12]  # Enemies in each wave
@export var time_between_spawns: float = 0.5
@export var time_between_waves: float = 3.0
@export var auto_start: bool = false

var current_wave: int = 0
var enemies_alive: int = 0
var is_active: bool = false
var _spawn_timer: float = 0.0
var _enemies_to_spawn: int = 0


func _ready() -> void:
	if auto_start:
		start()


func start() -> void:
	current_wave = 0
	is_active = true
	_start_next_wave()


func _process(delta: float) -> void:
	if not is_active:
		return

	if _enemies_to_spawn > 0:
		_spawn_timer -= delta
		if _spawn_timer <= 0:
			_spawn_enemy()
			_enemies_to_spawn -= 1
			_spawn_timer = time_between_spawns


func _start_next_wave() -> void:
	if current_wave >= enemies_per_wave.size():
		is_active = false
		all_waves_completed.emit()
		if has_node("/root/Events"):
			pass  # Events.all_waves_completed.emit() if you add it
		return

	_enemies_to_spawn = enemies_per_wave[current_wave]
	wave_started.emit(current_wave + 1)
	if has_node("/root/Events"):
		get_node("/root/Events").wave_started.emit(current_wave + 1)

	current_wave += 1


func _spawn_enemy() -> void:
	if not enemy_scene:
		push_error("Spawner: No enemy scene assigned.")
		return

	var spawn_pos: Vector2
	if spawn_points.size() > 0:
		var marker: Marker2D = spawn_points[randi() % spawn_points.size()]
		spawn_pos = marker.global_position
	else:
		spawn_pos = global_position

	var enemy: Node2D = enemy_scene.instantiate()
	enemy.global_position = spawn_pos
	get_parent().add_child(enemy)
	enemies_alive += 1

	# Listen for enemy death
	if enemy.has_signal("tree_exiting"):
		enemy.tree_exiting.connect(_on_enemy_died)


func _on_enemy_died() -> void:
	enemies_alive -= 1

	if enemies_alive <= 0 and _enemies_to_spawn <= 0:
		wave_completed.emit(current_wave)
		if has_node("/root/Events"):
			get_node("/root/Events").wave_completed.emit(current_wave)

		# Wait then start next wave
		await get_tree().create_timer(time_between_waves).timeout
		if is_active:
			_start_next_wave()

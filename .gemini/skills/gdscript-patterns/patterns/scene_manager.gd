## Scene Manager (Autoload/Singleton)
## Add this as an autoload named "SceneManager" in project settings.
## Handles scene transitions with optional fade effects.

extends Node

signal scene_loaded(scene_name: String)
signal transition_started
signal transition_finished

var _current_scene: Node = null
var _transition_layer: CanvasLayer = null
var _color_rect: ColorRect = null
var _tween: Tween = null


func _ready() -> void:
	# Create a CanvasLayer for the fade overlay
	_transition_layer = CanvasLayer.new()
	_transition_layer.layer = 100  # On top of everything
	add_child(_transition_layer)

	_color_rect = ColorRect.new()
	_color_rect.color = Color.BLACK
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_color_rect.modulate.a = 0.0
	_transition_layer.add_child(_color_rect)

	# Get the current scene
	var root: Window = get_tree().root
	_current_scene = root.get_child(root.get_child_count() - 1)


func change_scene(scene_path: String, fade_duration: float = 0.5) -> void:
	transition_started.emit()

	if fade_duration > 0:
		await _fade_out(fade_duration)

	_load_scene(scene_path)

	if fade_duration > 0:
		await _fade_in(fade_duration)

	transition_finished.emit()


func change_scene_to_packed(scene: PackedScene, fade_duration: float = 0.5) -> void:
	transition_started.emit()

	if fade_duration > 0:
		await _fade_out(fade_duration)

	_current_scene.queue_free()
	var new_scene: Node = scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	_current_scene = new_scene
	scene_loaded.emit(new_scene.name)

	if fade_duration > 0:
		await _fade_in(fade_duration)

	transition_finished.emit()


func reload_current_scene(fade_duration: float = 0.3) -> void:
	var current_path: String = _current_scene.scene_file_path
	if current_path.is_empty():
		push_warning("Cannot reload: current scene has no file path.")
		return
	change_scene(current_path, fade_duration)


func _load_scene(path: String) -> void:
	_current_scene.queue_free()
	var new_scene: PackedScene = ResourceLoader.load(path)
	if not new_scene:
		push_error("Failed to load scene: %s" % path)
		return
	var instance: Node = new_scene.instantiate()
	get_tree().root.add_child(instance)
	get_tree().current_scene = instance
	_current_scene = instance
	scene_loaded.emit(instance.name)


func _fade_out(duration: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 1.0, duration)
	await _tween.finished


func _fade_in(duration: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 0.0, duration)
	await _tween.finished

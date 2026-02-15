## Main Menu
## Attach to a Control node. Expects VBoxContainer with child Buttons.
## Scene structure:
##   MainMenu (Control) <- this script
##     VBoxContainer
##       Title (Label)
##       PlayButton (Button)
##       SettingsButton (Button)
##       QuitButton (Button)

extends Control

@export var game_scene: String = "res://scenes/game.tscn"

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Optional: button animations
	_setup_button_hover(play_button)
	_setup_button_hover(settings_button)
	_setup_button_hover(quit_button)


func _on_play_pressed() -> void:
	# If SceneManager autoload exists, use it for a fade transition
	if has_node("/root/SceneManager"):
		get_node("/root/SceneManager").change_scene(game_scene)
	else:
		get_tree().change_scene_to_file(game_scene)


func _on_settings_pressed() -> void:
	# Override this — open a settings panel or scene
	print("Settings not yet implemented.")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _setup_button_hover(button: Button) -> void:
	"""Add a subtle scale animation on hover."""
	button.mouse_entered.connect(func():
		var tween := create_tween()
		tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)
	)
	button.mouse_exited.connect(func():
		var tween := create_tween()
		tween.tween_property(button, "scale", Vector2.ONE, 0.1)
	)
	button.pivot_offset = button.size / 2

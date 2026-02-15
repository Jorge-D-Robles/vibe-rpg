## Pause Menu
## Attach to a Control node. Should be a child of a CanvasLayer (to render above the game).
## Scene structure:
##   PauseLayer (CanvasLayer)
##     PauseMenu (Control) <- this script
##       Panel
##         VBoxContainer
##           ResumeButton (Button)
##           SettingsButton (Button)
##           MainMenuButton (Button)

extends Control

@export var main_menu_scene: String = "res://scenes/main_menu.tscn"

@onready var resume_button: Button = %ResumeButton
@onready var main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # Critical: process even when tree is paused

	resume_button.pressed.connect(_on_resume_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


func toggle_pause() -> void:
	var is_pausing: bool = not get_tree().paused
	get_tree().paused = is_pausing
	visible = is_pausing

	if is_pausing:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		# Restore mouse mode if needed (e.g., for FPS games)
		pass


func _on_resume_pressed() -> void:
	toggle_pause()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	if has_node("/root/SceneManager"):
		get_node("/root/SceneManager").change_scene(main_menu_scene)
	else:
		get_tree().change_scene_to_file(main_menu_scene)

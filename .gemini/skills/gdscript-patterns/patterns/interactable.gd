## Interactable Object Pattern
## Attach to an Area2D. The player should have a method or signal for interaction.
## The player must be in group "player".

extends Area2D
class_name Interactable

signal interacted(body: Node2D)

@export var interaction_text: String = "Press E to interact"
@export var one_shot: bool = false

var _can_interact: bool = false
var _interactor: Node2D = null
var _has_interacted: bool = false

@onready var label: Label = $InteractionLabel  # Optional child Label


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if label:
		label.text = interaction_text
		label.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if not _can_interact:
		return
	if _has_interacted and one_shot:
		return

	if event.is_action_pressed("interact"):
		_has_interacted = true
		interacted.emit(_interactor)
		get_viewport().set_input_as_handled()

		if label and one_shot:
			label.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_can_interact = true
		_interactor = body
		if label and not (_has_interacted and one_shot):
			label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_can_interact = false
		_interactor = null
		if label:
			label.visible = false


# ============ Usage ============
# On a chest:
#   var chest_area: Interactable = $ChestArea
#   chest_area.interacted.connect(_on_chest_opened)
#
#   func _on_chest_opened(body):
#       # Give item, play animation, etc.
#       pass

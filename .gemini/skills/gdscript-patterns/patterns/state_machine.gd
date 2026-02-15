## Finite State Machine
## Attach to a Node and add State nodes as children.
## Each State is a separate Node script extending this base State class.

# ============ state_machine.gd ============
# Attach this to a Node called "StateMachine" as a child of your character.

extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)

	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_state_transitioned(state: State, new_state_name: String) -> void:
	if state != current_state:
		return

	var new_state: State = states.get(new_state_name.to_lower())
	if not new_state:
		push_warning("State '%s' not found." % new_state_name)
		return

	current_state.exit()
	new_state.enter()
	current_state = new_state


# ============ state.gd ============
# Base class for all states. Create a new script extending this for each state.
# Example: idle_state.gd, run_state.gd, jump_state.gd

#extends Node
#class_name State
#
#signal transitioned(state: State, new_state_name: String)
#
#
#func enter() -> void:
#	pass
#
#
#func exit() -> void:
#	pass
#
#
#func update(_delta: float) -> void:
#	pass
#
#
#func physics_update(_delta: float) -> void:
#	pass


# ============ Example: idle_state.gd ============
#extends State
#
#@onready var player: CharacterBody2D = owner
#
#
#func enter() -> void:
#	player.anim_player.play("idle")
#
#
#func physics_update(delta: float) -> void:
#	if not player.is_on_floor():
#		transitioned.emit(self, "fall")
#		return
#
#	if Input.is_action_just_pressed("jump"):
#		transitioned.emit(self, "jump")
#		return
#
#	var direction := Input.get_axis("move_left", "move_right")
#	if direction != 0:
#		transitioned.emit(self, "run")

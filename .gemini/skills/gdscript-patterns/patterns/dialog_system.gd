## Dialog System
extends Control

signal dialog_started
signal dialog_finished
signal line_displayed(text: String)

@export var characters_per_second: float = 30.0
@export var auto_advance_delay: float = 2.0

var _dialog_lines: Array[String] = []
var _current_line: int = 0
var _is_typing: bool = false
var _full_text: String = ""

@onready var text_label: RichTextLabel = %DialogText
@onready var name_label: Label = %SpeakerName
@onready var panel: PanelContainer = %DialogPanel


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if _is_typing:
			_skip_typing()
		else:
			_advance()
		get_viewport().set_input_as_handled()


func show_dialog(lines: Array[String], speaker: String = "") -> void:
	_dialog_lines = lines
	_current_line = 0
	visible = true
	if name_label:
		name_label.text = speaker
		name_label.visible = speaker != ""
	dialog_started.emit()
	_display_line()


func _display_line() -> void:
	if _current_line >= _dialog_lines.size():
		_close()
		return
	_full_text = _dialog_lines[_current_line]
	text_label.text = ""
	_is_typing = true
	var duration: float = _full_text.length() / characters_per_second
	var tween := create_tween()
	tween.tween_method(_update_visible_chars, 0, _full_text.length(), duration)
	tween.tween_callback(func(): _is_typing = false)
	line_displayed.emit(_full_text)


func _update_visible_chars(count: int) -> void:
	text_label.text = _full_text.substr(0, count)


func _skip_typing() -> void:
	_is_typing = false
	text_label.text = _full_text
	get_tree().create_tween().kill()


func _advance() -> void:
	_current_line += 1
	_display_line()


func _close() -> void:
	visible = false
	dialog_finished.emit()

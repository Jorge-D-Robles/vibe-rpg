## Save/Load System
## Add this as an autoload named "SaveManager".
## Uses JSON for cross-platform portability.

extends Node

const SAVE_DIR: String = "user://saves/"
const SAVE_FILE: String = "save_data.json"

var game_data: Dictionary = {}


func _ready() -> void:
	_ensure_save_dir()


func _ensure_save_dir() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)


func save_game(data: Dictionary = {}, slot: int = 0) -> bool:
	"""Save game data to a JSON file."""
	if data.is_empty():
		data = game_data

	# Add metadata
	data["_meta"] = {
		"timestamp": Time.get_datetime_string_from_system(),
		"slot": slot,
	}

	var file_path: String = SAVE_DIR + "slot_%d_%s" % [slot, SAVE_FILE]
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("SaveManager: Failed to open file for writing: %s" % file_path)
		return false

	var json_string: String = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

	print("SaveManager: Game saved to slot %d" % slot)
	return true


func load_game(slot: int = 0) -> Dictionary:
	"""Load game data from a JSON file. Returns empty dict on failure."""
	var file_path: String = SAVE_DIR + "slot_%d_%s" % [slot, SAVE_FILE]

	if not FileAccess.file_exists(file_path):
		push_warning("SaveManager: No save file found at: %s" % file_path)
		return {}

	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("SaveManager: Failed to open file for reading: %s" % file_path)
		return {}

	var json_string: String = file.get_as_text()
	file.close()

	var json := JSON.new()
	var error: Error = json.parse(json_string)
	if error != OK:
		push_error("SaveManager: JSON parse error at line %d: %s" % [json.get_error_line(), json.get_error_message()])
		return {}

	game_data = json.data
	print("SaveManager: Game loaded from slot %d" % slot)
	return game_data


func has_save(slot: int = 0) -> bool:
	"""Check if a save file exists for the given slot."""
	var file_path: String = SAVE_DIR + "slot_%d_%s" % [slot, SAVE_FILE]
	return FileAccess.file_exists(file_path)


func delete_save(slot: int = 0) -> void:
	"""Delete a save file."""
	var file_path: String = SAVE_DIR + "slot_%d_%s" % [slot, SAVE_FILE]
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)
		print("SaveManager: Deleted save slot %d" % slot)


func get_save_slots() -> Array[int]:
	"""Return a list of slots that have save data."""
	var slots: Array[int] = []
	var dir := DirAccess.open(SAVE_DIR)
	if not dir:
		return slots

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.begins_with("slot_") and file_name.ends_with(".json"):
			var slot_str: String = file_name.split("_")[1]
			if slot_str.is_valid_int():
				slots.append(int(slot_str))
		file_name = dir.get_next()

	slots.sort()
	return slots


# ============ Usage Example ============
# Saving:
#   SaveManager.game_data = {
#       "player_position": {"x": player.position.x, "y": player.position.y},
#       "player_health": health_component.current_health,
#       "score": score,
#       "level": current_level,
#       "inventory": inventory_items,
#   }
#   SaveManager.save_game()
#
# Loading:
#   var data = SaveManager.load_game()
#   if not data.is_empty():
#       player.position = Vector2(data.player_position.x, data.player_position.y)
#       health_component.current_health = data.player_health

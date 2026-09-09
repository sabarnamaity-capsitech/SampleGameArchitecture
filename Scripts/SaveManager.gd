class_name SaveManager
extends Node
# Shudhu save/load data. UI, sound, game logic — kichu na.

const SAVE_PATH := "user://save.json"

var _data: Dictionary = {}

func _ready() -> void:
	_load()

func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_data = {"levels_completed": {}, "settings": {}}
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(f.get_as_text())
	_data = parsed if parsed is Dictionary else {"levels_completed": {}, "settings": {}}

func _write() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(_data))
	GameBus.save_data_changed.emit()

func mark_level_complete(level_id: int, time_taken: float) -> void:
	_data["levels_completed"][str(level_id)] = time_taken
	_write()

func is_level_complete(level_id: int) -> bool:
	return _data["levels_completed"].has(str(level_id))
func is_level_unlocked(level_id: int) -> bool:
	# 1st level shob shomoy free
	if level_id <= 1:
		return true
	# baki gulo — thik agerta complete thakle unlock
	return is_level_complete(level_id - 1)
func get_setting(key: String, default_value: Variant = null) -> Variant:
	return _data["settings"].get(key, default_value)

func set_setting(key: String, value: Variant) -> void:
	_data["settings"][key] = value
	_write()
	GameBus.settings_changed.emit(key, value)
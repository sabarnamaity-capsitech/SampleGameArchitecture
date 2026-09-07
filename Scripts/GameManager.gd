class_name GameManager
extends Node
# Shudhu timer + win/lose state track kore. Kono card/tile/piece — kichu jane na.
var _save: SaveManager
var _ui: UIManager

var current_level_id: int = -1
var _elapsed: float = 0.0
var _running: bool = false

func setup(save: SaveManager, ui: UIManager) -> void:
	_save = save
	_ui = ui
func _process(delta: float) -> void:
	if _running:
		_elapsed += delta

func start_level(level_id: int) -> void:
	current_level_id = level_id
	_elapsed = 0.0
	_running = true
	GameBus.level_started.emit(level_id)

func report_win() -> void:
	if not _running:
		return
	_running = false
	_save.mark_level_complete(current_level_id, _elapsed)
	GameBus.level_won.emit(current_level_id, _elapsed)
	_ui.push("win")

func report_lose() -> void:
	if not _running:
		return
	_running = false
	GameBus.level_lost.emit(current_level_id)
	_ui.push("lose")

func restart_current() -> void:
	var id := current_level_id
	GameBus.level_restarted.emit(id)
	start_level(id)

func get_elapsed_time() -> float:
	return _elapsed
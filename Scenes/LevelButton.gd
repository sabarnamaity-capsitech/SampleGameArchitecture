extends Control
class_name LevelButton

@export var button: TextureButton
@export var label: Label
@export var lock_label: TextureRect   # dekhabe locked hole

var level_number: int
var _locked: bool = false

func setup(level: int, locked: bool) -> void:
	level_number = level
	label.text = str(level)
	_locked = locked
	_update_visual()


func _ready() -> void:
	button.pressed.connect(_on_pressed)

func _update_visual() -> void:
	button.disabled = _locked
	modulate = Color(0.5, 0.5, 0.5, 1.0) if _locked else Color(1, 1, 1, 1)
	if lock_label:
		lock_label.visible = _locked
	label.visible = not _locked

func _on_pressed() -> void:
	if _locked:
		return
	GameBus.level_selected.emit(level_number)
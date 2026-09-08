extends Control
class_name LevelButton

@export var button: TextureButton
@export var label: Label

var level_number: int
func setup(level: int) -> void:
	level_number = level
	label.text = str(level)

func _ready() -> void:
	button.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	GameBus.level_selected.emit(level_number)
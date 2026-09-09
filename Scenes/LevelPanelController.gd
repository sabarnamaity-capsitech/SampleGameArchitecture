extends Control

@export var level_button_scene: PackedScene
@export var level_data: LevelDatabase

# @onready var level_container: GridContainer = $Panel/ScrollContainer/GridContainer
@export var level_container: GridContainer
func _ready() -> void:
	print("LEVEL DATA = ", level_data)
	print("LEVEL CONTAINER = ", level_container)
	print("VALID = ", is_instance_valid(level_container))
	print("BUTTON SCENE = ", level_button_scene)
	GameBus.level_selected.connect(_on_level_selected)
	_create_level_buttons()

func _create_level_buttons() -> void:
	for child in level_container.get_children():
		child.queue_free()

	for i in level_data.grid_sizes.size():
		var level_number := i + 1
		var level_button := level_button_scene.instantiate() as LevelButton
		var locked := not GameService.save.is_level_unlocked(level_number)
		level_container.add_child(level_button)
		level_button.setup(level_number, locked)
			
func _on_level_selected(level_number: int) -> void:
	if not GameService.save.is_level_unlocked(level_number):
		return
	GameService.game.select_level(level_number)
	GameService.scene.go_to("gameplay")

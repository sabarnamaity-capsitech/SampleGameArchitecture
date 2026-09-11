class_name UIManager
extends CanvasLayer
var _config: GameConfig
var _open_panels: Dictionary = {}
func setup(config: GameConfig) -> void:
	_config = config

func push(panel_name: String) -> void:
	if _open_panels.has(panel_name):
		return
	if not _config.panels.has(panel_name):
		push_error("UIManager: no panel registered for '%s'" % panel_name)
		return

	var packed: PackedScene = _config.panels[panel_name]
	var instance = packed.instantiate()
	if instance.has_method("setup"):
		# instance.setup(GameService.sound, self, GameService.game, GameService.scene)
		instance.setup(GameService.sound, self, GameService.game, GameService.scene, GameService.save)

	add_child(instance)
	_open_panels[panel_name] = instance

func pop(panel_name: String) -> void:
	if not _open_panels.has(panel_name):
		return
	_open_panels[panel_name].queue_free()
	_open_panels.erase(panel_name)

func pop_all() -> void:
	for name in _open_panels.keys():
		pop(name)
class_name SceneManager
extends Node

var _current: Node = null
var _config:GameConfig
func setup(config: GameConfig) -> void:
	_config = config
func _ready() -> void:
	_current = get_tree().current_scene
func go_to(scene_key: String) -> void:
	if not _config.scenes.has(scene_key):
		push_error("SceneManager: no scene registered for '%s'" % scene_key)
		return

	var packed: PackedScene = _config.scenes[scene_key]
	if _current:
		_current.queue_free()

	var instance = packed.instantiate()
	if instance.has_method("setup"):
		instance.setup(GameService.game, GameService.sound, self)
	get_tree().root.add_child(instance)
	_current = instance
	get_tree().current_scene = instance
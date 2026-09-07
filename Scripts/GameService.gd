extends Node
# Single entry point. Sob manager ekhane instantiate hoy.
# Kono script kokhono direct onno manager touch korbe na —
# shudhu GameService.sound / .save / .scene / .ui / .game diye access hobe.
var config: GameConfig = preload("res://Resource/game_config.tres")
var scene: SceneManager
var ui: UIManager
var save: SaveManager
var sound: AudioManager
var game: GameManager

func _ready() -> void:
	print("config loaded: ", config)
	print("scenes dict: ", config.scenes)
	print("sounds dict: ", config.sounds)
	save = SaveManager.new()
	sound = AudioManager.new()
	scene = SceneManager.new()
	ui = UIManager.new()
	game = GameManager.new()
	add_child(save)
	add_child(sound)
	add_child(scene)
	add_child(ui)
	add_child(game)

	sound.setup(config)
	scene.setup(config)
	ui.setup(config)
	game.setup(save, ui)
	# for key in config.sounds:
	# 	sound.register(key, config.sounds[key])
	scene.go_to.call_deferred("home")
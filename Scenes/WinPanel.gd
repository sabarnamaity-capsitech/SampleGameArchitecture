extends Control

var _sound: AudioManager
var _ui: UIManager
var _game: GameManager
var _scene: SceneManager
var _save: SaveManager
@export var time_label: Label
@export var level_label: Label
@export var retry_button: TextureButton
@export var home_button: TextureButton

func setup(sound: AudioManager, ui: UIManager, game: GameManager, scene: SceneManager, save: SaveManager) -> void:
	_sound = sound
	_ui = ui
	_game = game
	_scene = scene
	_save = save

func _ready() -> void:
	print("WIN PANEL READY")
	# var t: float = _game.get_elapsed_time()
	# time_label.text = "Time: %.1fs" % t
	GameBus.level_won.connect(_on_level_won)
	retry_button.pressed.connect(_on_retry_pressed)
	home_button.pressed.connect(_on_home_pressed)

func _on_retry_pressed() -> void:
	_ui.pop("win")
	_game.restart_current()
func _on_level_won(level_id: int, time_taken: float) -> void:
	print("WIN SIGNAL RECEIVED")
	print("LEVEL: ", level_id)
	print("TIME: ", time_taken)
	time_label.text = "%.2f s" % time_taken
	level_label.text = "Level %d" % level_id
func _on_home_pressed() -> void:
	_ui.pop("win")
	_scene.go_to("home")

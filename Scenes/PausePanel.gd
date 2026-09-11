extends Control
var _sound:AudioManager
var _scene:SceneManager
var _game:GameManager
var _ui:UIManager
var _save: SaveManager
@export var restart_button: TextureButton
@export var home_button: TextureButton
@export var level_label: Label
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	restart_button.pressed.connect(_on_restart_pressed)
	home_button.pressed.connect(_on_home_pressed)
	GameBus.game_paused.connect(_on_game_paused)
func setup(sound: AudioManager, ui: UIManager, game: GameManager, scene: SceneManager, save: SaveManager) -> void:
	_sound = sound
	_ui = ui
	_game = game
	_scene = scene
	_save = save
func _on_restart_pressed() -> void:
	print("Restart pressed")
	_sound.play("click")
	get_tree().paused = false
	_ui.pop("pause")
	_game.restart_current()
func _on_game_paused(level_id: int) -> void:
	print("Game paused for level: ", level_id)
	level_label.text = "Level %d" % level_id
func _on_home_pressed() -> void:
	print("Home pressed")
	_sound.play("click")
	get_tree().paused = false
	_ui.pop("pause")
	_scene.go_to("home")

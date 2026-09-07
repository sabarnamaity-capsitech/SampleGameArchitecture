extends Control
var _sound:AudioManager
var _scene:SceneManager
var _game:GameManager
var _ui:UIManager
@export var restart_button: TextureButton
@export var home_button: TextureButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	restart_button.pressed.connect(_on_restart_pressed)
	home_button.pressed.connect(_on_home_pressed)
func setup(sound: AudioManager, ui: UIManager, game: GameManager, scene: SceneManager) -> void:
	_sound = sound
	_ui = ui
	_game = game
	_scene = scene
func _on_restart_pressed() -> void:
	print("Restart pressed")
	_sound.play("click")
	get_tree().paused = false
	_ui.pop("pause")
	_game.restart_current()

func _on_home_pressed() -> void:
	print("Home pressed")
	_sound.play("click")
	get_tree().paused = false
	_ui.pop("pause")
	_scene.go_to("home")
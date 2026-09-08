extends Control
var _sound:AudioManager
var _scene:SceneManager
@export var play_button: TextureButton
func setup(_game: GameManager, sound: AudioManager, scene: SceneManager) -> void:
	_sound = sound
	_scene = scene
func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed() -> void:
	print("Play button pressed")
	# _sound.play("click")
	_scene.go_to("level_select")
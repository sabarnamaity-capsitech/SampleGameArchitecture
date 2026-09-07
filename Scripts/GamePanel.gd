extends Control

var _game: GameManager
var _sound: AudioManager
var _ui: UIManager

@export var pause_btn: TextureButton
@export var timer_label: Label

func setup(game: GameManager, sound: AudioManager, ui: UIManager) -> void:
	_game = game
	_sound = sound
	_ui = ui
	pause_btn.pressed.connect(_on_pause_pressed)

func _process(_delta: float) -> void:
	timer_label.text = "%.2f" % _game.get_elapsed_time()

func _on_pause_pressed() -> void:
	_sound.play("click")
	get_tree().paused = true
	_ui.push("pause")
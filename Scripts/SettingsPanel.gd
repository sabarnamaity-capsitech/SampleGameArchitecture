extends Control
class_name SettingsPanel

var _sound: AudioManager
var _ui: UIManager
var _game: GameManager
var _scene: SceneManager
var _save: SaveManager
@export var music_on_btn: TextureButton
@export var music_off_btn: TextureButton
@export var sound_on_btn: TextureButton
@export var sound_off_btn: TextureButton
@export var close_btn: TextureButton

func setup(sound: AudioManager, ui: UIManager, game: GameManager, scene: SceneManager, save: SaveManager) -> void:
	_sound = sound
	_ui = ui
	_game = game
	_scene = scene
	_save = save

func _ready() -> void:
	music_on_btn.pressed.connect(_on_music_toggle)
	music_off_btn.pressed.connect(_on_music_toggle)
	sound_on_btn.pressed.connect(_on_sound_toggle)
	sound_off_btn.pressed.connect(_on_sound_toggle)
	close_btn.pressed.connect(_on_close_pressed)
	_refresh_visuals()

func _refresh_visuals() -> void:
	var music_on: bool = _save.get_setting("is_music_on", true)
	var sound_on: bool = _save.get_setting("is_sound_on", true)
	music_on_btn.visible = music_on
	music_off_btn.visible = not music_on
	sound_on_btn.visible = sound_on
	sound_off_btn.visible = not sound_on

func _on_music_toggle() -> void:
	var current: bool = _save.get_setting("is_music_on", true)
	_save.set_setting("is_music_on", not current)
	_sound.play("click")
	_refresh_visuals()

func _on_sound_toggle() -> void:
	var current: bool = _save.get_setting("is_sound_on", true)
	_save.set_setting("is_sound_on", not current)
	_sound.play("click")
	_refresh_visuals()

func _on_close_pressed() -> void:
	_sound.play("click")
	_ui.pop("settings")
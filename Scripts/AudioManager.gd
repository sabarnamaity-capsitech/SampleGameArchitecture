# class_name AudioManager
# extends Node
# # Pooled SFX players. Idle player-der process disabled thake (battery/CPU save).

# const POOL_SIZE := 8
# var _pool: Array[AudioStreamPlayer] = []
# var _sfx: Dictionary = {}

# func setup(config: GameConfig) -> void:
# 	for key in config.sounds:
# 		register(key, config.sounds[key])
# func _ready() -> void:
# 	for i in POOL_SIZE:
# 		var p := AudioStreamPlayer.new()
# 		p.process_mode = Node.PROCESS_MODE_DISABLED
# 		p.finished.connect(func(): p.process_mode = Node.PROCESS_MODE_DISABLED)
# 		add_child(p)
# 		_pool.append(p)

# func register(name: String, stream: AudioStream) -> void:
# 	_sfx[name] = stream

# func play(name: String) -> void:
# 	if not _sfx.has(name):
# 		push_warning("AudioManager: '%s' not registered" % name)
# 		return
# 	for p in _pool:
# 		if not p.playing:
# 			p.process_mode = Node.PROCESS_MODE_INHERIT
# 			p.stream = _sfx[name]
# 			p.play()
# 			return
# 	_pool[0].process_mode = Node.PROCESS_MODE_INHERIT
# 	_pool[0].stream = _sfx[name]
# 	_pool[0].play()

class_name AudioManager
extends Node
# SFX: প্রতিবার নতুন AudioStreamPlayer বানিয়ে play, শেষ হলে queue_free (dynamic, pool na).
# BGM: ekta dedicated player, ei node GameService-er child hisebe autoload e
# thake bole scene change hole o eta destroy hoy na — music continuous chole.

var _sfx: Dictionary = {}
var _music: Dictionary = {}

var _bgm_player: AudioStreamPlayer
var _current_music_name: String = ""

func setup(config: GameConfig) -> void:
	for key in config.sounds:
		register(key, config.sounds[key])
	for key in config.music:
		register_music(key, config.music[key])

func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	add_child(_bgm_player)
	_bgm_player.finished.connect(_on_music_finished)
	GameBus.settings_changed.connect(_on_settings_changed)

# ---------------- SFX ----------------

func register(name: String, stream: AudioStream) -> void:
	_sfx[name] = stream

func play(name: String) -> void:
	if not _is_sound_on():
		return
	if not _sfx.has(name):
		push_warning("AudioManager: '%s' not registered" % name)
		return
	var p := AudioStreamPlayer.new()
	add_child(p)
	p.stream = _sfx[name]
	p.play()
	p.finished.connect(func(): p.queue_free())

# ---------------- BGM ----------------

func register_music(name: String, stream: AudioStream) -> void:
	_music[name] = stream

func play_music(name: String) -> void:
	if not _music.has(name):
		push_warning("AudioManager: music '%s' not registered" % name)
		return
	_current_music_name = name
	if not _is_music_on():
		return
	if _bgm_player.playing and _bgm_player.stream == _music[name]:
		return
	_bgm_player.stream = _music[name]
	_bgm_player.play()

func stop_music() -> void:
	_bgm_player.stop()

func _on_music_finished() -> void:
	if _current_music_name != "" and _is_music_on():
		_bgm_player.play()

# ---------------- Settings reaction ----------------

func _on_settings_changed(key: String, value: Variant) -> void:
	if key == "is_music_on":
		if value:
			if _current_music_name != "":
				play_music(_current_music_name)
		else:
			stop_music()

# ---------------- Helpers ----------------

func _is_sound_on() -> bool:
	return GameService.save.get_setting("is_sound_on", true)

func _is_music_on() -> bool:
	return GameService.save.get_setting("is_music_on", true)
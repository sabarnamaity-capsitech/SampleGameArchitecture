class_name AudioManager
extends Node
# Pooled SFX players. Idle player-der process disabled thake (battery/CPU save).

const POOL_SIZE := 8


var _pool: Array[AudioStreamPlayer] = []
var _sfx: Dictionary = {}

func setup(config: GameConfig) -> void:
	for key in config.sounds:
		register(key, config.sounds[key])
func _ready() -> void:
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.process_mode = Node.PROCESS_MODE_DISABLED
		p.finished.connect(func(): p.process_mode = Node.PROCESS_MODE_DISABLED)
		add_child(p)
		_pool.append(p)

func register(name: String, stream: AudioStream) -> void:
	_sfx[name] = stream

func play(name: String) -> void:
	if not _sfx.has(name):
		push_warning("AudioManager: '%s' not registered" % name)
		return
	for p in _pool:
		if not p.playing:
			p.process_mode = Node.PROCESS_MODE_INHERIT
			p.stream = _sfx[name]
			p.play()
			return
	_pool[0].process_mode = Node.PROCESS_MODE_INHERIT
	_pool[0].stream = _sfx[name]
	_pool[0].play()
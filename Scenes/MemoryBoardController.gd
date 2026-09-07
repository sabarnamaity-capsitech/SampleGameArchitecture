extends Node2D
# GAME-SPECIFIC. Card gula viewport size onujayi dynamically size + position hoy.

const GRID_SIZE := 4
const GRID_MARGIN := 40.0        # screen edge theke gap
const CARD_GAP_RATIO := 0.85     # cell-er koto% card occupy korbe (baki gap)
const TOP_OFFSET_RATIO := 0.2    # upor theke koto% niche grid shuru hobe
const FLIP_BACK_DELAY := 0.6

const CARD_SCENE := preload("res://Scenes/Card.tscn")
var _game: GameManager
var _sound: AudioManager
var _ui: UIManager
var _cards: Array[Card] = []
var _values: Array[int] = []
var _matched: Array[bool] = []
var _flipped: Array[int] = []
var _input_locked := false
var _matches_found := 0
func setup(game: GameManager, sound: AudioManager, _scene: SceneManager) -> void:
	_game = game
	_sound = sound
	_ui = GameService.ui
func _ready() -> void:
	_game.start_level(1)
	GameBus.level_restarted.connect(_on_restart)
	_build_board()
	var game_panel = $HUD/GamePanel
	if game_panel and game_panel.has_method("setup"):
		print("setup calling")
		game_panel.setup(_game, _sound, _ui)
	else:
		print("SETUP SKIPPED - node ba method missing")

func _on_restart(_id: int) -> void:
	_build_board()

func _build_board() -> void:
	for c in _cards:
		c.queue_free()
	_cards.clear()

	_values = _generate_shuffled_values()
	_matched.assign(range(GRID_SIZE * GRID_SIZE).map(func(_i): return false))
	_flipped.clear()
	_matches_found = 0
	_input_locked = false

	var viewport_size: Vector2 = get_viewport_rect().size
	var available_size: float = min(viewport_size.x, viewport_size.y) - GRID_MARGIN * 2.0
	var cell_size: float = available_size / GRID_SIZE
	var card_dim := Vector2(cell_size * CARD_GAP_RATIO, cell_size * CARD_GAP_RATIO)

	var grid_pixel_size: float = cell_size * GRID_SIZE
	var start_x: float = (viewport_size.x - grid_pixel_size) / 2.0 + cell_size / 2.0
	var start_y: float = viewport_size.y * TOP_OFFSET_RATIO

	for i in _values.size():
		var card := CARD_SCENE.instantiate() as Card
		var row := i / GRID_SIZE
		var col := i % GRID_SIZE
		card.position = Vector2(start_x + col * cell_size, start_y + row * cell_size)
		card.set_card_size(card_dim)
		card.setup(_values[i])
		card.card_clicked.connect(_on_card_clicked)
		add_child(card)
		_cards.append(card)

func _generate_shuffled_values() -> Array[int]:
	var pairs: Array[int] = []
	for i in (GRID_SIZE * GRID_SIZE) / 2:
		pairs.append(i)
		pairs.append(i)
	pairs.shuffle()
	return pairs

func _on_card_clicked(card: Card) -> void:
	var index := _cards.find(card)
	if _input_locked or _matched[index] or _flipped.has(index):
		return

	card.reveal()
	_flipped.append(index)

	if _flipped.size() < 2:
		return

	_input_locked = true
	_sound.play("flip")

	var a: int = _flipped[0]
	var b: int = _flipped[1]

	if _values[a] == _values[b]:
		_matched[a] = true
		_matched[b] = true
		_cards[a].set_matched()
		_cards[b].set_matched()
		_matches_found += 1
		_flipped.clear()
		_input_locked = false
		_sound.play("match")
		if _matches_found == (GRID_SIZE * GRID_SIZE) / 2:
			_on_puzzle_solved()
	else:
		await get_tree().create_timer(FLIP_BACK_DELAY).timeout
		_cards[a].hide_card()
		_cards[b].hide_card()
		_flipped.clear()
		_input_locked = false

func _on_puzzle_solved() -> void:
	_sound.play("win_jingle")
	_game.report_win()

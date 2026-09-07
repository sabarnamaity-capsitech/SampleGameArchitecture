extends Area2D
class_name Card
# Ekta card. _draw() diye render hoy. Size ekhon fixed na — set_card_size()
# diye runtime e viewport onujayi set kora hoy.

signal card_clicked(card: Card)

const COLORS: Array[Color] = [
	Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN,
	Color.CYAN, Color.BLUE, Color.PURPLE, Color.MAGENTA,
]

var value: int = -1
var is_revealed := false
var is_matched := false
var card_size := Vector2(100, 100)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	input_event.connect(_on_input_event)
	_update_collision_shape()

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		card_clicked.emit(self)

func set_card_size(new_size: Vector2) -> void:
	card_size = new_size
	_update_collision_shape()
	queue_redraw()

func _update_collision_shape() -> void:
	if collision_shape and collision_shape.shape is RectangleShape2D:
		collision_shape.shape.size = card_size

func setup(v: int) -> void:
	value = v
	is_revealed = false
	is_matched = false
	queue_redraw()

func reveal() -> void:
	is_revealed = true
	queue_redraw()

func hide_card() -> void:
	is_revealed = false
	queue_redraw()

func set_matched() -> void:
	is_matched = true
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(-card_size / 2, card_size)
	var fill_color := COLORS[value] if (is_revealed or is_matched) else Color(0.2, 0.2, 0.25)
	draw_rect(rect, fill_color)
	draw_rect(rect, Color.BLACK, false, 2.0)
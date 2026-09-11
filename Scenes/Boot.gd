extends Node2D

@export var splash_duration: float = 3  # koto second Boot dekhabe

func _ready() -> void:
	GameService.sound.play_music("bgm")
	await get_tree().create_timer(splash_duration).timeout
	GameService.scene.go_to("home")
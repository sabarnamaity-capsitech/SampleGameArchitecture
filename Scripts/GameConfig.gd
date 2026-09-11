extends Resource
class_name GameConfig
@export var scenes: Dictionary[String, PackedScene] = {}
@export var panels: Dictionary[String, PackedScene] = {}
@export var sounds: Dictionary[String, AudioStream] = {}
@export var music: Dictionary[String, AudioStream] = {}
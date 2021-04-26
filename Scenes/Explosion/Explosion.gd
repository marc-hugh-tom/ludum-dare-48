extends Node2D

const Sounds = [
	preload("res://assets/sounds/explosion_1.ogg"),
	preload("res://assets/sounds/explosion_2.ogg"),
	preload("res://assets/sounds/explosion_3.ogg"),
]

onready var audio = $AudioStreamPlayer2D

func _ready():
	audio.stream = Sounds[randi() % Sounds.size()]
	audio.play()

func emit_explosion_event():
	get_tree().call_group("playstate", "explosion_event", position)

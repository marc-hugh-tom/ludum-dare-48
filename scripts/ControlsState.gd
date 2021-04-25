extends Node2D

signal start_game

func _ready():
	$Column/MarginContainer/StartButton.connect(
		"button_up", self, "start_game")

func start_game():
	emit_signal("start_game")

extends Node2D

signal start_game
signal start_credits

onready var global = get_tree().get_root().get_node("GlobalVariables")

func _ready():
	global.set_depth(0.0)
	$Menu/VBox/StartButton.connect(
		"button_up", self, "start_game")
	$Menu/VBox/CreditsButton.connect(
		"button_up", self, "start_credits")

func start_game():
	emit_signal("start_game")

func start_credits():
	emit_signal("start_credits")


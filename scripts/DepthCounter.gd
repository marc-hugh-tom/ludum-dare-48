extends Node2D

var current_value = 0.0

onready var global = get_tree().get_root().get_node("GlobalVariables")

func set_value(input_float):
	input_float = min(input_float, 9999)
	get_node('1000').set_value(input_float / 1000.0)
	get_node('100').set_value(fmod(input_float, 1000) / 100)
	get_node('10').set_value(fmod(input_float, 100) / 10)
	get_node('1').set_value(fmod(input_float, 10))

func _process(_delta):
	set_value(global.get_depth())

extends Node2D

var current_value = 0.0
var update_speed = 10.0

onready var global = get_tree().get_root().get_node("GlobalVariables")

func set_value(input_float):
	# thousands
	var thousand_value = input_float / 1000.0
	if thousand_value > 9:
		thousand_value = 9
	get_node('1000').set_value(thousand_value)
	# hundreds
	var hundreds_value = fmod(input_float, 1000) / 100
	if thousand_value == 9 and hundreds_value > 9:
		hundreds_value = 9
	get_node('100').set_value(hundreds_value)
	# tens
	var tens_value = fmod(input_float, 100) / 10
	if thousand_value == 9 and hundreds_value == 9 and tens_value > 9:
		tens_value = 9
	get_node('10').set_value(tens_value)
	# units
	var units_value = fmod(input_float, 10)
	get_node('1').set_value(units_value)

func _process(delta):
	current_value += (global.get_scrap() - current_value) * update_speed * delta
	set_value(current_value)

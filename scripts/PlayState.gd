extends Node2D

onready var global = get_tree().get_root().get_node("GlobalVariables")


func _ready():
	randomize()


func _process(delta):
	update_depth(delta)


func update_depth(delta):
	var current_depth = global.get_depth()
	global.set_depth(min(
		current_depth - global.get_scroll_vector().y * delta,
		global.get_max_depth()
	))

func explosion_event(explosion_pos):
	print('boom', explosion_pos)

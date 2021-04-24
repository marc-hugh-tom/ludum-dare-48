extends Node

var depth = 0
var scroll_vector = Vector2(0, 20)

func get_depth():
	return(depth)

func set_depth(input_int):
	depth = input_int

func get_scroll_vector():
	return(scroll_vector)

func set_scroll_vector(input_vec):
	scroll_vector = input_vec

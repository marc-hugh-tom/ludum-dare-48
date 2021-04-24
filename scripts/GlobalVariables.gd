extends Node

var depth: int = 0
var scroll_vector: Vector2 = Vector2(0, -2)
var exit_boundary: int = 64

func get_depth() -> int:
	return(depth)

func set_depth(input_int: int):
	depth = input_int

func get_scroll_vector() -> Vector2:
	return(scroll_vector)

func set_scroll_vector(input_vec: Vector2):
	scroll_vector = input_vec

func get_exit_boundary() -> int:
	return exit_boundary

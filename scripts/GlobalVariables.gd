extends Node

var depth: float = 0
var scroll_vector: Vector2 = Vector2(0, -30)
var exit_boundary: int = 64

func get_depth() -> float:
	return(depth)

func set_depth(input_float: float):
	depth = input_float

func get_scroll_vector() -> Vector2:
	return(scroll_vector)

func set_scroll_vector(input_vec: Vector2):
	scroll_vector = input_vec

func get_exit_boundary() -> int:
	return exit_boundary

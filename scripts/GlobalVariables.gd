extends Node

var depth: float = 0
var scroll_vector: Vector2 = Vector2(0, -30)
var exit_boundary: int = 64
var scrap: int = 0
var max_depth: int = 9999
var max_scrap: int = 9999

func get_depth() -> float:
	return(depth)

func set_depth(input_float: float):
	depth = input_float

func get_scroll_vector() -> Vector2:
	return scroll_vector
	
func get_scroll_dir() -> Vector2:
	return get_scroll_vector().normalized()

func set_scroll_vector(input_vec: Vector2):
	scroll_vector = input_vec

func get_exit_boundary() -> int:
	return exit_boundary

func get_scrap() -> int:
	return scrap

func increment_scrap(val: int):
	scrap += val
	scrap = min(scrap, max_scrap)

func set_scrap(val: int):
	scrap = val

func get_max_depth() -> int:
	return(max_depth)

func _process(delta):
	update_depth(delta)

func update_depth(delta):
	var current_depth = get_depth()
	set_depth(min(
		current_depth - get_scroll_vector().y * delta,
		get_max_depth()
	))

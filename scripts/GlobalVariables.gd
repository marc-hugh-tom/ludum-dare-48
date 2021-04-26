extends Node

var depth: float = 0
var scroll_vector: Vector2 = Vector2(0, -30)
var exit_boundary: int = 64
var scrap: int = 0
var max_depth: int = 9999
var max_scrap: int = 9999

var max_health: float = 100.0
var health: float = max_health

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
	_sync_sales_buttons()

func decrement_scrap(val: int):
	scrap -= val
	scrap = max(scrap, 0)
	_sync_sales_buttons()

func set_scrap(val: int):
	scrap = val
	_sync_sales_buttons()
	

func get_max_depth() -> int:
	return(max_depth)

func get_health() -> float:
	return health

func decrement_health(val: float):
	health -= val

func set_health(val: float):
	health = val

func increment_health(val: float):
	health += val

func _process(delta):
	update_depth(delta)

func update_depth(delta):
	var current_depth = get_depth()
	set_depth(min(
		current_depth - get_scroll_vector().y * delta,
		get_max_depth()
	))

func reset():
	pause_mode = PAUSE_MODE_INHERIT
	set_health(max_health)
	set_depth(0)
	set_scrap(0)

func is_max_depth():
	return abs(depth - max_depth) < 0.1

func _sync_sales_buttons():
	get_tree().call_group("SaleButtons", "sync_ui")

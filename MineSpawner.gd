extends Node

const SPAWN_MARGIN = 64
const MIN_SPAWN_SECONDS = 1
const MAX_SPAWN_SECONDS = 10
const MAX_DEPTH = 20000

const MineResource = preload("res://Scenes/Mine/Mine.tscn")

onready var global = get_tree().get_root().get_node("GlobalVariables")

func _ready():
	$Timer.start()


func spawn_mine():
	var mine = MineResource.instance()
	mine.position = select_spawn_point()
	get_parent().add_child(mine)
	print("spawned mine at ", mine.position)


func select_spawn_point() -> Vector2:
	var spawn_x = randi() % int(get_viewport().size.x)
	if global.get_scroll_dir().x < 0:
		spawn_x = get_viewport().size.x + SPAWN_MARGIN
	elif global.get_scroll_dir().x > 0:
		spawn_x = 0 - SPAWN_MARGIN
	var spawn_y = randi() % int(get_viewport().size.y)
	if global.get_scroll_dir().y < 0:
		spawn_y = get_viewport().size.y + SPAWN_MARGIN
	elif global.get_scroll_dir().y > 0:
		spawn_y = 0 - SPAWN_MARGIN
	
	return Vector2(spawn_x, spawn_y)


func _on_Timer_timeout():
	spawn_mine()

	var wait_time = rand_range(
		MIN_SPAWN_SECONDS,
		lerp(MAX_SPAWN_SECONDS, MIN_SPAWN_SECONDS, global.get_depth() / MAX_DEPTH)
	)
	
	$Timer.wait_time = wait_time
	$Timer.start()
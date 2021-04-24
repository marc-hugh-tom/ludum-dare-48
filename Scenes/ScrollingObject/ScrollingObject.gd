extends Area2D

onready var global = get_tree().get_root().get_node("GlobalVariables")


func _process(delta):
	position += (global.get_scroll_vector() * delta)
	if gone_out_of_view():
		destroy()


func gone_out_of_view() -> bool:
	if global.get_scroll_dir().x != 0 and global.get_scroll_dir().y != 0:
		return has_left_x() and has_left_y()
	return has_left_x() or has_left_y()

func has_left_x() -> bool:
	var scroll_x: int = global.get_scroll_dir().x
	if scroll_x == 0:
		return false
	if scroll_x < 0:
		return position.x <= global.get_exit_boundary() * -1
	return position.x >= get_viewport().size.x + global.get_exit_boundary()


func has_left_y() -> bool:
	var scroll_y: int = global.get_scroll_dir().y
	if scroll_y == 0:
		return false
	if scroll_y < 0:
		return position.y <= global.get_exit_boundary() * -1
	return position.y >= get_viewport().size.y + global.get_exit_boundary()

func destroy():
	queue_free()

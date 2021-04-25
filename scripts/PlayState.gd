extends Node2D

onready var global = get_tree().get_root().get_node("GlobalVariables")


func _ready():
	randomize()


func _process(delta):
	update_depth(delta)
	
	if Input.is_action_just_pressed("shop"):
		get_tree().paused = true
		$Shop.arsenal = $Foreground/sub.get_node("Arsenal")
		$Shop.show()

func update_depth(delta):
	var current_depth = global.get_depth()
	global.set_depth(min(
		(current_depth - global.get_scroll_vector().y * delta),
		global.get_max_depth()
	))


func _on_Shop_close():
		get_tree().paused = false
		$Shop.hide()

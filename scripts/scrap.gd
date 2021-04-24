extends "res://Scenes/ScrollingObject/ScrollingObject.gd"

func _ready():
	rotation_degrees = rand_range(0, 360)

func _on_scrap_body_entered(body):
	global.increment_scrap(10)
	destroy()

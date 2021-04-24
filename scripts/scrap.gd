extends "res://Scenes/ScrollingObject/ScrollingObject.gd"

var max_scale = Vector2(4, 4)
var animation_duration = 0.3


func _ready():
	rotation_degrees = rand_range(0, 360)

func _on_scrap_body_entered(body):
	global.increment_scrap(10)
	destroy()

func destroy():
	set_z_index(99)
	$Tween.interpolate_property($Sprite, "scale",
		Vector2(1, 1), max_scale, animation_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), animation_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.connect("tween_all_completed", self,
		"queue_free", [], CONNECT_ONESHOT)
	$Tween.start()

extends "res://Scenes/ScrollingObject/ScrollingObject.gd"

var max_scale = Vector2(4, 4)
var animation_duration = 0.3


func _ready():
	rotation_degrees = rand_range(0, 360)

func _on_scrap_body_entered(body):
	if body.has_method('is_player'):
		if body.is_player():
			global.increment_scrap(10)
			play_pickup_noise()
			destroy()

func play_pickup_noise():
	$AudioStreamPlayer2D.connect("finished", self,
		"queue_free", [], CONNECT_ONESHOT)
	$AudioStreamPlayer2D.play()

func destroy():
	set_z_index(99)
	$Tween.interpolate_property($Sprite, "scale",
		Vector2(1, 1), max_scale, animation_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), animation_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.connect("tween_all_completed", self,
#		"queue_free", [], CONNECT_ONESHOT)
	$Tween.start()

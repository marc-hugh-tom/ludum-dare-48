extends Node2D

onready var animated_sprite = $AnimatedSprite

export(bool) var is_bottom = false
onready var is_top = not is_bottom

func _physics_process(delta: float):
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	clamp_rotation()

func clamp_rotation():
	while rotation_degrees > 360.0:
		rotation_degrees -= 360.0
	while rotation_degrees < 0.0:
		rotation_degrees += 360.0

extends Node2D

func _physics_process(delta: float):
	look_at(get_global_mouse_position())
	clamp_rotation()

func clamp_rotation():
	while rotation_degrees > 360.0:
		rotation_degrees -= 360.0
	while rotation_degrees < 0.0:
		rotation_degrees += 360.0

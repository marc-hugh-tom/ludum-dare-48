extends Node2D

var speed = 500
var velocity = Vector2()

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)


func _physics_process(delta):
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area):
	print("harpoon hit something")
	if area.has_method("take_damage"):
		area.take_damage(10)
	queue_free()

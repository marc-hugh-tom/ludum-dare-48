extends Node2D

var fire_source = null
var speed = 600
var velocity = Vector2()

const Strike = preload("res://Scenes/Weapons/Strike.tscn")


func start(pos, dir, source):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	fire_source = source


func _physics_process(delta):
	position += velocity * delta
	velocity.y = lerp(velocity.y, speed, delta*0.1)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _do_damage(node):
	destroy()
	if node.has_method("take_damage"):
		node.take_damage(10)


func _on_Area2D_area_entered(area):
	if area != fire_source:
		_do_damage(area)


func _on_Area2D_body_entered(body):
	if body != fire_source:
		_do_damage(body)


func destroy():
	var strike = Strike.instance()
	strike.position = position
	get_parent().add_child(strike)
	queue_free()

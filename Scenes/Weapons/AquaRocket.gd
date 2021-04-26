extends Node2D

const Explosion = preload("res://Scenes/Explosion/Explosion.tscn")

var foreground_ref

var fire_source = null
var speed = -100
var max_speed = 800
var velocity = Vector2()


func start(pos, dir, source):
	rotation = dir
	position = pos
	velocity = Vector2(300, 0).rotated(rotation)
	fire_source = source


func _physics_process(delta):
	speed = lerp(speed, max_speed, 1.5*delta)
	velocity = Vector2(speed, 0).rotated(rotation)
	position += velocity * delta


func _do_damage(node):
	if node.has_method("take_damage"):
		node.take_damage(30)
	destroy()


func _on_Area2D_area_entered(area):
	_do_damage(area)


func _on_Area2D_body_entered(body):
	if body != fire_source:
		_do_damage(body)


func destroy():
	var explosion = Explosion.instance()
	explosion.position = position
	foreground_ref.call_deferred("add_child", explosion)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

extends Node2D

const Explosion = preload("res://Scenes/Explosion/Explosion.tscn")

var foreground_ref

export var speed = 300
export var steer_force = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO


func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)


func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
	

func seek():
	var steer = Vector2.ZERO
	var desired = (get_global_mouse_position() - position).normalized() * speed
	steer = (desired - velocity).normalized() * steer_force
	return steer


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_Area2D_body_entered(body):
	var explosion = Explosion.instance()
	explosion.position = position
	foreground_ref.call_deferred("add_child", explosion)
	
	if body.has_method("take_damage"):
		body.take_damage(50)

	queue_free()

extends Node2D

const Explosion = preload("res://Scenes/Explosion/Explosion.tscn")

var foreground_ref

var fire_source = null
var launch_speed = 300
var fall_speed = 700
var velocity = Vector2()

func start(pos, dir, source):
	rotation = dir
	position = pos
	velocity = Vector2(launch_speed, 0).rotated(rotation)
	fire_source = source
	
	
func _physics_process(delta):
	position += velocity * delta
	velocity.y = lerp(velocity.y, fall_speed, delta)
	if dropped_out_of_play():
		queue_free()


func dropped_out_of_play() -> bool:
	return (
		position.x < 0 or
		position.x > get_viewport().size.x or
		position.y > get_viewport().size.y
	)

func _do_damage(node):
	if node.has_method("take_damage"):
		node.take_damage(25)
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

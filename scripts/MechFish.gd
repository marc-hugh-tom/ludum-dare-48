extends KinematicBody2D

export(NodePath) var player_path
var speed = 2.0
var rotation_speed = 1.0

######################################

onready var player = get_node(player_path)
const ExplosionResource = preload("res://Scenes/Explosion/Explosion.tscn")
const ScrapResource = preload("res://nodes/scrap.tscn")
var exploded_bool = false

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var current_dir = Vector2.RIGHT.rotated(rotation)
	var desired_dir = player.position - position
	var desired_rotation = current_dir.angle_to(desired_dir)
	rotation += desired_rotation * rotation_speed * delta
	var collision = move_and_collide(Vector2.RIGHT.rotated(rotation) * speed)
	if collision:
		cause_damage(collision.get_collider())
		explode()

func cause_damage(victim):
	if victim and victim.has_method("take_damage"):
		victim.take_damage(10)
	if victim.has_method("impulse"):
		var direction = ( victim.position - self.position ).normalized()
		victim.impulse(direction * 3)

func explode():
	exploded_bool = true
	var explosion = ExplosionResource.instance()
	explosion.position = position
	get_parent().call_deferred("add_child", explosion)
	queue_free()

func generate_scrap():
	var scrap = ScrapResource.instance()
	scrap.set_position(position)
	get_parent().call_deferred("add_child", scrap)

func take_damage(amount: int = 0):
	if not exploded_bool:
		generate_scrap()
	explode()

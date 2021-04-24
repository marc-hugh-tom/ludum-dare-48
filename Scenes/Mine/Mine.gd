extends "res://Scenes/ScrollingObject/ScrollingObject.gd"

const ExplosionResource = preload("res://Scenes/Explosion/Explosion.tscn")
const ScrapResource = preload("res://nodes/scrap.tscn")

var exploded_bool = false

func _on_Mine_body_entered(body):
	cause_damage(body)
	explode()

func cause_damage(victim):
	if victim and victim.has_method("damage"):
		victim.damage(10)
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

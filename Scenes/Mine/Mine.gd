extends "res://Scenes/ScrollingObject/ScrollingObject.gd"

const ExplosionResource = preload("res://Scenes/Explosion/Explosion.tscn")



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
	print("boom")
	var explosion = ExplosionResource.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	destroy()

func take_damage(amount: int = 0):
	explode()

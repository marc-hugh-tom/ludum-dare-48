extends "res://Scenes/ScrollingObject/ScrollingObject.gd"

const ExplosionResource = preload("res://Scenes/Explosion/Explosion.tscn")


func _on_Mine_body_entered(body):
	explode(body)


func explode(victim):
	print("boom")
	var explosion = ExplosionResource.instance()
	explosion.position = position
	get_owner().add_child(explosion)
	if victim.has_method("damage"):
		victim.damage(10)
	destroy()

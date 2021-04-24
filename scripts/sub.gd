extends Node2D

var bobTimer = 0

func _ready():
	print(bobTimer)
	pass # Replace with function body.

func _physics_process(delta):
	bobTimer += delta
	self.position.y += sin(bobTimer * 2.3) / 7
	self.rotation_degrees += cos(bobTimer * 1.42) / 40

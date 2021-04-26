extends Area2D

onready var position_factors = [rand_range(1.8, 2.5), rand_range(50, 70)]
onready var rotation_factors = [rand_range(1.2, 1.8), rand_range(30, 50)]

var bob_timer = 0.0

signal on_damage

func _physics_process(delta: float):
	bob_timer += delta
	self.rotation_degrees += cos(bob_timer * rotation_factors[0]) / rotation_factors[1]
	self.position.y += cos(bob_timer * position_factors[0]) / position_factors[1]

func is_boss():
	return true

func take_damage(amount):
	emit_signal("on_damage", amount)

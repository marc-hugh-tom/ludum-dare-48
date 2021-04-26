extends Node2D

var update_delay = 0.5
var update_speed = 0.1

############################

onready var global = get_tree().get_root().get_node("GlobalVariables")

onready var current_value = global.get_boss_health()
onready var lag_value = current_value
var update_timer = 0.0

onready var meter = $Meter

func take_damage(amount):
	current_value -= amount
	update_timer = update_delay

func _process(delta):
	if update_timer > 0:
		update_timer -= delta
	if update_timer <= 0:
		lag_value -= (lag_value - current_value) * update_speed
	meter.get_material().set_shader_param("current_value", current_value)
	meter.get_material().set_shader_param("lag_value", lag_value)

func _on_boss_spawner_boss_damage(amount):
	take_damage(amount)

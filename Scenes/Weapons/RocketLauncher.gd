extends Node2D

const AquaRocket = preload("res://Scenes/Weapons/AquaRocket.tscn")
var foreground_ref


func _ready():
	$Timer.stop()


func get_weapon_name():
	return "Aqua Rocket"

func firing(source):
	if $Timer.is_stopped():
		fire(source)

func fire(source):
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var rocket = AquaRocket.instance()
	rocket.start(global_position, get_parent().rotation, source)
	foreground_ref.add_child(rocket)
	rocket.foreground_ref = foreground_ref

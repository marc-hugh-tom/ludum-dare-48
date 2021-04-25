extends Node2D

const Torpedo = preload("res://Scenes/Weapons/Torpedo.tscn")

var foreground_ref


func _ready():
	$Timer.stop()
	

func get_weapon_name():
	return "Torpedo"


func fire_once(source):
	if $Timer.is_stopped():
		fire(source)


func fire(source):
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var torpedo = Torpedo.instance()
	torpedo.foreground_ref = foreground_ref
	torpedo.start(global_position, get_parent().rotation)
	foreground_ref.add_child(torpedo)

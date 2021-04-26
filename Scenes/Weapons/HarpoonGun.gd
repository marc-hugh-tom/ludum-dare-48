extends Node2D

const Harpoon = preload("res://Scenes/Weapons/Harpoon.tscn")
var foreground_ref

func _ready():
	$Timer.stop()


func get_weapon_name():
	return "Harpoons"


func firing(source):
	if $Timer.is_stopped():
		fire(source)


func fire(source):
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var harpoon = Harpoon.instance()
	harpoon.start(global_position, get_parent().rotation, source)
	foreground_ref.add_child(harpoon)

extends Node2D

const Harpoon = preload("res://Scenes/Weapons/Harpoon.tscn")
var foreground_ref

func get_weapon_name():
	return "Harpoons"


func firing():
	if $Timer.is_stopped():
		fire()


func fire():
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var harpoon = Harpoon.instance()
	harpoon.start(global_position, get_parent().rotation)
	foreground_ref.add_child(harpoon)

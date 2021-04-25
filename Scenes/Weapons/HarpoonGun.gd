extends Node2D

const Harpoon = preload("res://Scenes/Weapons/Harpoon.tscn")

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
	get_owner().add_child(harpoon)

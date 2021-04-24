extends Node2D

const Harpoon = preload("res://Scenes/Weapons/Harpoon.tscn")


func firing():
	if $Timer.is_stopped():
		fire()


func fire():
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var harpoon = Harpoon.instance()
	harpoon.start(global_position, get_parent().rotation)
	get_owner().add_child(harpoon)

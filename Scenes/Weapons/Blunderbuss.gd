extends Node2D

const Shrapnel = preload("res://Scenes/Weapons/Shrapnel.tscn")

func get_weapon_name():
	return "Blunderbuss"

func firing(source):
	if $Timer.is_stopped():
		fire(source)


func fire(source):
	print("blunderbuss fire")
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var spread = PI*0.01
	var rotation = get_parent().rotation - spread
	for i in 3:
		var shrapnel = Shrapnel.instance()
		shrapnel.start(global_position, rotation + (i*spread), source)
		get_owner().add_child(shrapnel)

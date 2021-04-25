extends Node2D

const Shrapnel = preload("res://Scenes/Weapons/Shrapnel.tscn")
var foreground_ref

func get_weapon_name():
	return "Blunderbuss"

func firing():
	if $Timer.is_stopped():
		fire()


func fire():
	print("blunderbuss fire")
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var spread = PI*0.01
	var rotation = get_parent().rotation - spread
	for i in 3:
		var shrapnel = Shrapnel.instance()
		shrapnel.start(global_position, rotation + (i*spread))
		foreground_ref.add_child(shrapnel)

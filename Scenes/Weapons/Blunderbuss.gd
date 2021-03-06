extends Node2D

const Shrapnel = preload("res://Scenes/Weapons/Shrapnel.tscn")
var foreground_ref


func _ready():
	$Timer.stop()


func get_weapon_name():
	return "Depth Charges"

func firing(source):
	if $Timer.is_stopped():
		fire(source)


func fire(source):
	$Timer.start()
	$AudioStreamPlayer2D.play()
	var spread = PI*0.05
	var rotation = get_parent().rotation - spread
	for i in 3:
		var shrapnel = Shrapnel.instance()
		shrapnel.start(global_position, rotation + (i*spread), source)
		foreground_ref.add_child(shrapnel)
		shrapnel.foreground_ref = foreground_ref

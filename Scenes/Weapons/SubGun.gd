extends Node2D

const Shell = preload("res://Scenes/Weapons/Shell.tscn")
var foreground_ref
var orig_source

func _ready():
	$Reload.stop()


func get_weapon_name():
	return "Sub Gun"


func firing(source):
	if $Reload.is_stopped():
		fire(source)


func fire(source):
	orig_source = source
	$Reload.start()
	fire_single()
	$DoubleFire.start()


func fire_single():
	$AudioStreamPlayer2D.play()
	var shell = Shell.instance()
	shell.start(global_position, get_parent().rotation, orig_source)
	foreground_ref.add_child(shell)


func _on_DoubleFire_timeout():
	fire_single()

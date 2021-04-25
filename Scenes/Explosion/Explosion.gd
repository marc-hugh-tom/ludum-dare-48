extends Node2D

func emit_explosion_event():
	get_tree().call_group("playstate", "explosion_event", position)

extends Node

const OFFSCREEN_MARGIN = 64
const MIN_SPAWN_SECONDS = 8
const MAX_SPAWN_SECONDS = 16

######################################

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var global = get_tree().get_root().get_node("GlobalVariables")

var mech_fish = preload("res://nodes/MechFish.tscn")

func _ready():
	$Timer.start()

func return_enemy_formation():
	var screen_size = get_viewport().size
	var formations = [
		{
			"enemies": [mech_fish, mech_fish, mech_fish, mech_fish],
			"spawn_positions": [
				Vector2(-OFFSCREEN_MARGIN, -OFFSCREEN_MARGIN),
				Vector2(get_viewport().size.x+OFFSCREEN_MARGIN, -OFFSCREEN_MARGIN),
				Vector2(get_viewport().size.x+OFFSCREEN_MARGIN, get_viewport().size.y+OFFSCREEN_MARGIN),
				Vector2(-OFFSCREEN_MARGIN, get_viewport().size.y+OFFSCREEN_MARGIN)
			]
		}
	]
	return(formations[randi() % len(formations)])

func spawn_enemy_formation():
	var formation = return_enemy_formation()
	for idx in range(len(formation["enemies"])):
		var enemy = formation["enemies"][idx].instance()
		enemy.player = player
		enemy.position = formation["spawn_positions"][idx]
		enemy.current_rotation = enemy.position.angle_to_point(player.position) - PI/2
		get_parent().add_child(enemy)

func _on_Timer_timeout():
	spawn_enemy_formation()
	var wait_time = rand_range(
		MIN_SPAWN_SECONDS,
		lerp(MAX_SPAWN_SECONDS, MIN_SPAWN_SECONDS, global.get_depth() / global.get_max_depth())
	)
	$Timer.wait_time = wait_time
	$Timer.start()

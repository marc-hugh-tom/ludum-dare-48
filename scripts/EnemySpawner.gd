extends Node

const OFFSCREEN_MARGIN = 64
const MIN_SPAWN_SECONDS = 8
const MAX_SPAWN_SECONDS = 16

######################################

export(NodePath) var player_path
onready var player = get_node(player_path)
onready var global = get_tree().get_root().get_node("GlobalVariables")

var mech_fish = preload("res://nodes/MechFish.tscn")
var enemy_sub = preload("res://nodes/enemy_sub_1.tscn")

func _ready():
	pass#$Timer.start()

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

	if global.get_depth() > 1000.0:
		# enemy sub from bottom
		formations.append({
			"enemies": [enemy_sub],
			"spawn_positions": [
				Vector2(rand_range(0, get_viewport().size.x), get_viewport().size.y+OFFSCREEN_MARGIN),
			]
		})
	
	if global.get_depth() > 2000.0:
		# 2 enemy subs from left and right
		formations.append({
			"enemies": [enemy_sub, enemy_sub],
			"spawn_positions": [
				Vector2(-OFFSCREEN_MARGIN, rand_range(0, get_viewport().size.y)),
				Vector2(get_viewport().size.x + OFFSCREEN_MARGIN, rand_range(0, get_viewport().size.y)),
			]
		})
	
	if global.get_depth() > 5000.0:
		# 3 enemy subs from left, right, and bottom
		formations.append({
			"enemies": [enemy_sub, enemy_sub, enemy_sub],
			"spawn_positions": [
				Vector2(rand_range(0, get_viewport().size.x), get_viewport().size.y+OFFSCREEN_MARGIN),
				Vector2(-OFFSCREEN_MARGIN, rand_range(0, get_viewport().size.y)),
				Vector2(get_viewport().size.x + OFFSCREEN_MARGIN, rand_range(0, get_viewport().size.y)),
			]
		})
	
	return(formations[randi() % len(formations)])

func spawn_enemy_formation():
	var formation = return_enemy_formation()
	for idx in range(len(formation["enemies"])):
		var enemy = formation["enemies"][idx].instance()
		enemy.player = player
		enemy.position = formation["spawn_positions"][idx]
		
		if enemy.has_method("init"):
			enemy.init(player)
		
		get_parent().add_child(enemy)

func _on_Timer_timeout():
	spawn_enemy_formation()
	var wait_time = rand_range(
		MIN_SPAWN_SECONDS,
		lerp(MAX_SPAWN_SECONDS, MIN_SPAWN_SECONDS, global.get_depth() / global.get_max_depth())
	)
	$Timer.wait_time = wait_time
	$Timer.start()

func _on_boss_spawn_mechfish(params):
	var position = params[0]
	var enemy = mech_fish.instance()
	enemy.player = player
	enemy.position = position
	enemy.init(player)
	get_parent().add_child(enemy)

func _on_boss_spawn_sub(position):
	var enemy = enemy_sub.instance()
	enemy.player = player
	enemy.position = position
	enemy.init(player)
	get_parent().add_child(enemy)

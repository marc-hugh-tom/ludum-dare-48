extends Node2D

onready var global = get_tree().get_root().get_node("GlobalVariables")

var boss_resource = preload("res://Scenes/Boss/Boss.tscn")

var spawned = false

signal boss_damage

export(NodePath) var player_path = null

onready var player = get_node(player_path)

func _process(delta):
	if global.is_max_depth() and not spawned and len(get_tree().get_nodes_in_group("enemy")) == 0:
		spawned = true
		
		var boss = boss_resource.instance()
		boss.player = player
		boss.position = Vector2(540, 785)
		
		get_parent().add_child(boss)
	
		boss.connect("spawn_mine", get_node("../MineSpawner"), "_on_boss_spawn_mine")
		boss.connect("spawn_mechfish", get_node("../EnemySpawner"), "_on_boss_spawn_mechfish")
		boss.connect("spawn_sub", get_node("../EnemySpawner"), "_on_boss_spawn_sub")
		boss.connect("damage", self, "on_boss_damage")
		boss.connect("explosion", self, "explosion")

func on_boss_damage(amount):
	emit_signal("boss_damage", amount)

const ExplosionResource = preload("res://Scenes/Explosion/Explosion.tscn")

func explosion(position):
	var explosion = ExplosionResource.instance()
	explosion.position = position
	get_parent().call_deferred("add_child", explosion)

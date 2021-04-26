extends Node2D

class_name Boss

const DEBUG = true

const MineResource = preload("res://Scenes/Mine/Mine.tscn")
const mech_fish = preload("res://nodes/MechFish.tscn")
const enemy_sub = preload("res://nodes/enemy_sub_1.tscn")

signal spawn_mine
signal spawn_mechfish
signal spawn_sub

class StateChange:
	enum {
		None,
		Replace
	}
	var type
	var datum

	func _init(type, datum = null):
		self.type = type
		self.datum = datum

	static func none():
		return StateChange.new(None)

	static func replace(datum):
		assert(datum != null)
		return StateChange.new(Replace, datum)
		
class State:
	enum Type {
		Null,
		Spawn,
		Idle,
		
		
		SpawnEnemies,
		DropRightArm,
		RaiseRightArm,
		SpawnRightArmEnemies,
		
		DropLeftArm,
		RaiseLeftArm,
		SpawnLeftArmEnemies,
		
		ShakeBody,
		SpawnBodyEnemies,
	}

	var label: String

	func _init(label: String = "unknown"): self.label = label
	func label(): return label
	func process_state_changes(boss: Boss): return StateChange.none()
	func physics_process(delta: float, boss: Boss): pass
	func on_enter(boss: Boss): pass
	func on_exit(): pass

class StateGraph:
	var state: State = Null.new()
	var label: String

	func _init(boss: Boss, initial_state, label: String):
		self.label = label
		replace_state(boss, initial_state)
	
	func label(): return "%s (%s) (%s)" % [label, state.label()]
	
	func physics_process(delta: float, boss: Boss):
		var state_change = state.process_state_changes(boss)
		handle_state_change(boss, state_change)
		state.physics_process(delta, boss)

	func handle_state_change(boss: Boss, state_change: StateChange):
		match state_change.type:
			StateChange.None: pass
			StateChange.Replace: replace_state(boss, state_change.datum)

	func replace_state(boss: Boss, new_state_type):
		var new_state = boss.state_by_type[new_state_type]
		
		if DEBUG:
			print("%s change state from %s to %s" % [label, state.label(), new_state.label()])
		state.on_exit()
		state = new_state
		new_state.on_enter(boss)

class Null extends State:
	func _init().("null"): pass

class Spawn extends State:
	func _init().("spawn"): pass

	func physics_process(delta: float, boss: Boss):
		boss.position.y = lerp(boss.position.y, boss.get_viewport().size.y - 64, delta)

	func process_state_changes(boss: Boss):
		if boss.position.y - boss.get_viewport().size.y + 64 < 5:
			return StateChange.replace(State.Type.Idle)
		return StateChange.none()

class Idle extends State:
	var idle_frames = 0
	var max_idle_frames = 100
	
	func _init().("idle"): pass

	func on_enter(boss: Boss):
		idle_frames = 0

	func process_state_changes(boss: Boss):
		idle_frames += 1
		if idle_frames >= max_idle_frames:
			return StateChange.replace(State.Type.SpawnEnemies)
		return StateChange.none()

class SpawnEnemies extends State:
	var state_graph = null
	
	func _init().("spawn_enemies"): pass

	func on_enter(boss: Boss):
		if boss.stage == Stage.Type.RightArm:
			state_graph = StateGraph.new(boss, State.Type.DropRightArm, "spawn_enemies")
		if boss.stage == Stage.Type.LeftArm:
			state_graph = StateGraph.new(boss, State.Type.DropLeftArm, "spawn_enemies")
		if boss.stage == Stage.Type.Body:
			state_graph = StateGraph.new(boss, State.Type.ShakeBody, "spawn_enemies")

	func physics_process(delta: float, boss: Boss):
		state_graph.physics_process(delta, boss)

	func process_state_changes(boss: Boss):
		return StateChange.none()

	class DropRightArm extends State:
		var right_arm = null
		var right_arm_size = null
		
		func _init().("drop_right_arm"): pass

		func on_enter(boss: Boss):
			right_arm = boss.get_node("right_arm")
			right_arm_size = right_arm.get_node("Sprite").get_texture().get_size()

		func physics_process(delta: float, boss: Boss):
			right_arm.position.y = lerp(right_arm.position.y, 600, delta)

		func process_state_changes(boss: Boss):
			if right_arm.position.y > 500:
				return StateChange.replace(State.Type.RaiseRightArm)
			return StateChange.none()

	class RaiseRightArm extends State:
		var right_arm = null
		var right_arm_size = null
		
		func _init().("raise_right_arm"): pass

		func on_enter(boss: Boss):
			right_arm = boss.get_node("right_arm")
			right_arm_size = right_arm.get_node("Sprite").get_texture().get_size()

		func physics_process(delta: float, boss: Boss):
			right_arm.position.y = lerp(right_arm.position.y, 0, delta * 3)

		func process_state_changes(boss: Boss):
			if right_arm.position.y < 5:
				return StateChange.replace(State.Type.SpawnRightArmEnemies)
			return StateChange.none()

	class SpawnRightArmEnemies extends State:
		var right_arm_spawn = null
		var right_arm = null
		
		func _init().("spawn_right_arm"): pass

		func on_enter(boss: Boss):
			right_arm_spawn = boss.get_node("right_arm/spawn_position")
			right_arm = boss.get_node("right_arm")

		func physics_process(delta: float, boss: Boss):
			boss.emit_signal("spawn_mine", [right_arm_spawn.global_position, right_arm])

		func process_state_changes(boss: Boss):
			return StateChange.replace(State.Type.Idle)

	class DropLeftArm extends State:
		var right_arm = null
		var right_arm_size = null
		
		func _init().("drop_left_arm"): pass

		func on_enter(boss: Boss):
			right_arm = boss.get_node("left_arm")
			right_arm_size = right_arm.get_node("Sprite").get_texture().get_size()

		func physics_process(delta: float, boss: Boss):
			right_arm.position.y = lerp(right_arm.position.y, 600, delta)

		func process_state_changes(boss: Boss):
			if right_arm.position.y > 500:
				return StateChange.replace(State.Type.RaiseLeftArm)
			return StateChange.none()

	class RaiseLeftArm extends State:
		var left_arm = null
		var left_arm_size = null
		
		func _init().("left_right_arm"): pass

		func on_enter(boss: Boss):
			left_arm = boss.get_node("left_arm")
			left_arm_size = left_arm.get_node("Sprite").get_texture().get_size()

		func physics_process(delta: float, boss: Boss):
			left_arm.position.y = lerp(left_arm.position.y, 0, delta * 3)

		func process_state_changes(boss: Boss):
			if left_arm.position.y < 5:
				return StateChange.replace(State.Type.SpawnLeftArmEnemies)
			return StateChange.none()

	class SpawnLeftArmEnemies extends State:
		var left_arm_spawn = null
		var left_arm = null
		
		func _init().("spawn_left_arm"): pass

		func on_enter(boss: Boss):
			left_arm_spawn = boss.get_node("left_arm/spawn_position")
			left_arm = boss.get_node("left_arm")

		func physics_process(delta: float, boss: Boss):
			boss.emit_signal("spawn_mechfish", [left_arm_spawn.global_position, left_arm])

		func process_state_changes(boss: Boss):
			return StateChange.replace(State.Type.Idle)

	class ShakeBody extends State:
		var frames = 0
		var max_frames = 200
		var body = null
		var shake_delta = 0
		
		func _init().("shake_body"): pass

		func on_enter(boss: Boss):
			frames = 0
			body = boss.get_node("body")

		func process_state_changes(boss: Boss):
			frames += 1
			if frames >= max_frames:
				return StateChange.replace(State.Type.SpawnBodyEnemies)
			return StateChange.none()

		func physics_process(delta: float, boss: Boss):
			if frames > 100:
				shake_delta += delta
				body.position.x += cos(shake_delta * 50) * 5

	class SpawnBodyEnemies extends State:
		var body_spawn = null
		
		func _init().("spawn_body_enemies"): pass

		func on_enter(boss: Boss):
			body_spawn = boss.get_node("body/spawn_position")

		func physics_process(delta: float, boss: Boss):
			boss.emit_signal("spawn_sub", body_spawn.global_position)

		func process_state_changes(boss: Boss):
			return StateChange.replace(State.Type.Idle)

onready var state_by_type: Dictionary = {
	State.Type.Null: Null.new(),
	State.Type.Spawn: Spawn.new(),
	State.Type.Idle: Idle.new(),
	
	
	State.Type.SpawnEnemies: SpawnEnemies.new(),
	State.Type.DropRightArm: SpawnEnemies.DropRightArm.new(),
	State.Type.RaiseRightArm: SpawnEnemies.RaiseRightArm.new(),
	State.Type.SpawnRightArmEnemies: SpawnEnemies.SpawnRightArmEnemies.new(),
	
	State.Type.DropLeftArm: SpawnEnemies.DropLeftArm.new(),
	State.Type.RaiseLeftArm: SpawnEnemies.RaiseLeftArm.new(),
	State.Type.SpawnLeftArmEnemies: SpawnEnemies.SpawnLeftArmEnemies.new(),
	
	State.Type.ShakeBody: SpawnEnemies.ShakeBody.new(),
	State.Type.SpawnBodyEnemies: SpawnEnemies.SpawnBodyEnemies.new(),
}

var state_graph = null

class Stage:
	enum Type {
		RightArm,
		LeftArm,
		Body
	}

var stage = Stage.Type.Body

export(NodePath) var player_path = null
var player = null

func _ready():
	state_graph = StateGraph.new(self, State.Type.Spawn, "root")
	if player_path != null:
		player = get_node(player_path)
		
func _physics_process(delta: float):
	state_graph.physics_process(delta, self)

func on_damage(damage):
	print(damage)


func _on_body_on_damage(amount):
	on_damage(amount)

func _on_left_arm_on_damage(amount):
	on_damage(amount)

func _on_right_arm_on_damage(amount):
	on_damage(amount)

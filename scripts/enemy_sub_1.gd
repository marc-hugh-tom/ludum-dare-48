extends KinematicBody2D

const Harpoon = preload("res://Scenes/Weapons/Harpoon.tscn")
const ExplosionResource = preload("res://Scenes/Explosion/Explosion.tscn")
const ScrapResource = preload("res://nodes/scrap.tscn")

class_name EnemySub

const DEBUG = false
const DISTANCE_SQUARED_TO_TARGET = 250.0 * 250.0
const FIRING_RANGE_SQUARED = 300.0 * 300.0

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
		Bob,
		IdleMovement,
		MoveTowardsPlayer,
		Shoot,
		Reload,
	}

	var label: String

	func _init(label: String = "unknown"): self.label = label
	func label(): return label
	func process_state_changes(sub: EnemySub): return StateChange.none()
	func physics_process(delta: float, sub: EnemySub): pass
	func on_enter(): pass
	func on_exit(): pass

class Null extends State:
	func _init().("null"): pass

class Bob extends State:
	var bob_timer = 0

	func _init().("bob"): pass

	func physics_process(delta: float, sub: EnemySub):
		bob_timer += delta
		sub.rotation_degrees += cos(bob_timer * Constants.BOB_ROTATION_FACTORS[0]) / Constants.BOB_ROTATION_FACTORS[1]
		sub.bob_motion.y += cos(bob_timer * Constants.BOB_POSITION_FACTORS[0]) / Constants.BOB_POSITION_FACTORS[1]
		
	func process_state_changes(sub: EnemySub):
		return StateChange.none()

class Movement:
	class Idle extends State:
		var frames
		const IDLE_FRAMES = 50
		var player = null
		
		func _init(player: Sub).("idle"):
			self.player = player
		
		func on_enter():
			frames = 0
		
		func physics_process(delta: float, sub: EnemySub):
			if sub.motion.y > 0.0:
				sub.motion.y -= Constants.VERTICAL_DECELERATION
				if sub.motion.y < 0.0: sub.motion.y = 0.0
			elif sub.motion.y < 0.0:
				sub.motion.y += Constants.VERTICAL_DECELERATION
				if sub.motion.y > 0.0: sub.motion.y = 0.0
			if sub.motion.x > 0.0:
				sub.motion.x -= Constants.VERTICAL_DECELERATION
				if sub.motion.x < 0.0: sub.motion.x = 0.0
			elif sub.motion.x < 0.0:
				sub.motion.x += Constants.VERTICAL_DECELERATION
				if sub.motion.x > 0.0: sub.motion.x = 0.0

		func process_state_changes(sub: EnemySub):
			frames += 1
			if frames >= IDLE_FRAMES:
				if sub.position.distance_squared_to(self.player.position) >= sub.DISTANCE_SQUARED_TO_TARGET:
					return StateChange.replace(State.Type.MoveTowardsPlayer)
				else:
					frames = 0
			return StateChange.none()

	class TowardsPlayer extends State:
		var player = null
		
		func _init(player: Sub).("towards_player"):
			self.player = player
		
		func physics_process(delta: float, sub: EnemySub):
			var towards_player = (self.player.position - sub.position).normalized()
			sub.motion += towards_player
			
			sub.motion.x = clamp(sub.motion.x, -Constants.MAX_ENEMY_SPEED, Constants.MAX_ENEMY_SPEED)
			sub.motion.y = clamp(sub.motion.y, -Constants.MAX_ENEMY_SPEED, Constants.MAX_ENEMY_SPEED)

		func process_state_changes(sub: EnemySub):
			if sub.position.distance_squared_to(self.player.position) < sub.DISTANCE_SQUARED_TO_TARGET:
				return StateChange.replace(State.Type.IdleMovement)
			return StateChange.none()

class Shoot extends State:
	var player = null
	var has_shot = false
	
	func _init(player: Sub).("shoot"):
		self.player = player

	func on_enter():
		has_shot = false

	func physics_process(delta: float, sub: EnemySub):
		if sub.position.distance_squared_to(self.player.position) < sub.FIRING_RANGE_SQUARED:

			var harpoon = Harpoon.instance()
			harpoon.set_scale(Vector2(0.5, 0.5))
			harpoon.start(sub.position, (player.position + player.motion).angle_to_point(sub.position), sub)
			sub.get_parent().add_child(harpoon)

			has_shot = true

	func process_state_changes(sub: EnemySub):
		if has_shot:
			return StateChange.replace(State.Type.Reload)
		return StateChange.none()

class Reload extends State:
	var frames = 0
	const RELOAD_FRAMES = 100
	
	func _init().("reload"): pass

	func on_enter():
		frames = 0
	
	func process_state_changes(sub: EnemySub):
		frames += 1
		if frames >= RELOAD_FRAMES:
			return StateChange.replace(State.Type.Shoot)
		return StateChange.none()

class StateGraph:
	var state: State = Null.new()
	var label: String

	func _init(sub: EnemySub, initial_state, label: String):
		self.label = label
		replace_state(sub, initial_state)
	
	func label(): return "%s (%s) (%s)" % [label, state.label()]
	
	func physics_process(delta: float, sub: EnemySub):
		var state_change = state.process_state_changes(sub)
		handle_state_change(sub, state_change)
		state.physics_process(delta, sub)

	func handle_state_change(sub: EnemySub, state_change: StateChange):
		match state_change.type:
			StateChange.None: pass
			StateChange.Replace: replace_state(sub, state_change.datum)

	func replace_state(sub: EnemySub, new_state_type):
		var new_state = sub.state_by_type[new_state_type]
		
		if DEBUG:
			print("%s change state from %s to %s" % [label, state.label(), new_state.label()])
		state.on_exit()
		state = new_state
		new_state.on_enter()

class MovementGraph extends StateGraph:
	func _init(sub: EnemySub).(sub, State.Type.MoveTowardsPlayer, "movement"): pass
	
class ShootGraph extends StateGraph:
	func _init(sub: EnemySub).(sub, State.Type.Reload, "shoot"): pass
	
export(NodePath) var player_path = null
var player = null
var motion := Vector2(0.0, 0.0)
var bob_motion := Vector2(0.0, 0.0)

var bob = Bob.new()
var movement_graph = null
var shoot_graph = null

onready var state_by_type: Dictionary = {
	State.Type.Null: Null.new(),
	State.Type.Bob: Bob.new(),
	State.Type.MoveTowardsPlayer: Movement.TowardsPlayer.new(player),
	State.Type.IdleMovement: Movement.Idle.new(player),
	State.Type.Shoot: Shoot.new(player),
	State.Type.Reload: Reload.new(),
}

func _ready():
	if player_path != null:
		player = get_node(player_path)
	
	movement_graph = MovementGraph.new(self)
	shoot_graph = ShootGraph.new(self)

func init(player: Node):
	self.player = player

func _physics_process(delta: float):	
	movement_graph.physics_process(delta, self)
	shoot_graph.physics_process(delta, self)
	bob.physics_process(delta, self)
	
	if $AnimatedSprite.get_animation() == 'l' and player.position.x > self.position.x:
		$AnimationPlayer.play("l_to_r")
	elif $AnimatedSprite.get_animation() == 'r' and player.position.x < self.position.x:
		$AnimationPlayer.play("r_to_l")

	self.position += self.motion
	self.position += self.bob_motion

var health = 50.0
var has_exploded = false

func take_damage(damage):
	$AnimationPlayer.play("damage")
	health -= damage
	if health <= 0.0 and not has_exploded:
		has_exploded = true
		var explosion = ExplosionResource.instance()
		explosion.position = position
		get_parent().call_deferred("add_child", explosion)
		queue_free()

		for i in range(0, 3):
			var scrap = ScrapResource.instance()
			scrap.set_position(Vector2(position.x + rand_range(-20, 20), position.y + rand_range(-20, 20)))
			get_parent().call_deferred("add_child", scrap)

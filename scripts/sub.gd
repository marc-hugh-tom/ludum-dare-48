extends Node2D

class_name Sub

const DEBUG = false

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
		ImpulseDampen,
		
		HorizontalMovementIdle,
		TurnLeft,
		TurnRight,
		MoveLeft,
		MoveRight,
		
		VerticalMovementIdle,
		MoveUp,
		MoveDown,
		Decelerate,
	}

	var label: String

	func _init(label: String = "unknown"): self.label = label
	func label(): return label
	func process_state_changes(sub: Sub): return StateChange.none()
	func physics_process(delta: float, sub: Sub): pass
	func on_enter(): pass
	func on_exit(): pass

class Null extends State:
	func _init().("null"): pass

class Bob extends State:
	var bob_timer = 0

	func _init().("bob"): pass

	func physics_process(delta: float, sub: Sub):
		bob_timer += delta
		sub.rotation_degrees += cos(bob_timer * Constants.BOB_ROTATION_FACTORS[0]) / Constants.BOB_ROTATION_FACTORS[1]
		
	func process_state_changes(sub: Sub):
		return StateChange.none()

class ImpulseDampen extends State:
	func _init().("impulse_dampen"): pass

	func physics_process(delta: float, sub: Sub):
		if sub.impulse_force.y > 0.0:
			sub.impulse_force.y -= Constants.VERTICAL_DECELERATION
			if sub.impulse_force.y < 0.0: sub.impulse_force.y = 0.0
		elif sub.impulse_force.y < 0.0:
			sub.impulse_force.y += Constants.VERTICAL_DECELERATION
			if sub.impulse_force.y > 0.0: sub.impulse_force.y = 0.0

		if sub.impulse_force.x > 0.0:
			sub.impulse_force.x -= Constants.HORIZONTAL_DECELERATION
			if sub.impulse_force.x < 0.0: sub.impulse_force.x = 0.0
		elif sub.impulse_force.x < 0.0:
			sub.impulse_force.x += Constants.HORIZONTAL_DECELERATION
			if sub.impulse_force.x > 0.0: sub.impulse_force.x = 0.0

class VerticalMovement extends State:
	func _init(label: String = "unknown_vertical_state").(label): pass
	
	class Idle extends State:
		var bob_timer = 0

		func _init(label: String = "idle").(label): pass
		
		func on_enter():
			bob_timer = 0

		func physics_process(delta: float, sub: Sub):
			bob_timer += delta
			sub.motion.y += cos(bob_timer * Constants.BOB_POSITION_FACTORS[0]) / Constants.BOB_POSITION_FACTORS[1]

		func process_state_changes(sub: Sub):
			if Input.is_action_pressed("ui_up"):
				return StateChange.replace(State.Type.MoveUp)
			if Input.is_action_pressed("ui_down"):
				return StateChange.replace(State.Type.MoveDown)
			return StateChange.none()
	
	class Decelerate extends Idle:
		func _init(label: String = "decelerate").(label):
			pass

		func physics_process(delta: float, sub: Sub):
			if sub.motion.y > 0.0:
				sub.motion.y -= Constants.VERTICAL_DECELERATION
				if sub.motion.y < 0.0: sub.motion.y = 0.0
			elif sub.motion.y < 0.0:
				sub.motion.y += Constants.VERTICAL_DECELERATION
				if sub.motion.y > 0.0: sub.motion.y = 0.0

		func process_state_changes(sub: Sub):
			if sub.motion.y == 0:
				return StateChange.replace(State.Type.VerticalMovementIdle)
			return StateChange.none()
			
	class MoveUp extends VerticalMovement:
		func _init(label: String = "move_up").(label):
			pass

		func physics_process(delta: float, sub: Sub):
			if sub.motion.y > 0.0:
				sub.motion.y -= Constants.VERTICAL_DECELERATION
				if sub.motion.y < 0.0: sub.motion.y = 0.0
				
			sub.motion.y -= Constants.VERTICAL_ACCELERATION
			sub.motion.y = clamp(sub.motion.y, -Constants.MAX_VERTICAL_SPEED, Constants.MAX_VERTICAL_SPEED)

		func process_state_changes(sub: Sub):
			if not Input.is_action_pressed("ui_up"):
				return StateChange.replace(State.Type.Decelerate)
			return StateChange.none()
			
	class MoveDown extends VerticalMovement:
		func _init(label: String = "move_down").(label):
			pass

		func physics_process(delta: float, sub: Sub):
			if sub.motion.y < 0.0:
				sub.motion.y += Constants.VERTICAL_DECELERATION
				if sub.motion.y > 0.0: sub.motion.y = 0.0
				
			sub.motion.y += Constants.VERTICAL_ACCELERATION
			sub.motion.y = clamp(sub.motion.y, -Constants.MAX_VERTICAL_SPEED, Constants.MAX_VERTICAL_SPEED)

		func process_state_changes(sub: Sub):
			if not Input.is_action_pressed("ui_down"):
				return StateChange.replace(State.Type.Decelerate)
			return StateChange.none()

class HorizontalMovement extends State:
	func _init(label: String = "unknown_horizontal_state").(label): pass
	
	class Idle extends State:
		func _init().("idle"): pass

		func physics_process(delta: float, sub: Sub):
			if sub.motion.x > 0.0:
				sub.motion.x -= Constants.HORIZONTAL_DECELERATION
				if sub.motion.x < 0.0: sub.motion.x = 0.0
			elif sub.motion.x < 0.0:
				sub.motion.x += Constants.HORIZONTAL_DECELERATION
				if sub.motion.x > 0.0: sub.motion.x = 0.0

		func process_state_changes(sub: Sub):
			if Input.is_action_pressed("ui_left"):
				return StateChange.replace(State.Type.MoveLeft)
			if Input.is_action_pressed("ui_right"):
				return StateChange.replace(State.Type.MoveRight)
			return StateChange.none()
			
	class MoveLeft extends HorizontalMovement:
		func _init(label: String = "move_left").(label):
			pass

		func physics_process(delta: float, sub: Sub):
			if sub.motion.x > 0.0:
				sub.motion.x -= Constants.HORIZONTAL_DECELERATION
				if sub.motion.x < 0.0: sub.motion.x = 0.0
				
			sub.motion.x -= Constants.HORIZONTAL_ACCELERATION
			sub.motion.x = clamp(sub.motion.x, -Constants.MAX_HORIZONTAL_SPEED, Constants.MAX_HORIZONTAL_SPEED)

		func process_state_changes(sub: Sub):
			if not Input.is_action_pressed("ui_left"):
				return StateChange.replace(State.Type.HorizontalMovementIdle)
			return StateChange.none()
			
	class MoveRight extends HorizontalMovement:
		func _init(label: String = "move_right").(label):
			pass

		func physics_process(delta: float, sub: Sub):
			if sub.motion.x < 0.0:
				sub.motion.x += Constants.HORIZONTAL_DECELERATION
				if sub.motion.x > 0.0: sub.motion.x = 0.0
				
			sub.motion.x += Constants.HORIZONTAL_ACCELERATION
			sub.motion.x = clamp(sub.motion.x, -Constants.MAX_HORIZONTAL_SPEED, Constants.MAX_HORIZONTAL_SPEED)

		func process_state_changes(sub: Sub):
			if not Input.is_action_pressed("ui_right"):
				return StateChange.replace(State.Type.HorizontalMovementIdle)
			return StateChange.none()

	class TurnLeft extends HorizontalMovement:
		func _init(label: String = "turn_left").(label):
			pass

	class TurnRight extends HorizontalMovement:
		func _init(label: String = "turn_right").(label):
			pass

var state_by_type: Dictionary = {
	State.Type.Null: Null.new(),
	State.Type.Bob: Bob.new(),
	
	State.Type.HorizontalMovementIdle: HorizontalMovement.Idle.new(),
	State.Type.MoveLeft: HorizontalMovement.MoveLeft.new(),
	State.Type.MoveRight: HorizontalMovement.MoveRight.new(),
	State.Type.TurnLeft: HorizontalMovement.TurnLeft.new(),
	State.Type.TurnRight: HorizontalMovement.TurnRight.new(),
	
	State.Type.VerticalMovementIdle: VerticalMovement.Idle.new(),
	State.Type.MoveUp: VerticalMovement.MoveUp.new(),
	State.Type.MoveDown: VerticalMovement.MoveDown.new(),
	State.Type.Decelerate: VerticalMovement.Decelerate.new(),
}

onready var state = state_by_type[State.Type.Null]

class StateGraph:
	var state: State = Null.new()
	var label: String

	func _init(sub: Sub, initial_state, label: String):
		self.label = label
		replace_state(sub, initial_state)
	
	func label(): return "%s (%s) (%s)" % [label, state.label()]
	
	func physics_process(delta: float, sub: Sub):
		var state_change = state.process_state_changes(sub)
		handle_state_change(sub, state_change)
		state.physics_process(delta, sub)

	func handle_state_change(sub: Sub, state_change: StateChange):
		match state_change.type:
			StateChange.None: pass
			StateChange.Replace: replace_state(sub, state_change.datum)

	func replace_state(sub: Sub, new_state_type):
		var new_state = sub.state_by_type[new_state_type]
		
		if DEBUG:
			print("%s change state from %s to %s" % [label, state.label(), new_state.label()])
		state.on_exit()
		state = new_state
		new_state.on_enter()

class VerticalMovementGraph extends StateGraph:
	func _init(sub: Sub).(sub, State.Type.VerticalMovementIdle, "vertical_movement"): pass

class HorizontalMovementGraph extends StateGraph:
	func _init(sub: Sub).(sub, State.Type.HorizontalMovementIdle, "horizontal_movement"): pass

var vertical_movement_graph = null
var horizontal_movement_graph = null
var bob = state_by_type[State.Type.Bob]
var impulse_dampen = ImpulseDampen.new()

var motion := Vector2(0.0, 0.0)
var impulse_force := Vector2(0.0, 0.0)

var health = 100.0
signal damage_taken

func _ready():
	self.vertical_movement_graph = VerticalMovementGraph.new(self)
	self.horizontal_movement_graph = HorizontalMovementGraph.new(self)

func _physics_process(delta: float):
	vertical_movement_graph.physics_process(delta, self)
	horizontal_movement_graph.physics_process(delta, self)
	bob.physics_process(delta, self)
	impulse_dampen.physics_process(delta, self)
	if $AnimatedSprite.get_animation() == 'l' and self.motion.x < 0:
		$AnimationPlayer.play("flip_l_r")
	elif $AnimatedSprite.get_animation() == 'r' and self.motion.x > 0:
		$AnimationPlayer.play("flip_r_l")
	self.position += self.motion
	self.position += self.impulse_force

func impulse(force: Vector2):
	self.impulse_force = force

func take_damage(amount):
	health -= amount
	emit_signal("damage_taken", amount)

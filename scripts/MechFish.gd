extends KinematicBody2D

var speed = 2.0
var rotation_speed = 1.5
var ref_vec = Vector2.UP
var collision_shape_starting_pos = Vector2(0, 30)
var particles_starting_pos = Vector2(0, 60)

######################################

var player
const ExplosionResource = preload("res://Scenes/Explosion/Explosion.tscn")
const ScrapResource = preload("res://nodes/scrap.tscn")
var exploded_bool = false
var current_rotation = 0

func _ready():
	pass # Replace with function body.

func is_mech_fish():
	return(true)

func _physics_process(delta):
	var current_dir = ref_vec.rotated(current_rotation)
	var desired_dir = player.position - position
	var desired_rotation = current_dir.angle_to(desired_dir)
	current_rotation += desired_rotation * rotation_speed * delta
	manage_rotation_animation()
	var velocity = move_and_slide(ref_vec.rotated(current_rotation) * speed)
	position += velocity
	var slide_count = get_slide_count()
	if slide_count:
		for idx in range(slide_count):
			var collision = get_slide_collision(slide_count - 1)
			var collider = collision.collider
			if not collider.has_method("is_mech_fish"):
				cause_damage(collider)
				explode()

func manage_rotation_animation():
	while current_rotation < 0:
		current_rotation += PI*2
	while current_rotation > PI*2:
		current_rotation -= PI*2
	var frame_idx = int((current_rotation*32) / (2*PI))
	var remainder = fmod(current_rotation*32, 2*PI)
	$AnimatedSprite.set_rotation(remainder/32)
	$AnimatedSprite.set_frame(frame_idx)
	$CollisionShape2D.set_rotation(current_rotation)
	$CollisionShape2D.set_position(collision_shape_starting_pos.rotated(current_rotation))
	if has_node("Particles2D"):
		$Particles2D.set_rotation(current_rotation)
		$Particles2D.set_position(particles_starting_pos.rotated(current_rotation))

func cause_damage(victim):
	if victim and victim.has_method("take_damage"):
		victim.take_damage(10)
	if victim.has_method("impulse"):
		var direction = ( victim.position - self.position ).normalized()
		victim.impulse(direction * 3)

func explode():
	exploded_bool = true
	var explosion = ExplosionResource.instance()
	explosion.position = position
	get_parent().call_deferred("add_child", explosion)
	reparent_particles()
	queue_free()

func reparent_particles():
	if has_node("Particles2D"):
		var timer = Timer.new()
		var particles = $Particles2D
		timer.wait_time = particles.lifetime
		timer.autostart = true
		timer.connect("timeout", particles, "queue_free")
		particles.add_child(timer)
		remove_child(particles)
		get_parent().call_deferred("add_child", particles)

func generate_scrap():
	var scrap = ScrapResource.instance()
	scrap.set_position(position)
	get_parent().call_deferred("add_child", scrap)

func take_damage(amount: int = 0):
	if not exploded_bool:
		generate_scrap()
	explode()

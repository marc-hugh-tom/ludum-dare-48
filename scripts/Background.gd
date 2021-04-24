extends Node2D

# Control how fast the colour changes based on depth (lower is faster)
const depth_cutoff = 1000
# The list of colours you transition from
var colour_array = [
	Color("bfd2d9"),
	Color("86abc2"),
	Color("4e7fa2"),
	Color("004868"),
	Color("0f2a47"),
	Color("090d25")
]
# List of background things to spawn
var debris_array = [
	preload("res://assets/background/fish_silhouette.png")
]
# Max parallax number layers
var max_parallax = 3
# Initial debris spawn simulation
var debris_init_spawn_time = 30

##############################

onready var global = get_tree().get_root().get_node("GlobalVariables")
var debris_preload = preload("res://nodes/Debris.tscn")

func _ready():
	var _return = $DebrisTimer.connect("timeout", self, "spawn_debris")
	init_spawn_debris()

func _process(delta):
	var depth = global.get_depth()
	var colour_idx = floor(depth / depth_cutoff)
	var t = fmod(depth, depth_cutoff) / depth_cutoff
	# If we've reached the bottom, cap the colour to the final colour
	if colour_idx + 1 >= len(colour_array):
		colour_idx = len(colour_array) - 2
		t = 1.0
	var colour = colour_array[colour_idx].linear_interpolate(
		colour_array[colour_idx+1], t)
	set_shader_colour(colour)

func set_shader_colour(colour):
	$Background.get_material().set_shader_param("base_colour", colour)

func spawn_debris():
	var debris = debris_preload.instance()
	debris.set_texture(debris_array[randi() % len(debris_array)])
	var parallax_layer = 1 + (randi() % max_parallax)
	debris.set_parallax_modifier(parallax_layer)
	get_node("ParallaxLayer" + str(parallax_layer)).add_child(debris)
	return(debris)

func init_spawn_debris():
	for idx in range((debris_init_spawn_time / $DebrisTimer.wait_time)):
		var debris = spawn_debris()
		debris.update_position(idx * $DebrisTimer.wait_time)

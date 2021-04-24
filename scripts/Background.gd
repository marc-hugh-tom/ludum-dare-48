extends Node2D

# Control how fast the colour changes based on depth
const depth_cutoff = 100
# The list of colours you transition from
var colour_array = [
	Color("bfd2d9"),
	Color("86abc2"),
	Color("4e7fa2"),
	Color("004868"),
	Color("0f2a47"),
	Color("090d25")
]

onready var global = get_tree().get_root().get_node("GlobalVariables")

func _ready():
	pass

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
	
	# DEVEL - Increments the depth
	global.set_depth(depth + global.get_scroll_vector().y * delta)

func set_shader_colour(colour):
	get_material().set_shader_param("base_colour", colour)

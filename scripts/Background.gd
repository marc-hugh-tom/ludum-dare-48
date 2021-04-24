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
# Max parallax number layers
var max_parallax = 3

##############################

onready var global = get_tree().get_root().get_node("GlobalVariables")

func _ready():
	pass

func _process(delta):
	var mat = $Background.get_material()
	var depth = global.get_depth()
	var colour_idx = floor(depth / depth_cutoff)
	var t = fmod(depth, depth_cutoff) / depth_cutoff
	mat.set_shader_param("noise_scroll_value", t)
	# If we've reached the bottom, cap the colour to the final colour
	if colour_idx + 1 >= len(colour_array):
		colour_idx = len(colour_array) - 2
		t = 1.0
	var colour = colour_array[colour_idx].linear_interpolate(
		colour_array[colour_idx+1], t)
	mat.set_shader_param("base_colour", colour)

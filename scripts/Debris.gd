extends Sprite

var parallax_modifier = 1.0

##############################

onready var global = get_tree().get_root().get_node("GlobalVariables")

func _ready():
	var screen_size = get_viewport().get_size()
	position = Vector2(rand_range(0.0, screen_size.x), screen_size.y + 50)
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")

func set_parallax_modifier(input_float):
	parallax_modifier = input_float
	scale = Vector2(1.0 / parallax_modifier, 1.0 / parallax_modifier)

func _process(delta):
	update_position(delta)

func update_position(delta):
	position += delta * global.get_scroll_vector() / parallax_modifier

extends Node2D

signal quit
signal restart

onready var global = get_tree().get_root().get_node("GlobalVariables")

var explosion_array = []

func _ready():
	global.set_depth(0.0)
	randomize()

func _process(delta):
	if Input.is_action_just_pressed("shop"):
		get_tree().paused = true
		$Shop.arsenal = $ViewportContainer/Viewport/Foreground/sub.get_node("Arsenal")
		$Shop.show()
	update_explosions(delta)

func _on_Shop_close():
	get_tree().paused = false
	$Shop.hide()

func explosion_event(explosion_pos):
	explosion_array.append({
		'pos': explosion_pos,
		't': 0.0
	})

func update_explosions(delta):
	var screen_size = get_viewport_rect().size
	var new_array = []
	for explosion in explosion_array:
		explosion['t'] += delta
		if explosion['t'] < 1.0:
			new_array.append(explosion)
	if len(new_array) > 0:
		var data_image = Image.new()
		data_image.create(1, len(new_array), false, Image.FORMAT_RGBA8)
		data_image.lock()
		for i in range(len(new_array)):
			data_image.set_pixel(0, i,
				Color(
					new_array[i]['pos'].x / screen_size.x,
					1.0-new_array[i]['pos'].y / screen_size.y,
					new_array[i]['t']
				)
			)
		data_image.unlock()
		var texture = ImageTexture.new()
		texture.create_from_image(data_image, 0)
		$PostProcessing.get_material().set_shader_param("no_explosion", false)
		$PostProcessing.get_material().set_shader_param("data_texture", texture)
	else:
		$PostProcessing.get_material().set_shader_param("no_explosion", true)
	explosion_array = new_array

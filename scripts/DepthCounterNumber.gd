extends Sprite

func set_value(input_value):
	get_material().set_shader_param("current_value", input_value)

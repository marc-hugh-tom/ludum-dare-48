shader_type canvas_item;

uniform vec4 base_colour : hint_color;
uniform float gradient_factor : hint_range(0.0, 1.0);

void fragment() {
	float modifier = UV.y * gradient_factor;
	
	COLOR = vec4(
		base_colour.r-modifier,
		base_colour.g-modifier,
		base_colour.b-modifier,
		1.0
	);
}

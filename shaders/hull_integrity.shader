shader_type canvas_item;

uniform vec4 full_colour : hint_color;
uniform vec4 damage_colour : hint_color;
uniform vec4 empty_colour : hint_color;
uniform float lag_value : hint_range(0.0, 100.0);
uniform float current_value : hint_range(0.0, 100.0);

void fragment() {
	vec4 base_colour = texture(TEXTURE, UV);
	if (UV.x > lag_value / 100.0) {
		COLOR = empty_colour * base_colour;
	} else if (UV.x > current_value / 100.0) {
		COLOR = damage_colour * base_colour;
	} else {
		COLOR = full_colour * base_colour;
	}
	
}

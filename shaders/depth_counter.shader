shader_type canvas_item;

uniform sampler2D numbers;
uniform float current_value : hint_range(0.0, 10.0);

void fragment() {
	float y = UV.y/10.0 + current_value/10.0;
	if (y > 1.0) {
		y -= 1.0;
	}
	vec2 sample_uv = vec2(UV.x, y);
	
	vec4 number = texture(numbers, sample_uv);
	
	COLOR = number;
}

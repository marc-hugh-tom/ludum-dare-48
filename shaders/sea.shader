shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float noise_scroll_value : hint_range(0.0, 1.0);
uniform float noise_visibility : hint_range(0.0, 1.0);

uniform vec4 base_colour : hint_color;
uniform float gradient_factor : hint_range(0.0, 1.0);

void fragment() {
	vec4 noise = vec4(1.0, 1.0, 1.0, 1.0);

	// first parallax layer
	float noise_y = noise_scroll_value + UV.y;
	while (noise_y > 1.0) {
		noise_y -= 1.0;
	}
	vec2 noise_uv = vec2(UV.x, noise_y);
	noise = noise * texture(noise_texture, noise_uv);
	// second parallax layer
	noise_y = noise_scroll_value*2.0 + UV.y;
	while (noise_y > 1.0) {
		noise_y -= 1.0;
	}
	noise_uv = vec2(1.0-UV.x, noise_y);
	noise = noise * texture(noise_texture, noise_uv);

	float modifier = (UV.y * gradient_factor);
	
	COLOR = vec4(
		base_colour.r-modifier,
		base_colour.g-modifier,
		base_colour.b-modifier,
		1.0
	) + (noise.r * noise_visibility);
}

shader_type canvas_item;

uniform sampler2D viewport_texture;
uniform sampler2D data_texture;
uniform bool no_explosion;

const float force = 0.5;
const float blur = 30.0;
const float ring_size = 50.0;
const float max_size = 200.0;

void fragment() {
	vec2 corrected_uv = vec2(UV.x, 1.0-UV.y);
	vec2 resolution = vec2(textureSize(viewport_texture, 0));
	
	ivec2 data_size = textureSize(data_texture, 0);
	
	vec2 disp = vec2(0.0, 0.0);
	if (!no_explosion) {
		float mask = 0.0;
		for (int i = 0; i < data_size.y; i++) {
			vec4 explosion = texture(data_texture, vec2(0.5, float(i)/float(data_size.y)));
			vec2 center = vec2(explosion.r, explosion.g) * resolution;
			float size = explosion.b * max_size;
			float mod_ring_size = (1.0-explosion.b) * ring_size;
			
			mask = ((1.0 - smoothstep(size-blur, size, length(corrected_uv*resolution - center))) *
				smoothstep(size-blur-mod_ring_size, size-mod_ring_size, length(corrected_uv*resolution - center)));
			disp = disp + normalize(corrected_uv*resolution - center) * force * mask;
		}
	}
	COLOR = texture(viewport_texture, corrected_uv - disp);
}

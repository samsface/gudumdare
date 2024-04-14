shader_type canvas_item;

uniform float ttl : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_texture;

void fragment() {
	vec2 uv = UV;
	uv += (texture(noise_texture, mod(UV + TIME, vec2(1.0))).r * 2.0 - 1.0) * 0.02;

	float d1 = 1.0 - round(distance(uv, vec2(0.5, 0.5)) + 0.55 - ttl * 0.5);
	float d2 = 1.0 - round(distance(uv, vec2(0.5, 0.5)) + 0.50 - ttl * 0.5);

	COLOR = vec4(1.0, 0.0, 0.0, d2 - d1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

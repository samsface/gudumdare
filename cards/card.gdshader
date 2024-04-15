shader_type spatial;
render_mode unshaded;

uniform sampler2D TEXTURE;
uniform sampler2D noise_texture;
instance uniform float mana : hint_range(0.0, 1.0);
instance uniform vec3 modulate : source_color;
instance uniform float rand : hint_range(0.0, 1.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	ALPHA = color.a;
	ALBEDO = color.rgb * COLOR.rgb * modulate;

	vec2 uv = UV;
	uv += texture(noise_texture, UV + vec2(0, TIME + rand)).r * 0.1;

	float m = clamp(round(uv.y - (1.0 - mana) + 0.5), 0.0, 1.0);

	ALBEDO = mix(ALBEDO * 0.2, ALBEDO, m);

	ROUGHNESS = 0.0;
	METALLIC = 1.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform float clockwise_value : hint_range(0.0, 1.0); // Range from 0 to 1
uniform sampler2D noise;

void fragment() {
	vec2 uv = UV;

	float cv = floor(clockwise_value * 16.0) / 16.0;

	uv += (texture(noise, mod(UV + cv, vec2(1.0, 1.0))).r * 2.0 - 1.0) * 0.02;

    // Convert the UV coordinates to a center-relative space
    vec2 center = vec2(0.5, 0.5);
    vec2 uv_centered = uv - center;



    // Calculate the angle between the UV point and the positive x-axis
    float angle = atan(uv_centered.y, uv_centered.x);


    if (angle < 0.0)
        angle += 2.0 * PI;

    // Calculate the normalized clockwise value
    float normalized_value = cv;

    // Determine if the fragment should be colored or not based on the angle
    if (angle <= normalized_value * 2.0 * PI && distance(uv, center) < 0.5) {
        // Fill color if the angle is within the clockwise_value
        // You can change this color as needed


    } else {
        // No fill color if the angle is outside the clockwise_value
	   discard;
    }

}

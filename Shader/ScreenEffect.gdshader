shader_type canvas_item;

uniform vec4 edge_color : source_color = vec4(1.0, 0.0, 0.0, 0.2); // Very low-opacity red
uniform float edge_strength : hint_range(0.0, 1.0) = 0.5;
uniform float fade_distance : hint_range(0.0, 1.0) = 0.25;

void fragment() {
	vec2 uv = UV;

	float edge_dist = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));

	float fade = 1.0 - smoothstep(0.0, fade_distance, edge_dist);

	COLOR = vec4(edge_color.rgb, edge_color.a * fade * edge_strength);
}

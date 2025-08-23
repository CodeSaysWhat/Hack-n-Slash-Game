shader_type canvas_item;

uniform bool switch_color = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (switch_color) {
        float blue = tex_color.b;
        float red = tex_color.r;
        float green = tex_color.g;

        float blue_strength = blue - max(red, green); // how "pure" the blue is

        if (blue_strength > 0.2) {
            // Calculate brightness of blue pixel
            float brightness = (red + green + blue) / 3.0;

            // Use brightness to pick red shade
            if (brightness > 0.5) {
                tex_color.rgb = vec3(1.0, 0.0, 0.0); // Red
            } else {
                tex_color.rgb = vec3(0.6, 0.1, 0.1); // Dark red
            }
        }
    }
    COLOR = tex_color;
}

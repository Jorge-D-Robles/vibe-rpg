shader_type canvas_item;

uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_tex : hint_default_white;
uniform vec4 edge_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float edge_width : hint_range(0.0, 0.2) = 0.05;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    float noise = texture(noise_tex, UV).r;

    if (noise < dissolve_amount) {
        discard;
    } else if (noise < dissolve_amount + edge_width) {
        COLOR = edge_color;
    } else {
        COLOR = col;
    }
}

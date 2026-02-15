shader_type canvas_item;

uniform vec4 water_color : source_color = vec4(0.1, 0.3, 0.8, 0.6);
uniform float wave_speed : hint_range(0.0, 5.0) = 1.5;
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.02;
uniform float wave_frequency : hint_range(0.0, 20.0) = 8.0;

void fragment() {
    vec2 uv = UV;
    uv.x += sin(uv.y * wave_frequency + TIME * wave_speed) * wave_amplitude;
    uv.y += cos(uv.x * wave_frequency + TIME * wave_speed * 0.7) * wave_amplitude * 0.5;

    vec4 col = texture(TEXTURE, uv);
    COLOR = mix(col, water_color, water_color.a);
}
